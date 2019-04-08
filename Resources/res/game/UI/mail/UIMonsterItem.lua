--region UIMonsterItem.lua
--Author : yyt
--Date   : 2016/12/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMonsterItem  = class("UIMonsterItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIMonsterItem:ctor()
    self:CreateUI()
end

function UIMonsterItem:CreateUI()
    local root = resMgr:createWidget("mail/mall_wild_item")
    self:initUI(root)
end

function UIMonsterItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mall_wild_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_1.quit_export
    self.icon = self.root.Node_1.icon_export
    self.count_text = self.root.count_text_export
    self.name = self.root.name_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMonsterItem:setData(data, isMail)
    self.data = data

    local itemData = luaCfg:get_item_by(data.lID) or luaCfg:get_equipment_by(data.lID)
    if not itemData then return end

    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon or itemData.icon)
    
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon or itemData.icon)
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    self.count_text:setString(data.lCount)
    self.name:setString(itemData.itemName or itemData.name)

    
    local tempdata = {information = itemData} 
    self.m_TipsControl = UIItemTipsControl.new()
    self.m_TipsControl:setdata(self.icon,tempdata,data.tips_node)

    if isMail then
       self.name:setTextColor(cc.c3b(255, 226, 165)) 
    else
        self.name:setTextColor(cc.c3b(53, 22, 0))
    end

end

function UIMonsterItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

 
--CALLBACKS_FUNCS_END

return UIMonsterItem

--endregion
