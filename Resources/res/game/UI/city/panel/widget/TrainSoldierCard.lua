--region TrainSoldierCard.lua
--Author : wuwx
--Date   : 2016/08/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local propData = global.propData
local cityData = global.cityData
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local TrainSoldierCard  = class("TrainSoldierCard", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function TrainSoldierCard:ctor()
    
end

function TrainSoldierCard:CreateUI()
    local root = resMgr:createWidget("train/train_atk_bg")
    self:initUI(root)
end

function TrainSoldierCard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_atk_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_cell = self.root.btn_cell_export
    self.node_gray = self.root.btn_cell_export.node_gray_export
    self.btn_train = self.root.btn_cell_export.node_gray_export.btn_train_export
    self.blue_bg = self.root.btn_cell_export.node_gray_export.blue_bg_export
    self.btn_detail = self.root.btn_cell_export.node_gray_export.btn_detail_export
    self.up = self.root.btn_cell_export.node_gray_export.btn_detail_export.up_export
    self.name = self.root.btn_cell_export.node_gray_export.name_export
    self.soldier_node = self.root.btn_cell_export.node_gray_export.soldier_node_export
    self.get_num = self.root.btn_cell_export.node_gray_export.time_bg.get_mlan_4.get_num_export
    self.atk_num = self.root.btn_cell_export.node_gray_export.pro_node.atk_mlan_2.atk_num_export
    self.def_num = self.root.btn_cell_export.node_gray_export.pro_node.def_mlan_2.def_num_export
    self.Button_1 = self.root.Node_1.Button_1_export
    self.skill_icon_1 = self.root.Node_1.Button_1_export.skill_icon_1_export
    self.Button_2 = self.root.Node_2.Button_2_export
    self.skill_icon_2 = self.root.Node_2.Button_2_export.skill_icon_2_export
    self.Button_3 = self.root.Node_3.Button_3_export
    self.skill_icon_3 = self.root.Node_3.Button_3_export.skill_icon_3_export
    self.Button_4 = self.root.Node_4.Button_4_export
    self.skill_icon_4 = self.root.Node_4.Button_4_export.skill_icon_4_export
    self.Button_5 = self.root.Node_5.Button_5_export
    self.skill_icon_5 = self.root.Node_5.Button_5_export.skill_icon_5_export
    self.Button_6 = self.root.Node_6.Button_6_export
    self.skill_icon_6 = self.root.Node_6.Button_6_export.skill_icon_6_export
    self.star = self.root.star_export
    self.star1_bj = self.root.star_export.star1_bj_export
    self.star1 = self.root.star_export.star1_bj_export.star1_export
    self.star2 = self.root.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.star_export.star2_bj_export
    self.star3 = self.root.star_export.star2_bj_export.star3_export
    self.star4 = self.root.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.star_export.star3_bj_export
    self.star5 = self.root.star_export.star3_bj_export.star5_export
    self.star6 = self.root.star_export.star3_bj_export.star6_export

    uiMgr:addWidgetTouchHandler(self.btn_train, function(sender, eventType) self:onTrainClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_detail, function(sender, eventType) self:onDetailClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_2, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_3, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_4, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_5, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_6, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
--EXPORT_NODE_END
	self.btn_cell:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function TrainSoldierCard:onDetailClickHandler(sender, eventType)
	if self.data.type == 7 then
	    local panelT = panelMgr:openPanel("UIDeviceDetailTPanel")
	    panelT:setData(self.data)
	else
        if global.panelMgr:getPanel("TrainPanel"):checkSoldierMaxClass() then
            local TrainSoldierDetail = panelMgr:openPanel("TrainSoldierDetail")
            local buildingData = self.m_delegate:getData()
            TrainSoldierDetail:setData(self.data, buildingData)
        else
            local TrainUpSoldierDetail = panelMgr:openPanel("TrainUpSoldierDetail")
            local buildingData = self.m_delegate:getData()
            TrainUpSoldierDetail:setData(self.data, buildingData)
        end
	end
end

-- 检测是否有训练周卡
function TrainSoldierCard:checkTrainCondit(data)

	-- local isMonthCard = global.rechargeData:isTrainMonthCard()

	-- if not isMonthCard then -- 提示开通

	-- 	if trainer:isDone() then
	-- 		global.tipsMgr:showWarning("receive_first")
	-- 		return
	-- 	end

	-- 	if trainer:isTraining() then
	-- 		local panel = global.panelMgr:openPanel("UIPromptPanel")
	--         panel:setData("WEEK_CARD_RENEW_3", function ()
	--             global.panelMgr:openPanel("UIMonthCardPanel"):setData()
	--         end)
	--  		return
	-- 	end

	-- else --剩余时间

	-- 	local trainMonthCard = global.rechargeData:checkTrainMonthCard(data.lTotleTime)
 --    	if trainMonthCard == 0 and self.m_delegate:getIsWaitTrain() then
 --    		local panel = global.panelMgr:openPanel("UIPromptPanel")
	--         panel:setData("WEEK_CARD_RENEW_2", function ()
	--             global.panelMgr:openPanel("UIMonthCardPanel"):setData()
	--         end)
 --    		return
 --    	end

	-- end

   
    local trainer = self.m_delegate:getTrainer()
    -- vip state  -- 0:等级不够高 1: 等级够高 未激活 2: 等级够高 已经 激活 时间不够 3: 可用
    local state  =  global.vipBuffEffectData:isTrainMonthCard(data.lTotleTime)

    local call = function (errcode ) 

        local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData(errcode, function ()
            global.panelMgr:openPanel("UIvipPanel")
        end)
    end   

    if trainer:isTraining() then 

        if state == 0 then 
            
            call("Vip7Not")


        elseif state == 1 then 

            call("VipNotOpen")


        elseif state == 2 then 

            call("VipNoTime")

        elseif state == 3 then 

        end 
    else
        if trainer:isDone() and state ~= 3 then
            global.tipsMgr:showWarning("receive_first")
            return
        end
    end 

end

function TrainSoldierCard:playSound()
	
	gsound.stopEffect("city_click")
	if self.data.type == 7 then
		if self.data.skill == 1 then
			gevent:call(gsound.EV_ON_PLAYSOUND,"city_bartizan")
		else
			gevent:call(gsound.EV_ON_PLAYSOUND,"city_trap")
		end
	else
		gevent:call(gsound.EV_ON_PLAYSOUND,"city_train_"..self.data.type)
	end
end

function TrainSoldierCard:onTrainClickHandler(sender, eventType)

	local TrainNumPanel = panelMgr:openPanel("TrainNumPanel")
	local buildingId = self.m_delegate:getBuildingId()
	TrainNumPanel:setData(self.data,buildingId)
    TrainNumPanel:setCallBack(function(data)
  	
    	self:checkTrainCondit(data) -- 训练条件检测
    	self:playSound()		

    	-- 训练 --
    	global.cityApi:trainSoldier(buildingId,self.data.id,data.count,function(msg)
    		-- body
    		dump(msg, "##############>>> global.cityApi:trainSoldier: "..global.dataMgr:getServerTime())

		    if data.lType == 1 and msg.lBdTrain then 	   -- 使用魔晶立即训练
		    	msg.lBdTrain.lTotleTime = 0
		    end
	        cityData:setTrainList(buildingId,msg.lBdTrain) -- 设置训练队列

	        -------------------- 建筑上方图标表现 ------------------------

            if  global.g_cityView then 
	           local camp = global.g_cityView:getTouchMgr():getBuildingNodeBy(buildingId)			     
	    	  camp:trainState()
            end 
	    	-------------------- 训练队列卡片表现 ------------------------
	    	if not tolua.isnull(self.m_delegate) then
				local trainer = self.m_delegate:getTrainer()
				local waiter  = self.m_delegate:getWaiter()
				if msg.lBdTrain.lID == 1 then
					trainer:startTrain(msg.lBdTrain,(data.lType == 1))
				else
					waiter:startTrain(msg.lBdTrain,(data.lType == 1))
				end
				self.m_delegate:checkTrain() -- 训练面板按钮(是否可以训练)
			end
			
			-- 引导、空闲事件触发
			if data.lType == 0 then		
				gevent:call(global.gameEvent.EV_ON_UI_TRAINCLICK)
			end
			gevent:call(global.gameEvent.EV_ON_GUIDE_FINISH_CRUX_STEP)		
			gevent:call(global.gameEvent.EV_ON_UI_LEISURE)

    	end,data.lType)
    end)
end

function TrainSoldierCard:unLockSkillHandler(sender, eventType)

	local tag = sender:getTag()
    local configCamp = luaCfg:camp_lvup()
    local skillData = {}
    for _,v in pairs(configCamp) do
        if v.buildingId == self.buildingData.buildingType and v.skillOrder == tag then
                
            local skills = luaCfg:get_soldier_skill_by(v.skillId)
            local str = global.luaCfg:get_translate_string(10854, self.buildingData.buildsName, v.level, skills.skillName)
            global.tipsMgr:showWarning(str)
            return         
        end
    end
end
--CALLBACKS_FUNCS_END

function TrainSoldierCard:checkTipsPro(data)
    
    local soldier_pro_tips = luaCfg:soldier_pro_tips()
    for _,v in pairs(soldier_pro_tips) do
        if data.type == v.type and data.skill == v.skill then
            return v
        end
    end
end

function TrainSoldierCard:checkBuff(soldier_lvup_data)
        
    -- dump(soldier_lvup_data,'soldier_lvup_data')

    local defKeys = {
        "iftDef",
        "cvlDef",
        "acrDef",
        "magDef",
    }
    
    local pro = soldier_lvup_data.upPro / 100 + 1
    local soldierData = luaCfg:get_soldier_property_by(self.data.id)
    local soldier_pro_tips = self:checkTipsPro(self.data) or {}
    soldier_pro_tips.atk0 = soldier_pro_tips.atk0 or 0
    soldier_pro_tips.def0 = soldier_pro_tips.def0 or 0

    local atk = soldier_pro_tips.atk0 * pro
    local def = soldier_pro_tips.def0 * pro
    -- local soldierProMax = luaCfg:get_config_by(1).soldierProMax
    -- local soldierProBase = luaCfg:get_config_by(1).soldierProBase 
    self.atk_num:setPercent(atk)
    self.def_num:setPercent(def)

    -- global.SoldierBufferData:getBuffByID(self.data,function(tips)
        
    --     if not tips then
    --         self.atk_num:setPercent(0)
    --         self.def_num:setPercent(0)
    --     else
    --         local atk = tips['atk']
    --         local def = 0
    --         for _,v in ipairs(defKeys) do
    --             def = def + tips[v]
    --         end
    --         def = def / 4
    --         print('atk',atk,'def',def)
            
    --     end        
    -- end)
end

function TrainSoldierCard:setDelegate(delegate)
	self.m_delegate = delegate
end

function TrainSoldierCard:setData(data)

    data = data or {} 

	local soldierData = global.soldierData:getSoldiersBy(data.id)
    if soldierData then
        self.get_num:setString(soldierData.lCount + global.troopData:getSoldierNumById(data.id))
    else
        self.get_num:setString(global.troopData:getSoldierNumById(data.id))
    end

	--guide_btn_train_1012
    if data.skill then 
        self.btn_train:setName(self.btn_train:getName() .. data.skill)  
    end 

	self.data = data

	self.name:setString(data.name)

	--区分攻击兵还是防御兵
	-- self.blue_bg:setVisible(self.data.skill==2)
	local raceData = global.luaCfg:get_race_by(global.userData:getRace())
	global.panelMgr:setTextureFor(self.blue_bg, raceData.soldierBg)

	-- self.soldier_pic:loadTexture(data.pic, ccui.TextureResType.plistType)
	global.tools:setSoldierBust(self.soldier_node,self.data)

    local showlvStar = function (lv)
        self.star:setVisible(lv ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lv >= i)
        end
    end
	local id,dataBuild = global.cityData:getBuildingIdBySoldierId(data.id)
    if dataBuild and dataBuild.serverData and (data.type ~= 7) and (data.type ~= 0) then
        local soldier_lvup_data = self:colSoldierLv(dataBuild.serverData.lGrade or 1)
        showlvStar(soldier_lvup_data.lv)
        self.atk_num:getParent():getParent():setVisible(true)
        self:checkBuff(soldier_lvup_data)
        local soldierData = global.soldierData:getSoldiersBy(data.id)
        if soldierData then
            self.get_num:setString(soldierData.lCount + global.troopData:getSoldierNumById(data.id))
        else
            self.get_num:setString(global.troopData:getSoldierNumById(data.id))
        end
        if global.panelMgr:getPanel("TrainPanel"):checkSoldierMaxClass() then
            self.up:setString(global.luaCfg:get_local_string(10974))
        else
            self.up:setString(global.luaCfg:get_local_string(10973))
        end
    else
    	showlvStar(-1)
        self.atk_num:getParent():getParent():setVisible(false)
        self.up:setString(global.luaCfg:get_local_string(10974))
        local soldierData = global.soldierData:getTrapsBy(data.id)
        dump(soldierData,'soldierData')
        if soldierData then
            self.get_num:setString(soldierData.lCount)
        else
            self.get_num:setString(0)
        end
    end

    self:setSoldierSkill()

    global.tools:adjustNodePosForFather(self.get_num:getParent() , self.get_num)
end

function TrainSoldierCard:colSoldierLv(buildLv)
    
    local soldier_lvup = luaCfg:soldier_lvup()
    local res = {lv = 0,upPro = 0}
    for _,v in ipairs(soldier_lvup) do
        if buildLv >= v.buildLv then
            res = v
        end
    end
    return res
end

function TrainSoldierCard:setSoldierSkill()

    local buildingData = self.m_delegate:getData()
    -- 城墙 / 侦察营
    if buildingData.id == 12 or buildingData.id == 14 then
        for i=1,6 do
            local btnBg = self["Button_"..i]
            btnBg:setVisible(false)
        end
        return
    end
	
	-- 士兵技能解锁
	self.buildingData = buildingData
    local curLv = buildingData.serverData.lGrade
    local curId = buildingData.buildingType
    self.buildingData = buildingData
    local configCamp = luaCfg:camp_lvup()
    local skillData = {}
    for _,v in pairs(configCamp) do
        if v.buildingId == curId and v.skillId ~= 0 then 
            table.insert(skillData, v)
        end
    end

    if table.nums(skillData) > 1 then
        table.sort(skillData, function(s1, s2) return s1.level < s2.level end)
    end

    for i=1,6 do
        local skillIcon = self["skill_icon_"..i]
        local btnBg = self["Button_"..i]
        btnBg:setVisible(true)
        if skillData[i] then

            global.colorUtils.turnGray(skillIcon, false)
            local skills = luaCfg:get_soldier_skill_by(skillData[i].skillId)
            global.panelMgr:setTextureFor(skillIcon, skills.icon)     

            if skillData[i].level <= curLv then

                btnBg:setTouchEnabled(false)
                -- tips
                local trainPanel = global.panelMgr:getPanel("TrainPanel")
                local tempdata ={information=skills, param=true}
                self["m_TipsControl"..i] = UIItemTipsControl.new()
                self["m_TipsControl"..i]:setdata(skillIcon, tempdata, trainPanel.tips_node)
            else
                btnBg:setTouchEnabled(true)
                global.colorUtils.turnGray(skillIcon, true)
            end
        end
    end
end

function TrainSoldierCard:setCanTrain(can)
	-- global.colorUtils.turnGray(self.node_gray, not can)
	self.btn_train:setEnabled(can)
end

function TrainSoldierCard:onExit()
    for i=1,6 do
        if self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end 
    end
end 



return TrainSoldierCard

--endregion
