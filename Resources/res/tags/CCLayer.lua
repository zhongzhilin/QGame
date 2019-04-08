---@classdef CCLayer
CCLayer = {}
function CCLayer:autorelease() end 
function CCLayer:retain() end 
function CCLayer:retainCount() end 
function CCLayer:isEqual() end 
function CCLayer:copy() end 
function CCLayer:release() end 
function CCLayer:isSingleReference() end 
function CCLayer:visit() end 
function CCLayer:getUserObject() end 
function CCLayer:getSkewY() end 
function CCLayer:convertTouchToNodeSpace() end 
function CCLayer:getVertexZ() end 
function CCLayer:setParent() end 
function CCLayer:boundingBox() end 
function CCLayer:setVisible() end 
function CCLayer:stopActionByTag() end 
function CCLayer:getScaleY() end 
function CCLayer:setScaleX() end 
function CCLayer:reorderChild() end 
function CCLayer:setPositionX() end 
function CCLayer:removeFromParentAndCleanup() end 
function CCLayer:setTag() end 
function CCLayer:getChildrenCount() end 
function CCLayer:setScale() end 
function CCLayer:addChild() end 
function CCLayer:isVisible() end 
function CCLayer:setActionManager() end 
function CCLayer:setScheduler() end 
function CCLayer:getContentSize() end 
function CCLayer:getAnchorPoint() end 
function CCLayer:getTag() end 
function CCLayer:setGrid() end 
function CCLayer:convertToWorldSpace() end 
function CCLayer:setSkewX() end 
function CCLayer:setZOrder() end 
function CCLayer:worldToNodeTransform() end 
function CCLayer:getPosition() end 
function CCLayer:getSkewX() end 
function CCLayer:getScheduler() end 
function CCLayer:ignoreAnchorPointForPosition() end 
function CCLayer:setPosition() end 
function CCLayer:getParent() end 
function CCLayer:unscheduleUpdate() end 
function CCLayer:scheduleUpdateWithPriorityLua() end 
function CCLayer:removeChildByTag() end 
function CCLayer:convertToNodeSpaceAR() end 
function CCLayer:convertTouchToNodeSpaceAR() end 
function CCLayer:convertToWorldSpaceAR() end 
function CCLayer:setRotation() end 
function CCLayer:getComponent() end 
function CCLayer:convertToNodeSpace() end 
---
-- @return @class CCLayer
--
function CCLayer:create() end 
function CCLayer:getScale() end 
function CCLayer:getPositionY() end 
function CCLayer:getChildByTag() end 
function CCLayer:setContentSize() end 
function CCLayer:description() end 
function CCLayer:cleanup() end 
function CCLayer:getRotation() end 
function CCLayer:nodeToParentTransform() end 
function CCLayer:stopAction() end 
function CCLayer:numberOfRunningActions() end 
function CCLayer:removeAllChildren() end 
function CCLayer:runAction() end 
function CCLayer:setUserObject() end 
function CCLayer:parentToNodeTransform() end 
function CCLayer:removeChild() end 
function CCLayer:getAnchorPointInPoints() end 
function CCLayer:getScaleX() end 
function CCLayer:transform() end 
function CCLayer:getActionManager() end 
function CCLayer:draw() end 
function CCLayer:setScaleY() end 
function CCLayer:unregisterScriptHandler() end 
function CCLayer:setVertexZ() end 
function CCLayer:setAnchorPoint() end 
function CCLayer:getShaderProgram() end 
function CCLayer:stopAllActions() end 
function CCLayer:setUserData() end 
function CCLayer:setShaderProgram() end 
function CCLayer:getActionByTag() end 
function CCLayer:getGLServerState() end 
function CCLayer:getOrderOfArrival() end 
function CCLayer:getPositionX() end 
function CCLayer:setGLServerState() end 
function CCLayer:setSkewY() end 
function CCLayer:setOrderOfArrival() end 
function CCLayer:nodeToWorldTransform() end 
function CCLayer:getChildren() end 
function CCLayer:transformAncestors() end 
function CCLayer:getGrid() end 
function CCLayer:isRunning() end 
function CCLayer:registerScriptHandler() end 
function CCLayer:getCamera() end 
function CCLayer:isIgnoreAnchorPointForPosition() end 
function CCLayer:getUserData() end 
function CCLayer:setPositionY() end 
function CCLayer:getZOrder() end 
function CCLayer:isTouchEnabled() end 
function CCLayer:unregisterScriptKeypadHandler() end 
function CCLayer:registerScriptAccelerateHandler() end 
---
-- @return @class CCLayer
--
function CCLayer:create() end 
function CCLayer:setAccelerometerEnabled() end 
function CCLayer:registerScriptKeypadHandler() end 
function CCLayer:setTouchMode() end 
function CCLayer:isAccelerometerEnabled() end 
function CCLayer:setTouchEnabled() end 
function CCLayer:setTouchPriority() end 
function CCLayer:unregisterScriptAccelerateHandler() end 
function CCLayer:unregisterScriptTouchHandler() end 
function CCLayer:setKeypadEnabled() end 
function CCLayer:registerScriptTouchHandler() end 
function CCLayer:getTouchPriority() end 
function CCLayer:isKeypadEnabled() end 
function CCLayer:getTouchMode() end 