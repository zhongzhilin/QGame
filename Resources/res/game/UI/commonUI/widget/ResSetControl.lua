--region ResSetControl.lua
--Author : wuwx
--Date   : 2016/08/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
local ResSetControl  = class("ResSetControl")
local textScrollControl = require("game.UI.common.UITextScrollControl")

local resList = {
    WCONST.ITEM.TID.FOOD,
    WCONST.ITEM.TID.GOLD,
    WCONST.ITEM.TID.WOOD,
    WCONST.ITEM.TID.STONE,
    WCONST.ITEM.TID.SOLDIER,
}

local ResourceNumControl = require("game.UI.commonUI.unit.ResourceNumControl")

function ResSetControl:ctor(root,objs)
    if objs then
        self.objs = objs
    else
        self.objs = nil
    end
    self.root = root
    self.delay = 0


end


function ResSetControl:initUI(root)

    self.init =self.init or false  

    if self.objs then
        --主ui上的资源条
        for _ , i in ipairs(resList) do 
        if self.objs["res_"..i] then 
                self["res_"..i] = self.objs["res_"..i]
            end 
        end
        self.btn_rmb = self.objs.btn_rmb
        self.rmb_num = self.objs.rmb_num
        self.rmb_icon = self.objs.rmb_icon
    else
        --面板上的资源条
        for _ , i in ipairs(resList) do
            if  self.root["res_"..i] then 
                self["res_"..i] = self.root["res_"..i]
                if self.initBigNumber and not self.init then 
                    self:initBigNumber(self.root["res_"..i])
                end
                self["res_control"..i] = ResourceNumControl.new(self.root["res_"..i],true)
            end 
        end
        self.init = true 
        self.btn_rmb = self.root.btn_rmb_export
        self.rmb_num = self.root.btn_rmb_export.rmb_num_export
        self.rmb_icon = self.root.btn_rmb_export.rmb_icon_export
    end

    uiMgr:addWidgetTouchHandler(self.btn_rmb, function(sender, eventType) self:onRmbClickHandler(sender, eventType) end)
end


function ResSetControl:initBigNumber(root , ps)

    local icon = root.resBtn.num_export.num_icon_export
    global.funcGame:initBigNumber(root.resBtn.num_export  , 1 , function (text , setString) 
        local str = text._showText
        local endstr = string.sub(str, #str,#str)
        if endstr =="K" or endstr =="M" or endstr =="T" then 
            icon:setVisible(true)
            local str = string.sub(str, 1 ,#str-1)
            str = string.gsub( str ,"%D","/")
            local is = "ui_surface_icon/"..endstr..".png"
            if icon.is and icon.is == is then 
            else 
                icon:setSpriteFrame(is)
            end  
            icon.is = is
            setString(text , str)
        else 
            icon:setVisible(false)
            setString(text , str)
        end 
        global.tools:adjustNodePosForFather(text , icon)
    end)
end 

function ResSetControl:initEventListener()
    local callBB = function(eventName,isNotify)
        -- body
        self:updataItem(isNotify)
    end
    local eventWidget = self.root:getChildByName("ResSetControl_eventWidget")
    if eventWidget then
    else
        eventWidget = gdisplay.newWidget()
        eventWidget:setName("ResSetControl_eventWidget")
        self.root:addChild(eventWidget)
    end
    
    eventWidget:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,callBB)
    
end

function ResSetControl:onRmbClickHandler(sender, eventType)
    --钻石点击

    if _NO_RECHARGE then 
        return global.tipsMgr:showWarning("FuncNotFinish")
    end 

    global.panelMgr:openPanel("UIRechargePanel")

end


function ResSetControl:setData()
    self:initUI(self.root)

    self.isEnter = false
    self:updataItem()
    self:initEventListener()
end

function ResSetControl:playAnimation( root )
    
    -- 添加魔晶特效
    local nodeTimeLine = resMgr:createTimeline("common/common_resource_num")
    nodeTimeLine:setLastFrameCallFunc(function()
    end)
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    root:runAction(nodeTimeLine)
end

-- 魔晶滚动特效
function ResSetControl:setRmbScroll(isNotify)

    local num = self.rmb_num:getString() or 0 

    local perNum = tonumber(num)
    local rmbNum = tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))
    if isNotify and (perNum ~= rmbNum) then
        textScrollControl.startScroll(self.rmb_num, rmbNum, 1, nil, nil, nil)
        self.rmb_num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)), 8))
    else
        self.rmb_num:setString(rmbNum)
    end
end

function ResSetControl:updataItem(isNotify)

    log.debug("ResSetControl:updataItem(isNotify) isNotify=%s",isNotify)
    local topPanel = global.panelMgr:getTopPanelName()
    if topPanel == "UICityPanel" or (topPanel == "UISalaryPanel" and self.isEnter ) then
        self:setFirstScroll(true,isNotify)
    else
        self:setFirstScroll(false,isNotify)
        self.isEnter = true
    end
    
    for idx,id in ipairs(resList) do
        local resData = luaCfg:get_item_by(id)
        local item = self["res_"..id]
        local itemControl = self["res_control"..id]
        -- if id == WCONST.ITEM.TID.SOLDIER then --兵源
        --     resData = clone(luaCfg:get_item_by(5))
        --     resData.itemId= WCONST.ITEM.TID.SOLDIER 
        -- end 
        if not  tolua.isnull(item) then
            if item.setData then item:setData(resData) end
            if itemControl then itemControl:setData(resData) end
        end
    end
    local resData = luaCfg:get_item_by(WCONST.ITEM.TID.DIAMOND)
    -- self.rmb_icon:setSpriteFrame(resData.itemIcon)

    if self.delay > 0 then
        self.root:runAction( cc.Sequence:create(cc.DelayTime:create(self.delay), cc.CallFunc:create(function ()
            self:setRmbScroll(isNotify)
        end)))
    else
        self:setRmbScroll(isNotify)
    end
end


function ResSetControl:setFirstScroll(s,isNotify)
    
    for idx,id in ipairs(resList) do
        local item = self["res_"..id]
        local control = self["res_control"..id]
        if item then
            if item.setFirstScroll then 
                item:setFirstScroll(s,isNotify)
            elseif control and control.setFirstScroll then
                control:setFirstScroll(s,isNotify)
            end
        end
    end
end

function ResSetControl:setRmbDelay(delayTime)
    self.delay = delayTime
end

return ResSetControl

--endregion
