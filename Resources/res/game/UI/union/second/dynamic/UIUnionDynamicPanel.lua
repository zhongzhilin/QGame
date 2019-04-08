--region UIUnionDynamicPanel.lua
--Author : yyt
--Date   : 2017/02/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionDynamicPanel  = class("UIUnionDynamicPanel", function() return gdisplay.newWidget() end )

function UIUnionDynamicPanel:ctor()
    self:CreateUI()
end

function UIUnionDynamicPanel:CreateUI()
    local root = resMgr:createWidget("union/union_trigger_bj")
    self:initUI(root)
end

function UIUnionDynamicPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_trigger_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.tableNode = self.root.tableNode_export
    self.titleNode = self.root.titleNode_export
    self.topNode = self.root.topNode_export
    self.bottomNode = self.root.bottomNode_export
    self.tableSize = self.root.tableSize_export
    self.cellSize = self.root.cellSize_export
    self.flushNode = self.root.flushNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local UITableView = require("game.UI.common.UITableView")
    local UIUnionDynamicItemCell = require("game.UI.union.second.dynamic.UIUnionDynamicItemCell")
    self.tableView = UITableView.new()
        :setSize(self.tableSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIUnionDynamicItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tableNode:addChild(self.tableView)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

    -- 加载
    local loading_TimeLine = resMgr:createTimeline("world/map_Load")
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionDynamicPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 


function UIUnionDynamicPanel:tableMove()

    local curOffsetY = self.tableView:getContentOffset().y
    local minOffsetY = self.tableView:minContainerOffset().y
    local maxOffsetY = self.tableView:maxContainerOffset().y
    local tbSize = self.tableSize:getContentSize().height

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

function UIUnionDynamicPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        self:hideFlush()
    end)
end

function UIUnionDynamicPanel:onExit()
    self.tableView:setData({})
end

function UIUnionDynamicPanel:setData()

    self.isPushOver = false
    self.curlPage = 1
    self.lastData = {}

    self:showFlush()
end

--- 上拉刷新
function UIUnionDynamicPanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)

    self:pullServerData()
end

function UIUnionDynamicPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

-- 分页拉取联盟动态
function UIUnionDynamicPanel:pullServerData()

    global.unionApi:getDynamic(function (msg)

        if not self.curlPage then return end
        self:hideFlush()
        msg = msg or {}
        
        if msg.tgAct and #msg.tgAct > 0 then

            -- 当前offset
            self:setCurTableOffset()

            self:connectData(msg.tgAct)
            self.tableView:setData(self.lastData)
            
            -- 调整offset
            self:adjustTableOffset()

            self.curlPage = self.curlPage + 1
        else
            self.isPushOver = true
        end

    end, global.userData:getlAllyID(), self.curlPage)

end

function UIUnionDynamicPanel:setCurTableOffset()
    
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()

end

function UIUnionDynamicPanel:adjustTableOffset()
    if self.curlPage == 1 then return end

    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then

        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end
    
end

function UIUnionDynamicPanel:connectData(cur)
    if #cur == 0 then return end

    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end

function UIUnionDynamicPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUnionDynamicPanel")
end

--CALLBACKS_FUNCS_END

return UIUnionDynamicPanel

--endregion
