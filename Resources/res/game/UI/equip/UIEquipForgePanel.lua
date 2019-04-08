--region UIEquipForgePanel.lua
--Author : yyt
--Date   : 2017/07/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipForgePanel  = class("UIEquipForgePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIEquipForgeItemCell = require("game.UI.equip.UIEquipForgeItemCell")
local TabControl = require("game.UI.common.UITabControl")
local UIChatTableView = require("game.UI.chat.UIChatTableView")

function UIEquipForgePanel:ctor()
    self:CreateUI()
end

function UIEquipForgePanel:CreateUI()
    local root = resMgr:createWidget("equip/forge_1st_bg")
    self:initUI(root)
end

function UIEquipForgePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/forge_1st_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.cellSize = self.root.cellSize_export
    self.topNode = self.root.topNode_export
    self.botNode = self.root.botNode_export
    self.tbSize = self.root.tbSize_export
    self.tbNode = self.root.tbNode_export
    self.contrlNode = self.root.contrlNode_export
    self.point2 = self.root.contrlNode_export.Button_1.point2_export
    self.point1 = self.root.contrlNode_export.Button_2.point1_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UIChatTableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIEquipForgeItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tbNode:addChild(self.tableView)

    self.tabControl = TabControl.new(self.contrlNode, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIEquipForgePanel:registerMove()

    local node_touch = cc.Node:create()
    self:addChild(node_touch)

    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, node_touch)
end

function UIEquipForgePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIEquipForgePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIEquipForgePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIEquipForgePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIEquipForgePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIEquipForgePanel:onEnter()

    self.isPageMove = false
    self:registerMove()
    self:onTabButtonChanged(2)

    self:checkPoint()
    self:addEventListener(global.gameEvent.EV_ON_EQUIP_FORGIN_POINT, function ()  
        if self.checkPoint then
            self:checkPoint()   
        end   
    end)
    
end

function UIEquipForgePanel:checkPoint()
    for i=1,2 do
        self["point"..i]:setVisible(global.equipData:checkSuitKindCanForge(i))
    end
end

function UIEquipForgePanel:onTabButtonChanged(index)

    self.tabControl:setSelectedIdx(index)
    self:setData(index)
end

function UIEquipForgePanel:setData(index)

    local data = self:getEquipData(index)
    self.tableView:setData(data)
end

function UIEquipForgePanel:getMaxNumByType(lType)

    local suitData = luaCfg:forge_suit()
    for _,v in ipairs(suitData) do
        if v.suitType == lType then
            return v.maxNum
        end
    end
end

function UIEquipForgePanel:getEquipData(ind)

    local temp = {}
    local suitData = clone(luaCfg:forge_suit())
    table.sort(suitData, function(s1, s2) return s1.array < s2.array end)
    local index = 3 
    local data = {}
    for _,v in ipairs(suitData) do   
       
        if v.suitType == ind and v.array <= index then
            table.insert(temp, v)

            local maxIndex = index
            if maxIndex > self:getMaxNumByType(v.suitType) then 
                maxIndex = self:getMaxNumByType(v.suitType)
            end
            if v.array == maxIndex then

                local tp = {}
                tp.cData = temp
                tp.cellH = self.cellSize:getContentSize().height
                tp.isOffset = false
                if maxIndex == self:getMaxNumByType(v.suitType) then
                    tp.cellH = tp.cellH + tp.cellH/2 
                    tp.isOffset = true
                end
    
                table.insert(data, tp)
                index = index + 3
                temp = {}
            end
        end
    end
    return data
    
end

function UIEquipForgePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIEquipForgePanel")
end

--CALLBACKS_FUNCS_END

return UIEquipForgePanel

--endregion
