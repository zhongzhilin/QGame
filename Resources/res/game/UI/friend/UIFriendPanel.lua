--region UIFriendPanel.lua
--Author : yyt
--Date   : 2017/08/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFriendPanel  = class("UIFriendPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIFriendItemCell = require("game.UI.friend.UIFriendItemCell")

function UIFriendPanel:ctor()
    self:CreateUI()
end

function UIFriendPanel:CreateUI()
    local root = resMgr:createWidget("friend/friend_bg")
    self:initUI(root)
end

function UIFriendPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "friend/friend_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.attack_mode_cb2 = self.root.Node_13.attack_mode_cb2_export
    self.attack_mode_cb1 = self.root.Node_13.attack_mode_cb1_export
    self.topNode = self.root.topNode_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.node_tableView = self.root.node_tableView_export
    self.noFriend = self.root.noFriend_mlan_21_export

    uiMgr:addWidgetTouchHandler(self.root.Node_13.gmBtn, function(sender, eventType) self:gmHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIFriendItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.attack_mode_cb1:setSelected(true)
    self.attack_mode_cb2:setSelected(false)

    self.attack_mode_cb1:addEventListener(function(cb,state)
        self:checkSelect(1)                     
    end)

    self.attack_mode_cb2:addEventListener(function(cb,state)
        self:checkSelect(2)
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIFriendPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_FRIEND_UPDATE, function ()
        self:setData()
    end)

    self.isSelectModel = false
    self.isStartMove = false
    self:registerMove()
    self:setData()

    self.m_eventListenerCustomList = {}
end


function UIFriendPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIFriendPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIFriendPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIFriendPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIFriendPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isStartMove = true
        return
    end
end

function UIFriendPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIFriendPanel:setData()
    
    self.noFriend:setVisible(false)
    global.unionApi:getFriendList(function (msg)
        
        msg.lispublic     = msg.lispublic or 0
        msg.tagFriendInfo = msg.tagFriendInfo or {}

        self.attack_mode_cb1:setSelected(msg.lispublic == 0)
        self.attack_mode_cb2:setSelected(msg.lispublic ~= 0)
        self.isSelectModel = true
        self.tableView:setData(self:sortFriendList(msg.tagFriendInfo))

        -- 下载用户头像
        if msg.tagFriendInfo then
            local data = {}
            for i,v in pairs(msg.tagFriendInfo) do
                if v.szCustomIco ~= "" then
                    table.insert(data,v.szCustomIco)
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
    end, 1)
    
end

function UIFriendPanel:sortFriendList(data)
    -- body
    if table.nums(data) == 0 then 
        self.noFriend:setVisible(true)
        return {} 
    end
    local shipList   = {}
    local friendList = {}
    local applyList  = {}
    for _,v in pairs(data) do
        if v.lrequest == 1 then
            table.insert(friendList, v)
        elseif v.lrequest == 2 then
            table.insert(applyList, v)
        end
    end

    table.sort(friendList, function(s1, s2) 
        if not s1.lisonline or not s2.lisonline then
            return false
        else
            return  s1.lisonline > s2.lisonline 
        end
    end)
    table.sort(applyList, function(s1, s2) return  s1.ltime > s2.ltime end)
    local insertCall = function (tbList)
        for _,v in pairs(tbList) do
            table.insert(shipList, v)
        end
    end

    insertCall(applyList)
    insertCall(friendList)
    return shipList
end

-- 是否公开
function UIFriendPanel:checkSelect(changeIndex)
    
    if self.isSelectModel then
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    end
    if changeIndex == 1 then
        self.attack_mode_cb1:setSelected(true)
        self.attack_mode_cb2:setSelected(false)
        global.unionApi:getFriendList(function (msg)
        end, 6, 1) -- 是
    elseif changeIndex == 2 then
        self.attack_mode_cb2:setSelected(true)
        self.attack_mode_cb1:setSelected(false)
        global.unionApi:getFriendList(function (msg)
        end, 6, 2) -- 否
    end
end

function UIFriendPanel:gmHandler(sender, eventType)
    global.sdkBridge:hs_showFAQs() 
end

function UIFriendPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIFriendPanel")
end

function UIFriendPanel:noHandler(sender, eventType)

end

function UIFriendPanel:yesHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIFriendPanel

--endregion
