--region UIRecruitEffect.lua
--Author : yyt
--Date   : 2017/08/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRecruitEffect  = class("UIRecruitEffect", function() return gdisplay.newWidget() end )

function UIRecruitEffect:ctor()
    
end

function UIRecruitEffect:CreateUI()
    local root = resMgr:createWidget("effect/ui_kuang_eff")
    self:initUI(root)
end

function UIRecruitEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/ui_kuang_eff")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bottom = self.root.bottom_export
    self.top = self.root.top_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIRecruitEffect:onEnter()
	self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("effect/ui_kuang_eff")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

function UIRecruitEffect:setData()

end

--CALLBACKS_FUNCS_END

return UIRecruitEffect

--endregion
