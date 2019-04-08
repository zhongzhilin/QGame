--region UIRegisterItem.lua
--Author : yyt
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRegisterItem  = class("UIRegisterItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIRegisterItem:ctor()
    
    self:CreateUI()
end

function UIRegisterItem:CreateUI()
    local root = resMgr:createWidget("register/register_item_node")
    self:initUI(root)
end

function UIRegisterItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "register/register_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node_1 = self.root.Node_1_export
    self.quit = self.root.Node_1_export.quit_export
    self.icon = self.root.Node_1_export.icon_export
    self.count_text = self.root.Node_1_export.count_text_export
    self.done_node = self.root.done_node_export
    self.day_num_node = self.root.day_num_node_export
    self.day = self.root.day_num_node_export.day_export
    self.effectNode = self.root.effectNode_export
    self.TipLayout = self.root.TipLayout_export

--EXPORT_NODE_END
    self.sinTimes = 0

    local nodeTimeLine = resMgr:createTimeline("register/register_item_node")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRegisterItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

function UIRegisterItem:setData(data, curTimes, tips_node)

    self.data = data

    -- dump(self.data,"签到数据")
    -- self.root.  :setName("itemqueid" .. curTimes)

    local itemData = luaCfg:get_item_by(data[2]) or luaCfg:get_equipment_by(data[2])
    
    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon or itemData.icon)
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon or itemData.icon)
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    self.count_text:setString(data[3])

    self.done_node:setVisible(false)
    self.day_num_node:setVisible(true)
    self.day:setString( luaCfg:get_local_string(10352, curTimes) )
    
    if self.sinTimes >= curTimes then

        self.done_node:setVisible(true) 
        global.colorUtils.turnGray(self.Node_1,true)
    else
        global.colorUtils.turnGray(self.Node_1,false)
    end

    -- 可领取
    local registerPanel = global.panelMgr:getPanel("UIRegisterPanel") 
   if curTimes == (self.sinTimes + 1) and registerPanel.getRewardBtn:isEnabled()  then
        self.effectNode:setVisible(true)
   else
        self.effectNode:setVisible(false)
   end

    -- tips
    local tempdata ={information=itemData}
    self.m_TipsControl = UIItemTipsControl.new()
    self.m_TipsControl:setdata(self.icon,tempdata,tips_node)

end

--CALLBACKS_FUNCS_END

return UIRegisterItem

--endregion
