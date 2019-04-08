#ifndef __ERROR_WINDOW_H__
#define __ERROR_WINDOW_H__

#include "cocos2d.h"
USING_NS_CC;

class ErrorWindow:
	public Node
{
public:

	ErrorWindow();
	virtual ~ErrorWindow();

	static ErrorWindow * create(std::string & errorLabel);
	bool init(std::string & errorLabel);

	void renaderUI();
	void menuClick(Ref * refs);

private:

	Label * m_errorLabel;
	std::string m_errorStr;
};

#endif