#include "GexinDataReceiver.h"

#include "CCLuaEngine.h"

static GexinDataReceiver *instance = nullptr;

GexinDataReceiver* GexinDataReceiver::getInstance() {

    if (!instance)

    {

        instance = new GexinDataReceiver();

    }

    return instance;

}



void GexinDataReceiver::onClientidReceived(char* clientid) {

    //cid = clientid;

}



void GexinDataReceiver::onPayloadDataReceived(char* payloadData) {

}

char* GexinDataReceiver::getXGToken()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    
    bool isStr = JniHelper::getStaticMethodInfo(minfo, "org/cocos2dx/lua/AppActivity",
                                                "getXGToken",
                                                "()Ljava/lang/String;");
    
    if (!isStr)
    {
        log("getXGToken method not found!");
        return NULL;
    }
    
    jstring token = (jstring)minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
    
    return (char*)minfo.env->GetStringUTFChars(token, NULL);
    
#endif
    return NULL;
}

char* GexinDataReceiver::getDeviceInfo()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    
    bool isStr = JniHelper::getStaticMethodInfo(minfo, "org/cocos2dx/lua/AppActivity",
                                                "luaGetDeviceInfo",
                                                "()Ljava/lang/String;");
    
    if (!isStr)
    {
        log("getDeviceInfo method not found!");
        return "";
    }
    
    jstring deviceid = (jstring)minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
    
    return (char*)minfo.env->GetStringUTFChars(deviceid, NULL);
    
#endif
    return "";
}

