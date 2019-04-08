#include "ErrorWindow.h"
#include "ui/UIScrollView.h"
#include "LuaSupport/CCHgame.h"
#include "LogMore.h"

using namespace ui;
ErrorWindow::ErrorWindow()
{
	m_errorLabel = NULL;
}

ErrorWindow::~ErrorWindow()
{
}

ErrorWindow * ErrorWindow::create(std::string & errorLabel)
{
	auto errorWindow = new ErrorWindow();
	if(errorWindow && errorWindow->init(errorLabel))
	{
		errorWindow->autorelease();
		return errorWindow;
	}
	CC_SAFE_DELETE(errorWindow);
	return NULL;
}

bool ErrorWindow::init(std::string & errorLabel)
{
	if(Node::init())
	{
		m_errorStr = errorLabel;
		this->setAnchorPoint(Vec2(0,0));
		renaderUI();
	
		return true;
	}
	
	return false;
}

void ErrorWindow::renaderUI()
{
	auto sceneSize = Director::getInstance()->getWinSize();

	ScrollView* scrollView = ScrollView::create();
	scrollView->setContentSize(sceneSize);
	scrollView->setDirection(ScrollView::Direction::HORIZONTAL);
	this->addChild(scrollView);

	auto coloLayer = LayerColor::create(ccc4(0, 0, 0, 255));
	coloLayer->ignoreAnchorPointForPosition(false);
	coloLayer->setAnchorPoint(Vec2(0.5,0.5));
	coloLayer->setColor(ccc3(100, 100, 255));
	scrollView->addChild(coloLayer);

    CCHgame::setPasteBoard(m_errorStr.c_str());
    
	m_errorLabel = Label::createWithSystemFont(m_errorStr,"Consolas",24);
	m_errorLabel->setAnchorPoint(Vec2(0,1));
	m_errorLabel->setPosition(Vec2(0, 700 - 15));
	
	coloLayer->addChild(m_errorLabel);

	auto textSize = m_errorLabel->getContentSize();
	coloLayer->setContentSize(Size(textSize.width, 700));
	scrollView->setInnerContainerSize(Size(textSize.width, sceneSize.height));
	coloLayer->setPosition(Vec2(textSize.width / 2, sceneSize.height / 2));

	auto fontItemExit = MenuItemFont::create("exit",this,menu_selector(ErrorWindow::menuClick));
	fontItemExit->setAnchorPoint(Vec2(1,0.0f));
	fontItemExit->setFontSize(40);
	fontItemExit->setPosition(ccp(sceneSize.width / 2 - 100, sceneSize.height / 2 - 320));
	fontItemExit->setTag(0);


	auto fontItemstart = MenuItemFont::create("start",this,menu_selector(ErrorWindow::menuClick));
	fontItemstart->setAnchorPoint(Vec2(1,0.0f));
	fontItemstart->setFontSize(40);
	fontItemstart->setPosition(ccp(sceneSize.width/2 + 100, sceneSize.height / 2 - 320));
	fontItemstart->setTag(1);

	auto menus = Menu::create(fontItemExit,fontItemstart,NULL);
	menus->setPosition(Vec2(0,0));
	this->addChild(menus);
}

void ErrorWindow::menuClick(Ref * refs)
{
	MenuItemFont  * itenFont = (MenuItemFont*)refs;
	if(itenFont->getTag() == 1)
	{
		// Director::getInstance()->resume();
		this->removeFromParent();
		CCHgame::RestartGame();
        LogMore::s_errorWindow = nullptr;
		// Director::getInstance()->replaceScene(Director::getInstance()->getRunningScene());
		return;
	}

	#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8) || (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
		MessageBox("You pressed the close button. Windows Store Apps do not implement a close button.","Alert");
		return;
	#endif

		Director::getInstance()->end();

	#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		exit(0);
	#endif
}
