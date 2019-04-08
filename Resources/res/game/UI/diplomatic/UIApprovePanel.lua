--region UIApprovePanel.lua
--Author : yyt
--Date   : 2017/07/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIApprovePanel  = class("UIApprovePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIApproveCell = require("game.UI.diplomatic.UIApproveCell")

function UIApprovePanel:ctor()
    self:CreateUI()
end

function UIApprovePanel:CreateUI()
    local root = resMgr:createWidget("diplomatic/apply_panel")
    self:initUI(root)
end

function UIApprovePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diplomatic/apply_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top_bj = self.root.top_bj_export
    self.apply_num = self.root.top_bj_export.apply_num_export
    self.no = self.root.no_mlan_45_export
    self.node_tableView = self.root.node_tableView_export
    self.itemLayout = self.root.itemLayout_export
    self.topNode = self.root.topNode_export
    self.bottomNode = self.root.bottomNode_export
    self.title = self.root.title_export
    self.tbSize = self.root.tbSize_export
    self.flushNode = self.root.flushNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIApproveCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

    local loading_TimeLine = resMgr:createTimeline("world/map_Load")  
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIApprovePanel:tableMove()

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
        -- 刷新
        self:showFlush()

    else
        if self.isVisFlush and (curOffsetY < ( maxOffsetY +64 ) ) then
            self:hideFlush()
        end
    end
end

function UIApprovePanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        self:hideFlush()
    end)

    self:addEventListener(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE, function()       
        self:initData()
    end)
    self:initData()

    self.apply_num:setVisible(false)

end


function UIApprovePanel:initData()
    self.isPushOver = false
    self.curlPage = 1
    self.lastData = {}
    self:showFlush()
end

--- 上拉刷新
function UIApprovePanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData()
end

function UIApprovePanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

-- 分页拉取联盟动态
function UIApprovePanel:pullServerData()

    local isFirstPage = self.curlPage == 1 

    -- 获取审批列表
    global.unionApi:getUserRelationShip(function (msg)
        
        self:hideFlush()
        msg = msg or {}
        
        -- 当前offset
        self:setCurTableOffset()

        if msg.tagApplyList and #msg.tagApplyList > 0 then

            if isFirstPage then
                self.lastData = {}
                self.curlPage = 1 
            end
            self:connectData(msg.tagApplyList)
            self:setData(self.lastData)
            self:adjustTableOffset() -- 调整offset
            self.curlPage = self.curlPage + 1
        else            
            self:setData(self.lastData)
            self:adjustTableOffset() -- 调整offset
            self.isPushOver = true
        end

    end, 2, self.curlPage)
end

function UIApprovePanel:setCurTableOffset()
    
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()

end

function UIApprovePanel:adjustTableOffset()
    if self.curlPage == 1 then return end

    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then

        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end
    
end

function UIApprovePanel:connectData(cur)
    if #cur == 0 then return end
    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end

function UIApprovePanel:setData(data)

    if table.nums(data) > 0 then
        self.no:setVisible(false)
    else
        self.no:setVisible(true)
    end

    self.apply_num:setVisible( table.nums(data) > 0)

    self.apply_num:setString(global.luaCfg:get_local_string(10725, table.nums(data)))

    table.sort(data, function(s1, s2) return s1.lType > s2.lType end)
    self.tableView:setData(data)
end

function UIApprovePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIApprovePanel")
end

--CALLBACKS_FUNCS_END

return UIApprovePanel

--endregion
