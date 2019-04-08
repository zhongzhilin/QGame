--region UIBattleNode3.lua
--Author : wuwx
--Date   : 2016/12/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBattleSingle = require("game.UI.world.widget.UIBattleSingle")
--REQUIRE_CLASS_END

local UIBattleNode3  = class("UIBattleNode3", function() return gdisplay.newWidget() end )

function UIBattleNode3:ctor()
    
    self:CreateUI()
end

function UIBattleNode3:CreateUI()
    local root = resMgr:createWidget("animation/battle_node3")
    self:initUI(root)
end

function UIBattleNode3:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "animation/battle_node3")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    local jian_TimeLine = resMgr:createTimeline("effect/bigworld_battle_sign")
    jian_TimeLine:play("animation0", true)
    self.root.jian:runAction(jian_TimeLine)
    self.jian = UIBattleSingle.new()
    uiMgr:configNestClass(self.jian, self.root.jian)

--EXPORT_NODE_END

    local nodeTimeLine = resMgr:createTimeline("animation/battle_node3")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

function UIBattleNode3:setData(data)
    self.data = data
    self.jian:setData(data)
end

function UIBattleNode3:showFire(isShow,exitCall)
    self.root.fire:setVisible(isShow)
    self.m_exitCall = exitCall
end

function UIBattleNode3:onExit()
    if self.m_exitCall then self.m_exitCall() end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBattleNode3

--endregion
