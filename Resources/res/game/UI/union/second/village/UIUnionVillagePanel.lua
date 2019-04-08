--region UIUnionVillagePanel.lua
--Author : yyt
--Date   : 2017/08/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionVillagePanel  = class("UIUnionVillagePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIUnionVillageCell = require("game.UI.union.second.village.UIUnionVillageCell")

function UIUnionVillagePanel:ctor()
    self:CreateUI()
end

function UIUnionVillagePanel:CreateUI()
    local root = resMgr:createWidget("union/union_village_bg")
    self:initUI(root)
end

function UIUnionVillagePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_village_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.topNode = self.root.topNode_export
    self.node_tableView = self.root.node_tableView_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.no = self.root.no_mlan_50_export
    self.flushNode = self.root.flushNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIUnionVillageCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnionVillagePanel:tableMove()

    local curOffsetY = self.tableView:getContentOffset().y
    local minOffsetY = self.tableView:minContainerOffset().y
    local maxOffsetY = self.tableView:maxContainerOffset().y
    local tbSize = self.tbSize:getContentSize().height

    local isFlush = false
    if minOffsetY > 0 and curOffsetY > (minOffsetY+tbSize/8) then
        isFlush = true 
    elseif minOffsetY <= 0 and curOffsetY > (maxOffsetY+tbSize/8) then
        isFlush = true
    end

    if isFlush and (not self.isPushOver) and (not self.isVisFlush) then
        self:showFlush()
    else
        if self.isVisFlush and (curOffsetY < (maxOffsetY+64)) then
            self:hideFlush()
        end
    end
end

function UIUnionVillagePanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIUnionVillagePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end

    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
    self.m_eventListenerCustomList = {}

end

local beganPos = cc.p(0,0)
local isMoved = false
function UIUnionVillagePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIUnionVillagePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIUnionVillagePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIUnionVillagePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIUnionVillagePanel:onEnter()

    self.m_eventListenerCustomList = self.m_eventListenerCustomList or {}
    self.isPageMove = false
    self:registerMove()
    self.no:setVisible(false)

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        self:hideFlush()
    end)

    self.isPushOver = false
    self.curlPage = 1
    self.lastData = {}
    self:showFlush()
end

--- 上拉刷新
function UIUnionVillagePanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData()
end

function UIUnionVillagePanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

-- 分页拉取联盟村庄信息
function UIUnionVillagePanel:pullServerData()

    global.unionApi:getVillageList(function (msg)

        self:hideFlush()
        msg = msg or {}
 
        if msg.tagVillage and #msg.tagVillage > 0 then 

            self:setCurTableOffset() -- 当前offset
            self:connectData(msg.tagVillage)
            self.tableView:setData(self.lastData)
            self:adjustTableOffset() -- 调整offset
            self.curlPage = self.curlPage + 1
        else
            self.isPushOver = true
        end
        self.no:setVisible(#self.lastData == 0)

        if #self.lastData == 0 then
            self.tableView:setData(self.lastData)
        end


        -- 下载用户头像
        if msg.tagVillage then
            local data = {}
            for i,v in pairs(msg.tagVillage) do
                if v.tgUser and v.tgUser.szCustomIco ~= "" then
                    table.insert(data,v.tgUser.szCustomIco)
                end
            end
            local storagePath = global.headData:downloadPngzips(data)
            table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
                -- body
                if self and not tolua.isnull(self.tableView) then
                    self.tableView:setData(self.tableView:getData(),true)
                end
            end))
        end

    end, self.curlPage)

end

function UIUnionVillagePanel:connectData(cur)
    if #cur == 0 then return end
    for _,v in ipairs(cur) do
        table.insert(self.lastData, v)
    end
end

function UIUnionVillagePanel:setCurTableOffset()
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()
end

function UIUnionVillagePanel:adjustTableOffset()
    if self.curlPage == 1 then return end
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then
        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end
end

function UIUnionVillagePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUnionVillagePanel")
end

--CALLBACKS_FUNCS_END

return UIUnionVillagePanel

--endregion
