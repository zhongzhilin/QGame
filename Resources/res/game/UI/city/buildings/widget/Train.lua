--region Train.lua
--Author : wuwx
--Date   : 2016/08/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local TrainCircle = require("game.UI.city.buildings.widget.TrainCircle")
--REQUIRE_CLASS_END

local Train  = class("Train", function() return gdisplay.newWidget() end )

function Train:ctor()
    self:CreateUI()
end

function Train:CreateUI()
    local root = resMgr:createWidget("city/build_barrack_time")
    self:initUI(root)
end

function Train:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_barrack_time")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Normal = self.root.Normal_export
    self.load = self.root.Normal_export.Panel_1.load_export
    self.loading_effect = self.root.Normal_export.Panel_1.loading_effect_export
    self.time_bg = self.root.Normal_export.time_bg_export
    self.time = self.root.Normal_export.time_bg_export.time_export
    self.icon = self.root.Normal_export.Sprite_1.icon_export
    self.cirFinish = self.root.cirFinish_export
    self.cirFinish = TrainCircle.new()
    uiMgr:configNestClass(self.cirFinish, self.root.cirFinish_export)

--EXPORT_NODE_END
    self.barW = self.load:getContentSize().width
end

function Train:setData(soldierTrainData, isTrain)
	-- self.icon:setSpriteFrame(soldierTrainData.icon)
    self.soldierTrainData = soldierTrainData
    global.panelMgr:setTextureFor(self.icon,soldierTrainData.icon)
    local s = soldierTrainData.scale or 0.4951
    self.icon:setScale(s)

    self.Normal:setVisible(true)
    self.cirFinish:setVisible(false)
    self.isFinsih = false

    self.Normal:setPositionX(0)
    if isTrain then
       self.Normal:setPositionX(-26) 
    end
end

function Train:setHarvestCall(call)
    self.m_harvestCall = call
end

function Train:harvestCall(queueData)
    self.m_harvestCall(queueData)
end

function Train:updateInfo(data, queueData)
	self.load:setPercent(data.percent)
	self.time:setString(data.time)
    self.loading_effect:setPositionX(3+self.barW*data.percent/100)

    self:playFullEffect(data, queueData)
end

function Train:playFullEffect(data, queueData)

    self.queueData = queueData
    self.isFinsih = false
    self.Normal:setVisible(false)
    self.cirFinish:setVisible(false)
    if data.percent >= 100 then

        self.isFinsih = true
        self.cirFinish:setVisible(true)
        self.cirFinish:setHarvestCall(handler(self, self.harvestCall))
        self.cirFinish:setData(self.soldierTrainData)
        self.cirFinish:updateInfo(data, queueData)
    else
        self.Normal:setVisible(true)
    end
end

function Train:setActivityData(ac_data)
    if ac_data.type == 0 then 
        self.load:loadTexture(global.ActivityData.bg, ccui.TextureResType.plistType)
        self.loading_effect:setSpriteFrame(global.ActivityData.effect)
    elseif ac_data.type == 1 then 
        self.load:loadTexture(global.ActivityData.bg1, ccui.TextureResType.plistType)
        self.loading_effect:setSpriteFrame(global.ActivityData.effect1)
    end 
    self.icon:setSpriteFrame(global.ActivityData.icon)
    self.icon:setScale(global.ActivityData.scale)
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return Train

--endregion
