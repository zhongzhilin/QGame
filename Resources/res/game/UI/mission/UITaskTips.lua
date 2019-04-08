--region UITaskTips.lua
--Author : untory
--Date   : 2016/08/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITaskTips  = class("UITaskTips", function() return gdisplay.newWidget() end )

function UITaskTips:ctor()
  
  self:CreateUI()  
end

function UITaskTips:CreateUI()
    local root = resMgr:createWidget("common/common_gift_tips")
    self:initUI(root)
end

function UITaskTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_gift_tips")


-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Text_1 = self.root.Image_1.Text_1_export

--EXPORT_NODE_END
end

function UITaskTips:setDesc( str, delayTime, isAction )
	-- body

    local delay = 2
    if delayTime then  delay = delayTime end

    self.Text_1:setString(str)
    self:setScaleY(0)
    self:setVisible(true)
    self:stopAllActions()
    self:runAction(cc.Sequence:create(cc.EaseBackOut:create(
        cc.ScaleTo:create(0.45,1,1)),cc.DelayTime:create(delay),
        cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create()))

    if isAction then
        local  sp = resMgr:createCsbAction("effect/task_purple","animation0",false, true)
        self.root:addChild(sp)
    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function UITaskTips:onEnter()
	-- body

	
end

return UITaskTips

--endregion
