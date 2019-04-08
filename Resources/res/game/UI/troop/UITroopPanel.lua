--region UITroopPanel.lua
--Author : yyt
--Date   : 2016/09/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UITroopItem = require("game.UI.troop.UITroopItem")
local UISoldierNode = require("game.UI.pandect.UISoldierNode")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UITroopPanel  = class("UITroopPanel", function() return gdisplay.newWidget() end )
function UITroopPanel:ctor()
    self:CreateUI()
end

function UITroopPanel:CreateUI()
    local root = resMgr:createWidget("troop/troops_bg_1")
    self:initUI(root)
end

function UITroopPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/troops_bg_1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.head_layout1 = self.root.head_layout1_export
    self.head_layout2 = self.root.head_layout2_export
    self.head_layout3 = self.root.head_layout3_export
    self.head_layout4 = self.root.head_layout4_export
    self.btn_detail = self.root.FileNode_1.btn_detail_export
    self.sort_btn = self.root.FileNode_1.sort_btn_export
    self.titleNode = self.root.titleNode_export
    self.troopItem_layout = self.root.troopItem_layout_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.Mode2 = self.root.Mode2_export
    self.select1 = self.root.Mode2_export.Button_1.select1_export
    self.select2 = self.root.Mode2_export.Button_2.select2_export
    self.select3 = self.root.Mode2_export.Button_3.select3_export
    self.select4 = self.root.Mode2_export.Button_4.select4_export
    self.select5 = self.root.Mode2_export.Button_5.select5_export
    self.troops_txt = self.root.troops_txt_export
    self.intro = self.root.troops_txt_export.intro_mlan_25_export

    uiMgr:addWidgetTouchHandler(self.btn_detail, function(sender, eventType) self:onDetailClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.sort_btn, function(sender, eventType) self:sort_call(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.FileNode_1.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self:registerTouchListener() 
    self.itemSwitch = {}

    self.curItemTag = 0
    self.BTN_FIRST =  true
    self.curTroops = {} -- 当前选中的部队   

    for i=1,5 do
        local btn = self.Mode2["Button_"..i]
        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType)
            global.troopData:setPageMode(sender:getTag())
            self:setData()
        end)
    end

end

--　断线重连刷新界面
function UITroopPanel:initEventListener()
    local refershCall = function(event, isNotify)

        if not global.guideMgr:isPlaying() then
            global.panelMgr:closePanel("UIPromptPanel",true)
            self:setData(isNotify)
        else
            global.troopData:refershSoldierData()
        end        
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,refershCall)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UITroopPanel:registerTouchListener()
  
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    local contentMoveX, contentMoveY = 0, 0

    local  listener = cc.EventListenerTouchOneByOne:create()
    local function touchBegan(touch, event)
       contentMoveX = 0
       contentMoveY = 0
       return true
    end
    local function touchMoved(touch, event)
       
       local diff = touch:getDelta()
       contentMoveX = contentMoveX + math.abs(diff.x)
       contentMoveY = contentMoveY + math.abs(diff.y)
    end
    local function touchEnded(touch, event)

        if contentMoveX > 15 or contentMoveY > 15 then
            self.isMove = true
        else
            self.isMove = false
        end
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
end

function UITroopPanel:onEnter()
    
    self.mode = 0
    self.ScrollView_1:jumpToTop()
    self:initEventListener()
    
    self:setData()
end

function UITroopPanel:setInputMode( mode )

    print(" --- function UITroopPanel:setInputMode( mode )",mode)

    self.mode = mode
    self:setData()
    return self
end

function UITroopPanel:isRevolt()
    
    print(" --- function UITroopPanel:isRevolt(  )",self.mode)
    return self.mode == 1
end

--  传送去除新建部队
function UITroopPanel:getTpGarr(data)
    local temp = {}
    for _,v in pairs(data) do
        if v.lID ~= 0 and v.lSrcType and v.lSrcType == 6 then
            table.insert(temp, v)
        end
    end
    return temp
end

-- 根据部队状态获取部队数据
function UITroopPanel:getTroopDataByState(data, curPage)

    local temp = {}

    if curPage == 4 then
        
        for _,v in pairs(data) do
            local stateOrder = v.lState == 10 or v.lState == 5
            if v.lID ~= 0 and stateOrder then
                table.insert(temp, v)
            end
        end
    elseif curPage == 5 then

        local soldier = global.soldierData:getSoldiers()
        for i,v in ipairs(soldier) do
            if v.lCount > 0 then
                table.insert(temp, v)
            end
        end
        if #temp > 0 then
            table.sort(temp, function(s1, s2) return s1.lID < s2.lID end) 
        end

    elseif curPage == 2 then

        for _,v in pairs(data) do
            local isFighting = v.lState ==11 or v.lState ==12 or v.lState ==1
            if v.lID ~= 0 and isFighting  then
                table.insert(temp, v)
            end
        end

    elseif curPage == 3 then

        for _,v in pairs(data) do
            if v.lID ~= 0 and v.lState ==6 then
                table.insert(temp, v)
            end
        end
    end

    return temp
end

function UITroopPanel:sortTroop(data)

    self.isEdit = false

    local troop_sort_str = cc.UserDefault:getInstance():getStringForKey('TROOP_SORT','')
    local sortList = string.split(troop_sort_str,'|')
    local sortData = {}

    for i,v in ipairs(sortList) do
        if tonumber(v) then
            sortData[tonumber(v)] = i
        end        
    end

    table.sort(data,function(a,b)
        -- local sortA = sortData[a]
        -- local sortB = sortData[b]
        -- if sortA and not sortB then
        --     return true
        -- elseif sortB and not sortA then
        --     return false
        -- elseif sortA and sortB then
        --     return sortA < sortB
        -- else
        --     return a.lID < b.lID
        -- end

        if a.lID == 0 then
            return false
        end

        if b.lID == 0 then
            return true
        end
        
        local sortA = sortData[a.lID]
        local sortB = sortData[b.lID]

        if sortA and not sortB then
            return true
        elseif sortB and not sortA then
            return false
        elseif sortA and sortB then
            return sortA < sortB
        else
            return a.lID < b.lID
        end
    end)
end

-- 获取当前分页部队数据
-- 1 全部 2 战斗中部队 3 城内部队 4 城外部队 5 空闲士兵
function UITroopPanel:getCurPageTroop()

    local curPage = global.troopData:getPageMode()
    curPage = curPage > 0 and curPage or 1
    local data = self:getTroopData()
    if curPage ~= 1 then
        data = self:getTroopDataByState(data, curPage)
    end
    return data
end

function UITroopPanel:refershSelect()
    for i=1,5 do
        self["select"..i]:setVisible(false)
        if i == global.troopData:getPageMode() then
            self["select"..i]:setVisible(true)
        end
    end

    self.sort_btn:setVisible(global.troopData:getPageMode() == 1)
end

function UITroopPanel:setData(isNotify)
    
    --　刷新item数据
    self.m_lastState = nil
    global.troopData:refershSoldierData()
    self:refershSelect()

    local data = self:getCurPageTroop()
    self.curTroops = {}

    if isNotify then

        self.BTN_FIRST =  true
        local childs = self.ScrollView_1:getChildren()
        for _,item in pairs(childs) do
            if not tolua.isnull(item) and item.jiantou and item.jiantou:isVisible() then
                self.TROOP_STATE = 1
                item:hideActionBack(item)
                item.itemClickEffect:setVisible(false)
                self.curItemTag = item.selectBg:getTag()
            end 
        end
    else
        self.ScrollView_1:removeAllChildren()
    end

    self.itemSwitch = {}
    self.Mode2:setVisible(false)
    self.troops_txt:setVisible(false)
    self.titleNode:setVisible(true)
    self.titleNode:setPositionY(gdisplay.height - 60)
    local contentSize = gdisplay.height -  self.head_layout1:getContentSize().height
    if global.troopData:getPageMode() ~= 0 then
        contentSize = gdisplay.height -  self.head_layout3:getContentSize().height
        self.titleNode:setPositionY(gdisplay.height - 135)
        self.Mode2:setVisible(true)
        -- 城外驻防模式
        if global.troopData:getPageMode() == 4 then
            self.troops_txt:setVisible(true)
            self.intro:setString(global.luaCfg:get_local_string(10969))
            contentSize = gdisplay.height -  self.head_layout2:getContentSize().height
        elseif global.troopData:getPageMode() == 5 then
            self.titleNode:setVisible(false)
            contentSize = gdisplay.height -  self.head_layout4:getContentSize().height
        end
    end

    if global.scMgr:isWorldScene() then
        local worldPanel = global.g_worldview.worldPanel
        local targetData = global.troopData:getTargetData() or {}
        local attackMode = targetData.attackMode or 0
        --大地图部队是管理界面进来的
        if attackMode == -1 then
        elseif attackMode == 8 then
            self.intro:setString(global.luaCfg:get_local_string(10970))
            self.troops_txt:setVisible(true)
        end
    end
      
    local sW = self.troopItem_layout:getContentSize().height 
    local containerSize = (#data)*(sW+3)
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, contentSize))
    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    local pY = containerSize - sW

    self.pY = pY
    self.sW = sW

    self:sortTroop(data)


    local i = 0
    for _,v in pairs(data) do

        local isExit = true
        local item = self.ScrollView_1:getChildByTag(i*10+1) 
        if global.troopData:getPageMode() == 5 then

            if not item then
                item = UISoldierNode.new()
                isExit = false
            end
            v.cdata = clone(v)
            item:setData(v)
        else 
            if not item then
                item = UITroopItem.new()
                isExit = false
            else
                item:initUIData()
            end
            if v.lID == 0 then
                item:setLastAdd(v)
                item.selectBg:setTag(40100)
                item.selectBg:setSwallowTouches(false)
                item.ItemBg:setZoomScale(0.04)
                item.ItemBg:setName("GUIDENEWTROOP")
            else
                item.ItemBg:setName("")
                item:setData(v)
                item.selectBg:setTag(30100+i)
                item.selectBg:setSwallowTouches(false)
                item.ItemBg:setZoomScale(0)
                local troopScale = global.troopData:getTroopsScaleById(v.lID)
                item:setDieState(troopScale == 0)
            end
            item.troop_operation:setVisible(false)
            item.ItemBg:setSwallowTouches(false)
            table.insert(self.itemSwitch, item)
        end
        item:setPosition(cc.p(0, pY - (sW+3)*i))
        item:setAnchorPoint(cc.p(0, 1))
        item:setTag(i*10+1)
        if not isExit then        
            self.ScrollView_1:addChild(item)
        end
        i = i + 1
    end
  

    self.ScrollView_1:setPositionY(contentSize)
    if global.troopData:getPageMode() == 4 then
        self.ScrollView_1:setPositionY(contentSize + self.troops_txt:getContentSize().height)
    end
    self.ScrollView_1:jumpToTop()

end

-- 直接出征
function UITroopPanel:outTroop(curTroop)
    
    for _,v in pairs(self.itemSwitch) do

        if v.data.lID == curTroop.lID then
            
            self.curTroops = curTroop
            v:outTroop()
        else
            v.itemClickEffect:setVisible(false)
        end
    end
end

function UITroopPanel:getTroopData()
    
    local data = {}
    local tempData = global.troopData:getTroopList()
    if global.scMgr:isWorldScene() then
        local worldPanel = global.g_worldview.worldPanel
        local targetData = global.troopData:getTargetData() or {}
        local attackMode = targetData.attackMode or 0
        --大地图部队是管理界面进来的
        if attackMode == -1 then
            data = self:getMOwnTroop(tempData)
        else
            data = self:getMTroop(tempData)

            if attackMode == 8 then
                data = self:getTpGarr(data)
            end
        end
    else
        
        local attackMode = 0
        if global.troopData:getTargetData() ~= nil then

            attackMode = global.troopData:getTargetData().attackMode
        end
        
        if attackMode == -1 then
            data = self:getMOwnTroop(tempData)
        else
            data = self:getMTroop(tempData)
        end
    end
    return data
end

--仅自己的部队
function UITroopPanel:getMTroop(tempData)
    
    local troopData = {}
    local userId = global.userData:getUserId()
    for _,v in pairs(tempData) do
        if v.lUserID == userId then
            table.insert(troopData, v)
        end
    end
    return troopData
end

--包含盟友的驻防部队
function UITroopPanel:getMOwnTroop(tempData)
    
    local troopData = {}
    local userId = global.userData:getUserId()
    for _,v in pairs(tempData) do
        if v.lUserID == userId then
            table.insert(troopData, v)
        elseif v.lTarget == global.userData:getWorldCityID() then
            table.insert(troopData, v)
        end
    end
    return troopData
end

function UITroopPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UITroopPanel")  
    if global.scMgr:SceneName() == "MainScene" and global.g_cityView then
        global.g_cityView:getSoldierMgr():refershSoldier()
    end
    global.troopData:setPageMode(1)
end

function UITroopPanel:onExit()
    global.troopData:resetTargetData()
    global.troopData:cleanTargetCombat()
    self:stopScroll()
    -- self.isEdit = false
end

function UITroopPanel:startScroll()
    
    if self.scheduleListenerId then
        return
    end

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
            
        self:scroll()
    end, 1 / 60)
end

function UITroopPanel:scroll(dt)
    local dir = self.dir
    if dir then
        local curOffset = self.ScrollView_1:getInnerContainerPosition()
        local height = self.ScrollView_1:getInnerContainerSize().height
        local sizeHeight = self.ScrollView_1:getContentSize().height
        curOffset.y = curOffset.y - dir

        if curOffset.y > 0 then
           curOffset.y = 0 
        elseif sizeHeight - curOffset.y > height then
           curOffset.y = -(height - sizeHeight)
        else
            self.sender:setPositionY(self.sender:getPositionY() + dir)
        end

        self.ScrollView_1:setInnerContainerPosition(curOffset)        

        self:checkListPos(nil,nil,true)
    end
end

function UITroopPanel:stopScroll()
    
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function UITroopPanel:saveTroopSort(children)

    local res = ''
    for i,v in ipairs(children) do        
        res = res .. (i == 1 and '' or '|') .. v.data.lID
    end

    cc.UserDefault:getInstance():setStringForKey('TROOP_SORT',res)
end

function UITroopPanel:checkListPos(movePos,sender,isCallBySelf)
    local preChildren = self.ScrollView_1:getChildren()
    local children = {}
    for _,v in pairs(preChildren) do
        if not v.isEditItem then
            table.insert(children,v)
        end
    end


    local sw = self.sW

    if movePos then    
        local curOffset = self.ScrollView_1:getInnerContainerPosition()        
        movePos = movePos + curOffset.y
        if movePos > gdisplay.height - 200 - sw then
            self.dir = (movePos - (gdisplay.height - 200 - sw)) / 7
            self.sender = sender
            self:startScroll()
        elseif movePos < 0 then
            self.dir = movePos / 7
            self.sender = sender
            self:startScroll()
        else
            self.dir = nil
        end
    else
        if not isCallBySelf then
            self:stopScroll()
        end        
    end

    table.sort(children,function(a,b)

        -- if a.isEditItem then
        --     return false
        -- end

        -- if b.isEditItem then
        --     return true
        -- end

        local aY = a.taskPos or a:getPositionY()
        local bY = b.taskPos or b:getPositionY()
        -- aY = aY - sw / 2
        -- bY = bY - sw / 2

        if a.isMove then
            
            if aY < bY then
                bY = bY - sw / 2
            else
                bY = bY + sw / 2
            end
            
            return aY > bY
        elseif b.isMove then

            if aY < bY then
                aY = aY + sw / 2
            else
                aY = aY - sw / 2
            end
            return aY > bY
        else
            
            return aY > bY
        end

        if a.isMove then
            aY = aY - sw / 2
        elseif b.isMove then
            bY = bY - sw / 2
        end

        return aY > bY
    end)

    for i,v in ipairs(children) do
        if not v.isMove then            
            local posY = self.pY - (self.sW + 3) * (i - 1)            
            local nowPosY = v:getPositionY()
            if posY ~= nowPosY then                
                if v.taskPos ~= posY then
                    v:stopAllActions()
                    v.taskPos = posY
                    v.selectBg:setTag(30100+ i - 1)
                    local action = cc.Sequence:create(cc.MoveTo:create(0.1,cc.p(v:getPositionX(),posY)),cc.CallFunc:create(function()
                        v.taskPos = nil
                    end))           
                    v:runAction(action)
                end            
            end
        end
    end

    if not movePos then
        if not isCallBySelf then
            self:saveTroopSort(children)
        end  
    end
end

function UITroopPanel:onDetailClickHandler(sender, eventType)
  
    global.panelMgr:openPanel("UISoldierRelation")
end

function UITroopPanel:sort_call(sender, eventType)

    self.isEdit = not self.isEdit

    local children = self.ScrollView_1:getChildren()
    for _,v in ipairs(children) do
        -- v.sort_btn:stopAllActions()
        if not v.isEditItem then
            v:readyForSort(self.isEdit)
        end        
    end
end

function UITroopPanel:selectAllHandler(sender, eventType)

end

function UITroopPanel:selectAllHandler(sender, eventType)

end

function UITroopPanel:selectAllHandler(sender, eventType)

end

function UITroopPanel:selectAllHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UITroopPanel

--endregion
