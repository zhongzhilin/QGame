--region UIBossItem.lua
--Author : yyt
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBossItem  = class("UIBossItem", function() return gdisplay.newWidget() end )

function UIBossItem:ctor()
end

function UIBossItem:CreateUI()
    local root = resMgr:createWidget("boss/boss_icon")
    self:initUI(root)
end

function UIBossItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "boss/boss_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.NodeStar = self.root.NodeStar_export
    self.starDone1 = self.root.NodeStar_export.starDone1_export
    self.starDone2 = self.root.NodeStar_export.starDone2_export
    self.starDone3 = self.root.NodeStar_export.starDone3_export
    self.limit = self.root.limit_export
    self.Button_1 = self.root.Button_1_export
    self.icon = self.root.Button_1_export.icon_export
    self.name = self.root.Button_1_export.name_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:clickHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.Button_1:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBossItem:onEnter()
    
    self.nodeTimeLine = resMgr:createTimeline("boss/boss_icon")
    self.root:runAction(self.nodeTimeLine)
end

-- Elite 1关卡 2副本
function UIBossItem:setData(data)

    self.NodeStar:setVisible(data.Elite == 1)
    self.limit:setVisible(false)

    self.data = data
    local wild = luaCfg:get_wild_monster_by(data.monsterID)
    local wildData = luaCfg:get_world_surface_by(wild.file)
    self.wildData = wildData
    -- self.icon:setSpriteFrame(wildData.uimap)

    global.panelMgr:setTextureFor(self.icon,wildData.uimap)
    self.name:setString(data.name)
   
    local isUnlock = false
    if data.Front == 0 then
        isUnlock = true
    else
        -- 普通boss
        local frontData = global.bossData:getDataById(data.Front)
        if frontData.serverData and frontData.serverData.lPathTime  then -- and data.Elite == 1 then 
            isUnlock = (frontData.serverData.lPathTime > 0)
        end

        -- 极限boss
        -- if frontData.serverData and frontData.serverData.lDuration and data.Elite == 2 then 
        --     isUnlock = frontData.serverData.lDuration > 0 and  frontData.serverData.lDuration <= data.StarsTime
        -- end

    end

    self.isUnlock = isUnlock
    if isUnlock then
        
        self:isPlayState(false)
        local isPlay = 0
        if data.serverData then
            local starNum = 0
            local curScale = data.serverData.lPathPower or 0
            local curPathTime = data.serverData.lDuration or 0
            local curPassTime = data.serverData.lPathTime or 0

            if curScale > 0 and curScale <= data.StarsScale then
                starNum = starNum + 1
            end
            if curPathTime > 0 and curPathTime <= data.StarsTime then
                starNum = starNum + 1

            end
            if curPassTime > 0 then
                starNum = starNum + 1

                -- 极限boss 通关(打的时间小于要求规模时间)
                self.limit:setVisible(data.Elite ~= 1) 
            end
            self:checkStar(starNum)

        else
            self:checkStar(0)
            local effectFlag = global.bossData:getEffectFlagBy(self.data.id-1)
            if (effectFlag == 0) and (not global.bossData:isFirstInit()) then
                isPlay = 1
            end
            global.bossData:setEffectFlagBy(self.data.id-1, 1)
        end
   
        -- 是否播放动画
        if isPlay == 0 then
            self:isPlayState(true)
        end
        self.Button_1:setOpacity(255)
    else
        
        self:isPlayState(false)
        self:checkStar(0)
        self.Button_1:setOpacity(180)
    end
 
    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_PLAY, function (event, playId)

        if self.data.id == playId then
            self.nodeTimeLine:play("animation0", false)
        end
    end) 
end

function UIBossItem:isPlayState(isUnlock)
    
    if isUnlock then

        self.nodeTimeLine:gotoFrameAndPause(105)
        self.name:setTextColor(gdisplay.COLOR_WHITE)
    else

        self.name:setTextColor(cc.c3b(168,170,169))
        self.nodeTimeLine:gotoFrameAndPause(0)
    end

end

function UIBossItem:checkStar(num)
    
    for i=1,3 do
        if i <= num then
            self["starDone"..i]:setVisible(true)
        else
            self["starDone"..i]:setVisible(false)
        end
    end
end

function UIBossItem:clickHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIBossPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end
    
        --if self.isUnlock then      
            gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_"..self.wildData.id)       
            local bosMonPanel = global.panelMgr:openPanel("UIBosMonstPanel")
            bosMonPanel.isBossItem = true
            bosMonPanel:setData(self.data, nil, not self.isUnlock)
        -- else
        --     global.tipsMgr:showWarning("225")
        --end
    end
end
--CALLBACKS_FUNCS_END

return UIBossItem

--endregion
