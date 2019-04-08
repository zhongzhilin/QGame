//
//  QuickGameMain.cpp
//  QGame
//
//  Created by 易勇涛 on 2017/4/7.
//
//

#include <stdio.h>
#include "QuickGameMain.h"
#include "CCLuaEngine.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "iosHelper.h"
#endif

static QuickGameMain *instance = nullptr;
QuickGameMain* QuickGameMain::getInstance() {
    
    if (!instance)
    {
        instance = new QuickGameMain();
    }
    return instance;
}

// android： 获取AppActivity 静态对象来调用 java 非静态方法
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
jobject QuickGameMain::getActivity(std::string packageFile)
{
    JniMethodInfo minfo;//定义Jni函数信息结构体
    bool isHaveObj = JniHelper::getStaticMethodInfo(minfo,packageFile.c_str(),"rtnActivity", "()Ljava/lang/Object;");
    jobject jobj;
    
    if (isHaveObj) {
        
        jobj = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
        return jobj;
    }else{
        return NULL;
    }
}
#endif

// android： 调用void method
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
bool QuickGameMain::mCallVoidMethod(std::string methodStr, std::string packageFile)
{
    
    CCLOG("222222 ========> QuickGameMain mCallVoidMethod %s", packageFile.c_str());
    JniMethodInfo minfo;//定义Jni函数信息结构体
    bool isStr = JniHelper::getMethodInfo(minfo, packageFile.c_str(), methodStr.c_str(), "()V");
    if (!isStr)
    {
        log("not find method!");
        return false;
    }
    minfo.env->CallVoidMethod(getActivity(packageFile), minfo.methodID);
    return true;
}
#endif

// 获取渠道类型
std::string QuickGameMain::getChannel(int channelId)
{

    if(channelId == CHANNELTYPE::FACEBOOK){
        
        return "org/cocos2dx/lua/FaceBookMgr";
        
    }else if(channelId == CHANNELTYPE::GOOGLE){
        return "";
        
    }else if(channelId == CHANNELTYPE::GAMECENTER){
        return "";
    }
    
}

// 登入
bool QuickGameMain::login(int channelId)
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCLOG("111111 ========> QuickGameMain login %d", channelId);

    mCallVoidMethod("login", getChannel(channelId));
#endif
    return true;
    

}

// 登出
bool QuickGameMain::logOut(int channelId)
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("logOut", getChannel(channelId));
#endif
    return true;
}


// 支付
void QuickGameMain::pay(std::string shopId)
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "pay",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jShopId = (minfo.env)->NewStringUTF(shopId.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jShopId);
    }

#endif
   
}

// 分享
void QuickGameMain::callFacebookShare()
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("callFacebookShare", PACKAGE_FILE);
#endif

}

//用户中心
void QuickGameMain::callUserCenter()
{
 
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("callUserCenter", PACKAGE_FILE);
#endif
    
}

//
void QuickGameMain::callCustomerService()
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("callCustomerService", PACKAGE_FILE);
#endif
    
}


// java 回调接口实现
void QuickGameMain::onEnterGameCall(char* lUid, char* lToken, char* channelId, char* statues) {
    
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    LuaStack* pStack = engine->getLuaStack();
    lua_State* pLuaSt = pStack->getLuaState();
    lua_getglobal(pLuaSt,"onEnterGameCall");
    lua_pushstring(pLuaSt, lUid);
    lua_pushstring(pLuaSt, lToken);
    lua_pushstring(pLuaSt, channelId);
    lua_pushstring(pLuaSt, statues);
    
    // lua_pcall: 当前栈 2:参数个数 0:返回值个数 0:错误处理
    lua_pcall(pLuaSt, 4, 0, 0);
    
}

// 剪切
void QuickGameMain::copyBoard(std::string copyStr)
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "copyBoard",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        // this code could be crash in xiaomi or nexus
       jstring jCopyStr = (minfo.env)->NewStringUTF(copyStr.c_str());
       minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jCopyStr);
    }
    
#endif
    
}

// 剪切
void QuickGameMain::startApp()
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("startApp", PACKAGE_FILE);
#endif
    
}

void QuickGameMain::showCustomService(std::string uid,std::string username)
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "showQuickCustomService",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring juid = (minfo.env)->NewStringUTF(uid.c_str());
        jstring jusername = (minfo.env)->NewStringUTF(username.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, juid, jusername);
    }
    
#endif
    
}

//注册成功上报接口
void QuickGameMain::AdRegisterSuccess(std::string uid, std::string username)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "AdRegisterSuccess",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring juid = (minfo.env)->NewStringUTF(uid.c_str());
        jstring jusername = (minfo.env)->NewStringUTF(username.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, juid, jusername);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::AdRegisterSuccess(uid.c_str(), username.c_str());
#endif
    
}

//登陆成功上报接口
void QuickGameMain::AdLoginSuccess(std::string uid, std::string username)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "AdLoginSuccess",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring juid = (minfo.env)->NewStringUTF(uid.c_str());
        jstring jusername = (minfo.env)->NewStringUTF(username.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, juid, jusername);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::AdLoginSuccess(uid.c_str(), username.c_str());
#endif
    
}

//上传角色信息上报接口
void QuickGameMain::AdUpdateRoleInfo(int isCreateRole, std::string roleId, std::string roleName, std::string roleLevel,std::string roleServerId, std::string roleServerName, std::string roleBalance, std::string roleVipLevel, std::string rolePartyName)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "AdUpdateRoleInfo",
                                          "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
   
        
        jint jisCreateRole = isCreateRole;
        jstring jroleId = (minfo.env)->NewStringUTF(roleId.c_str());
        jstring jroleName = (minfo.env)->NewStringUTF(roleName.c_str());
        jstring jroleLevel = (minfo.env)->NewStringUTF(roleLevel.c_str());
        jstring jroleServerId = (minfo.env)->NewStringUTF(roleServerId.c_str());
        jstring jroleServerName = (minfo.env)->NewStringUTF(roleServerName.c_str());
        jstring jroleBalance = (minfo.env)->NewStringUTF(roleBalance.c_str());
        jstring jroleVipLevel = (minfo.env)->NewStringUTF(roleVipLevel.c_str());
        jstring jrolePartyName = (minfo.env)->NewStringUTF(rolePartyName.c_str());
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jisCreateRole, jroleId, jroleName, jroleLevel, jroleServerId, jroleServerName, jroleBalance, jroleVipLevel, jrolePartyName);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::AdUpdateRoleInfo(isCreateRole, roleId.c_str(), roleName.c_str(), roleLevel.c_str(), roleServerId.c_str(), roleServerName.c_str(),  roleBalance.c_str(), roleVipLevel.c_str(), rolePartyName.c_str());
#endif
    
}

// 上传支付信息
void QuickGameMain::AdPaySuccess(double orderAmount, std::string cpOrderNo, std::string goodsId, std::string goodsName,std::string currency)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "AdPaySuccess",
                                          "(DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
   
        
        jdouble jorderAmount = orderAmount;
        jstring jrcpOrderNo = (minfo.env)->NewStringUTF(cpOrderNo.c_str());
        jstring jgoodsId = (minfo.env)->NewStringUTF(goodsId.c_str());
        jstring jgoodsName = (minfo.env)->NewStringUTF(goodsName.c_str());
        jstring jcurrency = (minfo.env)->NewStringUTF(currency.c_str());
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jorderAmount, jrcpOrderNo, jgoodsId, jgoodsName, jcurrency);
        
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::AdPaySuccess(orderAmount, cpOrderNo.c_str(), goodsId.c_str(),  goodsName.c_str(), currency.c_str());
#endif
    
}

void QuickGameMain::AdTorialCompletion( int success,std::string coutent_id)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "AdTorialCompletion",
                                          "(ILjava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jint jsuccess = success;
        jstring jcoutent_id = (minfo.env)->NewStringUTF(coutent_id.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jsuccess, jcoutent_id);
    }
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::AdTorialCompletion(success, coutent_id.c_str());
#endif
    
}

void QuickGameMain::AdLevelAchieved(int level, int score)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "AdLevelAchieved",
                                          "(II)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jint jlevel = level;
        jint jscore = score;
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jlevel, jscore);
        
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::AdLevelAchieved(level, score);
#endif
    
}

void QuickGameMain::umengPaySuccess(double money, std::string item , int number, double price,int source)
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "umengPaySuccess",
                                          "(DLjava/lang/String;IDI)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jdouble jmoney = money;
        jstring jitem = (minfo.env)->NewStringUTF(item.c_str());
        jint jnumber = number;
        jdouble jprice = price;
        jint jsource = source;
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jmoney, jitem, jnumber, jprice, jsource);
        
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::umengPaySuccess(money, item.c_str(), number, price, source);
#endif
    
}

// FaceBookShare
void QuickGameMain::FaceBookShare(std::string name, std::string caption,std::string description, std::string link, std::string pic)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "FaceBookShare",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        
        jstring jname = (minfo.env)->NewStringUTF(name.c_str());
        jstring jcaption = (minfo.env)->NewStringUTF(caption.c_str());
        jstring jdescription = (minfo.env)->NewStringUTF(description.c_str());
        jstring jlink = (minfo.env)->NewStringUTF(link.c_str());
        jstring jpic = (minfo.env)->NewStringUTF(pic.c_str());
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jname, jcaption, jdescription, jlink, jpic);
    }
    
#endif
}

void QuickGameMain::FaceBookPurchase(double money, std::string currency)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "FaceBookPurchase",
                                          "(DLjava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jdouble jmoney = (jdouble)money;
        jstring jcurrency = (minfo.env)->NewStringUTF(currency.c_str());
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jmoney, jcurrency);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::FaceBookPurchase(money, currency.c_str());
#endif
    
}

void QuickGameMain::logSpentCreditsEvent(std::string contentId, std::string contentType, double totalValue)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "logSpentCreditsEvent",
                                          "(Ljava/lang/String;Ljava/lang/String;D)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jcontentId = (minfo.env)->NewStringUTF(contentId.c_str());
        jstring jcontentType = (minfo.env)->NewStringUTF(contentType.c_str());
        jdouble jtotalValue = (jdouble)totalValue;
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jcontentId, jcontentType, jtotalValue);
    }
    
#endif
}

void QuickGameMain::logAchievedLevelEvent (std::string level)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "logAchievedLevelEvent",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jlevel = (minfo.env)->NewStringUTF(level.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jlevel);
    }
    
#endif
}

void QuickGameMain::logCompletedTutorialEvent (std::string contentId, bool success)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "logCompletedTutorialEvent",
                                          "(Ljava/lang/String;I)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jcontentId = (minfo.env)->NewStringUTF(contentId.c_str());
        jint jsuccess = success ? 1 : 0;
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jcontentId, jsuccess);
    }
    
#endif
}
void QuickGameMain::logJoinGroupEvent (std::string groupID, std::string groupName)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "logJoinGroupEvent",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jgroupID = (minfo.env)->NewStringUTF(groupID.c_str());
        jstring jgroupName = (minfo.env)->NewStringUTF(groupName.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jgroupID, jgroupName);
    }
    
#endif
}
void QuickGameMain::logCreateGroupEvent(std::string groupID, std::string groupName, std::string groupType)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "logCreateGroupEvent",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jgroupID = (minfo.env)->NewStringUTF(groupID.c_str());
        jstring jgroupName = (minfo.env)->NewStringUTF(groupName.c_str());
        jstring jgroupType = (minfo.env)->NewStringUTF(groupType.c_str());
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jgroupID, jgroupName,jgroupType);
    }
    
#endif
}


// -------------- thinkingdata 统计 ------------------

void QuickGameMain::tDSetPublicProperties(std::string channelId, std::string roleId, std::string serverId, std::string level, std::string city)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDSetPublicProperties",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jchannelId = (minfo.env)->NewStringUTF(channelId.c_str());
        jstring jroleId = (minfo.env)->NewStringUTF(roleId.c_str());
        jstring jserverId = (minfo.env)->NewStringUTF(serverId.c_str());
        jstring jlevel = (minfo.env)->NewStringUTF(level.c_str());
        jstring jcity = (minfo.env)->NewStringUTF(city.c_str());
        
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jchannelId, jroleId, jserverId, jlevel, jcity);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDSetPublicProperties(channelId.c_str(), roleId.c_str(), serverId.c_str(), level.c_str(),city.c_str());
#endif
    
}


void QuickGameMain::tDSetAccountId(std::string account_id)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDSetAccountId",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jaccount_id = (minfo.env)->NewStringUTF(account_id.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jaccount_id);
    }
    
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDSetAccountId(account_id.c_str());
#endif
    
}


void QuickGameMain::tDRemoveAccountId()
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("tDRemoveAccountId", PACKAGE_FILE);
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDRemoveAccountId();
#endif
    
}

void QuickGameMain::tDRegister()
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("tDRegister", PACKAGE_FILE);
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDRegister();
#endif
    
}

void QuickGameMain::tDLogin()
{
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
    mCallVoidMethod("tDLogin", PACKAGE_FILE);
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDLogin();
#endif
    
}


void QuickGameMain::tDLoginOut(std::string online_time)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDLoginOut",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jonline_time = (minfo.env)->NewStringUTF(online_time.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jonline_time);
    }
    
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDLoginOut(online_time.c_str());
#endif
    
    
}


void QuickGameMain::tDLevelup(std::string roleLevel)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDLevelup",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jroleLevel = (minfo.env)->NewStringUTF(roleLevel.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jroleLevel);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDLevelup(roleLevel.c_str());
#endif
    
}



void QuickGameMain::tDCreateRole(std::string roleType)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDCreateRole",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jroleType = (minfo.env)->NewStringUTF(roleType.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jroleType);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDCreateRole(roleType.c_str());
#endif
    
}



void QuickGameMain::tDOrderInit(std::string order_id, double pay_amount)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDOrderInit",
                                          "(Ljava/lang/String;D)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jdouble jpay_amount = pay_amount;
        jstring jroleType = (minfo.env)->NewStringUTF(order_id.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jroleType, jpay_amount);
    }
    
#endif
    
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDOrderInit(order_id.c_str(), pay_amount);
#endif
    
}



void QuickGameMain::tDOrderFinish(std::string order_id, std::string pay_method, double pay_amount)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDOrderFinish",
                                          "(Ljava/lang/String;Ljava/lang/String;D)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jorder_id = (minfo.env)->NewStringUTF(order_id.c_str());
        jstring jpay_method = (minfo.env)->NewStringUTF(pay_method.c_str());
        jdouble jpay_amount = pay_amount;
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jorder_id, jpay_method, jpay_amount);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDOrderFinish(order_id.c_str(),pay_method.c_str(), pay_amount);
#endif
    
}



void QuickGameMain::tDJoinGuild(std::string guild_id, std::string guild_name)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDJoinGuild",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jguild_id = (minfo.env)->NewStringUTF(guild_id.c_str());
        jstring jguild_name = (minfo.env)->NewStringUTF(guild_name.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jguild_id, jguild_name);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDJoinGuild(guild_id.c_str(),guild_name.c_str());
#endif
    
}


void QuickGameMain::tDLeaveGuild(std::string guild_id, std::string guild_name, std::string leave_reason)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDLeaveGuild",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jguild_id = (minfo.env)->NewStringUTF(guild_id.c_str());
        jstring jguild_name = (minfo.env)->NewStringUTF(guild_name.c_str());
        jstring jleave_reason = (minfo.env)->NewStringUTF(leave_reason.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jguild_id, jguild_name, jleave_reason);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDLeaveGuild(guild_id.c_str(),guild_name.c_str(), leave_reason.c_str());
#endif
    
}



void QuickGameMain::tDCreateGuild(std::string guild_id, std::string guild_name)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDCreateGuild",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jguild_id = (minfo.env)->NewStringUTF(guild_id.c_str());
        jstring jguild_name = (minfo.env)->NewStringUTF(guild_name.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jguild_id, jguild_name);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDCreateGuild(guild_id.c_str(),guild_name.c_str());
#endif
    
}



void QuickGameMain::tDArenaEnter(std::string rank)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDArenaEnter",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jrank = (minfo.env)->NewStringUTF(rank.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jrank);
    }
    
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDArenaEnter(rank.c_str());
#endif
    
    
}


void QuickGameMain::tDArenaWin(std::string rank, std::string get_honour)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDArenaWin",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jrank = (minfo.env)->NewStringUTF(rank.c_str());
        jstring jget_honour = (minfo.env)->NewStringUTF(get_honour.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jrank, jget_honour);
    }
    
#endif
    
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDArenaWin(rank.c_str(),get_honour.c_str());
#endif
    
    
}


void QuickGameMain::tDArenaLost(std::string rank, std::string get_honour)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDArenaLost",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jrank = (minfo.env)->NewStringUTF(rank.c_str());
        jstring jget_honour = (minfo.env)->NewStringUTF(get_honour.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jrank, jget_honour);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDArenaLost(rank.c_str(),get_honour.c_str());
#endif
    
}

void QuickGameMain::tDAddFriend(std::string target_role_id)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDAddFriend",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jtarget_role_id = (minfo.env)->NewStringUTF(target_role_id.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jtarget_role_id);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDAddFriend(target_role_id.c_str());
#endif
    
}


void QuickGameMain::tDChat(std::string target_role_id, std::string chat_channel)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDChat",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jtarget_role_id = (minfo.env)->NewStringUTF(target_role_id.c_str());
        jstring jchat_channel = (minfo.env)->NewStringUTF(chat_channel.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jtarget_role_id, jchat_channel);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDChat(target_role_id.c_str(), chat_channel.c_str());
#endif
    
}


void QuickGameMain::tDDelFriend(std::string target_role_id)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDDelFriend",
                                          "(Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jtarget_role_id = (minfo.env)->NewStringUTF(target_role_id.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jtarget_role_id);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDDelFriend(target_role_id.c_str());
#endif
    
    
}


void QuickGameMain::tDShopBuy(std::string shop_type, std::string token_type, std::string token_cost, std::string item_id)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDShopBuy",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jshop_type = (minfo.env)->NewStringUTF(shop_type.c_str());
        jstring jtoken_type = (minfo.env)->NewStringUTF(token_type.c_str());
        jstring jtoken_cost = (minfo.env)->NewStringUTF(token_cost.c_str());
        jstring jitem_id = (minfo.env)->NewStringUTF(item_id.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jshop_type,jtoken_type,jtoken_cost,jitem_id);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDShopBuy(shop_type.c_str(), token_type.c_str(), token_cost.c_str(), item_id.c_str());
#endif
    
    
}


void QuickGameMain::tDSommon(std::string sommon_type, std::string token_type, std::string token_cost)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDSommon",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jsommon_type = (minfo.env)->NewStringUTF(sommon_type.c_str());
        jstring jtoken_type = (minfo.env)->NewStringUTF(token_type.c_str());
        jstring jtoken_cost = (minfo.env)->NewStringUTF(token_cost.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jsommon_type,jtoken_type,jtoken_cost);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDSommon(sommon_type.c_str(), token_type.c_str(), token_cost.c_str());
#endif
    
}


void QuickGameMain::tDSetUserProper(std::string role_name, std::string current_level)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDSetUserProper",
                                          "(Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jrole_name = (minfo.env)->NewStringUTF(role_name.c_str());
        jstring jcurrent_level = (minfo.env)->NewStringUTF(current_level.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jrole_name,jcurrent_level);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDSetUserProper(role_name.c_str(), current_level.c_str());
#endif
    
}


void QuickGameMain::tDAddUserProper(std::string total_revenue, std::string total_login)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isStr = JniHelper::getMethodInfo(minfo, PACKAGE_FILE,
                                          "tDAddUserProper",
                                          "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isStr)
    {
        log("error not find method!");
    }else{
        
        jstring jtotal_revenue = (minfo.env)->NewStringUTF(total_revenue.c_str());
        jstring jctotal_login = (minfo.env)->NewStringUTF(total_login.c_str());
        minfo.env->CallVoidMethod(getActivity(PACKAGE_FILE), minfo.methodID, jtotal_revenue,jctotal_login);
    }
    
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::tDAddUserProper(total_revenue.c_str(), total_login.c_str());
#endif
    
    
}









































