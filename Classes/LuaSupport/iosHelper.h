//
//  iosHelper.h
//  QGame
//
//  Created by untory on 2017/1/20.
//
//

#ifndef iosHelper_h
#define iosHelper_h

class iosHelper {
    
public:
    static void copy(const char* str);
    static void FaceBookPurchase(double money, const char* currency);
    static void FaceBookActivateApp();
    static void umengPaySuccess(double money,const char* item , int number, double price,int source);
    
    static void AdRegisterSuccess(const char* uid, const char* username);
    static void AdLoginSuccess(const char* uid, const char* username);
    static void AdUpdateRoleInfo(int isCreateRole, const char* roleId, const char* roleName, const char* roleLevel,const char* roleServerId, const char* roleServerName, const char* roleBalance, const char* roleVipLevel, const char* rolePartyName);
    static void AdPaySuccess(double orderAmount, const char* cpOrderNo, const char* goodsId, const char* goodsName,const char* currency);
    static void AdTorialCompletion( int success,const char* coutent_id);
    static void AdLevelAchieved(int level, int score);
    static const char* get_lan();
    
    // thinkdata
    static void tDSetAccountId(const char* account_id);
    static void tDRemoveAccountId();
    static void tDSetPublicProperties(const char* channelId,const char* roleId,const char* serverId,const char* level,const char* city);
    static void tDRegister();
    static void tDLogin();
    static void tDLoginOut(const char* online_time);
    static void tDLevelup(const char* roleLevel);
    static void tDCreateRole(const char* roleType);
    static void tDOrderInit(const char* order_id, double pay_amount);
    static void tDOrderFinish(const char* order_id, const char* pay_method, double pay_amount);
    static void tDJoinGuild(const char* guild_id, const char* guild_name);
    static void tDLeaveGuild(const char* guild_id, const char* guild_name, const char* leave_reason);
    static void tDCreateGuild(const char* guild_id, const char* guild_name);
    static void tDArenaEnter(const char* rank);
    static void tDArenaWin(const char* rank, const char* get_honour);
    static void tDArenaLost(const char* rank, const char* get_honour);
    static void tDAddFriend(const char* target_role_id);
    static void tDChat(const char* target_role_id, const char* chat_channel);
    static void tDDelFriend(const char* target_role_id);
    static void tDShopBuy(const char* shop_type, const char* token_type, const char* token_cost, const char* item_id);
    static void tDSommon(const char* shop_type, const char* token_type, const char* token_cost);
    static void tDSetUserProper(const char* role_name, const char* current_level);
    static void tDAddUserProper(const char* total_revenue, const char* total_login);
    
};

#endif /* iosHelper_h */
