#include "ResUpdateManager.h"
#include "CCLuaEngine.h"
#include "AppPatchVer.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WINRT) && (CC_TARGET_PLATFORM != CC_PLATFORM_WP8)
#include <curl/curl.h>
#include <curl/easy.h>

#include <stdio.h>
#include <vector>

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#endif

#include "unzip.h"

using namespace cocos2d;
using namespace std;

#define TEMP_PACKAGE_FILE_NAME    "hgame-update-temp-package.zip"
#define BACKUP_PACKAGE_FILE_NAME    "hgame-update-backup-package.zip"
#define BUFFER_SIZE    8192
#define MAX_FILENAME   512

// Message type
#define RESUPDATEMANAGER_MESSAGE_UPDATE_SUCCEED                0
#define RESUPDATEMANAGER_MESSAGE_RECORD_DOWNLOADED_VERSION     1
#define RESUPDATEMANAGER_MESSAGE_PROGRESS                      2
#define RESUPDATEMANAGER_MESSAGE_ERROR                         3

#define PATCH_DIR            "patch/"
#define DOWNLOAD_ACT_DIR         "download/activity"

// Some data struct for sending messages

struct ErrorMessage
{
    ResUpdateManager::ErrorCode code;
    ResUpdateManager* manager;
};

struct ProgressMessage
{
    int percent;
    ResUpdateManager* manager;
};

// Implementation of ResUpdateManager

const char* ResUpdateManager::getCurVerDir()
{
    return CUR_VERSION_DIR;
}

const char* ResUpdateManager::getPatchDir()
{
    return PATCH_DIR;
}

ResUpdateManager::ResUpdateManager(int version, const char* packageUrl/* =NULL */)
: _version(version)
, _packageUrl(packageUrl)
, _curl(NULL)
, _tid(NULL)
, _connectionTimeout(0)
, _delegate(NULL)
{
    _writablePath = FileUtils::getInstance()->getWritablePath();
    _storagePath = std::string(getPatchDir()) + getCurVerDir();
    checkStoragePath();
    _schedule = new Helper();
}

ResUpdateManager::~ResUpdateManager()
{
    CC_SAFE_RELEASE_NULL(_schedule);
    CC_SAFE_RELEASE_NULL(_delegate);
}

void ResUpdateManager::checkStoragePath()
{
#if CC_TARGET_PLATFORM != CC_PLATFORM_WIN32
    if (_storagePath.size() > 0 && _storagePath[_storagePath.size() - 1] != '/')
    {
        _storagePath.append("/");
    }
#else
    if (_storagePath.size() > 0 && _storagePath[_storagePath.size() - 1] != '\\')
    {
        _storagePath.append("\\");
    }
#endif
    if (!checkPath(_storagePath.c_str()))
    {
        CCLOG("storagePath %s check error!", _storagePath.c_str());
    }

    std::string temp = DOWNLOAD_ACT_DIR;
#if CC_TARGET_PLATFORM != CC_PLATFORM_WIN32
    if (temp.size() > 0 && temp[temp.size() - 1] != '/')
    {
        temp.append("/");
    }
#else
    if (temp.size() > 0 && temp[temp.size() - 1] != '\\')
    {
        temp.append("\\");
    }
#endif
    if (!checkPath(temp.c_str()))
    {
        CCLOG("download activity %s check error!", temp.c_str());
    }
}

void* assetsManagerDownloadAndUncompress(void *data)
{
    // ResUpdateManager* self = (ResUpdateManager*)data;

    // do
    // {
    //     if (!self->downLoad()) break;

    //     // Record downloaded version.
    //     ResUpdateManager::Message *msg1 = new ResUpdateManager::Message();
    //     msg1->what = RESUPDATEMANAGER_MESSAGE_RECORD_DOWNLOADED_VERSION;
    //     msg1->obj = self;
    //     self->_schedule->sendMessage(msg1);

    //     if (!self->backup())
    //     {
    //         self->sendErrorMessage(ResUpdateManager::kBackup);
    //         break;
    //     }

    //     // Uncompress zip file.
    //     if (!self->uncompress())
    //     {
    //         self->restoreBackup();
    //         self->sendErrorMessage(ResUpdateManager::kUncompress);
    //         break;
    //     }

    //     // Record updated version and remove downloaded zip file
    //     ResUpdateManager::Message *msg2 = new ResUpdateManager::Message();
    //     msg2->what = RESUPDATEMANAGER_MESSAGE_UPDATE_SUCCEED;
    //     msg2->obj = self;
    //     self->_schedule->sendMessage(msg2);
    // } while (0);

    // if (self->_tid)
    // {
    //     delete self->_tid;
    //     self->_tid = NULL;
    // }

    return NULL;
}

bool ResUpdateManager::isNeedBackup()
{
    return FileUtils::getInstance()->isFileExist(_writablePath + _storagePath + BACKUP_PACKAGE_FILE_NAME);
}

void ResUpdateManager::update()
{
    // if (_tid) return;

    // // 1. Urls of package and version should be valid;
    // // 2. Package should be a zip file.
    // if (_packageUrl.size() == 0)
    // {
    //     CCLOG("no version file url, or no package url, or the package is not a zip file");
    //     return;
    // }

    // _tid = new pthread_t();
    // pthread_create(&(*_tid), NULL, assetsManagerDownloadAndUncompress, this);
}

bool ResUpdateManager::backup()
{
    // Open the zip file
 //    string outFileName = _writablePath + _storagePath + TEMP_PACKAGE_FILE_NAME;
 //    unzFile zipfile = unzOpen(outFileName.c_str());
 //    if (!zipfile)
 //    {
 //        CCLOG("can not open downloaded zip file %s", outFileName.c_str());
 //        return false;
 //    }

 //    string backupFileName = _writablePath + _storagePath + BACKUP_PACKAGE_FILE_NAME;
	// zipFile backupZipfile = zipOpen(backupFileName.c_str(), 0);
 //    if (!backupZipfile)
 //    {
 //        CCLOG("can not open backup zip file %s", backupFileName.c_str());
 //        return false;
 //    }

 //    // Get info about the zip file
 //    unz_global_info global_info;
 //    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
 //    {
 //        CCLOG("can not read file global info of %s", outFileName.c_str());
 //        unzClose(zipfile);
 //        zipClose(backupZipfile, NULL);
 //        return false;
 //    }

 //    CCLOG("start backup");

 //    // Loop to extract all files.
 //    uLong i;
 //    unz_file_info fileInfo;
 //    char fileName[MAX_FILENAME];
 //    string fullPath;

 //    for (i = 0; i < global_info.number_entry; ++i)
 //    {
 //        // Get info about current file.
 //        if (unzGetCurrentFileInfo(zipfile,
 //            &fileInfo,
 //            fileName,
 //            MAX_FILENAME,
 //            NULL,
 //            0,
 //            NULL,
 //            0) != UNZ_OK)
 //        {
 //            CCLOG("can not read file info");
 //            unzClose(zipfile);
 //            zipClose(backupZipfile, NULL);
 //            return false;
 //        }

 //        fullPath = _writablePath + _storagePath + fileName;

 //        // Check if this entry is a directory or a file.
 //        const size_t filenameLength = strlen(fileName);
 //        CCLOG("backup file %s", fileName);
 //        if (fileName[filenameLength - 1] == '/')
 //        {
 //            // Entry is a directory, so create it.
 //            // If the directory exists, it will failed silently.
 //            if (!checkPath((_storagePath + fileName).c_str()))
 //            {
 //                CCLOG("can not create directory %s", fullPath.c_str());
 //                unzClose(zipfile);
 //                zipClose(backupZipfile, NULL);
 //                return false;
 //            }
 //        }
 //        else
 //        {

 //            // Entry is a file, so extract it.

 //            // Open current file.
 //            if (unzOpenCurrentFile(zipfile) != UNZ_OK)
 //            {
 //                CCLOG("can not open file %s", fileName);
 //                unzClose(zipfile);
 //                zipClose(backupZipfile, NULL);
 //                return false;
 //            }

 //            // store old existed file to backup zip.
 //            FILE * backupFile = fopen(fullPath.c_str(), "rb");
 //            if (backupFile)
 //            {
 //                //Ñ¹ËõÎÄ¼þ
 //                zip_fileinfo FileInfo;
 //                memset(&FileInfo, 0, sizeof(FileInfo));
 //                zipOpenNewFileInZip(backupZipfile, fileName, &FileInfo, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_BEST_SPEED);
 //                CCLOG("add file %s to zip %s", fileName, BACKUP_PACKAGE_FILE_NAME);

 //                fseek(backupFile, 0, SEEK_END);
 //                long pSize = ftell(backupFile);
 //                fseek(backupFile, 0, SEEK_SET);
 //                unsigned char* pBuffer = new unsigned char[pSize];
 //                pSize = fread(pBuffer, 1, pSize, backupFile);
 //                fclose(backupFile);

 //                //Ð´ÈëÑ¹ËõÎÄ¼þ
 //                zipWriteInFileInZip(backupZipfile, pBuffer, pSize);
 //                delete [] pBuffer;

 //                //¹Ø±Õµ±Ç°ÎÄ¼þ
 //                zipCloseFileInZip(backupZipfile);
 //            }
 //            else
 //            {
 //                m_vAddedFiles.push_back(fullPath);
 //            }
 //        }

 //        unzCloseCurrentFile(zipfile);

 //        // Goto next entry listed in the zip file.
 //        if ((i + 1) < global_info.number_entry)
 //        {
 //            if (unzGoToNextFile(zipfile) != UNZ_OK)
 //            {
 //                CCLOG("can not read next file");
 //                unzClose(zipfile);
 //                zipClose(backupZipfile, NULL);
 //                return false;
 //            }
 //        }
 //    }

 //    CCLOG("end backup");
 //    unzClose(zipfile);
 //    zipClose(backupZipfile, NULL);

    return true;
}

bool ResUpdateManager::uncompress()
{
    // // Open the zip file
    // string outFileName = _writablePath + _storagePath + TEMP_PACKAGE_FILE_NAME;
    // unzFile zipfile = unzOpen(outFileName.c_str());
    // if (!zipfile)
    // {
    //     CCLOG("uncompress can not open downloaded zip file %s", outFileName.c_str());
    //     return false;
    // }

    // // Get info about the zip file
    // unz_global_info global_info;
    // if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    // {
    //     CCLOG("uncompress can not read file global info of %s", outFileName.c_str());
    //     unzClose(zipfile);
    //     return false;
    // }

    // // Buffer to hold data read from the zip file
    // char readBuffer[BUFFER_SIZE];

    // CCLOG("start uncompressing");

    // // Loop to extract all files.
    // uLong i;
    // for (i = 0; i < global_info.number_entry; ++i)
    // {
    //     // Get info about current file.
    //     unz_file_info fileInfo;
    //     char fileName[MAX_FILENAME];
    //     if (unzGetCurrentFileInfo(zipfile,
    //         &fileInfo,
    //         fileName,
    //         MAX_FILENAME,
    //         NULL,
    //         0,
    //         NULL,
    //         0) != UNZ_OK)
    //     {
    //         CCLOG("can not read file info");
    //         unzClose(zipfile);
    //         return false;
    //     }

    //     string fullPath = _writablePath + _storagePath + fileName;

    //     // Check if this entry is a directory or a file.
    //     const size_t filenameLength = strlen(fileName);
    //     CCLOG("extract file %s", fileName);
    //     if (fileName[filenameLength - 1] == '/')
    //     {
    //         // Entry is a directory, so create it.
    //         // If the directory exists, it will failed silently.
    //         if (!checkPath((_storagePath + fileName).c_str()))
    //         {
    //             CCLOG("can not create directory %s", fullPath.c_str());
    //             unzClose(zipfile);
    //             return false;
    //         }
    //     }
    //     else
    //     {
    //         if (!checkPath((_storagePath + fileName).c_str()))
    //         {
    //             CCLOG("path for file %s create failed!", (_storagePath + fileName).c_str());
    //             unzClose(zipfile);
    //             return false;
    //         }

    //         // Entry is a file, so extract it.

    //         // Open current file.
    //         if (unzOpenCurrentFile(zipfile) != UNZ_OK)
    //         {
    //             CCLOG("can not open file %s", fileName);
    //             unzClose(zipfile);
    //             return false;
    //         }

    //         // Create a file to store current file.
    //         FILE *out = fopen(fullPath.c_str(), "wb");
    //         if (!out)
    //         {
    //             CCLOG("can not open destination file %s", fullPath.c_str());
    //             unzCloseCurrentFile(zipfile);
    //             unzClose(zipfile);
    //             return false;
    //         }

    //         // Write current file content to destinate file.
    //         int error = UNZ_OK;
    //         do
    //         {
    //             error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
    //             if (error < 0)
    //             {
    //                 CCLOG("can not read zip file %s, error code is %d", fileName, error);
    //                 unzCloseCurrentFile(zipfile);
    //                 unzClose(zipfile);
    //                 return false;
    //             }

    //             if (error > 0)
    //             {
    //                 fwrite(readBuffer, error, 1, out);
    //             }
    //         } while (error > 0);

    //         fclose(out);
    //     }

    //     unzCloseCurrentFile(zipfile);

    //     // Goto next entry listed in the zip file.
    //     if ((i + 1) < global_info.number_entry)
    //     {
    //         if (unzGoToNextFile(zipfile) != UNZ_OK)
    //         {
    //             CCLOG("can not read next file");
    //             unzClose(zipfile);
    //             return false;
    //         }
    //     }
    // }

    // CCLOG("end uncompressing");
    // unzClose(zipfile);

    // // Delete unloaded backup zip file.
    // std::string backupZipfileName = _writablePath + _storagePath + BACKUP_PACKAGE_FILE_NAME;
    // if (remove(backupZipfileName.c_str()) != 0)
    // {
    //     CCLOG("can not remove backup zip file %s", backupZipfileName.c_str());
    // }

    return true;
}

void ResUpdateManager::restoreBackup()
{
    // Open the zip file
    // string backupFileName = _writablePath + _storagePath + BACKUP_PACKAGE_FILE_NAME;
    // unzFile zipfile = unzOpen(backupFileName.c_str());
    // if (!zipfile)
    // {
    //     CCLOG("restoreBackup can not open backup zip file %s", backupFileName.c_str());
    //     return;
    // }

    // // Get info about the zip file
    // unz_global_info global_info;
    // if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    // {
    //     CCLOG("restoreBackup can not read file global info of %s", backupFileName.c_str());
    //     unzClose(zipfile);
    //     return;
    // }

    // // Buffer to hold data read from the zip file
    // char readBuffer[BUFFER_SIZE];

    // CCLOG("start restoreBackup");

    // // Loop to extract all files.
    // uLong i;
    // for (i = 0; i < global_info.number_entry; ++i)
    // {
    //     // Get info about current file.
    //     unz_file_info fileInfo;
    //     char fileName[MAX_FILENAME];
    //     if (unzGetCurrentFileInfo(zipfile,
    //         &fileInfo,
    //         fileName,
    //         MAX_FILENAME,
    //         NULL,
    //         0,
    //         NULL,
    //         0) != UNZ_OK)
    //     {
    //         CCLOG("can not read file info");
    //         unzClose(zipfile);
    //         return;
    //     }

    //     string fullPath = _writablePath + _storagePath + fileName;

    //     // Check if this entry is a directory or a file.
    //     const size_t filenameLength = strlen(fileName);
    //     CCLOG("extract file %s", fileName);

    //     // Entry is a file, so extract it.

    //     // Open current file.
    //     if (unzOpenCurrentFile(zipfile) != UNZ_OK)
    //     {
    //         CCLOG("can not open file %s", fileName);
    //         unzClose(zipfile);
    //         return;
    //     }

    //     // Create a file to store current file.
    //     FILE *out = fopen(fullPath.c_str(), "wb");
    //     if (!out)
    //     {
    //         CCLOG("can not open destination file %s", fullPath.c_str());
    //         unzCloseCurrentFile(zipfile);
    //         unzClose(zipfile);
    //         return;
    //     }

    //     // Write current file content to destinate file.
    //     int error = UNZ_OK;
    //     do
    //     {
    //         error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
    //         if (error < 0)
    //         {
    //             CCLOG("can not read zip file %s, error code is %d", fileName, error);
    //             unzCloseCurrentFile(zipfile);
    //             unzClose(zipfile);
    //             return;
    //         }

    //         if (error > 0)
    //         {
    //             fwrite(readBuffer, error, 1, out);
    //         }
    //     } while (error > 0);

    //     fclose(out);

    //     unzCloseCurrentFile(zipfile);

    //     // Goto next entry listed in the zip file.
    //     if ((i + 1) < global_info.number_entry)
    //     {
    //         if (unzGoToNextFile(zipfile) != UNZ_OK)
    //         {
    //             CCLOG("can not read next file");
    //             unzClose(zipfile);
    //             return;
    //         }
    //     }
    // }

    // CCLOG("end restoreBackup");
    // unzClose(zipfile);

    // for (int i = 0; i < m_vAddedFiles.size(); i++)
    // {
    //     std::string fileName = m_vAddedFiles[i];
    //     if (remove(fileName.c_str()) != 0)
    //     {
    //         CCLOG("can not remove downloaded zip file %s", fileName.c_str());
    //     }
    // }

    // if (!remove(backupFileName.c_str()) == 0)
    // {
    //     CCLOG("can not remove backup zip file %s", backupFileName.c_str());
    // }
}

bool ResUpdateManager::checkPath(const char* path)
{
    string fileNameStr(path);

    size_t startIndex = 0;

    std::string pathSep = "/";
    if (Application::sharedApplication()->getTargetPlatform() == Application::Platform::OS_WINDOWS)
    {
        pathSep = "\\";
        for (size_t i = 0; i < fileNameStr.size(); i++)
        {
            if (fileNameStr[i] == '/')
            {
                fileNameStr[i] = '\\';
            }
        }
    }

    size_t index = fileNameStr.find(pathSep, startIndex);

    while (index != std::string::npos)
    {
        const string dir = _writablePath + fileNameStr.substr(0, index);

        if (!m_mDirMap[dir])
        {
            FILE *out = fopen(dir.c_str(), "r");

            if (!out)
            {
                if (!createDirectory(dir.c_str()))
                {
                    CCLOG("can not create directory %s", dir.c_str());
                    return false;
                }
                else
                {
                    CCLOG("create directory %s", dir.c_str());
                    m_mDirMap[dir] = true;
                }
            }
            else
            {
                fclose(out);
                m_mDirMap[dir] = true;
            }
        }

        startIndex = index + 1;

        index = fileNameStr.find(pathSep, startIndex);
    }

    return true;
}

/*
* Create a direcotry is platform depended.
*/
bool ResUpdateManager::createDirectory(const char *path)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST))
    {
        return false;
    }

    return true;
#else
    BOOL ret = CreateDirectoryA(path, NULL);
    if (!ret && ERROR_ALREADY_EXISTS != GetLastError())
    {
        return false;
    }
    return true;
#endif
}

void ResUpdateManager::setSearchPath()
{
    vector<string> searchPaths = FileUtils::getInstance()->getSearchPaths();
    CCLOG("===========> ResUpdateManager::setSearchPath()");
    for (size_t i = 0; i < searchPaths.size(); i++)
    {
        CCLOG("searchPath: %s", searchPaths[i].c_str());
    }
    CCLOG("=============================================>");
}

static size_t downLoadPackage(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    FILE *fp = (FILE*)userdata;
    size_t written = fwrite(ptr, size, nmemb, fp);
    return written;
}

static int lastPer = -1;

int assetsManagerProgressFunc(void *ptr, double totalToDownload, double nowDownloaded, double totalToUpLoad, double nowUpLoaded)
{
    ResUpdateManager* manager = (ResUpdateManager*)ptr;
    ResUpdateManager::Message *msg = new ResUpdateManager::Message();
    msg->what = RESUPDATEMANAGER_MESSAGE_PROGRESS;

    totalToDownload = totalToDownload == 0 ? 1 : totalToDownload;

    int per = (int)(nowDownloaded / totalToDownload * 100);

    if (lastPer < per)
    {
        ProgressMessage *progressData = new ProgressMessage();
        progressData->percent = per;
        progressData->manager = manager;
        msg->obj = progressData;

        manager->_schedule->sendMessage(msg);

        CCLOG("downloading... nowDownloaded %.2f, totalToDownload %.2f, %d%%", nowDownloaded, totalToDownload, per);
    }

    lastPer = per;

    return 0;
}

bool ResUpdateManager::downLoad()
{
    // Create a file to save package.
    string outFileName = _writablePath + _storagePath + TEMP_PACKAGE_FILE_NAME;
    FILE *fp = fopen(outFileName.c_str(), "wb");
    if (!fp)
    {
        sendErrorMessage(kCreateFile);
        CCLOG("can not create file %s", outFileName.c_str());
        return false;
    }

    _curl = curl_easy_init();
    if (!_curl)
    {
        CCLOG("can not init curl");
        return false;
    }

    lastPer = -1;

    // Download pacakge
    CURLcode res;
    curl_easy_setopt(_curl, CURLOPT_URL, _packageUrl.c_str());
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, downLoadPackage);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, fp);
    curl_easy_setopt(_curl, CURLOPT_NOPROGRESS, false);
    curl_easy_setopt(_curl, CURLOPT_FOLLOWLOCATION, true);
    curl_easy_setopt(_curl, CURLOPT_PROGRESSFUNCTION, assetsManagerProgressFunc);
    curl_easy_setopt(_curl, CURLOPT_PROGRESSDATA, this);
    res = curl_easy_perform(_curl);
    fclose(fp);
    curl_easy_cleanup(_curl);
    if (res != 0)
    {
        sendErrorMessage(kNetwork);
        CCLOG("error when download package");
        return false;
    }

    CCLOG("succeed downloading package %s", _packageUrl.c_str());

    return true;
}

const char* ResUpdateManager::getPackageUrl() const
{
    return _packageUrl.c_str();
}

void ResUpdateManager::setPackageUrl(const char *packageUrl)
{
    _packageUrl = packageUrl;
}

const char* ResUpdateManager::getStoragePath() const
{
    return _storagePath.c_str();
}

void ResUpdateManager::setStoragePath(const char *storagePath)
{
    _storagePath = storagePath;
    checkStoragePath();
}

void ResUpdateManager::setDelegate(ResUpdateManagerDelegateProtocol *delegate)
{
    CC_SAFE_RELEASE(_delegate);
    _delegate = delegate;
    CC_SAFE_RETAIN(_delegate);
}

void ResUpdateManager::setScriptDelegate(int errHandler, int progressHandler, int successHandler)
{
    ResUpdateManagerScriptHandler* handler = new ResUpdateManagerScriptHandler(errHandler, progressHandler, successHandler);
    handler->autorelease();
    setDelegate(handler);
}

void ResUpdateManager::setConnectionTimeout(unsigned int timeout)
{
    _connectionTimeout = timeout;
}

unsigned int ResUpdateManager::getConnectionTimeout()
{
    return _connectionTimeout;
}

void ResUpdateManager::sendErrorMessage(ResUpdateManager::ErrorCode code)
{
    Message *msg = new Message();
    msg->what = RESUPDATEMANAGER_MESSAGE_ERROR;

    ErrorMessage *errorMessage = new ErrorMessage();
    errorMessage->code = code;
    errorMessage->manager = this;
    msg->obj = errorMessage;

    _schedule->sendMessage(msg);
}

// Implementation of AssetsManagerHelper

ResUpdateManager::Helper::Helper()
{
    _messageQueue = new list<Message*>();
    pthread_mutex_init(&_messageQueueMutex, NULL);
    Director::getInstance()->getScheduler()->scheduleUpdateForTarget(this, 0, false);
}

ResUpdateManager::Helper::~Helper()
{
    Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);
    delete _messageQueue;
}

void ResUpdateManager::Helper::sendMessage(Message *msg)
{
    pthread_mutex_lock(&_messageQueueMutex);
    _messageQueue->push_back(msg);
    pthread_mutex_unlock(&_messageQueueMutex);
}

bool ResUpdateManager::Helper::updateLogic(float dt)
{
    Message *msg = NULL;

    // Returns quickly if no message
    pthread_mutex_lock(&_messageQueueMutex);
    if (0 == _messageQueue->size())
    {
        pthread_mutex_unlock(&_messageQueueMutex);
        return false;
    }

    // Gets message
    msg = *(_messageQueue->begin());
    _messageQueue->pop_front();
    pthread_mutex_unlock(&_messageQueueMutex);

    switch (msg->what) {
    case RESUPDATEMANAGER_MESSAGE_UPDATE_SUCCEED:
        handleUpdateSucceed(msg);
        break;
    case RESUPDATEMANAGER_MESSAGE_PROGRESS:
        if (((ProgressMessage*)msg->obj)->manager->_delegate)
        {
            ((ProgressMessage*)msg->obj)->manager->_delegate->onProgress(((ProgressMessage*)msg->obj)->percent);
        }

        delete (ProgressMessage*)msg->obj;
        break;
    case RESUPDATEMANAGER_MESSAGE_ERROR:
        // error call back
        if (((ErrorMessage*)msg->obj)->manager->_delegate)
        {
            ((ErrorMessage*)msg->obj)->manager->_delegate->onError(((ErrorMessage*)msg->obj)->code);
        }

        delete ((ErrorMessage*)msg->obj);

        break;
    default:
        break;
    }

    delete msg;

    return true;
}

void ResUpdateManager::Helper::update(float dt)
{
    int num = 0;
    while (true)
    {
        if (!updateLogic(dt) || num >= 4)
        {
            break;
        }
        num++;
    }
}

void ResUpdateManager::Helper::handleUpdateSucceed(Message *msg)
{
    // ResUpdateManager* manager = (ResUpdateManager*)msg->obj;

    // // Set resource search path.
    // manager->setSearchPath();

    // // Delete unloaded zip file.
    // string zipfileName = manager->_writablePath + manager->_storagePath + TEMP_PACKAGE_FILE_NAME;
    // if (remove(zipfileName.c_str()) != 0)
    // {
    //     CCLOG("can not remove downloaded zip file %s", zipfileName.c_str());
    // }

    // if (manager && manager->_delegate)
    // {
    //     manager->_delegate->onSuccess();
    // }
}

// 

ResUpdateManagerScriptHandler::ResUpdateManagerScriptHandler() :
m_iErrorHandlerId(0),
m_iProgressHandlerId(0),
m_iSuccessHandlerId(0)
{

}

ResUpdateManagerScriptHandler::ResUpdateManagerScriptHandler(int erroHandler, int progressHandler, int successHandler) :
m_iErrorHandlerId(erroHandler),
m_iProgressHandlerId(progressHandler),
m_iSuccessHandlerId(successHandler)
{

}

ResUpdateManagerScriptHandler::~ResUpdateManagerScriptHandler()
{

}

void ResUpdateManagerScriptHandler::onError(ResUpdateManager::ErrorCode errorCode)
{
    if (!m_iErrorHandlerId) return;

    LuaEngine* pEngine = LuaEngine::getInstance();
    LuaStack* stack = pEngine->getLuaStack();
    stack->pushInt(errorCode);
    int ret = stack->executeFunctionByHandler(m_iErrorHandlerId, 1);
}

void ResUpdateManagerScriptHandler::onProgress(int percent)
{
    if (!m_iProgressHandlerId) return;

    LuaEngine* pEngine = LuaEngine::getInstance();
    LuaStack* stack = pEngine->getLuaStack();
    stack->pushInt(percent);
    int ret = stack->executeFunctionByHandler(m_iProgressHandlerId, 1);
}

void ResUpdateManagerScriptHandler::onSuccess()
{
    if (!m_iSuccessHandlerId) return;

    LuaEngine* pEngine = LuaEngine::getInstance();
    LuaStack* stack = pEngine->getLuaStack();
    int ret = stack->executeFunctionByHandler(m_iSuccessHandlerId, 0);
}

#endif // CC_PLATFORM_WINRT
