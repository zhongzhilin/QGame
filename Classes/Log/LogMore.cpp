#include "LogMore.h"
#include "ErrorWindow.h"
#include <strstream>


#define MAX_STRING_LENGTH (1024*100)

USING_NS_CC;

int LogMore::s_nLogMoreLv				= 3;
static std::vector<PrintInfoData>	mm_willWriteDataList;	//±¾µØ¼ÇÂ¼µÄÈÕÖ¾Êý¾Ý


std::string LogMore::s_currentLogName	= "";
std::string LogMore::s_errorText		= "";
std::string LogMore::s_fileName			= "";
ErrorWindow* LogMore::s_errorWindow		= nullptr;

static std::vector<std::string>		mm_logModuleList;
static std::vector<std::string>		mm_openModuleList;

static std::vector<std::string>		mm_pvpLogVets;
static bool							mm_isPvp;

static std::map<std::string, std::vector<std::string>> m_log;
static std::map<std::string, std::string> m_logFileName;

void LogMore::setIsPvp(bool ispvp)
{
	mm_isPvp = ispvp;
}

void LogMore::pvpStart()
{
	setIsPvp(true);
}
void LogMore::pvpStop()
{
	if (mm_isPvp == false)
	{
		return;
	}

	setIsPvp(false);

	//°ÑÈÕÖ¾Ð´ÈëÎÄ¼þÀïÃæÈ¥
	std::string strPath = cocos2d::FileUtils::getInstance()->getWritablePath();
	strPath += "log\\";
	if(!cocos2d::FileUtils::getInstance()->isDirectoryExist(strPath))
	{
		cocos2d::FileUtils::getInstance()->createDirectory(strPath);
	}

	time_t sysTime = time(0);
	struct tm* st = localtime(&sysTime);
	std::string fileName = getTimeString(false) ;

	std::string logName = "log-pvp-" + fileName + ".txt";
	strPath += logName;

	FILE* pFile =  fopen(strPath.c_str(), "a+");
	int kLnes = mm_pvpLogVets.size();
	for (int i = 0; i < kLnes; i++)
	{
		if (pFile)
		{
			fputs(mm_pvpLogVets[i].c_str(), pFile);
			fputs("\n", pFile);
	


		}
	}
	fclose(pFile);
	mm_pvpLogVets.clear();
}


void LogMore::setLogLevel(int lv)
{
    LogMore::s_nLogMoreLv = lv;
}

void LogMore::setNeedPrintLogModuleList(std::vector<std::string> & moduleList)
{
	mm_logModuleList = moduleList;
}

void LogMore::setOpenPrintLogModuleList(std::vector<std::string> & moduleList)
{
	mm_openModuleList = moduleList;
}

void LogMore::insertNeeLogModule(std::string & logModuleName)
{
	mm_logModuleList.push_back(logModuleName);
}

void LogMore::insertOpenLogModule(std::string & logModuleName)
{
	mm_openModuleList.push_back(logModuleName);
}

void LogMore::showErrorWindow()
{
	auto runingScenes = Director::getInstance()->getRunningScene();
	if(runingScenes)
	{
        if(s_errorWindow && s_errorWindow->isVisible())
        {
			s_errorWindow->removeFromParent();
        }
		s_errorWindow = ErrorWindow::create(s_errorText);
		runingScenes->addChild(s_errorWindow,runingScenes->getChildrenCount() + 9999999);
		// Director::getInstance()->pause();
	}
}
void LogMore::logErrorFormat(const char* sformat, ...)
{
    std::string str;
    
    va_list ap;
    va_start(ap, sformat);
    
    char* buf = (char*)malloc(MAX_STRING_LENGTH);
    if (buf != nullptr)
    {
        vsnprintf(buf, MAX_STRING_LENGTH, sformat, ap);
        str = buf;
        free(buf);
    }
    va_end(ap);
    
    logError(str.c_str());
}

void LogMore::init()
{

}
bool LogMore::writeToFile(const char* pszContent)
{
    std::string strPath = cocos2d::FileUtils::getInstance()->getWritablePath();
	strPath += "log\\";
	
	if(!cocos2d::FileUtils::getInstance()->isDirectoryExist(strPath))
	{
		cocos2d::FileUtils::getInstance()->createDirectory(strPath);
	}
	strPath += (getFileName() + "-" + LogMore::s_currentLogName + ".txt");
	std::string strSign = "[" + LogMore::s_currentLogName + "]";
    //Ð´ÈëÎÄ¼þ
	LogMore::writeFileData(strPath.c_str(),strSign.c_str(),pszContent);

	//¼ÓÈëÓÐall¿ª¹ØµÄ»°  ¾Í»áÍ¬Ê±ÏòallÎÄ¼þÀïÃæÐ´

	bool isHaveAll = false;
	int kLens = mm_openModuleList.size();
	while (--kLens>=0)
	{
		if(mm_openModuleList[kLens] == "All")
		{
			isHaveAll = true;
			break;
		}
	}

	if(isHaveAll)
	{
		std::string strPath = cocos2d::FileUtils::getInstance()->getWritablePath();
		strPath += "log\\";
		if(!cocos2d::FileUtils::getInstance()->isDirectoryExist(strPath))
		{
			cocos2d::FileUtils::getInstance()->createDirectory(strPath);
		}

		strPath += (getFileName() + "-" + "All" + ".txt");

		std::string strSign = "[" + LogMore::s_currentLogName + "]";
		LogMore::writeFileData(strPath.c_str(),strSign.c_str(),pszContent);
	}

    return false;
}

bool LogMore::writeFileData(const char * filePaths,const char * strSign,const char* pszContent)
{
    std::string strTime = LogMore::getTimeString();
        
	strTime +=  (std::string(strSign) + std::string(pszContent));
	mm_willWriteDataList.push_back(PrintInfoData(filePaths,strTime,int(mm_willWriteDataList.size())));

	return true;
}

bool LogMore::writeRecordToFile()
{
	// std::vector<PrintInfoData>::iterator iter = mm_willWriteDataList.begin();

	// for (iter = mm_willWriteDataList.begin(); iter != mm_willWriteDataList.end();)
	// {
	// 	FILE* pFile = fopen(iter->filePaths.c_str(), "a+");
	// 	if (pFile)
	// 	{
	// 		fputs(iter->textContents.c_str(), pFile);
	// 		fputs("\n", pFile);
	// 		fclose(pFile);
	// 	}
	// 	iter = mm_willWriteDataList.erase(iter);
	// }
	// return true;
	for(auto it = m_log.begin(); it != m_log.end(); ++it)
	{
		std::string filePath = m_logFileName[it->first];
		FILE* pFile = fopen(filePath.c_str(), "a+");
		if (pFile)
		{
			for (std::vector<std::string>::iterator iter = it->second.begin(); iter != it->second.end(); iter++)
			{
				fputs((*iter).c_str(), pFile);
				fputs("\n", pFile);
			}
			fclose(pFile);
		}
	}
	m_log.erase(m_log.begin(), m_log.end());
	return true;
}

void LogMore::writeAllRecordToFile()
{
	int kLens = mm_willWriteDataList.size();
	for (int i = 0; i < kLens; i++)
	{
		PrintInfoData printData = mm_willWriteDataList[0];
		FILE* pFile = fopen(printData.filePaths.c_str(), "a+");
		if (pFile)
		{
			fputs(printData.textContents.c_str(), pFile);
			fputs("\n", pFile);
			fclose(pFile);
		}

	}
	mm_willWriteDataList.clear();
}

void LogMore::printLogInfo(std::string &logTypeName, const char* pszContent)
{
	// LogMore::s_currentLogName = logTypeName;
 //    if (strcmp(pszContent, ""))
	// {
	// 	if(LogMore::isInShowLog())
	// 	{
	// 	    if (LogMore::s_nLogMoreLv >= 2)
	// 		{
	// 			log("Info: %s", pszContent);
	// 			if (mm_isPvp)
	// 			{
	// 				mm_pvpLogVets.push_back(pszContent);
	// 			}
	// 		}
	// 		if (LogMore::s_nLogMoreLv >= 3)
	// 		{
	// 			writeToFile(pszContent);
	// 		}
	// 	}
 
 //    }
 	std::map<std::string, std::vector<std::string>>::iterator it = m_log.find(logTypeName);
 	if (it == m_log.end())
 	{
 		std::vector<std::string> logList;
 		std::string content = pszContent;
 		logList.push_back(content);
 		m_log.insert(std::pair<std::string, std::vector<std::string>>(logTypeName, logList));
		std::string writableFileName = cocos2d::FileUtils::getInstance()->getWritablePath();
		writableFileName += "log\\";
		if(!cocos2d::FileUtils::getInstance()->isDirectoryExist(writableFileName))
		{
			cocos2d::FileUtils::getInstance()->createDirectory(writableFileName);
		}
		writableFileName += (getFileName() + "-" + logTypeName + ".txt");
		m_logFileName.insert(std::pair<std::string, std::string>(logTypeName, writableFileName));
	}
 	else
 	{
 		std::string content = pszContent;
 		it->second.push_back(content);
 	}
}

void LogMore::logError(const char* pszContent)
{
    if (strcmp(pszContent, ""))
	{
        if (LogMore::s_nLogMoreLv >= 1)
		{
            log("Error: %s", pszContent);
        }
        if (LogMore::s_nLogMoreLv >= 3) 
		{
			std::string strPath = cocos2d::FileUtils::getInstance()->getWritablePath();
			strPath += "log\\";
			if(!cocos2d::FileUtils::getInstance()->isDirectoryExist(strPath))
			{
				cocos2d::FileUtils::getInstance()->createDirectory(strPath);
			}

			strPath += (getFileName() + "-Error.txt");

		
			std::string strTime = LogMore::getTimeString();
			strTime +=  "[Error]";
			strTime +=  pszContent;

			FILE* pFile = fopen(strPath.c_str(), "a+");
			if(pFile)
			{
				fputs(strTime.c_str(), pFile);
				fputs("\n", pFile);
				fclose(pFile);
				fclose(pFile);
				
				s_errorText += "\n";
				s_errorText +=strTime;
			}
        }
    }
}
const std::string LogMore::getTimeString(bool detail)
{
    time_t sysTime = time(0);
    struct tm* st = localtime(&sysTime);
    return  detail ? cocos2d::StringUtils::format("[%04d/%02d/%02d %02d:%02d:%02d]", st->tm_year+1900, st->tm_mon+1, st->tm_mday, st->tm_hour, st->tm_min, st->tm_sec) : cocos2d::StringUtils::format("%04d-%02d-%02d-%02d-%02d", st->tm_year+1900, st->tm_mon+1, st->tm_mday,st->tm_hour, st->tm_min);
    
}

const std::string LogMore::getFileName()
{
	if  (LogMore::s_fileName == "")
	{
		time_t sysTime = time(0);
		struct tm* st = localtime(&sysTime);
		LogMore::s_fileName = getTimeString(false) ;// cocos2d::StringUtils::format("[%02d:%02d:%02d]", st->tm_hour, st->tm_min, st->tm_sec);
	}
	return LogMore::s_fileName ;
}

bool LogMore::isInShowLog()
{
	int kLens = mm_openModuleList.size();
	while (--kLens>=0)
	{
		std::string logType =  mm_openModuleList[kLens];
		if(LogMore::s_currentLogName == logType || logType == "All")
		{
			return true;
		}
	}
	return false;
}
