#ifndef __CCHGAME_H__
#define __CCHGAME_H__

#include "cocos2d.h"
#include "ui/UIScrollView.h"
#include "cocos-ext.h"
// #include "WaterEffectSprite.h"

// class WaterEffectSprite;
using namespace cocos2d;
 
class CCHgame : public cocos2d::Ref
{
	typedef int LUA_STRING;
    
    
public:
	CCHgame();
	~CCHgame();

	// 获取lua代码设备根目录 
	static const char* GetLuaDeviceRoot();

	// 获取文件内容 
	static std::string GetFileData(const char* fileName);

    // 获取游戏帧数
    static float getFps();

	// 重新开始游戏 
	static void RestartGame();

    static void UnScheduleAll();

    static void startApp();
    
    static void StartDraw(unsigned int handler,const Vec2 *verts,int size,int drawTurn);

    static int IsRelease();

	static bool CallRenderRender();
    
    static bool isSpriteTouchByPix(unsigned int handler,cocos2d::Point pos,cocos2d::Sprite* sprite);

    static bool isNodeBeTouch(cocos2d::Node* sprite,cocos2d::Rect rect,cocos2d::Point touchPos);
    
    static const char* getPasteBoardStr();
    
    static void setPasteBoard(const char* str);
    
    static const char* getXGToken();
	
    static void sendTouch(Point point);
	
    static void setWaterShader(cocos2d::Sprite* sprite, std::string normalMapName);
    static void setLineShader(cocos2d::Sprite* sprite);
    // calculate city ：building in screen
    static bool isRectIntersectRect(cocos2d::Rect buildingRect, cocos2d::Point offsetPos, const float scrollScale);
    static bool isRectContainsPoint(cocos2d::Rect rect, cocos2d::Point point);
    
    static void allExit();
    
    static bool login(int channelId);
    static bool logOut(int channelId);
    static void pay(std::string shopId);
    static void callFacebookShare();
    static void callUserCenter();
    static void callCustomerService();
    static void showCustomService(std::string uid,std::string username);
    static void AdRegisterSuccess(std::string uid, std::string username);
    static void AdLoginSuccess(std::string uid, std::string username);
    static void AdUpdateRoleInfo(int isCreateRole, std::string roleId, std::string roleName, std::string roleLevel,std::string roleServerId, std::string roleServerName, std::string roleBalance, std::string roleVipLevel, std::string rolePartyName);
    static void AdPaySuccess(double orderAmount, std::string cpOrderNo, std::string goodsId, std::string goodsName,std::string currency);
    static void AdTorialCompletion( int success,std::string coutent_id);
    static void AdLevelAchieved(int level, int score);
    static void umengPaySuccess(double money,std::string item , int number, double price,int source);
    static void FaceBookShare(std::string name, std::string caption,std::string description, std::string link, std::string pic);
    static void FaceBookPurchase(double money, std::string currency);
    static void logSpentCreditsEvent(std::string contentId, std::string contentType, double totalValue);
    static void logAchievedLevelEvent (std::string level);
    static void logCompletedTutorialEvent (std::string contentId, bool success);
    static void logJoinGroupEvent (std::string groupID, std::string groupName);
    static void logCreateGroupEvent (std::string groupID, std::string groupName, std::string groupType);
    static std::string getDeviceInfo();

	static void downloadWarData(std::string  url, std::string filepath);
	static void downloadFile(std::string url, std::string filepath);

    static void hs_showFAQs();
    static void hs_showConversation();
    static void hs_login(const char *identifier, const char *name, const char *email);
    static void hs_logout();
    static void hs_leaveBreadCrumb(const char *breadCrumb);
    static void hs_clearBreadCrumbs();
    static bool hs_setSDKLanguage(const char *locale);

    static void hs_showFAQs(cocos2d::ValueMap& config);
    static void hs_showConversation(cocos2d::ValueMap& config);
    static void hs_showFAQSection(const char *sectionPublishId);
    static void hs_showFAQSection(const char *sectionPublishId, cocos2d::ValueMap& config);
    static void hs_showSingleFAQ(const char *publishId);
    static void hs_showSingleFAQ(const char *publishId, cocos2d::ValueMap& config);
    static void hs_setNameAndEmail(const char *name, const char *email);
    static void hs_setUserIdentifier(const char *userIdentifier);
    static void hs_registerDeviceToken(const char *deviceToken);
    static void hs_showAlertToRateApp(const char *url, void (*action) (int result));
    static void hs_showAlertToRateApp(const char *url);
    static bool hs_isConversationActive();

    static bool hs_addStringProperty(const char* key, const char* value);
    static bool hs_addIntegerProperty(const char* key, int value);
    static bool hs_addBooleanProperty(const char* key, bool value);
    static bool hs_addDateProperty(const char* key, double secondsSinceEpoch);
    static void hs_addProperties(cocos2d::ValueMap& properties);

    static void hs_showInbox();
    static int  hs_getCountOfUnreadMessages();
    
    static bool unzipfile(const char* filepath,const char* dstpath,const char *passwd);
    
    // 获取系统语言
    static const char* get_lan();
    
    // 修改是否uiscrollview可滚动
    static void setNoTouchMove(cocos2d::ui::ScrollView* scrollView,  bool _noTouchMove);
    // 修改是cctableivew可滚动
    static void setNoTouchMoveTableView(cocos2d::extension::TableView* table,  bool _noTouchMove);

    static void initQuickSdk(unsigned int initHandler, unsigned int loginHandler, unsigned int loginOutHandler, unsigned int switchHandler,unsigned int exitHandler, unsigned int payHandler);
    static void loginQuick();
    static void logOutQuick();
    static int  getQuickChannelType();
    static void exitQuickSdk(unsigned int exitcall);
    
    static void updateRoleInfoWith(int isCreateRole, std::string roleId, std::string roleName, 
    std::string roleLevel,std::string roleServerId, std::string roleServerName, 
    std::string roleBalance, std::string roleVipLevel, std::string rolePartyName, 
    std::string roleCreateTime, std::string partyName, std::string partyId, std::string gameRoleGender, 
    std::string gameRolePower, std::string partyRoleId, std::string professionId, std::string profession, std::string friendlist);

    static void payQuick(double amount, int count, std::string cpOrderID, std::string extrasParams, std::string goodsID, std::string goodsName, 
    std::string roleId, std::string roleName, 
    std::string roleLevel,std::string roleServerId, std::string roleServerName, 
    std::string roleBalance, std::string roleVipLevel, std::string partyName);


    // -------------- thinkingdata 统计 ------------------
    static void tDSetPublicProperties (std::string channelId, std::string roleId, std::string serverId, std::string level, std::string city);
    static void tDSetAccountId (std::string ccount_id);
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

};

#endif

