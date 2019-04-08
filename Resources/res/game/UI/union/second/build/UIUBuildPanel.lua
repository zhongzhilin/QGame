--region UIUBuildPanel.lua
--Author : wuwx
--Date   : 2017/02/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUBuildPanel  = class("UIUBuildPanel", function() return gdisplay.newWidget() end )

function UIUBuildPanel:ctor()
    self:CreateUI()
end

function UIUBuildPanel:CreateUI()
    local root = resMgr:createWidget("union/union_build_bj")
    self:initUI(root)
end

function UIUBuildPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_build_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.union_lv = self.root.topinfo.info_bj.tips1_mlan_6.union_lv_export
    self.boom = self.root.topinfo.info_bj.tips2_mlan_6.boom_export
    self.type_icon = self.root.topinfo.type_bj.type_icon_export
    self.no = self.root.topinfo.no_mlan_10_export
    self.text = self.root.topinfo.text_mlan_6_export
    self.lv = self.root.topinfo.text_mlan_6_export.lv_export
    self.text_info = self.root.topinfo.text_info_mlan_7_export
    self.loadingbar_bg = self.root.loadingbar_bg_export
    self.LoadingBar = self.root.loadingbar_bg_export.LoadingBar_export
    self.time = self.root.loadingbar_bg_export.info_mlan_6.time_export
    self.task_btn = self.root.task_btn_export
    self.node_tableView = self.root.node_tableView_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:onIntro(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.task_btn, function(sender, eventType) self:onHelp(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UIMultiTableView = require("game.UI.common.multiMenuView.UIMultiTableView")
    local UIUBuildCell = require("game.UI.union.second.build.UIUBuildCell")
    self.tableView = UIMultiTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUBuildCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUBuildPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUBuildPanel")
end

function UIUBuildPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIUBuildPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIUBuildPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIUBuildPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIUBuildPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIUBuildPanel:onEnter()

    self.isPageMove = false
    self:registerMove()

    self:setData()

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_BUILD_DOING, function(event)
        global.unionApi:getAllyBuildState(function(msg)
            -- body
            self.m_helpTime = msg.lHelpTime
        end, global.userData:getlAllyID())
    end)
end

function UIUBuildPanel:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIUBuildPanel:setData()
    self.m_selectedItemId = self.m_selectedItemId or 1
    self:refresh(nil,true)
end

function UIUBuildPanel:refresh(noReset,isOn)
    self.m_isOn = isOn or self.m_isOn
    local sortData = self:getTableViewData(self.m_selectedItemId,self.m_isOn)
    self.tableView:setData(sortData,noReset)

    self.boom:setString(string.fformat("%s/%s",global.unionData:getInUnionStrong(),global.unionData:getInUnionMaxStrong()))
    self.union_lv:setString(global.unionData:getInUnionLv())

    local doingData = global.unionData:getInUnionBuildDoing()
    if doingData then
        local doingDData = global.luaCfg:get_union_build_by(doingData.lID)
        self.text:setString(doingDData.name)
        self.lv:setString("Lv"..(doingData.lLevel+1))
        -- 修改英文重叠 阿成
        global.tools:adjustNodePosForFather(self.lv:getParent(),self.lv)

        self.no:setVisible(false)
        self.text:setVisible(true)
        self.lv:setVisible(true)
        self.loadingbar_bg:setVisible(true)
        self.task_btn:setVisible(true)
        self.text_info:setVisible(true)
        self.type_icon:setVisible(true)
        -- self.type_icon:setSpriteFrame(doingDData.icon)
        global.panelMgr:setTextureFor(self.type_icon,doingDData.icon)

        self.m_helpTime = -1
        global.unionApi:getAllyBuildState(function(msg)
            -- body
            self.m_helpTime = msg.lHelpTime
        end, global.userData:getlAllyID())

        self.doingData = doingData
        if not self.m_countDownTimer then
            self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
        end
        self:countDownHandler(nil,true)
    else
        self.no:setVisible(true)
        self.text:setVisible(false)
        self.lv:setVisible(false)
        self.loadingbar_bg:setVisible(false)
        self.task_btn:setVisible(false)
        self.text_info:setVisible(false)
        self.type_icon:setVisible(false)
        -- if self.m_countDownTimer then
        --     gscheduler.unscheduleGlobal(self.m_countDownTimer)
        --     self.m_countDownTimer = nil
        -- end

--润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.union_lv:getParent(),self.union_lv)
    global.tools:adjustNodePosForFather(self.boom:getParent(),self.boom)
    global.tools:adjustNodePosForFather(self.time:getParent(),self.time)

    end
end

function UIUBuildPanel:countDownHandler(dt,isInit)

    if not self.doingData then return end
    local curr = global.dataMgr:getServerTime()
    local rest = (self.doingData.lEndTime or 0)-curr
    local per = rest/(self.doingData.lTotleTime or 1)*100
    local nextper = (rest-1)/(self.doingData.lTotleTime or 1)*100
    -- log.fatal("###########rest=%s,per=%s,self.doingData=%s",rest,per,vardump(self.doingData))
    if rest <= 0 then 
        rest = 0
        per = 0
        nextper=0
        local name = global.luaCfg:get_union_build_by(self.doingData.lID).name
        global.tipsMgr:showWarning("UnionBuild02",name)
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
    end
    self.LoadingBar:stopAllActions()
    if isInit then
        self.LoadingBar:setPercent(100-per)
    else
        self.LoadingBar:runAction(cc.ProgressFromTo:create(1,self.LoadingBar:getPercent(),100-nextper))
    end
    self.time:setString(global.funcGame.formatTimeToHMS(rest))

    --润稿 张亮
    global.tools:adjustNodePosForFather(self.time:getParent(),self.time)
end


function UIUBuildPanel:getTableViewData(itemId,isOn)
    local goData = {
        [1] = { file="UIUBuildOne",h=80,showChildren=false,childFile="UIUBuildItem",childH=122},
    }
    local showData = clone(goData[1])
    if itemId then
        showData.showChildren = isOn
        self.m_selectedItemId = itemId
    else
        showData.showChildren = true
        self.m_selectedItemId = 1
    end

    local parentList = global.luaCfg:union_build_type()
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
        itemData.childCount = 0
        local childList = global.luaCfg:union_build()
        for ii,member in pairs(childList) do
            if member.typelevel == v.type  then
                table.insert(itemData.children,{id=member.id,isChild=true,uiData={file=itemData.uiData.childFile,h=itemData.uiData.childH},bindId=v.id,sData=member})

                if global.unionData:isEnoughInUnionBuildsStudy(member.id) then
                    itemData.childCount = itemData.childCount+1
                end
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
function UIUBuildPanel:switchOn(itemId,cell)
    -- local cellId = cell:getId()
    -- local containerY = self.tableView:getContentOffset().y
    -- local originY = containerY+cell:getPositionY()

    self.m_isOn = true
    --刷新数据
    local data = self:getTableViewData(itemId,true)
    self.tableView:setData(data)

    -- local datas = self.tableView:getData()
    -- local allCell = self.tableView:getCells()
    --     table.sort( allCell, function(a,b)
    --         -- bod
    --         return a:getPositionY()>b:getPositionY()
    --     end )
    -- local endY = 0
    -- local endId = 0
    -- local nowCell = cell
    -- for i = 1, #allCell do
    --     local target = allCell[i]
    --     if target:getIdx() >= 0 and target:getId() == cellId-1 then
    --         endY = target:getPositionY()
    --         endId = target:getId()
    --     end

    --     if target:getIdx() >= 0 and target:getId() == cellId then
    --         nowCell = target
    --     end
    -- end
    -- local cellData = {}
    -- for _,v in ipairs(datas) do
    --     if v.id == cellId and not v.isChild then
    --         cellData = v
    --         break
    --     end
    -- end

    -- local containerPos = self.tableView:getContentOffset()
    -- local viewSize = self.tableView:getViewSize()
    -- local relationY = endY+containerPos.y --小于0时，处于不可见状态,相对node_tableview的坐标
    -- local offY = cellData.uiData.h*(cellId-endId)-relationY
    -- local nowCellY = nowCell:getPositionY()

    -- -- log.fatal("####containerPos.y=%s,relationY=%s,offY=%s,cellId=%s,endId=%s,endY=%s,originY=%s,nowCellY=%s",containerPos.y,relationY,offY,cellId,endId,endY,originY,nowCellY)
    -- -- log.fatal("####allCell[1].y=%s,containerPos.Y=%s,viewSize.height=%s,relationY=%s,offY=%s",allCell[1]:getPositionY(),containerPos.y,viewSize.height,relationY,offY)
    -- local needAction = true
    -- if relationY <= 0 then
    --     if allCell[1]:getPositionY()+containerPos.y+offY+cellData.uiData.childH<=viewSize.height then
    --         --拉出上面范围，不需改变
    --         needAction = false
    --     else
    --         self.tableView:setContentOffset(cc.p(containerPos.x,containerPos.y+offY))
    --     end
    -- else
    --     if originY <= 0 then
    --         originY=0
    --     end
    --     if allCell[1]:getPositionY()+originY-nowCellY+cellData.uiData.childH<=viewSize.height then
    --         --拉出上面范围，不需改变
    --         needAction = false
    --     else
    --         --正常的cell保持原来的位置不变
    --         self.tableView:setContentOffset(cc.p(containerPos.x,originY-nowCellY))
    --     end
    --     if (#cellData.children > 0) and (originY-cellData.uiData.childH>=0) then
    --         --超出一定区域不要滚动调整
    --         needAction = false
    --     end
    -- end

    -- local newContainerPos = self.tableView:getContentOffset()
    -- local newNowCellY = nowCell:getPositionY()
    -- if needAction then
    --     self.tableView:setContentOffset(cc.p(containerPos.x,newContainerPos.y+cellData.uiData.childH-(newContainerPos.y+newNowCellY)),true)
    -- end
end 

--收回
function UIUBuildPanel:switchOff(itemId,cell)
    -- local cellId = cell:getId()
    -- local containerY = self.tableView:getContentOffset().y
    -- local originY = containerY+cell:getPositionY()

    self.m_isOn = false
    --刷新数据
    local data = self:getTableViewData(itemId,false)
    self.tableView:setData(data)

    -- local datas = self.tableView:getData()
    -- local allCell = self.tableView:getCells()
    --     table.sort( allCell, function(a,b)
    --         -- bod
    --         return a:getPositionY()>b:getPositionY()
    --     end )
    -- local endY = 0
    -- local endId = 0
    -- local nowCell = cell
    -- for i = 1, #allCell do
    --     local target = allCell[i]
    --     if target:getIdx() >= 0 and target:getId() == cellId-1 then
    --         --最底层cell的位置
    --         endY = target:getPositionY()
    --         endId = target:getId()
    --     end

    --     if target:getIdx() >= 0 and target:getId() == cellId then
    --         nowCell = target
    --     end
    -- end
    -- local cellData = {}
    -- for _,v in ipairs(datas) do
    --     if v.id == cellId and not v.isChild then
    --         cellData = v
    --         break
    --     end
    -- end

    -- local containerPos = self.tableView:getContentOffset()
    -- local viewSize = self.tableView:getViewSize()
    -- local relationY = endY+containerPos.y --小于0时，处于不可见状态,相对node_tableview的坐标
    -- local offY = cellData.uiData.h*(cellId-endId)-relationY
    -- local nowCellY = nowCell:getPositionY()

    -- if allCell[1]:getPositionY()+cellData.uiData.h<=viewSize.height then
    --     --拉出上面范围，不需改变
    --     return
    -- end
    -- --正常情况保持不动
    -- self.tableView:setContentOffset(cc.p(containerPos.x,originY-nowCellY))
    -- local containerPos = self.tableView:getContentOffset()
    -- --超出移回
    -- if containerPos.y > 0 then
    --     self.tableView:setContentOffset(cc.p(containerPos.x,0))
    -- end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUBuildPanel:onIntro(sender, eventType)
    local data = global.luaCfg:get_introduction_by(11)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIUBuildPanel:onHelp(sender, eventType)
    -- global.tipsMgr:showWarning("FuncNotFinish")
    if self.m_helpTime == -1 then
        return
    end
    local currTime = global.dataMgr:getServerTime()
    local rest = self.m_helpTime - currTime
    if rest > 0 then
        return global.tipsMgr:showWarning("UnionBuild09",global.funcGame.formatTimeToHMS(rest))
    end
    global.unionApi:startAllyBuild(function(msg)
        -- body
        global.tipsMgr:showWarning("UnionBuild07",msg.lPay)
        self.m_helpTime = -1
        self:refresh(true)
    end,self.doingData.lID,1)
end
--CALLBACKS_FUNCS_END

return UIUBuildPanel

--endregion
