--region UIMailBattlePanel.lua
--Author : yyt
--Date   : 2016/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local mailData = global.mailData
local UIBattleInfo = require("game.UI.mail.UIBattleInfo")
local UIBattleBoss = require("game.UI.mail.UIBattleBoss")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIMonsterListNode = require("game.UI.mail.UIMonsterListNode")
local UIBattleShare = require("game.UI.mail.UIBattleShare")
--REQUIRE_CLASS_END

local UIMailBattlePanel  = class("UIMailBattlePanel", function() return gdisplay.newWidget() end )

function UIMailBattlePanel:ctor()
    self:CreateUI()
end

function UIMailBattlePanel:CreateUI()
    local root = resMgr:createWidget("mail/mall_war_bg")
    self:initUI(root)
end

function UIMailBattlePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mall_war_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.textLayout = self.root.textLayout_export
    self.bg = self.root.bg_export
    self.touchNode = self.root.touchNode_export
    self.common_title = self.root.common_title_export
    self.texTitleHead = self.root.common_title_export.texTitleHead_fnt_mlan_12_export
    self.ScroViewInfo = self.root.ScroViewInfo_export
    self.NodeTotal = self.root.ScroViewInfo_export.NodeTotal_export
    self.replay_bt = self.root.ScroViewInfo_export.NodeTotal_export.replay_bt_export
    self.ranks_left = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.ranks_left_mlan_8_export
    self.plA1 = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.plA1_export
    self.plA2 = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.plA2_export
    self.plA3 = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.plA3_export
    self.plA4 = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.plA4_export
    self.plA_add = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.plA_add_export
    self.scaleA = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.scaleA_mlan_5_export
    self.scaleNumA = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.scaleNumA_export
    self.winA = self.root.ScroViewInfo_export.NodeTotal_export.ranks1.winA_export
    self.go_target = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.go_target_export
    self.plD1 = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.plD1_export
    self.plD2 = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.plD2_export
    self.plD3 = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.plD3_export
    self.plD4 = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.plD4_export
    self.plD_add = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.plD_add_export
    self.scaleD = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.scaleD_mlan_5_export
    self.scaleNumD = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.scaleNumD_export
    self.winD = self.root.ScroViewInfo_export.NodeTotal_export.ranks2.winD_export
    self.city = self.root.ScroViewInfo_export.NodeTotal_export.title.city_export
    self.date = self.root.ScroViewInfo_export.NodeTotal_export.title.date_export
    self.textTitle = self.root.ScroViewInfo_export.NodeTotal_export.title.textTitle_export
    self.resultResNode = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export
    self.exploitVal = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.exploit_mlan_5.exploitVal_export
    self.dateRes = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.dateRes_mlan_5_export
    self.dateDefense = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.dateDefense_mlan_5_export
    self.data2 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.data2.data2_export
    self.data3 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.data3.data3_export
    self.data1 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.data1.data1_export
    self.data4 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.data4.data4_export
    self.wallIcon1 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon1_export
    self.leftDef1 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon1_export.leftDef1_export
    self.cfA1 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon1_export.leftDef1_export.cfA1_export
    self.leftDef2 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon1_export.leftDef2_export
    self.cfA2 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon1_export.leftDef2_export.cfA2_export
    self.wallIcon2 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon2_export
    self.rightDef1 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon2_export.rightDef1_export
    self.cfD1 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon2_export.rightDef1_export.cfD1_export
    self.rightDef2 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon2_export.rightDef2_export
    self.cfD2 = self.root.ScroViewInfo_export.NodeTotal_export.resultResNode_export.wallIcon2_export.rightDef2_export.cfD2_export
    self.posAttack = self.root.ScroViewInfo_export.NodeTotal_export.posAttack_export
    self.attackNode = self.root.ScroViewInfo_export.NodeTotal_export.attackNode_export
    self.wildItemNode = self.root.ScroViewInfo_export.NodeTotal_export.wildItemNode_export
    self.wildItemNode = UIMonsterListNode.new()
    uiMgr:configNestClass(self.wildItemNode, self.root.ScroViewInfo_export.NodeTotal_export.wildItemNode_export)
    self.wildItemWidget = self.root.ScroViewInfo_export.NodeTotal_export.wildItemWidget_export
    self.collectBtn = self.root.ScroViewInfo_export.NodeTotal_export.collectBtn_export
    self.defenseNode = self.root.ScroViewInfo_export.defenseNode_export
    self.troopNodePos = self.root.ScroViewInfo_export.troopNodePos_export
    self.cachePosNode = self.root.ScroViewInfo_export.cachePosNode_export
    self.adNodeLayout = self.root.adNodeLayout_export
    self.toplayout = self.root.toplayout_export
    self.toplayout1 = self.root.toplayout1_export
    self.troopLayout = self.root.troopLayout_export
    self.titleLayout = self.root.titleLayout_export
    self.sharePanel = self.root.sharePanel_export
    self.shareNode = self.root.sharePanel_export.shareNode_export
    self.shareNode = UIBattleShare.new()
    uiMgr:configNestClass(self.shareNode, self.root.sharePanel_export.shareNode_export)
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.common_title_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.replay_bt, function(sender, eventType) self:replay_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsTargetHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collectBtn, function(sender, eventType) self:collectMailHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.aTroopScale = self.attackNode.Node_1.info
    self.dTroopScale = self.defenseNode.Node_1.info
    self.aTroopCombat = self.attackNode.Node_1.combat
    self.dTroopCombat = self.defenseNode.Node_1.combat
    self.aTroopCity = self.attackNode.Node_1.city

    self.ScrollSH = self.ScroViewInfo:getContentSize().height

    -- 节点管理部队列表
    self.troopNode = cc.Node:create()
    self.ScroViewInfo:addChild(self.troopNode)

    self.defH = self.leftDef2:getContentSize().height
    self.defY = self.leftDef2:getPositionY()

    self.aX = self.scaleNumA:getPositionX()
    self.dX = self.scaleNumD:getPositionX()

    self.topOffsetNode = cc.Node:create()
    self.ScroViewInfo:addChild(self.topOffsetNode)

    -- local tag = cc.Sprite:create()
    -- tag:setSpriteFrame("mapunit/y_004.png")
    -- self.topOffsetNode:addChild(tag)

    self.ScroViewInfo:addEventListener(function()
        self:scrollEvent()
    end)    

    self.sharePanel:setContentSize(cc.size(gdisplay.width, gdisplay.height-80))

    global.panelMgr:setTextureFor(self.wallIcon2, "icon/race/all/torret_icon.png")
    global.panelMgr:setTextureFor(self.wallIcon1, "icon/race/all/trap_icon.png")

    uiMgr:configUILanguage(self.attackNode, "mail/mall_war_list")
    uiMgr:configUILanguage(self.defenseNode, "mail/mall_war_list2")

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

    self:adapt()

    for i=1,4 do
        global.funcGame:initBigNumber(self["data"..i], 2)
    end

end


function UIMailBattlePanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 


function UIMailBattlePanel:isClickScroRect(touchPoint)

    if not self.data then return end
    local data = self.data.tgItems or {}
    if self.wildItemNode:isVisible()  and (#data > 0) then 
        if self:checkContainRect(touchPoint, self.wildItemWidget) then
            return true
        end
    end

    local allChild = self.ScroViewInfo:getChildren()
    for _,v in pairs(allChild) do
        
        if v:getTag() == 0100 then
            if self:checkContainRect(touchPoint, v.troopScrollView) then
                return true
            end
        end
    end

    return false
end

function UIMailBattlePanel:checkContainRect(touchPoint, widget)
    local point = widget:convertToNodeSpace(touchPoint)
    local rect = cc.rect(0,0, widget:getContentSize().width, widget:getContentSize().height)
    if cc.rectContainsPoint(rect,point) then
        return true
    else
        return false
    end
end

function UIMailBattlePanel:registerMoveAction()

    local nextPanel = global.panelMgr:getPanel("UIMailListPanel")

    local  listener = cc.EventListenerTouchOneByOne:create()
    local beginTime = 0
    local moveDelet = 0

    local function touchBegan(touch, event)

        -- 点击到士兵滚动区域，不响应事件
        if not self.data or self:isClickScroRect(touch:getLocation()) then 
            return
        end

        if self:getPositionX() ~= 0 then return false end
   
        nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))

        beginTime = global.dataMgr:getServerTime()

        nextPanel:stopAllActions()
        self.isStartMove = true
        moveDelet = 0

        return true  
    end

    local function touchMoved(touch, event)

        if not self.isStartMove then
            return
        end

        local diff = touch:getDelta()
        moveDelet = moveDelet + diff.x

        local isTouch = self.ScroViewInfo:isTouchEnabled()
        
        if isTouch == true then

            if math.abs(diff.x) / 1.5 > math.abs(diff.y) then

                self.ScroViewInfo:setTouchEnabled(false)
            else

                return
            end
        end

        local nextPanelX = nextPanel:getPositionX() + diff.x / 2
        local currentPosX = self:getPositionX() + diff.x
        
        if currentPosX > gdisplay.width then
            currentPosX = gdisplay.width
            self:setPosition(cc.p(currentPosX, 0))
            nextPanel:setPosition(cc.p(0 , 0))
            return
        end
        if (currentPosX+diff.x) >= 0 then
            self:setPosition(cc.p(currentPosX, 0))
            nextPanel:setPosition(cc.p(nextPanelX , 0))
        end
    end

    local function touchEnded(touch, event)

        if not self.isStartMove then

            return
        end

        self.ScroViewInfo:setTouchEnabled(true)

        local diff = touch:getDelta()
        local moveWidth = (touch:getLocation().x - touch:getStartLocation().x)*2

        local currentPosX = self:getPositionX() 
        log.debug(currentPosX)

        local contentTime = global.dataMgr:getServerTime()  - beginTime

        local speed = moveDelet / (contentTime)

        log.debug("speed is " .. speed .. " " .. moveDelet .. " " .. contentTime)

        if currentPosX >= gdisplay.width / 2 or speed > 1500 then
            
            self:exit_call()
        else

            local contentX = self:getPositionX()
            local time = contentX / gdisplay.width * 0.2
            self:runAction(cc.MoveTo:create(time,cc.p(0,0)))

            nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))
        end
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.touchNode)

    self.touchNode:setLocalZOrder(8)

    self.lis = listener
end

function UIMailBattlePanel:getInfoNode(data)
    
    if #self.infoCache > 0 then

        local ret = self.infoCache[1]
        ret:setVisible(true)
        table.remove(self.infoCache,1)
        return ret
    else
        local ret = nil
        -- 世界boss 防御方
        -- if self.data.tgFightReport and  self.data.tgFightReport.lFightType == 9 and data.lTroopID == 0 then
        --     ret = UIBattleBoss.new()
        -- else
            ret = UIBattleInfo.new()
        -- end
        self.ScroViewInfo:addChild(ret)
        -- ret:retain()        
        return ret
    end    
end

function UIMailBattlePanel:cleanInfoNode(node)
    
    node:setVisible(false)
    -- node:removeFromParent()
    table.insert(self.infoCache,node)
end

function UIMailBattlePanel:scrollEvent()
    
    if not self.data then return end
    -- node:addChild(tag)
    self.isStartMove = nil

    local topY = self.topOffsetNode:getPositionY()
    local offsetY = self.topOffsetNode:convertToWorldSpace(cc.p(0,0)).y    
    
    self.nodeList = self.nodeList or {}
    for _,v in pairs(self.nodeList) do
        
        local y = (v:getPositionY() - topY) + offsetY        

        if y > -200 and y < gdisplay.height + 200 then

            if v.item == nil then

                local item = self:getInfoNode(v.data)
                item:setTag(0100)
                item:setData(v.data,v.index)
                item:setPosition(v:getPosition())
                -- v:getP:addChild(item)            
                v.item = item

                print(">>>>>>>>item")
            end 
        else

            if v.item then

                self:cleanInfoNode(v.item)
                v.item = nil

                print(">>>>>>>>remove item")
            end
            -- v:setVisible(false)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMailBattlePanel:onEnter()
    self.isBattleMove=false
    self:initListenner()
end

function UIMailBattlePanel:initListenner()

    self.listener = cc.EventListenerCustom:create("WARDATA_FILEWRITE_SUCCESS",function() 
        print("------------------pullByPHP downData success ---------------------: ")
        local tgFightReport = global.mailData:getBattleFileData(self.szReportid)
        if tgFightReport and table.nums(tgFightReport) > 0 then
            mailData:updateDetailMail(self.mailData.mailID or 0,  tgFightReport or {})
            self.mailData.tgFightReport = tgFightReport
            if self.setInitData then
                self:setInitData(self.mailData)
            end
        else
            global.mailData:deleteLocalFile(self.szReportid)
            self.common_title.esc:setTouchEnabled(true)
            print(" -- current mail be deleted! -- ")
        end
    end)
   self.listener1=  cc.EventListenerCustom:create("WARDATA_DOWNLORD_ERROR",function() 
        global.mailData:deleteLocalFile(self.szReportid)
        self.common_title.esc:setTouchEnabled(true)
        global.tipsMgr:showWarning("Download Mail Error!")
    end)

    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self)

    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener1,self)

end 

-- 小战报协议拉取
function UIMailBattlePanel:pullBySocket(szReportid)

    global.chatApi:getBattleInfo(szReportid ,function(msg)
        print(" ----------------------- pullBySocket -------------------------: "..szReportid)
        msg.tagMail = msg.tagMail or {}
        if not msg.tagMail.lType then return end
        mailData:updateDetailMail(msg.tagMail.lID or 0,  msg.tagMail.tgFightReport or {})
        if self.setInitData then
            self:setInitData(msg.tagMail)
        end
    end, global.userData:getUserId(), 1)
end

-- 大战报php下载
function UIMailBattlePanel:pullByPHP(szReportid) 

    if global.mailData:CheckisExitsPlus(szReportid) then
        print("------------------ pullByPHP exitFile ---------------------")
        local tgFightReport = global.mailData:getBattleFileData(szReportid)
        if tgFightReport and table.nums(tgFightReport) > 0 then
            mailData:updateDetailMail(self.mailData.mailID or 0,  tgFightReport or {})
            self.mailData.tgFightReport = tgFightReport
            self:setInitData(self.mailData)
        else
            global.mailData:deleteLocalFile(self.szReportid)
            CCHgame:downloadWarData(global.mailData:getRequestUrl(szReportid), global.mailData:getFilePath(szReportid)) --如果存在垃圾战报删除之后,再拉取 一次
            print(" -- current mail be deleted! -- ")
        end
    else
        print("down Url: " .. global.mailData:getRequestUrl(szReportid))
        print("file Path: " .. global.mailData:getFilePath(szReportid))
        CCHgame:downloadWarData(global.mailData:getRequestUrl(szReportid), global.mailData:getFilePath(szReportid))
    end
end

function UIMailBattlePanel:showCollect()
    self.collectBtn:setVisible(true)
end

function UIMailBattlePanel:setData(data, isNeedMoveAction, isChatFunc, isNoShare)

    -- dump(data,'.adawdawdaw mail data')

    self.common_title.esc:setTouchEnabled(false)

    self.troopNode:removeAllChildren()
    self.mailData = data
    self.isNeedMoveAction = isNeedMoveAction
    self.isChatFunc = isChatFunc
    data.lBigFight = data.lBigFight or 1
    if (not data.isShortMail) then -- 如果战报errorcode是大战报的情况
       data.isShortMail = data.lBigFight == 1 and 0 or 1
    end
    self.ScroViewInfo:setVisible(false)
    self.sharePanel:setVisible(false)
    self.common_title.Button_1:setVisible(not isNoShare)
    self.collectBtn:setVisible(false)
    if (not data.tgFightReport) or (not data.tgFightReport.szReportid) then 
        self.common_title.esc:setTouchEnabled(true)
        return 
    end
    self.szReportid = data.tgFightReport.szReportid
    
    if data.isShortMail == 0 then

        if data.lBigFight == 0 then
            self:pullBySocket(data.tgFightReport.szReportid)
        elseif data.lBigFight == 1 then
            self:pullByPHP(data.tgFightReport.szReportid)
        end
    else
        self:setInitData(data)
    end

end

function UIMailBattlePanel:setInitData(data)

    self.common_title.esc:setTouchEnabled(true)


    self.ScroViewInfo:setVisible(true)
    self.data = data

    if  self.data.tgFightReport and  table.nums(self.data.tgFightReport) > 0 then 
        self:checkBattleMailType(self.data.tgFightReport)
        self:initInfo(self.data.tgFightReport)
    end

    self:scrollEvent()

    --　添加手势滑动
    if self.isNeedMoveAction then 
        if not self.lis then
            self:registerMoveAction()
        end
    else
        if self.lis then
            cc.Director:getInstance():getEventDispatcher():removeEventListener(self.lis)
            self.lis = nil
        end
    end

    self.attackNode.Node_1.text1_mlan_6:setString(luaCfg:get_local_string(10966))
    self.attackNode.Node_1.city:setString(luaCfg:get_local_string(10093))
    self.defenseNode.Node_1.text1_mlan_6:setString(luaCfg:get_local_string(10966))
    self.defenseNode.Node_1.city:setString(luaCfg:get_local_string(10094))

end

function UIMailBattlePanel:checkBattleMailType(data)
    
    local isBattleMail = true

    --　侦查战报
    if data.lPurpose and data.lPurpose == 3 then
        isBattleMail = false
    end

    self.plA_add:setVisible(false)
    self.plD_add:setVisible(false)
    self.winA:setVisible(false)
    self.winD:setVisible(false)
    self.leftDef1:setVisible(false)
    self.rightDef1:setVisible(false)
    self.wildItemNode:setVisible(false)
    self.resultResNode:setVisible(true)

    local titleMailId = 0
    local leftTypeId, troopScaleId = 0, 0
    local resTypeId, defenseId = 0, 0
    local cityTitleId = 0
    
    if isBattleMail then

        self.leftDef2:setPositionY(self.defY)
        self.rightDef2:setPositionY(self.defY)
        self.scaleNumA:setPositionX(self.aX)
        self.scaleNumD:setPositionX(self.dX)

        self.leftDef1:setVisible(true)
        self.rightDef1:setVisible(true)

        titleMailId = 10146
        leftTypeId, troopScaleId = 10153, 10159
        resTypeId, defenseId = 10154, 10155
        cityTitleId = 10093

    else

        self.leftDef2:setPositionY(self.defY+self.defH/2)
        self.rightDef2:setPositionY(self.defY+self.defH/2)
        self.scaleNumA:setPositionX(self.aX + 30)
        self.scaleNumD:setPositionX(self.dX + 30)

        titleMailId, leftTypeId = 10145, 10152
        troopScaleId = 10160
        cityTitleId  = 10158

        local ltype, findResult  = self:getOwnerType() 
        if ltype == 0 then -- 防御方
            resTypeId = 10184
            defenseId = 10185
        else               -- 攻击方
            resTypeId = 10156
            defenseId = 10157
        end
    end

    if data.lResult then
        if data.lResult == 1 then 
            self.winA:setVisible(true)
        else
            self.winD:setVisible(true)
        end
    end

    if self.data.lMailID and self.data.lMailID > 0 then
        local contentTitle = luaCfg:get_email_by(self.data.lMailID).mailContent
        self.textTitle:setString(contentTitle)
    end
    self.texTitleHead:setString(luaCfg:get_local_string(titleMailId))
    self.ranks_left:setString(luaCfg:get_local_string(leftTypeId))
    self.scaleA:setString(luaCfg:get_local_string(troopScaleId))
    self.scaleD:setString(luaCfg:get_local_string(troopScaleId))
    self.dateRes:setString(luaCfg:get_local_string(resTypeId))
    self.dateDefense:setString(luaCfg:get_local_string(defenseId))
    self.aTroopCity:setString(luaCfg:get_local_string(cityTitleId))

    -- 資源和野怪
    self.topH = self.toplayout:getContentSize().height
    local posY = self.posAttack:getPositionY()
    self.attackNode:setPositionY(posY)
    if data.lFightType and (data.lFightType == 3) or (data.lFightType == 2 and data.bPve)  then
        self.wildItemNode:setVisible(true)
        self.resultResNode:setVisible(false)
        self:setWildItemNode()
        self.attackNode:setPositionY(posY+self.topH-self.toplayout1:getContentSize().height)
        self.topH = self.toplayout1:getContentSize().height
    end


    if data.lFightType and (data.lFightType == 9)  then
        self.winA:setVisible(false)
        self.winD:setVisible(false)
        self.dTroopScale:setVisible(false)
        self.dTroopCombat:getParent():setVisible(false)
        self.defenseNode.Node_1.text1_mlan_6:setVisible(false)
    else
        self.dTroopCombat:getParent():setVisible(true)
        self.defenseNode.Node_1.text1_mlan_6:setVisible(true)
        self.dTroopScale:setVisible(true)
    end
end

function UIMailBattlePanel:setWildItemNode()

    local data = self.data.tgItems or {}

    -- 多人战斗掉落物品是否属于自己
    local userId = global.userData:getUserId()
    local  lWinnerUser = self.data.tgFightReport.lWinner or 0
    if lWinnerUser ~= userId and (not self.isChatFunc) then
        data = {}
    end
    for _ ,v in pairs(data) do
        v.tips_node = self.tips_node
    end 
    self.wildItemNode:setData(data)
end

function UIMailBattlePanel:initInfo(data)
     
    -- print(data.szDefName,'......')
    if data.szDefName and data.szDefName ~= "" then 

        if data.lFightType and data.lFightType ~= 1 then
            local rwData = mailData:getDataByType(data.lFightType, tonumber(data.szDefName))
            rwData = rwData or {}
            self.city:setString(rwData.name or "")
        else         
            self.city:setString(data.szDefName)
        end
    else
        self.city:setString("-") 
    end

    if self.data.tgFightReport then
        self.date:setString(mailData:getDataTime(self.data.tgFightReport.lTime))
    end

    -- 战斗攻击方玩家数据
    self.userDataA = {}
    self.userDataD = {}
    self:sortUserName()
    self:initUserInfo(self.userDataA, 1)
    self:initUserInfo(self.userDataD, 2)


    -- 显示隐藏机制
    self:successInfo()
    if data.lPurpose and data.lPurpose == 3 then
        self:checkMailState()
    end

    if data.tgAtkParty then

        local aTroopNum = data.tgAtkParty.lTotalTroop 
        self.scaleNumA:setString(global.funcGame:_formatBigNumber(aTroopNum, 1))
        self.aTroopScale:setString(global.funcGame:_formatBigNumber(aTroopNum, 1))
        self.aTroopCombat:setString(global.funcGame:_formatBigNumber(data.tgAtkParty.lPower or 0, 1))
    end

    if  data.tgDefParty then

        if self:checkUnLock(1) then

            local bTroopNum = data.tgDefParty.lTotalTroop 
            if data.lPurpose and data.lPurpose == 3 then
                local defTroop = self:getFindTroop(data.tgDefTroop)
                self.scaleNumD:setString(global.funcGame:_formatBigNumber(self:getTroopScale(defTroop), 1))
            else
                self.scaleNumD:setString(global.funcGame:_formatBigNumber(bTroopNum, 1))
            end 
            self.dTroopScale:setString(global.funcGame:_formatBigNumber(bTroopNum, 1))
            self.dTroopCombat:setString(global.funcGame:_formatBigNumber(data.tgDefParty.lPower or 0, 1))
        else
            self.scaleNumD:setString("?")
            self.dTroopScale:setString("?")
            self.dTroopCombat:setString("?")
        end
    end

    -- 军功值
    self:setExploitVal(data)
end

function UIMailBattlePanel:setExploitVal(data)

    local val = 0
    local userId = global.userData:getUserId()
    if data.tgAtkUser then
        for _,v in pairs(data.tgAtkUser) do
            if v.lUserID == userId then
                val = v.lExploit or 0
                break
            end
        end
    end
    if val == 0 and data.tgDefUser then
        for _,v in pairs(data.tgDefUser) do
            if v.lUserID == userId then
                val = v.lExploit or 0
                break
            end
        end
    end

    self.exploitVal:setString(val)
end

function UIMailBattlePanel:getTroopScale(data)
    
    local scaleNum = 0
    for _,v in pairs(data) do
        if v.lTroopID > 0 then
            local scale = 0
            scale = global.troopData:getTroopsScaleByData(v.tgSoldiers)
            scaleNum = scaleNum + scale
        end
    end
    return scaleNum
end

function UIMailBattlePanel:getMailFightType()
    if self.data then 
      return self.data.tgFightReport.lFightType
    end 
end

function UIMailBattlePanel:getDefName()
    return self.data.tgFightReport.szDefName
end

function UIMailBattlePanel:getBattlePurpose()
    return self.data.tgFightReport.lPurpose
end

function UIMailBattlePanel:getMailAllName()
    
    local str = ""
    local fightType = self:getMailFightType()
    if fightType and fightType ~= 1  then
        local rwData = mailData:getDataByType(fightType, tonumber(self.data.tgFightReport.szDefName))
        if rwData  then  -- protect 
            str = rwData.name or ""
        end 
    else         
        str = self.data.tgFightReport.szDefName
    end

    return str
end

function UIMailBattlePanel:getMailTagUser()
    
    return self.data.tgFightReport.tgDefUser or {}
end

function UIMailBattlePanel:getMailAtkUser()
    
    return self.data.tgFightReport.tgAtkUser 
end

function UIMailBattlePanel:initUserInfo( userDataTb, id)

    local userNum = (#userDataTb)
    local str = ""
    if id == 1 then 
        str = "plA"
        if userNum > 4 then self.plA_add:setVisible(true) end
    else
        str = "plD"
        if userNum > 4 then self.plD_add:setVisible(true) end
    end

    for i=1,4 do
        if userDataTb[i] then
            self[str..i]:setVisible(true)
            self[str..i]:setString(userDataTb[i].szName)
        else
            self[str..i]:setVisible(false)
        end 
    end

    -- 资源野地显示领主名字
    local data = self.data.tgFightReport
    if userNum == 0  and (data.lFightType == 2 or  data.lFightType == 3 or data.lFightType == 5  or data.lFightType == 7 or data.lFightType == 9 )  then
        self.plD1:setVisible(true)
        self.plD1:setString(self:getMailAllName()) 
    end

    -- 新手引导特殊战报处理
    if id == 1 and userNum == 0 then
        local moniData = luaCfg:get_wild_monster_by(3000013)
        self.plA1:setVisible(true)
        self.plA1:setString(moniData.name)
    end

end

function UIMailBattlePanel:sortTroop( data )
    
    local troop1 = {}
    local troop2 = {}
    local troopTotal = {}

    local troop1, troop2 = self:getFindTroop(data)

    for _,v in pairs(troop1) do
         table.insert(troopTotal, v)
    end
    for _,v in pairs(troop2) do
         table.insert(troopTotal, v)
    end
    
    return troopTotal
end

function UIMailBattlePanel:onExit()
    
    self.data = nil
    self.nodeList = self.nodeList or {}
    for _,v in ipairs(self.nodeList) do

        if v.item then

            v.item:removeFromParent()
        end

        if not tolua.isnull(v) then

            v:removeFromParent()
        end        
    end

    self.infoCache = self.infoCache or {}
    for _,v in ipairs(self.infoCache) do

        if not tolua.isnull(v) then

            v:removeFromParent()
        end        
    end

    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener1)
end

function UIMailBattlePanel:initTroop(data)
    
    self.troopNode:removeAllChildren()

    self.nodeList = {}
    self.infoCache = {}

    local datat = self:sortTroop(data.tgAtkTroop) or {}
    local datad = self:sortTroop(data.tgDefTroop) or {}

    local sH = self.troopLayout:getContentSize().height
    local nodeSH = self.adNodeLayout:getContentSize().height
    local contentSize = gdisplay.height -  self.titleLayout:getContentSize().height - 30

    -- 防御部队
    local dNum = 0 
    local temp = {}
    if datad then 
        
        if self:checkUnLock(4) then
            temp = self:checkBattle(datad)
            self:checkWildTroop(temp)
        else
            table.insert(temp, datad[1] or {})
        end

        -- 如果没有防御部队，则显示一支空的防御部队
        if table.nums(temp) == 0 then

            local emptyTroop = {}
            emptyTroop.lExp = 0
            emptyTroop.lHeroID = 0
            emptyTroop.lHerolv = 0
            emptyTroop.lPurpose = 1
            emptyTroop.lTroopID = -1
            emptyTroop.lUserID  = 4010596
            emptyTroop.szTroopName = "-"
            emptyTroop.tgSoldiers = {[1] = {lCount=1, lID=-1, lKilled=0, lSlv=0,},}
            table.insert(temp, emptyTroop)
        end

        dNum = self:getTableNum(temp)
    end

    -- 攻击部队
    local tNum = self:getTableNum(datat)
    if datat then

        local containerSize = sH*(tNum + dNum) + self.adNodeLayout:getContentSize().height + self.topH
        if contentSize > containerSize then
            containerSize = contentSize
        end
        self.ScroViewInfo:setContentSize(cc.size(gdisplay.width, contentSize)) 
        self.ScroViewInfo:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
        self.ScroViewInfo:setPosition(cc.p(0, 10))
        self.NodeTotal:setPositionY(containerSize-self.ScrollSH)
        self.topOffsetNode:setPositionY(containerSize)
        local py = containerSize - self.topH - sH + 30
        local i = 0
        for _,v in pairs(datat) do

            if v.tgSoldiers and (#v.tgSoldiers > 0) then

                local node = cc.Node:create()
                node:setPosition(cc.p(0, py - sH*i))                
                node.data = v
                node.index = 1
                self.troopNode:addChild(node)               
                table.insert(self.nodeList,node)
                i = i + 1
            end
        end
        self.defenseNode:setPositionY(py-sH*(tNum-1) - nodeSH/2)
    end

    if datad then 
        local j = 0
        local dy = self.defenseNode:getPositionY() - sH - nodeSH/2
        for _,v in pairs(temp) do

            if v.tgSoldiers and (#v.tgSoldiers > 0) then
      
                local node = cc.Node:create()
                node:setPosition(cc.p(0, dy - sH*j))
                node.data = v
                node.index = 2                    
                self.troopNode:addChild(node)
                table.insert(self.nodeList,node)
                j = j + 1
            end
        end
    end
           
    self.ScroViewInfo:jumpToTop()
    
end

-- 0 正常战斗  1防御(野地野怪防御反扑)  2 攻/防(野地野怪混合防御和反扑)
function UIMailBattlePanel:checkWildTroop(defTroop)
    
    self.troopParm = 0
    local atk, def = false, false
    local lfightType = self:getMailFightType()
    if lfightType == 2  or lfightType == 3 then
        for _,v in pairs(defTroop) do
            if v.lPurpose == 6 then      --反扑
                atk = true 
            elseif v.lPurpose == 10 then --防御
                def = true
            end
        end
    end

    if atk and def then
        self.troopParm = 2
        return 
    end

    if atk then
        self.troopParm = 1
    end
end

function UIMailBattlePanel:getTroopParm()
    return self.troopParm or 0
end

-- 城内城外战规则:

-- 自己是进攻方(自己攻击目的)
-- 攻城：可以看到防守方内城部队数据 
-- 其他指令只能看到外城部队

-- 自己是防御方 (整场战斗目的)
-- 攻城：可以看到防守方内城部队数据 
-- 其他指令只能看到外城部队

function UIMailBattlePanel:checkBattle(troop)

    local temp = {}
    local data = self.data.tgFightReport
    local ltype, findResult  = self:getOwnerType() 

    -- 只针对城堡战斗 
    if data.lFightType ~= 1 then
        return troop
    end
    -- 侦查
    if data.lPurpose == 3 then
        return troop
    end

    -- 过滤城内部队
    local checkCityTroop = function (troopData)      
        for _,v in pairs(troopData) do         
            if v.lPurpose ~= 6 then     -- 6 城内部队
                table.insert(temp, v)
            end
        end
    end

    if ltype == 0 then -- 防御方
       
        temp = troop

    else -- 进攻方
       
        local isAtkCity = false         -- 默认不是攻城       
        if data.tgAtkUser then
            for _,v in pairs(data.tgAtkUser) do
                if v.lPurpose == 1 then -- 1攻城类型
                    isAtkCity = true
                end
            end
        end

        if isAtkCity then
            temp = troop
        else
            checkCityTroop(troop)
        end
    end

    return temp

end

function UIMailBattlePanel:getTableNum(data)
    local totalNum = 0
    for _,v in pairs(data) do
        
        if v.tgSoldiers and (#v.tgSoldiers > 0) then
            totalNum = totalNum + 1
        end
    end
    return totalNum
end

function UIMailBattlePanel:checkMailState()
    
    -- ltype: 0 防御 1攻击   findResult: 0 未发现 1 被发现
    -- result: 1 成功 2 失败
    local data = self.data.tgFightReport
    local ltype, findResult  = self:getOwnerType()                   
    local result = data.lResult   

    -- 城防设施
    if self:checkUnLock(3) then
        self.cfA2:setString(data.tgTrap.lTrapCount)
        self.cfD2:setString(data.szBartizan.lTrapCount)
    else
        self.cfA2:setString("?")
        self.cfD2:setString("?")
    end

    if ltype == 1 then

        if findResult == 1 then
            if result == 1 then
                self:successInv()
            else
                self:failInv()
            end
        else
            self:successInv()
        end
    else
        self:setFindTroop(data)
    end

end

function UIMailBattlePanel:successInv()
    
    local data = self.data.tgFightReport
    if data.lRobRes then
        for k,v in pairs(data.lRobRes) do
            if k <= 4 then

                if self:checkUnLock(2) then
                    self["data"..k]:setString(v)
                else
                    self["data"..k]:setString("?")
                end
            end
        end
    end
end

function UIMailBattlePanel:failInv()
    
    local data = self.data.tgFightReport
    if data.lRobRes then
        for k,v in pairs(data.lRobRes) do
            if k <= 4 then

                if self:checkUnLock(2) then
                    self["data"..k]:setString("-")
                else
                    self["data"..k]:setString("?")
                end
            end
        end
    end

    if data.tgTrap then

        if self:checkUnLock(3) then
            self.cfA1:setString("-")
            self.cfA2:setString("-")
        else
            self.cfA1:setString("?")
            self.cfA2:setString("?")
        end
    end
    if data.szBartizan then

        if self:checkUnLock(3) then
            self.cfD1:setString("-")
            self.cfD2:setString("-")
        else
            self.cfD1:setString("?")
            self.cfD2:setString("?")
        end
    end

    self:setFindTroop(data)

end

function UIMailBattlePanel:setFindTroop(data)

    local atkTroop = self:getFindTroop(data.tgAtkTroop)
    local defTroop = self:getFindTroop(data.tgDefTroop)

    data.tgAtkTroop = {}
    data.tgDefTroop = {}

    data.tgAtkTroop = atkTroop
    data.tgDefTroop = defTroop

    self:initTroop(data)
end

function UIMailBattlePanel:getFindTroop( data )
    
    if not data then data = {} end
    local data1 = {}
    local data2 = {}
    for _,v in pairs(data) do
        
        if global.troopData:checkTroopTypeByData(v) then
            table.insert(data1, v)
        else
            table.insert(data2, v)
        end
    end
    return data1, data2
end

-- 如果是掠夺战报，只显示自己掠夺的资源
function UIMailBattlePanel:initResRob()

    local data = self.data.tgFightReport
    local ltype, findResult  = self:getOwnerType() 
    local purpose = data.lPurpose

    local initResRobData = function (data)
        if not data then return end
        for k,v in pairs(data) do
            if k <= 4 then
                -- 掠夺战报
                if purpose == 6 and (v > 0) then
                    if ltype == 0 then
                        self["data"..k]:setString("-"..v)
                    else
                        self["data"..k]:setString("+"..v)
                    end
                else
        
                    if self:checkUnLock(2) then
                        self["data"..k]:setString(v)
                    else
                        self["data"..k]:setString("?")
                    end
                end
            end
        end
    end

    if ltype == 0 then
        if data.lRobRes then
            initResRobData(data.lRobRes)
        end
    else -- 攻击方
        
        local robRes = {0,0,0,0}
        for _,v in pairs(data.tgAtkTroop) do
            if v.lUserID == global.userData:getUserId() then
                local robTemp = v.lRob
                if robTemp then
                    for i=1,4 do
                        if robTemp[i] then
                            robRes[i] = robRes[i] + robTemp[i]
                        end
                    end
                end
            end
        end
        initResRobData(robRes)
    end

end

function UIMailBattlePanel:successInfo()

    self:initResRob()
    if self.data and self.data.tgFightReport then 
        local data = self.data.tgFightReport
        if data.tgTrap then

            if self:checkUnLock(3) then

                self.cfA1:setString(data.tgTrap.lTrapCount)
                if data.tgTrap.lLosCount > 0 then
                    self.cfA2:setString("-"..data.tgTrap.lLosCount)
                else
                    self.cfA2:setString("0")
                end
            else
                self.cfA1:setString("?")
                self.cfA2:setString("?")
            end
        end
        if data.szBartizan then

            if self:checkUnLock(3) then

                self.cfD1:setString(data.szBartizan.lTrapCount)
                if data.szBartizan.lLosCount > 0 then
                    self.cfD2:setString("-"..data.szBartizan.lLosCount)
                else
                    self.cfD2:setString("0")
                end
            else
                self.cfD1:setString("?")
                self.cfD2:setString("?")
            end
        end

        self:initTroop(data)
    end 
end

function UIMailBattlePanel:getOwnerType()
    
    local data = self.data.tgFightReport

    local killCount, loseCount = 0, 0
    local ltype = 0
    local findResult = 0
    local userId = global.userData:getUserId()
    if data.tgAtkUser then
        for _,v in pairs(data.tgAtkUser) do
            if v.lUserID == userId then
                ltype = 1
            end
        end
    end

    if ltype == 1 then
        if data.tgDefParty then
            killCount = data.tgDefParty.lWoundCount
        end
        if data.tgAtkParty then
            loseCount = data.tgAtkParty.llosCount
        end
    else
        if data.tgDefParty then
            loseCount = data.tgDefParty.lWoundCount
        end
        if data.tgAtkParty then
            killCount = data.tgAtkParty.llosCount
        end
    end

    if loseCount > 0 then
        findResult = 1
    end

    return ltype, findResult
end

function UIMailBattlePanel:sortUserName()
    
    if self.data.tgFightReport.tgAtkUser then
        self:inertMUser(self.data.tgFightReport.tgAtkUser, 1) 
        self:inertOUser(self.data.tgFightReport.tgAtkUser, 1)
    end
    if self.data.tgFightReport.tgDefUser then
        self:inertMUser(self.data.tgFightReport.tgDefUser, 2)
        self:inertOUser(self.data.tgFightReport.tgDefUser, 2)
    end
end

function UIMailBattlePanel:inertMUser( userTb, id )
    
    -- dump(userTb,'init user')

    local userName = global.userData:getUserName()
    for _,v in pairs(userTb) do
        if v.szName == userName then
            if id == 1 then
                table.insert(self.userDataA, v) 
            else
                table.insert(self.userDataD, v) 
            end 
        end
    end
end

function UIMailBattlePanel:inertOUser( userTb, id )
   
    -- dump(userTb,'init user')

   local userName = global.userData:getUserName()
    for _,v in pairs(userTb) do

        if v.szName ~= userName then
            if id == 1 then
                table.insert(self.userDataA, v) 
            else
                table.insert(self.userDataD, v) 
            end 
        end
    end
end

function UIMailBattlePanel:getTroopMsg( troopId, userId, troopType )

    self.data =self.data or {} 

    local data = self.data.tgFightReport
    if troopType == 1 then -- 攻击部队
        
        if data.tgAtkUser then
            for _,v in pairs(data.tgAtkUser) do
                if v.lUserID == userId  then
                    return v
                end
            end
        end
    else                   -- 防御部队
        if data.tgDefUser then
            for _,v in pairs(data.tgDefUser) do
                if v.lUserID == userId  then
                    return v
                end
            end
        end
    end 
end

function UIMailBattlePanel:exit_call(sender, eventType)
    
    gevent:call(global.gameEvent.EV_ON_GUIDE_EXIT_MAIL)

    global.sactionMgr:closePanelForAction("UIMailBattlePanel", "UIMailListPanel")
    self:updateInit()
end

function UIMailBattlePanel:updateInit()
    local  panel = global.panelMgr:getPanel("UIMailListPanel")
    panel:initData()
end

-- 分享
function UIMailBattlePanel:shareHandler(sender, eventType)
    
    if not self.data then return end
    if not self.data.tgFightReport then return end
    local isVisi = self.sharePanel:isVisible()
    if not isVisi then
        self:showSharePanel()
    else
        self:hideSharePanel()
    end

end

function UIMailBattlePanel:showSharePanel()

    if self.sharePanel:isVisible() then return end
    
    uiMgr:addSceneModel(0.7)
    self.shareNode:setData(self.data.tgFightReport.szReportid, "UIMailBattlePanel")
    self.sharePanel:setVisible(true)
    local nodeTimeLine = resMgr:createTimeline("mail/mall_war_bg")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()

        self.sharePanel:setVisible(true)
    end)
    self:runAction(nodeTimeLine)

end

function UIMailBattlePanel:hideSharePanel()
    
    if not self.sharePanel:isVisible() then return end

    uiMgr:addSceneModel(0.7)
    local nodeTimeLine = resMgr:createTimeline("mail/mall_war_bg")
    nodeTimeLine:play("animation1", false)
    nodeTimeLine:setLastFrameCallFunc(function()
    
        self.sharePanel:setVisible(false)
    end)
    self:runAction(nodeTimeLine)

end

function UIMailBattlePanel:replay_click(sender, eventType)

    if not self.data then return end
    if not self.data.tgFightReport then return end

    local exitMailCall = function ()
        -- body
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener1)
    end

    if  self.data.lBigFight and self.data.lBigFight ~= 0  then 

        local panel =  global.panelMgr:openPanel("UIRePlayerPanel")
        panel:downlordData(tostring(self.data.tgFightReport.szReportid))
        exitMailCall()
    else 

        global.mailApi:checkFightReplay(tonumber(self.data.tgFightReport.szReportid),function(ret, msg)
            if ret.retcode == 1 then 
                global.tipsMgr:showWarning("VideotapeDeath")
                return
            end  
            local panel =  global.panelMgr:openPanel("UIRePlayerPanel")
            panel:setData(msg.lReplayData)
            exitMailCall()
        end)
    end 

end
function UIMailBattlePanel:checkUnLock(lType, troopType)

    -- 攻击部队
    if troopType and troopType == 1 then
        return true
    end

    -- 自己是侦查方侦查战报
    local data = self.data.tgFightReport
    local ltype, findResult  = self:getOwnerType() 
    if data.lPurpose == 3 and ltype == 1 then

        -- 侦查营建筑等级
        local curBuildLv = global.cityData:getBuildingById(12).serverData.lGrade
        local scoutTrigger = luaCfg:buildings_scout_mail()
        for i,v in pairs(scoutTrigger) do
            if curBuildLv >= v.buildingLv and v.unlockType == lType then
                return true
            end
        end
        return false
    else
        return true
    end
end

function UIMailBattlePanel:gpsTargetHandler(sender, eventType)
    
    local panel = global.panelMgr:getPanel("UIMailPanel")
    panel:setPosition(cc.p(0, 0))
  
    local data = self.data.tgFightReport
    dump(data, " ==>lTargetMapId: ")
    data.lTargetMapId = data.lTargetMapId or global.userData:getWorldCityID()
    global.funcGame:gpsWorldCity(data.lTargetMapId, nil, true)
end

function UIMailBattlePanel:collectMailHandler(sender, eventType)
    
    if not self.mailData then return end
    if not self.mailData.mailID then 
        self.mailData.mailID = self.mailData.lID or 0
    end 

    if global.mailData:IsCollect(self.mailData.mailID) then
        return global.tipsMgr:showWarning("CollectionMail02")
    end

    global.mailApi:actionMail({self.mailData.mailID}, 4, function(msg)

        global.mailData:addMailHold(self.mailData)
        global.tipsMgr:showWarning("CollectionMail01")
    end)

end
--CALLBACKS_FUNCS_END

return UIMailBattlePanel

--endregion
