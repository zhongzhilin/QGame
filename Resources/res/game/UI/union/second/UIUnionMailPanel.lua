--region UIUnionMailPanel.lua
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

local UIUnionMailPanel  = class("UIUnionMailPanel", function() return gdisplay.newWidget() end )

function UIUnionMailPanel:ctor()
    self:CreateUI()
end

function UIUnionMailPanel:CreateUI()
    local root = resMgr:createWidget("union/union_mail")
    self:initUI(root)
end

function UIUnionMailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_mail")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.tableNode = self.root.tableNode_export
    self.titleNode = self.root.titleNode_export
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


function UIUnionMailPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 


function UIUnionMailPanel:tableMove()

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

function UIUnionMailPanel:onExit()
    self.data = {}
end

function UIUnionMailPanel:onEnter()

    -- 用于记录读取状态
    global.chatApi:logicNotifyRead(function(msg)
    end, global.userData:getUserId(), 0)

    self.isVisFlush = false             -- 刷新状态
    self.isStartMove = false            -- 滑动状态
    self.isScroToBottom = true          -- 是否需要滑动至最底部
    self.lastFlushOffset = cc.p(0, 0)   -- 下拉刷新前的位移

    self:hideFuncBorard()
    self:initEventListener()    
    self.tableView:setData({})
    self.flushNode:setVisible(false)
    self.isInitEnter = true

    self:reFresh()
    
end

function UIUnionMailPanel:reFresh()

    self.lastData = {}
    self.curlPage = 1
    self:pullServerData()
end

-- 拉取服务器数据
function UIUnionMailPanel:pullServerData()
    
    global.chatApi:getMsgInfo(function(msg)
        if self.hideFlush then 
            self:hideFlush()
        end 
        msg.tagMsg = msg.tagMsg or {}
        if #msg.tagMsg == 0 and self.curlPage > 1 then
            return
        end

        self.isScroToBottom = false
        if self.connectData then
            self:connectData(msg.tagMsg)
        end
        self:setData(self.lastData)
        self.curlPage = self.curlPage + 1

        if chatData:getIsResume() then
            self.tableView:scrollToBottom()
        else
            if #msg.tagMsg > 0 and not self.isInitEnter then
                if self.tableView:minContainerOffset().y < 0 then
                    self.tableView:setContentOffset(self.lastFlushOffset)
                end
                self.isInitEnter = false
            end
        end

    end, 1, self.curlPage, global.userData:getUserId())

end

function UIUnionMailPanel:connectData(cur)
    if #cur == 0 then return end
    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end

function UIUnionMailPanel:initEventListener()

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

function UIUnionMailPanel:inputEvent(eventType)
    if eventType == "began" then
        self.model:setVisible(true)
    end
    if eventType == "return" then
        self.model:setVisible(false)
    end
end

function UIUnionMailPanel:setData(data)
    local tempData = global.chatData:getChatMsg(data)
    self:setUIData(tempData)  
end

function UIUnionMailPanel:setUIData(data)

    self.model:setVisible(false)
    self:hideFuncBorard()

    self.data = data
    -- 刷新时间贴条
    data = global.chatData:updateTime(data)
    self.tableView:setData(data)
    if self.isScroToBottom or self.isInitEnter then
        self.tableView:scrollToBottom()
    end

end

--- 下拉刷新
function UIUnionMailPanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData()
end

function UIUnionMailPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

--- 发送消息
function UIUnionMailPanel:sender(sender, eventType)

    if not global.unionData:isHadPower(25) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    
    local szContent = self.tf_Input:getString()
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
        msg.tagMsg = msg.tagMsg or {}
        if table.nums(msg.tagMsg) > 0 then
            table.insert(self.lastData, msg.tagMsg)
            self:setData(self.lastData)
        end
    
    end, 4, szContent, lFromId, lFromId)
end


function UIUnionMailPanel:exit_call(sender, eventType)
    self:hideFuncBorard()
    global.panelMgr:closePanelForBtn("UIUnionMailPanel")

    global.chatApi:logicNotifyRead(function(msg)
        -- 刷新列表最新消息
        local  panel = global.panelMgr:getPanel("UIMailListPanel")
        panel:initData()
    end, global.userData:getUserId(), 1)

end

--- 显示复制私聊功能面板
function UIUnionMailPanel:showFuncBorard(data, pos, rowPosX)
    self.FuncPanel:setVisible(true)
    self.FuncNode:setData(data)
    self.FuncNode:setPosition(pos)

    local posR = self.FuncNode:convertToNodeSpace(cc.p(rowPosX, 0))
    self.FuncNode.row:setPositionX(posR.x)
end

function UIUnionMailPanel:hideFuncBorard(sender, eventType)
    self.FuncPanel:setVisible(false)
end

function UIUnionMailPanel:modelClickHandler(sender, eventType)
    self.model:setVisible(false)
end
--CALLBACKS_FUNCS_END

return UIUnionMailPanel

--endregion
