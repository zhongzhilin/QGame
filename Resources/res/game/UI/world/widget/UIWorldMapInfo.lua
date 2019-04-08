--region UIWorldMapInfo.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIWorldMapInfoItem1 = require("game.UI.world.widget.UIWorldMapInfoItem1")
local UIWorldMapInfoItem2 = require("game.UI.world.widget.UIWorldMapInfoItem2")
--REQUIRE_CLASS_END

local UIWorldMapInfo  = class("UIWorldMapInfo", function() return gdisplay.newWidget() end )

function UIWorldMapInfo:ctor()
    self:CreateUI()
end

function UIWorldMapInfo:CreateUI()
    local root = resMgr:createWidget("world/miracle_info_bj")
    self:initUI(root)
end

function UIWorldMapInfo:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/miracle_info_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Panel_54.Node_image.name_mlan_12_export
    self.top_1 = UIWorldMapInfoItem1.new()
    uiMgr:configNestClass(self.top_1, self.root.Node_export.top_1)
    self.top_2 = UIWorldMapInfoItem1.new()
    uiMgr:configNestClass(self.top_2, self.root.Node_export.top_2)
    self.top_3 = UIWorldMapInfoItem1.new()
    uiMgr:configNestClass(self.top_3, self.root.Node_export.top_3)
    self.top_4 = UIWorldMapInfoItem1.new()
    uiMgr:configNestClass(self.top_4, self.root.Node_export.top_4)
    self.sort_1 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_1, self.root.Node_export.sort_1)
    self.sort_2 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_2, self.root.Node_export.sort_2)
    self.sort_3 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_3, self.root.Node_export.sort_3)
    self.sort_4 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_4, self.root.Node_export.sort_4)
    self.sort_5 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_5, self.root.Node_export.sort_5)
    self.sort_6 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_6, self.root.Node_export.sort_6)
    self.sort_7 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_7, self.root.Node_export.sort_7)
    self.sort_8 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_8, self.root.Node_export.sort_8)
    self.sort_9 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_9, self.root.Node_export.sort_9)
    self.sort_10 = UIWorldMapInfoItem2.new()
    uiMgr:configNestClass(self.sort_10, self.root.Node_export.sort_10)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIWorldMapInfo:setData()
    
    for i = 1,4 do

        self["top_" .. i]:setData(i)
    end

    for i = 1,10 do

        self["sort_" .. i]:setData(i)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldMapInfo:onCloseHanler(sender, eventType)

    global.panelMgr:closePanelForBtn("UIWorldMapInfo")
end
--CALLBACKS_FUNCS_END

return UIWorldMapInfo

--endregion
