#include "QuickSDK.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "QuickSDKAndroid.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
//#include "QuickSDKIOS.h"
#endif

void QuickSDK::setInitNotifier(InitNotifier *notifier) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::setInitNotifier(notifier);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::setInitNotifier(notifier);
#endif
}

void QuickSDK::setLoginNotifier(LoginNotifier *notifier) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::setLoginNotifier(notifier);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::setLoginNotifier(notifier);
#endif
}

void QuickSDK::setSwitchAccountNotifier(SwitchAccountNotifier *notifier) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::setSwitchAccountNotifier(notifier);
#endif
}

void QuickSDK::setLogoutNotifier(LogoutNotifier *notifier) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::setLogoutNotifier(notifier);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::setLogoutNotifier(notifier);
#endif
}

void QuickSDK::setPayNotifier(PayNotifier *notifier) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::setPayNotifier(notifier);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::setPayNotifier(notifier);
#endif
}

void QuickSDK::setExitNotifier(ExitNotifier *notifier) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::setExitNotifier(notifier);
#endif
}

void QuickSDK::login() {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::login();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::login();
#endif
}

void QuickSDK::logout() {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::logout();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::logout();
#endif
}

void QuickSDK::updateRoleInfoWith(GameRoleInfo &gameRoleInfo, bool createRole) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::updateRoleInfoWith(gameRoleInfo, createRole);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::updateRoleInfoWith(&gameRoleInfo, createRole);
#endif
}

void QuickSDK::pay(OrderInfo &orderInfo, GameRoleInfo &gameRoleInfo) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::pay(orderInfo, gameRoleInfo);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // QuickSDKIOS::pay(&orderInfo, &gameRoleInfo);
#endif
}

void QuickSDK::exit() {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	QuickSDKAndroid::exit();
#endif
}

bool QuickSDK::isFunctionSupported(FuncType funcType) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	return QuickSDKAndroid::isFunctionSupported(funcType);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // return QuickSDKIOS::isFunctionTypeSupported(funcType);
#endif
	return false;
}

bool QuickSDK::callFunction(FuncType funcType) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	return QuickSDKAndroid::callFunction(funcType);
#endif
	return false;
}

int QuickSDK::getChannelType() {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	return QuickSDKAndroid::channelType();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // return QuickSDKIOS::channelType();
#endif
	return 0;
}

const char* QuickSDK::getConfigValue(const char* key) {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	return QuickSDKAndroid::getConfigValue(key);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // return QuickSDKIOS::getConfigValue(key);
#endif
	return "";
}

bool QuickSDK::channelHasExitDialog() {

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	return QuickSDKAndroid::channelHasExitDialog();
#endif
	return false;
}
