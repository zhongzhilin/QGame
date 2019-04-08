--region UIfail.lua
--Author : anlitop
--Date   : 2017/06/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIfail  = class("UIfail", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")

function UIfail:ctor()
    self:CreateUI()
end

function UIfail:CreateUI()
    local root = resMgr:createWidget("player/node/win_or_fail2")
    self:initUI(root)
end

function UIfail:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/win_or_fail2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END



function UIfail:showAction()

     actionManger.getInstance():createTimeline(self.root ,"UIfail" , true , true)
end 

return UIfail

--endregion
