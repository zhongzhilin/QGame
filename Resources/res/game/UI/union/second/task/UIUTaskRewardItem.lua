--region UIUTaskRewardItem.lua
--Author : yyt
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUTaskRewardItem  = class("UIUTaskRewardItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIUTaskRewardItem:ctor()
    
end

function UIUTaskRewardItem:CreateUI()
    local root = resMgr:createWidget("union/union_task_reward_item")
    self:initUI(root)
end

function UIUTaskRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_task_reward_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_1.quit_export
    self.icon = self.root.Node_1.icon_export
    self.count_text = self.root.Node_1.count_text_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUTaskRewardItem:setData(data)
    -- body
    local itemData = luaCfg:get_item_by(data.id) or luaCfg:get_equipment_by(data.id)
    local itemIcon = itemData.itemIcon or itemData.icon
    self.count_text:setString(data.num)
    -- self.icon:setSpriteFrame(itemIcon)
    global.panelMgr:setTextureFor(self.icon,itemIcon)

    local quality = itemData.quality
    if quality == 0 then quality = 1 end
    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",quality))
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",quality))

    local tempdata ={information= itemData}
    self.m_TipsControl = UIItemTipsControl.new()
    self.m_TipsControl:setdata(self.icon, tempdata, global.utaskPanel.tips_node)
end

function UIUTaskRewardItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

--CALLBACKS_FUNCS_END

return UIUTaskRewardItem

--endregion
