--region UIBattleItemNodeEnd.lua
--Author : Administrator
--Date   : 2016/11/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleItemNodeEnd  = class("UIBattleItemNodeEnd", function() return gdisplay.newWidget() end )


local UISoldierEnd = require("game.UI.world.widget.GM.UISoldierEnd")

local topHeight = 33
local itemHeight = 66

function UIBattleItemNodeEnd:ctor(data,isAtt,lRate)
    
    self:CreateUI(data,isAtt,lRate)
end

function UIBattleItemNodeEnd:CreateUI(data,isAtt,lRate)
    local root = resMgr:createWidget("battle/army_end_node")
    self:initUI(root,data,isAtt,lRate)
end

function UIBattleItemNodeEnd:initUI(root,data,isAtt,lRate)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/army_end_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.army_name = self.root.top_export.army_name_export
    self.atk_type = self.root.top_export.atk_type_export

--EXPORT_NODE_END
    if isAtt then

        self.atk_type:setString("进攻")
    else

        self.atk_type:setString("防守")
    end
    
    local sdCount = #data.tgCalcSolier
    for i,v in ipairs(data.tgCalcSolier) do

        -- dump(v,"data ininin")
        
        local sd = {lID = v.lid,lCount = v.lrealcount,lLosCount = v.ltheorycount,lRate = lRate}

        local soldier = UISoldierEnd.new(sd)
        soldier:setPositionY((i - 1) * itemHeight)

        self:addChild(soldier)
    end

    self.top:setPositionY(sdCount * itemHeight)

    self:setContentSize({width = 0,height = sdCount * itemHeight + topHeight})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleItemNodeEnd

--endregion
