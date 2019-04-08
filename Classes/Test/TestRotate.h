#ifndef __TEST_ROTATE_H__
#define __TEST_ROTATE_H__

#include "cocos2d.h"

class TestRotateLayer : public cocos2d::Layer
{
public:
    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    bool init(int configId, int configType);  

    // there's no 'id' in cpp, so we recommend returning the class instance pointer
    static cocos2d::Scene* scene(int configId, int configType);
    
    static TestRotateLayer* create(int configId, int configType);

    // default implements are used to call script callback if exist
    bool onTouchBegan(cocos2d::Touch *pTouch, cocos2d::Event *pEvent);
    void onTouchMoved(cocos2d::Touch *pTouch, cocos2d::Event *pEvent);
    void onTouchEnded(cocos2d::Touch *pTouch, cocos2d::Event *pEvent);
    void onTouchCancelled(cocos2d::Touch *pTouch, cocos2d::Event *pEvent);
};

#endif // __TEST_ROTATE_H__
