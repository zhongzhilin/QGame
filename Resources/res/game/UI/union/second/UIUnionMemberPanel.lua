--region UIUnionMemberPanel.lua
--Author : wuwx
--Date   : 2016/12/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIApplyOffice = require("game.UI.union.widget.UIApplyOffice")
--REQUIRE_CLASS_END

local UIUnionMemberPanel  = class("UIUnionMemberPanel", function() return gdisplay.newWidget() end )

function UIUnionMemberPanel:ctor()
    self:CreateUI()
end

function UIUnionMemberPanel:CreateUI()
    local root = resMgr:createWidget("union/union_member_bg")
    self:initUI(root)
end

function UIUnionMemberPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_member_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.btn1 = UIApplyOffice.new()
    uiMgr:configNestClass(self.btn1, self.root.Node_7.btn1)
    self.btn2 = UIApplyOffice.new()
    uiMgr:configNestClass(self.btn2, self.root.Node_7.btn2)
    self.btn3 = UIApplyOffice.new()
    uiMgr:configNestClass(self.btn3, self.root.Node_7.btn3)
    self.btn4 = UIApplyOffice.new()
    uiMgr:configNestClass(self.btn4, self.root.Node_7.btn4)
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
    local UIUnionMemCell = require("game.UI.union.list.UIUnionMemCell")
    self.tableView = UIMultiTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionMemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUnionMemberPanel:onEnter()
    self.officeData = {}
    --设置官职信息
    local unionTopBtnDatas = global.luaCfg:union_position_btn()
    for i,v in ipairs(unionTopBtnDatas) do
        if self["btn"..i] then
            self["btn"..i]:setData(v)
            self.officeData[v.id] = {}
            self.officeData[v.id].state = 0
            self.officeData[v.id].data = {}
            self.officeData[v.id].applyData = {}
        end
    end
    self.m_eventListenerCustomList = {}
end

function UIUnionMemberPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIUnionMemberPanel:setmode()

    self.root.Node_7:setVisible(not self.isOtherWay)
    self.itemTopNode:setPositionY(gdisplay.height-390)
    if self.isOtherWay then 
        self.itemTopNode:setPositionY(gdisplay.height-80)
    end 
    self.contentLayout:setContentSize(cc.size(self.contentLayout:getContentSize().width , self.itemTopNode:getPositionY() - self.itemBottomNode:getPositionY()))
    self.tableView:setSize(self.contentLayout:getContentSize(),self.itemTopNode, self.itemBottomNode)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
end  

function UIUnionMemberPanel:setData(otherUnionData , isOtherWay)
    --标记是否是打开的自己的联盟
    self.tgMember = {}
    self.m_isMineUnion = not otherUnionData
    self.data = otherUnionData or global.unionData:getInUnion()
    self.m_selectedItemId = 1

    self.tableView:setData({})
    self.isOtherWay = isOtherWay
    self:setmode()

    self:refresh(nil,true)

    self:addEventListener(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH, function()
        self:refresh(true)
    end)
    
    self.m_isMineUnion  =  self.data.lID  == global.unionData:getInUnion().lID

end

function UIUnionMemberPanel:refresh(noReset,isOn)
    local function callback(msg)
        -- body
        if self.data and global.unionData:isMineUnion(self.data.lID) then
            global.unionData:setInUnion(msg.tgAlly)
            global.unionData:setInUnionMembers(msg.tgMember)
            global.unionData:setInUnionBuilds(msg.tagBuilds)
            gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL,true)            
        end
        self.tgMember = msg.tgMember
        self.m_isOn = isOn or self.m_isOn
        local sortData,showChildrenIsNil = self:getTableViewData(self.m_selectedItemId,self.m_isOn)
        if showChildrenIsNil then
            noReset = false
        end
        self.tableView:setData(sortData,noReset)

        self:setOfficeBtns()
        
        -- 下载用户头像
        if msg.tgMember then
            local data = {}
            for i,v in pairs(msg.tgMember) do
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
    end

    if self.data then 
        global.unionApi:getAllyMemberlist(callback,self.data.lID)
    end 
end

--处理联盟官职数据
function UIUnionMemberPanel:setOfficeBtns()
    for i,v in pairs(self.officeData) do
        self.officeData[i].isApplying = false
        self.officeData[i].data = {}
        self.officeData[i].applyData = {}
    end
    for ii,member in ipairs(self.tgMember) do
        local applys = global.tools:d2b(member.lApply,4)
        for k,v in ipairs(applys) do
            local lApply = k
            if v > 0 then
                if member.lID == global.userData:getUserId() then
                    self.officeData[lApply].isApplying = true
                end
                table.insert(self.officeData[lApply].applyData,member)
            end
        end

        local classes = global.tools:d2b(member.lClass,4)
        for k,v in ipairs(classes) do
            local lClass = k
            if v > 0 then
                self.officeData[lClass].data = member
            end
        end
    end

    for i,v in pairs(self.officeData) do
        if self["btn"..i] then
            self["btn"..i]:setOfficeData(self.officeData[i])
        end
    end
end

--1,2,3,4配置id是否在服务器给定的lApply值内
function UIUnionMemberPanel:checkIsApply(s,id)
    local bitT = global.tools:d2b(s,4)
    for i,v in ipairs(bitT) do
        if i == id then
            return v > 0 
        end
    end
end
-- 获取排序好的申请该官职的所有成员列表
function UIUnionMemberPanel:getApplyList(id)
    local data = {}
    for ii,member in ipairs(self.tgMember) do
        if self:checkIsApply(member.lApply,id) and not global.unionData:isLeader(nil,member.lID) and member.lRole>0 and not self:checkIsApply(member.lClass,id) then
            table.insert(data,member)
        end
    end
    table.sort( data, function(a,b)
        -- body
        if self:checkIsApply(a.lApply,id) and self:checkIsApply(b.lApply,id) then
            if a.lOnline == b.lOnline then
                return a.lPower >= b.lPower
            else
                return a.lOnline > b.lOnline
            end
        else
            if self:checkIsApply(a.lApply,id) then
                return true
            elseif self:checkIsApply(b.lApply,id) then
                return false
            else
                if a.lOnline == b.lOnline then
                    return a.lPower >= b.lPower
                else
                    return a.lOnline > b.lOnline
                end
            end
        end
    end )
    return data
end

function UIUnionMemberPanel:getTableViewData(itemId,isOn)
    local goData = {
        [1] = { file="UIUnionMemOne",h=80,showChildren=false,childFile="UIUnionMemSecA",childH=120},
        [2] = { file="UIUnionMemOne",h=80,showChildren=false,childFile="UIUnionMemSecB",childH=120},
        [3] = { file="UIUnionMemOne",h=80,showChildren=false,childFile="UIUnionMemSecB",childH=120},
        [4] = { file="UIUnionMemOne",h=80,showChildren=false,childFile="UIUnionMemSecB",childH=120},
        [5] = { file="UIUnionMemOne",h=80,showChildren=false,childFile="UIUnionMemSecB",childH=120},
        [6] = { file="UIUnionMemOne",h=80,showChildren=false,childFile="UIUnionMemSecC",childH=120},
    }
    if itemId then
        goData[itemId].showChildren = isOn
        self.m_selectedItemId = itemId
    else
        goData[1].showChildren = true
        self.m_selectedItemId = 1
    end

    local parentList = clone(global.luaCfg:union_class_btn())

    local canLookOnlineState = false
    if not self.m_isMineUnion then
        --别人联盟不能看申请信息
        table.remove(parentList,6)
    else
        canLookOnlineState = global.unionData:isHadPower(19)
    end

    local showChildrenIsNil = false
    local data = {}
    for i,v in ipairs(parentList) do
        local itemData = v
        itemData.uiData = goData[v.id]
        itemData.children = {}
        itemData.onlineCount = 0
        for ii,member in ipairs(self.tgMember) do
            if member.lRole == v.level then
                table.insert(itemData.children,{id=v.id*1000+1 ,uiData={file=itemData.uiData.childFile,h=itemData.uiData.childH},bindId=v.id,sData=member,canLookOnlineState=canLookOnlineState})
                if member.lOnline == 1 then
                    itemData.onlineCount = itemData.onlineCount + 1
                end
            end
        end
        itemData.count = #itemData.children
        if not canLookOnlineState then
            itemData.onlineCount = itemData.count
        end
        -- itemData.children = {
        --     {id=v.id*1000+1 ,uiData={file=itemData.uiData.childFile,h=itemData.uiData.childH},bindId=v.id},
        --     {id=v.id*1000+2 ,uiData={file=itemData.uiData.childFile,h=itemData.uiData.childH},bindId=v.id},
        -- }

        if #itemData.children > 0 then
            table.sort( itemData.children, function(a,b)
                if a.sData.lOnline == b.sData.lOnline then
                    return a.sData.lPower > b.sData.lPower
                else
                    return a.sData.lOnline > b.sData.lOnline
                end
            end )
        end
        table.insert(data,itemData)
        if itemData.uiData.showChildren then
            if #itemData.children > 0 then
                table.insertTo(data,itemData.children)
            else
                showChildrenIsNil = true
            end
        else
        end
    end
    return data,showChildrenIsNil
end

--展开
function UIUnionMemberPanel:switchOn(itemId)
    self.m_isOn = true
    local data = self:getTableViewData(itemId,true)
    self.tableView:setData(data)
end

--收回
function UIUnionMemberPanel:switchOff(itemId)
    self.m_isOn = false
    local data = self:getTableViewData(itemId,false)
    self.tableView:setData(data)
end

function UIUnionMemberPanel:exit_call()
    global.panelMgr:closePanelForBtn("UIUnionMemberPanel")
end

function UIUnionMemberPanel:getTableView()
    return self.tableView
end

function UIUnionMemberPanel:isMineUnion()
    return self.m_isMineUnion
end

--获取联盟数据
function UIUnionMemberPanel:getData()
    return self.data
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionMemberPanel

--endregion
