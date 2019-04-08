--region UIPaltUpdateConfrimPanel.lua
--Author : untory
--Date   : 2017/04/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPaltUpdateConfrimPanel  = class("UIPaltUpdateConfrimPanel", function() return gdisplay.newWidget() end )

function UIPaltUpdateConfrimPanel:ctor()
    self:CreateUI()
end

function UIPaltUpdateConfrimPanel:CreateUI()
    local root = resMgr:createWidget("loading/plat_update_panel")
    self:initUI(root)
end

function UIPaltUpdateConfrimPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/plat_update_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ScrollView = self.root.update_bg.ScrollView_export
    self.maintain = self.root.update_bg.ScrollView_export.maintain_export

    uiMgr:addWidgetTouchHandler(self.root.update_bg.confirm_btn, function(sender, eventType) self:confirmHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIPaltUpdateConfrimPanel:setData(versionData)

    -- print(debug.)
    print(debug.traceback() ,"UIPaltUpdateConfrimPanel")

    
    local currLan = global.languageData:getCurrentLanguage()
    uiMgr:setRichText(self, "maintain",versionData["log_" .. currLan] or versionData["log_cn"], {})    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPaltUpdateConfrimPanel:confirmHandler(sender, eventType)
    
    if global.tools:isIos() then
        -- cc.Application:getInstance():openURL("https://itunes.apple.com/cn/app/id1218728898")
    elseif global.tools:isAndroid() then
        -- cc.Application:getInstance():openURL("")
    end

    -- global.tipsMgr:showWarningText("由于没有在平台上线，所以只能关闭游戏")
    -- global.delayCallFunc(function()
        
        
    --     -- global.funcGame:allExit()    
    -- end,nil,1)            
end
--CALLBACKS_FUNCS_END

return UIPaltUpdateConfrimPanel

--endregion
