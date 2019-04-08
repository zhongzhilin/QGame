--region UIDiplomaticPanel.lua
--Author : yyt
--Date   : 2017/07/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDiplomaticPanel  = class("UIDiplomaticPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIDiplomaticCell = require("game.UI.diplomatic.UIDiplomaticCell")

function UIDiplomaticPanel:ctor()
    self:CreateUI()
end

function UIDiplomaticPanel:CreateUI()
    local root = resMgr:createWidget("diplomatic/diplomatic_bg")
    self:initUI(root)
end

function UIDiplomaticPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diplomatic/diplomatic_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.no = self.root.no_mlan_45_export
    self.bottomNode = self.root.bottomNode_export
    self.topNode = self.root.topNode_export
    self.node_tableView = self.root.node_tableView_export
    self.spReadState = self.root.bj.establishBtn.spReadState_export
    self.unReadNum = self.root.bj.establishBtn.spReadState_export.unReadNum_export
    self.title = self.root.title_export
    self.itemLayout = self.root.itemLayout_export
    self.tbSize = self.root.tbSize_export
    self.flushNode = self.root.flushNode_export

    uiMgr:addWidgetTouchHandler(self.root.bj.establishBtn, function(sender, eventType) self:approveHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bj.newDiplomaticBtn, function(sender, eventType) self:newDiplomaticHandler(sender, eventType) end)
--EXPORT_NODE_END
     uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIDiplomaticCell)
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

function UIDiplomaticPanel:tableMove()

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

function UIDiplomaticPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        self:hideFlush()
    end)

    local checkDiplomatic = function ()
        -- body
        self.spReadState:setVisible(false)
        local appCount = global.unionData:getApproveCount()
        if appCount > 0 then
            self.spReadState:setVisible(true)
            self.unReadNum:setString(appCount)
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE, function()   
        checkDiplomatic()
        self:initData()
    end)
    checkDiplomatic()
    self:initData()

end

function UIDiplomaticPanel:initData()
    self.isPushOver = false
    self.curlPage = 1
    self.lastData = {}
    self:showFlush()
end

--- 上拉刷新
function UIDiplomaticPanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)
    self:pullServerData()
end

function UIDiplomaticPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

-- 分页拉取联盟动态
function UIDiplomaticPanel:pullServerData()

    local isFirstPage = self.curlPage == 1 

    -- 获取敌对列表
    global.unionApi:getUserRelationShip(function (msg)
        
        self:hideFlush()
        msg = msg or {}
        
        -- 当前offset
        self:setCurTableOffset()

        if msg.tagUserRelationship and #msg.tagUserRelationship > 0 then
            
            if isFirstPage then
                self.lastData = {}
                self.curlPage = 1 
            end

            self:connectData(msg.tagUserRelationship)
            self:setData(self.lastData)
            self:adjustTableOffset() -- 调整offset
            self.curlPage = self.curlPage + 1
        else           
            self:setData(self.lastData)
            self:adjustTableOffset()
            self.isPushOver = true
        end

    end, 1, self.curlPage)

end

function UIDiplomaticPanel:setCurTableOffset()
    
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()

end

function UIDiplomaticPanel:adjustTableOffset()
    if self.curlPage == 1 then return end

    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then

        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end
    
end

function UIDiplomaticPanel:connectData(cur)
    if #cur == 0 then return end
    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end

function UIDiplomaticPanel:setData(data)

    if table.nums(data) > 0 then
        self.no:setVisible(false)
    else
        self.no:setVisible(true)
    end
    self.tableView:setData(data)
end

function UIDiplomaticPanel:approveHandler(sender, eventType)
    global.panelMgr:openPanel("UIApprovePanel")
end

function UIDiplomaticPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDiplomaticPanel")
end

function UIDiplomaticPanel:newDiplomaticHandler(sender, eventType)
    global.panelMgr:openPanel("UIUnionAskPanel"):setData(nil, nil, 2)
end
--CALLBACKS_FUNCS_END

return UIDiplomaticPanel

--endregion
