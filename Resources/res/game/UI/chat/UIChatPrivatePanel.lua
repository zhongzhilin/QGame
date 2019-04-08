--region UIChatPrivatePanel.lua
--Author : yyt
--Date   : 2017/01/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local chatData = global.chatData
local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIChatItemCell = require("game.UI.chat.UIChatItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIChatFuncBoard = require("game.UI.chat.UIChatFuncBoard")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIChatPrivatePanel  = class("UIChatPrivatePanel", function() return gdisplay.newWidget() end )

function UIChatPrivatePanel:ctor()
    self:CreateUI()
end

function UIChatPrivatePanel:CreateUI()
    local root = resMgr:createWidget("chat/chat_private")
    self:initUI(root)
end

function UIChatPrivatePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_private")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.tableNode = self.root.tableNode_export
    self.titleNode = self.root.titleNode_export
    self.toName = self.root.titleNode_export.toName_mlan_16_export
    self.tf_Input = self.root.input.inputBox.tf_Input_export
    self.tf_Input = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Input, self.root.input.inputBox.tf_Input_export)
    self.TableSize = self.root.TableSize_export
    self.NodeTop = self.root.NodeTop_export
    self.NodeBottom = self.root.NodeBottom_export
    self.CellSize = self.root.CellSize_export
    self.FuncPanel = self.root.FuncPanel_export
    self.FuncNode = self.root.FuncPanel_export.FuncNode_export
    self.FuncNode = UIChatFuncBoard.new()
    uiMgr:configNestClass(self.FuncNode, self.root.FuncPanel_export.FuncNode_export)
    self.topSize = self.root.FuncPanel_export.topSize_export
    self.model = self.root.model_export
    self.flushNode = self.root.flushNode_export

    uiMgr:addWidgetTouchHandler(self.root.input.senderBtn, function(sender, eventType) self:sender(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.FuncPanel, function(sender, eventType) self:hideFuncBorard(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.model, function(sender, eventType) self:modelClickHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UIChatTableView.new()
        :setSize(self.TableSize:getContentSize(), self.NodeTop, self.NodeBottom)
        :setCellSize(self.CellSize:getContentSize())
        :setCellTemplate(UIChatItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)  
        :setColumn(1)      
    self.tableNode:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

    self.FuncPanel:setSwallowTouches(false)
    self.nodeMaxPosY = gdisplay.height - self.topSize:getContentSize().height  -- self.FuncNode 最大位置

    self.currChatManName = ""
    self.currChatManId = 0

    -- 加载
    local loading_TimeLine = resMgr:createTimeline("world/map_Load")
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)

    self.tf_Input:addEventListener(handler(self, self.inputEvent))

    self:adapt()

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChatPrivatePanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 

function UIChatPrivatePanel:registerMoveAction()

    local nextPanel = global.panelMgr:getPanel("UIMailListPanel")
    local touchNode = cc.Node:create()
    self:addChild(touchNode)

    local  listener = cc.EventListenerTouchOneByOne:create()
    local beginTime = 0
    local moveDelet = 0

    local function touchBegan(touch, event)

        if self:getPositionX() ~= 0 then return false end
   
        nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))
        beginTime = global.dataMgr:getServerTime()
        nextPanel:stopAllActions()
        self.isStartMoveAction = true
        moveDelet = 0
        return true  
    end

    local function touchMoved(touch, event)

        if not self.isStartMoveAction then
            return
        end

        local diff = touch:getDelta()
        moveDelet = moveDelet + diff.x
        local isTouch = self.tableView:isTouchEnabled()    
        if isTouch == true then
            if math.abs(diff.x) / 1.5 > math.abs(diff.y) then
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

        if not self.isStartMoveAction then
            return
        end

        self.tableView:setTouchEnabled(true)

        local diff = touch:getDelta()
        local moveWidth = (touch:getLocation().x - touch:getStartLocation().x)*2

        local currentPosX = self:getPositionX() 
        local contentTime = global.dataMgr:getServerTime()  - beginTime
        local speed = moveDelet / (contentTime)
        if currentPosX >= gdisplay.width / 2 or speed > 1500 then         
            self:exit_call()
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
    touchNode:setLocalZOrder(8)
    self.lis = listener
end

function UIChatPrivatePanel:tableMove()

    self.isStartMoveAction = nil
    self.isStartMove = true
    self.FuncPanel:setVisible(false)

    local tbSize = self.TableSize:getContentSize().height
    local curOffsetY = math.abs(self.tableView:getContentOffset().y)
    local maxOffsetY = math.abs(self.tableView:minContainerOffset().y)

    if curOffsetY > (maxOffsetY + tbSize/5) then
        if not self.isVisFlush then
            self.isInitEnter = false
            self.lastFlushOffset = self.tableView:getContentOffset()
            self:showFlush()
        end
    else
        if self.isVisFlush and (curOffsetY < (maxOffsetY + 64)) then
            self:hideFlush()
        end
    end
end

function UIChatPrivatePanel:onExit()
    self.data = {}
    global.isTranslating = nil
    global.chatFlushing = nil
end

function UIChatPrivatePanel:onEnter()

    self.isVisFlush = false             -- 刷新状态
    self.isStartMove = false            -- 滑动状态
    self.isScroToBottom = true          -- 是否需要滑动至最底部
    self.curlPage = 1                   -- 当前拉取的页
    self.lastFlushOffset = cc.p(0, 0)   -- 下拉刷新前的位移

    self:hideFuncBorard()
    self:initEventListener()    
end

function UIChatPrivatePanel:initEventListener()

    local resetOffset = function (tbOffset, minOffset)
        -- body
        local curMinOffset = self.tableView:minContainerOffset().y
        if curMinOffset < 0 then
            tbOffset.y = tbOffset.y - (math.abs(curMinOffset) - minOffset)
            self.tableView:setContentOffset(tbOffset)
        end
    end

    --- 新消息通知监听
    self:addEventListener(global.gameEvent.EV_ON_NEW_CHAT, function (event, msg)
        
        if not msg then return end
        local isPriNew = (msg.lType == 1) and (not chatData:isShieldUser(self.currChatManId))
        if isPriNew  then

            local tbOffset = self.tableView:getContentOffset()
            local minOffset = math.abs(self.tableView:minContainerOffset().y)

            self.isScroToBottom = false
            local data = global.chatData:getChatByKey(self.currChatManId) or {}
            self:setUIData(data.value or {})

            resetOffset(tbOffset, minOffset) -- 重置
        end
    end) 

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.getChatData then
            global.chatFlushing = nil
            self:getChatData()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.getChatData then
            self:getChatData()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        self:hideFlush()
    end)

     self:addEventListener(global.gameEvent.EV_ON_CHAT_TRANSLATE,function()
        local tbOffset = self.tableView:getContentOffset()
        self.tableView:setData(self.data)
        self.tableView:setTouchEnabled(true)
        local curMinOffset = self.tableView:minContainerOffset().y
        if curMinOffset < 0 then
            self.tableView:setContentOffset(tbOffset)
        end
    end)

end

function UIChatPrivatePanel:inputEvent(eventType)
    if eventType == "began" then
        self.model:setVisible(true)
    end
    if eventType == "return" then
        self.model:setVisible(false)
    end
end

function UIChatPrivatePanel:setData(data)

    local tempData = global.chatData:getChatMsg(data)
    local chat = clone(chatData:getChatByKey(self.currChatManId)) -- 缓存记录
    if chat ~= nil and (#chat.value > 0) then
        tempData = chatData:inertChat(chat.value, tempData)
    end

    self:setUIData(tempData)  
end

function UIChatPrivatePanel:setUIData(data)

    if self.curlFaceID and self.curlFaceID ~= 0 then
        for _,v in pairs(data) do
            if (v.lFrom ==  self.currChatManId) or (v.lTo == self.currChatManId) then
                v.lFaceID = self.curlFaceID
            end
        end
    end

    self.model:setVisible(false)
    self:hideFuncBorard()
    global.chatData:setCurLType(1)

    chatData:saveChat(self.currChatManId, data or {}, self.curlPage)
    chatData:setCurChat(data)
    data = chatData:getChatByKey(self.currChatManId).value

    self.data = data
    -- 刷新时间贴条
    data = global.chatData:updateTime(data)
    self.tableView:setData(data)
    if self.isScroToBottom or self.isInitEnter then
        self.tableView:scrollToBottom()
    end

end

function UIChatPrivatePanel:refershData(curInfo)

    if self.data and #self.data > 0 then
        for _,v in pairs(self.data) do
            if (v.lFrom ==  self.currChatManId) or (v.lTo == self.currChatManId) then
                v.szFrom = curInfo.szName
                v.lFaceID = curInfo.lFace
                v.szAllyNick = curInfo.szAllyShortName
            end
        end

        local tbOffset = self.tableView:getContentOffset()
        self.tableView:setData(self.data)
        chatData:saveChat(self.currChatManId, clone(self.data), self.curlPage)
        self.tableView:setContentOffset(tbOffset)
    end
end

function UIChatPrivatePanel:init(recvId, recvName, isNeedMoveAction)

    -- 用于记录读取状态
    global.chatApi:logicNotifyRead(function(msg)
    end, recvId, 0)

    --清除数据
    self.toName:setString("")
    self.tableView:setData({})

    self.flushNode:setVisible(false)
    self.isInitEnter = true
    self:setCurChatManMsg(recvId or 0 , recvName or "")
    self:getChatData()


    --　添加手势滑动
    if isNeedMoveAction and (not self.lis) then 
        self:registerMoveAction()
    elseif self.lis then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.lis)
        self.lis = nil
    end

end

-- 获取聊天数据
function UIChatPrivatePanel:getChatData() 
    
    local chat = chatData:getChatByKey(self.currChatManId) 
    local isHistory = (chat ~= nil and (#chat.value > 0) and (chat.lPage >= 1))

    if chatData:getIsResume() then
        self.curlPage = 1
        self:pullServerData()
    else 
        if isHistory then
            self.curlPage = chat.lPage
            self:setUIData(chat.value or {})
        else
            self.curlPage = 1
            self:pullServerData()
        end
    end
end

-- 拉取服务器数据
function UIChatPrivatePanel:pullServerData()
    
    -- 避免网络差的情况多次发送数据叠加的问题      
    if global.chatFlushing then return end
    global.chatFlushing = true

    global.chatApi:getMsgInfo(function(msg)

        global.chatFlushing = nil
        self.curlPage = self.curlPage or 1

        local isResume = chatData:getIsResume()
        if isResume then
            if not tolua.isnull(self.tableView) then 
                self.tableView:setData({})
            end 
            chatData:removeChatByKey(self.currChatManId)
            chatData:setIsResume(false)
        end

        if self.hideFlush then
            self:hideFlush()
        end 
        msg.tagMsg = msg.tagMsg or {}
        if #msg.tagMsg == 0 and self.curlPage > 1 then
            return
        end

        self.isScroToBottom = false
        if self.setData then
            self:setData(msg.tagMsg)
        end

        if isResume then
            if not tolua.isnull(self.tableView) then 
                self.tableView:scrollToBottom()
            end 
        else
            if #msg.tagMsg > 0 and not self.isInitEnter then

                if not tolua.isnull(self.tableView) then 
                    
                    if self.tableView:minContainerOffset().y < 0 then
                        self.tableView:setContentOffset(self.lastFlushOffset)
                    end
                end 

                self.isInitEnter = false
            end
        end

    end, 1, self.curlPage, self.currChatManId)

end

--- 下拉刷新
function UIChatPrivatePanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self.curlPage = 1

    local chat = chatData:getChatByKey(self.currChatManId) 
    local isRecode = (chat ~= nil) and (#chat.value > 0) and (chat.lPage >= 1) 
    if isRecode then
        self.curlPage = chat.lPage + 1
    end

    self:pullServerData()
end

function UIChatPrivatePanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end


-- 初始化当前聊天对象信息
function UIChatPrivatePanel:setCurChatManMsg(recvId, recvName)
    
    self.currChatManId = recvId
   
    -- 拉取用户详细信息
    global.chatApi:getUserInfo(function(msg)
               
        local strName = 0
        msg.tgInfo = msg.tgInfo or {}

        local data = msg.tgInfo[1] 
        if not data then return end
        if data.szAllyShortName and data.szAllyShortName ~= "" then
            strName = "【"..data.szAllyShortName.."】".. data.szName 
        else
            strName = data.szName
        end

        if self.refershData then -- protect 
            self:refershData(data)
            self.toName:setString(strName)
            self.currChatManName = strName
        end 

    end, {recvId})

end

function UIChatPrivatePanel:setCurMsg(data)

    self.currChatManName = data.szName

    if data.szAllyNick and data.szAllyNick ~= "" then
        self.toName:setString("【"..data.szAllyNick.."】"..data.szName)
    else
        self.toName:setString(data.szName)
    end
    self.curlFaceID = data.lFaceID
end

function UIChatPrivatePanel:setCurMsgPri(data)

    self.currChatManName = data.szFrom

    if data.szAllyNick and data.szAllyNick ~= "" then
        self.toName:setString("【"..data.szAllyNick.."】"..data.szFrom)
    else
        self.toName:setString(data.szFrom)
    end
    self.curlFaceID = data.lFaceID
end

--- 发送消息
function UIChatPrivatePanel:sender(sender, eventType)
    
    -- 屏蔽对象
    if chatData:isShieldUser(self.currChatManId) then
        global.tipsMgr:showWarning("BLACK_LIST_SEND")
        return
    end
    
    local lPage = 1
    local szContent = self.tf_Input:getString()

    if szContent == "" or szContent == " " then
        global.tipsMgr:showWarning("chatEmpty")
        return
    end

    if not global.chatData:checkLength(szContent) then 
        return
    end

    local lFromId, lToId = global.userData:getUserId(), self.currChatManId
    global.chatApi:senderMsg(function(msg)
        
        if not tolua.isnull(self.tf_Input) then 
            self.tf_Input:setString("")
        end 

        self.isScroToBottom = true
        chatData:addChat(self.currChatManId, msg.tagMsg or {})
        if self.getChatData then 
            self:getChatData()
        end 

    end, 1, szContent, lFromId, lToId )

end


function UIChatPrivatePanel:exit_call(sender, eventType)

    self:hideFuncBorard()

    global.sactionMgr:closePanelForAction("UIChatPrivatePanel", "UIMailListPanel")
    global.chatApi:logicNotifyRead(function(msg)
    
        -- 刷新列表最新消息
        local  panel = global.panelMgr:getPanel("UIMailListPanel")
        panel:initData()
        
    end, self.currChatManId, 1)

    chatData:setCurLType(chatData:getCurChatPage())
end

--- 显示复制私聊功能面板
function UIChatPrivatePanel:showFuncBorard(data, pos, rowPosX)
    self.FuncPanel:setVisible(true)
    self.FuncNode:setData(data)
    self.FuncNode:setPosition(pos)

    local posR = self.FuncNode:convertToNodeSpace(cc.p(rowPosX, 0))
    self.FuncNode.row:setPositionX(posR.x)
end

function UIChatPrivatePanel:hideFuncBorard(sender, eventType)
    self.FuncPanel:setVisible(false)
end

function UIChatPrivatePanel:modelClickHandler(sender, eventType)
    self.model:setVisible(false)
end
--CALLBACKS_FUNCS_END

return UIChatPrivatePanel

--endregion
