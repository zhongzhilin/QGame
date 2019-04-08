--region UIUMsgPanel.lua
--Author : wuwx
--Date   : 2017/02/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local chatData = global.chatData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIChatFuncBoard = require("game.UI.chat.UIChatFuncBoard")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIChatItemCell = require("game.UI.chat.UIChatItemCell")
local UIUMsgPanel  = class("UIUMsgPanel", function() return gdisplay.newWidget() end )

function UIUMsgPanel:ctor()
    self:CreateUI()
end

function UIUMsgPanel:CreateUI()
    local root = resMgr:createWidget("union/union_chat")
    self:initUI(root)
end

function UIUMsgPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_chat")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.tableNode = self.root.tableNode_export
    self.titleNode = self.root.titleNode_export
    self.toName = self.root.titleNode_export.toName_mlan_7_export
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
    self.flushNode = self.root.flushNode_export

    uiMgr:addWidgetTouchHandler(self.root.input.senderBtn, function(sender, eventType) self:onSend(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.FuncPanel, function(sender, eventType) self:hideFuncBorard(sender, eventType) end)
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

    self.tableView:setDidScrollCall(function(tableView, idx)
        self:hideFuncBorard()
    end)

    self.FuncPanel:setSwallowTouches(false)
    self.nodeMaxPosY = gdisplay.height - self.topSize:getContentSize().height  -- self.FuncNode 最大位置

    local loading_TimeLine = resMgr:createTimeline("world/map_Load")  
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)

    self:adapt()

end


function UIUMsgPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 

function UIUMsgPanel:tableMove()

    self.FuncPanel:setVisible(false)

    local tbSize = self.TableSize:getContentSize().height
    local curOffsetY = math.abs(self.tableView:getContentOffset().y)
    local maxOffsetY = math.abs(self.tableView:minContainerOffset().y)

    if curOffsetY > (maxOffsetY + tbSize/5) then
        if (not self.isVisFlush) and (not self.isPushOver) then
            self.lastFlushOffset = self.tableView:getContentOffset()
            self:showFlush()
        end
    else
        if self.isVisFlush and (curOffsetY < (maxOffsetY + 64)) then
            self:hideFlush()
        end
    end
end

function UIUMsgPanel:onExit()
    self.data = {}
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIUMsgPanel:onEnter()

    self.isVisFlush = false             -- 刷新状态
    self.lastFlushOffset = cc.p(0, 0)   -- 下拉刷新前的位移
    self:initEventListener()    
    self.flushNode:setVisible(false)
    self.isPushOver = false

    self.tableView:setData({})
    self:hideFuncBorard()

    self:addEventListener(global.gameEvent.EV_ON_CHAT_TRANSLATE,function()
        local tbOffset = self.tableView:getContentOffset()
        self.tableView:setData(self.data)
        local curMinOffset = self.tableView:minContainerOffset().y
        if curMinOffset < 0 then
            self.tableView:setContentOffset(tbOffset)
        end
    end)

    self.m_eventListenerCustomList = {}
end

function UIUMsgPanel:initEventListener()

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.reFresh then
            self:reFresh()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.reFresh then
            self:reFresh()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        if self.hideFlush then
            self:hideFlush()
        end
    end)
end

function UIUMsgPanel:setData(lAllyID)
    self.lAllyID = lAllyID
    self:refresh()
end

function UIUMsgPanel:refresh()

    self.lastData = {}
    self.curlPage = 1
    self:pullServerData()
end

-- 拉取服务器数据
-- message AllyMsg
-- {
--     required int32      lAllyID     = 1;//联盟ID
--     required int32      lUserID     = 2;
--     required uint32     lTime       = 3;
--     required string     szContent   = 4;
--     required string     szUserName  = 5;
-- }

-- message CTMsg
-- {
--     required uint32     lType       = 1;//1，私聊 2，世界，3，联盟，4，聊天组
--     required string     szContent   = 2;//内容
--     required int32      lFrom       = 3;//发送方id
--     optional int32      lTo         = 4;//接收方id
--     optional string     szTo        = 5;//接收方名字
--     optional int32      lTime       = 6;//发送时间
--     optional int32      lAllyID     = 7;//发送方联盟id
--     optional string     szFrom      = 8;//发送方名字
--     optional string     szAlly      = 9;//发送方联盟名
--     optional string     szAllyNick  = 10;//发送方联盟简称
--     optional CTSpecial  tagSpl      = 11;//
--     optional int32      lFaceID     = 12;
-- }
function UIUMsgPanel:pullServerData()

    local resetOffset = function (msg)
        if self.curlPage == 1 then
            self.tableView:scrollToBottom()
        else
            if self.tableView:minContainerOffset().y < 0 then
                self.tableView:setContentOffset(self.lastFlushOffset)
            else
                self.tableView:scrollToBottom()
            end
        end
    end

    global.unionApi:getAllyMsgList(function(msg)

        if  tolua.isnull(self) then return end 

        if self.hideFlush then 
            self:hideFlush()
        end
        msg.tgMsg = msg.tgMsg or {}
        if #msg.tgMsg == 0 and self.curlPage > 1 then
            self.isPushOver = true
            return
        end
        if self.connectData then 
            self:connectData(msg.tgMsg)
        end
        local data = {}
        if self.convertChatData then
            data = self:convertChatData(self.lastData)
        end
        if self.hideFuncBorard then 
            self:hideFuncBorard()
        end 
        self.data = data
        self.tableView:setData(data)
        resetOffset(msg)
        
        -- 下载用户头像
        if msg.tgMsg then
            local data = {}
            for i,v in pairs(msg.tgMsg) do                
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

        self.curlPage = self.curlPage + 1

    end,self.lAllyID, self.curlPage)
end

function UIUMsgPanel:connectData(cur)
    if #cur == 0 then return end
    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end

--- 下拉刷新
function UIUMsgPanel:showFlush()
    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData()
end

function UIUMsgPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

function UIUMsgPanel:convertChatData(tgMsg)
    local data = {}
    local mineId = global.userData:getUserId()
    for _,v in ipairs(tgMsg) do
        local temp = v
        temp.lFrom = v.lUserID
        temp.itemType = 1 
        temp.szFrom = v.szUserName
        temp.sendState = 0
        temp.itemKind = 1

        temp.cellH = 0 
        temp.textSize = {0, 0}
        temp.timeStr = ""
        -- 翻译状态
        temp.tranStr   = temp.tranStr or ""  
        temp.tranState = temp.tranState or 0
        global.chatData:checkCellUI(temp)
        table.insert(data,temp)
    end
    data = global.chatData:updateTime(data)
    return data
end

function UIUMsgPanel:exit_call(sender, eventType)
    self:hideFuncBorard()

    global.panelMgr:closePanelForBtn("UIUMsgPanel")
end

--- 显示复制私聊功能面板
function UIUMsgPanel:showFuncBorard(data, pos)
    self.FuncPanel:setVisible(true)
    self.FuncNode:setData(data)
    self.FuncNode:setPosition(pos)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--- 发送消息
function UIUMsgPanel:onSend(sender, eventType)
    
    local szContent = self.tf_Input:getString()

    if szContent == "" or szContent == " " then
        global.tipsMgr:showWarning("chatEmpty")
        return
    end

    global.unionApi:sendAllyLeaveMsg(function(msg)
        self.tf_Input:setString("")
        self:refresh()
    end,self.lAllyID,szContent)
end

function UIUMsgPanel:hideFuncBorard(sender, eventType)
    self.FuncPanel:setVisible(false)
end
--CALLBACKS_FUNCS_END

return UIUMsgPanel

--endregion
