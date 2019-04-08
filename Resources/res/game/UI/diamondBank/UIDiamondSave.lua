--region UIDiamondSave.lua
--Author : yyt
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIDiamondSave  = class("UIDiamondSave", function() return gdisplay.newWidget() end )
local CountSliderControl = require("game.UI.common.UICountSliderControl")

function UIDiamondSave:ctor()
    self:CreateUI()
end

function UIDiamondSave:CreateUI()
    local root = resMgr:createWidget("diamond_bank/bank_use_bg")
    self:initUI(root)
end

function UIDiamondSave:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diamond_bank/bank_use_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_export
    self.light = self.root.Node_export.light_export
    self.icon = self.root.Node_export.icon_export
    self.time = self.root.Node_export.time_mlan_7.time_export
    self.rate = self.root.Node_export.rate_mlan_7.rate_export
    self.min = self.root.Node_export.min_mlan_10.min_export
    self.maxSave = self.root.Node_export.max_mlan_8.maxSave_export
    self.line1 = self.root.Node_export.max_mlan_8.line1_export
    self.curSave = self.root.Node_export.max_mlan_8.curSave_export
    self.save_btn = self.root.Node_export.save_btn_export
    self.grayBg = self.root.Node_export.save_btn_export.grayBg_export
    self.get_btn = self.root.Node_export.get_btn_export
    self.slider = self.root.Node_export.slider_export
    self.line = self.root.Node_export.slider_export.line_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.save_btn, function(sender, eventType) self:saveHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.get_btn, function(sender, eventType) self:getDiamondHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider, handler(self,  self.changCountCallBack)) 
    self.maxSlider = self.slider.max

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDiamondSave:setData(data)

    self.data = data
    self.time:setString(luaCfg:get_local_string(10772,data.day))
    self.txt_Title:setString(luaCfg:get_local_string(10911,data.day))
    self.rate:setString(data.interest .. "%")
    self.min:setString(luaCfg:get_local_string(10912,data.min))
    self.curSave:setString(global.propData:getCurBankSave(data.type))
    self.maxSave:setString(data.max)
    global.panelMgr:setTextureFor(self.icon, data.icon)
    self.light:setScale(data.lightScale/100)

    global.tools:adjustNodePosForFather(self.curSave:getParent(), self.curSave)
    local curW = self.curSave:getContentSize().width
    self.line1:setPositionX(self.curSave:getPositionX()+curW+5)
    self.maxSave:setPositionX(self.curSave:getPositionX()+curW+10)

    self.minSaveNum = data.min
    self.maxSaveNum = data.max-global.propData:getCurBankSave(data.type)
    local curDiamond = global.propData:getProp(WCONST.ITEM.TID.DIAMOND)
    self.maxSaveNum = self.maxSaveNum <= curDiamond and self.maxSaveNum or curDiamond
    if self.maxSaveNum < data.min then
        self.minSaveNum = self.maxSaveNum
    end
    self.sliderControl:setMaxCount(self.maxSaveNum)
    self.sliderControl:setMinCount(self.minSaveNum)
    self.sliderControl:changeCount(self.minSaveNum) 

    global.colorUtils.turnGray(self.grayBg, false)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,data.min) or (self.maxSaveNum < data.min)  then
        global.colorUtils.turnGray(self.grayBg, true)
    end

    global.tools:adjustNodePosForFather(self.time:getParent(), self.time)
    global.tools:adjustNodePosForFather(self.rate:getParent(), self.rate)
    global.tools:adjustNodePosForFather(self.min:getParent(), self.min)
    global.tools:adjustNodePos(self.line, self.maxSlider)

end

function UIDiamondSave:changCountCallBack(contentCount, event)
    
    if event ~= 1 then
        return
    end

    local curCount = self.sliderControl:getContentCount()
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, self.data.min) then
        global.tipsMgr:showWarning("NodiamondBank")
        return 
    elseif self.maxSaveNum < self.data.min then
        global.tipsMgr:showWarning("BankMax")
        return
    end

end

function UIDiamondSave:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIDiamondSave")
end

function UIDiamondSave:saveHandler(sender, eventType)
    
    local curCount = self.sliderControl:getContentCount()
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, self.data.min) then
        global.tipsMgr:showWarning("NodiamondBank")
        return 
    elseif self.maxSaveNum < self.data.min then
        global.tipsMgr:showWarning("BankMax")
        return
    end

    global.itemApi:bankAction(function (msg)
        -- body
        global.tipsMgr:showWarning("diamondBank")
        self:onCloseHandler()

    end, 1, self.data.type, 1, curCount)

end

function UIDiamondSave:getDiamondHandler(sender, eventType)
    self:onCloseHandler()
    global.UIRechargeListOffset = nil
    global.panelMgr:closePanel("UIDiamondBankPanel")
    global.panelMgr:openPanel("UIRechargePanel")
end
--CALLBACKS_FUNCS_END

return UIDiamondSave

--endregion
