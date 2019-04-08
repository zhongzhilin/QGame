--region UIPKRePlayHeroItemArr.lua
--Author : zzl
--Date   : 2018/02/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPKRePlayHeroItem = require("game.UI.pk.player.UIPKRePlayHeroItem")
--REQUIRE_CLASS_END

local UIPKRePlayHeroItemArr  = class("UIPKRePlayHeroItemArr", function() return gdisplay.newWidget() end )

function UIPKRePlayHeroItemArr:ctor()
    
end

function UIPKRePlayHeroItemArr:CreateUI()
    local root = resMgr:createWidget("player_kill/player/play_2hero")
    self:initUI(root)
end

function UIPKRePlayHeroItemArr:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/player/play_2hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_0 = UIPKRePlayHeroItem.new()
    uiMgr:configNestClass(self.FileNode_0, self.root.node_0.FileNode_0)
    self.FileNode_1 = UIPKRePlayHeroItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.node_1.FileNode_1)

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPKRePlayHeroItemArr:onEnter()


end 

function UIPKRePlayHeroItemArr:onExit()


    if self.timer then 
        gscheduler.unscheduleGlobal(self.timer)
    end 

    self:stopAllActions()
end 

function UIPKRePlayHeroItemArr:setData(data , heroData)

    self.data = data 

    dump(self.data ,"UIPKRePlayHeroItemArr")

    self.displayHero = self.FileNode_1

    self.attackHero =  self["FileNode_"..data.attack]
    self.defackHero =  self["FileNode_"..(1-data.attack)]

    self.winHero =  self["FileNode_"..data.win]
    self.failedhero =  self["FileNode_"..(1-data.win)]

    self.attackHero.victory:setVisible(true)
    self.defackHero.victory:setVisible(true)

    self.attackHero.effect:setVisible(false)
    self.defackHero.effect:setVisible(false)


    self.FileNode_1.hurt:setVisible(false)
    self.FileNode_0.hurt:setVisible(false)


    self.failedhero.victory:setVisible(false)

    self.failedhero.failed:setVisible(false)
    self.winHero.failed:setVisible(false)

    self.winHero.effect:setVisible(true)

    -- self.FileNode_1:restUI()
    -- self.FileNode_0:restUI()

    self:restUI()


    global.colorUtils.turnGray(self.FileNode_1.bt_bg, false)
    global.colorUtils.turnGray(self.FileNode_0.bt_bg , false)

    self.FileNode_0:setData(heroData.attack)
    self.FileNode_1:setData(heroData.def)



    -- self.displayHero:runRePlayAction(4)
end


function UIPKRePlayHeroItemArr:quickResult()


    self.failedhero.failed:setVisible(true)

    self:restUI()
    self.FileNode_1:restUI()
    self.FileNode_0:restUI()

    self.FileNode_1:runRePlayAction(5)
    self.FileNode_0:runRePlayAction(5)

    global.colorUtils.turnGray(self.failedhero.bt_bg, true)


    self:stopAllActions()

end 

function UIPKRePlayHeroItemArr:getC(call)

    return cc.CallFunc:create(call)
end 

local dayTime  = 1

function UIPKRePlayHeroItemArr:excute()

      local  s2 =  cc.Sequence:create(

        self:getC(function () 

            self.displayHero:runRePlayAction(2)
        end) , -- 翻盖

        cc.DelayTime:create(dayTime),

        self:getC(function () 

            self:runRePlayAction(self.data.attack+1)

        end) , -- 攻击 

        cc.DelayTime:create(dayTime*0.4),

        self:getC(function () 

            self.winHero:runRePlayAction(3)
            self.failedhero:runRePlayAction(3)
            -- self.defackHero:runRePlayAction(3)
            -- self.winHero.failed:setVisible(false)

            global.delayCallFunc(function()

                if self.failedhero and not tolua.isnull(self.failedhero) then 
                    self.failedhero.failed:setVisible(true)
                end 

            end,0 , 1.2)

        end),-- 结果 

        cc.DelayTime:create(1.15),

        self:getC(function () 

            global.colorUtils.turnGray(self.failedhero.bt_bg, true)

        end) -- 结果 
    )

    self:runAction(s2)
end 



function UIPKRePlayHeroItemArr:test()

    self.FileNode_0:runRePlayAction(6)
    self.FileNode_1:runRePlayAction(7)

end 

function UIPKRePlayHeroItemArr:restUI()

    self.root:stopAllActions()
    self.nodeTimeLine =global.resMgr:createTimeline("player_kill/player/play_2hero")
    self.root:runAction(self.nodeTimeLine)
    self.nodeTimeLine:gotoFrameAndPause(0)

end 


local action_table ={
    { "animation0" , 1 , "Player_SoldiersPK" ,0.35},
    { "animation1" , 2 , "Player_SoldiersPK" ,0.35},
    -- { function () return , "Player_SoldiersPK" , 0.1}
}

function UIPKRePlayHeroItemArr:runRePlayAction(tag)

    self.root:stopAllActions()

    local animation = ""

    animation = action_table[tag]

    self.nodeTimeLine =global.resMgr:createTimeline("player_kill/player/play_2hero")

    self.nodeTimeLine:play(animation[1], false)

    self.root:runAction(self.nodeTimeLine)

    if  animation[3] and animation~=""  then 
        self.timer=global.delayCallFunc(function()
            gevent:call(gsound.EV_ON_PLAYSOUND, animation[3])
        end,0 , animation[4] or 0)
    end 

    return animation[2]
end 

--CALLBACKS_FUNCS_END

return UIPKRePlayHeroItemArr

--endregion
