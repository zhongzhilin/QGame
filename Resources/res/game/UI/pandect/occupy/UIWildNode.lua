--region UIWildNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildNode  = class("UIWildNode", function() return gdisplay.newWidget() end )

function UIWildNode:ctor()
    self:CreateUI()
end

function UIWildNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_wild_node")
    self:initUI(root)
end

function UIWildNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_wild_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.wild_btn = self.root.Node_2.wild_btn_export
    self.wild_icon = self.root.Node_2.wild_btn_export.wild_icon_export
    self.perhour_speed = self.root.Node_2.perhour_speed_mlan_10.perhour_speed_export
    self.rest_time = self.root.Node_2.rest_num_mlan_6.rest_time_export
    self.wild_name = self.root.Node_2.wild_name_export
    self.posX = self.root.Node_2.posX_export
    self.posY = self.root.Node_2.posY_export
    self.go_target = self.root.Node_2.go_target_export
    self.addHeroBtn = self.root.Node_2.garrison_mlan_6.addHeroBtn_export
    self.choose_hero = self.root.Node_2.garrison_mlan_6.choose_hero_export
    self.pic = self.root.Node_2.garrison_mlan_6.choose_hero_export.pic_export
    self.hero_quality = self.root.Node_2.garrison_mlan_6.choose_hero_export.hero_quality_export

    uiMgr:addWidgetTouchHandler(self.wild_btn, function(sender, eventType) self:gpsLocation(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.addHeroBtn, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.addHeroBtn:setSwallowTouches(false)
    self.wild_btn:setSwallowTouches(false)
    self.go_target:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIWildNode:setData(data)
   
    self.data = data
    local resData = global.luaCfg:get_wild_res_by(data.lKind)
    self.resData = resData
    self.wild_name:setString(resData.name)
    local surfaceData = global.luaCfg:get_world_surface_by(resData.file)
    local designerData = luaCfg:get_wild_res_by(self.data.lKind)
    global.panelMgr:setTextureFor(self.wild_icon,surfaceData.worldmap)

    local worldConst = require("game.UI.world.utils.WorldConst")
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(pos.x)
    self.posY:setString(pos.y)
    -- self.perhour_speed:setString(string.format("%s%s", data.lCollectSpeed or 0, global.luaCfg:get_local_string(10076) ))
    local add = data.lCollectSpeed and data.lCollectSpeed - resData.yield or 0
    add = add == 0 and "" or ("+"..add)
    global.uiMgr:setRichText(self, "perhour_speed", 50249, {basics = resData.yield, addnum = add})

    -- self:checkTime() -- 野地剩余时间
    self:heroGarrison()

    if not self.data.lCollectSpeed then

        self.rest_time:setString(designerData.allres - self.data.lCollectCount)  
    else
        local cutTime = global.dataMgr:getServerTime() - (self.data.lCollectStart or 0) 
        local speed = self.data.lCollectSpeed / 3600
        local alreadyGet = speed * cutTime + (self.data.lPlusRes or  0)
        local hp = math.ceil(designerData.allres - alreadyGet - self.data.lCollectCount)
        self.rest_time:setString(hp)
    end
    
   

    global.tools:adjustNodePosForFather(self.perhour_speed:getParent(),self.perhour_speed)
    
end

function UIWildNode:heroGarrison()
    -- body
    self.choose_hero:setVisible(false)
    self.addHeroBtn:setVisible(true)

    local troopsData = global.troopData:getTroopsByCityId(self.data.lResID)
    if #troopsData > 0 then
        local heroData = troopsData[1].lHeroID or {}
        if heroData[1] and heroData[1] > 0  then
            self.addHeroBtn:setVisible(false)
            self.choose_hero:setVisible(true) 
            local pro = global.heroData:getHeroPropertyById(heroData[1])
            if pro then --防止报错 。
                global.panelMgr:setTextureFor(self.pic, pro.nameIcon)
                self.hero_quality:setVisible(pro.quality ~=  1)
            end 
        end
    end
end

function UIWildNode:checkTime()

    local designerData = luaCfg:get_wild_res_by(self.data.lKind)
    local currSvrTime = global.dataMgr:getServerTime()
    local maxHp = designerData.waste
    self.lEndTime = maxHp*designerData.consume + self.data.lFlushTime

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIWildNode:countDownHandler(dt)
    if not self.lEndTime then 
        -- protect 
        return 
    end 
    if self.lEndTime <= 0 then
        self.rest_time:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = math.floor(self.lEndTime - curr)
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        return
    end
    self.rest_time:setString(global.funcGame.formatTimeToHMS(rest))

    global.tools:adjustNodePosForFather(self.rest_time:getParent(),self.rest_time)

end

function UIWildNode:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIWildNode:gpsLocation(sender, eventType)
end

function UIWildNode:gpsHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPandectPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then  
        if sPanel.isPageMove then 
            return
        end

        global.guideMgr:setStepArg({id = self.data.lResID,isWild = 1})
        gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_PANDECT)
    end
end
--CALLBACKS_FUNCS_END

return UIWildNode

--endregion
