--region UIRestrain.lua
--Author : anlitop
--Date   : 2017/09/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRestrain  = class("UIRestrain", function() return gdisplay.newWidget() end )
local actionManger  =require("game.UI.replay.excute.actionManger")

function UIRestrain:ctor()

end

function UIRestrain:CreateUI()
    local root = resMgr:createWidget("player/node/player_Gicon")
    self:initUI(root)
end

function UIRestrain:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/player_Gicon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

function UIRestrain:showRightRestrain()

     actionManger.getInstance():createTimeline(self ,"showRightRestrain" , true , true)
end

function UIRestrain:showLeftRestrain()



     actionManger.getInstance():createTimeline(self ,"showLeftRestrain" , true , true)
end 


function UIRestrain:hideSelf()


     actionManger.getInstance():createTimeline(self ,"hideRestrain" , true , true)
end 



--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIRestrain

--endregion
