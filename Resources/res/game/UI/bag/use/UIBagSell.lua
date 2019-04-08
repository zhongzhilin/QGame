--region UIBagSell.lua
--Author : untory
--Date   : 2017/06/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local luaCfg = global.luaCfg
local uiMgr = global.uiMgr
local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIBagSell  = class("UIBagSell", function() return gdisplay.newWidget() end )

function UIBagSell:ctor()
    self:CreateUI()
end

function UIBagSell:CreateUI()
    local root = resMgr:createWidget("bag/bag_sell")
    self:initUI(root)
end

function UIBagSell:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_sell")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.desc = self.root.Node_export.desc_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.icon_bg = self.root.Node_export.icon_bg_export
    self.icon = self.root.Node_export.icon_export
    self.pay_icon = self.root.Node_export.dia_heal_btn.pay_icon_export
    self.num = self.root.Node_export.dia_heal_btn.num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.dia_heal_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.all_slt_btn, function(sender, eventType) self:allSelect(sender, eventType) end)
--EXPORT_NODE_END

    self.slider.cur = self.cur    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider,function(count)
        
        self:changeHandler(count)
    end , true)
end

function UIBagSell:changeHandler(count)
    
    self.sellCount = count
    
    if self.itemData.sellRes and  self.itemData.sellRes[2]  then  -- protect 
        self.num:setString(self.sellCount * self.itemData.sellRes[2])
    end 
end

function UIBagSell:setData(data)

    self.data = data

    local itemData = luaCfg:get_item_by(data.id) 
    self.itemData = itemData
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon)        
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
    self.desc:setString(string.format(luaCfg:get_local_string(10688),itemData.itemName))
    self.sliderControl:setMaxCount(data.count)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIBagSell:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIBagSell")
end

function UIBagSell:onCureHandler(sender, eventType)
            
    if not luaCfg:get_item_by(self.itemData.sellRes[1]) then 
        --protect 
        return 
    end 

    local data = clone(self.data)
    local sellName = luaCfg:get_item_by(self.itemData.sellRes[1]).itemName     
    local sellPrice = self.sellCount * self.itemData.sellRes[2]
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("SellItem", function()
        global.itemApi:sellItem(data.id,self.sliderControl:getContentCount(),function(msg)
    
            global.tipsMgr:showWarning("SellSuccess", sellName,sellPrice)
            global.panelMgr:closePanel("UIBagSell") 
        end)
    end,self.sellCount,self.itemData.itemName,sellPrice,sellName)    
end

function UIBagSell:allSelect(sender, eventType)
    self.sliderControl:chooseAll()
end
--CALLBACKS_FUNCS_END

return UIBagSell

--endregion
