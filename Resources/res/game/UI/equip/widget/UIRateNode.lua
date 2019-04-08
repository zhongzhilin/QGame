--region UIRateNode.lua
--Author : Administrator
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRateNode  = class("UIRateNode", function() return gdisplay.newWidget() end )

function UIRateNode:ctor()
    
end

function UIRateNode:CreateUI()
    local root = resMgr:createWidget("equip/str_rate_node")
    self:initUI(root)
end

function UIRateNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/str_rate_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pro_symbol = self.root.pro_symbol_export
    self.itemIcon = self.root.pro_symbol_export.buttonNode.itemIcon_export
    self.defalut_name = self.root.pro_symbol_export.defalut_name_export
    self.add_btn = self.root.pro_symbol_export.add_btn_export
    self.name = self.root.pro_symbol_export.name_export
    self.count = self.root.pro_symbol_export.count_export

    uiMgr:addWidgetTouchHandler(self.itemIcon, function(sender, eventType) self:cancel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.add_btn, function(sender, eventType) self:choose(sender, eventType) end)
--EXPORT_NODE_END

    self.add_btn:setZoomScale(0.4)
    self.defalut_name:setString(luaCfg:get_local_string(10431))
end

function UIRateNode:setRate(id)
    
	-- self.name:setString(luaCfg:get_local_string(10431))

	if id == -1 then
    
        self.defalut_name:setVisible(true)
        self.defalut_name:setPositionY(-21)
        self.name:setVisible(false)
        self.add_btn:setVisible(true)
        self.itemIcon:setVisible(false)
        self.count:setVisible(false)
    elseif id == -2 then

        self.defalut_name:setVisible(true)
        self.name:setVisible(false)
        self.add_btn:setVisible(false)
        self.itemIcon:setVisible(false) 
        self.defalut_name:setPositionY(0)
        self.count:setVisible(false)
    else

        local itemData = luaCfg:get_item_by(id)

        self.defalut_name:setVisible(false)
        self.name:setVisible(true)
        self.add_btn:setVisible(false)
        self.itemIcon:setVisible(true)

        -- self.itemIcon:loadTextureNormal(itemData.itemIcon, ccui.TextureResType.plistType)
        -- self.itemIcon:loadTexturePressed(itemData.itemIcon, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.itemIcon,itemData.itemIcon)
        
        self.name:setString(itemData.itemName)
        self.count:setVisible(true)
        -- self.count:setString(luaCfg:get_local_string(10445, global.normalItemData:getItemById(id).count))
        self.count:setString("(" .. global.normalItemData:getItemById(id).count .. "/1)")
    end

    self.id = id
end

function UIRateNode:getId()

    return self.id
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRateNode:choose(sender, eventType)

    local panel = global.panelMgr:openPanel("UISpeedPanel")
    panel:setData(nil, 0, panel.TYPE_EQUIP_RATE)
end

function UIRateNode:cancel(sender, eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("EquipItemNotUse",function()
        
        global.panelMgr:getPanel("UIEquipStrongPanel"):chooseRate(-1)
    end)
end
--CALLBACKS_FUNCS_END

return UIRateNode

--endregion
