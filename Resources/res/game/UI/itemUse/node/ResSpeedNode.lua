local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local ResSpeedNode  = class("ResSpeedNode", function() return gdisplay.newWidget() end )

function ResSpeedNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function ResSpeedNode:initUI(callFunc)

	local buffTime = global.buffData:getBuffTimeBy(self.panel.buildingId)

    self.panel.text:setString(luaCfg:get_local_string(10049))

    self.itemUseCall = callFunc
    self.panel.queueUnlock_node:setVisible(true)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10042))
    self.panel.timeline_node:setVisible(false)
    self.panel.txt_Title:setString(luaCfg:get_local_string(10037))

    if buffTime.lStartTime then
        self.panel.restTime_node:setVisible(true)
        self.m_restTime = buffTime.lEndTime-global.dataMgr:getServerTime()
        self.m_totalTime = buffTime.lStartTime-buffTime.lEndTime
        local countFunc = function(dt)
            self.m_restTime = self.m_restTime - 1

            self.panel.leftTime:setString(funcGame.formatTimeToHMS(self.m_restTime))
            if self.m_restTime <= 0 then

                if self.m_countDownTimer_res then
                    gscheduler.unscheduleGlobal(self.m_countDownTimer_res)
                    self.m_countDownTimer_res = nil
                end
                self.panel.leftTime:setString("00:00:00")
                --资源加速失效
                self.panel:exit()
                return
            end
            global.tools:adjustNodePos(self.panel.leftTime, self.panel.text)
        end
        if not self.m_countDownTimer_res then
            self.m_countDownTimer_res = gscheduler.scheduleGlobal(countFunc, 1)
        end
        countFunc()
    else
        self.panel.restTime_node:setVisible(false)
    end
    
end

function ResSpeedNode:setItemData(data)

    local spaceStr = self.panel.spaceNum:getString()
    if data.itemId == 6 then

    	local buildingData = global.cityData:getBuildingById(self.panel.buildingId)
        local resourceId = global.cityData:getBuildingsInfoId(buildingData.buildingType,buildingData.serverData.lGrade)
        local resourceData = luaCfg:get_buildings_resource_by(resourceId)
        self.panel.need:setString(resourceData.resUpCost)
        self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10038), resourceData.resUpTime/60) .. "?")
        self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
        global.tools:adjustNodePos(self.panel.textHead, self.panel.need)
    else
        local itemCount = normalItemData:getItemById(data.itemId).count
        if itemCount <= 0 then
            self.panel:itemCountNotEnough(spaceStr, data.itemName)
        else
            self.panel.btnUse:setEnabled(true)
            local maxCount = itemCount
            self.panel.sliderControl:setMaxCount(maxCount)
            if maxCount == 1 then
                self.panel.sliderControl:reSetMaxCount(1)
            end

            self.panel.speedUseText:setString(luaCfg:get_local_string(10030))
            local restTime = data.typePara1*60
            self.panel.speedTime:setString(funcGame.formatTimeToHMS(restTime))
            global.tools:adjustNodePos(self.panel.speedUseText, self.panel.speedTime)
        end
    end
end

function ResSpeedNode:resAccelerate()
    
    local buildingData = global.cityData:getBuildingById(self.panel.buildingId)
    local resourceId = global.cityData:getBuildingsInfoId(buildingData.buildingType,buildingData.serverData.lGrade)
    local resourceData = luaCfg:get_buildings_resource_by(resourceId)

    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    local number = tonumber(self.panel.cur:getString())

    self.panel.topModel:setVisible(false)
    if item.data.itemId == 6 then
        if self.panel:checkDiamondEnough(resourceData.resUpCost) then
            global.itemApi:diamondUse(function(msg)
                global.tipsMgr:showWarning(buildingData.buildsName..luaCfg:get_local_string(10683))
                self.panel:exit()
                if self.itemUseCall then self.itemUseCall() end
            end,4,0,self.panel.buildingId)
        end
    else
        global.itemApi:itemUse(item.data.itemId, number, 0, self.panel.buildingId, function(msg)
            global.tipsMgr:showWarning(buildingData.buildsName..luaCfg:get_local_string(10683))
            self.panel:exit()
            if self.itemUseCall then self.itemUseCall() end
        end)
    end
end

function ResSpeedNode:onExit()
    
    if self.m_countDownTimer_res then
        gscheduler.unscheduleGlobal(self.m_countDownTimer_res)
        self.m_countDownTimer_res = nil
    end
end

return ResSpeedNode
	