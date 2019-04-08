--region UIMailRewardItem.lua
--Author : yyt
--Date   : 2016/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailRewardItem  = class("UIMailRewardItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIMailRewardItem:ctor()
    
    self:CreateUI()
end

function UIMailRewardItem:CreateUI()
    local root = resMgr:createWidget("mail/mail_three_node")
    self:initUI(root)
end

function UIMailRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_three_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.reward_icon = self.root.reward_icon_export
    self.reward_text1 = self.root.reward_text1_export
    self.reward_text2 = self.root.reward_text2_export

--EXPORT_NODE_END
end

function UIMailRewardItem:setData(data)
    local  tb_item = luaCfg:get_item_by(data.lID) or luaCfg:get_equipment_by(data.lID)
    self.reward_text1:setString(tb_item.itemName or tb_item.name)
    self.reward_text2:setString(data.lCount)
    -- self.reward_icon:setSpriteFrame(tb_item.itemIcon or tb_item.icon)
    -- self.bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",tb_item.quality))
    global.panelMgr:setTextureFor(self.reward_icon,tb_item.itemIcon or tb_item.icon)
    global.panelMgr:setTextureFor(self.bg,string.format("icon/item/item_bg_0%d.png",tb_item.quality))

    -- 粮食图标不用缩放
    if data.lID < 6 then
        self.reward_icon:setScale(1)
    else
        self.reward_icon:setScale(0.5)  
    end
    self.m_TipsControl = UIItemTipsControl.new()
    local tempdata ={information =tb_item } 
    self.m_TipsControl:setdata(self.root.bg_export,tempdata,data.tips_node)
    self.m_TipsControl:setCheckMode(1)
end

  
function UIMailRewardItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMailRewardItem

--endregion
