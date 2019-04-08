#ifndef _QUICKSDKANDROID_H_
#define _QUICKSDKANDROID_H_

#include <jni.h>
#include <string>
#include "QuickSDK.h"

extern "C" {
//定义通知

enum ToolbarPlace {
	kToolBarTopLeft = 1,	//左上
	kToolBarTopRight,		//右上
	kToolBarMidLeft,		//左中
	kToolBarMidRight,		//右中
	kToolBarBottomLeft,		//左下
	kToolBarBottomRight,	//右下
};

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onInitSuccess(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onInitFailed(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLoginSuccess(
		JNIEnv *, jclass, jstring, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLoginFailed(
		JNIEnv *, jclass, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLoginCancel(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onSwitchAccountSuccess(
		JNIEnv *, jclass, jstring, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onSwitchAccountFailed(
		JNIEnv *, jclass, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onSwitchAccountCancel(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLogoutSuccess(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLogoutFailed(
		JNIEnv *, jclass, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onPaySuccess(
		JNIEnv *, jclass, jstring, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onPayCancel(
		JNIEnv *, jclass, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onPayFailed(
		JNIEnv *, jclass, jstring, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onChargeSuccess(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onChargeCancel(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onChargeFailed(
		JNIEnv *, jclass, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onExitSuccess(
		JNIEnv *, jclass);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onExitFailed(
		JNIEnv *, jclass, jstring, jstring);

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_prepared(JNIEnv *,
		jclass);

jclass GetQuickSdkManagerClass();
jobject GetQuickSdkManager(jclass jclazz);

class QuickSDKAndroid {
public:
	static void setInitNotifier(InitNotifier *notifier);
	static void setLoginNotifier(LoginNotifier *notifier);
	static void setSwitchAccountNotifier(SwitchAccountNotifier *notifier);
	static void setLogoutNotifier(LogoutNotifier *notifier);
	static void setPayNotifier(PayNotifier *notifier);
	static void setExitNotifier(ExitNotifier *notifier);
	static void setShowExitDialog(bool showExitDialog);
	static void login();
	static void logout();
	static void pay(OrderInfo &orderInfo, GameRoleInfo &gameRoleInfo);
	static bool channelHasExitDialog();
	static void exit();
	static void updateRoleInfoWith(GameRoleInfo &gameRoleInfo, bool createRole);
	static bool isFunctionSupported(int funcType);
	static bool callFunction(int funcType);
	static int channelType();
	static const char* getConfigValue(const char* key);
private:
	static int initStatus();
	static void setInitOK();
};

}
#endif // _QUICKSDKANDROID_H_
