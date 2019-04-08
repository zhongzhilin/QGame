--region UIBagUse.lua
--Author : Administrator
--Date   : 2016/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local propData = global.propData
local userData = global.userData
local dataMgr = global.dataMgr

local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIBagUse  = class("UIBagUse", function() return gdisplay.newWidget() end )

function UIBagUse:ctor()
    self:CreateUI()
end

function UIBagUse:CreateUI()
    local root = resMgr:createWidget("bag/bag_use")
    self:initUI(root)
end

function UIBagUse:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_use")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.title.name_export
    self.desc = self.root.Node_export.desc_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.icon_bg = self.root.Node_export.icon_bg_export
    self.icon = self.root.Node_export.icon_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4_0, function(sender, eventType) self:use_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4, function(sender, eventType) self:chooseAll(sender, eventType) end)
--EXPORT_NODE_END
    self.slider.cur = self.cur
    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    self.sliderControl = CountSliderControl.new(self.slider)
end

function UIBagUse:setData(data)
    -- body
    self.data = data

    self.sliderControl:setMaxCount(data.count)

    local itemData = luaCfg:get_item_by(data.id)
 
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
    self.name:setString(itemData.itemName)
    
    --string.format(luaCfg:get_local_string(10060),itemData.itemName)
    self.desc:setString(string.format(luaCfg:get_local_string(10060),itemData.itemName))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIBagUse:chooseAll(sender, eventType)
    
    self.sliderControl:chooseAll()
end

function UIBagUse:exit(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UIBagUse")
end

function UIBagUse:use_call(sender, eventType)


    global.panelMgr:closePanel("UIBagUse")

    local itemData = luaCfg:get_item_by(self.data.id)
    local window = itemData.window

    global.itemApi:itemUse(self.data.id, self.sliderControl:getContentCount(), 0, 0, function(msg)
       
        --　领主经验道具使用
        gevent:call(global.gameEvent.EV_ON_UI_USER_UPDATE)
    
        local data = {} --msg.tgItem--global.normalItemData:useItem(self.data.id, num)        
        for _,v in ipairs(msg.tgItem or {}) do

            table.insert(data,{[1] = v.lID,[2] = v.lCount})            
        end

        local tipStr = ""
        if data then tipStr = global.taskData.getGiftInfoBySort(data) end

        if window == 0 then
            
            return

        elseif  window == 1 then
            --todo

            global.tipsMgr:showTaskTips(tipStr)
        elseif  window == 2 then

            global.panelMgr:openPanel("UIItemRewardPanel"):setData(data)
        elseif window == 3 then

            local id = itemData.typePara1

            local soldierData = luaCfg:get_soldier_property_by(id)
            global.tipsMgr:showTaskTips(luaCfg:get_local_string(10206,soldierData.name,num))

            return
        elseif window == 4 then
            
            global.tipsMgr:showTaskTips(itemData.useDes)
        end    
    end)

    

end
--CALLBACKS_FUNCS_END

return UIBagUse

--endregion
