#ifndef _QUICKSDK_H_
#define _QUICKSDK_H_

#define QUICKSDK_COCOS2DX_VERSION "1.2"
#include "cocos2d.h"


enum FuncType {
	FuncType_UNDEFINED = 0,   //Unused
	FuncType_ENTER_BBS = 101, /*进入论坛*/
	FuncType_ENTER_USER_CENTER = 102, /*进入用户中心*/
	FuncType_SHOW_TOOLBAR = 103, /*显示浮动工具栏*/
	FuncType_HIDE_TOOLBAR = 104, /*隐藏浮动工具栏*/
	FuncType_Customer_Service = 130, /* 客服中心 */
	FuncType_SWITCH_ACCOUNT = 107, /*切换账号 （android）*/
	FuncType_REAL_NAME_REGISTER = 105, /*实名认证 （android）*/
	FuncType_ANTI_ADDICTION_QUERY = 106, /*防沉迷 （android）*/

	FuncType_SHARE = 108, /* 分享 （android）*/
	FuncType_NOTICE = 120,/* 公告 （android）*/
};

class InitNotifier {
public:
	virtual ~InitNotifier() {
	}
	;
	virtual void onInitSuccess() = 0;
	virtual void onInitFailed() = 0;
};

class LoginNotifier {
public:
	virtual ~LoginNotifier() {
	}
	;
	virtual void onLoginSuccess(const char *uid, const char *userName, const char *token) = 0;
	virtual void onLoginCancel() = 0;
	virtual void onLoginFailed() = 0;
};

class SwitchAccountNotifier {
public:
	virtual ~SwitchAccountNotifier() {
	}
	;
	virtual void onSwitchAccountSuccess(const char *uid, const char *userName, const char *token) = 0;
	virtual void onSwitchAccountCancel() = 0;
	virtual void onSwitchAccountFailed() = 0;
};

class LogoutNotifier {
public:
	virtual ~LogoutNotifier() {
	}
	;
	virtual void onLogoutSuccess() = 0;
	virtual void onLogoutFailed() = 0;
};

class PayNotifier {
public:
	virtual ~PayNotifier() {
	}
	;
	virtual void onPaySuccess(const char *sdkOrderID, const char *cpOrderID, const char *extrasParams) = 0;
	virtual void onPayCancel(const char *sdkOrderID, const char *cpOrderID) = 0;
	virtual void onPayFailed(const char *sdkOrderID, const char *cpOrderID) = 0;
};

class ExitNotifier {
public:
	virtual ~ExitNotifier() {
	}
	;
	virtual void onExitSuccess() = 0;
	virtual void onExitFailed() = 0;
};

struct OrderInfo{
	std::string goodsID;
	std::string goodsName;
	std::string goodsDesc;
	std::string quantifier; //商品量词
	std::string cpOrderID;
	std::string callbackUrl;
	std::string extrasParams;
	double price;
	double amount;
	int count;
};

struct GameRoleInfo{
	std::string serverID;
	std::string serverName;
	std::string gameRoleName;
	std::string gameRoleID;
	std::string gameRoleBalance;
	std::string vipLevel;
	std::string gameRoleLevel;
	std::string partyName;
	std::string roleCreateTime;
	/* 以下为360特殊要求参数(具体可参考360的对接文档)，不对接360的话可以不填以下参数 */
	std::string partyId;//帮派ID
	std::string gameRoleGender;//角色性别
	std::string gameRolePower;//角色战力
	std::string partyRoleId;//角色在帮派中的ID
	std::string partyRoleName;//角色在帮派中的名称
	std::string professionId;//角色职业ID
	std::string profession;//角色职业名称
	std::string friendlist;//好友关系列表
};
//接口定义
class QuickSDK {
public:
	//公共接口
	static void setInitNotifier(InitNotifier *notifier);
	static void setLoginNotifier(LoginNotifier *notifier);//ios android
	static void setSwitchAccountNotifier(SwitchAccountNotifier *notifier);
	static void setLogoutNotifier(LogoutNotifier *notifier);//ios android
	static void setPayNotifier(PayNotifier *notifier);//ios android
	static void login();
	static void logout();
	static void pay(OrderInfo &orderInfo, GameRoleInfo &gameRoleInfo);
	static void exit();
	static void updateRoleInfoWith(GameRoleInfo &gameRoleInfo, bool createRole);

	static int getChannelType();
	static const char* getConfigValue(const char* key);

	static bool isFunctionSupported(FuncType funcType);
	static bool callFunction(FuncType funcType);

	//android
	static void setExitNotifier(ExitNotifier *notifier);
	static bool channelHasExitDialog();//判断渠道是否有退出框
};

#endif // _QUICKSDK_H_
