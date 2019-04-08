--region UINode1.lua
--Author : yyt
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBossItem = require("game.UI.boss.UIBossItem")
--REQUIRE_CLASS_END

local UINode1  = class("UINode1", function() return gdisplay.newWidget() end )

function UINode1:ctor()
    self:CreateUI()
end

function UINode1:CreateUI()
    local root = resMgr:createWidget("boss/boss_loop_monster1")
    self:initUI(root)
end

function UINode1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_loop_monster1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.run1 = self.root.run1_export
    self.road101 = self.root.run1_export.road101_export
    self.road102 = self.root.run1_export.road102_export
    self.road103 = self.root.run1_export.road103_export
    self.road104 = self.root.run1_export.road104_export
    self.road105 = self.root.run1_export.road105_export
    self.road106 = self.root.run1_export.road106_export
    self.road107 = self.root.run1_export.road107_export
    self.road108 = self.root.run1_export.road108_export
    self.road109 = self.root.run1_export.road109_export
    self.run2 = self.root.run2_export
    self.road201 = self.root.run2_export.road201_export
    self.road202 = self.root.run2_export.road202_export
    self.road203 = self.root.run2_export.road203_export
    self.road204 = self.root.run2_export.road204_export
    self.road205 = self.root.run2_export.road205_export
    self.road206 = self.root.run2_export.road206_export
    self.road207 = self.root.run2_export.road207_export
    self.run3 = self.root.run3_export
    self.road301 = self.root.run3_export.road301_export
    self.road302 = self.root.run3_export.road302_export
    self.road303 = self.root.run3_export.road303_export
    self.road304 = self.root.run3_export.road304_export
    self.road305 = self.root.run3_export.road305_export
    self.road306 = self.root.run3_export.road306_export
    self.road307 = self.root.run3_export.road307_export
    self.road308 = self.root.run3_export.road308_export
    self.run4 = self.root.run4_export
    self.road401 = self.root.run4_export.road401_export
    self.road402 = self.root.run4_export.road402_export
    self.road403 = self.root.run4_export.road403_export
    self.road404 = self.root.run4_export.road404_export
    self.road405 = self.root.run4_export.road405_export
    self.road406 = self.root.run4_export.road406_export
    self.road407 = self.root.run4_export.road407_export
    self.road408 = self.root.run4_export.road408_export
    self.road409 = self.root.run4_export.road409_export
    self.monster1 = self.root.monster1_export
    self.monster1 = UIBossItem.new()
    uiMgr:configNestClass(self.monster1, self.root.monster1_export)
    self.monster2 = self.root.monster2_export
    self.monster2 = UIBossItem.new()
    uiMgr:configNestClass(self.monster2, self.root.monster2_export)
    self.monster3 = self.root.monster3_export
    self.monster3 = UIBossItem.new()
    uiMgr:configNestClass(self.monster3, self.root.monster3_export)
    self.monster4 = self.root.monster4_export
    self.monster4 = UIBossItem.new()
    uiMgr:configNestClass(self.monster4, self.root.monster4_export)

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UINode1:setData(data)

    if not data then return end
    
    self.data = data
    for i=1,4 do
        self["monster"..i]:setVisible(true)
        if data[i] then
            self["monster"..i]:setData(data[i])
            self:checkRoad(i, data[i])
        else
            self["monster"..i]:setVisible(false)
            for j=1,10 do
                if self["road"..i.."0"..j] then
                    self["road"..i.."0"..j]:setVisible(false) 
                end
                if self["road"..(i-1).."0"..j] then
                    self["road"..(i-1).."0"..j]:setVisible(false) 
                end
            end
        end
    end

    self:setRoadPic()
end

function UINode1:setRoadPic()

    local picRoad = {
        [1] = "ui_surface_icon/boss_dian.png",
        [2] = "ui_surface_icon/tboss_dian.png",
    }

    local index = 1
    if self.data[1] then
        index = self.data[1].Elite
    end

    for i=1,4 do
        for j=1,10 do
            if self["road"..i.."0"..j] then
                self["road"..i.."0"..j]:setSpriteFrame(picRoad[index])
            end
        end
    end

end


function UINode1:checkRoad(index, data)

    local isPass = false
    if data.serverData and data.serverData.lPathTime then 
        isPass = (data.serverData.lPathTime > 0)
    end

    local effectFlag = global.bossData:getEffectFlagBy(data.id)

    local temp = 0
    for i=1,10 do
        if self["road"..index.."0"..i] then
            temp = temp + 1
        end
    end

    for i=1,10 do
        if self["road"..index.."0"..i] then

            global.colorUtils.turnGray(self["road"..index.."0"..i], true)
            if isPass then
                self:roadAction(effectFlag, self["road"..index.."0"..i], i-1, temp, data)     
            end
        end
    end

    if isPass then 
        global.bossData:setEffectFlagBy(data.id, 1)
    end

end

function UINode1:roadAction(isPlay, road, i, temp, data)
    
    if (isPlay==0) and (not global.bossData:isFirstInit()) then

        road:runAction(cc.Sequence:create(cc.DelayTime:create(i*0.1), cc.CallFunc:create(function ( )
            
            global.colorUtils.turnGray(road, false)
        end), cc.ScaleTo:create(0.1, 2.5), cc.ScaleTo:create(0.1, 1), cc.CallFunc:create(function( )

            if temp == (i+1) then
                gevent:call(global.gameEvent.EV_ON_UI_BOSS_PLAY, data.id+1)
            end
        end) ))
   else
       global.colorUtils.turnGray(road, false)
   end
end

--CALLBACKS_FUNCS_END

return UINode1

--endregion
