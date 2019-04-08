--region UIBalanceNode.lua
--Author : Administrator
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBalanceNode  = class("UIBalanceNode", function() return gdisplay.newWidget() end )

function UIBalanceNode:ctor()
    
end

function UIBalanceNode:CreateUI()
    local root = resMgr:createWidget("equip/str_balance_node")
    self:initUI(root)
end

function UIBalanceNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/str_balance_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pro_symbol = self.root.pro_symbol_export_0
    self.itemIcon = self.root.pro_symbol_export_0.buttonNode.itemIcon_export
    self.defalut_name = self.root.pro_symbol_export_0.defalut_name_export
    self.add_btn = self.root.pro_symbol_export_0.add_btn_export
    self.name = self.root.pro_symbol_export_0.name_export
    self.count = self.root.pro_symbol_export_0.count_export

    uiMgr:addWidgetTouchHandler(self.itemIcon, function(sender, eventType) self:cancel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.add_btn, function(sender, eventType) self:choose(sender, eventType) end)
--EXPORT_NODE_END

    self.add_btn:setZoomScale(0.4)
    self.defalut_name:setString(luaCfg:get_local_string(10430))
end

function UIBalanceNode:setIndex(index)
	self.index = index
end

function UIBalanceNode:setBalance(id, needCount)
	
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
        self.needCount = needCount
        local havCount = global.normalItemData:getItemById(id).count
        if needCount then
            if havCount >= needCount then
            uiMgr:setRichText(self, "count", 50097, {num_1=havCount, num_2=needCount})
            else
                uiMgr:setRichText(self, "count", 50096, {num_1=havCount, num_2=needCount})
            end
        else
            uiMgr:setRichText(self, "count", 50097, {num_1=havCount, num_2=1})
        end
    end

    self.id = id
end

function UIBalanceNode:getId()

	return self.id
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBalanceNode:choose(sender, eventType)
    if self.needCount then return end -- 锻造
    local panel = global.panelMgr:openPanel("UISpeedPanel")
    panel:setData(nil, 0, panel.TYPE_EQUIP_BALANCE,self.index)
end

function UIBalanceNode:cancel(sender, eventType)

    -- 锻造
    if self.needCount then 
        local temp = {}
        local forgeData = luaCfg:get_forge_material_by(self.id)
        if not forgeData then return end
        for i=1,forgeData.maxNum do
            if forgeData["approach"..i] and forgeData["approach"..i] ~= 0 then
                table.insert(temp, forgeData["approach"..i])
            end
        end
        global.panelMgr:openPanel("UIHeroNoOrder"):setData(temp)

        global.gpsStroeItemID = self.id
        
        return 
    end 

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("EquipItemNotUse",function()
        
        global.panelMgr:getPanel("UIEquipStrongPanel"):cancelBalance(-1, self.index)
    end)
end
--CALLBACKS_FUNCS_END

return UIBalanceNode

--endregion
