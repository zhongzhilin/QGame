--region UIActivityInfoPanel.lua
--Author : zzl
--Date   : 2017/12/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityInfoPanel  = class("UIActivityInfoPanel", function() return gdisplay.newWidget() end )

function UIActivityInfoPanel:ctor()
    self:CreateUI()
end

function UIActivityInfoPanel:CreateUI()
    local root = resMgr:createWidget("activity/activity_info")
    self:initUI(root)
end

function UIActivityInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.ScrollView_1 = self.root.Node_export.ScrollView_1_export
    self.desc_text = self.root.Node_export.ScrollView_1_export.desc_text_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIActivityInfoPanel:setData(data)

    self.data = data 

    uiMgr:setRichText(self, "desc_text", self.data.ruleinfo)

    local size = self.desc_text:getRichTextSize()

    self.ScrollView_1:setInnerContainerSize(cc.size(size.width,size.height))

    if size.height <  self.ScrollView_1:getContentSize().height then 
        self.desc_text:setPositionY(self.ScrollView_1:getContentSize().height)
    else 
        self.desc_text:setPositionY(size.height)
    end 

    self.ScrollView_1:jumpToTop()

end 


function UIActivityInfoPanel:close_panel(sender, eventType)
        
    global.panelMgr:closePanel("UIActivityInfoPanel")

end
--CALLBACKS_FUNCS_END

return UIActivityInfoPanel

--endregion
