--region FireFinish.lua
--Author : untory
--Date   : 2016/12/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local FireFinish  = class("FireFinish", function() return gdisplay.newWidget() end )

function FireFinish:ctor()
    self:CreateUI()
end

function FireFinish:CreateUI()
    local root = resMgr:createWidget("common/city_burn")
    self:initUI(root)
end

function FireFinish:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/city_burn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.rebuild_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function FireFinish:onCureHandler(sender, eventType)

    global.worldApi:rebuildCity(function(msg)
        
        global.userData:setCityState(0)
        global.userData:setWorldCityID(msg.lCityId)
        global.panelMgr:closePanel("FireFinish")

        local scMgr = global.scMgr
        if scMgr:isMainScene() then

            scMgr:gotoWorldSceneWithAnimation()
        end
    end)    
end
--CALLBACKS_FUNCS_END

return FireFinish

--endregion
