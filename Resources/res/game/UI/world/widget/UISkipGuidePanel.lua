--region UISkipGuidePanel.lua
--Author : untory
--Date   : 2017/06/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISkipGuidePanel  = class("UISkipGuidePanel", function() return gdisplay.newWidget() end )

function UISkipGuidePanel:ctor()
    self:CreateUI()
end

function UISkipGuidePanel:CreateUI()
    local root = resMgr:createWidget("world/director/guide_skip")
    self:initUI(root)
end

function UISkipGuidePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/director/guide_skip")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.skip, function(sender, eventType) self:skipAction(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISkipGuidePanel:skipAction(sender, eventType)

    sender:setEnabled(false)

    global.guideMgr:stop()
    global.commonApi:setGuideStep(global.guideMgr:getCurStep(),function()
        
        -- global.guideMgr:cleanCache()
        -- global.guideMgr.isInScript = false
        global.scMgr:gotoMainSceneWithAnimation()    
        global.guideMgr:setTaskEvent(global.gameEvent.EV_ON_ENTER_MAIN_SCENE)
    end)


    -- global.scMgr:gotoMainSceneWithAnimation()
end
--CALLBACKS_FUNCS_END

return UISkipGuidePanel

--endregion
