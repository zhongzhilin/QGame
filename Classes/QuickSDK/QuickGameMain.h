//
//  QuickGameMain.h
//  QGame
//
//  Created by 易勇涛 on 2017/4/7.
//
//

#ifndef QuickGameMain_h
#define QuickGameMain_h


#include <string>
#include "cocos2d.h"

using namespace cocos2d;

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "platform/android/jni/JniHelper.h"

#endif

#define PACKAGE_FILE	"org/cocos2dx/lua/AppActivity"

// sdk 渠道类型
enum CHANNELTYPE {
    
    FACEBOOK   = 1,
    GOOGLE     = 2,
    GAMECENTER = 3,
};

class QuickGameMain:public Ref
{
public:
    
    static QuickGameMain* getInstance();
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    static jobject getActivity(std::string packageFile);
    static bool mCallVoidMethod(std::string methodStr, std::string packageFile);
#endif
    
    static bool login(int channelId);
    static bool logOut(int channelId);
    static void pay(std::string shopId);
    static std::string getChannel(int channelId);
   
    static void callFacebookShare();
    static void callUserCenter();
    static void callCustomerService();
    static void startApp();
    static void copyBoard(std::string copyStr);
    static void showCustomService(std::string uid,std::string username);
    static void AdRegisterSuccess(std::string uid, std::string username);
    static void AdLoginSuccess(std::string uid, std::string username);
    static void AdUpdateRoleInfo(int isCreateRole, std::string roleId, std::string roleName, std::string roleLevel,std::string roleServerId, std::string roleServerName, std::string roleBalance, std::string roleVipLevel, std::string rolePartyName);
    static void AdPaySuccess(double orderAmount, std::string cpOrderNo, std::string goodsId, std::string goodsName,std::string currency);
    static void AdTorialCompletion( int success,std::string coutent_id);
    static void AdLevelAchieved(int level, int score);
    static void umengPaySuccess(double money, std::string item , int number, double price,int source);
    static void FaceBookShare(std::string name, std::string caption,std::string description, std::string link, std::string pic);
    static void FaceBookPurchase(double money, std::string currency);
    static void logSpentCreditsEvent(std::string contentId, std::string contentType, double totalValue);
    static void logAchievedLevelEvent (std::string level);
    static void logCompletedTutorialEvent (std::string contentId, bool success);
    static void logJoinGroupEvent (std::string groupID, std::string groupName);
    static void logCreateGroupEvent (std::string groupID, std::string groupName, std::string groupType);

    // -------------- thinkingdata 统计 ------------------
    static void tDSetPublicProperties (std::string channelId, std::string roleId, std::string serverId, std::string level, std::string city);
    static void tDSetAccountId (std::string account_id);
    static void tDRemoveAccountId ();
    static void tDRegister ();
    static void tDLogin ();
    static void tDLoginOut (std::string online_time);
    static void tDLevelup (std::string roleLevel);
    static void tDCreateRole (std::string roleType);
    static void tDOrderInit(std::string order_id, double pay_amount);
    static void tDOrderFinish(std::string order_id, std::string pay_method, double pay_amount);
    static void tDJoinGuild(std::string guild_id, std::string guild_name);
    static void tDLeaveGuild(std::string guild_id, std::string guild_name, std::string leave_reason);
    static void tDCreateGuild(std::string guild_id, std::string guild_name);
    static void tDArenaEnter (std::string rank);
    static void tDArenaWin (std::string rank, std::string get_honour);
    static void tDArenaLost (std::string rank, std::string get_honour);
    static void tDAddFriend (std::string target_role_id);
    static void tDChat (std::string target_role_id, std::string chat_channel);
    static void tDDelFriend (std::string target_role_id);
    static void tDShopBuy(std::string shop_type, std::string token_type, std::string token_cost, std::string item_id);
    static void tDSommon (std::string sommon_type, std::string token_type, std::string token_cost);
    static void tDSetUserProper (std::string role_name, std::string current_level);
    static void tDAddUserProper (std::string total_revenue, std::string total_login);

    
    // java 回调接口
    void onEnterGameCall(char* lUid, char* lToken, char* channelId, char* statues);
    
};


#endif /* QuickGameMain_h */
