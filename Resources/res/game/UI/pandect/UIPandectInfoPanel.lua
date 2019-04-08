--region UIPandectInfoPanel.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPandectInfoPanel  = class("UIPandectInfoPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIPandectInfoCell = require("game.UI.pandect.UIPandectInfoCell")

function UIPandectInfoPanel:ctor()
    self:CreateUI()
end

function UIPandectInfoPanel:CreateUI()
    local root = resMgr:createWidget("common/pandect_info_bg")
    self:initUI(root)
end

function UIPandectInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_info_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_export
    self.top = self.root.Node_export.top_export
    self.bottom = self.root.Node_export.bottom_export
    self.tbSize = self.root.Node_export.tbSize_export
    self.cellSize = self.root.Node_export.cellSize_export
    self.table_node = self.root.Node_export.table_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top, self.bottom)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPandectInfoCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPandectInfoPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPandectInfoPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIPandectInfoPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIPandectInfoPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPandectInfoPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIPandectInfoPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPandectInfoPanel:onEnter()

    self.isPageMove = false
    self:registerMove()
end

function UIPandectInfoPanel:setData(data, infoData)

    self.infoData = infoData
    self.txt_Title:setString(infoData.titleStr)
    table.sort(data, function (s1, s2) return s1.lFrom < s2.lFrom end)
    self.tableView:setData(data)
end

function UIPandectInfoPanel:getInfoData()
    return self.infoData.infoCata
end

function UIPandectInfoPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIPandectInfoPanel")
end
--CALLBACKS_FUNCS_END

return UIPandectInfoPanel

--endregion
