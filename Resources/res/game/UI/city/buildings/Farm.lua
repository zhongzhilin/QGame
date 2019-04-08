--region Farm.lua
--Author : wuwx
--Date   : 2016/08/10

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local dataMgr = global.dataMgr
local cityData = global.cityData
local stateEvent = global.stateEvent
local tipsMgr = global.tipsMgr
local cityApi = global.cityApi
local propData = global.propData

local BuildingItem = require("game.UI.city.widget.BuildingItem")
local Farm  = class("Farm", function() return BuildingItem.new() end )

function Farm:ctor()
    print("Farm:ctor()")

    self.m_clickCall = nil --call by BuildingItem.lua

    self.m_openFullEffect = true
end

function Farm:initStateMachine(initial_state)
    BuildingItem.initStateMachine(self, initial_state or stateEvent.BUILDING.STATE.OPERATE)
    self.fsm:addState({
        events = {
            -- {name = stateEvent.FARM.EVENT.NOHARVEST, from = {stateEvent.FARM.STATE.HARVEST,stateEvent.FARM.STATE.MAXHARVEST}, to = stateEvent.FARM.STATE.NOHARVEST},
            {name = stateEvent.FARM.EVENT.HARVEST, from = stateEvent.BUILDING.STATE.OPERATE, to = stateEvent.FARM.STATE.HARVEST},
            {name = stateEvent.FARM.EVENT.MAXHARVEST, from = {stateEvent.FARM.STATE.HARVEST,stateEvent.BUILDING.STATE.OPERATE}, to = stateEvent.FARM.STATE.MAXHARVEST},
        },
        callbacks = {
            -- ["onenter"..stateEvent.FARM.STATE.NOHARVEST] = function(event)
            --     self.m_stateCall = function() 
            --         print(event.name.."不能收获")
            --     end
            -- end,
            ["onenter"..stateEvent.FARM.STATE.HARVEST] = function(event)
                self.m_clickCall = function()
                    self:harvest()
                end

                if tolua.isnull(self.fullNode) then self:addResourceEffect() end
                if not self.m_noChangeTex then
                    self.m_noChangeTex = false
                    self.fullNode:setScale(0.3)
                    self.fullNode:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.4,1)))
                end
                self.fullNode.lig:setVisible(false)

                self.isCanHarvest = true

                self.fullNode.LoadingBar_1:setPercent(1)
                self.fullNode.LoadingBar_1.ep_l2_00000_1:setPositionX(0)
                self:countDownHandler()
            end,
            ["onenter"..stateEvent.FARM.STATE.MAXHARVEST] = function(event)
                self.m_clickCall = function()                     
                    self:harvest()
                end
                
                if tolua.isnull(self.fullNode) then self:addResourceEffect() end
                self.fullNode.lig:setVisible(true)

                self.isCanHarvest = true
                if self.m_countDownTimer then
                    gscheduler.unscheduleGlobal(self.m_countDownTimer)
                    self.m_countDownTimer = nil
                end
            end,
        }
    })
end

function Farm:onEnter()
    BuildingItem.onEnter(self)
end

function Farm:onExit()
    BuildingItem.onExit(self)
end

function Farm:setData(data,noChangeTex)
    self.m_noChangeTex = noChangeTex
    if not BuildingItem.setData(self,data,noChangeTex) then return end

    self:addEventListener(global.gameEvent.EV_ON_CITY_BUFF_UPDATE, function ()
        -- body
        self:addSpeedBuff()
    end) 

    if self.data.serverData.lStatus ~= WDEFINE.CITY.BUILD_STATE.BUILDED then
        return
    end

    local outputData = cityData:getOutputDataByTypeAndLv(data.buildingType,data.serverData.lGrade)
    self.m_outputData = outputData

    --加速数据获取
    self.m_buffTime = global.buffData:getBuffTimeBy(self.data.id)

    self:countDownHandler()
    self:addSpeedBuff()

    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
end 

function Farm:countDownHandler(dt)

    local outputData = self.m_outputData
    if not outputData then 
        return 
    end 
    self.m_totalProduce = outputData.totalProduce

    self.m_minSec = outputData.minMinute
    local perNumForS = outputData.perProduce/global.define.HOUR
    -- self.m_totalSecsToMaxOutput = outputData.totalProduce/outputData.perProduce*global.define.HOUR
    -- self.m_startSecsToMaxOutput = (outputData.totalProduce-self.data.serverData.lBdRes.lOutput)/outputData.perProduce*global.define.HOUR
    self.m_startServerTime = self.data.serverData.lBdRes.lInit

    local currServerTime = dataMgr:getServerTime()
    self.m_output = (currServerTime-self.m_startServerTime)*perNumForS
    --总时间-目前为止要到最大值需要的时间+到现在已经过去的时间
    -- self.m_outputTime = self.m_totalSecsToMaxOutput-self.m_startSecsToMaxOutput+(currServerTime-self.m_startServerTime)
    self.m_outputTime = (currServerTime-self.m_startServerTime)
 
    local per = self.m_output / self.m_totalProduce * 100

    if not tolua.isnull(self.fullNode) then
        self.fullNode.LoadingBar_1:setPercent(per)
        local partX = per * 70 / 100
        if partX > 70 then partX = 70 end
        
        self.fullNode.LoadingBar_1.ep_l2_00000_1:setPositionX(partX)
    end
    

    -- print("###############self.m_output="..self.m_output)
    -- print("###############self.m_outputTime="..self.m_outputTime)
    -- print("###############self.m_minSec="..self.m_minSec)

    --获取收获按钮上数量label
    self:checkHarvestBtnUpdate()
    self:updateAccelerateTime()

    local stepData = luaCfg:get_guide_stage_by(2)
    if global.userData:getGuideStep() == stepData.Key and self.data.id == stepData.data1 then
    
        if not self.fsm:isState(stateEvent.FARM.EVENT.HARVEST) then
            self.m_output = 999
            self:doEvent(stateEvent.FARM.EVENT.HARVEST)
        end
    else

        if self.m_output >= self.m_totalProduce then
            self:doEvent(stateEvent.FARM.EVENT.MAXHARVEST)
            return
        end

        if self.m_outputTime >= self.m_minSec then
            if not self.fsm:isState(stateEvent.FARM.EVENT.HARVEST) then
                self:doEvent(stateEvent.FARM.EVENT.HARVEST)
            end
        else
            if not self.fsm:isState(stateEvent.BUILDING.EVENT.OPERATE) then
                self:doEvent(stateEvent.BUILDING.EVENT.OPERATE)
            end
        end
    end    
end

function Farm:addSpeedBuff()
    if global.buffData:checkFarmSpeed(self.data.id) then
        if not self.speedNode then
            self.speedNode = resMgr:createCsbAction("effect/res_add_speed","animation0",true)
            self:addChild(self.speedNode,1)
        end
    else
        if self.speedNode then
            self.speedNode:removeFromParent()
            self.speedNode = nil
        end
    end
end

local numberColor = {
    
    [WCONST.PROP_INDEX.FOOD] = {r = 255,g = 255,b = 44},
    [WCONST.PROP_INDEX.GOLD] = {r = 255,g = 226,b = 62},
    [WCONST.PROP_INDEX.WOOD] = {r = 255,g = 163,b = 4},
    [WCONST.PROP_INDEX.STONE] = {r = 143,g = 222,b = 255},
}

function Farm:harvest(noShowNoResource)
            
    if self.m_output < 1 then
        if not noShowNoResource then
            tipsMgr:showWarning("NoResource")
        end
    else
        if not tolua.isnull(self.fullNode)  then
            self:addChild(resMgr:createCsbAction("effect/resource_achieve_click","animation0",false,true),1)
            self.fullNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.RemoveSelf:create())) 
        end

        local dataHandler = function(msg)
            -- body
            if not self.m_outputData then return end

            if not msg or not msg.lBdRes  then
                --Protect 
                return
            end 

            local soundKey = "ui_harvest_"..self.m_outputData.itemId
            gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)

            self.isCanHarvest = false

            local lOutput = msg.lBdRes.lOutput
            log.trace("#####Farm:harvest() server->lOutput=%s,m_output=%s",msg.lBdRes.lOutput,self.m_output)
            msg.lBdRes.lOutput = 0
            self.m_output = 0
            cityData:setBdResById(self.data.id,msg.lBdRes)
            self:resetData()

            self:playHarvestEffect()

            local number = ccui.TextAtlas:create(":"..math.floor(lOutput),"fonts/number_white.png",33,40,"0")
            self:addChild(number,998)

            number:setScale(0.7)
            number:setColor(numberColor[self.m_outputData.itemId])
            number:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.FadeOut:create(0.6)))
            number:runAction(cc.Sequence:create(cc.EaseIn:create(cc.MoveBy:create(1.2,cc.p(0,150)),1),cc.RemoveSelf:create()))
        end
        cityApi:buildHarvest(self.data.serverData.lBuildID,function(msg)
            -- body
            -- gevent:call(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE_ACTION)
            dataHandler(msg)
        end,function(ret,msg)
                if ret.retcode == 50 then
                    --资源满了之后的处理
                    dataHandler(msg)
                end
            end
        )
    end
    
end

local fullCsd = {
    
    [WCONST.PROP_INDEX.FOOD] = "effect/resource_food_achieve_full",
    [WCONST.PROP_INDEX.GOLD] = "effect/resource_coin_achieve_full",
    [WCONST.PROP_INDEX.STONE] = "effect/resource_stone_achieve_full",
    [WCONST.PROP_INDEX.WOOD] = "effect/resource_wood_achieve_full",
}


local linePath = {
    
    [WCONST.PROP_INDEX.FOOD] = "map/foodLine.png",
    [WCONST.PROP_INDEX.GOLD] = "map/coinLine.png",
    [WCONST.PROP_INDEX.STONE] = "map/stoneLine.png",
    [WCONST.PROP_INDEX.WOOD] = "map/woodLine.png",
}

function Farm:addResourceEffect()

    if not self.m_openFullEffect then
        return
    end

    if self.fsm:isState(stateEvent.FARM.STATE.MAXHARVEST) or self.fsm:isState(stateEvent.FARM.STATE.HARVEST) then
    else
        self.m_openFullEffect=false
    end
    if not tolua.isnull(self.fullNode)  then
        self.fullNode:removeFromParent()
    end
    self.fullNode = resMgr:createCsbAction(fullCsd[self.m_outputData.itemId],"animation0",true)    
    self.fullNode:setPosition(cc.p(0,0))
    self:addChild(self.fullNode)


    self.fullNode.get_bg:setName("build_farm_" .. self.data.id)    

    -- self.fullNode.setVisible = function(state)
        
    --     log.debug(debug.traceback())
    -- end
end

function Farm:playHarvestEffect()

    self:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        local sp = cc.Sprite:create()
        sp:setSpriteFrame(self.m_outputData.icon)
        sp:setPosition(self:convertToWorldSpace(cc.p(0,0)))
        -- global.scMgr:CurScene():addChild(sp, 31)
        global.panelMgr:addWidgetToPanelDown(sp)

        local endY = gdisplay.height - 133 - (self.m_outputData.itemId - 1) * 46

        local bezier = {}
        bezier[1] = cc.p(200 - math.random(100),endY + 50 - math.random(100))
        bezier[2] = cc.p(400 - math.random(200),endY + 150 - math.random(300))
        bezier[3] = cc.p(680,endY)

        sp:runAction(cc.BezierTo:create(0.6,bezier))
        sp:setScale(0)
        sp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1),cc.ScaleTo:create(0.3,0),cc.RemoveSelf:create()))

        local mms = cc.MotionStreak:create(0.5, 0.1, 7, cc.c3b(255,255,255),linePath[self.m_outputData.itemId])
        mms:setFastMode(true)
        -- global.scMgr:CurScene():addChild(mms, 31)
        global.panelMgr:addWidgetToPanelDown(mms)

        mms:setPosition(sp:getPosition())
        mms:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

        mms:runAction(cc.BezierTo:create(0.6,bezier))
    end),cc.DelayTime:create(0.1)),4))
end

--overwrite  BuildingItem:getTouchRect():to add check rect!
function Farm:getTouchRect(noMultiRect)
    local buildingRect = BuildingItem.getTouchRect(self)
    if noMultiRect then return buildingRect end
    if self.fsm and (self.fsm:isState(stateEvent.FARM.STATE.MAXHARVEST) or self.fsm:isState(stateEvent.FARM.STATE.HARVEST)) then
        local iconRect = cc.rect(-65,65,100,100)
        local pos = cc.p(0,0)
        iconRect.x = buildingRect.x+buildingRect.width*0.5+pos.x+iconRect.x
        iconRect.y = buildingRect.y+buildingRect.height*0.5+pos.y+iconRect.y
        local rects = {buildingRect,iconRect}
        return rects
    else
        return buildingRect
    end
end

function Farm:checkResTouched(touchPos)
    local scrollPos = self:getParent():convertToNodeSpace(touchPos)

    local isIn = self:checkRectContainsPoint(self:getResTouchRect(), scrollPos)
    return isIn
end

function Farm:getResTouchRect()
    local buildingRect = self:getTouchRect()
    return buildingRect
end


--每秒收获操作按钮状态
function Farm:checkHarvestBtnUpdate()
    if self:isSelected() then
        local m_operateNode = global.g_cityView:getOperateMgr()
        if not m_operateNode or tolua.isnull(m_operateNode) then return end
        local txt_node = m_operateNode:getBtnTxtNodeById(4)
        if txt_node then 
            local btn = txt_node:getParent()
            local label = txt_node.time
            if self.m_output < 1 then
                if btn:isTouchEnabled() then
                    btn:setTouchEnabled(false)
                    global.colorUtils.turnGray(btn, true)
                end
                txt_node:setVisible(false)
                label:setString("")
            else
                txt_node:setVisible(true)
                if not btn:isTouchEnabled() then
                    btn:setTouchEnabled(true)
                    global.colorUtils.turnGray(btn, false)
                end
                label:setString(self:getShowOutput()) 
            end
        end
    end
end

function Farm:getShowOutput()
    if not self.m_buffTime then
        self.m_buffTime = global.buffData:getBuffTimeBy(self.data.id)
    end
    if not self.m_buffTime.lStartTime then
        --没有加速buff
        return math.floor(self.m_output)
    end
    local plus = self.m_buffTime.lParam or 0
    local dt = self.m_buffTime.lStartTime-self.m_startServerTime
    if dt <= 0 then
        return math.floor(self.m_output*(1+plus/100))
    else
        local currServerTime = global.dataMgr:getServerTime()
        local per = (currServerTime-self.m_buffTime.lStartTime)/(currServerTime-self.m_startServerTime)
        return math.floor(self.m_output*(1+plus/100*per))
    end
end

--资源生产加速道具使用
function Farm:accelerate()
    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 资源加速道具

    local function leftTimeAndTotalTime()
        self.m_buffTime = global.buffData:getBuffTimeBy(self.data.id)
    end
    panel:setData(leftTimeAndTotalTime, 0, panel.TYPE_RES_SPEED, self.data.id)
end

--操作界面上资源加速按钮的时间
function Farm:updateAccelerateTime()
    if self:isSelected() then
        local m_operateNode = global.g_cityView:getOperateMgr()
        if not m_operateNode or tolua.isnull(m_operateNode) then return end
        local txt_node = m_operateNode:getBtnTxtNodeById(5)
        if txt_node then
            local btn = txt_node:getParent()
            local label = txt_node.time
            local buffTime = self.m_buffTime
            if buffTime and buffTime.lStartTime then
                local m_restTime = buffTime.lEndTime-global.dataMgr:getServerTime()
                local m_totalTime = buffTime.lStartTime-buffTime.lEndTime

                label:setString(global.funcGame.formatTimeToHMS(m_restTime))
                if m_restTime <= 0 then
                    txt_node:setVisible(false)
                else
                    txt_node:setVisible(true)
                end
            end
        end
    end
end


function Farm:canHarvest()
    return self.isCanHarvest
end

return Farm

--endregion
