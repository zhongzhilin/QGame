#ifndef __ResUpdateManager__
#define __ResUpdateManager__

#include "cocos2d.h"
// #include "ExtensionMacros.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WINRT) && (CC_TARGET_PLATFORM != CC_PLATFORM_WP8)
#include <string>
#include <curl/curl.h>
#include <pthread.h>

class ResUpdateManagerDelegateProtocol;

/*
 *  This class is used to auto update resources, such as pictures or scripts.
 *  The updated package should be a zip file. And there should be a file named
 *  version in the server, which contains version code.
 *  @js NA
 *  @lua NA
 */
class ResUpdateManager : public cocos2d::Ref
{
public:
    enum ErrorCode
    {
		// Error caused by creating a file to store downloaded data
		kCreateFile,
		/** Error caused by network
		-- network unavaivable
		-- timeout
		-- ...
		*/
		kNetwork,
		/** There is not a new version
		*/
		kNoNewVersion,
		/** Error caused in uncompressing stage
		-- can not open zip file
		-- can not read file global information
		-- can not read file information
		-- can not create a directory
		-- ...
		*/
		kBackup,
		/** Error caused in uncompressing stage
		-- can not open zip file
		-- can not read file global information
		-- can not read file information
		-- can not create a directory
		-- ...
		*/
		kUncompress,
    };

	static const char* getCurVerDir();
	static const char* getPatchDir();

	ResUpdateManager(int version, const char* packageUrl = NULL);
    
	virtual ~ResUpdateManager();

    virtual void update();
    
    const char* getPackageUrl() const;
    void setPackageUrl(const char* packageUrl);

    const char* getStoragePath() const;
    void setStoragePath(const char* storagePath);
    
	void setDelegate(ResUpdateManagerDelegateProtocol *delegate);
	void setScriptDelegate(int erroHandler, int progressHandler, int successHandler);
    
    void setConnectionTimeout(unsigned int timeout);
    unsigned int getConnectionTimeout();
    
    friend void* assetsManagerDownloadAndUncompress(void*);
    friend int assetsManagerProgressFunc(void *, double, double, double, double);

	bool isNeedBackup();
	bool backup();
    void restoreBackup();

    static bool createDirectory(const char *path);
    
protected:
    bool downLoad();
    void checkStoragePath();
	bool checkPath(const char* path);
    bool uncompress();
    void setSearchPath();
    void sendErrorMessage(ErrorCode code);

private:
    typedef struct _Message
    {
    public:
        _Message() : what(0), obj(NULL){}
        unsigned int what; // message type
        void* obj;
    } Message;
    
    class Helper : public cocos2d::Ref
    {
    public:
        Helper();
        ~Helper();
        
        virtual void update(float dt);
        bool updateLogic(float dt);
        void sendMessage(Message *msg);
        
    private:
        void handleUpdateSucceed(Message *msg);
        
        std::list<Message*> *_messageQueue;
        pthread_mutex_t _messageQueueMutex;
    };
    
private:
        
    //! The version of downloaded resources.
    int _version;
    std::string _packageUrl;
	//! The path to store downloaded resources.
	std::string _storagePath;
	std::string _writablePath;

    CURL *_curl;
    Helper *_schedule;
    pthread_t *_tid;
    unsigned int _connectionTimeout;
    
	ResUpdateManagerDelegateProtocol *_delegate; // weak reference

	std::map<std::string, bool> m_mDirMap;
	std::vector<std::string> m_vAddedFiles;
};

class ResUpdateManagerDelegateProtocol: public cocos2d::Ref
{
public:

	ResUpdateManagerDelegateProtocol() {};
	virtual ~ResUpdateManagerDelegateProtocol() {};

    virtual void onError(ResUpdateManager::ErrorCode errorCode) {};
    virtual void onProgress(int percent) {};
    virtual void onSuccess() {};
};

class ResUpdateManagerScriptHandler : public ResUpdateManagerDelegateProtocol
{
public:
	ResUpdateManagerScriptHandler();
	ResUpdateManagerScriptHandler(int erroHandler, int progressHandler, int successHandler);
	~ResUpdateManagerScriptHandler();

	virtual void onError(ResUpdateManager::ErrorCode errorCode);
	virtual void onProgress(int percent);
	virtual void onSuccess();

private:
	int m_iErrorHandlerId;
	int m_iProgressHandlerId;
	int m_iSuccessHandlerId;
};

#endif // CC_TARGET_PLATFORM != CC_PLATFORM_WINRT
#endif /* defined(__ResUpdateManager__) */
