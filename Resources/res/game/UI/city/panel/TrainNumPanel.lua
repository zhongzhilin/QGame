--region TrainNumPanel.lua
--Author : wuwx
--Date   : 2016/08/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg
local userData = global.userData
local propData = global.propData
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local TrainNumPanel  = class("TrainNumPanel", function() return gdisplay.newWidget() end )
local CountSliderControl = require("game.UI.common.UICountSliderControl")

function TrainNumPanel:ctor()
    self:CreateUI()
end

function TrainNumPanel:CreateUI()
    local root = resMgr:createWidget("train/train_second_training")
    self:initUI(root)
end

function TrainNumPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_second_training")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.soldier_name = self.root.Node_export.title.soldier_name_export
    self.portrait_view = self.root.Node_export.portrait_view_export
    self.picBg = self.root.Node_export.portrait_view_export.picBg_export
    self.portrait_node = self.root.Node_export.portrait_view_export.portrait_node_export
    self.curr_capactity = self.root.Node_export.curr_capactity_export
    self.manpower = self.root.Node_export.manpower_mlan_5_export
    self.popu_num = self.root.Node_export.popu_num_export
    self.soldier_des = self.root.Node_export.soldier_des_export
    self.gold_num = self.root.Node_export.gold_num_export
    self.wood_num = self.root.Node_export.wood_num_export
    self.food_num = self.root.Node_export.food_num_export
    self.stone_num = self.root.Node_export.stone_num_export
    self.capactity = self.root.Node_export.capactity_export
    self.capacity_num = self.root.Node_export.capacity_num_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.btn_cost = self.root.Node_export.btn_cost_export
    self.grayBg1 = self.root.Node_export.btn_cost_export.grayBg1_export
    self.num = self.root.Node_export.btn_cost_export.num_export
    self.btn_train = self.root.Node_export.btn_train_export
    self.grayBg2 = self.root.Node_export.btn_train_export.grayBg2_export
    self.time = self.root.Node_export.btn_train_export.time_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_cost, function(sender, eventType) self:onCostHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_train, function(sender, eventType) self:onTrainHandler(sender, eventType) end)
--EXPORT_NODE_END

    global.funcGame:initBigNumber(self.food_num, 1)
    global.funcGame:initBigNumber(self.wood_num, 1)
    global.funcGame:initBigNumber(self.gold_num, 1)
    global.funcGame:initBigNumber(self.stone_num, 1)

    self.slider.cur = self.cur
    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.sliderUpdate), true)


    self.m_totalTime = 0
    self.m_totalPop = 0
    self.m_totalRes = {}
end

function TrainNumPanel:setData(data,buildingId)
    self.m_buildingId = buildingId
    self.data = data or {}

    self.m_accEffect = {}
    self.m_accEffect[2] = {value = 0, per = 0}
    self.m_accEffect[4] = {value = 0, per = 1}
    self.m_accEffect[6] = {value = 0, per = 1}

    local soldierPro = luaCfg:get_soldier_property_by(self.data.id)
    local upperBound = userData:getUsefulPopulation()

    self.portrait_view:setSpriteFrame("ui_surface_icon/train_soldier_s_bg"..self.data.skill..".png")
    global.tools:setSoldierAvatar(self.portrait_node,self.data)

    local effectReqData = {}
    if self.data.type == 7 then
        --城墙兵种单独处理
        soldierPro = luaCfg:get_def_device_by(self.data.type*10+self.data.skill)
        upperBound = userData:getUsefulDefPop()
        self.m_singleCostPop = soldierPro.space
        self.capactity:setSpriteFrame("ui_surface_icon/mainui_wallspace_icon.png")
        self.curr_capactity:setSpriteFrame("ui_surface_icon/mainui_wallspace_icon.png")
        self.manpower:setString(luaCfg:get_local_string(10069))
        effectReqData = {{lType = 4,lBind = self.data.id}}
    else
        self.m_singleCostPop = soldierPro.perPop
        self.capactity:setSpriteFrame("ui_surface_icon/mainui_man_icon.png")
        self.curr_capactity:setSpriteFrame("ui_surface_icon/mainui_man_icon.png")
        self.manpower:setString(luaCfg:get_local_string(10068))

        effectReqData = {{lType = 2,lBind = self.data.id},{lType = 6,lBind = self.data.id}}
    end

    self.popu_num:setString(upperBound) 
    self.soldier_des:setString(soldierPro.info)
    self.soldier_name:setString(soldierPro.name)

    --是否在引导
    local stepData = luaCfg:get_guide_stage_by(1)
    local curStep = global.userData:getGuideStep()
    local stepGuide = global.guideMgr:getCurStep()

    -- print( " ==========> curStep:" .. curStep)
    -- print( " ==========> stepGuide:" .. stepGuide)

    if stepGuide == stepData.Key or stepGuide == 40007 then
    else

        -- 兵种buff
        global.gmApi:effectBuffer(effectReqData, function (msg)
            -- dump(msg)
            msg = msg or {}
            if not self.m_accEffect then return end
            msg.tgEffect = msg.tgEffect or {}
            for _,v in pairs(msg.tgEffect) do
                if v.lType == 2 then
                    self.m_accEffect[v.lType] = self.m_accEffect[v.lType] or {value = 0, per = 0}
                else
                    self.m_accEffect[v.lType] = self.m_accEffect[v.lType] or {value = 0, per = 1}
                end

                for _,vv in pairs(v.tgEffect or {}) do
                    local dataTypeItem = luaCfg:get_data_type_by(vv.lEffectID)
                    if dataTypeItem then 

                        if v.lType == 6 then
                            -- 兵源训练上限
                            if dataTypeItem.extra == "%" then
                                self.m_accEffect[v.lType].per = (1-vv.lVal/100)*self.m_accEffect[v.lType].per
                            else
                                self.m_accEffect[v.lType].value = self.m_accEffect[v.lType].value+vv.lVal
                            end
                        elseif v.lType == 2 then
                            -- 训练时间buff
                            self.m_accEffect[v.lType].per = math.floor(100-(100-self.m_accEffect[v.lType].per)*(100-vv.lVal)/100)
                        elseif v.lType == 4 and dataTypeItem.typeId == 3047 then
                            -- 城防训练加速
                            self.m_accEffect[v.lType].per = math.floor(100-(100-self.m_accEffect[v.lType].per)*(100-vv.lVal)/100)
                        end

                    end
                end
            end
            if self.getTrainBaseNum then
                self:sliderChange(self:getTrainBaseNum(), true)
            end
        end)

        -- 训练上限
        global.gmApi:effectBuffer({{lType = luaCfg:get_buildings_pos_by(buildingId).funcType,lBind = buildingId}},function(msg)
            
            if not self.getTrainBaseNum then return end
            msg = msg or {}
            msg.tgEffect = msg.tgEffect or {}
            local curVal, curBuffsId = self:getTrainBaseNum()
            local buffData = msg.tgEffect[1] or {}
            local buffs = buffData.tgEffect  or {}
            local allAdd = 0
            for _,v in pairs(buffs) do
                if v.lEffectID and v.lEffectID == curBuffsId then
                    local buff_conf = luaCfg:get_data_type_by(v.lEffectID)   
                    if buff_conf then
                        allAdd = math.floor(allAdd+v.lVal)                  
                    end
                end
            end
            
            -- 针对建筑全开(上限buff不存在) 做的特殊处理
            if allAdd == 0 then 
                allAdd = allAdd + curVal
            end
            self:sliderChange(allAdd, true)

        end)

    end

    self:sliderChange(self:getTrainBaseNum())

    local raceData = global.luaCfg:get_race_by(global.userData:getRace())
    global.panelMgr:setTextureFor(self.picBg, raceData.soldierTrainBg)

    self.manpower:setPositionX(self.popu_num:getPositionX()-self.popu_num:getContentSize().width-10)
    self.curr_capactity:setPositionX(self.manpower:getPositionX()-self.manpower:getContentSize().width)    

end

-- 获取基础单兵训练数量
function TrainNumPanel:getTrainBaseNum()
    -- body
    local building = global.cityData:getBuildingById(self.m_buildingId)
    local infoId = global.cityData:getBuildingsInfoId(building.buildingType,building.serverData.lGrade)
    local infos = luaCfg:get_buildings_lvup_by(infoId)    
    if not infos then return 0,0 end
    local parm = infos.extraPara2 
    local buffsId = infos.extraDataType2
    if parm == 0 then
        parm = infos.extraPara1
        buffsId = infos.extraDataType1
    end
    
    return parm,  buffsId
end

function TrainNumPanel:sliderChange(maxTrainNum, skipInputChange)

    --是否在引导
    local stepData = luaCfg:get_guide_stage_by(1)
    if global.userData:getGuideStep() == stepData.Key then
        local stepMax = 300     -- 引导训练值
        self.sliderControl:setMaxCount(stepMax)
        self.sliderControl:chooseAll()
        self:sliderUpdate()
    else
        self.maxTrainNum = maxTrainNum
        self:refersh(skipInputChange)
    end
        
end

function TrainNumPanel:refersh(skipInputChange)
    -- body

    local maxNum = self:getMaxSource()
    if self.maxTrainNum and self.data.type ~= 7 then
        -- maxNum = maxNum > self.maxTrainNum and  self.maxTrainNum or maxNum
        maxNum = self.maxTrainNum
    else 
        maxNum = maxNum
    end 

    if maxNum <= 0 then maxNum = 1  end 

    if  false then
    -- if maxNum <= 0 then
        self.sliderControl:setMaxCount(1)
        self.sliderControl:reSetMaxCount(1)
    else
        local curCount = self.sliderControl:getContentCount()
        self.sliderControl:setMaxCount(maxNum , skipInputChange)
        self.sliderControl:changeCount(curCount or 1, skipInputChange)
    end
    self:sliderUpdate()

end

function TrainNumPanel:onExit()
    self.sliderControl:changeCount(1)
end

function TrainNumPanel:onCloseHandler(sender, eventType)
    panelMgr:closePanelForBtn("TrainNumPanel")
end

function TrainNumPanel:setCallBack(callback)
    self.m_callback = callback
end

-- 获取最大兵源数
function TrainNumPanel:getMaxSource()

    local building = global.cityData:getBuildingById(self.m_buildingId)
    local isfull,class,nextClass = global.soldierData:getSoldierClassBy(building.serverData.lGrade)
    local lvupData = luaCfg:get_soldier_lvup_by(class+1)
    
    local rCan = {}
    for k,v in ipairs(self.data.perCost) do
        local id, num = v[1], v[2]
        local name = WCONST.ITEM.NAME[id]
        if name then
            
            if id <= 4 then
                num = math.ceil(num*(100+lvupData.upPro)/100)
            end
            local mHave = propData:getProp(id)
            local cutNum = math.ceil(mHave*self.m_accEffect[6].per)-self.m_accEffect[6].value
            cutNum = math.floorMin(cutNum)

            -- 资源总量加入buff之后计算
            mHave = mHave*2 - cutNum
            local canNum = math.floor(mHave/num)
            table.insert(rCan, canNum)
        end
    end

    table.sort(rCan, function(s1, s2) return s1 < s2 end)
    local curCostPop = 0
    if self.m_singleCostPop > 0 then

        curCostPop = math.floor(userData:getUsefulPopulation() / self.m_singleCostPop)
        if self.data.type == 7 then
            curCostPop = math.floor(userData:getUsefulDefPop() / self.m_singleCostPop)
        end
    end

    if rCan[1] < curCostPop or (self.m_singleCostPop == 0) then
        curCostPop = rCan[1]
    end
    return curCostPop
    
end

function TrainNumPanel:sliderUpdate()
    local currNum = self.sliderControl:getContentCount()
    if currNum == 0 then currNum = 1 end

    self.m_totalPop = self.m_singleCostPop*currNum
    self.capacity_num:setString(self.m_totalPop)

    local building = global.cityData:getBuildingById(self.m_buildingId)
    local isfull,class,nextClass = global.soldierData:getSoldierClassBy(building.serverData.lGrade)
    local lvupData = luaCfg:get_soldier_lvup_by(class+1)
    for id,name in ipairs(WCONST.ITEM.NAME) do
        local textNode = self[name.."_num"]
        if textNode then
            textNode:setString(0)
            self.m_totalRes[id] = num
        end
    end

    local isResEnougth = true
    for k,v in ipairs(self.data.perCost) do
        local id = v[1]
        local num = v[2]*currNum
        local name = WCONST.ITEM.NAME[id]
        if name then
            local textNode = self[name.."_num"]     
            num = math.ceil(num*self.m_accEffect[6].per)-self.m_accEffect[6].value
            if id <= 4 then
                num = math.ceil(num*(100+lvupData.upPro)/100)
            end
            num = math.floorMin(num)
            textNode:setString(num)
            if propData:checkEnough(id, num) then
                textNode:setTextColor(gdisplay.COLOR_TEXT_BROWN)
            else
                textNode:setTextColor(gdisplay.COLOR_RED)
                isResEnougth = false
                self.resNoEnoughId = id
            end
            self.m_totalRes[id] = num
        end
    end

    self.isBuildJiaochang = global.cityData:getTopLevelBuild(4)

    local isPopEnougth = true
    local popEnuough = userData:checkPopulation(self.m_totalPop)
    if self.data.type == 7 then
        popEnuough = userData:checkDefPop(self.m_totalPop)
    end
    if popEnuough then
        self.capacity_num:setTextColor(gdisplay.COLOR_TEXT_BROWN)
    else
        self.capacity_num:setTextColor(gdisplay.COLOR_RED)
        isPopEnougth = false
    end
    -- if currNum <= 0 then
    --     can = false
    -- end

    self.m_totalTime = self.data.perTime*currNum    

    local specialStep = luaCfg:get_guide_stage_by(1)
    if global.userData:getGuideStep() == specialStep.Key then
        self.m_totalTime = specialStep.data1                
    end
    -- 城防训练加速
    if self.data.type == 7 then
        self.m_totalTime = self.m_totalTime - math.floor(self.m_totalTime*self.m_accEffect[4].per/100)
    else
        self.m_totalTime = self.m_totalTime - math.floor(self.m_totalTime*self.m_accEffect[2].per/100)
    end
    local timeData = funcGame.formatTimeToHMS(self.m_totalTime)
    self.time:setString(timeData)

    local diaNum = funcGame.getDiamondCount(self.m_totalTime)
    self:checkDiamondEnough(diaNum) 

    self.isResEnougth = isResEnougth
    self.isPopEnougth = isPopEnougth

    local isCanTrain = isResEnougth and isPopEnougth
    global.colorUtils.turnGray(self.grayBg2, isCanTrain == false)
    global.colorUtils.turnGray(self.grayBg1, isCanTrain == false)


end

function TrainNumPanel:onEnter()

    self.resNoEnoughId = 0
    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()
        if self.refersh then       
            if self.data.type ~= 7 then
                self.popu_num:setString(userData:getUsefulPopulation()) 
            end
            self:refersh()
        end
    end)

    self.sliderControl.inputText:setString(1)
end

function TrainNumPanel:checkDiamondEnough(diaNum)

    self.num:setString(diaNum) 
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,diaNum) then
        self.num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function TrainNumPanel:onCostHandler(sender, eventType)


    if not self.isResEnougth then
        global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10852, target=1, param={self.resNoEnoughId}})
        return
    end
    if not self.isPopEnougth then

        if not self.isBuildJiaochang then
            global.tipsMgr:showWarning("train_condition_field")
            return
        end

        if self.data.type == 7 then
            global.tipsMgr:showWarning("train_condition_3")
        else
            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10851, target=2})
        end
        return
    end

    -- global.tipsMgr:showWarning("秒cd功能暂未开放")
    if self.m_totalPop <= 0 then
        global.tipsMgr:showWarning("TroopsConfirm")
        return
    end

    local diamondNum = tonumber(self.num:getString())
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, diamondNum) then
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end

    self:onCloseHandler()

    local data = {
        populationCost = self.m_totalPop,
        resCost = self.m_totalRes,
        count = self.sliderControl:getContentCount(),
        lType = 1,
        lTotleTime = self.m_totalTime
    }

    self.m_callback(data)
end

function TrainNumPanel:playAnimation()
    
    local cityView = global.g_cityView
    local cityNode = cityView.touchMgr:getBuildingNodeBy(self.m_buildingId)
    local speed = 0.65
    cityNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
        
        local trainEffect = resMgr:createCsbAction("effect/army_build_par","animation0",true)
        trainEffect:setPosition(cityNode:convertToWorldSpace(cc.p(0,0)))  
        trainEffect:runAction(cc.Sequence:create(cc.MoveTo:create(speed,cc.p(gdisplay.width / 2,gdisplay.height - 50)),cc.RemoveSelf:create()))            
        uiMgr:configUITree(trainEffect)       
        trainEffect.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
        global.g_cityView:addChild(trainEffect, global.panelMgr.LAYER.LAYER_SYSTEM)

        end),cc.DelayTime:create(speed),cc.CallFunc:create(function()
                local upfire = resMgr:createCsbAction("effect/upgrade_effect_upfire","animation0",false,true)
                upfire:setPosition(cc.p(gdisplay.width / 2,gdisplay.height - 50))
                global.g_cityView:addChild(upfire, global.panelMgr.LAYER.LAYER_SYSTEM)
        end))
    )
end


function TrainNumPanel:onTrainHandler(sender, eventType)

    if not self.isResEnougth then
        global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10852, target=1, param={self.resNoEnoughId}})
        return
    end
    if not self.isPopEnougth then

        if not self.isBuildJiaochang then
            global.tipsMgr:showWarning("train_condition_field")
            return
        end

        if self.data.type == 7 then
            global.tipsMgr:showWarning("train_condition_3")
        else
            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10851, target=2})
        end
        return
    end

    if self.m_totalPop <= 0 then
        global.tipsMgr:showWarning("TroopsConfirm")
        return
    end
    self:onCloseHandler()

    local data = {
        populationCost = self.m_totalPop,
        resCost = self.m_totalRes,
        count = self.sliderControl:getContentCount(),
        lType = 0,
        lTotleTime = self.m_totalTime
    }
    self.m_callback(data)
end
--CALLBACKS_FUNCS_END

return TrainNumPanel

--endregion
