--region UITitle.lua
--Author : anlitop
--Date   : 2017/06/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITitle  = class("UITitle", function() return gdisplay.newWidget() end )
local actionManger  =require("game.UI.replay.excute.actionManger")


function UITitle:ctor()
    -- self:CreateUI()
end

function UITitle:CreateUI()
    local root = resMgr:createWidget("player/node/title")
    self:initUI(root)
end

function UITitle:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/title")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.stage = self.root.stage_export
    self.name = self.root.stage_export.name_export
    self.type = self.root.stage_export.type_export

--EXPORT_NODE_END
end


function UITitle:setData(data)

    -- self.name:setString(data[1])
    self.type:setString(data)
end


function UITitle:ShowAction()

    actionManger.getInstance():createTimeline(self.root  ,"title" , true , true)
    
end 


function UITitle:hideTitleNoAction()

    local timeline= actionManger.getInstance():createTimeline(self.root  ,"hideTitleNoAction" , true , true)

end 


function UITitle:hideTitleWithAction()
    actionManger.getInstance():createTimeline(self.root  ,"hideTitle" , true , true)
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITitle

--endregion
