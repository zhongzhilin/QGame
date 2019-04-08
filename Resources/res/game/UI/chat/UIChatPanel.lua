--region UIChatPanel.lua
--Author : yyt
--Date   : 2016/12/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local chatData = global.chatData
local TabControl = require("game.UI.common.UITabControl")
local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIChatItemCell = require("game.UI.chat.UIChatItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIChatPanel  = class("UIChatPanel", function() return gdisplay.newWidget() end )
local UIChatFuncBoard = require("game.UI.chat.UIChatFuncBoard")
local UIChatUnionRecruit = require("game.UI.chat.UIChatUnionRecruit")

function UIChatPanel:ctor()
    self:CreateUI()
end

function UIChatPanel:CreateUI()
    local root = resMgr:createWidget("chat/chat_bj")
    self:initUI(root)
end

function UIChatPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.tableNode = self.root.tableNode_export
    self.tf_Input = self.root.input.inputBox.tf_Input_export
    self.tf_Input = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Input, self.root.input.inputBox.tf_Input_export)
    self.topBtnNode = self.root.topBtnNode_export
    self.titleNode = self.root.titleNode_export
    self.TableSize = self.root.TableSize_export
    self.NodeTop = self.root.NodeTop_export
    self.NodeBottom = self.root.NodeBottom_export
    self.CellSize = self.root.CellSize_export
    self.model = self.root.model_export
    self.flushNode = self.root.flushNode_export
    self.spReadState = self.root.spReadState_export
    self.unRead = self.root.spReadState_export.unRead_export
    self.FuncPanel = self.root.FuncPanel_export
    self.topSize = self.root.FuncPanel_export.topSize_export
    self.sharePanel = self.root.sharePanel_export

    uiMgr:addWidgetTouchHandler(self.root.input.senderBtn, function(sender, eventType) self:sender(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.model, function(sender, eventType) self:modelClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.inputBtn, function(sender, eventType) self:senderBgHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.FuncPanel, function(sender, eventType) self:hideFuncBorard(sender, eventType) end)
--EXPORT_NODE_END
    
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UIChatTableView.new()
        :setSize(self.TableSize:getContentSize(), self.NodeTop, self.NodeBottom)
        :setCellSize(self.CellSize:getContentSize())
        :setCellTemplate(UIChatItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN) --- BOTTOMUP
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)  
        :setColumn(1)      
    self.tableNode:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMoveHandler), cc.SCROLLVIEW_SCRIPT_SCROLL)

    self.tabControl = TabControl.new(self.topBtnNode, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.FuncPanel:setSwallowTouches(false)
    self.nodeMaxPosY = gdisplay.height - self.topSize:getContentSize().height  -- self.FuncNode 最大位置
    self.sharePanel:setContentSize(cc.size(gdisplay.width, gdisplay.height-80))

    local loading_TimeLine = resMgr:createTimeline("world/map_Load")  
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)

    self.tf_Input:addEventListener(handler(self, self.inputEvent))

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIChatPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 

function UIChatPanel:registerMove()

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
function UIChatPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIChatPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIChatPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isStartMove = true
        return
    end
end

function UIChatPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIChatPanel:tableMoveHandler()

    self.FuncPanel:setVisible(false)

    local tbSize = self.TableSize:getContentSize().height
    local curOffsetY = math.abs(self.tableView:getContentOffset().y)
    local maxOffsetY = math.abs(self.tableView:minContainerOffset().y)

    local isOffsetMin = curOffsetY < (maxOffsetY +64)
    local isOffsetMax = curOffsetY > (maxOffsetY + tbSize/5) 
    local isCanFlush  = isOffsetMax and (self.isPushAllData == chatData:getIsPushAll(chatData:getCurChatPage()))

    if (not self.isVisFlush) and isCanFlush then
        self.isInitEnter = false
        self.lastFlushOffset = self.tableView:getContentOffset()
        self:showFlush()
    else
        if self.isVisFlush and isOffsetMin then
            self:hideFlush()
        end
    end

end

function UIChatPanel:onEnter()

    self.isStartMove = false
    self:registerMove()

    self.isVisFlush = false             -- 刷新状态
    self.isScroToBottom = true          -- 是否需要滑动至最底部
    self.curlPage = 1                   -- 当前拉取的页
    self.lastFlushOffset = cc.p(0, 0)   -- 下拉刷新前的位移
    self.isPushAllData = 0              -- 数据是否已全部拉取
    
    self:hideFuncBorard()
    self:setTabControl()
    self:initEventListener()
    self:initNewMsgListener()

    self:setUnionRecruit()

    print('on chat panel')
end

function UIChatPanel:setUnionRecruit(isAction)

    if not tolua.isnull(self.unionRecruit) then
        self.unionRecruit:setVisible(false)
    end
    if self.tabControl:getSelectedIdx() == 2 and global.chatData:getChatRecruitMsg() then

        if not self.unionRecruit then
            self.unionRecruit =  UIChatUnionRecruit.new()
            self.unionRecruit:CreateUI()
            self.root:addChild(self.unionRecruit)
            self.unionRecruit:setPosition(cc.p(-2, gdisplay.height-236))
        end
        self.unionRecruit:setVisible(true)
        self.unionRecruit:setData(global.chatData:getChatRecruitMsg(), isAction)
    end
end

function UIChatPanel:initNewMsgListener()

    local resetOffset = function (tbOffset, minOffset)
        local curMinOffset = self.tableView:minContainerOffset().y
        if curMinOffset < 0 then
            if math.abs(tbOffset.y) < gdisplay.width/2 then
                self.tableView:scrollToBottom()
            else
                tbOffset.y = tbOffset.y - (math.abs(curMinOffset) - minOffset)
                self.tableView:setContentOffset(tbOffset)
            end
        end
    end
    
    --- 新消息通知监听
    self:addEventListener(global.gameEvent.EV_ON_NEW_CHAT, function (event, msg)

        if not msg then return end
        local isPublicMsg = (msg.lType == 2) or (msg.lType == 3) or (msg.lType == 4)
        local isNewChat   = (msg.lFrom ~= global.userData:getUserId()) and (not chatData:isShieldUser(msg.lFrom))

        -- 服务自动发送
        local isMine = msg.lFrom == global.userData:getUserId()
        local specKey = {10, 12}
        local isSpecKey = function (key)
            for k,v in pairs(specKey) do
                if v == key then
                    return true
                end
            end
            return false
        end
        local isSpecMessage = msg.tagSpl and msg.tagSpl.lKey and isSpecKey(msg.tagSpl.lKey) -- 联盟礼包
        local isSpecMsg = isMine and isSpecMessage

        if (isPublicMsg and isNewChat) or isSpecMsg then

            local tbOffset = self.tableView:getContentOffset() 
            local minOffset = math.abs(self.tableView:minContainerOffset().y) 

            self.isScroToBottom = false
            local data = chatData:getChatByKey(self.tabControl:getSelectedIdx()) 
            if not data then return end
            self:setUIData(data.value)
           
            resetOffset(tbOffset, minOffset)  -- 重置  
        end
    end) 

end

function UIChatPanel:initEventListener()

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()  
        if self.setTabControl then
            global.chatFlushing = nil
            self:setTabControl()               
        end
    end) 

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()  
        if self.setTabControl then
            self:setTabControl()   
            global.chatData:refershChatRecruitMsg()
        end   
    end)

    global.chatData:pushUnionUnRead()
    self:addEventListener(global.gameEvent.EV_ON_UNION_CHATUNREAD, function ()
        if self.checkUnReadNum then
            self:checkUnReadNum()
        end
    end)
    
    self:addEventListener(global.gameEvent.EV_ON_CHAT_SHIELD, function ()  -- 屏蔽某人
        if self.refersh then
            self:refersh()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        if self.hideFlush then
            self:hideFlush()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_CHAT_TRANSLATE,function()
        local tbOffset = self.tableView:getContentOffset()
        self.tableView:setData(self.data)
        local curMinOffset = self.tableView:minContainerOffset().y
        if curMinOffset < 0 then
            self.tableView:setContentOffset(tbOffset)
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_CHATTOP_UNIONRECRUIT,function(event, isAction)
        if self.setUnionRecruit then
            self:setUnionRecruit(isAction)
        end
    end)

end

function UIChatPanel:setTabControl()
    
    if not chatData:isJoinUnion() then
        self.tabControl:setEnabledIndex(3)
        self.tabControl:setSelectedIdx(2)
        self:onTabButtonChanged(2)
    else
        self.tabControl:setSelectedIdx(chatData:getCurChatPage())
        self.tabControl:setEnabledIndex(nil)
        self:onTabButtonChanged(chatData:getCurChatPage())
    end

end

function UIChatPanel:inputEvent(eventType)

    if eventType == "began" then
        self.model:setVisible(true)
    end
    if eventType == "return" then
        self.model:setVisible(false)
    end
end

-- 2 国家、3 联盟、4系统
function UIChatPanel:onTabButtonChanged(index)

    -- 联盟招募消息置顶
    self:setUnionRecruit()

    self.isScroToBottom = true
    if index == 2 or index == 4 then
        
        self.tableView:setData({})
        chatData:setCurChatPage(index)
        self:getChatData() 

        self:checkUnReadNum()
        self:closeUnion()
    else
        if not chatData:isJoinUnion() then
            global.tipsMgr:showWarning("ChatUnionNo")
            return
        end

        self.tableView:setData({})
        chatData:setCurChatPage(index)
        self:getChatData()

        self.spReadState:setVisible(false)
        self:openUnion()
    end

    
end

-- 开启联盟
function UIChatPanel:openUnion()

    global.chatData:setUnionUnRead(0)
    global.chatApi:logicNotifyRead(function(msg)
    end, 2, 0)
end

-- 关闭联盟
function UIChatPanel:closeUnion()
    global.chatApi:logicNotifyRead(function(msg)
    end, 2, 1)
end

-- 联盟红点
function UIChatPanel:checkUnReadNum()

    self.spReadState:setVisible(false)
    if not chatData:isJoinUnion() or self.tabControl:getSelectedIdx() == 3 then 
        return
    end
    
    local num = global.chatData:getUnionUnRead()
    if num <= 0 then
        self.spReadState:setVisible(false)
    else
        self.spReadState:setVisible(true)
        self.unRead:setString(num)
    end
end

function UIChatPanel:setData(data)

    self.FuncPanel:setVisible(false)
    local tempData = chatData:getChatMsg(data)

    -- 获取缓存记录
    local chat = chatData:getChatByKey(self.tabControl:getSelectedIdx())
    if chat ~= nil then
        tempData = chatData:inertChat(chat.value, tempData)
    end
    
    self:setUIData(tempData)

end

function UIChatPanel:setUIData(data)

    self.model:setVisible(false)
    self.sharePanel:setVisible(false)
    self:hideFuncBorard()
    chatData:setCurLType(self.tabControl:getSelectedIdx())
    chatData:saveChat(self.tabControl:getSelectedIdx(), data or {}, self.curlPage)
    chatData:setCurChat(data)
    data = chatData:getChatByKey(self.tabControl:getSelectedIdx()).value

    self:tableSetData(data)

    if self.isScroToBottom or self.isInitEnter then
        self.tableView:scrollToBottom()
    end
end

--  更新时间贴条 并显示
function UIChatPanel:tableSetData(data)

    local temp = chatData:shieldChat(data)
    data = chatData:updateTime(temp)
    self.data = data
    self.tableView:stopScrolling()
    self.tableView:setData(data)
end

function UIChatPanel:refersh()
    self:tableSetData(self.data)
    self.tableView:scrollToBottom()
end

function UIChatPanel:refershData(curInfo)

    if self.data == nil then return end

    for _,v in pairs(self.data) do
        if curInfo.lUserID == v.lFrom then
            v.szFrom = curInfo.szName
            v.lFaceID = curInfo.lFace
            v.szAllyNick = curInfo.szAllyShortName
        end
    end
    local tbOffset = self.tableView:getContentOffset()
    self:tableSetData(self.data)
    chatData:saveChat(self.tabControl:getSelectedIdx(), clone(self.data), self.curlPage)
    self.tableView:setContentOffset(tbOffset)
end

-- 获取当前页聊天数据
function UIChatPanel:getChatData() 
    
    self.flushNode:setVisible(false)
    local chat = chatData:getChatByKey(self.tabControl:getSelectedIdx()) 

    local isHistory = (chat ~= nil and (#chat.value > 0) and (chat.lPage >= 1))
    local isFirst = chatData:getFirstPush(self.tabControl:getSelectedIdx())

    if not isFirst and isHistory then
        self.curlPage = chat.lPage
        self:setUIData(chat.value or {})
    else
        self.curlPage = 1 
        self:pullServerData()
    end
 
end

--- 下拉刷新
function UIChatPanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self.curlPage = 1

    local chat = chatData:getChatByKey(self.tabControl:getSelectedIdx()) 
    local isRecode = (chat ~= nil) and (#chat.value > 0) and (chat.lPage >= 1)
    if isRecode then
        self.curlPage = chat.lPage + 1
    end

    self:pullServerData()
end

function UIChatPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

--- 拉取服务器数据
function UIChatPanel:pullServerData()

    local resetOffset = function (msg)
    
        if tolua.isnull(self.tableView) then return end
        if self.curlPage == 1 then
            self.tableView:scrollToBottom()
        else
            if #msg.tagMsg > 0 and not self.isInitEnter then

                if self.tableView:minContainerOffset().y < 0 then
                    self.tableView:setContentOffset(self.lastFlushOffset)
                end
                self.isInitEnter = false
            end
        end
    end

    -- 避免网络差的情况多次发送数据叠加的问题      
    if global.chatFlushing then return end
    global.chatFlushing = true
    
    local curType = self.tabControl:getSelectedIdx()
    global.chatApi:getMsgInfo(function(msg)

        if tolua.isnull(self) then return end 

        global.chatFlushing = nil

        if curType ~= self.tabControl:getSelectedIdx() then
            self:pullServerData()
            return 
        end

        if self.hideFlush then
            self:hideFlush()
        end

        msg.tagMsg = msg.tagMsg or {}
        local isPushOver = (#msg.tagMsg == 0) and (self.curlPage > 1)
        if isPushOver then
            chatData:setIsPushAll(curType)
            return
        end
        if self.curlPage == 1 then
            chatData:setFirstPush(curType)
            chatData:removeChatByKey(curType)
        end

        self.isScroToBottom = false
        if self.setData then
            self:setData(msg.tagMsg)
        end
        resetOffset(msg)

    end, curType, self.curlPage)

  
end

--- 发送消息
function UIChatPanel:sender(sender, eventType)

    local curType = self.tabControl:getSelectedIdx()
    if curType == 4 then -- 系统频道发送屏蔽
        global.tipsMgr:showWarning("cant_talk")
        return
    end

    local szContent = self.tf_Input:getString() or ""
    if szContent == "" or szContent == " " then
        global.tipsMgr:showWarning("chatEmpty")
        return
    end
    
    if not global.chatData:checkLength(szContent) then 
        return
    end
     
    local lFromId = global.userData:getUserId()
    global.chatApi:senderMsg(function(msg)

        self.tf_Input:setString("")
        self.isScroToBottom = true

        chatData:addChat(curType, msg.tagMsg or {})
        self:getChatData()

    end, curType, szContent, lFromId)

end

--- 显示复制私聊功能面板 
function UIChatPanel:showFuncBorard(data, pos, rowPosX)

    if not self.FuncNode then
        self.FuncNode = UIChatFuncBoard.new()
        self.FuncPanel:addChild(self.FuncNode)
    end
    self.FuncPanel:setVisible(true)
    self.FuncNode:setData(data)
    self.FuncNode:setPosition(pos)

    local posR = self.FuncNode:convertToNodeSpace(cc.p(rowPosX, 0))
    if not tolua.isnull(self.FuncNode.row) then
        self.FuncNode.row:setPositionX(posR.x)
        self.FuncNode.row:setFlippedY(false) 
        self.FuncNode.row:setPositionY(10)
    end
end

function UIChatPanel:hideFuncBorard(sender, eventType)
    self.FuncPanel:setVisible(false)
end


-- 转发分享战报
function UIChatPanel:showSharePanel()

    if self.sharePanel:isVisible() then return end

    self.sharePanel:setVisible(true)
    local nodeTimeLine = resMgr:createTimeline("chat/chat_bj")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        self.sharePanel:setVisible(true)
    end)
    self:runAction(nodeTimeLine)

end

function UIChatPanel:hideSharePanel()
    
    if not self.sharePanel:isVisible() then return end

    local nodeTimeLine = resMgr:createTimeline("chat/chat_bj")
    nodeTimeLine:play("animation1", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        self.sharePanel:setVisible(false)
    end)
    self:runAction(nodeTimeLine)
end

function UIChatPanel:onExit()

    global.chatFlushing = nil
    self:hideFuncBorard()
   
    --退出保留目前的聊天类型
    cc.UserDefault:getInstance():setStringForKey("ChatSelect", chatData:getCurChatPage())
    cc.UserDefault:getInstance():flush()

    self.tabControl:setEnabledIndex(nil)
    self.data = {}

    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end

    global.isTranslating = nil
end

function UIChatPanel:exit_call(sender, eventType)
    self.closeUnion()
    self:hideFuncBorard()
    global.panelMgr:closePanelForBtn("UIChatPanel")  
end

function UIChatPanel:modelClickHandler(sender, eventType)
    self.model:setVisible(false)
end

function UIChatPanel:senderBgHandler(sender, eventType)
    self.tf_Input:touchDownAction()
end
--CALLBACKS_FUNCS_END

return UIChatPanel

--endregion
