--region UIMailListPanel.lua
--Author : yyt
--Date   : 2016/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local mailData = global.mailData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIMailEdit = require("game.UI.mail.UIMailEdit")
--REQUIRE_CLASS_END

local UIMailListPanel  = class("UIMailListPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIMailListItemCell = require("game.UI.mail.UIMailListItemCell")
local UIMailEdit = require("game.UI.mail.UIMailEdit")

function UIMailListPanel:ctor()
    self:CreateUI()
end

function UIMailListPanel:CreateUI()
    local root = resMgr:createWidget("mail/mail_second_bg")
    self:initUI(root)
end

function UIMailListPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_second_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.table_node = self.root.table_node_export
    self.common_title = self.root.common_title_export
    self.mail_two_title = self.root.common_title_export.mail_two_title_fnt_mlan_12_export
    self.editBtn = self.root.editBtn_export
    self.unEditBtn = self.root.unEditBtn_export
    self.mail_two = self.root.mail_two_export
    self.mail_two_panel = self.root.mail_two_export.mail_two_panel_export
    self.detailNode = self.root.detailNode_export
    self.detailNodeBottom = self.root.detailNodeBottom_export
    self.btnPanel = self.root.btnPanel_export
    self.readAllBtn = self.root.btnPanel_export.readAllBtn_export
    self.editPanel = self.root.editPanel_export
    self.editNode = self.root.editPanel_export.editNode_export
    self.editNode = UIMailEdit.new()
    uiMgr:configNestClass(self.editNode, self.root.editPanel_export.editNode_export)
    self.flushNode = self.root.flushNode_export

    uiMgr:addWidgetTouchHandler(self.editBtn, function(sender, eventType) self:editHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.unEditBtn, function(sender, eventType) self:unEditHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.readAllBtn, function(sender, eventType) self:readAllHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)
     
    self.tableView = UITableView.new()
        :setSize(self.mail_two:getContentSize(), self.detailNode, self.detailNodeBottom)
        :setCellSize(self.mail_two_panel:getContentSize())
        :setCellTemplate(UIMailListItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tableView:setLocalZOrder(11)
    self.tableView:registerScriptHandler(handler(self, self.mailMove), cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.table_node:addChild(self.tableView)

    uiMgr:addButtomModal(self)

    --　添加手势滑动
    self:registerMoveAction()

    self.preTableOffset = cc.p(-1, -1)
    self.minOffset = 0

    global.m_listPanel = self

    self:adapt()

end

function UIMailListPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 

function UIMailListPanel:onEnter()

    self.curPage = 1
    self.isPushOver = false -- 是否全部拉取完成
    self:hideFlush()

    self.tableView:stopAllActions()
    self.tableView:setTouchEnabled(false)
    self.tableView:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(function()
        
        self.tableView:setTouchEnabled(true)
    end)))

    self:addEventListener(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM, function ()
        self:initData()
    end) 

    -- --- 新消息通知监听
    self:addEventListener(global.gameEvent.EV_ON_CHAT_NEWMESSAGE, function ()
        self:initData()
    end) 

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        self:hideFlush()
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        self:initData()
    end)

    self.m_eventListenerCustomList = {}
    
end

function UIMailListPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

--//////////////// 上拉刷新 ///////////////////// --

function UIMailListPanel:mailMove()

    self.isStartMove = nil

    local curOffsetY = self.tableView:getContentOffset().y
    local minOffsetY = self.tableView:minContainerOffset().y
    local maxOffsetY = self.tableView:maxContainerOffset().y
    local tbSize = self.mail_two:getContentSize().height

    local isFlush = false
    if minOffsetY > 0 and curOffsetY > (minOffsetY+tbSize/8) then
        isFlush = true 
    elseif minOffsetY <= 0 and curOffsetY > (maxOffsetY+tbSize/8) then
        isFlush = true
    end

    if isFlush and (not self.isPushOver) and (not self.isVisFlush) then
        -- 刷新
        self:showFlush()
    else
        if self.isVisFlush and (curOffsetY < ( maxOffsetY +64 ) ) then
            self:hideFlush()
        end
    end

end
--- 上拉刷新
function UIMailListPanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData(true)
end

function UIMailListPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

function UIMailListPanel:pullServerData(isPush) 

     if self.typeId == 3 then
        -- 获取聊天成员列表
        global.chatApi:getChatList(function(msg)

            if self.hideFlush then 
                self:hideFlush()
            end 
            self:setCurTableOffset()
            
            self.curPage = self.curPage + 1
            msg.tagRecord = msg.tagRecord or {}
            table.sort(msg.tagRecord, function(s1, s2) return s1.lTime > s2.lTime end)
            -- 新数据插入添加
            local temp = clone(self.data)
            for _,v in pairs(msg.tagRecord) do
                table.insert(temp, v)
            end
            self:setData(temp, false, isPush)

            self:adjustTableOffset()
            if msg.tagRecord and #msg.tagRecord > 0 then
            else
                self.isPushOver = true
            end

            -- 下载用户头像
            if msg.tagRecord then
                local data = {}
                for i,v in pairs(msg.tagRecord) do
                    if v.szCustomIco ~= "" then
                        table.insert(data,v.szCustomIco)
                    end
                end
                local storagePath = global.headData:downloadPngzips(data)
                table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
                    -- body
                    if self and not tolua.isnull(self.tableView) then
                        self.tableView:setData(self.data,true)
                    end
                end))
            end

        end, self.curPage+1)

    else  

        global.mailApi:pushMail(function (msg)

            if self.hideFlush then 
                self:hideFlush()
            end 
            msg = msg or {}
            
            -- 当前offset
            if self.setCurTableOffset then 
                self:setCurTableOffset()
            end 

            if self.typeId == 7 then
                mailData:initMailHold(msg.tagMail or {})
            else 
                mailData:init(msg.tagMail or {}, true)
            end
            if self.setData  then 
                self:setData(mailData:getMailDetailData(self.typeId), false, isPush)
            end 

            -- 调整offset
            if self.adjustTableOffset then 
                self:adjustTableOffset()
            end 

            if msg.tagMail and #msg.tagMail > 0 then
            else
                self.isPushOver = true
            end

        end, self:getMinMailId(),  mailData:checkDetailType(self.typeId), 10)
    end

end

-- 获取最小mail id 
function UIMailListPanel:getMinMailId()
    
    self.typeId = self.typeId or 0
    local temp = clone(self.data) or {}
    if self.typeId == 7 then -- 收藏
        table.sort(temp, function (m1, m2) 
            m1.time = m1.time or 0
            m2.time = m2.time or 0
            return m1.time < m2.time 
        end)
        if table.nums(temp) > 0 then
            return temp[1].time 
        end
    else
        table.sort(temp, function (m1, m2) 
            m1.mailID = m1.mailID or 0
            m2.mailID = m2.mailID or 0
            return m1.mailID < m2.mailID 
        end)
        if table.nums(temp) > 0 then
            return temp[1].mailID
        end
    end
    return 0
end

function UIMailListPanel:setCurTableOffset() 
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()
end

function UIMailListPanel:adjustTableOffset()
    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset() 
    if minOffset.y < 0 then
        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end
end

--//////////////// 上拉刷新 ///////////////////// --

function UIMailListPanel:setData(data, isReset, isPush)

    if not data then return end
    self.nodeTimeLine = resMgr:createTimeline("mail/mail_second_bg")
    self:runAction(self.nodeTimeLine)

    self.typeId = mailData:getTypeId(mailData._MAILTITLE)
    self.mail_two_title:setString(mailData._MAILTITLE)
    self.nodeTimeLine:gotoFrameAndPause(0)

    -- 筛选屏蔽玩家
    -- if self.typeId == 3 then
    --     local aData = {}
    --     for _,v in ipairs(data) do
    --         if not global.chatData:isShieldUser(v.lUserID) then
    --             table.insert(aData, v)
    --         end
    --     end
    --     self.data = aData
    -- else
        self.data = data
    -- end

    if self.typeId == 3 then 
        self:priChatRead()
    end

    if not isPush then
        if not self.isEditSelect then
            self.editBtn:setVisible(true)
            self.unEditBtn:setVisible(false)
        else
            self.editBtn:setVisible(false)
            self.unEditBtn:setVisible(true)
        end
    end

    -- dump(self.data)
    self.tableView:setData(self.data, isReset)
 
end

-- 私聊读取状态初始化
function UIMailListPanel:priChatRead()
    for k,v in ipairs(self.data) do
        if v.lNewCount > 0 then
            v.state = 0 
        else
            v.state = 1
        end
    end
end

-- 将当前私聊设为已读
function UIMailListPanel:setPriChatRead(data)
    
    local readCall = function (lUserID)
        for _,v in pairs(self.data) do
            if v.lUserID == lUserID then
                local curNum = global.mailData:getCurPriUnReadNum()
                global.mailData:setCurPriUnReadNum(curNum - v.lNewCount)
                v.lNewCount = 0
            end
        end
    end

    for _,v in pairs(data) do
        readCall(v)
    end
end

function  UIMailListPanel:initData(typeId)
    -- body
    local isRset = true
    if typeId then 
        self.data = nil
        self.typeId = nil
        isRset = nil
        self.tableView:setData({}) 
    end

    local typeId = self.typeId or typeId
    if typeId == 3 then

        -- 获取聊天成员列表
        global.chatApi:getChatList(function(msg)
            if not self.setData then return end
            self.isPushOver = false
            self.curPage = 1
            msg.tagRecord = msg.tagRecord or {}
            table.sort(msg.tagRecord, function(s1, s2) return s1.lTime > s2.lTime end)
            self:setData(msg.tagRecord, isRset)

            -- 下载用户头像
            if msg.tagRecord then
                local data = {}
                for i,v in pairs(msg.tagRecord) do
                    if v.szCustomIco ~= "" then
                        table.insert(data,v.szCustomIco)
                    end
                end
                local storagePath = global.headData:downloadPngzips(data)
                table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
                    -- body
                    if self and not tolua.isnull(self.tableView) then
                        self.tableView:setData(self.data,true)
                    end
                end))
            end
        end, 1)
        
    else 
        local tempPanelData = mailData:getMailDetailData(typeId)
        self:setData(tempPanelData, isRset)
    end
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMailListPanel:btn_exit(sender, eventType)

    self:exitPanel()
end

function UIMailListPanel:exitPanel()
    global.sactionMgr:closePanelForAction("UIMailListPanel", "UIMailPanel")
    self:refershUnReadNum()
    
    local  panel = global.panelMgr:getPanel("UIMailPanel")
    panel:initData()

    self.preTableOffset = cc.p(-1, -1)
    self.minOffset = 0

    self.isEditSelect = false 
end

function UIMailListPanel:refershUnReadNum()

    if self.typeId == 3 then

        local totalUnReadNum = 0
        for _,v in pairs(self.data) do
            
            totalUnReadNum = totalUnReadNum + v.lNewCount 
        end 
        mailData:setCurPriUnReadNum(totalUnReadNum)
    end

end

function UIMailListPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIMailListPanel:registerMoveAction()
    
    local nextPanel = global.panelMgr:getPanel("UIMailPanel")
    local touchNode = cc.Node:create()
    self.table_node:addChild(touchNode)

    local  listener = cc.EventListenerTouchOneByOne:create()
    local beginTime = 0
    local moveDelet = 0

    -- 手势误差处理
    local beganPos = cc.p(0,0)
    local ALLOW_MOVE_ERROR = 7.0/160.0

    local function touchBegan(touch, event)

        if self:getPositionX() ~= 0 then 
            return false 
        end
   
        nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))

        beginTime = global.dataMgr:getServerTime()

        nextPanel:stopAllActions()
        self.isStartMove = true
        moveDelet = 0

        beganPos = touch:getLocation()

        return true  
    end

    local function touchMoved(touch, event)

        if not self.isStartMove or self.isEditSelect then
            return
        end

        local diff = touch:getDelta()
        moveDelet = moveDelet + diff.x

        local isTouch = self.tableView:isTouchEnabled()

        -- 手势误差处理
        local isMoved = false
        if self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
            isMoved = true      
        end

        if isTouch == true then

            if isMoved then  
                self.tableView:setTouchEnabled(false)
            else
                return
            end
        end

        local nextPanelX = nextPanel:getPositionX() + diff.x / 2
        local currentPosX = self:getPositionX() + diff.x
        
        if currentPosX > gdisplay.width then
            currentPosX = gdisplay.width
            self:setPosition(cc.p(currentPosX, 0))
            nextPanel:setPosition(cc.p(0 , 0))
            return
        end
        if (currentPosX+diff.x) >= 0 then
            self:setPosition(cc.p(currentPosX, 0))
            nextPanel:setPosition(cc.p(nextPanelX , 0))
        end
    end

    local function touchEnded(touch, event)

        if not self.isStartMove or self.isEditSelect then

            return
        end

        self.tableView:setTouchEnabled(true)

        local diff = touch:getDelta()
        local moveWidth = (touch:getLocation().x - touch:getStartLocation().x)*2

        local currentPosX = self:getPositionX() 
        log.debug(currentPosX)

        local contentTime = global.dataMgr:getServerTime()  - beginTime

        local speed = moveDelet / (contentTime)

        local inSpeed = (speed > 1500) and (currentPosX > 5)
        local inDistance = currentPosX >= gdisplay.width / 2

        if inDistance or inSpeed then
            self:exitPanel()
        else

            local contentX = self:getPositionX()
            local time = contentX / gdisplay.width * 0.2
            self:runAction(cc.MoveTo:create(time,cc.p(0,0)))

            nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))
        end
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)

    touchNode:setLocalZOrder(10)

    self.lis = listener
end


function UIMailListPanel:editHandler(sender, eventType)
    
    if table.nums(self.data) == 0 then
        global.tipsMgr:showWarning("EMAIL_RECEIVE_FAIL")
        return 
    end

    self.isEditSelect = true 
    for i,v in ipairs(self.data) do
        v.isSelected = false
    end

    uiMgr:addSceneModel(0.5)
    self:setData(self.data, true, true)

    self.editBtn:setVisible(false)
    self.unEditBtn:setVisible(true)
    self:showEditPanel()

end

function UIMailListPanel:unEditHandler(sender, eventType)
    
    self.isEditSelect = false
    uiMgr:addSceneModel(0.5)
    self:setData(self.data, true, true)

    self.editBtn:setVisible(true)
    self.unEditBtn:setVisible(false)
    self:hideEditPanel()
    
end

-- 编辑
function UIMailListPanel:showEditPanel()

    uiMgr:addSceneModel(1)
    self.editNode:setData(handler(self, self.editCall), self.typeId)
    self.editPanel:setVisible(true)
    self.nodeTimeLine:play("animation0", false)
    self.nodeTimeLine:setLastFrameCallFunc(function()
        self.editPanel:setVisible(true)
    end)
end

function UIMailListPanel:hideEditPanel()
    
    uiMgr:addSceneModel(1)
    self.nodeTimeLine:play("animation1", false)
    self.nodeTimeLine:setLastFrameCallFunc(function()
        self.editPanel:setVisible(false)
    end)
    
end

function UIMailListPanel:editCall(param, editIndex)
    
    if editIndex == 1 then

        self:selectAll(param)
    elseif editIndex == 2 then

        self:getRewardAll()
    elseif editIndex == 3 then

        self:delectSelect()
    elseif editIndex == 4 then

        self:readAll()
    end
end

-- 一键已读
function UIMailListPanel:readAll()

    local temp = {}
    for i,v in pairs(self.data) do
        if v.isSelected then
            table.insert(temp, v) 
        end
    end
    if table.nums(temp) == 0 then
        global.tipsMgr:showWarning("choose_email_first") 
        return 
    end 

    -- 是否标记已读  
    local curRead = {}
    for i,v in ipairs(temp) do
        if v.state == 0 then
            table.insert(curRead, v.mailID or v.lUserID) 
        end
    end

    if table.nums(curRead) == 0 then
        global.tipsMgr:showWarning("no_read_email") 
        return 
    end 

    if self.typeId == 3 then

        global.chatApi:operateChatList(function(msg)

            self.isEditSelect = false
            self:setPriChatRead(curRead)
            self:setData(self.data, true)         
            global.tipsMgr:showWarning("read_email") 
        end, 3, curRead)
    else

        global.mailApi:actionMail(curRead, 1, function(msg)

            self.isEditSelect = false
            for _,v in pairs(curRead) do
                mailData:updataReadState(v) -- 修改选中邮箱读取状态      
            end 
            self:setData(mailData:getMailDetailData(self.typeId), true)
            global.tipsMgr:showWarning("read_email") 
        end)
    end

end

-- 全选
function UIMailListPanel:selectAll(param)
    
    -- 取消
    if not param then
        
        for i,v in ipairs(self.data) do
            v.isSelected = false
        end
    else
        
        for i,v in ipairs(self.data) do
            v.isSelected = true
        end
    end
    
    self.tableView:setData(self.data, true)

end

-- 领取
function UIMailListPanel:getRewardAll()

    local temp = {}
    local selectAllId = {}
    for i,v in ipairs(self.data) do
        if v.isSelected then
            table.insert(temp, v) 
            table.insert(selectAllId, v.mailID)
        end
    end
    if table.nums(temp) == 0 then
        global.tipsMgr:showWarning("EMAIL_CHECK") 
        return 
    end  

    local curReward = {}
    for i,v in ipairs(temp) do
        if v.itemState == 0 and v.appendixContent ~= 0 then
            table.insert(curReward, v.mailID)
        end
    end

    if table.nums(curReward) == 0 then
        global.tipsMgr:showWarning("EMAIL_NO_GIFT") 
        return 
    end 

    global.mailApi:actionMail(selectAllId, 2, function(msg)

        -- 修改选中邮箱读取状态
        for _,v in pairs(selectAllId) do
            mailData:updataReadState(v)     
        end
        self.isEditSelect = false
        mailData:updataGiftState(selectAllId)
        self:setData(mailData:getMailDetailData(self.typeId), true)
        global.tipsMgr:showWarning("EMAIL_RECEIVE_COMPLETE") 
    end)

end

-- 删除
function UIMailListPanel:delectSelect()

    local isHaveReward = false
    local temp = {}
    for i,v in ipairs(self.data) do
        local isReward = (v.itemState == 0 and v.appendixContent ~= 0)
        if v.isSelected then
            if isReward then 
                isHaveReward = true
            end

            if self.typeId == 3 then
                isHaveReward = false
                table.insert(temp, v.lUserID)
            else
                table.insert(temp, v.mailID)
            end
        end
    end

    -- dump(temp,"删除邮件ID")
    -- 当前没有选中邮件
    if table.nums(temp) == 0 then
        global.tipsMgr:showWarning("EMAIL_DELETE_CHECK") 
        return 
    end 

    local confirmCall = function ()
        
        if self.typeId == 3 then 

            global.chatApi:operateChatList(function(msg)

                self.isEditSelect = false
                -- msg.tagRecord = msg.tagRecord or {}
                -- table.sort(msg.tagRecord, function(s1, s2) return s1.lTime > s2.lTime end)
                -- self:setData(msg.tagRecord)
                self:initData()
                global.tipsMgr:showWarning("EMAIL_DELETE_COMPLETE") 
                
            end, 1, temp)

        else

            local operType = self.typeId == 7 and 5 or 3
            global.mailApi:actionMail(temp, operType, function(msg)
                self.isEditSelect = false

                if self.typeId == 7 then
                    mailData:deleteMailHold(temp)
                else
                    mailData:deleteMail(temp)
                end
                -- 删除完再次拉取数据
                if self.pullServerData then 
                    self:pullServerData(false)
                end 
                global.tipsMgr:showWarning("EMAIL_DELETE_COMPLETE") 
            end)
        end
    end

    -- 选中邮件中有礼包
    if isHaveReward then
        global.tipsMgr:showWarning("delete_mail")
        return 
    end

    confirmCall()
end


function UIMailListPanel:readAllHandler(sender, eventType)
    
    global.mailApi:pushMail(function(msg)

        -- 所有邮件标记已读
        global.mailData:updataMailStateAll(mailData:checkDetailType(self.typeId))
        if self.typeId == 3 then
            global.mailData:setCurPriUnReadNum(0)
        end
        self:initData()

        local tagMail = msg.tagMail or {}
        if #tagMail == 0 then
            return global.tipsMgr:showWarning("noMailGet")
        end
        global.panelMgr:openPanel("UIMailAllRewardPanel"):setData(tagMail)

    end, 0, 999, mailData:checkDetailType(self.typeId))

end
--CALLBACKS_FUNCS_END

return UIMailListPanel

--endregion
