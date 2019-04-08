--region UIUnionAskPanel.lua
--Author : wuwx
--Date   : 2017/01/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUnionAskPanel  = class("UIUnionAskPanel", function() return gdisplay.newWidget() end )

function UIUnionAskPanel:ctor()
    self:CreateUI()
end

function UIUnionAskPanel:CreateUI()
    local root = resMgr:createWidget("union/union_please_bj")
    self:initUI(root)
end

function UIUnionAskPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_please_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node_tableView = self.root.node_tableView_export
    self.title = self.root.title_export
    self.ml_title = self.root.title_export.ml_title_fnt_mlan_6_export
    self.search_name = self.root.top_bj.search_name.search_name_mlan_10_export
    self.search_name = UIInputBox.new()
    uiMgr:configNestClass(self.search_name, self.root.top_bj.search_name.search_name_mlan_10_export)
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export

    uiMgr:addWidgetTouchHandler(self.root.top_bj.search, function(sender, eventType) self:searchHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.change, function(sender, eventType) self:refreshHandler(sender, eventType) end)
--EXPORT_NODE_END

    local UILoadTableView = require("game.UI.union.widget.UILoadTableView")
    local UIUnionAskCell = require("game.UI.union.list.UIUnionAskCell")
    self.tableView = UILoadTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionAskCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.search_name:addEventListener( function()
        -- body
        self.m_currKey = self.search_name:getString()
    end )
end

function UIUnionAskPanel:onEnter()
    self.tableView:setData({})
    self.m_currPage = 1
    self.m_currKey = nil
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self:addEventListener(global.gameEvent.EV_ON_UNION_SELECTUSER, function (event, msg)
        self:exit_call()
        global.panelMgr:closePanel("UIUnionAskPanel")
    end)
end

function UIUnionAskPanel:exit_call(sender, eventType)
    if global.panelMgr:isPanelOpened("UIUnionAskSearchPanel") then
        global.panelMgr:closePanelForBtn("UIUnionAskSearchPanel")
    else
        global.panelMgr:closePanelForBtn("UIUnionAskPanel")
    end
end

function UIUnionAskPanel:getOthParam() 
    return self.othParam
end

-- 0联盟成员 1 聊天列表 2 个人外交 3 官职设置
function UIUnionAskPanel:setData(searchKey,call, param)

    param = param or 0
    if param == 1 then
        self.ml_title:setString(global.luaCfg:get_local_string(10326))
    elseif param == 2 then
        self.ml_title:setString(global.luaCfg:get_local_string(10787))
    elseif param == 3 then
        self.ml_title:setString(global.luaCfg:get_local_string(10902))
    else
        self.ml_title:setString(global.luaCfg:get_local_string(10325))
    end
    self.othParam = param

    if searchKey then
        --展示搜索结果
        self.search_name:setString(searchKey)

        self.m_currKey = self.search_name:getString()
        global.unionApi:getRandUser(function(data)
                -- 成功返回
                table.sort( data.tgUser, function(a,b)
                    -- body
                    if a.lOnline == b.lOnline then
                        return a.lLastTime > b.lLastTime
                    else
                        return a.lOnline > b.lOnline
                    end
                end )
                self.tableView:setData(data.tgUser)
                if call then call() end

                if data and data.lPage then
                    self.m_currPage = data.lPage + 1
                end
            end,1,self.m_currKey,
            function(ret)
                -- 没有搜索结果
                self.tableView:setData({})
            end)
    else
        self.search_name:setString("")
        global.unionApi:getRandUser(function(data)
            table.sort( data.tgUser, function(a,b)
                -- body
                if a.lOnline == b.lOnline then
                    return a.lLastTime > b.lLastTime
                else
                    return a.lOnline > b.lOnline
                end
            end )
            if not tolua.isnull(self.tableView) then 
                self.tableView:setData(data.tgUser)
            end
            if call then call() end

            if data and data.lPage then
                self.m_currPage = data.lPage + 1
            end
        end,self.m_currPage,self.m_currKey)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionAskPanel:searchHandler(sender, eventType)
    if self.search_name:getString() == "" then
        global.tipsMgr:showWarning("UnionKey")
        return
    end
    if global.panelMgr:isPanelOpened("UIUnionAskSearchPanel") then
        global.panelMgr:getPanel("UIUnionAskSearchPanel"):setData(self.search_name:getString())
    else
        global.panelMgr:openPanel("UIUnionAskSearchPanel"):setData(self.search_name:getString())
        self.search_name:setString("")
        self.m_currKey = nil
    end
end

function UIUnionAskPanel:refreshHandler(sender, eventType)
    
    self.m_currPage = 1
    self:setData(self.m_currKey,function()
        -- body
        global.uiMgr:addSceneModel(1)
        local allCell = self.tableView:getCells()
        table.sort( allCell, function(a,b)
            -- bod
            return a:getPositionY()>b:getPositionY()
        end )
        local speed = 5000
        for i = 1, #allCell do
            local target = allCell[i]
            if target:getIdx() >= 0 then

                local overCall = function ()
                    gsound.stopEffect("city_click")
                    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
                end
                
                local opacity = 0
                local dt = 0.1*i
                local dy = -dt*speed
                if dy >= -gdisplay.height then
                    dy = -gdisplay.height
                end
                local dp = cc.p(0,dy)
                local speedType = nil
                if i >= #allCell then
                    global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
                else
                    global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
                end
            end
        end
    end, self.othParam)
end
--CALLBACKS_FUNCS_END

return UIUnionAskPanel

--endregion
