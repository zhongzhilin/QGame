--region UITownSoldier.lua
--Author : untory
--Date   : 2016/12/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UILongTipsControl = require("game.UI.common.UILongTipsControl")

local UITownSoldier  = class("UITownSoldier", function() return gdisplay.newWidget() end )

function UITownSoldier:ctor()
    
end

function UITownSoldier:CreateUI()
    local root = resMgr:createWidget("wild/wild_camp_icon")
    self:initUI(root)
end

function UITownSoldier:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_camp_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.number = self.root.Panel_1.number_bg.number_export
    self.portrait_node = self.root.Panel_1.portrait_node_export
    self.select_bg = self.root.Panel_1.select_bg_export

--EXPORT_NODE_END
    self.tipsControl = UILongTipsControl.new(self.root.Panel_1,WCONST.LONG_TIPS_PANEL.WILD_RES)
end

function UITownSoldier:setData( data , isWild )
    local soldierData = nil 
    if isWild then 
        soldierData = luaCfg:get_wild_property_by(data.lID)
    else
        soldierData = luaCfg:get_soldier_train_by(data.lID)
        -- dump(soldierData)
    end

    self.number:setString(data.lCount)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)

    self.tipsControl:setData(soldierData)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITownSoldier

--endregion
