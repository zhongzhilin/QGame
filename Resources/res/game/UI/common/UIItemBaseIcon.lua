--region UIItemBaseIcon.lua
--Author : Administrator
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UILongTipsControl = require("game.UI.common.UILongTipsControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIItemBaseIcon  = class("UIItemBaseIcon", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIItemBaseIcon:ctor()
    
end

function UIItemBaseIcon:CreateUI()
    local root = resMgr:createWidget("common/common_item_icon")
    self:initUI(root)
end

function UIItemBaseIcon:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_item_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.quit_export
    self.icon = self.root.icon_export
    self.count_text = self.root.count_text_export
    self.name = self.root.name_export

--EXPORT_NODE_END

    self:hideName()    
end

function UIItemBaseIcon:openLongTipsControl(delayTime)
    self.tipsControl = UILongTipsControl.new(self.icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    self.tipsControl:setDelayTime(delayTime)
end

function UIItemBaseIcon:initTextTips(TipLayout)
    
    local itemData = self.itemData
        
    if self.itemData == nil then return end

    TipLayout.itemName:setString(itemData.itemName)
    TipLayout.itemDes:setString(itemData.itemDes)
    -- TipLayout.Node_5.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- TipLayout.Node_5.icon:setSpriteFrame(itemData.itemIcon)
    global.panelMgr:setTextureForAsync(TipLayout.Node_5.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    global.panelMgr:setTextureForAsync(TipLayout.Node_5.icon,itemData.itemIcon,true)
end

function UIItemBaseIcon:longPressDeal(beganPoint,TipLayout)
    
    if self.itemData == nil then return end

    local size = TipLayout.bg:getContentSize()
    
    if beganPoint.x > gdisplay.width - size.width then
        beganPoint.x = gdisplay.width - size.width 
    end


    beganPoint.x = beganPoint.x + size.width / 2
    beganPoint.y = beganPoint.y + size.height / 2    

    local pos = TipLayout:getParent():convertToNodeSpaceAR(beganPoint)            

    TipLayout:setVisible(true)
    TipLayout:runAction(cc.FadeIn:create(0.2))
    TipLayout:setPosition(pos)

    -- local outNodePos = self.tips.outNode:convertToWorldSpace(cc.p(0,0))
    -- if outNodePos.x > gdisplay.width then

    --     self.tips:setPositionX(self.tips:getPositionX() + (gdisplay.width - outNodePos.x))
    -- end
end


function UIItemBaseIcon:showName(color)
    self.name:setVisible(true)
    if color then
        self.name:setTextColor(color)
    end    
end

function UIItemBaseIcon:hideName()
    self.name:setVisible(false)
end

 
function UIItemBaseIcon:setId(id,count)
	
    local itemData = luaCfg:get_item_by(id)

    if itemData == nil then return end
    self.itemData = itemData

    -- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon)
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
    global.panelMgr:setTextureForAsync(self.icon,itemData.itemIcon,true)

    if count then
        self.count_text:setVisible(true)
        self.count_text:setString(count)
    else 
        self.count_text:setVisible(false)
    end    

    self.name:setString(itemData.itemName)

    if self.tipsControl then
        self.tipsControl:setData({information = itemData})
    end    
end

function UIItemBaseIcon:registerTips(tips_panel)
    self.tips_panel = tips_panel
    if self.tips_panel and  self.tips_panel.tips_node and self.itemData  then 
        self.m_TipsControl = UIItemTipsControl.new()
        self.m_TipsControl:setdata(self.quit,{information=self.itemData},self.tips_panel.tips_node)
    end 
end 


function  UIItemBaseIcon:clearTips()
   if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end 


function UIItemBaseIcon:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIItemBaseIcon

--endregion
