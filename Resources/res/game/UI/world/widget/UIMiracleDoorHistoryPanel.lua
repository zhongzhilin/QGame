--region UIMiracleDoorHistoryPanel.lua
--Author : Untory
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local UITableView = require("game.UI.common.UITableView")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIMiracleDoorHistoryPanel  = class("UIMiracleDoorHistoryPanel", function() return gdisplay.newWidget() end )
local UIMiracleDoorHistoryItemCell = require("game.UI.world.widget.UIMiracleDoorHistoryItemCell")

function UIMiracleDoorHistoryPanel:ctor()
    self:CreateUI()
end

function UIMiracleDoorHistoryPanel:CreateUI()
    local root = resMgr:createWidget("wild/temple_history_leader_bg")
    self:initUI(root)
end

function UIMiracleDoorHistoryPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_history_leader_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.close_node = self.root.Node_2.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_2.close_node_export)
    self.no = self.root.Node_2.no_mlan_16_export
    self.tb_node = self.root.Node_2.tb_node_export
    self.tbsize = self.root.Node_2.tbsize_export
    self.itsize = self.root.Node_2.itsize_export
    self.flushNode = self.root.Node_2.flushNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIMiracleDoorHistoryItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tb_node:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

    local loading_TimeLine = resMgr:createTimeline("world/map_Load")  
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)

end

function UIMiracleDoorHistoryPanel:tableMove()

    local curOffsetY = self.tableView:getContentOffset().y
    local minOffsetY = self.tableView:minContainerOffset().y
    local maxOffsetY = self.tableView:maxContainerOffset().y
    local tbSize = self.tbsize:getContentSize().height

    local isFlush = false
    if minOffsetY > 0 and curOffsetY > (minOffsetY+tbSize/8) then
        isFlush = true 
    elseif minOffsetY <= 0 and curOffsetY > (maxOffsetY+tbSize/8) then
        isFlush = true
    end

    if isFlush and (not self.isPushOver) and (not self.isVisFlush) then
        self:showFlush()
    else
        if self.isVisFlush and (curOffsetY < ( maxOffsetY +64 ) ) then
            self:hideFlush()
        end
    end
end

function UIMiracleDoorHistoryPanel:onEnter()
    self.m_eventListenerCustomList = {}
    self.isVisFlush = false             -- 刷新状态
    self:initEventListener()    
    self.flushNode:setVisible(false)
    self.isPushOver = false
    self.tableView:setData({})
    self.no:setVisible(false)
end

function UIMiracleDoorHistoryPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIMiracleDoorHistoryPanel:initEventListener()

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.refresh then
            self:refresh()
        end
    end)
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.refresh then
            self:refresh()
        end
    end)
end

function UIMiracleDoorHistoryPanel:setData(cityId)
    self.cityId = cityId
    self:refresh()
end

function UIMiracleDoorHistoryPanel:refresh()

    self.lastData = {}
    self.curlPage = 1
    self:pullServerData()
end

function UIMiracleDoorHistoryPanel:pullServerData()
    
    global.worldApi:queryMiracleOwner(function(msg)

        if self.hideFlush then 
            self:hideFlush()
        end 
        msg.tgOwns = msg.tgOwns or {}
        if self.curlPage == 1 and #msg.tgOwns == 0 then
            self.no:setVisible(true)
            self.isPushOver = true
            return
        end

        if #msg.tgOwns == 0 and self.curlPage > 1 then
            self.isPushOver = true
            return
        end

        -- 当前offset
        self:setCurTableOffset()
        self:connectData(msg.tgOwns)
        table.sortBySortList(self.lastData, {{"lOwnSort","max"}})
        self.tableView:setData(self.lastData)
        self:adjustTableOffset()
        self.curlPage = self.curlPage + 1

        -- 下载用户头像
        if msg.tgOwns then
            local data = {}
            for i,v in pairs(msg.tgOwns) do
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

    end, self.cityId, self.curlPage) 

end

function UIMiracleDoorHistoryPanel:setCurTableOffset()
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()
end

function UIMiracleDoorHistoryPanel:adjustTableOffset()
    if self.curlPage == 1 then return end
    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then
        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end

end

function UIMiracleDoorHistoryPanel:connectData(cur)
    if #cur == 0 then return end
    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end

--- 下拉刷新
function UIMiracleDoorHistoryPanel:showFlush()
    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData()
end

function UIMiracleDoorHistoryPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMiracleDoorHistoryPanel:exitCall(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UIMiracleDoorHistoryPanel")
end
--CALLBACKS_FUNCS_END

return UIMiracleDoorHistoryPanel

--endregion
