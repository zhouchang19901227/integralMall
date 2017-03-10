package com.hk.integralMall.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.hk.integralMall.ConfigurationFields;
import com.hk.integralMall.mapper.integral.IntegralConsumptionMapper;
import com.hk.integralMall.mapper.integral.IntegralPreConsumptionMapper;
import com.hk.integralMall.mapper.integral.IntegralUserMapper;
import com.hk.integralMall.model.integral.IntegralConsumption;
import com.hk.integralMall.model.integral.IntegralPreConsumption;
import com.hk.integralMall.model.integral.IntegralUser;
import com.hk.integralMall.utils.CommonUtils;
import com.hk.integralMall.utils.SignEncryption;
import com.hk.integralMall.vo.CreditConsumeParams;
import com.hk.integralMall.vo.ExchangeResultParams;
import com.hk.integralMall.vo.IntegralResponse;

/**
 * 
 * @author jiangjianbin 
 * 创建日期:2016年10月18日 下午2:41:29 
 * 积分商城duiba服务层
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class IntegralService2DuibaImpl {

	/**
	 * @Fields integralUser : 用户积分
	 */
	@Autowired
	private IntegralUserMapper integralUser;

	/**
	 * @Fields preConsumption : 用户预消费积分记录
	 */
	@Autowired
	private IntegralPreConsumptionMapper integralPreConsumption;

	/**
	 * @Fields preConsumption : 用户消费积分记录
	 */
	@Autowired
	private IntegralConsumptionMapper  integralConsumption;
	
	
	/**
	 * duiba发送请求扣积分
	 */
	public IntegralResponse consumIntegral(CreditConsumeParams integralPreConsumptionParam) {
		// 返回给积分商城的参数值
		IntegralResponse response = new IntegralResponse();
		
		try {
			// 根据用户id查询用户总积分
			IntegralUser userIntegral = integralUser.selectByUserId(integralPreConsumptionParam.getUid());

			int totalScore = userIntegral.getTotalscore();
			int cousumScore = integralPreConsumptionParam.getCredits();
		    
			if (totalScore < cousumScore) {
				response.setStatus("fail");
				response.setErrorMessage("积分不足");
				response.setCredits(totalScore);
				return response;
			}
			
			IntegralPreConsumption preConsumption = new IntegralPreConsumption();
			preConsumption.setUserid(integralPreConsumptionParam.getUid());
			preConsumption.setOrderid(integralPreConsumptionParam.getOrderNum());
			preConsumption.setInstructions(integralPreConsumptionParam.getType());
			preConsumption.setScore(integralPreConsumptionParam.getCredits());
			//欲扣除，兑吧处理状态为2:未处理
			preConsumption.setResultstatus(2);
			// 返回插入的记录条数
			integralPreConsumption.insertPreConsumIntegral(preConsumption);
			response.setBizId(integralPreConsumptionParam.getOrderNum());
			response.setCredits(totalScore - cousumScore);
		} catch (Exception e) {
			response.setErrorMessage("fail");
			response.setErrorMessage("扣分失败");
			return response;
		}
		return response;
	}
	
	
	
    /**
     * 兌換結果通知
     */
	public String exchangeResultInform(ExchangeResultParams param) {
		// 返回给积分商城的参数值
	    IntegralResponse response = new IntegralResponse();
	    response.setStatus("ok");
	    try {
	    	Map<String,Object>  params = new HashMap<String,Object>();
			params.put("orderId", param.getOrderNum());
			//是否已结单(0未结单，1已结单)
			params.put("isStatement", true);
			//兑吧处理状态(0失败1成功2，未处理)
			params.put("resultStatus", param.getSuccess());
			
			//更新欲扣积分记录表状态，isStatement改为已结单1，resultStatus兑吧兑换结果成功1失败0
			integralPreConsumption.updateByOrderId(params);
			IntegralPreConsumption integralPreConsum = integralPreConsumption.selectByOrderId(param.getOrderNum());
			if(null == integralPreConsum || integralPreConsum.getResultstatus()!=1){
				return response.getStatus();
			}
			//判断是否已经扣除积分
			IntegralConsumption resultOrderId = integralConsumption.selectByOrderId(integralPreConsum.getOrderid());
			if(null == resultOrderId){
				IntegralConsumption integralConsum = new IntegralConsumption();
				integralConsum.setUserid(integralPreConsum.getUserid());
				integralConsum.setPresumpid(integralPreConsum.getId());
				integralConsum.setOrderid(integralPreConsum.getOrderid());
				integralConsum.setInstructions(integralPreConsum.getInstructions());
				integralConsum.setScore(integralPreConsum.getScore());
				//积分消费表记录添加
				integralConsumption.insert(integralConsum);
				//修改用户表中的总积分值
				integralUser.updateByUserId(integralPreConsum.getUserid(), integralPreConsum.getScore());
			}
		} catch (Exception e) {
			return "fail";
		}
		return response.getStatus();
	}
	
	
	/**
	 * 生成免登陆的url
	 * @param uid
	 * @param redirect
	 * @return
	 */
	public String buildLoginUrl(String uid,String userName,String telPhone,String yikeCode,String redirect){
		String coverUrl = null;
		
		try {
			Map<String,Object> params = new HashMap<String,Object>();
			// 根据用户id查询用户总积分
			IntegralUser userIntegral = integralUser.selectByUserId(uid);
			if(null == userIntegral)
				integralUser.insertSelective(new IntegralUser(uid,userName,telPhone,yikeCode,CommonUtils.getFailureTime()));
			
			//置入参数
			params.put("appKey", ConfigurationFields.APP_DuiBa_KEY);
			params.put("appSecret", ConfigurationFields.APPSECRET);
			params.put("uid", uid);
			params.put("credits",null ==  userIntegral ? 0: userIntegral.getTotalscore());
			params.put("timestamp",System.currentTimeMillis());
			
			//跳转指定页面参数
			if(!StringUtils.isEmpty(redirect))
				params.put("redirect",redirect);
			
			//用户ID Token
			Map<String,Object> idToken = new HashMap<String,Object>();
			idToken.put("app_yk_key", ConfigurationFields.APP_YK_KEY);
			idToken.put("uid", uid);
			
			int status = integralUser.selectByUserIdForSignIn(uid);
			String dcustom = "status=".concat(status +"&btnText=").concat(ConfigurationFields.BET_TEXT)
			.concat("&token=" + SignEncryption.sign(idToken));
			params.put("dcustom",dcustom);
			
			coverUrl = ConfigurationFields.DUIBA_AutoLoginUrl.concat(SignEncryption.buildUrlWithSign(params));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return coverUrl;
	}
}
