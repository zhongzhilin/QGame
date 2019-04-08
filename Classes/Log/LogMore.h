/****************************************************************************
 ��־���
 Ĭ������ȼ���3��
 
 �ܹ�4������
 0��:�����κ����
 1��:���Error
 2��:���Info��Error
 3��:��������һ��TXT��־�ļ���ͬʱ���Info��Error
 
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
    //��ʼ��
    static void init();

	//��ӡ����־
	static void printLog(std::string & logTypeName,const char *sformat,  ...);
	static void printServerLog(const char *sformat, ...);

    //��������ȼ�
    static void setLogLevel(int lv);
	static bool isInShowLog();

    //���������Ϣ lua ���ýӿ�
    static void printLogInfo(std::string & logTypeName,const char* pszContent);

    //���������Ϣ
    static void logErrorFormat(const char *sformat, ...);
    static void logError(const char* pszContent);

	static bool writeToFile(const char* pszContent);
	static bool writeFileData(const char * filePaths,const char * strSign,const char* pszContent);
	static bool writeRecordToFile();
	static void writeAllRecordToFile();

	//����������Ҫ��ӡ��־��ģ��
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
