--region RmbWidget.lua
--Author : wuwx
--Date   : 2017/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local RmbWidget  = class("RmbWidget", function() return gdisplay.newWidget() end )

function RmbWidget:ctor()
    
    self.delay = 0
end

function RmbWidget:CreateUI()
    local root = resMgr:createWidget("common/common_rmb_num")
    self:initUI(root)
end

function RmbWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_rmb_num")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_rmb = self.root.btn_rmb_export
    self.rmb_num = self.root.btn_rmb_export.rmb_num_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.btn_rmb, function(sender, eventType) self:onRmbClickHandler(sender, eventType) end)
end

function RmbWidget:onRmbClickHandler(sender, eventType)
    --钻石点击
    global.panelMgr:openPanel("UIRechargePanel")
end

function RmbWidget:onEnter()

    self:playAnimation()
	self:initEventListener()
end

function RmbWidget:initEventListener()
    local callBB = function(eventName, isNotify)
        -- body
        self:updataItem(isNotify)
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,callBB)
    self:updataItem()
end

local textScrollControl = require("game.UI.common.UITextScrollControl")
function RmbWidget:setRmbScroll(isNotify)
    local perNum = tonumber(self.rmb_num:getString())
    local rmbNum = tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))
    if isNotify and (perNum ~= rmbNum) then
        textScrollControl.startScroll(self.rmb_num, rmbNum, 1, nil, nil, nil)
        self.rmb_num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)), 8))
    else
        self.rmb_num:setString(rmbNum)
    end
end

function RmbWidget:updataItem(isNotify)
    if self.delay > 0 then
        self.root:runAction( cc.Sequence:create(cc.DelayTime:create(self.delay), cc.CallFunc:create(function ()
            self:setRmbScroll(isNotify)
        end)))
    else
        self:setRmbScroll(isNotify)
    end
end

function RmbWidget:setRmbDelay(delayTime)
    self.delay = delayTime
end

function RmbWidget:playAnimation()
    -- 添加魔晶特效
    local nodeTimeLine = resMgr:createTimeline("common/common_rmb_num")
    nodeTimeLine:setLastFrameCallFunc(function()
    end)
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return RmbWidget

--endregion
