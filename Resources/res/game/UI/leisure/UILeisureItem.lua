--region UILeisureItem.lua
--Author : yyt
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILeisureItem  = class("UILeisureItem", function() return gdisplay.newWidget() end )

function UILeisureItem:ctor()
    self:CreateUI()
end

function UILeisureItem:CreateUI()
    local root = resMgr:createWidget("leisureList/leisure_node")
    self:initUI(root)
end

function UILeisureItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "leisureList/leisure_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button_1 = self.root.Button_1_export
    self.name = self.root.Button_1_export.name_export
    self.build_icon = self.root.Button_1_export.build_icon_export
    self.satus = self.root.Button_1_export.satus_export
    self.btnSelect = self.root.btnSelect_export
    self.selectPng = self.root.btnSelect_export.selectPng_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:goHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.Button_1_export.go_btn, function(sender, eventType) self:goHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btnSelect, function(sender, eventType) self:selectHandler(sender, eventType) end, true)
--EXPORT_NODE_END

    self.root:setCascadeOpacityEnabled(true)
    self.Button_1:setSwallowTouches(false)
    self.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.posX, self.posY = 50, 40

    self.btnSelect:setSwallowTouches(false)
    self.btnSelect:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

local colors = {
    [0] = {r=87,g=213,b=63},
    [1] = {r=255,g=255,b=255},
}

function UILeisureItem:setData(data)
    
    self.data = data
    if data.id == 22 or data.id == 23  then -- plist合图 
        self.build_icon:setSpriteFrame(data.icon)
    else -- 散图
        global.panelMgr:setTextureFor(self.build_icon,data.icon)
    end
    self.build_icon:setScale(data.scale/100)
    self.name:setString(data.build)
    self.build_icon:setPosition(cc.p(self.posX+data.offsetX, self.posY))

    -- 未开启状态
    if data.state == -2 or  data.state == -3 then
        self.satus:setString(luaCfg:get_local_string(10652))
        self.satus:setTextColor(cc.c3b(colors[1].r, colors[1].g, colors[1].b)) 
    else      
        self:setState(data)
    end

    -- 野地可占领
    if data.id == 21 and data.state == 3 then
        data.parm = data.parm or {}
        local nowNum = data.parm.nowNum or 0
        local maxNum = data.parm.maxNum or 0
        self.satus:setString(data.status_3 .. " ".. nowNum .. "/" .. maxNum )
    end

    self:setSelectAll()
end

-- 当前item是否是全选状态
function UILeisureItem:setSelectAll()

    -- 编辑状态
    self.Button_1:stopAllActions()
    local curPos = 390
    if global.m_LeisurePanel.isEditState then
        local curPos1 = cc.p(curPos + 30, self.Button_1:getPositionY())
        local action = cc.MoveTo:create(0.2, curPos1)
        self.Button_1:runAction(action)
        self.btnSelect:setVisible(true)
    else
        self.Button_1:setPositionX(curPos)
        self.btnSelect:setVisible(false)
    end

    self:selectState()
end

-- 选中状态
function UILeisureItem:selectState()
    self.selectPng:setVisible(self.data.isSelected == true)
end

function UILeisureItem:checkStateColor()

    if  self.data["color_"..self.data.state] == 1 then
        self.satus:setTextColor(cc.c3b(colors[0].r, colors[0].g, colors[0].b))
    else
        self.satus:setTextColor(cc.c3b(colors[1].r, colors[1].g, colors[1].b)) 
    end
end

function UILeisureItem:setState(data)

    self:checkStateColor()

    local curState = data["status_"..data.state]
    if curState then
        if curState == "cd" then
            self:checkTime()
        elseif curState == "%s" then
            self.satus:setString(data.parm or 0)
        else
            self.satus:setString(curState)
        end      
    end
end

function UILeisureItem:checkTime()

    -- 占领野地特殊处理
    if self.data.id == 21 then
        local wildRes = self.data.parm 
        if table.nums(wildRes) > 0 then
            local designerData = luaCfg:get_wild_res_by(wildRes.lKind)
            -- local currSvrTime = global.dataMgr:getServerTime()
            -- local maxHp = designerData.waste
            -- dump(wildRes,'wildRes')
            self.lEndTime = global.dataMgr:getServerTime() + wildRes.lCollectSurplus / (wildRes.lCollectSpeed / 3600) -- maxHp*designerData.consume + wildRes.lFlushTime
        end
        self.lEndTime = self.lEndTime or 0
    else
        self.lEndTime = self.data.parm or 0
    end
    
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UILeisureItem:countDownHandler(dt)
    if self.lEndTime <= 0 then
        self:cdFinish()
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = math.floor(self.lEndTime - curr)
    if rest < 0 then
        self:cdFinish()
        return
    end
    self.satus:setString(global.funcGame.formatTimeToHMS(rest))
end

function UILeisureItem:cdFinish()

    self.satus:setString("00:00:00")
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UILeisureItem:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UILeisureItem:goHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UILeisurePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
        if global.m_LeisurePanel.isEditState then
            self:checkSelectState()
            return
        end

        if self.data.state == -2 then

            -- 占领野地
            if self.data.id == 21 then
                if global.cityData:getMainCityLevel() < 2 then
                    return global.tipsMgr:showWarning('NewGuide01')
                end
                if global.userData:getWorldCityID() == 0 and global.scMgr:isMainScene() then 
                    return global.tipsMgr:showWarning("pleaseSetUpCity")
                end
            end

            local buildsName = luaCfg:get_buildings_pos_by(self.data.unlock_building).buildsName
            local str = luaCfg:get_local_string(10653, self.data.unlock_lv, buildsName)
            global.tipsMgr:showWarning(str)
            return
        end

        if self.data.id == 1 then -- 每日任务
            local opLv = global.luaCfg:get_config_by(1).dailyTaskLv
            if not global.funcGame:checkBuildLv(1, opLv) then
                return
            end
        end

        if self.data.id == 4 then 
            local panel = global.panelMgr:openPanel("UIHeroPanel")
            panel.tabControl2:setSelectedIdx(4)
            panel:onTabButtonChanged(4)
            return 
        end 

        if self.data.id == 22 and (not global.userData:isOpenExploit()) then -- 军功
            local str = luaCfg:get_local_string(10479, global.luaCfg:get_config_by(1).exploitUnlock)
            return global.tipsMgr:showWarning(str)         
        end


        if self.data.id == 23 and self.data.state == 3 then -- 神兽
            return global.tipsMgr:showWarning("petPrompt04")
        end 

        if self.data.id == 25 and self.data.state == 3 then -- 神兽
            
            return global.tipsMgr:showWarning("pk04")
        end 


        -- 如果在世界，切到内城再打开界面
        global.panelMgr:closePanel("UILeisurePanel")

        if self.data.id == 23 then
            self:petCall()
            return
        end

        local data = clone(self.data)

        -- 直接在大地图可以打开的界面(英雄、龙潭、成就、占领野地)
        local isWorldOpen = (data.id==3 or data.id==19 or data.id==21 or data.id==4)
        if global.scMgr:isWorldScene() and (not isWorldOpen) then
            global.g_worldview.mapPanel:cleanSchedule()
            global.scMgr:setMainSceneCall(function()                                     
                global.funcGame:leiMainAndOpenPanel(data)
            end)
            global.scMgr:gotoMainSceneWithAnimation()
        else         
            global.funcGame:leiMainAndOpenPanel(self.data)
        end
    end
end

function UILeisureItem:petCall()

    local data = clone(self.data)
    if global.scMgr:isWorldScene() then
        global.g_worldview.mapPanel:cleanSchedule()
        global.scMgr:setMainSceneCall(function()                                           
            global.panelMgr:openPanel("UIPetInfoPanel"):setData(global.petData:getGodAnimalByType(data.parm1))
        end)
        global.scMgr:gotoMainSceneWithAnimation()
    else
        global.panelMgr:openPanel("UIPetInfoPanel"):setData(global.petData:getGodAnimalByType(data.parm1))
    end
end

function UILeisureItem:selectHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UILeisurePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        
        if sPanel.isPageMove then 
            return
        end
        self:checkSelectState()
    end
end

function UILeisureItem:checkSelectState()
    -- body
    self.data.isSelected = (not self.data.isSelected)
    self:selectState()
    global.m_LeisurePanel:updateItem(self.data)
end

--CALLBACKS_FUNCS_END

return UILeisureItem

--endregion
