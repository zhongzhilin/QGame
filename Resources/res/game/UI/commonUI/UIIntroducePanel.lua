--region UIIntroducePanel.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIIntroducePanel  = class("UIIntroducePanel", function() return gdisplay.newWidget() end )

function UIIntroducePanel:ctor()
    self:CreateUI()
end

function UIIntroducePanel:CreateUI()
    local root = resMgr:createWidget("common/introduction_sec")
    self:initUI(root)
end

function UIIntroducePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/introduction_sec")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.title = self.root.Node_export.title_export
    self.ScrollView_1 = self.root.Node_export.ScrollView_1_export
    self.content = self.root.Node_export.ScrollView_1_export.content_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIIntroducePanel:setData(data)
    
    self.title:setString(data.title)

    local params = data.addParams or {}
    uiMgr:setRichText(self, "content", tonumber(data.content), params)
    local size = self.content:getRichTextSize()

    self.ScrollView_1:setInnerContainerSize(cc.size(size.width,size.height))

    if size.height <  self.ScrollView_1:getContentSize().height then 
        self.content:setPositionY(self.ScrollView_1:getContentSize().height - 15 )
    else 
        self.content:setPositionY(size.height)
    end 

    self.ScrollView_1:jumpToTop() 

end

function UIIntroducePanel:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIIntroducePanel")
end
--CALLBACKS_FUNCS_END

return UIIntroducePanel

--endregion
