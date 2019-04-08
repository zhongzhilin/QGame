#include "TestRotate.h"

USING_NS_CC;

CCScene* TestRotateLayer::scene(int configId, int configType)
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    TestRotateLayer *layer = TestRotateLayer::create(configId, configType);

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

TestRotateLayer* TestRotateLayer::create(int configId, int configType)
{
    TestRotateLayer* layer = new TestRotateLayer();
    if (layer->init(configId, configType))
    {
        layer->autorelease();
        return layer;
    }
    layer->release();
    return NULL;
}

// on "init" you need to initialize your instance
bool TestRotateLayer::init(int configId, int configType)
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    
    return true;
}

bool TestRotateLayer::onTouchBegan(cocos2d::Touch *pTouch, cocos2d::Event *pEvent)
{
    return false;
}

void TestRotateLayer::onTouchMoved(cocos2d::Touch *pTouch, cocos2d::Event *pEvent)
{

}

void TestRotateLayer::onTouchEnded(cocos2d::Touch *pTouch, cocos2d::Event *pEvent)
{

}

void TestRotateLayer::onTouchCancelled(cocos2d::Touch *pTouch, cocos2d::Event *pEvent)
{
    
}
