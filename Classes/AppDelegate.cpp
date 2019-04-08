#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "audio/include/SimpleAudioEngine.h"
#include "audio/include/AudioEngine.h"
#include "cocos2d.h"
#include "cocostudio/CocoStudio.h"
#include "lua_module_register.h"
#include "Base/Utils.h"
#include "AppMacros.h"
#include "AppPatchVer.h"
#include "luaext/lua_extensions.h"
//#include "ResUpdate/ResUpdateManager.h"
#include "Lua/AxLuaFunction.h"
#include "Resource/ResourceManager.h"
#include "LuaSupport/CCHgame.h"
#include "LuaSupport/lua_qgame_auto.hpp"
#include "LuaSupport/lua_qgame_manual.hpp"
#include "cocos2dx_extra.h"
#include "GtSDK/GexinDataReceiver.h"
#include "LuaSupport/lua_NotifyHelper_auto.hpp"
#include "LuaSupport/lua_binding.h"
#include "base/ZipUtils.h"
#include "renderer/CCTexture2D.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #include "MobClickCpp.h"
    #include "bugly/CrashReport.h"
    #include "bugly/lua/BuglyLuaAgent.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    #include "bugly/CrashReport.h"
    #include "bugly/lua/BuglyLuaAgent.h"
#endif


using namespace CocosDenshion;

USING_NS_CC;
using namespace std;
#define PATCH_DIR_KEY "patch-path-key"

extern "C"
{
    int hgame_lua_loader(lua_State *L)
    {
        std::string filename(luaL_checkstring(L, 1));
        size_t pos = filename.rfind(".lua");
        if (pos != std::string::npos)
        {
            filename = filename.substr(0, pos);
        }

        pos = filename.find_first_of(".");
        while (pos != std::string::npos)
        {
            filename.replace(pos, 1, "/");
            pos = filename.find_first_of(".");
        }
        filename.append(".lua");

        ssize_t codeBufferSize = 0;
        std::string fullPath = FileUtils::getInstance()->fullPathForFilename(filename.c_str());
        unsigned char* codeBuffer = FileUtils::getInstance()->getFileData(fullPath.c_str(), "rb", &codeBufferSize);

        if (codeBuffer)
        {

            CONFIG_DECRPYT(codeBuffer, codeBufferSize);

            if (luaL_loadbuffer(L, (char*)codeBuffer, codeBufferSize, filename.c_str()) != 0)
            {
                luaL_error(L, "error loading module %s from file %s :\n\t%s",
                    lua_tostring(L, 1), filename.c_str(), lua_tostring(L, -1));
            }
            else
            {
                //CCLOG("hgame_lua_loader %s", fullPath.c_str());
            }
            delete[] codeBuffer;
        }
        else
        {
            CCLOG("can not get file data of %s", filename.c_str());
        }

        return 1;
    }
}

static AppDelegate* instance = NULL;
static bool isSystemInited = false;

class DelayCallBack : public cocos2d::Ref
{
public:
    void delayCallback(float dt)
    {
        if (!isSystemInited)
        {
            instance->initSystem(); 
            isSystemInited = true;
        }
        
        Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
        
        release();
    }
};

AppDelegate::AppDelegate()
{
    instance = this;
//	m_dispathMsgNode = nullptr;
}

AppDelegate::~AppDelegate()
{
    cocos2d::experimental::AudioEngine::end();
//    SimpleAudioEngine::end();
//	if (m_dispathMsgNode != nullptr)
//	{
//		m_dispathMsgNode->stopDispatch();
//		m_dispathMsgNode->release();
//		m_dispathMsgNode = NULL;
//	}
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
   
    #if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        if (CCHgame::IsRelease() == 1)
        {
            CrashReport::initCrashReport("5438a422af", false, CrashReport::Verbose);
        }
    #endif
    
    #if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
        if (CCHgame::IsRelease() == 1)
        {
            CrashReport::initCrashReport("484a44301c");
        }
    #endif

    //try gexindataReceiver
    GexinDataReceiver *receiver = new GexinDataReceiver();
    delete receiver;

    // set default FPS
    Director* pDirector = Director::getInstance();
    pDirector->setAnimationInterval(1.0 / 60.0f);

    Utils::InitRand();

    Scene* s = Scene::create();

    pDirector->runWithScene(s);

    s->addChild(LayerColor::create(Color4B(0, 0, 0, 0)));
    DelayCallBack* obj = new DelayCallBack;
    pDirector->getScheduler()->schedule(schedule_selector(DelayCallBack::delayCallback), obj, 0, 0, 0, false);
    
    // 友盟统计ios
    #if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        MOBCLICKCPP_START_WITH_APPKEY_AND_CHANNEL("5c0a4476b465f541920000f1", "appstore");
    #endif
    
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    if (!isSystemInited)
    {
        return;
    }

    Director::getInstance()->stopAnimation();
//    Director::getInstance()->pause();

    // if you use SimpleAudioEngine, it must be pause
//    ResourceManager::getInstance()->PauseBackgroundMusic();
    // cocos2d::experimental::AudioEngine::pauseAll();
   // ResourceManager::getInstance()->PauseAllEffects();

    //AxLuaVoidFunc("GLFRun")("global.funcGame.OnPause");
    
    
    
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    LuaStack* pStack = engine->getLuaStack();
    lua_State* pLuaSt = pStack->getLuaState();
    lua_getglobal(pLuaSt,"gevent_onpause");
    lua_pcall(pLuaSt, 0,0,0);

    
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    if (!isSystemInited)
    {
        return;
    }

    Director::getInstance()->startAnimation();
//    Director::getInstance()->resume();

    // if you use SimpleAudioEngine, it must resume here
    //    ResourceManager::getInstance()->ResumeAllEffects();
    // cocos2d::experimental::AudioEngine::resumeAll();
//    ResourceManager::getInstance()->ResumeBackgroundMusic();
    
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    LuaStack* pStack = engine->getLuaStack();
    lua_State* pLuaSt = pStack->getLuaState();
    lua_getglobal(pLuaSt,"gevent_onresume");
    lua_pcall(pLuaSt, 0,0,0);
    
    //AxLuaVoidFunc("GLFRun")("global.funcGame.OnResume");
}

void AppDelegate::applicationWillPause()
{
    if (!isSystemInited)
    {
        return;
    }
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    LuaStack* pStack = engine->getLuaStack();
    lua_State* pLuaSt = pStack->getLuaState();
    lua_getglobal(pLuaSt,"gevent_onIosSmallPause");
    lua_pcall(pLuaSt, 0,0,0);
}


void AppDelegate::applicationWillResume()
{
    if (!isSystemInited)
    {
        return;
    }
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    LuaStack* pStack = engine->getLuaStack();
    lua_State* pLuaSt = pStack->getLuaState();
    lua_getglobal(pLuaSt,"gevent_onIosSmallResume");
    lua_pcall(pLuaSt, 0,0,0);
}

void AppDelegate::initSystem(void)
{
    initResource();
    initScriptEngine();
    initGame();
}

bool AppDelegate::initScriptEngine(void)
{

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);

    LuaStack* pStack = engine->getLuaStack();

    std::string key1 = "FNb";
    lua_State* pLuaSt = pStack->getLuaState();	
	
	lua_module_register(pLuaSt);
    std::string key2 = "G5PIm@";

    pStack->addLuaLoader(hgame_lua_loader);
    
    std::string key3 = "9y9";

    // add by wuwx
    std::string key4 = "*m6Z";
	const char* sign = "qgame";
	ResourcesDecode::getInstance()->setXTHHHHKey((key1+key2+key3+key4).c_str(), strlen((key1+key2+key3+key4).c_str()), sign, strlen(sign));

    // pStack->setXXTEAKeyAndSign(key, strlen(key), sign, strlen(sign));
//    pStack->setXXTEAKeyAndSign("2dxLua", strlen("2dxLua"), "XXTEA", strlen("XXTEA"));
    
    luaopen_lua_extensions(pLuaSt);
    luaopen_lua_extra(pLuaSt);
	register_all_qgame(pLuaSt);
    register_qgame_CCHgame_manual(pLuaSt);
    register_all_NotifyHelper(pLuaSt);
    
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    lua_register_mobclick_module(pLuaSt);
    
    if (CCHgame::IsRelease() == 1)
    {
        auto engine = LuaEngine::getInstance();
        ScriptEngineManager::getInstance()->setScriptEngine(engine);
        BuglyLuaAgent::registerLuaExceptionHandler(engine);
    }
    
#endif


    return true;
}

bool AppDelegate::initResource(void)
{
    std::vector<std::string> resSearchPaths;
    
    
    FileUtils* fileUtils = FileUtils::getInstance();
    std::string patchPath = fileUtils->getWritablePath() + "patch/";
    
    if(!fileUtils->isDirectoryExist(patchPath)){
        fileUtils->createDirectory(patchPath);
    }
    
//    patchPath = patchPath + ResUpdateManager::getPatchDir();
//    patchPath = patchPath + ResUpdateManager::getCurVerDir();
    
    
    resSearchPaths.push_back(patchPath);
    resSearchPaths.push_back(patchPath + "res");
    resSearchPaths.push_back(patchPath + "res/common");
    resSearchPaths.push_back(patchPath + "res/common/base");
    resSearchPaths.push_back(patchPath + "res/common/base/pack");
    resSearchPaths.push_back(patchPath + "asset");
    resSearchPaths.push_back(patchPath + "asset/ui");
    resSearchPaths.push_back(patchPath + "asset/xml");
    resSearchPaths.push_back(patchPath + "asset/logo");

    resSearchPaths.push_back(fileUtils->getWritablePath());

    resSearchPaths.push_back("res");
    resSearchPaths.push_back("res/common");
    resSearchPaths.push_back("res/common/base");
    resSearchPaths.push_back("res/common/base/pack");
    resSearchPaths.push_back("asset");
    resSearchPaths.push_back("asset/ui");
    resSearchPaths.push_back("asset/xml");
    resSearchPaths.push_back("asset/logo");

    resSearchPaths.push_back("src");
    
    fileUtils->setSearchPaths(resSearchPaths);
    
    auto isLowQuality = UserDefault::getInstance()->getBoolForKey("isLowQuality");
    if(isLowQuality){
        Texture2D::setQualityLevel(2);
    }else{
        Texture2D::setQualityLevel(1);
    }

//    ZipUtils::unzip(fileUtils->fullPathForFilename("zip/res.zip").c_str(), fileUtils->getWritablePath().c_str(),NULL);

    return true;
}

bool AppDelegate::initGame(void)
{
//    ResUpdateManager* mgr = new ResUpdateManager(1, "");
//    if (mgr->isNeedBackup())
//    {
//        mgr->restoreBackup();
//    }
//    delete mgr;

    LuaEngine* pEngine = LuaEngine::getInstance();
    pEngine->executeString("require \"res.app_boot\"");
    //pEngine->executeScriptFile("main.lua");

    //Director::getInstance()->getKeypadDispatcher()->addDelegate(this);
    
    cocos2d::experimental::AudioEngine::lazyInit();

//	m_dispathMsgNode = DispatchMsgNode::create();
//	m_dispathMsgNode->retain();
//	m_dispathMsgNode->startDispatch();
    return true;
}

void AppDelegate::onMemoryWarning()
{
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    LuaStack* pStack = engine->getLuaStack();
    lua_State* pLuaSt = pStack->getLuaState();
    lua_getglobal(pLuaSt,"gevent_on_memory_warning");
    lua_pcall(pLuaSt, 0,0,0);
}

void AppDelegate::applicationRestart()
{
//    SimpleAudioEngine::getInstance()->stopAllEffects();
//    SimpleAudioEngine::getInstance()->stopBackgroundMusic(true);
    cocos2d::experimental::AudioEngine::stopAll();

    Director* director = Director::getInstance();

    //cocostudio::DataReaderHelper::getInstance()->clear();

    director->getScheduler()->scheduleUpdate(director->getActionManager(), Scheduler::PRIORITY_SYSTEM, false);

    director->purgeCachedData();

    ScriptEngineManager::getInstance()->removeScriptEngine();

    initSystem();
    
    auto isLowQuality = UserDefault::getInstance()->getBoolForKey("isLowQuality");
    if(isLowQuality){
        Texture2D::setQualityLevel(2);
    }else{
        Texture2D::setQualityLevel(1);
    }
}
