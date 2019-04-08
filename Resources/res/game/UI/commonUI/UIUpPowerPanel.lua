--region UIUpPowerPanel.lua
--Author : yyt
--Date   : 2017/09/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUpPowerPanel  = class("UIUpPowerPanel", function() return gdisplay.newWidget() end )
local UIUpPowerItem = require("game.UI.commonUI.UIUpPowerItem")

function UIUpPowerPanel:ctor()
    self:CreateUI()
end

function UIUpPowerPanel:CreateUI()
    local root = resMgr:createWidget("city/build_lvup_tips")
    self:initUI(root)
end

function UIUpPowerPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_lvup_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.bg1 = self.root.Node_export.bg1_export
    self.combat_num = self.root.Node_export.combat_num_export
    self.title = self.root.Node_export.combat_num_export.title_mlan_9_export
    self.itemH = self.root.Node_export.itemH_export
    self.itemNode = self.root.Node_export.itemNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.root.Panel_1:setSwallowTouches(false)
    self.bg:setSwallowTouches(false)
    self.bg1:setSwallowTouches(false)
    self.itemH:setSwallowTouches(false)
    self.Node:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUpPowerPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.onCloseHandler then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.onCloseHandler then
            self:onCloseHandler()
        end
    end)

end

function UIUpPowerPanel:setData(buildId, nextBuildLv)

    if not buildId or buildId == 0 then return end

    local configData = luaCfg:build_lvup_ui()
    for i,v in pairs(configData) do
        if v.buildingId == buildId and nextBuildLv == v.level then
            self.data = v
            break
        end 
    end 
    if not self.data then return end

    local buildingType = luaCfg:get_buildings_pos_by(buildId).buildingType
    local infoId = global.cityData:getBuildingsInfoId(buildingType, nextBuildLv)         
    local building_info = luaCfg:get_buildings_info_by(infoId)
    self.combat_num:setString("")
    if building_info then 
        self.combat_num:setString(building_info.combatUp)
    end 


    -- 效果列表
    self.itemNode:removeAllChildren()
    local itemH = self.itemH:getContentSize().height
    for i=1,self.data.maxNum do
        
        local info = self.data["typePara"..i]
        local value = self.data["para"..i.."Next"]
        if info and info ~= "" then
            local item = UIUpPowerItem.new()
            if self.data.maxNum > 1 then
                item:setPosition(cc.p(-gdisplay.width/2, -20-itemH*(i-1)))
            else
                item:setPosition(cc.p(-gdisplay.width/2, -30))
            end
            item:setData({info, value})
            self.itemNode:addChild(item)
        end
    end

    local minH, minY = 214, 150
    self.bg:setContentSize(cc.size(gdisplay.width, minH))
    self.bg1:setVisible(false)
    self.bg:setVisible(true)
    self.combat_num:setPositionY(minY)

    if self.data.maxNum > 2 then
        local addH = (self.data.maxNum-2)*itemH*2
        self.bg:setContentSize(cc.size(gdisplay.width, minH+addH))
        self.combat_num:setPositionY(minY+addH/4)
    elseif self.data.maxNum == 0 then

        self.bg1:setVisible(true)
        self.bg:setVisible(false)
        self.combat_num:setPositionY(105)
    end

    self.runing = true  -- errorcode展开展开结束后再允许退出，解决出现特效一半的情况
    self.Node:setScaleY(0)
    self.Node:setVisible(true)
    self.Node:stopAllActions()
 
    local seq = cc.Spawn:create(cc.Sequence:create( cc.DelayTime:create(0.1), cc.CallFunc:create(function ()
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_fcup_3")
    end)), cc.Sequence:create( cc.EaseBackOut:create(cc.ScaleTo:create(0.45,1,1)), cc.CallFunc:create(function () 
        self.runing = false
    end)))

    self.Node:runAction(seq)
    

    -- 倒计时
    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end  
    self.cutTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimerHandler), 1.3)

end

function UIUpPowerPanel:cutTimerHandler()

    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end
    self:onCloseHandler()
end

function UIUpPowerPanel:onCloseHandler(sender, eventType)
    
    -- if not tolua.isnull(self.Node) and (not self.runing) then
        self.Node:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create(), cc.CallFunc:create(function ()
            global.panelMgr:closePanel("UIUpPowerPanel")
        end)))
    -- end
end

function UIUpPowerPanel:onExit()
    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end
end
--CALLBACKS_FUNCS_END

return UIUpPowerPanel

--endregion
