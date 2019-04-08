#include "network/CCDownloader.h"

#include <string>

#include "CCLuaEngine.h"
#include "cocos2d.h"
#include "AppDelegate.h"
#include "math/MathUtil.h"
#include "GtSDK/GexinDataReceiver.h"
#include "QuickSDK/QuickGameMain.h"
#include "Lua/AxLuaFunction.h"

#include "QuickSDK/QuickSDK.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "QuickSDK/QuickSDKAndroid.h"
#endif

//#include "Proto/pbconf.client.loader.h"

#include "CCHgame.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "iosHelper.h"
#endif

USING_NS_CC;

using namespace cocos2d::network;
using namespace cocos2d::extension;

CCHgame::CCHgame()
{
}

CCHgame::~CCHgame()
{
}

bool CCHgame::isSpriteTouchByPix(unsigned int handler,cocos2d::Point openglLocation,cocos2d::Sprite* clickableSprite){
    
    auto spriteLocation = clickableSprite->convertToNodeSpace(openglLocation);
    auto spContentSize = clickableSprite->getContentSize();
    auto rect = Rect(Vec2::ZERO, spContentSize);
    if (!rect.containsPoint(spriteLocation))
    {
        return false;
    }
    
    auto renderTex = RenderTexture::create(spContentSize.width, spContentSize.height, Texture2D::PixelFormat::RGBA8888);
    renderTex->getSprite()->setAnchorPoint(Vec2::ZERO);
    //特别注意这里，直接用renderTex->setAnchorPoint无效
    renderTex->setPosition(Vec2::ZERO);
    
    // init tmpSprite
    auto tmpSprite = Sprite::createWithSpriteFrame(clickableSprite->getSpriteFrame());
    tmpSprite->setAnchorPoint(Vec2::ANCHOR_BOTTOM_LEFT);
    tmpSprite->setPosition(Vec2::ZERO);
    
    // draw
    renderTex->beginWithClear(0, 0, 0, 0);
    tmpSprite->visit();
    renderTex->end();
    
//    // 利用CustomCommand获取绘制后的数据，cocos2dx 3.0后visit()不会立即渲染
    CustomCommand* checkAlphaCommand = new CustomCommand();
    checkAlphaCommand->init(0);

	
	auto func = std::bind([=](int handler){

		auto img = renderTex->newImage(false);
		// opengl的y轴是从下到上，false=垂直方向不翻转与opengl一致
		unsigned char* data = img->getData();
		unsigned char alpha = *(data + (int)spriteLocation.y * (int)spContentSize.width * 4 + (int)spriteLocation.x * 4 + 3);
		// 4=rgba模式每像素4字节，3=第4个字节为透明度		
		CC_SAFE_DELETE(img);

		delete checkAlphaCommand;

		if (alpha > 0){

			auto engine = LuaEngine::getInstance();
			auto stack = engine->getLuaStack();
			stack->executeFunctionByHandler(handler, 0);
			stack->clean();
		}
	},handler);

	checkAlphaCommand->func = func;

    Director::getInstance()->getRenderer()->addCommand(checkAlphaCommand);

    return true;
}

bool CCHgame::isNodeBeTouch(cocos2d::Node *node, cocos2d::Rect rect, cocos2d::Point touchPos){
    
    auto camera = Camera::getVisitingCamera();
    return isScreenPointInRect(touchPos, camera, node->getWorldToNodeTransform(), rect, nullptr);
}

const char* CCHgame::GetLuaDeviceRoot()
{
	static std::string strLuaRootPath;
	if (strLuaRootPath != "")
	{
		return strLuaRootPath.c_str();
	}

	const std::string strLuaBootFile = "app_boot.lua";
	std::string strPath = FileUtils::getInstance()->fullPathForFilename(strLuaBootFile.c_str());
	std::string::size_type pos = strPath.rfind(strLuaBootFile);
	if (std::string::npos == pos)
	{
		CCAssert(false, "lua script root dir not found!");
	}

	strLuaRootPath = strPath.substr(0, --pos);
	return strLuaRootPath.c_str();
}

float CCHgame::getFps()
{
    Director* director = Director::getInstance();
    float curr = director->getFps();
    return curr;
}

std::string CCHgame::GetFileData(const char* fileName)
{
	ssize_t ulSize = 0;
    unsigned char* pBuf = FileUtils::getInstance()->getFileData(fileName, "rb", &ulSize);
	if (pBuf == NULL)
	{
		return NULL;
	}

	std::string contentStr((const char*)pBuf, ulSize);
	delete[] pBuf;
	return contentStr;
}

void CCHgame::RestartGame()
{
    class ScriptEngineRemove : public Ref
	{
	public:
        static ScriptEngineRemove* create(void)
		{
            ScriptEngineRemove* pRet = new ScriptEngineRemove();
			if (pRet)
			{
				pRet->autorelease();
			}
			else
			{
				CC_SAFE_DELETE(pRet);
			}
			return pRet;
		}

		void callBack(float dt)
		{
			AppDelegate* pApp = (AppDelegate*)Application::getInstance();
            CCHgame::UnScheduleAll();
			pApp->applicationRestart();
		}

	};

    Director* director = Director::getInstance();
    ScriptEngineRemove* pObj = ScriptEngineRemove::create();
    director->getScheduler()->schedule(schedule_selector(ScriptEngineRemove::callBack), pObj, 0, 0, 0.2f, false);
}

void CCHgame::UnScheduleAll()
{
    Director* director = Director::getInstance();
    ActionManager* actionMgr = director->getActionManager();
    actionMgr->removeAllActions();
    director->getScheduler()->unscheduleAll();
    director->getScheduler()->scheduleUpdateForTarget(actionMgr, kCCPrioritySystem, false);
    director->destroyTextureCache();
    director->initTextureCache();
}

struct Line {
    Point p1;
    Point p2;
};

void CCHgame::StartDraw(unsigned int handler,const Vec2 *verts,int size,int drawTurn){

    std::thread([=]{
    
        //定义所有的点
        std::vector<Point> points;
        
        for(int i = 0;i < size;i++){
            
            points.push_back(verts[i]);
        }
        
        // log("%d cpp points size",points.size());
        
        int lineWidth = 1000;
        
        std::vector<Line> lineCache;
        
        auto abs = [](float num)->float{
            
            if(num < 0) return -num;
            return num;
        };
        
        auto isPointEquie = [](Point p1,Point p2)->bool{
            
            return p1.x == p2.x && p1.y == p2.y;
        };
        
        auto getK = [abs](Point p1,Point p2)->float{
            
            if(p1.x == p2.x) return 0;
            return abs(p1.y - p2.y) / abs(p1.x - p2.x);
        };
        
        auto checkLine = [&lineCache,isPointEquie](Point startPos,Point endPos)->bool{
            
            for(int i = 0;i < lineCache.size();i++){
                
                Line tempLine = lineCache[i];
                Point preStart = tempLine.p1;
                Point preEnd = tempLine.p2;
                
                if(isPointEquie(startPos,preStart) || isPointEquie(startPos,preEnd) || isPointEquie(endPos,preStart) || isPointEquie(endPos,preEnd)){
                    
                }else{
                    
                    if(Vec2::isSegmentIntersect(preStart,preEnd,startPos,endPos)){
                        
                        return false;
                    }
                }
            }
            
            return true;
        };
        
        std::vector<Point> checkCupDatas = {};
        auto checkCup = [&checkCupDatas](int i,int j)->bool{
            
            for(int index = 0;index < checkCupDatas.size();index++){
                
                auto v = checkCupDatas[index];
                if((v.x == i && v.y == j) || (v.x == j && v.y == i)){
                    
                    return false;
                }
            }
            
            return true;
        };
        
        auto isHavaAngle = [abs](std::vector<float> tb,float angle)->bool{
            
            for(int i = 0;i < tb.size();i++){
                
                auto av = tb[i];
                if(angle < 0) angle = angle + 360;
                if(av < 0) av = av + 360;
                
                if(abs(angle - av) < 60) return true;
            }
            
            return false;
        };
        
        for(int ti = 0;ti < points.size();ti++){
            
            auto i = points[ti];
            std::vector<float> allAngle;
            for(int tj = 0;tj < points.size();tj++){
                
                auto j = points[tj];
                auto startPos = i;
                auto endPos = j;
                
                auto dis = startPos.getDistance(endPos);
                auto subPoint = (startPos - endPos);
                auto angle = atan2f(subPoint.y,subPoint.x) / 3.14 * 180;
                
                if(dis < lineWidth && !(isHavaAngle(allAngle,angle)) && checkLine(startPos,endPos) && ti != tj && checkCup(ti,tj)){
                    
                    Line line;
                    line.p1 = startPos;
                    line.p2 = endPos;
                    
                    allAngle.push_back(angle);
                    lineCache.push_back(line);
                    checkCupDatas.push_back(Point(ti,tj));
                    
//                    log("cpp %d %d",ti + 1,tj + 1);
                }
            }
        }

        
        Director::getInstance()->getScheduler()->performFunctionInCocosThread([=]{
        
            LuaValueArray l_res;
            
            for(int i = 0;i < lineCache.size();i++){
            
                LuaValueArray l_line;
                
                auto line = lineCache[i];
                LuaValueDict l_point1;
                l_point1["x"] = LuaValue::intValue(line.p1.x);
                l_point1["y"] = LuaValue::intValue(line.p1.y);
                LuaValueDict l_point2;
                l_point2["x"] = LuaValue::intValue(line.p2.x);
                l_point2["y"] = LuaValue::intValue(line.p2.y);
                
                l_line.push_back(LuaValue::dictValue(l_point1));
                l_line.push_back(LuaValue::dictValue(l_point2));
                
                l_res.push_back(LuaValue::arrayValue(l_line));
            }
            
            auto engine = LuaEngine::getInstance();
            auto stack = engine->getLuaStack();
            stack->pushInt(drawTurn);
            stack->pushLuaValueArray(l_res);
            stack->executeFunctionByHandler(handler, 2);
            stack->clean();
        });
    }).detach();
    
//    auto isLineInLineCache = [&lineCache,isPointEquie](Point startPos,Point endPos)->bool{
//    
//        for(int i = 0;i < lineCache.size();i++){
//        
//            auto line = lineCache[i];
//            auto preStart = line.p1;
//            auto preEnd = line.p2;
//            
//            if ((isPointEquie(startPos,preStart) && isPointEquie(endPos,preEnd)) || (isPointEquie(startPos,preEnd) && isPointEquie(endPos,preStart))){
//                
//                return true;
//            }
//        }
//        
//        return  false;
//    };
}

void CCHgame::sendTouch(Point point){
    
    srand ((unsigned)time(nullptr));
    intptr_t _touchId = rand();
    
    auto dir = Director::getInstance();
    auto sizeInPixels = dir->getWinSizeInPixels();
    auto sizeRes = dir->getOpenGLView()->getFrameSize();
    auto sizeScale = sizeRes.width / sizeInPixels.width;
    
    float x = point.x * sizeScale;
    float y = (sizeInPixels.height - point.y) * sizeScale;
    
//    float screenScale = Director::getInstance()->getContentScaleFactor();
//    float x = point.x;
//    float y = Director::getInstance()->getWinSize().height - point.y;
    
    Director::getInstance()->getOpenGLView()->handleTouchesBegin(1, &_touchId, &x, &y);
    Director::getInstance()->getOpenGLView()->handleTouchesEnd(1, &_touchId, &x, &y);
}

const char* CCHgame::getPasteBoardStr(){

    return "test";
}

void CCHgame::setPasteBoard(const char* str){
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    iosHelper::copy(str);
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
   QuickGameMain::getInstance()->copyBoard(str);
#endif
    
}

void CCHgame::startApp(){
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
   QuickGameMain::getInstance()->startApp();
#endif
    
}

int CCHgame::IsRelease()
{
	int ret = 0;
#ifdef NDEBUG
	ret = 1;
#endif
	return ret;
}

bool CCHgame::CallRenderRender()
{
	Director::getInstance()->getRenderer()->render();
	return true;
}

const char* CCHgame::getXGToken()
{
    return GexinDataReceiver::getInstance()->getXGToken();
}

void CCHgame::setWaterShader(cocos2d::Sprite* sprite, std::string normalMapName)
{
    auto fragSource = (GLchar*)String::createWithContentsOfFile(FileUtils::getInstance()->fullPathForFilename("shaders/WaterEffect.fsh").c_str())->getCString();
    auto program = GLProgram::createWithByteArrays(ccPositionTextureColor_noMVP_vert, fragSource);
    
    auto glProgramState = GLProgramState::getOrCreateWithGLProgram(program);
    sprite->setGLProgramState(glProgramState);
    
    auto normalMapTextrue = TextureCache::getInstance()->addImage(normalMapName);
    Texture2D::TexParams texParams = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT };
    normalMapTextrue->setTexParameters(&texParams);
    sprite->getGLProgramState()->setUniformTexture("u_normalMap", normalMapTextrue);
}

void CCHgame::setLineShader(cocos2d::Sprite* sprite)
{
    auto fragSource = (GLchar*)String::createWithContentsOfFile(
        FileUtils::getInstance()->fullPathForFilename("shader/line.fsh").c_str())->getCString();
    auto program = GLProgram::createWithByteArrays(ccPositionTextureColor_noMVP_vert, fragSource);

    auto glProgramState = GLProgramState::getOrCreateWithGLProgram(program);
    sprite->setGLProgramState(glProgramState);

    auto normalMapTextrue = TextureCache::getInstance()->addImage("shader/line.png");
    Texture2D::TexParams texParams = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT };
    normalMapTextrue->setTexParameters(&texParams);
}

bool CCHgame::isRectIntersectRect(cocos2d::Rect buildingRect, cocos2d::Point offsetPos, const float scrollScale)
{
	auto size = Director::getInstance()->getWinSize();
    auto originX = -offsetPos.x/scrollScale;
    auto originY = -offsetPos.y/scrollScale;
    auto screenRect = cocos2d::Rect(originX,originY,size.width/scrollScale,size.height/scrollScale);


    auto ret = !( screenRect.origin.x > buildingRect.origin.x + buildingRect.size.width    ||
                screenRect.origin.x + screenRect.size.width < buildingRect.origin.x        ||
                screenRect.origin.y > buildingRect.origin.y + buildingRect.size.height     ||
                screenRect.origin.y + screenRect.size.height < buildingRect.origin.y );

    return ret;
}

bool CCHgame::isRectContainsPoint(cocos2d::Rect rect, cocos2d::Point point)
{
    auto ret = ((point.x >= rect.origin.x) && (point.x <= rect.origin.x + rect.size.width) &&
                (point.y >= rect.origin.y) && (point.y <= rect.origin.y + rect.size.height));

    return ret;
}

void CCHgame::allExit()
{
    // Application* pApp = Application::getInstance();
    // pApp->allExit();
}


// sdk 调用接口
bool CCHgame::login(int channelId)
{
    return QuickGameMain::getInstance()->login(channelId);
}

bool CCHgame::logOut(int channelId)
{
    return QuickGameMain::getInstance()->logOut(channelId);
}

// 支付
void CCHgame::pay(std::string shopId)
{
    QuickGameMain::getInstance()->pay(shopId);
}

void CCHgame::callFacebookShare()
{
    QuickGameMain::getInstance()->callFacebookShare();
}

void CCHgame::callUserCenter()
{
    QuickGameMain::getInstance()->callUserCenter();
}

void CCHgame::callCustomerService()
{
    QuickGameMain::getInstance()->callCustomerService();
}

void CCHgame::showCustomService(std::string uid,std::string username)
{
    QuickGameMain::getInstance()->showCustomService(uid,username);
}

void CCHgame::AdRegisterSuccess(std::string uid,std::string username)
{
    QuickGameMain::getInstance()->AdRegisterSuccess(uid, username);
}

void CCHgame::AdLoginSuccess(std::string uid, std::string username)
{
    QuickGameMain::getInstance()->AdLoginSuccess(uid, username);
}

void CCHgame::AdUpdateRoleInfo(int isCreateRole, std::string roleId, std::string roleName, std::string roleLevel,std::string roleServerId, std::string roleServerName, std::string roleBalance, std::string roleVipLevel, std::string rolePartyName)
{
    QuickGameMain::getInstance()->AdUpdateRoleInfo(isCreateRole, roleId, roleName, roleLevel, roleServerId, roleServerName, roleBalance, roleVipLevel, rolePartyName);
}

void CCHgame::AdPaySuccess(double orderAmount, std::string cpOrderNo, std::string goodsId, std::string goodsName,std::string currency)
{
    QuickGameMain::getInstance()->AdPaySuccess(orderAmount, cpOrderNo, goodsId, goodsName, currency);
}

void CCHgame::AdTorialCompletion(int success,std::string coutent_id)
{
    QuickGameMain::getInstance()->AdTorialCompletion(success, coutent_id);
}

void CCHgame::AdLevelAchieved(int level, int score)
{
    QuickGameMain::getInstance()->AdLevelAchieved(level, score);
}

void CCHgame::umengPaySuccess(double money,std::string item , int number, double price,int source)
{
    QuickGameMain::getInstance()->umengPaySuccess(money, item, number, price, source);
}

void CCHgame::FaceBookShare(std::string name, std::string caption,std::string description, std::string link, std::string pic)
{
    QuickGameMain::getInstance()->FaceBookShare(name, caption, description, link, pic);
}

void CCHgame::FaceBookPurchase(double money, std::string currency)
{
    QuickGameMain::getInstance()->FaceBookPurchase(money, currency);
}

void CCHgame::logSpentCreditsEvent(std::string contentId, std::string contentType, double totalValue)
{
    QuickGameMain::getInstance()->logSpentCreditsEvent(contentId, contentType, totalValue);
}
void CCHgame::logAchievedLevelEvent (std::string level)
{
    QuickGameMain::getInstance()->logAchievedLevelEvent(level);
}
void CCHgame::logCompletedTutorialEvent (std::string contentId, bool success)
{
    QuickGameMain::getInstance()->logCompletedTutorialEvent(contentId, success);
}
void CCHgame::logJoinGroupEvent (std::string groupID, std::string groupName)
{
    QuickGameMain::getInstance()->logJoinGroupEvent(groupID, groupName);
}
void CCHgame::logCreateGroupEvent (std::string groupID, std::string groupName, std::string groupType)
{
    QuickGameMain::getInstance()->logCreateGroupEvent(groupID, groupName, groupType);
}
std::string CCHgame::getDeviceInfo()
{
    return GexinDataReceiver::getInstance()->getDeviceInfo();
}

void CCHgame::downloadWarData(std::string  url, std::string filepath)
{


	 Downloader *  _downloader = new Downloader();

	 // 下载出错
	 _downloader->onTaskError = [](const DownloadTask& task,
		 int errorCode,
		 int errorCodeInternal,
		 const std::string& errorStr)
	 {
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("WARDATA_DOWNLORD_ERROR", NULL);
	 };

	 //进度
	 _downloader->onTaskProgress = [](const DownloadTask& task,
		 int64_t bytesReceived,
		 int64_t totalBytesReceived,
		 int64_t totalBytesExpected)
	 {

		 int percent = totalBytesExpected ? int(totalBytesReceived * 100 / totalBytesExpected) : 0;
         
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("WARDATA_DOWNLORDING", &percent);

	 };

	 // 数据下载成功
	 _downloader->onDataTaskSuccess = [](const DownloadTask& task,
		 std::vector<unsigned char>& data)
	 {
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("WARDATA_DOWNLORD_SUCCESS", NULL);
	 };

	  //文件写入成功
	 _downloader->onFileTaskSuccess = [](const DownloadTask& task)
	 {
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("WARDATA_FILEWRITE_SUCCESS", NULL);
	 };

	 _downloader->createDownloadFileTask(url, filepath);
}

void CCHgame::downloadFile(std::string url, std::string filepath)
{


     Downloader *  _downloader = new Downloader();

     // 下载出错
     _downloader->onTaskError = [](const DownloadTask& task,
         int errorCode,
         int errorCodeInternal,
         const std::string& errorStr)
     {
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent(task.storagePath+ "_DOWNLORD_ERROR", NULL);
     };

     //进度
     _downloader->onTaskProgress = [](const DownloadTask& task,
         int64_t bytesReceived,
         int64_t totalBytesReceived,
         int64_t totalBytesExpected)
     {

         int percent = totalBytesExpected ? int(totalBytesReceived * 100 / totalBytesExpected) : 0;
         
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent(task.storagePath + "_DOWNLORDING", &percent);

     };

     // 数据下载成功
     _downloader->onDataTaskSuccess = [](const DownloadTask& task,
         std::vector<unsigned char>& data)
     {
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent(task.storagePath + "_DOWNLORD_SUCCESS", NULL);
     };

      //文件写入成功
     _downloader->onFileTaskSuccess = [](const DownloadTask& task)
     {
		 Director::getInstance()->getEventDispatcher()->dispatchCustomEvent(task.storagePath + "_FILEWRITE_SUCCESS", NULL);
     };

     _downloader->createDownloadFileTask(url, filepath);
}

void CCHgame::hs_showFAQs()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

void CCHgame::hs_showConversation()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

void CCHgame::hs_login(const char *identifier, const char *name, const char *email)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

void CCHgame::hs_logout()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

void CCHgame::hs_leaveBreadCrumb(const char *breadCrumb)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

void CCHgame::hs_clearBreadCrumbs()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

bool CCHgame::hs_setSDKLanguage(const char *locale)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
    return false;
}

void CCHgame::hs_showFAQs(cocos2d::ValueMap& config)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}
void CCHgame::hs_showConversation(cocos2d::ValueMap& config)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}
void CCHgame::hs_showFAQSection(const char *identifier, cocos2d::ValueMap& config)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}
void CCHgame::hs_showFAQSection(const char *sectionPublishId)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#endif
}

void CCHgame::hs_showSingleFAQ(const char *publishId)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}
void CCHgame::hs_showSingleFAQ(const char *publishId, cocos2d::ValueMap& config)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}

void CCHgame::hs_setNameAndEmail(const char *name, const char *email)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}
void CCHgame::hs_setUserIdentifier(const char *userIdentifier)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}

void CCHgame::hs_registerDeviceToken(const char *deviceToken)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}
void CCHgame::hs_showAlertToRateApp(const char *url, void (*action) (int result))
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}
void CCHgame::hs_showAlertToRateApp(const char *url)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}
bool CCHgame::hs_isConversationActive()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
    return false;
}

bool CCHgame::hs_addStringProperty(const char* key, const char* value)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
    return false;
}
bool CCHgame::hs_addIntegerProperty(const char* key, int value)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
    return false;
}
bool CCHgame::hs_addBooleanProperty(const char* key, bool value)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
    return false;
}
bool CCHgame::hs_addDateProperty(const char* key, double secondsSinceEpoch)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
    return false;
}
void CCHgame::hs_addProperties(cocos2d::ValueMap& properties)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}

void CCHgame::hs_showInbox()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
}
int CCHgame::hs_getCountOfUnreadMessages()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#endif
    return 0;
}

const char* CCHgame::get_lan()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    return iosHelper::get_lan();
#endif
    return "";
}

void CCHgame::setNoTouchMove(cocos2d::ui::ScrollView* scrollView, bool noTouchMove)
{
    scrollView->setNoTouchMove(noTouchMove);
}

void CCHgame::setNoTouchMoveTableView(cocos2d::extension::TableView * table, bool noTouchMove)
{
    table->setNoTouchMove(noTouchMove);
}
bool CCHgame::unzipfile(const char* filepath,const char* dstpath,const char *passwd)
{
    return ZipUtils::unzip(filepath,dstpath,nullptr);
}




// --------------------------------- quick sdk 接入------------------------------ //

void CCHgame::initQuickSdk(unsigned int initHandler, unsigned int loginHandler, unsigned int loginOutHandler, unsigned int switchHandler,unsigned int exitHandler, unsigned int payHandler)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

    // -----------------  初始化 ----------------- //
    class InitNotifierImpl: public InitNotifier {

        private:
            unsigned int m_handler = 0;
        public:
            void setHandler(unsigned int i_handler) { m_handler = i_handler; }
            void onInitSuccess() {
               //初始化成功
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(0);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
            }
            void onInitFailed() {
               //初始化失败
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(1);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
            }
    };
    InitNotifierImpl* objInit = new InitNotifierImpl();
    objInit->setHandler(initHandler);
    QuickSDK::setInitNotifier(objInit);


    // -----------------  登录 ----------------- //
    class LoginNotifierImpl: public LoginNotifier {
        private:
            unsigned int m_handler = 0;

        public:
        
            void setHandler(unsigned int i_handler) { m_handler = i_handler; }

        void onLoginSuccess(const char *uid, const char *userName, const char *token) {
           //登录成功，获取到用户信息userInfo
           //通过userInfo中的UID、token做服务器登录认证

            auto engine = LuaEngine::getInstance();
            auto stack = engine->getLuaStack();
            stack->pushInt(0);
            stack->pushString(uid);
            stack->pushString(userName);
            stack->pushString(token);
            stack->pushInt(QuickSDK::getChannelType()); //渠道ID
            stack->executeFunctionByHandler(m_handler, 5);
            stack->clean();

        }
       void onLoginCancel() {
           //登录取消
            auto engine = LuaEngine::getInstance();
            auto stack = engine->getLuaStack();
            stack->pushInt(1);
            stack->executeFunctionByHandler(m_handler, 1);
            stack->clean();
            QuickSDK::login();

       }
       void onLoginFailed() {
           //登录失败
            auto engine = LuaEngine::getInstance();
            auto stack = engine->getLuaStack();
            stack->pushInt(2);
            stack->executeFunctionByHandler(m_handler, 1);
            stack->clean();
            QuickSDK::login();
       }
    };
    LoginNotifierImpl* objLogin = new LoginNotifierImpl();
    objLogin->setHandler(loginHandler);
    QuickSDK::setLoginNotifier(objLogin);

    // -----------------  注销 ----------------- //
    class LogoutNotifierImpl: public LogoutNotifier {
        private:
            unsigned int m_handler = 0;

        public:
        
            void setHandler(unsigned int i_handler) { m_handler = i_handler; }
            void onLogoutSuccess() {
                //注销成功
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(0);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }
           void onLogoutFailed(){
                //注销失败不做处理
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(1);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }    
    };
    LogoutNotifierImpl* objLogOut = new LogoutNotifierImpl();
    objLogOut->setHandler(loginOutHandler);
    QuickSDK::setLogoutNotifier(objLogOut);


    // -----------------  切换账号 ----------------- //
    class SwitchAccountNotifierImpl: public SwitchAccountNotifier {
        private:
            unsigned int m_handler = 0;

        public:
        
            void setHandler(unsigned int i_handler) { m_handler = i_handler; }
            void onSwitchAccountSuccess(const char *uid, const char *userName, const char *token) {
                  //切换账号成功，通过userInfo中的uid、token做服务器登录认证
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(0);
                stack->pushString(uid);
                stack->pushString(userName);
                stack->pushString(token);
                stack->pushInt(QuickSDK::getChannelType()); //渠道ID
                stack->executeFunctionByHandler(m_handler, 5);
                stack->clean();
           }
           void onSwitchAccountFailed(){
                  //切换账号失败
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(1);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }
           void onSwitchAccountCancel(){
                  //切换账号取消
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(2);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }    
    };
    SwitchAccountNotifierImpl* objSwit = new SwitchAccountNotifierImpl();
    objSwit->setHandler(switchHandler);
    QuickSDK::setSwitchAccountNotifier(objSwit);


    // -----------------  退出 ----------------- //
    class ExitNotifierImpl: public ExitNotifier {
        private:
            unsigned int m_handler = 0;

        public:
        
            void setHandler(unsigned int i_handler) { m_handler = i_handler; }
            void onExitSuccess() {
                //退出成功
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(0);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }
           void onExitFailed(){
                //退出失败
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(1);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }    
    };
    ExitNotifierImpl* objExit = new ExitNotifierImpl();
    objExit->setHandler(exitHandler);
    QuickSDK::setExitNotifier(objExit);

    // -----------------  支付 ----------------- //
    class PayNotifierImpl: public PayNotifier {
        private:
            unsigned int m_handler = 0;

        public:
        
            void setHandler(unsigned int i_handler) { m_handler = i_handler; }
            void onPaySuccess(const char *sdkOrderID, const char *cpOrderID, const char *extrasParams) {
                  //支付成功
                 //sdkOrderID:quick订单号 cpOrderID：游戏订单号
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(0);
                stack->pushString(sdkOrderID);
                stack->pushString(cpOrderID);
                stack->pushString(extrasParams);
                stack->pushInt(QuickSDK::getChannelType()); //渠道ID
                stack->executeFunctionByHandler(m_handler, 5);
                stack->clean();
           }
           void onPayCancel(const char *sdkOrderID, const char *cpOrderID){
                  //切换账号失败
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(1);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }
           void onPayFailed(const char *sdkOrderID, const char *cpOrderID){
                  //支付失败
                auto engine = LuaEngine::getInstance();
                auto stack = engine->getLuaStack();
                stack->pushInt(2);
                stack->executeFunctionByHandler(m_handler, 1);
                stack->clean();
           }    
    };
    PayNotifierImpl* objPay = new PayNotifierImpl();
    objPay->setHandler(payHandler);
    QuickSDK::setPayNotifier(objPay);

#endif

}

int CCHgame::getQuickChannelType()
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return QuickSDK::getChannelType();
#endif
return 0;

}

void CCHgame::loginQuick()
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    QuickSDK::login();
#endif

}

void CCHgame::logOutQuick()
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    QuickSDK::logout();
#endif

}

void CCHgame::exitQuickSdk(unsigned int exitcall)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    //判断渠道是否有退出框
    bool b = QuickSDK::channelHasExitDialog();
    if (b) {
        auto engine = LuaEngine::getInstance();
        auto stack = engine->getLuaStack();
        stack->pushInt(0);
        stack->executeFunctionByHandler(exitcall, 1);
        stack->clean();
        QuickSDK::exit();
    } else {
        //创建游戏的退出框，点击确定后，调用QuickSDK::exit();
        auto engine = LuaEngine::getInstance();
        auto stack = engine->getLuaStack();
        stack->pushInt(1);
        stack->executeFunctionByHandler(exitcall, 1);
        stack->clean();
    }
#endif

}


void CCHgame::updateRoleInfoWith(int isCreateRole, std::string roleId, std::string roleName, 
    std::string roleLevel,std::string roleServerId, std::string roleServerName, 
    std::string roleBalance, std::string roleVipLevel, std::string rolePartyName, 
    std::string roleCreateTime, std::string partyName, std::string partyId, std::string gameRoleGender, 
    std::string gameRolePower, std::string partyRoleId, std::string professionId, std::string profession, std::string friendlist)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    struct GameRoleInfo gameRoleInfo;
    gameRoleInfo.gameRoleBalance = roleBalance;
    gameRoleInfo.gameRoleID = roleId;
    gameRoleInfo.gameRoleLevel = roleLevel;
    gameRoleInfo.gameRoleName = roleName;
    gameRoleInfo.partyName = partyName;
    gameRoleInfo.serverName = roleServerName;
    gameRoleInfo.serverID = roleServerId;
    gameRoleInfo.vipLevel = roleVipLevel;
    gameRoleInfo.roleCreateTime = roleCreateTime; //UC，当乐与1881渠道必传，值为10位数时间戳
    gameRoleInfo.partyId = partyId; //360渠道参数，设置帮派id，必须为整型字符串
    gameRoleInfo.gameRoleGender = gameRoleGender; //360渠道参数
    gameRoleInfo.gameRolePower = gameRolePower; //360渠道参数，设置角色战力，必须为整型字符串
    gameRoleInfo.partyRoleId = partyRoleId; //360渠道参数，设置角色在帮派中的id
    gameRoleInfo.partyRoleName = rolePartyName; //360渠道参数，设置角色在帮派中的名称
    gameRoleInfo.professionId = professionId; //360渠道参数，设置角色职业id，必须为整型字符串
    gameRoleInfo.profession = profession; //360渠道参数，设置角色职业名称
    gameRoleInfo.friendlist = friendlist; //360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190
    
    //创建角色
    if(isCreateRole == 0)
    {
        QuickSDK::updateRoleInfoWith(gameRoleInfo, true);
    }else{
    //进入游戏及角色升级
        QuickSDK::updateRoleInfoWith(gameRoleInfo, false);
    }
#endif

}

void CCHgame::payQuick(double amount, int count, std::string cpOrderID, std::string extrasParams, std::string goodsID, std::string goodsName, 
    std::string roleId, std::string roleName, 
    std::string roleLevel,std::string roleServerId, std::string roleServerName, 
    std::string roleBalance, std::string roleVipLevel, std::string partyName)
{

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    struct OrderInfo orderInfo;
    orderInfo.amount = amount;
    orderInfo.count = count;
    orderInfo.cpOrderID = cpOrderID;
    orderInfo.extrasParams = extrasParams;
    orderInfo.goodsID = goodsID;
    orderInfo.goodsName =goodsName;

    struct GameRoleInfo gameRoleInfo;
    gameRoleInfo.gameRoleBalance = roleBalance;
    gameRoleInfo.gameRoleID = roleId;
    gameRoleInfo.gameRoleLevel = roleLevel;
    gameRoleInfo.gameRoleName = roleName;
    gameRoleInfo.partyName = partyName;
    gameRoleInfo.serverName = roleServerName;
    gameRoleInfo.serverID = roleServerId;
    gameRoleInfo.vipLevel = roleVipLevel;

    QuickSDK::pay(orderInfo, gameRoleInfo);
#endif
    
}



// -------------- thinkingdata 统计 ------------------
void CCHgame::tDSetPublicProperties (std::string channelId, std::string roleId, std::string serverId, std::string level, std::string city)
{
    QuickGameMain::getInstance()->tDSetPublicProperties (channelId, roleId, serverId, level, city);
}
void CCHgame::tDSetAccountId (std::string account_id)
{
    QuickGameMain::getInstance()->tDSetAccountId (account_id);
}
void CCHgame::tDRemoveAccountId ()
{
    QuickGameMain::getInstance()->tDRemoveAccountId ();
}
void CCHgame::tDRegister ()
{
    QuickGameMain::getInstance()->tDRegister ();
}
void CCHgame::tDLogin ()
{
    QuickGameMain::getInstance()->tDLogin ();
}
void CCHgame::tDLoginOut (std::string online_time)
{
    QuickGameMain::getInstance()->tDLoginOut (online_time);
}
void CCHgame::tDLevelup (std::string roleLevel)
{
    QuickGameMain::getInstance()->tDLevelup (roleLevel);
}
void CCHgame::tDCreateRole(std::string roleType)
{
    QuickGameMain::getInstance()->tDCreateRole (roleType);
}
void CCHgame::tDOrderInit(std::string order_id, double pay_amount)
{
    QuickGameMain::getInstance()->tDOrderInit (order_id, pay_amount);
}
void CCHgame::tDOrderFinish(std::string order_id, std::string pay_method, double pay_amount)
{
    QuickGameMain::getInstance()->tDOrderFinish(order_id, pay_method, pay_amount);
}
void CCHgame::tDJoinGuild(std::string guild_id, std::string guild_name)
{
    QuickGameMain::getInstance()->tDJoinGuild(guild_id, guild_name);
}
void CCHgame::tDLeaveGuild(std::string guild_id, std::string guild_name, std::string leave_reason)
{
     QuickGameMain::getInstance()->tDLeaveGuild (guild_id, guild_name, leave_reason);
}
void CCHgame::tDCreateGuild(std::string guild_id, std::string guild_name)
{
     QuickGameMain::getInstance()->tDCreateGuild (guild_id, guild_name);
}
void CCHgame::tDArenaEnter (std::string rank)
{
    QuickGameMain::getInstance()->tDArenaEnter (rank);
}
void CCHgame::tDArenaWin (std::string rank, std::string get_honour)
{
    QuickGameMain::getInstance()->tDArenaWin (rank, get_honour);
}
void CCHgame::tDArenaLost (std::string rank, std::string get_honour)
{
    QuickGameMain::getInstance()->tDArenaLost (rank, get_honour);
}
void CCHgame::tDAddFriend (std::string target_role_id)
{
    QuickGameMain::getInstance()->tDAddFriend (target_role_id);
}
void CCHgame::tDChat (std::string target_role_id, std::string chat_channel)
{
    QuickGameMain::getInstance()->tDChat (target_role_id , chat_channel);
}
void CCHgame::tDDelFriend (std::string target_role_id)
{
    QuickGameMain::getInstance()->tDDelFriend (target_role_id);
}
void CCHgame::tDShopBuy(std::string shop_type, std::string token_type, std::string token_cost, std::string item_id)
{
    QuickGameMain::getInstance()->tDShopBuy (shop_type, token_type,token_cost,item_id);
}
void CCHgame::tDSommon (std::string sommon_type, std::string token_type, std::string token_cost)
{
    QuickGameMain::getInstance()->tDSommon (sommon_type, token_type,token_cost);
}
void CCHgame::tDSetUserProper (std::string role_name, std::string current_level)
{
    QuickGameMain::getInstance()->tDSetUserProper (role_name, current_level);
}
void CCHgame::tDAddUserProper (std::string total_revenue, std::string total_login)
{
    QuickGameMain::getInstance()->tDAddUserProper (total_revenue, total_login);
}













