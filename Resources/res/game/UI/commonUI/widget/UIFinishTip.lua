--region UIFinishTip.lua
--Author : yyt
--Date   : 2018/01/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local gameEvent = global.gameEvent
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFinishTip  = class("UIFinishTip", function() return gdisplay.newWidget() end )

function UIFinishTip:ctor()
    
end

function UIFinishTip:CreateUI()
    local root = resMgr:createWidget("effect/down_tishi_ui")
    self:initUI(root)
end

function UIFinishTip:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/down_tishi_ui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.text = self.root.Node_1.text_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- parm = {id=1, args={100}}
-- id: remind表id  args 自定义参数
function UIFinishTip:onEnter()
	-- body
	self.isShowing = false

	self:addEventListener(gameEvent.EV_ON_GAME_RESUME,function()
		if self.clean then
    		self:clean()
    	end
    end)

	self:addEventListener(gameEvent.EV_ON_FINISHTIP,function(event, msg)
		
		if not self.showTip then return end
		if not self.isShowing then
			self:showTip(msg)
		end
    end)

end

function UIFinishTip:showTip(msg)
	-- body

	local data = msg.param
	local datas = {}
    for index,v in ipairs(data.args or {}) do
        datas['key_'..index] = v
    end 
    local remindConfig = luaCfg:get_remind_by(data.id)
	uiMgr:setRichText(self, "text", remindConfig.content, datas)

	self.isShowing = true
	self.root:stopAllActions()
	local nodeTimeLine = resMgr:createTimeline("effect/down_tishi_ui")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        
        global.finishData:removeFinishList(msg.listId)
        self.isShowing = false
        
    end)
    self.root:runAction(nodeTimeLine)

    self.text:setOpacity(0)
    self.text:runAction(cc.Sequence:create(cc.FadeIn:create(25/60), cc.DelayTime:create(2), cc.FadeOut:create(35/60)))

end

function UIFinishTip:clean()
	-- body
	self.isShowing = false

	self.root:stopAllActions()
    self.text:setOpacity(0)
    
	-- local timeLine = resMgr:createTimeline("effect/down_tishi_ui")    
 --    self.root:runAction(timeLine)
 --    timeLine:gotoFrameAndPause(0)
end

--CALLBACKS_FUNCS_END

return UIFinishTip

--endregion
