--region UILeisurePanel.lua
--Author : yyt
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILeisurePanel  = class("UILeisurePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UILeisureCell = require("game.UI.leisure.UILeisureCell")

function UILeisurePanel:ctor()
    self:CreateUI()
end

function UILeisurePanel:CreateUI()
    local root = resMgr:createWidget("leisureList/leisure_list_panel")
    self:initUI(root)
end

function UILeisurePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "leisureList/leisure_list_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.NodeTitle = self.root.Node_export.NodeTitle_export
    self.top = self.root.Node_export.top_export
    self.bottom = self.root.Node_export.bottom_export
    self.tbSize = self.root.Node_export.tbSize_export
    self.cellSize = self.root.Node_export.cellSize_export
    self.table_node = self.root.Node_export.table_node_export
    self.showTitle = self.root.Node_export.showTitle_mlan_4_export
    self.noShow = self.root.Node_export.noShow_mlan_26_export
    self.cancelBtn = self.root.Node_export.cancelBtn_export
    self.editBtn = self.root.Node_export.editBtn_export
    self.confirmBtn = self.root.Node_export.confirmBtn_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Panel_2, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.cancelBtn, function(sender, eventType) self:cancelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.editBtn, function(sender, eventType) self:editHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.confirmBtn, function(sender, eventType) self:confirmHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top, self.bottom)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UILeisureCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

    global.m_LeisurePanel = self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UILeisurePanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UILeisurePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.isEditState = false
end

local beganPos = cc.p(0,0)
local isMoved = false
function UILeisurePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UILeisurePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UILeisurePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UILeisurePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UILeisurePanel:onEnter()

    -- 刷新占领野地上限数
    global.resData:updateOccupy()
    
    -- 空闲监听列表
    local eventList = global.leisureData:getEventList()
    for _,v in pairs(eventList) do
        self:addEventListener(global.gameEvent[v], function ()
            self:setData(true)
        end)
    end

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        self:setData(true)
    end) 

    -- 蜡烛特效
    local nodeTimeLine = resMgr:createTimeline("leisureList/leisure_list_panel")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)

    self.isPageMove = false
    self:registerMove()

    self.isPanelOnEnter = true
    self:setData()

end

function UILeisurePanel:setData(isReset)

    local data = global.leisureData:getLeisure() 
    self:editState(data)
    self.tableView:setData(data, isReset)
end

function UILeisurePanel:editState(data)
    -- body
    if not self.isEditState then
        self.cancelBtn:setVisible(false)
        self.confirmBtn:setVisible(false)
        self.editBtn:setVisible(true)
        self.NodeTitle:setPositionX(-50)
        self.showTitle:setVisible(false)
    else
        self.cancelBtn:setVisible(true)
        self.confirmBtn:setVisible(true)
        self.editBtn:setVisible(false)
        self:titleAction()
        self.showTitle:setVisible(true)
    end

    if table.nums(data) <= 0 then
        self.noShow:setVisible(true)
    else
        self.noShow:setVisible(false)
    end

end

function UILeisurePanel:exit(sender, eventType)
    self.isEditState = false
    global.leisureData:initLeisureAll()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    global.panelMgr:closePanel("UILeisurePanel")
end

function UILeisurePanel:cancelHandler(sender, eventType)
    
    self.isEditState = false
    global.leisureData:initLeisureAll()
    self:setData(true)
    global.tipsMgr:showWarning("operate_failed")
end

function UILeisurePanel:editHandler(sender, eventType)

    uiMgr:addSceneModel(0.5)
    self.isEditState = true 
    global.leisureData:initLeisureAll(true)
    local data = clone(global.leisureData:getLeisure())
    for i,v in ipairs(data) do
        if global.leisureData:isExitLocal(v.id) then
            v.isSelected = false
        else
            v.isSelected = true
        end
    end

    self.editData = data
    self.tableView:setData(self.editData)
    self:editState(self.editData)    
end

function UILeisurePanel:confirmHandler(sender, eventType)

    self.isEditState = false
    self.NodeTitle:setPositionX(-50)
    local selectList = {}
    self.editData = self.editData or {}
    for _,v in pairs(self.editData) do        
        if not v.isSelected then
            table.insert(selectList, v.id)
        end
    end

    if not global.leisureData:isChangeList(selectList) then
        global.leisureData:initLeisureAll()
        global.tipsMgr:showWarning("operate_failed")
    else
        global.leisureData:writeLeisureList(selectList)
        global.tipsMgr:showWarning("operate_success")
        gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
    end
    self:setData()

end

-- 标题跟随
function UILeisurePanel:titleAction()
    local curPos1 = cc.p(-20, self.NodeTitle:getPositionY())
    local action = cc.MoveTo:create(0.2, curPos1)
    self.NodeTitle:runAction(action)
end

function UILeisurePanel:updateItem(data)
    for _,v in pairs(self.editData) do
        if v.id == data.id then
            v.isSelected = data.isSelected
        end 
    end
end

--CALLBACKS_FUNCS_END

return UILeisurePanel

--endregion
