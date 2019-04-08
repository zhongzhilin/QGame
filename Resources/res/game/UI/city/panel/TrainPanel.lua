--region TrainPanel.lua
--Author : wuwx
--Date   : 2016/08/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local userData = global.userData
local luaCfg = global.luaCfg
local cityData = global.cityData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local TrainCard = require("game.UI.city.panel.widget.TrainCard")
local TrainSoldierCard = require("game.UI.city.panel.widget.TrainSoldierCard")
--REQUIRE_CLASS_END

local TrainPanel  = class("TrainPanel", function() return gdisplay.newWidget() end )

function TrainPanel:ctor()
    self:CreateUI()
end

function TrainPanel:CreateUI()
    local root = resMgr:createWidget("train/train_bg")
    self:initUI(root)
end

function TrainPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.trim_top = self.root.trim_top_export
    self.title = self.root.title_export
    self.wall_device = self.root.title_export.wall_device_fnt_export
    self.lv_node = self.root.title_export.lv_node_export
    self.panel_name = self.root.title_export.lv_node_export.panel_name_fnt_export
    self.res = self.root.res_export
    self.train_sequence_1 = TrainCard.new()
    uiMgr:configNestClass(self.train_sequence_1, self.root.train_sequence_1)
    self.train_sequence_2 = TrainCard.new()
    uiMgr:configNestClass(self.train_sequence_2, self.root.train_sequence_2)
    self.train_bg = self.root.train_bg_export
    self.scrollView = self.root.scrollView_export
    self.ps_node = self.root.scrollView_export.ps_node_export
    self.soldier_card_1 = TrainSoldierCard.new()
    uiMgr:configNestClass(self.soldier_card_1, self.root.scrollView_export.soldier_card_1)
    self.soldier_card_2 = TrainSoldierCard.new()
    uiMgr:configNestClass(self.soldier_card_2, self.root.scrollView_export.soldier_card_2)
    self.unlock = self.root.scrollView_export.unlock_export
    self.ps_node2 = self.root.ps_node2_export

--EXPORT_NODE_END
    -- global.panelMgr:trimScrollView(self.scrollView,self.trim_top)
    self:adapt()
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.res)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,function()
        if self.setData then
            self:setData(self.data)
        end
    end)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

end

function TrainPanel:adapt()

    local sHeight =(gdisplay.height - self.trim_top:getContentSize().height)
    local defY = self.scrollView:getContentSize().height
    self.scrollView:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 

    else
        self.scrollView:setTouchEnabled(false)
        self.scrollView:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.scrollView:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.scrollView:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

    self.train_bg:setContentSize(cc.size(self.scrollView:getContentSize().width , self.ps_node2:getPositionY()))
end 

function TrainPanel:onCloseHandler(sender, eventType)
    panelMgr:closePanelForBtn("TrainPanel")
    if panelMgr:getTopPanelName() == "UIWallSpacePanel" then
        panelMgr:getPanel("UIWallSpacePanel"):setData()
    end
end

function TrainPanel:onEnter()
    self["btn_train_1"] = self.soldier_card_1.btn_train
    self["btn_train_2"] = self.soldier_card_2.btn_train
    self["esc"] = self.title.esc

    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.res)

    local callbb = function()
        if self.data then 
            self:setData(self.data)
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE, callbb)

    local callbb1 = function()
        if self.data then 
            self:setData(self.data)
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, callbb1)

    self:addEventListener(global.gameEvent.EV_ON_SOLDIER_HARVEST, callbb1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function TrainPanel:setData(data)

    if not data then return end

    self.data = data
    -- self.panel_name:setString(self.data.serverData.lGrade)
    if self.data.buildingType == 14 then
        self.lv_node:setVisible(false)
        self.wall_device:setVisible(true)
        self.wall_device:setString(global.luaCfg:get_local_string(10090))
        self.unlock:setVisible(false)
    else
        -- 城墙逻辑
        self.lv_node:setVisible(true)
        self.wall_device:setVisible(false)
        self.panel_name:setString(luaCfg:get_local_string(10622,self.data.buildsName,self.data.serverData.lGrade))

        local isfull,class,nextClass = global.soldierData:getSoldierClassBy(self.data.serverData.lGrade)
        if isfull then
            self.unlock:setVisible(false)
        else
            local lvupData = luaCfg:get_soldier_lvup_by(nextClass+1)
            uiMgr:setRichText(self,"unlock",50247,{build =self.data.buildsName ,lv =lvupData.buildLv, sldLv=nextClass})
            self.unlock:setVisible(true)
        end

        ---润稿相关处理 张亮
        -- luaCfg:get_local_string(10622,self.data.buildsName,self.data.serverData.lGrade)
        -- print(luaCfg:get_local_string(10622,self.data.buildsName,self.data.serverData.lGrade))

    end

    self.train_sequence_1:setDelegate(self)
    self.train_sequence_2:setDelegate(self)
    self.soldier_card_1:setDelegate(self)
    self.soldier_card_2:setDelegate(self)


    local race = userData:getRace()
    local soldierType = data.soldierType
    local preSoldierId = race*1000+soldierType*10

    local data1 = clone(luaCfg:get_soldier_train_by(preSoldierId+1))
    local data2 = clone(luaCfg:get_soldier_train_by(preSoldierId+2))

    -- print("reducescale",reducescale)
    -- print("reducescale",reducescale)

    self.soldier_card_1:setData(data1)
    if data2 then
        --注意下侦察兵训练界面只有一种兵
        self.soldier_card_2:setVisible(true)
        self.soldier_card_1:setPositionX(191)
        self.soldier_card_2:setData(data2)
    else
        self.soldier_card_2:setVisible(false)
        self.soldier_card_1:setPositionX(360)
    end

    self.train_sequence_1:setTitle(1)
    self.train_sequence_2:setTitle(2)

    self.train_sequence_1:setData(cityData:getTrainListById(self.data.id,1))
    self.train_sequence_2:setData(cityData:getTrainListById(self.data.id,2))

    self:checkTrain()

end

function TrainPanel:getData()
    return self.data
end

function TrainPanel:getBuildingId()
    return self.data.id
end

function TrainPanel:getTrainer()
    return self.train_sequence_1
end

function TrainPanel:getWaiter()
    return self.train_sequence_2
end

-- 检查士兵是否升阶到满阶
function TrainPanel:checkSoldierMaxClass()
    local lvupData = global.luaCfg:soldier_lvup()
    return (self.data.serverData.lGrade >= lvupData[#lvupData].buildLv)
end

-- 第一队列训练 第二队列闲置
function TrainPanel:getIsWaitTrain()

    if self.train_sequence_1:isTraining() and self.train_sequence_2:isIdle() then
        return true
    end
    return false
end

function TrainPanel:checkTrain()
    local canTrain = self:getTrainer():isIdle() or self:getWaiter():isIdle() 
    for i = 1,2 do
        local trainer = self["soldier_card_"..i]
        trainer:setCanTrain(canTrain)
    end
end


return TrainPanel

--endregion
