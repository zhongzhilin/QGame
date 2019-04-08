#ifndef __GEXIN_DATA_RECEIVER_H__

#define __GEXIN_DATA_RECEIVER_H__

#include "cocos2d.h"

USING_NS_CC;
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "platform/android/jni/JniHelper.h"

#endif



class GexinDataReceiver : public CCObject

{

public:

	static GexinDataReceiver* getInstance();

private:

	char* cid;



public:

    void onClientidReceived(char* clientid);

    void onPayloadDataReceived(char* payloadData);
    
    char* getXGToken();
    
    char* getDeviceInfo();

    



};



#endif // __GEXIN_DATA_RECEIVER_H__

