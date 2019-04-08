--region UIRankPanel.lua
--Author : yyt
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRankPanel  = class("UIRankPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
local UIRankTypeCell = require("game.UI.rank.UIRankTypeCell")

function UIRankPanel:ctor()
    self:CreateUI()
end

function UIRankPanel:CreateUI()
    local root = resMgr:createWidget("rank/rank_1st_bg")
    self:initUI(root)
end

function UIRankPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rank/rank_1st_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.topNode = self.root.topNode_export
    self.table_node = self.root.table_node_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.bottomNode = self.root.bottomNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UIMultiTableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIRankTypeCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGINs

function UIRankPanel:onEnter()
    self.m_eventListenerCustomList = {}
    self:setData()
end

function UIRankPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIRankPanel:setData()

    -- 拉取各个排行榜第一信息
    global.unionApi:getTopRankList(function(msg)

        -- dump(msg, ">>>>>>>>>>> getTopRankList")
        if msg.tgTopInfos then
            if self.getTopRank then --保护处理
                self.tableView:setData(self:getTopRank(msg.tgTopInfos) or {} )
            end 

            -- 下载用户头像
            local data = {}
            for i,v in pairs(msg.tgTopInfos) do
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

    end)
end

function UIRankPanel:getTopRank(msg)

    local data = global.luaCfg:rank()
    for _,value in pairs(data) do
        for _,v in pairs(msg) do
            if v.lID == value.id then
                value.serverData = v
            end
        end
        -- 间隔
        value.uiData = {}
        if value.id == 4 then
            value.uiData.h = self.cellSize:getContentSize().height + 15
        else
            value.uiData.h = self.cellSize:getContentSize().height 
        end
    end
    return data
end

function UIRankPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIRankPanel")  
end

--CALLBACKS_FUNCS_END

return UIRankPanel

--endregion
