--region UIBattleNode.lua
--Author : Administrator
--Date   : 2016/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBattleSingle = require("game.UI.world.widget.UIBattleSingle")
--REQUIRE_CLASS_END

local UIBattleNode  = class("UIBattleNode", function() return gdisplay.newWidget() end )

local isOpenFightEffect = cc.UserDefault:getInstance():getBoolForKey("isOpenFightEffect",true)    

local csbName = isOpenFightEffect and "animation/battle_node2" or "animation/battle_node_no_effect"

function UIBattleNode:ctor()
    
    self:CreateUI()
end

function UIBattleNode:CreateUI()

    local root = resMgr:createWidget(csbName)
    self:initUI(root)
end

function UIBattleNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, csbName)

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    local jian_TimeLine = resMgr:createTimeline("effect/bigworld_battle_sign")
    jian_TimeLine:play("animation0", true)
    self.root.jian:runAction(jian_TimeLine)
    self.jian = UIBattleSingle.new()
    uiMgr:configNestClass(self.jian, self.root.jian)

--EXPORT_NODE_END
    
    local nodeTimeLine = resMgr:createTimeline(csbName)
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

function UIBattleNode:setData(data)
    self.data = data
    self.jian:setData(data)
end

-- boss单独处理
function UIBattleNode:setBoss(boss)
    self.boss = boss
    self.jian:setBoss(boss)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleNode

--endregion
