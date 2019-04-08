--region UIVS.lua
--Author : anlitop
--Date   : 2017/06/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIVS  = class("UIVS", function() return gdisplay.newWidget() end )
local actionManger  =require("game.UI.replay.excute.actionManger")

function UIVS:ctor()
	
end

function UIVS:CreateUI()
    local root = resMgr:createWidget("player/node/vs")
    self:initUI(root)
end

function UIVS:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/vs")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.vs = self.root.vs_export

--EXPORT_NODE_END
end


function UIVS:hideVsNoAction()

    -- print("//////////////////////隐藏vs  没有动画")
    actionManger.getInstance():createTimeline(self.root  ,"hideVs" , true , true)
end 


function UIVS:hideVsWithAction()

    actionManger.getInstance():createTimeline(self.root  ,"hideVsAction" , true , true)

end 

function UIVS:showVsWithAction()

	actionManger.getInstance():createTimeline(self.root  ,"showVsAction" , true , true)
end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIVS

--endregion
