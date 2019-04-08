--region UIAttackEffect.lua
--Author : untory
--Date   : 2016/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAttackEffect  = class("UIAttackEffect", function() return gdisplay.newWidget() end )

function UIAttackEffect:ctor()
    self:CreateUI()
end

function UIAttackEffect:CreateUI()
    local root = resMgr:createWidget("world/battle_red")
    self:initUI(root)
end

function UIAttackEffect:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/battle_red")



-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END
end


--- 此处加音效
function UIAttackEffect:onEnter()

	self.root:stopAllActions()
	
	local timeLine = resMgr:createTimeline("world/battle_red")
	timeLine:play("animation0", true)
    self.root:runAction(timeLine)
    self:playAudio()
end

function UIAttackEffect:playAudio()
    self.soundHandler = gsound.playEffectForced("red_sceen")
end

function UIAttackEffect:onExit()
    gaudio.stopSound(self.soundHandler)
end



--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAttackEffect:exitCall(sender, eventType)

    global.worldApi:ignoreAttackEffect()
	-- global.panelMgr:closePanel("UIAttackEffect")
end
--CALLBACKS_FUNCS_END

return UIAttackEffect

--endregion
