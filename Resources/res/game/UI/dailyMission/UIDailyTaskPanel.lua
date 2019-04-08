
--region UIDailyTaskPanel.lua
--Author : untory
--Date   : 2016/08/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
local UITaskTab = require("game.UI.mission.UITaskTab")
--REQUIRE_CLASS_END

local UIDailyTaskPanel  = class("UIDailyTaskPanel", function() return gdisplay.newWidget() end )
local dailyTaskData = global.dailyTaskData
local UITableView = require("game.UI.common.UITableView")
local UIDailyTaskItemCell = require("game.UI.dailyMission.UIDailyTaskItemCell")
local UIBoxItemCell = require("game.UI.dailyMission.box.UIBoxItemCell")

function UIDailyTaskPanel:ctor()
    self:CreateUI()
end

function UIDailyTaskPanel:CreateUI()
    local root = resMgr:createWidget("task/task_daily_bg")
    self:initUI(root)
end

function UIDailyTaskPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_daily_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.common_title = self.root.common_title_export
    self.tableNode = self.root.tableNode_export
    self.topParent = self.root.topParent_export
    self.top_board = self.root.topParent_export.top_board_export
    self.quitBtn = self.root.topParent_export.top_board_export.quitBtn_export
    self.quitNode = self.root.topParent_export.top_board_export.quitBtn_export.quitNode_export
    self.quitIcon = self.root.topParent_export.top_board_export.quitBtn_export.quitNode_export.quitIcon_export
    self.curQualityNum = self.root.topParent_export.top_board_export.quitBtn_export.quitNode_export.curQualityNum_export
    self.effectQuit = self.root.topParent_export.top_board_export.quitBtn_export.quitNode_export.effectQuit_export
    self.flushTime = self.root.topParent_export.top_board_export.flushTime_export
    self.Node_Scroe = self.root.topParent_export.top_board_export.Node_Scroe_export
    self.progressNode = self.root.topParent_export.top_board_export.Node_Scroe_export.progressNode_export
    self.score = self.root.topParent_export.top_board_export.Node_Scroe_export.progressNode_export.score_export
    self.role_icon = self.root.topParent_export.top_board_export.Node_Scroe_export.progressNode_export.role_icon_export
    self.loading = self.root.topParent_export.top_board_export.loading_export
    self.box_tb_size = self.root.topParent_export.top_board_export.box_tb_size_export
    self.box_it_size = self.root.topParent_export.top_board_export.box_it_size_export
    self.rightBtn = self.root.topParent_export.top_board_export.rightBtn_export
    self.leftBtn = self.root.topParent_export.top_board_export.leftBtn_export
    self.tableSize = self.root.tableSize_export
    self.cell = self.root.tableSize_export.cell_export
    self.top = self.root.top_export
    self.buttom_node = self.root.buttom_node_export
    self.Panel_4 = self.root.Panel_4_export
    self.btnRlush = self.root.btnRlush_export
    self.grayBg = self.root.btnRlush_export.grayBg_export
    self.flush_time = self.root.btnRlush_export.flush_time_export
    self.dia_icon = self.root.btnRlush_export.dia_icon_export
    self.dia_num = self.root.btnRlush_export.dia_num_export
    self.top2 = self.root.top2_export
    self.paging = self.root.paging_export
    self.paging = UITaskTab.new()
    uiMgr:configNestClass(self.paging, self.root.paging_export)

    uiMgr:addWidgetTouchHandler(self.root.common_title_export.intro_btn, function(sender, eventType) self:help_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.quitBtn, function(sender, eventType) self:quitRewardHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:right_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:left_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnRlush, function(sender, eventType) self:flush_call(sender, eventType) end)
--EXPORT_NODE_END
    
    -- uiMgr:ad
    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)

    self.tableView = UITableView.new()
        :setSize(self.tableSize:getContentSize(),self.top2,self.buttom_node)
        :setCellSize(self.cell:getContentSize())
        :setCellTemplate(UIDailyTaskItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(3)

    self.tableView:setPositionX(self.buttom_node:getPositionX())

    self.boxTableView = UITableView.new()
        :setSize(self.box_tb_size:getContentSize())
        :setCellSize(self.box_it_size:getContentSize())
        :setCellTemplate(UIBoxItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)

    self.boxTableView:setBounceable(false)

    self.boxTableView.scrollViewDidScroll = handler(self, self.boxTableViewSlider)
    self.boxTableView:registerScriptHandler(handler(self.boxTableView, self.boxTableView.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.boxTableView:setPosition(self.box_tb_size:getPosition())

    self.top_board:addChild(self.boxTableView)
    self.tableNode:addChild(self.tableView)     -- 添加在node上， 防止触摸不吞噬的问题！

    self.effectNode = cc.Node:create()
    self.root:addChild(self.effectNode)

    self.topParentY = self.topParent:getPositionY()
end

local btnBg = {
    [1] = "ui_button/btn_refresh.png",
    [2] = "ui_button/btn_equip_grey.png",
}

function UIDailyTaskPanel:boxTableViewSlider()

    local offsetX = self.boxTableView:getContentOffset().x
    local dailyReward = luaCfg:daily_reward()
    local tableSize = self.box_tb_size:getContentSize().width
    local cellTotalSize = self.box_it_size:getContentSize().width*(table.nums(dailyReward))
    local minOffsetX = self.boxTableView:minContainerOffset().x

    if offsetX > (minOffsetX + 20) then
        self.rightBtn:setEnabled(true)
    else
        self.rightBtn:setEnabled(false)
    end
    if offsetX >= 0 then
        self.leftBtn:setEnabled(false)
    else
        self.leftBtn:setEnabled(true)
    end
    
    if self == nil or self.contentPen == nil then
        return 
    end
    
    local sW = self.loading:getContentSize().width
    local cutPen = self.contentPen + offsetX / sW * 100
    self.loading:setPercent(cutPen)

    local preX = cutPen * sW / 100

    local minX = 0
    local maxX = self.loading:getContentSize().width
    if preX < minX then preX = minX end
    if preX > maxX then preX = maxX end
    self.progressNode:setPositionX(preX)

end

function UIDailyTaskPanel:showTab()
    
    self.topParent:setPositionY(self.topParentY)
    self.FileNode_1:setVisible(true)
    self.paging:setVisible(true)

    self.tableView:setSize(self.tableSize:getContentSize(),self.top,self.buttom_node)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
end

function UIDailyTaskPanel:closeTab()
    
    self.topParent:setPositionY(self.topParentY + 178)
    self.FileNode_1:setVisible(false)
    self.paging:setVisible(false)

    self.tableView:setSize(self.tableSize:getContentSize(),self.top2,self.buttom_node)
     -- self.tableView:setSize(self.tableSize:getContentSize(), self.top2, self.buttom_node)
    -- 改变tableview 尺寸大小，重新设置下填充方向，不然会是倒序显示
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
end

function UIDailyTaskPanel:setData(noReset, noReset2)

    self:updateScore(noReset)
    self:updateCell(noReset2)

    if self.scheduleListenerId then
    else
       self.scheduleListenerId = gscheduler.scheduleGlobal(function()
            self:checkTime() 
        end, 1)
    end
    self:checkTime()

end


function UIDailyTaskPanel:onEnter()    

    -- 重置timeline
    self.isOnEnter = true
    self.tableView:setData({})

    local timeLine = resMgr:createTimeline("task/task_daily_bg")    
    self:runAction(timeLine)
    timeLine:gotoFrameAndPause(0)

    self.isFirstGuide = 0
    self.isOpenEffectId = 0     -- 是否启用开宝箱特效

    local callBB = function(event, isRefersh)
        self:setData(true, true)
        self:runAction(cc.Sequence:create( cc.DelayTime:create(0), cc.CallFunc:create(function ()         
            global.dailyTaskData:setFlushState()
        end)))
    end
    self:addEventListener(gameEvent.EV_ON_DAILY_TASK_FLUSH,callBB)

    -- vip 刷新 
    self:addEventListener(global.gameEvent.EV_ON_UI_USER_UPDATE,function()
        self:reFreshNumber()
    end)

    self.FileNode_1:setData(4,false,nil)
    self:closeTab()        
    self.paging:setIndex(3)
end

function UIDailyTaskPanel:reFreshNumber()
    self:flushBtnState()
end 
function UIDailyTaskPanel:onExit()
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end

    self.effectNode:removeAllChildren()
end

function UIDailyTaskPanel:checkTime()
    
    local contentTime = global.dataMgr:getServerTime()
    local nextTime = dailyTaskData:getNextFlushTime()

    local cutTime = nextTime - contentTime
    if cutTime < 0 then
        dailyTaskData:setRefershTime()
        gevent:call(gameEvent.EV_ON_DAILY_TASK_FLUSH)
        return        
    end

    local hour = math.floor(cutTime / 3600) 
    cutTime = cutTime  % 3600
    local min = math.floor(cutTime / 60)
    cutTime = cutTime % 60
    local sec = math.floor(cutTime)

    self.flushTime:setString(string.format(luaCfg:get_local_string(10012), hour,min,sec))
end


function UIDailyTaskPanel:updateScore(noReset)
    -- body

    local contentScore = dailyTaskData:getScore()
    self.score:setString(contentScore)

    local showScores = clone(dailyTaskData:getBoxs())
    local proIndex = 0
    local cutScore = 0

    -- 单个宝箱占用的百分比/2
    local boxSw = self.box_it_size:getContentSize().width/2
    local loadSw = self.loading:getContentSize().width
    local singlePen = (boxSw/loadSw)*100

    if contentScore <= showScores[1].score then
        cutScore = contentScore / showScores[1].score * singlePen
    end

    for i = 1,#showScores do

        local stepScore = showScores[i].score 
        local nextStepScore = 0

        if i ~= #showScores then
            nextStepScore = showScores[i + 1].score
        end

        local isCanGet = false
        -- 判断是否在可领取的区间
        if contentScore >= stepScore then

            if contentScore < nextStepScore then
                cutScore = (contentScore - stepScore) / (nextStepScore - stepScore) * singlePen * 2
            end
            isCanGet = true
            if i == 1 then
                proIndex = proIndex + singlePen
            else
                proIndex = proIndex + singlePen * 2
            end
        else
            isCanGet = false
        end

        showScores[i].isCanGet = isCanGet    
        showScores[i].sort = i
    end

    -- 大于宝箱总积分
    local addPen = 0
    local maxScore = showScores[#showScores].score 
    if contentScore >= maxScore then
        local totalScore = dailyTaskData:getTotalScore()
        local addVal = (contentScore - maxScore)/(totalScore - maxScore)
        addPen = math.ceil(addVal*singlePen)
    end

    local pen = proIndex + cutScore + addPen
    self.contentPen = pen 
    self.loading:setPercent(pen)

    self:boxTableViewSlider()

    self.boxTableView:setData(showScores, not self.isOnEnter)
    self:flushBtnState()

    if self.isOnEnter then
        self:gpsScoreBox(showScores)
        self:boxTableViewSlider()
        self.isOnEnter = false
    end

end 

function UIDailyTaskPanel:gpsScoreBox(showScores)

    local minOffsetX = self.boxTableView:minContainerOffset().x
    local maxOffsetX = self.boxTableView:maxContainerOffset().x
    local cellSize = self.box_it_size:getContentSize().width
    local offset = self.boxTableView:getContentOffset()
    local curGetMinIndex = self:getIndex(showScores)
    
    local offX = 0
    if curGetMinIndex > 0 then
        offX = 0-(cellSize*(curGetMinIndex-1))
    else
        local curUnLockIndex, curIndexScore = self:getCurScoreIndex(showScores)
        if curUnLockIndex ~= 0 then
            local lastScore = self:getScorByIndex(showScores, curUnLockIndex-1)
            local ffX = (curIndexScore-dailyTaskData:getScore())/(curIndexScore-lastScore)
            offX = 0-(cellSize*(curUnLockIndex-1))
            offX = offX + cellSize*3/2 + ffX*cellSize
        end
    end

    offX = offX < minOffsetX and  minOffsetX or offX
    offX = offX > maxOffsetX and  maxOffsetX or offX
    self.boxTableView:setContentOffset(cc.p(offX, offset.y))
end

function UIDailyTaskPanel:getScorByIndex(data, idx)
    for index ,v in ipairs(data) do 
        if idx == index then 
            return v.score
        end 
    end
    return 0
end

function UIDailyTaskPanel:getCurScoreIndex(data)

    local curScore = dailyTaskData:getScore()
    for index ,v in ipairs(data) do 
        if v.score >= curScore then 
            return index, v.score
        end 
    end
    return 0, 0
end

function UIDailyTaskPanel:getIndex(data)
    for index ,v in ipairs(data) do 
        if v.state == 0 then 
            return  index
        end 
    end 
    return 0
end 


function UIDailyTaskPanel:flushBtnState()

    -- 判断按钮状态
    local isCanFlush = true
    local config = luaCfg:get_config_by(1)
    -- 是否达到可刷新条件
    if not global.funcGame:checkTarget(config.daily_task_level) then 
        isCanFlush = false
    end
    -- 当期任务是否全部完成
    local _, canflush = dailyTaskData:isHaveTask() 
    isCanFlush = isCanFlush and canflush
    global.colorUtils.turnGray(self.grayBg, isCanFlush == false)
    
    local dailyRlush = luaCfg:get_daily_refresh_by(1)
    local refershTimes = dailyTaskData:getFlushTime()
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipTaskCount")
    if refershTimes < dailyRlush.freeTime or  vipfreenumber > 0  then
        if  global.vipBuffEffectData:isUseVipFreeNumber("lVipTaskCount") then
            if dailyRlush.freeTime -refershTimes > 0 then 
                self.flush_time:setString(luaCfg:get_local_string(10203,vipfreenumber+dailyRlush.freeTime -refershTimes))
            else
                self.flush_time:setString(luaCfg:get_local_string(10203,vipfreenumber))
            end 
        else 
            self.flush_time:setString(luaCfg:get_local_string(10203, dailyRlush.freeTime - refershTimes))
        end 
        self.dia_num:setVisible(false)
        self.dia_icon:setVisible(false)
        self.flush_time:setVisible(true)

        self.btnRlush:loadTextures(btnBg[2],btnBg[2],btnBg[2],ccui.TextureResType.plistType)
        self.grayBg:loadTexture(btnBg[2] ,ccui.TextureResType.plistType)
    else

        self.btnRlush:loadTextures(btnBg[1],btnBg[1],btnBg[1],ccui.TextureResType.plistType)
        self.grayBg:loadTexture(btnBg[1] ,ccui.TextureResType.plistType)

        local timesId = refershTimes
        self.dia_num:setVisible(true)
        self.dia_icon:setVisible(true)
        self.flush_time:setVisible(false)
        if timesId > 6 then
            self.dia_num:setString(dailyRlush["costNum"..dailyRlush.maxNum])
        else
            self.dia_num:setString(dailyRlush["costNum"..timesId] or dailyRlush.costNum6)
        end
        self:checkDiamondEnough()
    end
end

function UIDailyTaskPanel:updateCell(noReset2)
    -- body
    local data = dailyTaskData:getTasks()
    local compare = function(a, b)      
        if a.state == b.state then         
            return a.rank < b.rank 
        else
            return a.state < b.state
        end
    end
    table.sort(data, compare)

    dailyTaskData:cleanWaitList()
    self.tableView:setData(data, noReset2 or false)
    self:runAction( cc.Sequence:create( cc.DelayTime:create(0.5), cc.CallFunc:create(function ()
        global.tipsMgr:showTipsList()
    end)))

    self:refershQuitClass()

end

--当前橙色任务数量
function UIDailyTaskPanel:refershQuitClass() 

    local data = dailyTaskData:getTasks()
    local qualityNum, totalNum = 0, 0
    for k,v in pairs(data) do

        local taskData = luaCfg:get_daily_task_by(v.id)
        if taskData.quality >= global.dailyTaskData:getLockQualityLv() then
            qualityNum = qualityNum + 1
        end
    end

    local curGetPross = global.dailyTaskData:getQuitClass()
    local quitConfig = luaCfg:daily_quality_reward()
    for i,v in ipairs(quitConfig) do
        if (v.num <= qualityNum) and (v.num > curGetPross) then
            totalNum = v.num
            break
        end
    end
    --没有可领阶级
    if totalNum == 0 then
        for i,v in ipairs(quitConfig) do
            if v.num > qualityNum then
                totalNum = v.num
                break
            end
        end
    end
   
    if totalNum == 0 then -- 已领完
        totalNum = #data + 1
    end 

    self.totalQuitNum = totalNum
    self.qualityNum = qualityNum
    if totalNum == (#data + 1) then 
        self.curQualityNum:setString(luaCfg:get_local_string(10201))
        self.quitBtn:setEnabled(false)
        global.colorUtils.turnGray(self.quitNode, true)
    else 
        self.curQualityNum:setString(qualityNum .. "/" .. totalNum)
        self.quitBtn:setEnabled(true)
        global.colorUtils.turnGray(self.quitNode, false)
    end


    -- 奖励是否能领
    self.effectQuit:setVisible(false)
    if qualityNum >= totalNum then
        self.root:stopAllActions()
        self.effectQuit:setVisible(true)
        local nodeTimeLine =resMgr:createTimeline("task/task_daily_bg")
        nodeTimeLine:play("animation1",true)
        self.root:runAction(nodeTimeLine)
    end
end

function UIDailyTaskPanel:open_box(sender, eventType,i,isCanGet)
    -- body
    global.tipsMgr:cleanTipsWaitList()
    global.panelMgr:openPanel("UIDailyTaskRewardPanel"):setID(i,isCanGet)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDailyTaskPanel:btn_exit(sender, eventType)
    
    global.tipsMgr:showTipsList()
    global.panelMgr:closePanelForBtn("UIDailyTaskPanel")
end

function UIDailyTaskPanel:flush_call(sender, eventType)

    -- 未解锁刷新
    local config = luaCfg:get_config_by(1)
    if not global.funcGame:checkTarget(config.daily_task_level) then
        local condit = luaCfg:get_target_condition_by(config.daily_task_level)
        global.tipsMgr:showWarning(luaCfg:get_local_string(10479, condit.condition))
        return
    end

    -- 所有任务已完成
    local _, canflush = dailyTaskData:isHaveTask()
    if not canflush then
        global.tipsMgr:showWarning("daily_task_complete")
        return
    end

    local isFree = false
    local freeRefershTimes =  luaCfg:get_daily_refresh_by(1).freeTime
    local refershTimes = dailyTaskData:getFlushTime()
    if refershTimes < freeRefershTimes then
        isFree = true
    end
   
    local strErrorKey = dailyTaskData:isCanFlush()
    if strErrorKey == "nil" then
        
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_delaytaskNew")
        if not isFree then
            if self:checkDiamondEnough() then 
                self:useDiamond() 
            else
                global.panelMgr:openPanel("UIRechargePanel")
            end
        else
            self:useDiamond()
        end
        
    else
        global.tipsMgr:showCommonTips("common/common_normal_tips",luaCfg:get_errorcode_by(strErrorKey).text)
    end
end

function UIDailyTaskPanel:useDiamond()
    
    global.uiMgr:addSceneModel(1)

    global.itemApi:diamondUse(function(msg)
        local refershTimes = dailyTaskData:getFlushTime()
        if  global.vipBuffEffectData:isUseVipFreeNumber("lVipTaskCount") then 
            global.vipBuffEffectData:useVipDiverseFreeNumber("lVipTaskCount",1)
        else 
            dailyTaskData:setFlushTime(refershTimes + 1)
        end
        if self.flushBtnState then 
            self:flushBtnState()
        end 
    end,7)
end

function UIDailyTaskPanel:checkDiamondEnough()
    
    local isEnough = true
    local needNum = tonumber(self.dia_num:getString())
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,needNum or 0) then
        self.dia_num:setTextColor(gdisplay.COLOR_RED)
        isEnough = false
    else
        self.dia_num:setTextColor(cc.c3b(255, 184, 34))
    end
    return isEnough
end


function UIDailyTaskPanel:help_click(sender, eventType)
    
    local data = luaCfg:get_introduction_by(6)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIDailyTaskPanel:right_click(sender, eventType)

    self.boxTableView:scrollToRight() 
    self.leftBtn:setEnabled(true)
    self.rightBtn:setEnabled(false)
end

function UIDailyTaskPanel:left_click(sender, eventType)
    
    self.boxTableView:scrollToLeft()
    self.leftBtn:setEnabled(false)
    self.rightBtn:setEnabled(true)
end

function UIDailyTaskPanel:setPageViewCurrentPageIndex(index)
    self.FileNode_1:setPageViewCurrentPageIndex(index)
end

function UIDailyTaskPanel:getPageViewCurrentPageIndex()
   return self.FileNode_1:getPageViewCurrentPageIndex()
end 

function UIDailyTaskPanel:quitRewardHandler(sender, eventType)

    self.qualityNum  = self.qualityNum  or 0 
    self.totalQuitNum  = self.totalQuitNum  or 0 
    
    if self.qualityNum < self.totalQuitNum then
        
        local dropid = 0
        for i,v in ipairs(luaCfg:daily_quality_reward()) do
            if v.num == self.totalQuitNum then
                dropid = v.reward
                break
            end
        end
        if dropid > 0 then
            global.panelMgr:openPanel("UIDailyTaskRewardPanel"):setBossData(dropid, false, 0)
        end
        return 
    end

    global.taskApi:taskGetGift(0,function(msg)

        msg.tgItem = msg.tgItem or {}
        local data = {}
        for i,v in ipairs(msg.tgItem) do
            local temp = {} 
            table.insert(temp, v.lID)
            table.insert(temp, v.lCount)
            table.insert(data, temp)
        end

        global.panelMgr:openPanel("UIItemRewardPanel"):setData(data, true) 
        global.dailyTaskData:setQuitClass(self.totalQuitNum)
        self:refershQuitClass()
    end, 2)

end

--CALLBACKS_FUNCS_END

return UIDailyTaskPanel

--endregion
