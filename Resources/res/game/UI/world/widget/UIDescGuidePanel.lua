--region UIDescGuidePanel.lua
--Author : untory
--Date   : 2017/04/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDescGuidePanel  = class("UIDescGuidePanel", function() return gdisplay.newWidget() end )

function UIDescGuidePanel:ctor()
    self:CreateUI()
end

function UIDescGuidePanel:CreateUI()
    local root = resMgr:createWidget("world/director/guide_content")
    self:initUI(root)
end

function UIDescGuidePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/director/guide_content")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.guide_content = self.root.guide_content_export
    self.text = self.root.guide_content_export.text_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END
end

function UIDescGuidePanel:setData(data)
    
    self.data = data
    self.text:setString(global.luaCfg:get_local_string(data.des))
    self.guide_content:setPositionY(data.y or 500)

    self.root.Panel_1:setTouchEnabled(not data.isHideTouch)
    local bgSize = self.guide_content.bj:getContentSize()

    data.dtY = data.dtY or 0
    if data.panelName and data.widgetName then
        local panel = global.panelMgr:getPanel(data.panelName)
        if panel then

            local widget = ccui.Helper:seekNodeByName(panel, data.widgetName)
            if widget then
                local pointPos = widget:convertToWorldSpace(cc.p(0,0))     
                local rectSize =  widget.rect_export:getContentSize()        
                pointPos.y = pointPos.y + data.dtY - bgSize.height/2 - rectSize.height/2 + 15
                self.guide_content:setPositionY(pointPos.y)
            end
        end
    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDescGuidePanel:exit(sender, eventType)

    global.panelMgr:closePanel("UIDescGuidePanel")
    global.guideMgr:dealScript()
end
--CALLBACKS_FUNCS_END

return UIDescGuidePanel

--endregion
