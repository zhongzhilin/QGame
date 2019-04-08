--region UINodeBottom.lua
--Author : yyt
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBossItem = require("game.UI.boss.UIBossItem")
--REQUIRE_CLASS_END

local UINodeBottom  = class("UINodeBottom", function() return gdisplay.newWidget() end )

function UINodeBottom:ctor()
    
end

function UINodeBottom:CreateUI()
    local root = resMgr:createWidget("boss/boss_loop_lower")
    self:initUI(root)
end

function UINodeBottom:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_loop_lower")

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
    self.run2 = self.root.run2_export
    self.road201 = self.root.run2_export.road201_export
    self.road202 = self.root.run2_export.road202_export
    self.road203 = self.root.run2_export.road203_export
    self.road204 = self.root.run2_export.road204_export
    self.road205 = self.root.run2_export.road205_export
    self.run3 = self.root.run3_export
    self.road301 = self.root.run3_export.road301_export
    self.road302 = self.root.run3_export.road302_export
    self.road303 = self.root.run3_export.road303_export
    self.road304 = self.root.run3_export.road304_export
    self.road305 = self.root.run3_export.road305_export
    self.road306 = self.root.run3_export.road306_export
    self.monster1 = self.root.monster1_export
    self.monster1 = UIBossItem.new()
    uiMgr:configNestClass(self.monster1, self.root.monster1_export)
    self.monster2 = self.root.monster2_export
    self.monster2 = UIBossItem.new()
    uiMgr:configNestClass(self.monster2, self.root.monster2_export)
    self.monster3 = self.root.monster3_export
    self.monster3 = UIBossItem.new()
    uiMgr:configNestClass(self.monster3, self.root.monster3_export)

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UINodeBottom:setData(data)
    if not data then return end

    self.data = data
    for i,v in ipairs(data) do
        self["monster"..i]:setData(v)
        self:checkRoad(i, v)
    end

    self:setRoadPic()
end

function UINodeBottom:setRoadPic()

    local picRoad = {
        [1] = "ui_surface_icon/boss_dian.png",
        [2] = "ui_surface_icon/tboss_dian.png",
    }

    local index = 1
    if self.data[1] then
        index = self.data[1].Elite
    end

    for i=1,3 do
        for j=1,10 do
            if self["road"..i.."0"..j] then
                self["road"..i.."0"..j]:setSpriteFrame(picRoad[index])
            end
        end
    end

end

function UINodeBottom:checkRoad(index, data)

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

function UINodeBottom:roadAction(isPlay, road, i, temp , data)
    
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

return UINodeBottom

--endregion
