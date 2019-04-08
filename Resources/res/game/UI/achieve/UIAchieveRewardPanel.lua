--region UIAchieveRewardPanel.lua
--Author : anlitop
--Date   : 2017/09/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAchieveRewardPanel  = class("UIAchieveRewardPanel", function() return gdisplay.newWidget() end )

local luaCfg = global.luaCfg

function UIAchieveRewardPanel:ctor()
    self:CreateUI()
end

function UIAchieveRewardPanel:CreateUI()
    local root = resMgr:createWidget("achievement/acm_reward")
    self:initUI(root)
end

function UIAchieveRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "achievement/acm_reward")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.monster = self.root.Node_export.monster_export
    self.acm_name = self.root.Node_export.acm_name_export
    self.re = self.root.Node_export.re_mlan_3_export
    self.diaCurNum = self.root.Node_export.diaCurNum_export
    self.diamond_icon_sprite = self.root.Node_export.diamond_icon_sprite_export
    self.star_node_1 = self.root.Node_export.star_node_1_export
    self.star_node_effect_1 = self.root.Node_export.star_node_effect_1_export
    self.star_node_2 = self.root.Node_export.star_node_2_export
    self.star_node_effect_2 = self.root.Node_export.star_node_effect_2_export
    self.star_node_3 = self.root.Node_export.star_node_3_export
    self.star_node_effect_3 = self.root.Node_export.star_node_effect_3_export
    self.light_effect = self.root.Node_export.light_effect_export
    self.get = self.root.Node_export.get_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.get, function(sender, eventType) self:getRewardHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.effectNode = cc.Node:create()
    self.root:addChild(self.effectNode)

    self.rew_text=   self.re
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAchieveRewardPanel:onEnter()
    self.effect_end = false 
    self.effectNode:removeAllChildren()
end 

function UIAchieveRewardPanel:setData(id)

    self.data = id 

    local achData = luaCfg:get_achievement_by(self.data)

    local drop =  global.luaCfg:get_drop_by(achData.reward).dropItem[1]
    self.drop = drop

    self.diaCurNum:setString(":"..drop[2])

    global.panelMgr:setTextureFor(self.diamond_icon_sprite, global.luaCfg:get_item_by(drop[1]).itemIcon)

    self.acm_name:setString(achData.title)
    self.monster :setString(achData.des)

    local roundId = achData.roundId


    self.number =  drop[2]

    for i =1 , 3 do 
        
        self["star_node_"..i]:setVisible(i <= roundId)
        self["star_node_effect_"..i]:setVisible(i <= roundId)

    end 

    self:stopAllActions()

    local nodeTimeLine =resMgr:createTimeline("achievement/acm_reward")
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",false)
    nodeTimeLine:setLastFrameCallFunc(function()

        self.effect_end = true 
    end)
    self:playBG(roundId)


    local nodeTimeLine =resMgr:createTimeline("effect/cup_eff")
    self.light_effect:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)


    -- 多语言居中
    global.tools:adjustNodePos(self.diamond_icon_sprite , self.rew_text)
    global.tools:adjustNodePos(self.diamond_icon_sprite, self.diaCurNum)
    local x = (self.diaCurNum:getPositionX() -  (math.abs( self.rew_text:getPositionX()))) / 2
    self.diamond_icon_sprite:setPositionX(self.diamond_icon_sprite:getPositionX() -x )
    self.rew_text:setPositionX(self.rew_text:getPositionX() - x )
    self.diaCurNum:setPositionX(self.diaCurNum:getPositionX() -  x )

end 


function UIAchieveRewardPanel:playBG(roundId)

    local ationT = {}

    for i =1 , roundId do 
        
        local d = cc.DelayTime:create(0.4)
        local c = cc.CallFunc:create(function()
            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_stars_"..i)
        end)

        table.insert(ationT , d )
        table.insert(ationT , c  )
    end 

    self:runAction(cc.Sequence:create(ationT))
end 


function UIAchieveRewardPanel:exit(sender, eventType)
    if self.effect_end then 
        global.panelMgr:closePanelForBtn("UIAchieveRewardPanel")
    end 
end

function UIAchieveRewardPanel:getRewardHandler(sender, eventType)

    global.taskApi:taskGetGift(self.data,function(msg)

        global.achieveData:isFinishAchieve()

        if self.drop and self.drop[1] == 6 then 
            -- 閹绢厽鏂侀悧瑙勬櫏
            local x, y = self.diaCurNum:convertToWorldSpace(cc.p(0,0))
            self:playHarvestEffect(x, y, tonumber(self.number) , handler(self ,self.exit))
        else 

            global.panelMgr:closePanel("UIAchieveRewardPanel")
            global.panelMgr:openPanel("UIItemRewardPanel"):setData({self.drop})
        end 

        gevent:call(global.gameEvent.EV_ON_UI_ACM_UPDATE)

    end, 1)
    
end


function UIAchieveRewardPanel:playHarvestEffect(posX, posY, diamondNum ,call)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_FlyMoney")
    self:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        local sp = cc.Sprite:create()
        sp:setSpriteFrame("ui_surface_icon/item_icon_005.png")
        sp:setPosition(cc.p(posX, posY))
        self.effectNode:addChild(sp)

        local endX, endY = gdisplay.width - 50,  gdisplay.height - 50
        local bezier = {}
        bezier[1] = cc.p(200 - math.random(100),endY + 50 - math.random(100))
        bezier[2] = cc.p(400 - math.random(200),endY + 150 - math.random(300))
        bezier[3] = cc.p(endX, endY)

        sp:runAction(cc.BezierTo:create(0.6,bezier))
        sp:setScale(0)
        sp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1),cc.ScaleTo:create(0.3,0),cc.RemoveSelf:create()))

        local mms = cc.MotionStreak:create(0.5, 0.1, 7, cc.c3b(255,255,255),"map/stoneLine.png")
        mms:setFastMode(true)
        self.effectNode:addChild(mms)

        mms:setPosition(sp:getPosition())
        mms:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

        mms:runAction(cc.BezierTo:create(0.6,bezier))
    end),cc.DelayTime:create(0.1)),4))

    local number = ccui.TextAtlas:create(":"..math.floor(diamondNum),"fonts/number_white.png",33,40,"0")
    number:setPosition(cc.p(posX, posY))
    self.effectNode:addChild(number)

    number:setScale(0.7)
    number:setColor(cc.c3b(143, 222, 255))
    number:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.FadeOut:create(0.6)))
    number:runAction(cc.Sequence:create(cc.EaseIn:create(cc.MoveBy:create(1.2,cc.p(0,150)),1),cc.RemoveSelf:create() ,cc.CallFunc:create(function()
        self.effect_end = true 
        if call then 
            call()
        end 
    end)))

end


--CALLBACKS_FUNCS_END

return UIAchieveRewardPanel

--endregion
