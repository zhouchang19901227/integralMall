package com.hk.integralMall.service;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.hk.integralMall.ConfigurationFields;
import com.hk.integralMall.mapper.integral.IntegralAcquireMapper;
import com.hk.integralMall.mapper.integral.IntegralConsumptionMapper;
import com.hk.integralMall.mapper.integral.IntegralInviteMapper;
import com.hk.integralMall.mapper.integral.IntegralUserMapper;
import com.hk.integralMall.model.integral.IntegralInvite;
import com.hk.integralMall.model.integral.IntegralUser;
import com.hk.integralMall.utils.CommonUtils;
import com.hk.integralMall.utils.ServiceProxy;
import com.hk.integralMall.utils.SignEncryption;
import com.hk.integralMall.vo.IntegralConsumptionVO;
import com.hk.integralMall.vo.RegisteVo;
import com.hk.integralMall.vo.SimpleWrap;

/** 
* @ClassName: IntegralServiceImpl 
* @author bushuai
* @Description: 积分商城签到服务层
* @date 2016年10月17日 上午11:06:56 
*/
@Service
public class IntegralServiceImpl {
	
	/** 
	* @Fields integralAcquire : 积分获取
	*/
	@Autowired
	private IntegralAcquireMapper integralAcquire;
	
	/** 
	* @Fields integralUser : 用户积分
	*/
	@Autowired
	private IntegralUserMapper integralUser;
	
	/** 
	* @Fields integralInvite : 分享邀请
	*/
	@Autowired
	private IntegralInviteMapper integralInvite;
	
	/** 
	* @Fields integralConsumption : 积分消耗表
	*/
	@Autowired
	private IntegralConsumptionMapper integralConsumption;
	
	/** 
	* @Fields serviceProxy : 请求代理
	*/
	@Autowired
	private ServiceProxy serviceProxy;
	/** 
	* @Title: queryPastCalendar 
	* @Description: 查询签到日历
	* @param userId
	* @return  
	*/
	public SimpleWrap queryPastCalendar(String userId,String month){
		SimpleWrap wraps = new SimpleWrap();
		try{
			String pastDates = integralAcquire.selectByAcquireType(userId,1,month);
			wraps.setRowData(pastDates);
		}catch(Exception e){
			wraps.setMsgCode("EX1000");
			wraps.setMsgContext("queryPastCalendar" + e.getMessage());
		}
		return wraps;
	}
	

	
	/** 
	* @Title: queryIntegralRecords 
	* @Description: 查询积分记录
	* @param userId
	* @param page
	* @param rows
	* @return  
	*/
	public SimpleWrap queryIntegralRecords(String userId, int page,
			int rows) {
		SimpleWrap wraps = new SimpleWrap();
		try{
			PageHelper.startPage(page, rows);
			List<IntegralConsumptionVO> consumptions = integralConsumption.selectHisRecodesByUserId(userId);
			PageInfo<IntegralConsumptionVO> paging = new PageInfo<IntegralConsumptionVO>(consumptions);
			wraps.setRowData(paging.getList());
		}catch(Exception e){
			wraps.setMsgCode("EX1001");
			wraps.setMsgContext("queryIntegralRecords" + e.getMessage());
		}
		return wraps;
	}
	
	
	/** 
	* @Title: userPastOperation 
	* @Description: 用户签到操作
	* @param userId
	* @return  
	*/
	@Transactional(rollbackFor=Exception.class)
	public Map<String,Object> userPastOperation(String userId,String token){
		/*输入输出参数源*/
		Map<String,Object> inOut = new HashMap<String,Object>();
		/*加密参数*/
		Map<String,Object> encry = new HashMap<String,Object>();
		try{
			inOut.put("uid", userId);
			inOut.put("app_yk_key", ConfigurationFields.APP_YK_KEY);
			
			if(!SignEncryption.sign(inOut).equals(token)){
				inOut.put("errMsg","EX1002(非法请求!!!)");
				return inOut;
			}
			
			inOut.remove("app_yk_key");
			integralUser.execSingedProcess(inOut);
			/*初始化加密数据*/
			encry.put("credits",inOut.get("credits").toString());
			encry.put("uid",userId);
			encry.put("timestamp",System.currentTimeMillis());
			/*加密后置入响应参数*/
			inOut.put("sign", SignEncryption.sign(encry));
		}catch(Exception e){
			inOut.put("errMsg","EX1002");
		}
		return inOut;
	} 
	
	
	/** 
	* @Title: shareInviteFirend 
	* @Description: 分享邀请好友
	* @param userId
	* @return  
	*/
	@Transactional(rollbackFor=Exception.class)
	public SimpleWrap shareInviteFirend(String userId,String inviteUA){
		SimpleWrap wraps = new SimpleWrap();
		try{
			//查询是否分享过
			IntegralInvite inviteShare = integralInvite.selectIsShareByUserId(userId);
			
			String inviteCode = CommonUtils.GenerateUUID();
			IntegralInvite inviteDT = new IntegralInvite(userId,inviteCode,inviteUA);
			
			if(inviteShare != null)
				integralInvite.updateShareTravelByConditions(inviteDT);
				else
					integralInvite.insertSelective(inviteDT);
			wraps.setRowData(inviteCode);
		}catch(Exception e){
			wraps.setMsgCode("EX1003");
			wraps.setMsgContext("shareInviteFirend" + e.getMessage());
		}
		return wraps;
	}

	
	/** 
	* @Title: finishRegistered 
	* @Description: 通过邀请完成注册
	* @param invitecode
	* @param inviteid
	* @return  
	*/
	@Transactional(rollbackFor=Exception.class)
	public SimpleWrap finishRegistered(String inviteUId) {
		SimpleWrap wraps = new SimpleWrap();
		try{
			Map<String,Object> inParams = new HashMap<String,Object>();
			inParams.put("inviteUId", inviteUId);
			integralInvite.execFinishInvite(inParams);
			
			if(null != inParams.get("msgCode")){
				wraps.setMsgContext(inParams.get("msgCode").toString());
				wraps.setMsgContext(inParams.get("msgContext").toString());
			}
		}catch(Exception e){
			wraps.setMsgCode("EX1004");
			wraps.setMsgContext("finishRegistered" + e.getMessage());
		}
		return wraps;
	}
	
	/** 
	* @Title: queryUserIntegralInfo 
	* @Description: 查询用户积分基础信息
	* @param userId
	* @return  
	*/
	public SimpleWrap queryUserIntegralInfo(String userId){
		SimpleWrap wraps = new SimpleWrap();
		try{
			IntegralUser userInfo = integralUser.selectByUserId(userId);
			//年度积分清零
			integralUser.updateIntegralReset(userId);
			wraps.setRowData(userInfo);
		}catch(Exception e){
			wraps.setMsgCode("EX1005");
			wraps.setMsgContext("queryUserIntegralInfo" + e.getMessage());
		}
		return wraps;
	}



	/** 
	* @Title: queryUserSignInData 
	* @Description: 查询用户签到关联数据
	* @param userId
	* @return  
	*/
	public SimpleWrap queryUserSignInData(String userId) {
		SimpleWrap wraps = new SimpleWrap();
		try{
			Map<String,Object> inOut = new HashMap<String,Object>();
			inOut.put("uId", userId);
			integralUser.querySignInRelateData(inOut);
			wraps.setRowData(inOut);
		}catch(Exception e){
			wraps.setMsgCode("EX1006");
			wraps.setMsgContext("queryUserSignInData" + e.getMessage());
		}
		return wraps;
	}
	
	
	
	/**
	 * 用户注册
	 * @param registeVo
	 * @return
	 */
	@Transactional(rollbackFor=Exception.class)
	public SimpleWrap addUserLoginRegiste(RegisteVo registeVo){
		SimpleWrap wraps = new SimpleWrap();
		try {
			String json = CommonUtils.objectMapper.writeValueAsString(registeVo);
			String result = serviceProxy.ProcessRequest(ConfigurationFields.YKAPI.concat("/userLogin/addUserLoginRegister"), json);
			JsonNode jsonNode = CommonUtils.objectMapper.readTree(result);
			String code = jsonNode.get("code").asText();
			
			//注册消息返回
			if(!"0".equals(code.trim())){
				wraps.setMsgCode("E1008");
				wraps.setMsgContext(jsonNode.get("msg").asText());
				return wraps;
			}
			 //获取相应节点
	        JsonNode dNode = jsonNode.get("data").get("doctorUserDto");
	        
			String userId = dNode.get("userId").asText();
			//插入用户邀请
			IntegralInvite invite = new IntegralInvite(registeVo.getUserId(), registeVo.getInviteCode(), registeVo.getInviteUA(),userId);
			integralInvite.insert(invite);
			//插入积分失效时间
			Calendar now = Calendar.getInstance();  
			Calendar calendar = Calendar.getInstance();  
	        calendar.clear();  
	        calendar.set(Calendar.YEAR, now.get(Calendar.YEAR) + 1);  
	        calendar.roll(Calendar.DAY_OF_YEAR, -1);
	        
	       
			String username = dNode.get("doctorName").asText();
			String telphone = dNode.get("mobilePhone").asText();
			String yikecode = dNode.get("doctorNumber").asText();
			//插入初始用户信息
			IntegralUser user = new IntegralUser(userId, username, telphone, yikecode,CommonUtils.getFailureTime());
			integralUser.insert(user);
		} catch (Exception e) {
			wraps.setMsgCode("EX1007");
			wraps.setMsgContext("addUserLoginRegiste" + e.getMessage());
		}
		return wraps;
	}
	
	
	/**
	 * 获取注册手机验证码
	 * @param MobilePhone
	 * @return
	 */
	public SimpleWrap getMobilePhoneCaptcha(String mobilePhone) {
		SimpleWrap wraps = new SimpleWrap();
		try {
			Map<String, String> inParams = new HashMap<String, String>();
			inParams.put("mobilePhone", mobilePhone);
			inParams.put("operationType", "1");
			
			String jsonString = CommonUtils.objectMapper.writeValueAsString(inParams);
			String result = serviceProxy.ProcessRequest(ConfigurationFields.YKAPI.concat("/userLogin/getMobilePhoneCaptcha"), jsonString);
			
			JsonNode jsonNode = CommonUtils.objectMapper.readTree(result);
			String code = jsonNode.get("code").asText();
			
			if (!"0".equals(code.trim())) {
				wraps.setMsgCode("E1011");
				wraps.setMsgContext(jsonNode.get("msg").asText());
				return wraps;
			}
			
		    //获取相应节点
			wraps.setRowData(jsonNode.get("data").get("objData").asText());
		} catch (Exception e) {
			wraps.setMsgCode("EX1012");
			wraps.setMsgContext("getMobilePhoneCaptcha" + e.getMessage());
		}
		return wraps;
	}
}
