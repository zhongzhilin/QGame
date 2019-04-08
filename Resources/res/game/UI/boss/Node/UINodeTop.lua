--region UINodeTop.lua
--Author : yyt
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBossItem = require("game.UI.boss.UIBossItem")
--REQUIRE_CLASS_END

local UINodeTop  = class("UINodeTop", function() return gdisplay.newWidget() end )

function UINodeTop:ctor()
    
end

function UINodeTop:CreateUI()
    local root = resMgr:createWidget("boss/boss_loop_top")
    self:initUI(root)
end

function UINodeTop:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_loop_top")

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
    self.monster1 = self.root.monster1_export
    self.monster1 = UIBossItem.new()
    uiMgr:configNestClass(self.monster1, self.root.monster1_export)
    self.monster2 = self.root.monster2_export
    self.monster2 = UIBossItem.new()
    uiMgr:configNestClass(self.monster2, self.root.monster2_export)

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UINodeTop:setData(data)
    
    self.data = data
    self.run1:setVisible(true)
    for i=1,2 do
        self["monster"..i]:setVisible(true)
        if data[i] then
            self["monster"..i]:setData(data[i])
            self:checkRoad(i, data[i])
        else
            self["monster"..i]:setVisible(false)
            if i==2 then
                self.run1:setVisible(false)
            end
        end
    end
   self:setRoadPic()
end

function UINodeTop:setRoadPic()

    local picRoad = {
        [1] = "ui_surface_icon/boss_dian.png",
        [2] = "ui_surface_icon/tboss_dian.png",
    }

    local index = 1
    if self.data[1] then
        index = self.data[1].Elite
    end

    for j=1,7 do
        if self["road10"..j] then
            self["road10"..j]:setSpriteFrame(picRoad[index])
        end
    end

    

end

function UINodeTop:checkRoad(index, data)

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

function UINodeTop:roadAction(isPlay, road, i, temp, data)
    
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

return UINodeTop

--endregion
