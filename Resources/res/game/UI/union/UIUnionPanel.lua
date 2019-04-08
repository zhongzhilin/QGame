--region UIUnionPanel.lua
--Author : wuwx
--Date   : 2016/12/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UILoadTableView = require("game.UI.union.widget.UILoadTableView")
local UIUnionCell = require("game.UI.union.list.UIUnionCell")

local UIUnionPanel = class("UIUnionPanel", function() return gdisplay.newWidget() end )

function UIUnionPanel:ctor()
    self:CreateUI()
end

function UIUnionPanel:CreateUI()
    local root = resMgr:createWidget("union/union_list_bg")
    self:initUI(root)
end

function UIUnionPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_list_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node_tableView = self.root.node_tableView_export
    self.title = self.root.title_export
    self.search_name = self.root.top_bj.search_name.search_name_mlan_8_export
    self.search_name = UIInputBox.new()
    uiMgr:configNestClass(self.search_name, self.root.top_bj.search_name.search_name_mlan_8_export)
    self.search_language_btn = self.root.top_bj.search_language_btn_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export

    uiMgr:addWidgetTouchHandler(self.root.top_bj.search, function(sender, eventType) self:searchHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.change, function(sender, eventType) self:refreshHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.establish, function(sender, eventType) self:createHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.tableView = UILoadTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.search_language_btn:setPressedActionEnabled(false)

    -- self.search_language:setTextColor(self.m_normalColor)
    self.search_name:addEventListener( function()
        -- body
        self.m_currKey = self.search_name:getString()
    end )


    local lans = global.luaCfg:union_languages()
    local sourceData = {}
    for _,v in pairs(lans) do
        local tData = clone(v)
        tData.text = v.name
        table.insert(sourceData,tData)
    end
    table.sort(sourceData,function(s,b)
        -- body
        return s.id<b.id
    end)
    self.sourceData = sourceData

    local UIDownListControl = require("game.UI.common.selectItemView.UIDownListControl")
    self.jobComboBox = UIDownListControl.new(self.search_language_btn)
    self.jobComboBox:setData(sourceData)
    -- self.jobComboBox:setOpenListCsb("union/union_lan_item")
    self.jobComboBox:setOpenListCsb("union/union_lan_item",handler(self, self.onItemUpdate))
    self.jobComboBox:setSelectedItemChangeHandler(handler(self, self.onItemChangeHandler))
    self.root:addChild(self.jobComboBox)
end

local bgs = {
    [0] = "ui_surface_icon/union_language2.jpg",
    [1] = "ui_surface_icon/union_language1.jpg"
}
function UIUnionPanel:onItemUpdate(data,item)
    item.root.bg:setSpriteFrame(bgs[data.id%2])
    item.root.text:setString(data.text)
end

--切换item的回调
function UIUnionPanel:onItemChangeHandler(data)
    self.m_currLanguage = data.id
end

function UIUnionPanel:onEnter()
    self.tableView:setData({})
    self.m_currPage = 1
    self.m_currLanguage = nil
    self.m_currKey = nil
    self.m_inputMode = 0
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
end

function UIUnionPanel:onExit()
end

function UIUnionPanel:exit_call(sender, eventType)
    if global.panelMgr:isPanelOpened("UIUnionSearchPanel") then
        global.panelMgr:closePanelForBtn("UIUnionSearchPanel")
    else
        global.panelMgr:closePanelForBtn("UIUnionPanel")
    end
end

function UIUnionPanel:setInputMode(mode)
    self.m_inputMode = mode
end

function UIUnionPanel:getInputMode(mode)
    return self.m_inputMode
end

function UIUnionPanel:setData(searchKey,lanId,call)
    if lanId then
        self.jobComboBox:setCurrentDataIndex(self:getIdxBy(lanId), true)
    else
        self.jobComboBox:setCurrentDataIndex(self:getIdxBy(1), true)
    end
    if searchKey then
        --展示搜索结果
        self.search_name:setString(searchKey)

        self.m_currKey = self.search_name:getString()
        self.m_currLanguage = self.jobComboBox:getCurrentData().id
        global.unionData:getMore(function(data)
                -- 成功返回
                if tolua.isnull(self.tableView) then return end
                local union = global.unionData:getUnion()
                self.tableView:setData(union)
                if call then call() end

                if data and data.lPage then
                    self.m_currPage = data.lPage + 1
                end
            end,1,self.m_currLanguage,self.m_currKey,
            function(ret)
                -- 没有搜索结果
                self.tableView:setData({})
            end)
    else
        self.search_name:setString("")
        global.unionData:getMore(function(data)

            if tolua.isnull(self.tableView) then return end
            local union = global.unionData:getUnion()
            global.funcGame:checkIsNeedOpenUnionAd(union)
            self.tableView:setData(union)
            if call then call() end

            if data and data.lPage then
                self.m_currPage = data.lPage + 1
            end
        end,self.m_currPage,self.m_currLanguage,self.m_currKey)
    end

    --如果已经加入联盟，认为通过其他联盟按钮进入的
    if global.userData:checkJoinUnion() then
        self.root.btn_bj.establish:setVisible(false)
        self.root.btn_bj.change:setPositionX(350)
    else
        self.root.btn_bj.establish:setVisible(true)
        self.root.btn_bj.change:setPositionX(216)
    end
end

function UIUnionPanel:getIdxBy(lanId)
    if not lanId then
        return
    end
    for i,v in ipairs(self.sourceData) do
        if v.id == lanId then
            return i
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionPanel:searchHandler(sender, eventType)
    -- if self.search_name:getString() == "" and (self.jobComboBox:getCurrentData().id == 1) then
    --     global.tipsMgr:showWarning("UnionKey")
    --     return
    -- end
    self.m_currLanguage = self.jobComboBox:getCurrentData().id 
    if global.panelMgr:isPanelOpened("UIUnionSearchPanel") then
        global.panelMgr:getPanel("UIUnionSearchPanel"):setData(self.search_name:getString(),self.m_currLanguage)
    else
        global.panelMgr:openPanel("UIUnionSearchPanel"):setData(self.search_name:getString(),self.m_currLanguage)
        self.search_name:setString("")
        self.m_currKey = nil

        self.jobComboBox:setCurrentDataIndex(self:getIdxBy(1), true)
        self.m_currLanguage = nil
    end
end

function UIUnionPanel:refreshHandler(sender, eventType)

    -- self.m_currPage = 1
    self:setData(self.m_currKey,self.m_currLanguage,function()
        -- body
        local modal = global.uiMgr:addSceneModel(1)
        local allCell = self.tableView:getCells()
        table.sort( allCell, function(a,b)
            -- bod
            return a:getPositionY()>b:getPositionY()
        end )
        local speed = 5000
        for i = 1, #allCell do
            local target = allCell[i]
            if target:getIdx() >= 0 then

                local overCall_sound = function ()
                    gsound.stopEffect("city_click")
                    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
                end
                local overCall = function ()
                    gsound.stopEffect("city_click")
                    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
                    if modal and not tolua.isnull(modal) then
                        modal:removeFromParent()
                    end
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
                    global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall_sound)
                end
            end
        end
    end)
end

function UIUnionPanel:createHandler(sender, eventType)
    global.panelMgr:openPanel("UICreateUnionPanel"):setData()
end

--CALLBACKS_FUNCS_END

-- 检查自己是否已在联盟

return UIUnionPanel

--endregion
