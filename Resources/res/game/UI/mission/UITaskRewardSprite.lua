--region UITaskRewardSprite.lua
--Author : Untory
--Date   : 2017/09/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITaskRewardSprite  = class("UITaskRewardSprite", function() return gdisplay.newWidget() end )

function UITaskRewardSprite:ctor()
    self:CreateUI()
end

function UITaskRewardSprite:CreateUI()
    local root = resMgr:createWidget("task/task_city_reward_node")
    self:initUI(root)
end

function UITaskRewardSprite:initUI(root)    
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_city_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.bg.icon_export
    self.num = self.root.num_export

--EXPORT_NODE_END
    
    self:setCascadeOpacityEnabled(true)
    self.root:setCascadeOpacityEnabled(true)
end

local linePath = {
    
    [WCONST.PROP_INDEX.FOOD] = "map/foodLine.png",
    [WCONST.PROP_INDEX.GOLD] = "map/coinLine.png",
    [WCONST.PROP_INDEX.STONE] = "map/stoneLine.png",
    [WCONST.PROP_INDEX.WOOD] = "map/woodLine.png",
}

function UITaskRewardSprite:setData(data , call)
    
    local itemData = luaCfg:get_res_icon_by(data.lID)
    local itemIcon = itemData.icon
    self.icon:setSpriteFrame(itemIcon)
    self.num:setString(":" .. data.lCount)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_DivineItme")
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        


        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_harvest_2")
        if data.lID < 5 then
            self:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
                
                print(">>>task reward")

                local sp = cc.Sprite:create()
                sp:setSpriteFrame(itemIcon)
                sp:setPosition(self:convertToWorldSpace(cc.p(0,0)))
                -- global.scMgr:CurScene():addChild(sp, 31)
                global.panelMgr:addWidgetToPanelDown(sp)

                local endY = gdisplay.height - 133 - (data.lID - 1) * 46

                local bezier = {}               

                if global.scMgr:isWorldScene() then 
                    bezier[1] = cc.p(700 - math.random(200),endY + 50 - math.random(100))
                    bezier[2] = cc.p(800 - math.random(200),endY + 150 - math.random(300))
                    bezier[3] = cc.p(200,50)
                else
                    bezier[1] = cc.p(200 - math.random(100),endY + 50 - math.random(100))
                    bezier[2] = cc.p(400 - math.random(200),endY + 150 - math.random(300))
                    bezier[3] = cc.p(680,endY)
                end


                sp:runAction(cc.BezierTo:create(0.6,bezier))
                sp:setScale(0)
                sp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1),cc.ScaleTo:create(0.3,0),cc.RemoveSelf:create()))

                local mms = cc.MotionStreak:create(0.5, 0.1, 7, cc.c3b(255,255,255),linePath[data.lID])
                mms:setFastMode(true)
                -- global.scMgr:CurScene():addChild(mms, 31)
                global.panelMgr:addWidgetToPanelDown(mms)

                mms:setPosition(sp:getPosition())
                mms:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

                mms:runAction(cc.Sequence:create(cc.BezierTo:create(0.6,bezier) ))

            end),cc.DelayTime:create(0.1)),4))
        end

        if data.lID == 5 then
            local speed = 0.65
            local flystar2 = resMgr:createWidget("effect/upgrade_effect_exp")
            flystar2:setPosition(self:convertToWorldSpace(cc.p(0,0)))
            flystar2:runAction(cc.Sequence:create(cc.MoveTo:create(speed,cc.p(45,gdisplay.height - 135)),cc.RemoveSelf:create()))            
            uiMgr:configUITree(flystar2)     
            flystar2.Particle_1:setPositionType(cc.POSITION_TYPE_FREE)
            -- global.scMgr:CurScene():addChild(flystar2, 31)
            global.panelMgr:addWidgetToPanelDown(flystar2)
        end
    end), cc.FadeOut:create(0.5) , cc.CallFunc:create(function()
        if call then 
            call()
        end 
    end)))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITaskRewardSprite

--endregion
