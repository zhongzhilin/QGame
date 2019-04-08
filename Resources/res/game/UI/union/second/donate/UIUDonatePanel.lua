--region UIUDonatePanel.lua
--Author : wuwx
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUDonatePanel  = class("UIUDonatePanel", function() return gdisplay.newWidget() end )

function UIUDonatePanel:ctor()
    self:CreateUI()
end

function UIUDonatePanel:CreateUI()
    local root = resMgr:createWidget("union/union_donate_bj")
    self:initUI(root)
end

function UIUDonatePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_donate_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.res = self.root.res_export
    self.num = self.root.donate_mlan_6.num_export
    self.text = self.root.boom_mlan_6.text_export
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.node_tableView = self.root.node_tableView_export

    uiMgr:addWidgetTouchHandler(self.root.bg.btn_rank, function(sender, eventType) self:onOpenRankPanel(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
    local UIUDonateCell = require("game.UI.union.second.donate.UIUDonateCell")
    self.tableView = UIMultiTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUDonateCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.res)
end

function UIUDonatePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUDonatePanel")
end

function UIUDonatePanel:onEnter()
    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.res)


    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_DONATE, function()
        self:refresh(true)
    end)
    self:setData()
end

function UIUDonatePanel:onExit()
    gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
end

function UIUDonatePanel:setData()
    self.m_selectedItemId = 1
    self:refresh(nil,true)
end

function UIUDonatePanel:refresh(noReset,isOn)
    self.m_isOn = isOn or self.m_isOn
    local sortData = self:getTableViewData(self.m_selectedItemId,self.m_isOn)
    self.tableView:setData(sortData,noReset)

    self.num:setString(global.userData:getlAllyDonate().lStrongCur)
    self.text:setString(string.format("%s/%s",global.unionData:getInUnionStrong(),global.unionData:getInUnionMaxStrong()))

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.num:getParent(),self.num)
    global.tools:adjustNodePosForFather(self.text:getParent(),self.text)
end

function UIUDonatePanel:getTableViewData(itemId,isOn)
    local goData = {
        [1] = { file="UIUDonateOne",h=80,showChildren=false,childFile="UIUDonateItem",childH=122},
    }
    local showData = clone(goData[1])
    if itemId then
        showData.showChildren = isOn
        self.m_selectedItemId = itemId
    else
        showData.showChildren = true
        self.m_selectedItemId = 1
    end

    local parentList = global.luaCfg:union_donate_type()
    local data = {}
    for i,v in ipairs(parentList) do
        local itemData = v
        itemData.isChild = false
        if self.m_selectedItemId == v.id then
            itemData.uiData = showData
        else
            itemData.uiData = clone(goData[1])
        end
        itemData.children = {}
        local childList = global.luaCfg:union_donate()
        for ii,member in pairs(childList) do
            if member.type == v.type  then
                table.insert(itemData.children,{id=member.id,isChild=true,uiData={file=itemData.uiData.childFile,h=itemData.uiData.childH},bindId=v.id,sData=member})
            end
        end

        if #itemData.children > 0 then
            table.sort( itemData.children, function(a,b)
                return b.sData.array > a.sData.array
            end )
        end
        table.insert(data,itemData)
        if itemData.uiData.showChildren then
            table.insertTo(data,itemData.children)
        end
    end
    return data
end

--展开
function UIUDonatePanel:switchOn(itemId)
    self.m_isOn = true
    local data = self:getTableViewData(itemId,true)
    self.tableView:setData(data)
end 

--收回
function UIUDonatePanel:switchOff(itemId)
    self.m_isOn = false
    local data = self:getTableViewData(itemId,false)
    self.tableView:setData(data)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUDonatePanel:onOpenRankPanel(sender, eventType)
    -- global.tipsMgr:showWarning("FuncNotFinish")
    global.panelMgr:openPanel("UIUDonateRankPanel")
end
--CALLBACKS_FUNCS_END

return UIUDonatePanel

--endregion
