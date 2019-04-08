--region UIwin.lua
--Author : anlitop
--Date   : 2017/06/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local actionManger  =require("game.UI.replay.excute.actionManger")

local UIwin  = class("UIwin", function() return gdisplay.newWidget() end )

function UIwin:ctor()
    self:CreateUI()
end

function UIwin:CreateUI()
    local root = resMgr:createWidget("player/node/win_or_fail1")
    self:initUI(root)
end

function UIwin:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/win_or_fail1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function UIwin:showAction()
	
     actionManger.getInstance():createTimeline(self.root  ,"UIwin" , true , true)
end 

return UIwin

--endregion
