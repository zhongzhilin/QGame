#ifndef _NOTIFY_HELPER_H_

#define _NOTIFY_HELPER_H_

#include <string>

#include "cocos2d.h"



using namespace cocos2d;



#define SEND_SUCCESS	1

#define SEND_FAIL		0

#define PACKAGE_FILE	"org/cocos2dx/lua/PushService"



class NotifyHelper:public Ref

{

public:

	NotifyHelper();

	virtual ~NotifyHelper();

	bool init(){ return true; }

	CREATE_FUNC(NotifyHelper);



	static bool addNotification(int notifyID, int delayTime, std::string tickerText, std::string contentTitle, std::string contentText);

	static bool cleanOnlyNotification(int notify_id);

	static bool cleanAllNotification();



};









#endif
