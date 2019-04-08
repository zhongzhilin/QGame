--region ResourceNum.lua
--Author : wuwx
--Date   : 2016/08/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local ResourceNum  = class("ResourceNum", function() return gdisplay.newWidget() end )

local ResourceNumControl = require("game.UI.commonUI.unit.ResourceNumControl")

function ResourceNum:ctor()
    
end

function ResourceNum:CreateUI()
    local root = resMgr:createWidget("common/mainui_resource_num")
    self:initUI(root)
end

function ResourceNum:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/mainui_resource_num")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.LoadPanel = self.root.resBtn.LoadPanel_export
    self.loadLayout = self.root.resBtn.LoadPanel_export.loadLayout_export
    self.loadBarSp = self.root.resBtn.LoadPanel_export.loadBarSp_export
    self.num = self.root.resBtn.num_export
    self.num_icon = self.root.resBtn.num_icon_export
    self.btn_click = self.root.resBtn.btn_click_export
    self.icon = self.root.resBtn.btn_click_export.icon_export

    uiMgr:addWidgetTouchHandler(self.root.resBtn, function(sender, eventType) self:res_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_click, function(sender, eventType) self:res_click(sender, eventType) end)
--EXPORT_NODE_END

    self.control = ResourceNumControl.new(self.root)
end

function ResourceNum:setData(data)
    self.control:setData(data)
end

function ResourceNum:setFirstScroll(s,isNotify)
    self.control:setFirstScroll(s,isNotify)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function ResourceNum:res_click(sender, eventType)

    local resPanel = global.panelMgr:openPanel("UIResPanel")
    resPanel:setData()
end
--CALLBACKS_FUNCS_END

return ResourceNum

--endregion
