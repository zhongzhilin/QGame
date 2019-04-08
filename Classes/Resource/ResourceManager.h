#ifndef __RESOURCEMANAGER_H__
#define __RESOURCEMANAGER_H__
#include "cocos2d.h"
#include "cocos-ext.h"
#include "cocostudio/CocoStudio.h"

using namespace cocostudio;

class ResourceManager : public cocos2d::Ref
{
public:
	ResourceManager();
	virtual ~ResourceManager();

	static ResourceManager * getInstance();

	virtual void init();

public:
	
#ifndef SVR_BUILD
	void preloadEffect(const char* soundFileName);
	unsigned int PlayEffect(const char* soundFileName, float vol = 1);
	void SetEffectVolumn(unsigned int soundId, float vol);
	void StopEffect(unsigned int effectId);

	void PauseAllEffects();
	void ResumeAllEffects();

	void StopAllEffects();

    void PlayBackgroundMusic(const char* soundFileName);
    void SetBackgroundMusicVolumn(float vol);
	void StopBackgroundMusic();

	void PauseBackgroundMusic();
	void ResumeBackgroundMusic();

	void EnableSound();
	void DisableSound();

	void UpdateSoundEnable();

	void timeBegin(std::string key);
	float timeEnd(std::string key);
	void timeBegin(int key);
	float timeEnd(int key);
	void showTimeLog(int key = 0);

    void showCurTime();

    void TestCPPCrash();
	virtual bool IsSoundEnable(void){ return mIsSoundEnable; }
#endif

protected:
	bool mIsSoundEnable; 
private:

#ifndef SVR_BUILD
	std::map<std::string, unsigned int> mSoundEffectMap;
	std::map<std::string, unsigned int> mSoundBGMusicMap;

    bool mIsPaused;
    bool mIsBgmChanged;
	std::string mBackgroundMusic;
#endif

	bool mPreLoad;
	typedef struct CallFuncTime
	{
		float total;
		int times;
		timeval begin;
	}CFT;
	std::map<std::string, CFT> mCallFuncTime;
    std::map<int, CFT> timetest; 
};

#endif