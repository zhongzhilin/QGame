/****************************************************************************
 日志输出
 默认输出等级是3级
 
 总共4个级别
 0级:屏蔽任何输出
 1级:输出Error
 2级:输出Info和Error
 3级:本地生成一份TXT日志文件，同时输出Info和Error
 
 Created by butcher
 ****************************************************************************/
#ifndef __LOGMORE_H__
#define __LOGMORE_H__

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include "cocos2d.h"
#include "ErrorWindow.h"

typedef struct _PrintInfoData
{
	_PrintInfoData(std::string paths,std::string texts,int ids)
	{
		filePaths		= paths;
		textContents	= texts;
		indexs			= ids;
	}
	int indexs;
	std::string filePaths;
	std::string textContents;

}PrintInfoData;

class LogMore
{
public:
    //初始化
    static void init();

	//打印出日志
	static void printLog(std::string & logTypeName,const char *sformat,  ...);
	static void printServerLog(const char *sformat, ...);

    //设置输出等级
    static void setLogLevel(int lv);
	static bool isInShowLog();

    //输出调试信息 lua 调用接口
    static void printLogInfo(std::string & logTypeName,const char* pszContent);

    //输出错误信息
    static void logErrorFormat(const char *sformat, ...);
    static void logError(const char* pszContent);

	static bool writeToFile(const char* pszContent);
	static bool writeFileData(const char * filePaths,const char * strSign,const char* pszContent);
	static bool writeRecordToFile();
	static void writeAllRecordToFile();

	//设置整个需要打印日志的模块
	static void setNeedPrintLogModuleList(std::vector<std::string> & moduleList);
	static void setOpenPrintLogModuleList(std::vector<std::string> & moduleList);

	static void insertNeeLogModule(std::string & logModuleName);
	static void insertOpenLogModule(std::string & logModuleName);

	static void showErrorWindow();

	static void setIsPvp(bool ispvp);
	static void pvpStart();
	static void pvpStop();

	
	static ErrorWindow* s_errorWindow;
	
private:

    static int s_nLogMoreLv;
	static std::string s_currentLogName;
	static std::string s_errorText;
	static std::string s_fileName;


    static const std::string getTimeString(bool detail = true);
	static const std::string getFileName();
};

#endif /* __LOGMORE_H__ */
