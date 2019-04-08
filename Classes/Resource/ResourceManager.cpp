#include "ResourceManager.h"
#include "AppMacros.h"
#include "Base/Utils.h"
// #include "DBUtil.h"
#include "extensions/cocos-ext.h"
#include "cocostudio/CocoStudio.h"

#ifndef SVR_BUILD
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
using namespace cocostudio;
#endif

static ResourceManager * Manager = NULL;

using namespace std;
USING_NS_CC;

const char* CONFIG_DB = "config.db";

const char* USER_SOUND_ENABLE_KEY = "user_sound_enable";


ResourceManager * ResourceManager::getInstance()
{
	if (!Manager)
	{
		Manager = new ResourceManager();
		Manager->init();
	}

	return Manager;
}

ResourceManager::ResourceManager()
{
#ifndef SVR_BUILD
    mIsSoundEnable = UserDefault::getInstance()->getBoolForKey(USER_SOUND_ENABLE_KEY, true);
    mIsPaused = false;
    mIsBgmChanged = false;
#endif
}

ResourceManager::~ResourceManager()
{
}

void ResourceManager::init()
{
}
#ifndef SVR_BUILD

void ResourceManager::preloadEffect(const char* soundFileName)
{
	//FileUtils* fileUtils = FileUtils::getInstance();

	//std::string soundFileNameStr(soundFileName);
	//if (soundFileNameStr.empty() || !fileUtils->isFileExist(fileUtils->fullPathForFilename(soundFileName)))
	//{
	//	return ;
	//}
	//SimpleAudioEngine::getInstance()->preloadEffect(fileUtils->fullPathForFilename(soundFileName).c_str());
}


unsigned int ResourceManager::PlayEffect(const char* soundFileName, float vol/* = 1*/)
{
    FileUtils* fileUtils = FileUtils::getInstance();

	std::string soundFileNameStr(soundFileName);

	if (!mIsSoundEnable || vol <= 0 || soundFileNameStr.empty() || !fileUtils->isFileExist(fileUtils->fullPathForFilename(soundFileName)))
	{
		return 0;
	}
    unsigned int soundId = -1;
    soundId = SimpleAudioEngine::getInstance()->playEffect(fileUtils->fullPathForFilename(soundFileName).c_str(), false);
	mSoundEffectMap[soundFileNameStr] = soundId;

	return soundId;
}

void ResourceManager::SetEffectVolumn(unsigned int soundId, float vol)
{
    if (vol == 0)
    {
        return;
    }
    SimpleAudioEngine::getInstance()->setEffectsVolume(vol);
	//SimpleAudioEngine::getInstance()->setEffectVolume(soundId, vol);
}

void ResourceManager::StopEffect(unsigned int effectId)
{
    SimpleAudioEngine::getInstance()->stopEffect(effectId);
}

void ResourceManager::PauseAllEffects()
{
    if (!mIsPaused)
    {
        SimpleAudioEngine::getInstance()->pauseAllEffects();
        mIsPaused = true;
    }
}

void ResourceManager::ResumeAllEffects()
{
	if (!mIsSoundEnable)
	{
		return;
    }

    if (mIsPaused)
    {
        SimpleAudioEngine::getInstance()->resumeAllEffects();
        mIsPaused = false;
    }
}

void ResourceManager::PlayBackgroundMusic(const char* soundFileName)
{
	mBackgroundMusic = (soundFileName != NULL ? soundFileName : mBackgroundMusic);

	FileUtils* fileUtils = FileUtils::getInstance();

    mIsBgmChanged = true;

	if (!mIsSoundEnable || mBackgroundMusic.empty() || !fileUtils->isFileExist(fileUtils->fullPathForFilename(mBackgroundMusic.c_str())))
	{
		return;
	}
	
	SimpleAudioEngine::getInstance()->playBackgroundMusic(fileUtils->fullPathForFilename(mBackgroundMusic.c_str()).c_str(), true);
}

void ResourceManager::SetBackgroundMusicVolumn(float vol)
{
    SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(vol);
}

void ResourceManager::StopBackgroundMusic()
{
	SimpleAudioEngine::getInstance()->stopBackgroundMusic(true);
}

void ResourceManager::PauseBackgroundMusic()
{
	SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

void ResourceManager::ResumeBackgroundMusic()
{
	if (!mIsSoundEnable)
	{
		return;
	}
	SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}

void ResourceManager::StopAllEffects()
{
	SimpleAudioEngine::getInstance()->stopAllEffects();
}

void ResourceManager::EnableSound()
{
	mIsSoundEnable = true;
    if (SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying() && !mIsBgmChanged)
	{
		ResumeBackgroundMusic();
	}
	else if (!mBackgroundMusic.empty())
	{
		PlayBackgroundMusic(mBackgroundMusic.c_str());
        mIsBgmChanged = false;
	}
	UpdateSoundEnable();
}

void ResourceManager::DisableSound()
{
	mIsSoundEnable = false;
	StopAllEffects();
	if (SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying())
	{
		PauseBackgroundMusic();
	}
	UpdateSoundEnable();
}

void ResourceManager::UpdateSoundEnable()
{
	UserDefault::getInstance()->setBoolForKey(USER_SOUND_ENABLE_KEY, mIsSoundEnable);
}

static timeval now;

void ResourceManager::timeBegin(std::string key)
{	
	if (mCallFuncTime.find(key) == mCallFuncTime.end())
	{
		CFT * b = &mCallFuncTime[key];
		b->total = 0;
		b->times = 0;
	}	
	CFT * c = &mCallFuncTime[key];

    gettimeofday(&c->begin, NULL);
}

float ResourceManager::timeEnd(std::string key)
{
    gettimeofday(&now, NULL);
	CFT * c = &mCallFuncTime[key];
	float time = (now.tv_sec - c->begin.tv_sec) * 1000 + (now.tv_usec - c->begin.tv_usec) * 0.001;
	c->times++;		
	c->total += time;
	return time;
}

void ResourceManager::timeBegin(int key)
{
	if (timetest.find(key) == timetest.end())
	{
		CFT * b = &timetest[key];
		b->total = 0;
		b->times = 0;
	}
	CFT * c = &timetest[key];
    gettimeofday(&c->begin, NULL);
}

float ResourceManager::timeEnd(int key)
{
    gettimeofday(&now, NULL);
	CFT * c = &timetest[key];
	float time = (now.tv_sec - c->begin.tv_sec) * 1000 + (now.tv_usec - c->begin.tv_usec) * 0.001;
	c->times++;
	c->total += time;
	return time;
}

void ResourceManager::showTimeLog(int key/*=0*/)
{
// 	static int cKey = 0;
// 	if (mCallFuncTime.size() == 0 && timetest.size() == 0)
// 	{
// 		cKey = cKey * 10 + key;
// 		if (cKey == 1234567)
// 		{
// 			
// 		}
// 	}
	for (std::map<std::string, CFT>::iterator i = mCallFuncTime.begin(); i != mCallFuncTime.end();)
	{
		CFT c = i->second;
		CCLOG("----TimeTest---- total:%9.3f, \ttimes:%d, \tAverage:%9.3f ---- %s", c.total, c.times, c.total / c.times, i->first.c_str());
		mCallFuncTime.erase(i++);
	}
	for (std::map<int, CFT>::iterator i = timetest.begin(); i != timetest.end();)
	{
		CFT c = i->second;
        CCLOG("----TimeTest---- total:%9.3f, \ttimes:%d, \tAverage:%9.3f ---- %d", c.total, c.times, c.total / c.times, i->first);
		timetest.erase(i++);
	}

	mCallFuncTime.clear();
	timetest.clear();
}

void ResourceManager::showCurTime()
{
    timeval time;
    gettimeofday(&time, NULL);
    CCLOG("==============> curTime %ld.%d", time.tv_sec, time.tv_usec);
}

void ResourceManager::TestCPPCrash()
{
    ResourceManager* aa = NULL;
    aa->retain();
}

#endif // !SVR_BUILD
