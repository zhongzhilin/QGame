--region UIWildSoldier.lua
--Author : wuwx
--Date   : 2016/11/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UILongTipsControl = require("game.UI.common.UILongTipsControl")

local UIWildSoldier  = class("UIWildSoldier", function() return gdisplay.newWidget() end )

function UIWildSoldier:ctor()
    -- self:CreateUI()
end

function UIWildSoldier:CreateUI()
    local root = resMgr:createWidget("wild/wild_icon")
    self:initUI(root)
end

function UIWildSoldier:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_node = self.root.Panel_1.portrait_node_export
    self.select_bg = self.root.Panel_1.select_bg_export
    self.hp = self.root.Sprite_1.hp_export
    self.number = self.root.number_bg.number_export

--EXPORT_NODE_END
    self.tipsControl = UILongTipsControl.new(self.root.Panel_1,WCONST.LONG_TIPS_PANEL.WILD_RES)
end

function UIWildSoldier:setData(data,isShowNumber)
    
    -- dump(data,">>.")

    local soldierData = luaCfg:get_wild_property_by(data.lID)
    self.hp:setString(soldierData.name)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)

    self.tipsControl:setData(soldierData)
    self.number:getParent():setVisible(isShowNumber)
    if isShowNumber then
        self.number:setString(data.lValue)
    end    
end

function UIWildSoldier:setDataNotWild(id)
    
    local soldierData = luaCfg:get_soldier_property_by(id)
    self.hp:setString(soldierData.name)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)
    
    self.tipsControl:setData(soldierData)
    self.number:getParent():setVisible(false)
end

function UIWildSoldier:showName(isVisi)
    self.root.Sprite_1:setVisible(isVisi)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWildSoldier

--endregion
