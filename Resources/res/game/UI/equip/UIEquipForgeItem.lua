--region UIEquipForgeItem.lua
--Author : yyt
--Date   : 2017/07/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
--REQUIRE_CLASS_END

local UIEquipForgeItem  = class("UIEquipForgeItem", function() return gdisplay.newWidget() end )

function UIEquipForgeItem:ctor()
    self:CreateUI()
end

function UIEquipForgeItem:CreateUI()
    local root = resMgr:createWidget("equip/equip_forge_node")
    self:initUI(root)
end

function UIEquipForgeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_forge_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node_1 = self.root.Node_1_export
    self.btn1 = self.root.Node_1_export.btn1_export
    self.baseIcon1 = self.root.Node_1_export.btn1_export.baseIcon1_export
    self.baseIcon1 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon1, self.root.Node_1_export.btn1_export.baseIcon1_export)
    self.name1 = self.root.Node_1_export.btn1_export.name1_export
    self.lv1 = self.root.Node_1_export.btn1_export.lv1_export
    self.point1 = self.root.Node_1_export.btn1_export.point1_export
    self.Node_2 = self.root.Node_2_export
    self.btn2 = self.root.Node_2_export.btn2_export
    self.baseIcon2 = self.root.Node_2_export.btn2_export.baseIcon2_export
    self.baseIcon2 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon2, self.root.Node_2_export.btn2_export.baseIcon2_export)
    self.name2 = self.root.Node_2_export.btn2_export.name2_export
    self.lv2 = self.root.Node_2_export.btn2_export.lv2_export
    self.point2 = self.root.Node_2_export.btn2_export.point2_export
    self.Node_3 = self.root.Node_3_export
    self.btn3 = self.root.Node_3_export.btn3_export
    self.point3 = self.root.Node_3_export.btn3_export.point3_export
    self.lv3 = self.root.Node_3_export.btn3_export.lv3_export
    self.name3 = self.root.Node_3_export.btn3_export.name3_export
    self.baseIcon3 = self.root.Node_3_export.btn3_export.baseIcon3_export
    self.baseIcon3 = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon3, self.root.Node_3_export.btn3_export.baseIcon3_export)

    uiMgr:addWidgetTouchHandler(self.btn1, function(sender, eventType) self:itemClickHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btn2, function(sender, eventType) self:itemClickHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btn3, function(sender, eventType) self:itemClickHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.btn1:setSwallowTouches(false)
    self.btn2:setSwallowTouches(false)
    self.btn3:setSwallowTouches(false)

    self.node1Y = self.Node_1:getPositionY()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIEquipForgeItem:onEnter()
    -- body
    self:addEventListener(global.gameEvent.EV_ON_EQUIP_FORGIN_POINT, function ()  
        if self.checkPoint then
            self:checkPoint()   
        end   
    end)
end

function UIEquipForgeItem:checkPoint()

    for i=1,3 do
        local curData = self.data[i]
        self["point"..i]:setVisible(false)
        if curData then
            self["point"..i]:setVisible(global.equipData:checkSuitTypeCanForge(curData.forgeId))
        end
    end
end

function UIEquipForgeItem:setData(data)

    self.data = data.cData
    
    for i=1,3 do
        local curItem =  self["Node_"..i]
        local curData =  self.data[i]
        curItem:setVisible(false)
        if curData then
            curItem:setVisible(true)
            self["name"..i]:setString(curData.suitName)
            self["lv"..i]:setString(curData.text)
            self["baseIcon"..i]:setData({icon=curData.icon, quality=curData.quality})
        end

        local y = i == 1 and self.node1Y or 0
        curItem:setPositionY(y)
        if data.isOffset then
            curItem:setPositionY(y+self.btn1:getContentSize().height/2)
        end
    end

    self:checkPoint()
end

function UIEquipForgeItem:itemClickHandler(sender, eventType)
    
    local sPanel = global.panelMgr:getPanel("UIEquipForgePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        
        if sPanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        local curId = sender:getTag()
        global.panelMgr:openPanel("UIForgeSelectPanel"):setData(self.data[curId])
    end
end
--CALLBACKS_FUNCS_END

return UIEquipForgeItem

--endregion
