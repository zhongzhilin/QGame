--region UIChooseSoliderEffect.lua
--Author : anlitop
--Date   : 2017/07/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChooseSoliderEffect  = class("UIChooseSoliderEffect", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")


function UIChooseSoliderEffect:ctor()
    
end

function UIChooseSoliderEffect:CreateUI()
    local root = resMgr:createWidget("effect/light_zdhf")
    self:initUI(root)
end

function UIChooseSoliderEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/light_zdhf")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UIChooseSoliderEffect:showTopAction()
	actionManger.getInstance():createTimeline(self.root  ,"showTopChooseSoliderEffect" , true , true)
end 


function UIChooseSoliderEffect:showBottomAction()
	actionManger.getInstance():createTimeline(self.root  ,"showBottomChooseSoliderEffect" , true , true)
end 

function UIChooseSoliderEffect:HideAllNoAction()
	actionManger.getInstance():createTimeline(self.root  ,"hideChooseSoliderEffect" , true , true)
end 



return UIChooseSoliderEffect

--endregion
