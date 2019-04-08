--region UIDailyTaskRewardItem.lua
--Author : untory
--Date   : 2016/08/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDailyTaskRewardItem  = class("UIDailyTaskRewardItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIDailyTaskRewardItem:ctor()
    
    self:CreateUI()
end

function UIDailyTaskRewardItem:CreateUI()
    local root = resMgr:createWidget("task/task_daily_reward_node")
    self:initUI(root)
end

function UIDailyTaskRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_daily_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.name_export
    self.count = self.root.count_export
    self.bg = self.root.bg_export
    self.icon = self.root.icon_export

--EXPORT_NODE_END
    global.funcGame:initBigNumber(self.count, 1)

end

function UIDailyTaskRewardItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end 
end

function UIDailyTaskRewardItem:setData(msg)
    -- body

    local itemId = msg[1]
    local itemNum = msg[2]

    local itemData = luaCfg:get_item_by(itemId) or global.luaCfg:get_equipment_by(itemId)
    local itemName = itemData.itemName or itemData.name
    local itemIcon = itemData.itemIcon or itemData.icon

    if itemId < 100 then
        self.icon:setScale(1)
    else
        self.icon:setScale(0.40)
    end

    local quality = itemData.quality
    if quality == 0 then quality = 1 end

    -- self.bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",quality))
    self.name:setString(itemName)
    -- self.icon:setSpriteFrame(itemIcon)
    self.count:setString(itemNum)
    global.panelMgr:setTextureFor(self.bg,string.format("icon/item/item_bg_0%d.png",quality))
    global.panelMgr:setTextureFor(self.icon,itemIcon)

    -- tips
    if not self.m_TipsControl  then 
        self.m_TipsControl = UIItemTipsControl.new()
        local tempdata ={information=itemData} 
        local rewardPanel = global.panelMgr:getPanel("UIDailyTaskRewardPanel")
        self.m_TipsControl:setdata(self.icon, tempdata, rewardPanel.tips_node)
    else 
        local tempdata ={information=itemData} 
        self.m_TipsControl:updateData(tempdata)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIDailyTaskRewardItem

--endregion
