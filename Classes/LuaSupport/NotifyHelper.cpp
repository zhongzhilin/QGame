#include "NotifyHelper.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "platform/android/jni/JniHelper.h"
#endif

NotifyHelper::NotifyHelper()

{

	

}



NotifyHelper::~NotifyHelper()

{



}



bool NotifyHelper::addNotification(int notifyID, int delayTime, std::string tickerText, std::string contentTitle, std::string contentText)

{

	

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

	JniMethodInfo minfo;



	bool isStr = JniHelper::getStaticMethodInfo(minfo, PACKAGE_FILE,

		"addNotification",

		"(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");



	if (!isStr)

	{

		log("addNotification method not found!");

		return false;

	}



	jint	jint_notifyID = notifyID;

	jint	jint_delayTime = delayTime;

	jstring jstr_tickerText = minfo.env->NewStringUTF(tickerText.c_str());

	jstring jstr_contentTitle = minfo.env->NewStringUTF(contentTitle.c_str());

	jstring jstr_contentText = minfo.env->NewStringUTF(contentText.c_str());



	minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, jint_notifyID, jint_delayTime, jstr_tickerText, jstr_contentTitle, jstr_contentText);



#endif

	return true;

}



bool NotifyHelper::cleanOnlyNotification(int notifyID)

{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

	JniMethodInfo minfo;



	bool isStr = JniHelper::getStaticMethodInfo(minfo, PACKAGE_FILE,

		"cleanOnlyNotification",

		"(I)V");



	if (!isStr)

	{

		log("cleanOnlyNotification method not found!");

		return false;

	}



	jint	jint_notifyID = notifyID;



	minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, jint_notifyID);



#endif

	return true;

}



bool NotifyHelper::cleanAllNotification()

{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

	JniMethodInfo minfo;



	bool isStr = JniHelper::getStaticMethodInfo(minfo, PACKAGE_FILE,

		"cleanAllNotification",

		"()V");



	if (!isStr)

	{

		log("cleanAllNotification method not found!");

		return false;

	}



	minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);



#endif

	return true;

}
