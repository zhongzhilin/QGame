#include "QuickSDKAndroid.h"

#include "platform/android/jni/JniHelper.h"

extern "C" {

JNIEnv* env;
JavaVM* jvm;
jobject quickSdkManagerObject;

InitNotifier* initNotifier;
LoginNotifier* loginNotifier;
SwitchAccountNotifier* switchAccountNotifier;
LogoutNotifier* logoutNotifier;
PayNotifier* payNotifier;
ExitNotifier* exitNotifier;

bool QuickSDKAndroid::channelHasExitDialog() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID isShowExitDialog = env->GetMethodID(quickSdkManagerClass, "isShowExitDialog", "()Z");
	return env->CallBooleanMethod(quickSdkManager, isShowExitDialog);
}

void QuickSDKAndroid::setInitNotifier(InitNotifier *notifier) {
	initNotifier = notifier;
	QuickSDKAndroid::setInitOK();
	int initStatus = QuickSDKAndroid::initStatus();
	if (initStatus == 1) {
		initNotifier->onInitSuccess();
	}
	if (initStatus == 2) {
		initNotifier->onInitFailed();
	}

}

void QuickSDKAndroid::setInitOK() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID setInitOK = env->GetMethodID(quickSdkManagerClass, "setInitOK","()V");
	env->CallVoidMethod(quickSdkManager, setInitOK);
}

int QuickSDKAndroid::initStatus() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID initStatus = env->GetMethodID(quickSdkManagerClass, "getInitStatus", "()I");
	return env->CallIntMethod(quickSdkManager, initStatus);
}

void QuickSDKAndroid::setLoginNotifier(LoginNotifier *notifier) {
	loginNotifier = notifier;
}

void QuickSDKAndroid::setSwitchAccountNotifier(SwitchAccountNotifier *notifier) {
	switchAccountNotifier = notifier;
}

void QuickSDKAndroid::setLogoutNotifier(LogoutNotifier *notifier) {
	logoutNotifier = notifier;
}

void QuickSDKAndroid::setPayNotifier(PayNotifier *notifier) {
	payNotifier = notifier;
}

void QuickSDKAndroid::setExitNotifier(ExitNotifier *notifier) {
	exitNotifier = notifier;
}

void QuickSDKAndroid::login() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID login = env->GetMethodID(quickSdkManagerClass, "login", "()V");
	env->CallVoidMethod(quickSdkManager, login);
}

void QuickSDKAndroid::logout() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID logout = env->GetMethodID(quickSdkManagerClass, "logout", "()V");
	env->CallVoidMethod(quickSdkManager, logout);
}

void QuickSDKAndroid::updateRoleInfoWith(GameRoleInfo &gameRoleInfo, bool createRole) {
	jvm->AttachCurrentThread(&env, NULL);
	jclass gameRoleInfoClass = env->FindClass("com/qk/game/entity/GameRoleInfo");
	jmethodID gameRoleInfoInit = env->GetMethodID(gameRoleInfoClass, "<init>", "()V");
	jobject gameRoleInfoObject = env->NewObject(gameRoleInfoClass, gameRoleInfoInit);

	jmethodID setServerName = env->GetMethodID(gameRoleInfoClass, "setServerName", "(Ljava/lang/String;)V");
	jmethodID setServerID = env->GetMethodID(gameRoleInfoClass, "setServerID", "(Ljava/lang/String;)V");
	jmethodID setGameRoleName = env->GetMethodID(gameRoleInfoClass, "setGameRoleName", "(Ljava/lang/String;)V");
	jmethodID setGameRoleID = env->GetMethodID(gameRoleInfoClass, "setGameRoleID", "(Ljava/lang/String;)V");
	jmethodID setGameBalance = env->GetMethodID(gameRoleInfoClass, "setGameBalance", "(Ljava/lang/String;)V");
	jmethodID setVipLevel = env->GetMethodID(gameRoleInfoClass, "setVipLevel", "(Ljava/lang/String;)V");
	jmethodID setGameUserLevel = env->GetMethodID(gameRoleInfoClass, "setGameUserLevel", "(Ljava/lang/String;)V");
	jmethodID setPartyName = env->GetMethodID(gameRoleInfoClass, "setPartyName", "(Ljava/lang/String;)V");
	jmethodID setRoleCreateTime = env->GetMethodID(gameRoleInfoClass, "setRoleCreateTime", "(Ljava/lang/String;)V");

	env->CallVoidMethod(gameRoleInfoObject, setServerName, env->NewStringUTF(gameRoleInfo.serverName.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setServerID, env->NewStringUTF(gameRoleInfo.serverID.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameRoleName, env->NewStringUTF(gameRoleInfo.gameRoleName.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameRoleID, env->NewStringUTF(gameRoleInfo.gameRoleID.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameBalance, env->NewStringUTF(gameRoleInfo.gameRoleBalance.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setVipLevel, env->NewStringUTF(gameRoleInfo.vipLevel.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameUserLevel, env->NewStringUTF(gameRoleInfo.gameRoleLevel.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setPartyName, env->NewStringUTF(gameRoleInfo.partyName.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setRoleCreateTime, env->NewStringUTF(gameRoleInfo.roleCreateTime.c_str()));

	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID setGameRoleInfo = env->GetMethodID(quickSdkManagerClass, "setGameRoleInfo", "(Lcom/qk/game/entity/GameRoleInfo;Z)V");
	jboolean jcreateRole = createRole;
	env->CallVoidMethod(quickSdkManager, setGameRoleInfo, gameRoleInfoObject, jcreateRole);
}

void QuickSDKAndroid::pay(OrderInfo &orderInfo, GameRoleInfo &gameRoleInfo) {
	jvm->AttachCurrentThread(&env, NULL);
	jclass orderInfoClass = env->FindClass("com/qk/game/entity/OrderInfo");
	jmethodID orderInfoInit = env->GetMethodID(orderInfoClass, "<init>", "()V");
	jobject orderInfoObject = env->NewObject(orderInfoClass, orderInfoInit);

	jmethodID setGoodsID = env->GetMethodID(orderInfoClass, "setGoodsID", "(Ljava/lang/String;)V");
	jmethodID setGoodsName = env->GetMethodID(orderInfoClass, "setGoodsName", "(Ljava/lang/String;)V");
	jmethodID setGoodsDesc = env->GetMethodID(orderInfoClass, "setGoodsDesc", "(Ljava/lang/String;)V");
	jmethodID setCpOrderID = env->GetMethodID(orderInfoClass, "setCpOrderID", "(Ljava/lang/String;)V");
	jmethodID setPrice = env->GetMethodID(orderInfoClass, "setPrice", "(D)V");
	jmethodID setCount = env->GetMethodID(orderInfoClass, "setCount", "(I)V");
	jmethodID setAmount = env->GetMethodID(orderInfoClass, "setAmount", "(D)V");
	jmethodID setCallbackUrl = env->GetMethodID(orderInfoClass, "setCallbackUrl", "(Ljava/lang/String;)V");
	jmethodID setExtrasParams = env->GetMethodID(orderInfoClass, "setExtrasParams", "(Ljava/lang/String;)V");

	env->CallVoidMethod(orderInfoObject, setGoodsID, env->NewStringUTF(orderInfo.goodsID.c_str()));
	env->CallVoidMethod(orderInfoObject, setGoodsName, env->NewStringUTF(orderInfo.goodsName.c_str()));
	env->CallVoidMethod(orderInfoObject, setGoodsDesc, env->NewStringUTF(orderInfo.goodsDesc.c_str()));
	env->CallVoidMethod(orderInfoObject, setCpOrderID, env->NewStringUTF(orderInfo.cpOrderID.c_str()));
	env->CallVoidMethod(orderInfoObject, setPrice, orderInfo.price);
	env->CallVoidMethod(orderInfoObject, setCount, orderInfo.count);
	env->CallVoidMethod(orderInfoObject, setAmount, orderInfo.amount);
	env->CallVoidMethod(orderInfoObject, setCallbackUrl, env->NewStringUTF(orderInfo.callbackUrl.c_str()));
	env->CallVoidMethod(orderInfoObject, setExtrasParams, env->NewStringUTF(orderInfo.extrasParams.c_str()));

	jclass gameRoleInfoClass = env->FindClass("com/qk/game/entity/GameRoleInfo");
	jmethodID gameRoleInfoInit = env->GetMethodID(gameRoleInfoClass, "<init>", "()V");
	jobject gameRoleInfoObject = env->NewObject(gameRoleInfoClass, gameRoleInfoInit);

	jmethodID setServerName = env->GetMethodID(gameRoleInfoClass, "setServerName", "(Ljava/lang/String;)V");
	jmethodID setServerID = env->GetMethodID(gameRoleInfoClass, "setServerID", "(Ljava/lang/String;)V");
	jmethodID setGameRoleName = env->GetMethodID(gameRoleInfoClass, "setGameRoleName", "(Ljava/lang/String;)V");
	jmethodID setGameRoleID = env->GetMethodID(gameRoleInfoClass, "setGameRoleID", "(Ljava/lang/String;)V");
	jmethodID setGameBalance = env->GetMethodID(gameRoleInfoClass, "setGameBalance", "(Ljava/lang/String;)V");
	jmethodID setVipLevel = env->GetMethodID(gameRoleInfoClass, "setVipLevel", "(Ljava/lang/String;)V");
	jmethodID setGameUserLevel = env->GetMethodID(gameRoleInfoClass, "setGameUserLevel", "(Ljava/lang/String;)V");
	jmethodID setPartyName = env->GetMethodID(gameRoleInfoClass, "setPartyName", "(Ljava/lang/String;)V");

	env->CallVoidMethod(gameRoleInfoObject, setServerName, env->NewStringUTF(gameRoleInfo.serverName.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setServerID, env->NewStringUTF(gameRoleInfo.serverID.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameRoleName, env->NewStringUTF(gameRoleInfo.gameRoleName.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameRoleID, env->NewStringUTF(gameRoleInfo.gameRoleID.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameBalance, env->NewStringUTF(gameRoleInfo.gameRoleBalance.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setVipLevel, env->NewStringUTF(gameRoleInfo.vipLevel.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setGameUserLevel, env->NewStringUTF(gameRoleInfo.gameRoleLevel.c_str()));
	env->CallVoidMethod(gameRoleInfoObject, setPartyName, env->NewStringUTF(gameRoleInfo.partyName.c_str()));

	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID pay = env->GetMethodID(quickSdkManagerClass, "pay", "(Lcom/qk/game/entity/OrderInfo;Lcom/qk/game/entity/GameRoleInfo;)V");
	env->CallVoidMethod(quickSdkManager, pay, orderInfoObject, gameRoleInfoObject);
}

void QuickSDKAndroid::exit() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID exit = env->GetMethodID(quickSdkManagerClass, "exit", "()V");
	env->CallVoidMethod(quickSdkManager, exit);
}

bool QuickSDKAndroid::isFunctionSupported(int funcType) {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID isFunctionSupported = env->GetMethodID(quickSdkManagerClass, "isFunctionSupported", "(I)Z");
	jint jfuncType = funcType;
	return env->CallBooleanMethod(quickSdkManager, isFunctionSupported, jfuncType);
}

bool QuickSDKAndroid::callFunction(int funcType) {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID callFunction = env->GetMethodID(quickSdkManagerClass, "callFunction", "(I)Z");
	int jfuncType = funcType;
	return env->CallBooleanMethod(quickSdkManager, callFunction, jfuncType);
}

int QuickSDKAndroid::channelType() {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID getChannelType = env->GetMethodID(quickSdkManagerClass, "getChannelType", "()I");
	return env->CallIntMethod(quickSdkManager, getChannelType);
}

const char* QuickSDKAndroid::getConfigValue(const char* key) {
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID getExtrasConfig = env->GetMethodID(quickSdkManagerClass, "getExtrasConfig", "(Ljava/lang/String;)Ljava/lang/String;");
	jstring jkey = env->NewStringUTF(key);
	jstring config = (jstring) env->CallObjectMethod(quickSdkManager, getExtrasConfig, jkey);
	return env->GetStringUTFChars(config, NULL);
}

jclass GetQuickSdkManagerClass() {
	jvm->AttachCurrentThread(&env, NULL);
	return env->FindClass("com/qk/game/cocos2dx/QKManager");
}

jobject GetQuickSdkManager(jclass jclazz) {
	jvm->AttachCurrentThread(&env, NULL);
	if (quickSdkManagerObject == NULL) {
		jmethodID construction_id = env->GetStaticMethodID(jclazz, "getInstance", "()Lcom/qk/game/cocos2dx/QKManager;");
		jobject object = env->CallStaticObjectMethod(jclazz, construction_id);
		if (object == NULL)
			quickSdkManagerObject = NULL;
		else
			quickSdkManagerObject = env->NewGlobalRef(object);
	}
	return quickSdkManagerObject;
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onInitSuccess(JNIEnv *, jclass){
	initNotifier->onInitSuccess();
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onInitFailed(JNIEnv *, jclass){
	initNotifier->onInitFailed();
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLoginSuccess(JNIEnv *, jclass clazz, jstring juid, jstring juserName,
		jstring jtoken) {
	const char* uid = env->GetStringUTFChars(juid, NULL);
	const char* userName = env->GetStringUTFChars(juserName, NULL);
	const char* token = env->GetStringUTFChars(jtoken, NULL);
	loginNotifier->onLoginSuccess(uid, userName, token);
	env->ReleaseStringUTFChars(juid, uid);
	env->ReleaseStringUTFChars(juserName, userName);
	env->ReleaseStringUTFChars(jtoken, token);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLoginFailed(JNIEnv *, jclass, jstring jmessage, jstring jtrace) {
	const char* message = env->GetStringUTFChars(jmessage, NULL);
	const char* trace = env->GetStringUTFChars(jtrace, NULL);
	loginNotifier->onLoginFailed();
	env->ReleaseStringUTFChars(jmessage, message);
	env->ReleaseStringUTFChars(jtrace, trace);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLoginCancel(JNIEnv *, jclass) {
	loginNotifier->onLoginCancel();
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onSwitchAccountSuccess(JNIEnv *, jclass clazz, jstring juid, jstring juserName,
		jstring jtoken) {
	const char* uid = env->GetStringUTFChars(juid, NULL);
	const char* userName = env->GetStringUTFChars(juserName, NULL);
	const char* token = env->GetStringUTFChars(jtoken, NULL);
	switchAccountNotifier->onSwitchAccountSuccess(uid, userName, token);
	env->ReleaseStringUTFChars(juid, uid);
	env->ReleaseStringUTFChars(juserName, userName);
	env->ReleaseStringUTFChars(jtoken, token);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onSwitchAccountFailed(JNIEnv *, jclass, jstring jmessage, jstring jtrace){
	const char* message = env->GetStringUTFChars(jmessage, NULL);
	const char* trace = env->GetStringUTFChars(jtrace, NULL);
	switchAccountNotifier->onSwitchAccountFailed();
	env->ReleaseStringUTFChars(jmessage, message);
	env->ReleaseStringUTFChars(jtrace, trace);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onSwitchAccountCancel(JNIEnv *, jclass){
	switchAccountNotifier->onSwitchAccountCancel();
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLogoutSuccess(JNIEnv *, jclass) {
	logoutNotifier->onLogoutSuccess();
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onLogoutFailed(JNIEnv *, jclass, jstring jmessage, jstring jtrace) {
	const char* message = env->GetStringUTFChars(jmessage, NULL);
	const char* trace = env->GetStringUTFChars(jtrace, NULL);
	logoutNotifier->onLogoutFailed();
	env->ReleaseStringUTFChars(jmessage, message);
	env->ReleaseStringUTFChars(jtrace, trace);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onPaySuccess(JNIEnv *, jclass, jstring jsdkOrderID, jstring jcpOrderID,
		jstring jextrasParams) {
	const char* sdkOrderID = env->GetStringUTFChars(jsdkOrderID, NULL);
	const char* cpOrderID = env->GetStringUTFChars(jcpOrderID, NULL);
	const char* extrasParams = env->GetStringUTFChars(jextrasParams, NULL);
	payNotifier->onPaySuccess(sdkOrderID, cpOrderID, extrasParams);
	env->ReleaseStringUTFChars(jsdkOrderID, sdkOrderID);
	env->ReleaseStringUTFChars(jcpOrderID, cpOrderID);
	env->ReleaseStringUTFChars(jextrasParams, extrasParams);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onPayCancel(JNIEnv *, jclass, jstring jcpOrderID) {
	const char* cpOrderID = env->GetStringUTFChars(jcpOrderID, NULL);
	payNotifier->onPayCancel("",cpOrderID);
	env->ReleaseStringUTFChars(jcpOrderID, cpOrderID);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onPayFailed(JNIEnv *, jclass,jstring jcpOrderID, jstring jmessage,
		jstring jtrace) {
	const char* cpOrderID = env->GetStringUTFChars(jcpOrderID, NULL);
	const char* message = env->GetStringUTFChars(jmessage, NULL);
	const char* trace = env->GetStringUTFChars(jtrace, NULL);
	payNotifier->onPayFailed("",cpOrderID);
	env->ReleaseStringUTFChars(jcpOrderID, cpOrderID);
	env->ReleaseStringUTFChars(jmessage, message);
	env->ReleaseStringUTFChars(jtrace, trace);

}
JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onChargeSuccess(JNIEnv *, jclass) {

}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onChargeCancel(JNIEnv *, jclass) {

}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onChargeFailed(JNIEnv *, jclass, jstring, jstring) {

}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onExitSuccess(JNIEnv *, jclass) {
	exitNotifier->onExitSuccess();
	jvm->AttachCurrentThread(&env, NULL);
	jclass quickSdkManagerClass = GetQuickSdkManagerClass();
	jobject quickSdkManager = GetQuickSdkManager(quickSdkManagerClass);
	jmethodID exitGame = env->GetMethodID(quickSdkManagerClass, "exitGame", "()V");
	env->CallVoidMethod(quickSdkManager, exitGame);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_onExitFailed(JNIEnv *, jclass, jstring jmessage, jstring jtrace) {
	const char* message = env->GetStringUTFChars(jmessage, NULL);
	const char* trace = env->GetStringUTFChars(jtrace, NULL);
	exitNotifier->onExitFailed();
	env->ReleaseStringUTFChars(jmessage, message);
	env->ReleaseStringUTFChars(jtrace, trace);
}

JNIEXPORT void JNICALL Java_com_qk_game_cocos2dx_JniHelper_prepared(JNIEnv * jenv, jclass) {
	jenv->GetJavaVM(&jvm);
	if (env == NULL) {
		env = jenv;
	}
}

}
