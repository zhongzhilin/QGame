--region UIAchieveItem.lua
--Author : yyt
--Date   : 2017/02/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAchieveItem  = class("UIAchieveItem", function() return gdisplay.newWidget() end )

function UIAchieveItem:ctor()
    self:CreateUI()
end

function UIAchieveItem:CreateUI()
    local root = resMgr:createWidget("achievement/acm_node")
    self:initUI(root)
end

function UIAchieveItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "achievement/acm_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.starDone1 = self.root.Image_1.starDone1_export
    self.starDone3 = self.root.Image_1.starDone3_export
    self.starDone2 = self.root.Image_1.starDone2_export
    self.acm_name = self.root.Image_1.acm_name_export
    self.acm_des = self.root.Image_1.acm_des_export
    self.acm_reward = self.root.Image_1.acm_reward_mlan_2_export
    self.dia_icon = self.root.Image_1.dia_icon_export
    self.diaNum = self.root.Image_1.diaNum_export
    self.progress = self.root.Image_1.progress_export
    self.bar = self.root.Image_1.progress_export.bar_export
    self.progressNum = self.root.Image_1.progress_export.progressNum_export
    self.compete = self.root.Image_1.compete_export
    self.get = self.root.Image_1.get_export
    self.Node_1 = self.root.Image_1.Node_1_export
    self.Node_2 = self.root.Image_1.Node_2_export
    self.Node_3 = self.root.Image_1.Node_3_export

    uiMgr:addWidgetTouchHandler(self.get, function(sender, eventType) self:getRewardHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.get:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- required int32      lID         = 1;//
-- required int32      lState      = 2;// -1未开启, 0进行中，1可领取，2已领取，3挑战失败
-- required int32      lProgress   = 3
function UIAchieveItem:setData(data)

    self.data = data
    local achData = luaCfg:get_achievement_by(data.lID)

    local drop =  global.luaCfg:get_drop_by(achData.reward).dropItem[1]

    self.drop = drop
    
    global.panelMgr:setTextureFor(self.dia_icon, global.luaCfg:get_item_by(drop[1]).itemIcon)

    self.diaNum:setString("+"..drop[2])
    global.tools:adjustNodePos(self.acm_reward, self.dia_icon)
    -- global.tools:adjustNodePos(self.dia_icon, self.diaNum)
    self.diaNum:setPositionX(self.dia_icon:getPositionX() + 50)

    self.acm_name:setString(achData.title)
    self.acm_des:setString(achData.des)

    self.get:setVisible(false)
    self.compete:setVisible(false)
    if data.lState == 0 then
        self.progress:setVisible(true)
        self.bar:setPercent(data.lProgress/achData.target*100)
        self.progressNum:setString(data.lProgress.."/"..achData.target)
    else
        self.progress:setVisible(false)
        self.get:setVisible(data.lState == 1)
        self.compete:setVisible(data.lState == 2)
    end

    -- dump(data)
    for i=1,3 do
        self["starDone"..i]:setVisible(false)
        self["Node_"..i]:removeAllChildren()
    end

    -- 成就阶段星级
    data.serverRound = data.serverRound or achData.roundId

    --依次播放星星效果
    local playEffectFlag = data.effectFlag
    if global.achieveData:isFirstInit() then

        for i=1, data.serverRound do
            self["starDone"..i]:setVisible(true)
        end

    else

        for i=1, playEffectFlag do
            
            if i <= data.serverRound then
                self["starDone"..i]:setVisible(true)
            end
        end

        for i=playEffectFlag+1, data.serverRound do
            
            local delay = 0.5*(i-playEffectFlag-1)
            self:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()
                -- body
                self:playEffect(i)
            end)))
        end
    end

    data.effectFlag = data.serverRound

end

function UIAchieveItem:playEffect( flag )

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_stars_"..flag)
    local timeLine = resMgr:createCsbAction("achievement/effect","animation0",false,true,nil,function ( )

        self["starDone"..flag]:setVisible(true)
    end)
    timeLine:setPosition(0, 0)
    self["Node_"..flag]:addChild(timeLine)

end

function UIAchieveItem:getRewardHandler(sender, eventType)

    local panel = global.panelMgr:getPanel("UIAchievePanel")
    panel.ResSetControl:setRmbDelay(1)

    global.taskApi:taskGetGift(self.data.lID,function(msg)

        panel:refersh() 

        if self.drop and self.drop[1] == 6 then 
            -- 播放特效
            local x, y = self.dia_icon:convertToWorldSpace(cc.p(0,0))
            panel:playHarvestEffect(x, y, tonumber(self.diaNum:getString()))
        else 

            global.panelMgr:openPanel("UIItemRewardPanel"):setData({self.drop})
        end 

        gevent:call(global.gameEvent.EV_ON_UI_ACM_UPDATE)
    end, 1)
end

--CALLBACKS_FUNCS_END

return UIAchieveItem

--endregion
