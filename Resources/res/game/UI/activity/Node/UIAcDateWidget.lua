 --region UIAcDateWidget.lua
--Author : wuwx
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAcDateWidget  = class("UIAcDateWidget", function() return gdisplay.newWidget() end )

function UIAcDateWidget:ctor()
end

function UIAcDateWidget:CreateUI()
    local root = resMgr:createWidget("activity/time_node")
    self:initUI(root)
end

function UIAcDateWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/time_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.day_bg_1 = self.root.Node_1.day_node.day_bg_1_export
    self.day_bg_2 = self.root.Node_1.day_node.day_bg_2_export
    self.day_bg_3 = self.root.Node_1.day_node.day_bg_3_export
    self.day = self.root.Node_1.day_node.day_export
    self.hour_bg_1 = self.root.Node_1.hour_node.hour_bg_1_export
    self.hour_bg_2 = self.root.Node_1.hour_node.hour_bg_2_export
    self.hour = self.root.Node_1.hour_node.hour_export
    self.min_bg_1 = self.root.Node_1.min_node_1.min_bg_1_export
    self.min_bg_2 = self.root.Node_1.min_node_1.min_bg_2_export
    self.min = self.root.Node_1.min_node_1.min_export

--EXPORT_NODE_END
end

function UIAcDateWidget:setData(i_day,i_restTime)
    local tData = global.funcGame._toFormatTime(i_restTime)
    self.day:setString(string.format("%02d",i_day))
    if i_day and i_day >= 100 then
        self.day_bg_3:setVisible(true)
    else
        self.day_bg_3:setVisible(false)
    end
    self.hour:setString(string.format("%02d",tData.hour))
    self.min:setString(string.format("%02d",tData.minute))
end
local lastIsRed = nil
function UIAcDateWidget:changeBg(isRed)
    if isRed == lastIsRed then
        return
    end
    local frameName = "ui_surface_icon/green_bg.png"
    if isRed then
        frameName = "ui_surface_icon/red_bg.png"
    end
    self.day_bg_1:setSpriteFrame(frameName)
    self.day_bg_2:setSpriteFrame(frameName)
    self.day_bg_3:setSpriteFrame(frameName)
    self.hour_bg_1:setSpriteFrame(frameName)
    self.hour_bg_2:setSpriteFrame(frameName)
    self.min_bg_1:setSpriteFrame(frameName)
    self.min_bg_2:setSpriteFrame(frameName)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIAcDateWidget

--endregion
