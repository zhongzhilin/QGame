--region UISeeking.lua
--Author : Administrator
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISeeking  = class("UISeeking", function() return gdisplay.newWidget() end )

function UISeeking:ctor()
    self:CreateUI()
end

function UISeeking:CreateUI()
    local root = resMgr:createWidget("troop/seek_ing")
    self:initUI(root)
end

function UISeeking:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/seek_ing")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.Panel.Node_5.Button_9, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END
end

function UISeeking:onEnter()

    self.root:stopAllActions()
    
    local timeLine = resMgr:createTimeline("troop/seek_ing")
    timeLine:play("animation0", true)
    self.root:runAction(timeLine)

    self.isDelayClose = false
    self.callBack = nil
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        
        if self.isDelayClose then

            if self.callBack then self.callBack() end
            global.panelMgr:closePanel("UISeeking")
        end

        self.isDelayClose = true
    end)))
end

function UISeeking:setDelayClose(callback)
    
    self.callBack = callback
    if self.isDelayClose then

        if self.callBack then self.callBack() end
        global.panelMgr:closePanel("UISeeking")
    else

        self.isDelayClose = true
    end    
end

function UISeeking:setTroopId( troopId )
    
    self.troopId = troopId
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISeeking:exitCall(sender, eventType)

    global.worldApi:stopFindPath(self.troopId,function()

        global.panelMgr:closePanel("UISeeking")
    end)
end
--CALLBACKS_FUNCS_END

return UISeeking

--endregion
