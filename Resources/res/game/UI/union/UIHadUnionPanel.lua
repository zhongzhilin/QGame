--region UIHadUnionPanel.lua
--Author : wuwx
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local rechargeData = global.rechargeData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIHadUnionPanel  = class("UIHadUnionPanel", function() return gdisplay.newWidget() end )
local UIUnionWarCell = require("game.UI.union.list.UIUnionWarCell")
local UITableView = require("game.UI.common.UITableView")
local UIAdvertisementItem = require("game.UI.advertisementItem.UIAdvertisementItem")

function UIHadUnionPanel:ctor()
    self:CreateUI()
end

function UIHadUnionPanel:CreateUI()
    local root = resMgr:createWidget("union/union_bj")
    self:initUI(root)
end

function UIHadUnionPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_3 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.FileNode_3)
    self.title = self.root.title_export
    self.Node_1 = self.root.Node_1_export
    self.name = self.root.Node_1_export.name_export
    self.boss = self.root.Node_1_export.boss_mlan_5.boss_export
    self.Boom = self.root.Node_1_export.boom_mlan_6.Boom_export
    self.capital = self.root.Node_1_export.capital_mlan_6.capital_export
    self.level = self.root.Node_1_export.level.level_export
    self.num = self.root.Node_1_export.num.num_export
    self.battle = self.root.Node_1_export.battle.battle_export
    self.war = self.root.Node_1_export.war_export
    self.language = self.root.Node_1_export.battle_0.language_export
    self.ScrollView_1 = self.root.Node_1_export.ScrollView_1_export
    self.notice = self.root.Node_1_export.ScrollView_1_export.notice_export
    self.FileNode_1 = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_1_export.FileNode_1)
    self.go_target = self.root.Node_1_export.go_target_export
    self.freeMoveCityBtn = self.root.Node_1_export.freeMoveCityBtn_export
    self.node_tableView = self.root.node_tableView_export
    self.spReadState = self.root.Node_24.btn.spReadState_export
    self.Text = self.root.Node_24.btn.spReadState_export.Text_export
    self.message = self.root.Node_24.btn.message_export
    self.message_text = self.root.Node_24.btn.message_export.message_text_export
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:go_target_handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.freeMoveCityBtn, function(sender, eventType) self:freeMoveCityHanlder(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_24.btn.btn1, function(sender, eventType) self:messageHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_24.btn.btn2, function(sender, eventType) self:memberHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_24.btn.btn3, function(sender, eventType) self:inviteHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_24.btn.btn4, function(sender, eventType) self:manageUnionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_24.btn.btn5, function(sender, eventType) self:onUnionMailPanel(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionWarCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.scroSize = self.ScrollView_1:getContentSize()
end
 

function UIHadUnionPanel:onEnter()

     local reFreshAd = function () 

        if global.advertisementData:isPsLock(2) then 
            self.FileNode_3:setVisible(false)
        else 
            self.FileNode_3:setData(2)
            self.FileNode_3:setVisible(true)
        end 
        self:adjustps()
        
    end 

    reFreshAd()

    global.loginApi:clickPointReport(nil,13,nil,nil)

    self.spReadState:setVisible(false)
    self.message:setVisible(false)
    self:setData()


    local setBtn  = function (stay) 

        local data = global.luaCfg:union_function_btn()
        table.sort( data, function(a,b)
            -- body
            return a.array < b.array
        end )
        self.tableView:setData(data , stay)

    end 

    setBtn()

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        reFreshAd()
        setBtn(true)
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.refresh then
            self:refresh()
        end
    end) 

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_PANEL, function(event,noNet,call)
        if not self.setData then return end
        if noNet then
            self:setData()
        else
            self:refresh(nil,call)
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH, function(event)
        if self.setData then
            self:setData()
        end
    end)

    self:refresh(true)
end


local ps ={
    default = gdisplay.height -241, 
    ad = gdisplay.height -345, 
} 

local top= {
    default = gdisplay.height-519 , 
    ad =  gdisplay.height -618, 
}


function UIHadUnionPanel:adjustps()

    self.tableView:setData({})

    if self.FileNode_3:isVisible() then 
        self.Node_1:setPositionY(ps.ad)
        self.itemTopNode:setPositionY(top.ad)

    else 
        self.Node_1:setPositionY(ps.default)
        self.itemTopNode:setPositionY(top.default)
    end

    self.tableView:setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

end 


--call by panelMgr after closePanel
function UIHadUnionPanel:onDefineExit()
    global.unionApi:sendExitAlly()
end

function UIHadUnionPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIHadUnionPanel")
end

function UIHadUnionPanel:setData(isReset)

    local data = global.unionData:getInUnion()
    self.data = data

    data.szShortName = data.szShortName or "-"
    data.lCount = data.lCount or "-"
    data.lPower = data.lPower or "-"
    data.szName = data.szName or "-"
    data.szInfo = data.szInfo or "-"
    
    -- dump(self.data,"asdffasdfasdfasdfasd")
    --设置旗帜
    self.FileNode_1:setData(self.data.lTotem)

    self.name:setString(string.format("【%s】%s",data.szShortName,data.szName))
    self.boss:setString(data.szLeader)
    self.num:setString(string.format("%s/%s",(self.data.lCount or 0),(self.data.lMaxCount or 0)))
    self.battle:setString(self.data.lPower)

    self.level:setString(global.unionData:getInUnionLv())
    self.war:setString("")
    
    --公告
    self.notice:setTextAreaSize(cc.size(self.notice:getContentSize().width,0))
    self.notice:setString(data.szNotice)
    local label = self.notice:getVirtualRenderer()
    local desSize = label:getContentSize()
    self.notice:setContentSize(desSize)
    local textH = self.notice:getContentSize().height
    self.notice:setString(data.szNotice)

    local itemH = self.itemLayout:getContentSize().height
    local contentSize = 120 
    local containerSize = textH 
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView_1:setInnerContainerSize(cc.size(600, containerSize))
    self.notice:setPositionY(containerSize)
    self.ScrollView_1:jumpToTop()


    self.Boom:setString(string.fformat("%s/%s",global.unionData:getInUnionStrong(),global.unionData:getInUnionMaxStrong()))
    self.capital:setString(global.userData:getlAllyDonate().lStrongCur)
    local lanId = global.unionData:getInUnionLanId()
    self.language:setString(global.unionData:getUnionLanguage(lanId))

    self.freeMoveCityBtn:setVisible(global.refershData:isHavFreeMoveTimes() and not global.unionData:isLeader())

    if isReset then
        self.tableView:setData(self.tableView:getData())
    else
        self.tableView:update(self.tableView:getData())
    end
    
    -- 联盟新成员红点
    local count = global.userData:getlAllyRedCountBy(1)
    self.spReadState:setVisible(count > 0 and (global.unionData:isHadPower(22)))
    self.Text:setString(count)

    -- 联盟留言红点
    local count = global.userData:getlAllyRedCountBy(5)
    self.message:setVisible(count > 0)
    self.message_text:setString(count)

--润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.boss:getParent(),self.boss)
    global.tools:adjustNodePosForFather(self.Boom:getParent(),self.Boom)
    global.tools:adjustNodePosForFather(self.capital:getParent(),self.capital)

end

function UIHadUnionPanel:refresh(isReset,call)
    local function callback(msg)
        if tolua.isnull(self) then
            return
        end
        -- body
        global.unionData:setInUnion(msg.tgAlly)
        global.unionData:setInUnionMembers(msg.tgMember)
        global.unionData:setInUnionBuilds(msg.tagBuilds)
        if self.setData  then --防止 nil 
            self:setData(isReset)
        end 
        if global.panelMgr:isPanelOpened("UIUnionMgrPanel") then
            --刷新管理界面
            global.panelMgr:getPanel("UIUnionMgrPanel"):setData()
        end
        if global.panelMgr:isPanelOpened("UIUBuildPanel") then
            --刷新联盟建设
            global.panelMgr:getPanel("UIUBuildPanel"):refresh(true)
        end
        if call then call() end
    end
    global.unionApi:getAllyMemberlist(callback,self.data.lID)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHadUnionPanel:messageHandler(sender, eventType)
    global.panelMgr:openPanel("UIUMsgPanel"):setData(self.data.lID)
end

function UIHadUnionPanel:memberHandler(sender, eventType)

    -- global.tipsMgr:showWarning("FuncNotFinish")
    global.panelMgr:openPanel("UIUnionMemberPanel"):setData()
end

function UIHadUnionPanel:inviteHandler(sender, eventType)
    if not global.unionData:isHadPower(14) then 
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    global.panelMgr:openPanel("UIUnionAskPanel"):setData()
end

function UIHadUnionPanel:manageUnionHandler(sender, eventType)
    global.panelMgr:openPanel("UIUnionMgrPanel")
end

function UIHadUnionPanel:go_target_handler(sender, eventType)
    if self.data and self.data.lLeader then
        local leaderData = global.unionData:getUnionLeaderData(self.data.lLeader)
        if leaderData and leaderData.lMapID then 
            global.funcGame:gpsWorldCity(leaderData.lMapID)
        end
    end
end

function UIHadUnionPanel:onUnionMailPanel(sender, eventType)

    if not global.unionData:isHadPower(25) then
        global.tipsMgr:showWarning("unionPowerNot")
        return 
    end
    global.panelMgr:openPanel("UIUnionMailPanel")
end

function UIHadUnionPanel:freeMoveCityHanlder(sender, eventType)
    
    
    local  tipsOverCall =   function () 

        global.funcGame:highMoveCitySpecial(function()
            local allyId = global.userData:getlAllyID()                     
            local tmpCall = function()
             
                global.worldApi:freeToMove(allyId,function(msg)

                    global.refershData:setFreeMoveTimes(1)
                    if self.freeMoveCityBtn then
                        self.freeMoveCityBtn:setVisible(global.refershData:isHavFreeMoveTimes() and  not global.unionData:isLeader())
                    end
                    global.panelMgr:closePanelForBtn("UIHadUnionPanel")

                    if global.scMgr:isWorldScene() then
                        -- msg = {lCityID = tonumber(strTb[3])}
                        global.g_worldview.worldPanel:setMainCityData(msg,true)
                        global.tipsMgr:showWarning("InviteMove01")
                    else
                        global.scMgr:gotoWorldSceneWithAnimation()
                        global.tipsMgr:showWarning("InviteMove01")
                    end                              
                end)
            end

            if global.troopData:isEveryTroopIsInsideCity() then

                tmpCall()
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")        
                panel:setData("CityMoveTroopsNo", function()
                       
                    tmpCall()
                end)
            end
        end)

    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")        
    panel:setData("MoveToLeader", function()
        tipsOverCall()
    end)


end
--CALLBACKS_FUNCS_END

return UIHadUnionPanel

--endregion
