--region UIMonthEffect.lua
--Author : anlitop
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMonthEffect  = class("UIMonthEffect", function() return gdisplay.newWidget() end )

function UIMonthEffect:ctor()
    
end

function UIMonthEffect:CreateUI()
    local root = resMgr:createWidget("effect/huodong_icon1")
    self:initUI(root)
end

function UIMonthEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/huodong_icon1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.redPoint = self.root.Button_1.redPoint_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:callBack(sender, eventType) end, true)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:callBack(sender, eventType) end)

end

function UIMonthEffect:onEnter()

    local nodeTimeLine =resMgr:createTimeline("effect/huodong_icon1")

    self.root:runAction(nodeTimeLine)

    nodeTimeLine:play("animation0",true)

    nodeTimeLine:setTimeSpeed(0.7)

    -- nodeTimeLine:setsrpp

    self:addEventListener(global.gameEvent.EV_ON_ACTIVITY_RED, function ()
        if not tolua.isnull(self.redPoint) then
            self.redPoint:setVisible(global.ActivityData:isActivityRed())
        end
    end)
    self.redPoint:setVisible(global.ActivityData:isActivityRed())
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMonthEffect:callBack(sender, eventType)
   local panel =   global.panelMgr:openPanel("UIActivityPanel")
    panel:setData(2)
end

--CALLBACKS_FUNCS_END

return UIMonthEffect

--endregion
