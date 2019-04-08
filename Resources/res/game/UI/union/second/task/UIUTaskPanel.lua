--region UIUTaskPanel.lua
--Author : wuwx
--Date   : 2017/02/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUTaskPanel  = class("UIUTaskPanel", function() return gdisplay.newWidget() end )

function UIUTaskPanel:ctor()
    self:CreateUI()
end

function UIUTaskPanel:CreateUI()
    local root = resMgr:createWidget("union/union_task_bj")
    self:initUI(root)
end

function UIUTaskPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_task_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.cur_num = self.root.capital_mlan_9.cur_num_export
    self.time = self.root.boom_mlan_12.time_export
    self.node_tableView = self.root.node_tableView_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:onHelp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bg.btn_rank, function(sender, eventType) self:onOpenRankPanel(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
    local UIUTaskCell = require("game.UI.union.second.task.UIUTaskCell")
    self.tableView = UIMultiTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUTaskCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUTaskPanel:registerMove()

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
function UIUTaskPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIUTaskPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIUTaskPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIUTaskPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end


function UIUTaskPanel:onEnter()

    self.isPageMove = false
    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_TASK, function(event, shareCall)
        self:refresh(nil,nil,shareCall)
    end)
    self:setData()
end

function UIUTaskPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUTaskPanel")
end

function UIUTaskPanel:onExit()

    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end

    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
end

function UIUTaskPanel:setData(noReset)
    self.m_selectedItemId = self.m_selectedItemId or 1
    self.cur_num:setString("")
    self.time:setString("")
    self:refresh(noReset,true)

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.cur_num:getParent(),self.cur_num)
    --global.tools:adjustNodePosForFather(self.time:getParent(),self.time)



end

function UIUTaskPanel:refresh(noReset,isOn,shareCall)
    global.unionApi:getAllyTaskList(function(msg)
        -- body
        self.data = msg.tgTasks or {}
        self.bossData = msg.tgAllyBoss or {}
        self.lFlushTime = msg.lFlushTime or 0
        self.m_isOn = isOn or self.m_isOn

        if self.getTableViewData then 
            local sortData = self:getTableViewData(self.m_selectedItemId,true)
            self.tableView:setData(sortData,noReset)
        end 

        local canGetNum = 0
        for i,v in ipairs(self.data) do
            if v.lState == 1 then
                canGetNum = canGetNum+1
            end
        end
        global.unionData:setInUnionRed(7,canGetNum)

        if self.cur_num then
            self.cur_num:setString(msg.lValue)
        end

        if not self.m_countDownTimer then
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
        end
        if self.countDownHandler then 
            self:countDownHandler()
        end 
        if shareCall then shareCall() end
    end)
end

--刷新剩余倒计时
function UIUTaskPanel:countDownHandler()

    if not self.lFlushTime then 
        --protect
        return 
    end

    local curr = global.dataMgr:getServerTime()
    local rest = self.lFlushTime-curr
    if rest < 0 then 
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_TASK)
        rest = 0
    end
    self.time:setString(global.funcGame.formatTimeToHMS(rest))

     -- 润稿处理 张亮
     global.tools:adjustNodePosForFather(self.time:getParent(),self.time,10)
end

function UIUTaskPanel:getTableViewData(itemId,isOn)
    local goData = {
        [1] = { file="UIUTaskOne",h=80,showChildren=false,childFile="UIUTaskItem",childH=125},
    }
    local showData = clone(goData[1])
    if itemId then
        showData.showChildren = isOn
        if isOn then
            self.m_selectedItemId = itemId
        end
    else
        showData.showChildren = true
        self.m_selectedItemId = 1
    end

    local parentList = global.luaCfg:union_task_type()
    local data = {}
    for i,v in ipairs(parentList) do
        local itemData = v
        itemData.isChild = false
        if self.m_selectedItemId == v.id then
            itemData.uiData = showData
        else
            itemData.uiData = clone(goData[1])
        end
        itemData.children = {}
        local canGetNum = 0
        for ii,member in pairs(self.data) do
            local dData = global.luaCfg:get_union_task_by(member.lID)
            if dData.tasktype == 3 then
                itemData.uiData.childFile = "UIUTaskItemA"
                for iii,i_boss in pairs(self.bossData) do
                    if i_boss.lSrcID == member.lID then
                        member.boss = i_boss
                    end
                end
            end
            if dData and dData.tasktype == v.type  then
                table.insert(itemData.children,{id=member.id,isChild=true,uiData={file=itemData.uiData.childFile,h=itemData.uiData.childH},bindId=v.id,sData=member})
                if member.lState == 1 then
                    canGetNum = canGetNum + 1
                end
            end
        end
        itemData.canGetNum = canGetNum

        if #itemData.children > 0 then
            table.sort( itemData.children, function(a,b)
                return b.sData.lID > a.sData.lID
            end )
        end
        table.insert(data,itemData)
        if itemData.uiData.showChildren then
            table.insertTo(data,itemData.children)
        end
    end
    return data
end

-- 今日是否已经击杀boss 
function UIUTaskPanel:isHaveKillBoss()
    -- body
    self.data = self.data or {}
    for _,v in pairs(self.data) do
        local unionTask = global.luaCfg:get_union_task_by(v.lID) 
        if v.lState == 2 and unionTask.tasktype == 3 then -- 已击杀
            return true
        end
    end
    return false
end

--展开
function UIUTaskPanel:switchOn(itemId)

    self.m_isOn = true
    local data  = self:getTableViewData(itemId,true)
    self.tableView:setData(data)
end

--收回
function UIUTaskPanel:switchOff(itemId)
    self.m_isOn = false
    local data = self:getTableViewData(itemId,false)
    self.tableView:setData(data)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUTaskPanel:onHelp(sender, eventType)
    local data = global.luaCfg:get_introduction_by(10)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIUTaskPanel:onOpenRankPanel(sender, eventType)

    global.panelMgr:openPanel("UIUDonateRankPanel")
end
--CALLBACKS_FUNCS_END

return UIUTaskPanel

--endregion
