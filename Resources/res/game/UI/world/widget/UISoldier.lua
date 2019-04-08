--region UISoldier.lua
--Author : Administrator
--Date   : 2016/11/02
--generate by [ui_code_tool.py] automatically

local uiMgr = global.uiMgr
local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldier  = class("UISoldier", function() return gdisplay.newWidget() end )

local side_action = {
    
    "animation6",
    "animation2",
    "animation3",
    "animation5",
    "animation7",
    "animation1",
    "animation4",
    "animation0",
}

function UISoldier:ctor()
    
end

function UISoldier:CreateUI()
    
end

function UISoldier:initUI(fileType)
    
    self.path = fileType
    self.soldier = resMgr:createWidget(fileType)
    self:addChild(self.soldier)

    uiMgr:configUITree(self.soldier)
end

function UISoldier:onEnter()

    self.soldier:stopAllActions()
    self.timeLine = resMgr:createTimeline(self.path)
    self.soldier:runAction(self.timeLine)
end

function UISoldier:checkSide(sideIndex)
    
    self.timeLine:play(side_action[sideIndex],true)
end

function UISoldier:createFlag(kind)

    local animationName = "animation/flag_" .. kind    
    local flag = resMgr:createWidget(animationName)
    uiMgr:configUITree(flag)
    local flag_TimeLine = resMgr:createTimeline(animationName)
    flag_TimeLine:play("animation0", true)
    flag:runAction(flag_TimeLine)
    -- flag.flagSp:setVisible(false)

    self.soldier.flag:addChild(flag)
    
    -- for i = 1,8 do

    --     local gan = ccui.Helper:seekNodeByName(self["angle"..i], "flag_node_export")
        
    --     if tolua.isnull(gan) == false then
            

    --         local animationName = "animation/flag_" .. kind
    --         local flag = resMgr:createWidget(animationName)
    --         local flag_TimeLine = resMgr:createTimeline(animationName)
    --         flag_TimeLine:play("animation0", true)
    --         flag:runAction(flag_TimeLine)

    --         gan:addChild(flag)    
    --     end
    -- end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISoldier

--endregion
