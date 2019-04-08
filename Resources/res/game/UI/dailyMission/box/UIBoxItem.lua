--region UIBoxItem.lua
--Author : Administrator
--Date   : 2016/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBoxItem  = class("UIBoxItem", function() return gdisplay.newWidget() end )

function UIBoxItem:ctor()
  
	self:CreateUI()  
end

function UIBoxItem:CreateUI()
    local root = resMgr:createWidget("task/task_daily_box_item")
    self:initUI(root)
end

function UIBoxItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_daily_box_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.button = self.root.button_export
    self.score2 = self.root.score2_export
    self.unGetEffect = self.root.unGetEffect_export
    self.openEffect = self.root.openEffect_export
    self.guide = self.root.guide_export

--EXPORT_NODE_END

	self.button:setSwallowTouches(false)
    self.taskPanel = global.panelMgr:getPanel("UIDailyTaskPanel")
end

function UIBoxItem:onEnter()
end

function UIBoxItem:setData(data)

    self.unGetEffect:stopAllActions()
    self.timeLine = resMgr:createTimeline("effect/get_box")
    self.unGetEffect:runAction(self.timeLine)

    self.openEffect:stopAllActions()
    self.timeLine1 = resMgr:createTimeline("effect/open_box")
    self.openEffect:runAction(self.timeLine1)

    self.guide:setName("box_item" .. data.sort)
	self.score2:setString(data.score)

    self.openEffect:setVisible(false)
    self.button:setVisible(true)

    local getPointConfig = function(score)
        for i,v in ipairs(global.luaCfg:daily_point()) do
            if v.taskSegment == score then
                return v
            end
        end
    end

    self.pointConfig = getPointConfig(data.score)
    self.button:loadTexture(self.pointConfig.closeIcon, ccui.TextureResType.plistType)
    local state = 1
    local currentState = global.dailyTaskData:getBoxs()[data.sort].state
    if currentState == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
        state = 0
    elseif currentState == WDEFINE.DAILY_TASK.TASK_STATE.GETD then

        if self.taskPanel.isOpenEffectId == data.score then

            self.button:setVisible(false)
            self.openEffect:setVisible(true)
            self.timeLine1:play("animation0", false)
            self.taskPanel.isOpenEffectId = 0
        else
            self.button:loadTexture(self.pointConfig.openIcon, ccui.TextureResType.plistType)
        end
    end

    self.unGetEffect.button_export:loadTexture(self.pointConfig.closeIcon, ccui.TextureResType.plistType)
    self.openEffect.baoxiang_00000_3:setSpriteFrame(self.pointConfig.closeIcon)
    self.openEffect.bx:setSpriteFrame(self.pointConfig.openIcon)

    self:setState(state)

end

function UIBoxItem:setState(state)
    
    if self.guideSpTask and not tolua.isnull(self.guideSpTask) and (self.taskPanel.isFirstGuide == 0) then
        self.guideSpTask:removeFromParent()
        self.guideSpTask = nil
    end
    
    if state == 0 then
        self.unGetEffect:setVisible(true)
            
        self.timeLine:play("animation0", true)

        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function ( )
            
            if self.taskPanel.isFirstGuide == 0 then
                local guideSp, timeLine = resMgr:createCsbAction("effect/get_box2","animation0",false, true) 
                self.taskPanel:addChild(guideSp)

                local posT = self.button:convertToWorldSpace(cc.p(0, 0))
                guideSp:setPosition(cc.p(posT.x, posT.y + 30))
                self.guideSpTask = guideSp

                self.taskPanel.isFirstGuide  = self.taskPanel.isFirstGuide + 1
            end
        end)))

    else
        self.unGetEffect:setVisible(false)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBoxItem

--endregion
