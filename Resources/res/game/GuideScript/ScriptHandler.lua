local ScriptHandler = class("ScriptHandler")
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

--[[
***创建野地

***kind     类型          
***id       唯一标识                
***cityId   绑定的城池ID    默认主城id
***x        相对城池的x     默认0
***y        相对城池的y     默认0     

]]--

function ScriptHandler:autoAddWild(data)

    local kind = data.kind or 30012    
    local id = data.id or 0    
    local cityId = data.cityId or self.mainId
    local pos = global.g_worldview.const:convertCityId2Pix(cityId)
    local x = pos.x + data.x or 0
    local y = pos.y + data.y or 0
        
    local tagWildRes = {
        [1] = {
            lFlushTime = 1490275630,
            lKind = kind,
            lPosX = x,
            lPosY = y,
            lReason = 0,
            lResID = id,
            lState = 1,
            tagAtkSoldiers = {
                [1] = {
                    lID = 21081,
                    lValue = 2,
                },
                [2] = {
                    lID = 21082,
                    lValue = 3,
                },
                [3] = {
                    lID = 21091,
                    lValue = 3,
                },
                [4] = {
                    lID = 21092,
                    lValue = 2,
                },  
            }
        }
    }

   -- dump(tagWildRes)
    global.g_worldview.areaDataMgr:wildResNotify(tagWildRes)

end

--[[
***单纯标记

***step    步数     用于后台统计

]]--
function ScriptHandler:autoSignTag(data)

    if data.isWait then
        global.guideMgr:waitForNet()
    end

    global.commonApi:setFPSStep(1,global.guideMgr:getCurStep() * 1000 + (data.step or 0),data.isWait)

    if data.isWait then
        return -1
    else
        return 0
    end        
end

--[[
***单纯标记

***step    步数     用于后台统计

]]--
function ScriptHandler:autoGpsHero(data)
  
    global.panelMgr:getPanel('UIHeroPanel'):GpsHero(data.heroId)
    -- global.commonApi:setFPSStep(1,global.guideMgr:getCurStep() * 1000 + (data.step or 0))
end

--[[

***将scrollView移动到底部
]]--
function ScriptHandler:autoFixScrollView(data)
    
    local panelName = data.panelName
    local widgetName = data.widgetName

    local panel = global.panelMgr:getPanel(panelName)
    local widget = ccui.Helper:seekNodeByName(panel,widgetName)

    print(tolua.type(widget),">>>check widget type")

    widget:scrollToBottom(0,false)
end

--[[
***创建怪物

***kind     类型          
***id       唯一标识                
***cityId   绑定的城池ID    默认主城id
***x        相对城池的x     默认0
***y        相对城池的y     默认0     

]]--

function ScriptHandler:autoAddMonster(data)

    if data.isNeedAction == nil then data.isNeedAction = true end

    local startTime = global.dataMgr:getServerTime()
    local kind = data.kind or 170011    
    local id = data.id or 0    
    local cityId = data.cityId or self.mainId
    local pos = global.g_worldview.const:convertCityId2Pix(cityId)
    local x = pos.x + data.x or 0
    local y = pos.y + data.y or 0
        
    local disapperTime = startTime + 998
    if not data.isNeedAction then
        disapperTime = nil
    end

    local tagWildMonster = {
        [1] = {
            lBelongsID = 3001119,
            lBelongsType = 1,
            lDisapperTime = disapperTime,
            lFlushTime = startTime,
            lKind = kind,
            lMonsterID = id,
            lPosX = x,
            lPosY = y,
            lReason = 0,
            lState = 1,
            tagDefSoldiers = {
                [1] = {
                    lID = 23141,
                    lValue = 3,
                },
            },
        },
    }

    global.g_worldview.areaDataMgr:wildObjNotify(tagWildMonster)
end

function ScriptHandler:autoShowInfo(data)
    
    global.panelMgr:openPanel("UIComInfo"):setData(data)
    return -1
end

--[[
***打开跳过引导
]]--

function ScriptHandler:autoOpenSkipGuide()
    
    global.panelMgr:openPanel("UISkipGuidePanel")
    return 0 
end

--[[
***标记已经做完了引导
]]--

function ScriptHandler:autoSignGuide(data)

    if not data.isWait then
        global.guideMgr:waitForNet()
    end            
    
    if data.step then

        global.commonApi:setGuideStep(data.step,function(msg)

            global.guideMgr:setStepArg(msg.lPara or 0)
            -- global.guideMgr:dealScript()
        end)        
    else
    
        if global.guideMgr:getCurStep() == global.luaCfg:get_guide_stage_by(5).Key then

           global.guideMgr:setTempData(1051) 
        end

        -- global.userData:setGuide(true)    
        global.commonApi:setGuideStep(global.guideMgr:getCurStep(),function(msg)

            global.guideMgr:setStepArg(msg.lPara or 0)

        end)        
    end    

    return -1
end

--[[
***定位内城建筑
***id   建筑id
]]--

function ScriptHandler:autoGpsBuild(data)
    
    if data.idFunc then
        data.id = data.idFunc()
    end

    global.funcGame.gpsCityBuildingById(data.id,WDEFINE.SCROLL_SLOW_DT)

    return WDEFINE.SCROLL_SLOW_DT
end

--[[
***定位内城建筑
***id   建筑id
]]--

function ScriptHandler:autoOpenBuildPanel(data)
    
    if not tolua.isnull(global.g_cityView) then 
        global.g_cityView:getScrollView():stopScrolling()
    end 

    if data.idFunc then
        data.id = data.idFunc()
    end

    if not tolua.isnull(global.g_cityView) then 
        local build = global.g_cityView:getTouchMgr():getBuildingNodeBy(data.id)

        local soundKey = "city_click_"..build:getData().buildingType
        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)

        if build.__cname == "Farm" then
            build:showOperatePanel(2)
        else
            build:showOperatePanel()
        end    
    end
end

--[[
***设置滑动条的进度
***panelName    面板
***count        设置数量
]]--

function ScriptHandler:autoSetSildier(data)
    
    data.count = data.count or 1
    local panel = global.panelMgr:getPanel(data.panelName)
    panel.sliderControl:changeCount(data.count)
    if data.isChooseAll then
        panel.sliderControl:chooseAll()
    end
end

--[[
***等待滑动条滑到某个程度
***count        设置数量
]]--

function ScriptHandler:autoWaitSildier(data)
    
    local CountSliderControl = require("game.UI.common.UICountSliderControl")
    CountSliderControl.setTaskCount(data.count)
    -- local sliderControl = CountSliderControl.getTopSlider()
    -- if sliderControl then 
    --     sliderControl:setGuideEvent(function(count)
            
    --         if count >= data.count then            

    --             global.guideMgr:dealScript() 
    --             sliderControl:cleanGuideEvent()                 
    --             sliderControl.slider:setTouchEnabled(false)
    --             sliderControl.slider:setTouchEnabled(true)
    --         end
    --     end)
    -- end
    return -1
end

--[[
***禁止所有按钮点击，但是可以滑动
]]--

function ScriptHandler:autoDisableButtons(data)
    
    global.disableButton = true
end

--[[
***enable所有按钮点击，但是可以滑动
]]--

function ScriptHandler:autoEnableButtons(data)
    
    global.disableButton = false
end

--[[
***关闭面板
***panelName    面板
]]--

function ScriptHandler:autoClosePanel(data)
    
    global.panelMgr:closePanel(data.panelName)
end

function ScriptHandler:autoCloseBuildPanel(data)
    
    global.panelMgr:getPanel("BuildPanel"):onCloseHandler()
end

--[[
**关闭所有上层面板
]]--

function ScriptHandler:autoCloseAllPanel(data)
    
    global.panelMgr:closePanelExecptDown()
end

--[[
***打开签到面板
]]--

function ScriptHandler:autoOpenSignPanel(data)
    
    local dailyTaskData = global.dailyTaskData
    local register = dailyTaskData:getTagSignInfo()
    local flag = dailyTaskData:getCurDay(register.lLastSign)
    dailyTaskData:setIsFirstOnEnter()
    global.panelMgr:openPanel("UIRegisterPanel"):setData(register)
end

--[[
***创建村庄

***ids       id列表
]]--

function ScriptHandler:autoAddEmpty(data)

    local lType = data.lType or 0    

    for _,id in ipairs(data.ids) do
        local cv = {
            lBlockID = 3,
            lCityID = id,
            lKind = 1,
            lReason = 1,
            lBaseInfo = 0,
            lType = lType,
            tagWildInfo = {
                lCurHp = 400,
                lCurRound = 0,
                lMaxHp = 400,
                lStatus = 0,
            },   
            tagPlusInfo = {
                [1] = {
                    lID = 24,
                    lValue = 100,
                },
            },
        }

        local pos = global.g_worldview.const:convertCityId2Pix(id)
        local _x = pos.x
        local _y = pos.y
        local _szCityName = cv.szCityName
        local _id = cv.lCityID

        local res = {id = _id,x = _x,y = _y,name = _szCityName, sData = cv}
        global.g_worldview.mapPanel:addMapObj({waitType = "cityNode",data = res})
    end    
end

--[[
***创建城池，更新城池

***kind     类型          
***id       唯一标识             
***state    城池状态        默认0         0 普通 2 烧成
***lv       城池等级        默认1                      
***Kind     城池种族        默认1        
***avatar   敌对状态        默认0         0 中立 1 自己 2 同盟 3 联盟 4 敌对
***isNeedAction     是否要播放迁城特效

]]--

function ScriptHandler:autoAddCity(data)

    local id = data.id or 0
    local name = "defaultName" 

    if type(data.name) == "number" then
        name = global.luaCfg:get_local_string(data.name)
    elseif type(data.name) == "string" then
        name = data.name        
    end

    local state = data.state or 0
    local pos = global.g_worldview.const:convertCityId2Pix(id)
    local x = pos.x
    local y = pos.y
    local avatar = data.avatar or 0
    data.lv = data.lv or 1
    data.Kind = data.Kind or 1
    --0 中立 1 自己 2 同盟 3 联盟 4 敌对

    local cv = {
        lBaseInfo = data.lv,
        lBlockID = 4542,
        lCityID = id,
        lPosX = x,
        lPosY = y,
        lProtect = 0,
        lProtectArrived = 0,
        lReason = 0,
        lRelationFlag = 0,
        lState = state,
        lType = 0,
        szCityName = name,
        tagCityUser = {
            lAllyID = 0,
            lAvatar = avatar,
            lKind = data.Kind,
            lPowerLord = 0,
            lUserGrade = 1,
            lUserID = 0,
            szUserName = name,
        },        
    }

    local _x = cv.lPosX
    local _y = cv.lPosY
    local _szCityName = cv.szCityName
    local _id = cv.lCityID

    local panel = global.g_worldview.mapPanel 

    local target = panel:getCityById(id)
    if target then 
        target:setVisible(false)
    end

    local res = {id = _id,x = _x,y = _y,name = _szCityName, sData = cv}
    local city = panel:addMapObj({waitType = "cityNode",data = res})    
    -- target:removeFromParent()

    if data.isNeedAction then

        city:setVisible(false)

        local csb = resMgr:createCsbAction("effect/move_city", "animation0", false, true, function()
            
        end,function()
            
            city:setVisible(true)
        end)

        uiMgr:configUITree(csb)

        -- csb.Node_1.citySprite:setSpriteFrame(city:getCityIconPath({sData = cv}).worldmap)

        global.panelMgr:setTextureFor(csb.Node_1.citySprite,city:getCityIconPath({sData = cv}).worldmap)

        csb:setPosition(cc.p(city:getPosition()))

        panel.effectNode:addChild(csb)

        -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_movecity")
    end

    return 0
end

--[[
***定位控件

***panelName    面板名字          
***widgetName   控件名字          
***scaleX       手的左右方向   -1 1
***scaleY       手的上下方向   -1 1
***touchPos     要模拟的点击坐标     默认控件中心点

]]--

function ScriptHandler:autoGuide(data)
    
    global.panelMgr:openPanel("UIGuidePanel"):setData(data)    

    return -1
end


--[[
***展开说明面板

***y    注意适配          
***des  文本id

]]--

function ScriptHandler:autoCheckFPS(data)
    
    if global.funcGame:getCurrentFPS() < 15 then


        self:autoRemoveEvoEffect()

        -- local panel = global.panelMgr:openPanel("UIPromptPanel")
        -- panel:setData("CPU_picture", function()

        --     cc.Director:getInstance():resume()
        -- end)

        -- panel:setCancelCall(function()
            
        --     cc.Director:getInstance():resume()
        -- end)

        -- panel:setPanelExitCallFun(function()
            
        --     cc.Director:getInstance():resume()
        -- end)

        -- panel:setLocalZOrder(998)

        -- global.delayCallFunc(function()

        --     if global.panelMgr:isPanelOpened("UIPromptPanel") then
        --         cc.Director:getInstance():pause()
        --     end
            
        -- end,nil,0.5)
    end

end

--[[
***展开说明面板

***y    注意适配          
***des  文本id

]]--

function ScriptHandler:autoGuideDesc(data)
    
    global.panelMgr:openPanel("UIDescGuidePanel"):setData(data)

    if data.isHideTouch then

        return 0
    else

        return -1
    end
end

--[[
***关闭npc对话

]]--

function ScriptHandler:autoCloseNpcSound(data)
    
    local npcKey = global.panelMgr:getPanel("UINPCPanel"):getPreSoundKey()
    if npcKey then        
        gsound.stopEffect(npcKey)
    end

    return 0
end

--[[
***定位控件

***panelName    面板名字          
***widgetName   控件名字          
***scaleX       手的左右方向   -1 1
***scaleY       手的上下方向   -1 1
***touchPos     要模拟的点击坐标     默认控件中心点

]]--

function ScriptHandler:autoGuideRect(data)
    
    global.panelMgr:openPanel("UIGuideRectPanel"):setData(data)

    return 0
end

--[[
***隐藏大地图的进攻面板
]]--

function ScriptHandler:autoHideAttackBoard()
    
    if global.scMgr:isWorldScene() then
        global.g_worldview.worldPanel.attactInfoBoard:hideBoard()
    end

    return 0
end

--[[
***开始震动

***power    振幅          默认20          
***speed    振频          默认0.05

]]--

function ScriptHandler:autoStartShaky(data)

    local power = data.power or 20
    local speed = data.speed or 0.05

    local scrollView = global.g_worldview.worldPanel.m_scrollView    
    local action = cc.Repeat:create(cc.Sequence:create(cc.MoveBy:create(speed,cc.p(0,power)),
            cc.MoveBy:create(speed,cc.p(0,-power))),1000)
    action:setTag(12)

    self:autoEndShaky()

    scrollView:runAction(action)

    return 0
end

--[[
***结束震动

]]--

function ScriptHandler:autoEndShaky(data)

    local scrollView = global.g_worldview.worldPanel.m_scrollView        
    scrollView:stopActionByTag(12)
    scrollView:setPositionY(-45)

    return 0
end

--[[
***关闭所有特效

]]--

function ScriptHandler:autoRemoveEvoEffect(data)

    if global.g_worldview.weatherMgr then 
        global.g_worldview.weatherMgr:closeAllWeacher(true)
    end  

    self:autoRemoveEffect({id = 320})

    local citys = global.g_worldview.mapPanel:getAllCitys()    
    for _,v in ipairs(citys) do

        self:removeCityEffect(v)
    end

    return 0
end

function ScriptHandler:removeCityEffect(city)
    
    local CITY_HIDE_NODES = {"townNode","tips_node","fireNode","protect_1_","icon_city_go","protect_time","protect_2","garrison_state","randomDoorEffect","doorEffect","stop"}
    
    for _,values in ipairs(CITY_HIDE_NODES) do

        if city[values] then
           city[values]:removeFromParent() 
        end
    end
end

--[[
***进入大地图&创建主城

***kind     类型          
***id       唯一标识             
***state    城池状态        默认0         0 普通 2 烧成
***lv       城池等级        默认1                      
***Kind     城池种族        默认1        
***avatar   敌对状态        默认0         0 中立 1 自己 2 同盟 3 联盟 4 敌对
***isNeedAction     是否要播放迁城特效

]]--

function ScriptHandler:autoEnterWorld(data)

    local id = data.id or 0    
    local name = data.name or "defaultName" 
    local state = data.state or 0
    local pos = global.g_worldview.const:convertCityId2Pix(id)
    local x = pos.x
    local y = pos.y
    data.avatar = data.avatar or 1
    data.lv = data.lv or 1
    data.Kind = data.Kind or 1

    self.mainId = id

    global.g_worldview.worldPanel:enterWorld({lCitys = {
        lCityID = id,
        lPosX = x,
        lPosY = y,
        lReason = 0,
        }})

    self:autoAddCity(data) 
    return 0
end

--[[
***平移

***x        目标位置
***y        目标位置            
***time     时间              默认1
***ease     线性              默认不带线性，需要开启的话设置成2
***delay    等待时间          默认和移动时间一样

]]--

function ScriptHandler:autoGpsLine(data)

    local x = data.x or 0
    local y = data.y or 0 

    if data.posFunc then

        local pos = data.posFunc()
        x = pos.x
        y = pos.y
    end

    local time = data.time or 1
    local ease = data.ease or 1
    local delay = data.delay or time

    local cat = cc.Node:create()    
    global.g_worldview.mapPanel.effectNode:addChild(cat)    
    cat:scheduleUpdate(function(node,dt)

        local nextPos = cc.p(cat:getPosition())
        global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(nextPos.x * -1,nextPos.y * -1))
    end)
    
    cat:setPosition(global.g_worldview.const:convertScreenPos2Map(cc.p(gdisplay.width / 2,gdisplay.height / 2)))
    
    local moveTo = cc.MoveTo:create(time,cc.p(cc.p(x,y)))    
    
    cat:runAction(cc.Sequence:create(cc.EaseInOut:create(moveTo,ease),cc.RemoveSelf:create()))
    
    return delay
end

-- --[[
-- ***同步服务器路线
-- ]]--

-- function ScriptHandler:autoSyncLine(data)
    
--     local startId = data.startId or data.startIdFunc()
--     local endId = data.endId or data.endIdFunc()


-- end

--[[
***刷新当前世界屏幕
]]--



function ScriptHandler:autoFlushWorld(data)

    global.g_worldview.areaDataMgr:flushCurrentScreen(nil,true,true)
end

--[[
***显示黑屏说明

***time     显示时间    默认5秒
***des      显示文本          
***title    标题
***delay    持续时间    默认完全阻塞
***isFadeIn 是否淡入
]]--



function ScriptHandler:autoShowDes(data)

    global.panelMgr:openPanel("UIGuideBGPanel"):setData(data)
    
    return data.delay or -1  
end


--[[
***开启红屏

]]--

function ScriptHandler:autoFlushTroopPanel(data)
    
    global.panelMgr:getPanel("UITroopPanel"):setData()
    return 0
end

--[[
***开启红屏

]]--

function ScriptHandler:autoShowRedScreen(data)
    
    global.panelMgr:openPanel("UIAttackEffect")
    return 0
end

--[[
***维护左侧面板

]]--

function ScriptHandler:autoInsertAttackBoard(data)
    
    local startTimeServer = global.dataMgr:getServerTime()
    if type(data.desc) == 'number' then
        data.desc = luaCfg:get_local_string(data.desc)
    end

    global.g_worldview.worldPanel.attactInfoBoard:removeAttactBoard(data.troopId or 1002)

    global.g_worldview.worldPanel.attactInfoBoard:insertAttactBoard({
        attackTime = data.time or 10,
        startTime = startTimeServer,
        troopData = {
            lArrived = 1506416596,
            lDst = 610350899,
            lDstType = 0,
            lHeroID = 0,
            lParty = 1,
            lPurpose = 2,
            lReason = 0,
            lSpeedUp = 0,
            lSrc = 610340538,
            lSrcType = 0,
            lStart = 1506416540,
            lStatus = 1,
            lTroopID = 91620,
            lUserID = 4010526,
            lWildKind = 0,
            szDstName = "小村庄",
            szSrcName = "小村庄",
            szUserName = "GuibeOudet",
        },
        troopId = data.troopId or 1002,
        uiInfo = {
            cityId = 610350899,
            icon_path = "ui_surface_icon/world_team_type1.png",
            is_show_speed = true,
            lWildKind = 0,
            title_str = data.desc or 'no desc',
        },
    },"attack")

    -- global.delayCallFunc(function()
    --     global.g_worldview.worldPanel.attactInfoBoard:removeAttactBoard(data.troopId or 1002)
    -- end,nil,data.time or 10)

    return 0
end

--[[
***关闭红屏

]]--

function ScriptHandler:autoCloseRedScreen(data)
    
    global.panelMgr:closePanel("UIAttackEffect")
    return 0
end

--[[
***延时

***time     时间

]]--

function ScriptHandler:autoDelay(data)
    local time = data.time or 10
    return time
end

--[[
***判断是否需要等待loaddone 
注意！！！
这个不能作为进入大地图的事件

]]--

function ScriptHandler:autoWaitForWorldLoad(data)
    
    if data.widgetNameFunc then
        data.widgetName = data.widgetNameFunc()
    end

    if global.scMgr:isMainScene() then
        return self:autoWait({taskEvent = global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE})
    end

    local worldPanel = global.g_worldview.worldPanel
    if ccui.Helper:seekNodeByName(worldPanel,data.widgetName) then

        return 0
    else

        return self:autoWait({taskEvent = global.gameEvent.EV_ON_UI_LOOP_ADDCHILD_DONE})
    end
end

--[[
***拉近拉远摄像头

***scale     大小     默认0.5
***time      时间     默认0.75

]]--

function ScriptHandler:autoScaleTo(data)
    
    local scale = data.scale or 0.75
    local time = data.scale or 0.5
    time = math.floor(60 * time)

    local scrollView = global.g_worldview.worldPanel.m_scrollView    

    scrollView:setMinScale(0)
    scrollView:setMaxScale(10)

    local node = cc.Node:create()
    scrollView:addChild(node)

    local zoomScale = scrollView:getZoomScale()
    local cutScale = (scale - zoomScale) / time

    node:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()

        local resScale = scrollView:getZoomScale() + cutScale
        print(resScale,"resScale",cutScale,"cutScale")

        scrollView:setZoomScale(resScale)
    end),cc.DelayTime:create(1 / 60)),time))
end

--[[
***定位大地图元素
]]--
function ScriptHandler:autoChooseCity(data)

    global.g_worldview.worldPanel:chooseCityById(data.cityId or data.cityIdFunc(),data.cityType or data.cityTypeFunc())
end

--[[
***拉近拉远摄像头

***id        定位城池id     默认主城
***time      时间           默认1
***ease      线性           默认开启，线性值为2，需要关闭设置为1

]]--

function ScriptHandler:autoGpsCity(data)

    dump(data,"gps city data")

    local id = data.id or self.mainId
    
    if data.idFunc then

        id = data.idFunc()
    end

    if data.isWildFunc then
        data.isWild = data.isWildFunc()
    end

    if data.isFast then

        -- global.g_worldview.worldPanel:chooseCityById(id,0,true)
        global.funcGame:gpsWorldCity(id,data.isWild or 0, true)

        return
    end    
    
    local time = data.time or 1
    local ease = data.ease or 2

    local cat = cc.Node:create()    
    global.g_worldview.mapPanel.effectNode:addChild(cat)    
    cat:scheduleUpdate(function(node,dt)

        local nextPos = cc.p(cat:getPosition())
        global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(nextPos.x * -1,nextPos.y * -1))
    end)
    cat:setPosition(global.g_worldview.const:convertScreenPos2Map(cc.p(gdisplay.width / 2,gdisplay.height / 2)))
    
    local target = global.g_worldview.mapPanel:getCityById(id) or global.g_worldview.mapPanel:getWildObjById(id) or global.g_worldview.mapPanel:getWildResById(id)

    if target then --protect 

        local moveTo = cc.MoveTo:create(time,cc.p(target:getPosition()))    
    
        cat:runAction(cc.Sequence:create(cc.EaseInOut:create(moveTo,ease),cc.RemoveSelf:create()))

    end 

    return time
end

--[[
***显示npc

***side      方向           默认0           0左边 1右边
***des       说话内容       
***npc       npc           

]]--

function ScriptHandler:autoShowNpc(data)
    
    global.panelMgr:openPanel("UINPCPanel"):setData(data)
    return -1
end

--[[
***设置panel的自定义model
***panelName     
***isHide       是否开启     默认开启     
]]--

function ScriptHandler:autoSetPanelModel(data)
    
    local panel = global.panelMgr:getPanel(data.panelName)
    panel.guide:setVisible(not data.isHide)

    return data.time or 0
end

--[[
***插入子剧情

***name     子剧情文件目录

]]--

function ScriptHandler:autoInsertStory(data)
    
    local index = ''
    if global.guideMgr:checkEventTarget(data.targets or {}) then
        index = ''
    else
        index = 'Other'
    end

    local name = data['name' .. index]
    local tbdata = data['data' .. index]
    if name or tbdata then

        local tb = tbdata or clone(require("game.GuideScript.Scripts." .. name)) 
        tb = table.reverse(tb)

        for _,v in ipairs(tb) do
            table.insert(global.guideMgr.script,1,v)
        end
    end
end

--[[
***返回主城

]]--

function ScriptHandler:autoGotoMainScene(data)
    
    global.scMgr:gotoMainSceneWithAnimation()    
    global.guideMgr:setTaskEvent(global.gameEvent.EV_ON_ENTER_MAIN_SCENE)
    return -1
end

--[[
***移除部队

]]--

function ScriptHandler:autoRemoveTroop(data)
    local id = data.id or 4706 --**唯一ID，实验改写 
    if global.g_worldview and global.g_worldview.attackMgr then
        global.g_worldview.attackMgr:removeTroop(id)
    end
    global.g_worldview.worldPanel.attactInfoBoard:removeAttactBoard(id)

end

--[[
** 创建
]]--

function ScriptHandler:autoLog(data)
    
    global.tipsMgr:showWarningText(type(data.desc) == 'function' and data.desc() or data.desc)

    return 0
end

--[[
** 创建
]]--

function ScriptHandler:autoFixTask(data)
    
    -- 之所以要延时一帧，是因为 在一些引导步骤里，做了 （引导期间不做处理的）判断，而fixTask又是引导的最后一步，所以可以这么处理
    global.delayCallFunc(function()

        global.funcGame.handleQuickTask(-1)
    end,nil,0)

    return 0
end

--[[
** 创建
]]--

function ScriptHandler:autoCheckVillage(data)

    -- 这里是认为只会遇到村庄引导，即worldcity必定为村庄

    local villageName = global.guideMgr:getStepArg()
    
    if string.startswith(villageName,'worldcityName') then

        --  联盟村庄跳过
        local cityId = villageName:gsub('worldcityName','')
        if global.g_worldview.mapPanel:getCityById(tonumber(cityId)):isTown() then
            return 0
        end

        -- 之所以要延时一帧，是因为 在一些引导步骤里，做了 （引导期间不做处理的）判断，而fixTask又是引导的最后一步，所以可以这么处理                    
        global.delayCallFunc(function()
            
            gevent:call(global.gameEvent.EV_ON_GUIDE_VILLAGE_GUIDE_DONE)
        end,nil,0) 
    end    

    return 0
end

--[[
** 创建
]]--

function ScriptHandler:autoCheckTrain(data)

    -- 这里是认为只会遇到村庄引导，即worldcity必定为村庄

    local buildId = global.guideMgr:getStepArg()
    if buildId == 6 then
        -- 之所以要延时一帧，是因为 在一些引导步骤里，做了 （引导期间不做处理的）判断，而fixTask又是引导的最后一步，所以可以这么处理                    
        global.delayCallFunc(function()
            
            gevent:call(global.gameEvent.EV_ON_GUIDE_TRAIN_GUIDE_DONE)
        end,nil,0) 
    end
    -- if string.startswith(villageName,'worldcityName') then
    
    -- end    

    return 0
end

--[[
** 创建
]]--

function ScriptHandler:autoStartBeat(data)
    
    global.worldApi:startGuideBeat(function(msg)
        
        global.guideMgr:dealScript()
    end)   

    return -1
end

--[[
** 创建
]]--

function ScriptHandler:autoAddTroopWithServerPath(data)
    
    local startId = data.startId or data.startIdFunc()
    local endId = data.endId or data.endIdFunc()
    
    print('start startId',startId,'endId',endId)
    global.worldApi:queryPath(startId,endId,function(msg)
        
        dump(msg,'test')

        data.path = table.reverse(msg.lPaths)
        self:autoAddTroop(data)

        global.guideMgr:dealScript()
    end)    

    return -1
end

--[[
***创建部队

***time     行军时间        默认10
***path     行军路径
***id       唯一ID
***name     部队名字
***heroId   英雄ID


]]--

function ScriptHandler:autoAddTroop(data)

    local id = data.id or 4706 --**唯一ID，实验改写 
    local name = data.name or "defaultName"--**部队名字，实验改写
    if global.g_worldview and global.g_worldview.attackMgr then
        global.g_worldview.attackMgr:removeTroop(id)
    end

    if type(data.name) == "number" then
        name = global.luaCfg:get_local_string(data.name)
    elseif type(data.name) == "string" then
        name = data.name        
    end

    local time = data.time or 10
    local alreadyTime = data.alreadyTime or 0
    local path = data.path or {[1] = 560051033,[2] = 560051032}

    if data.pathFunc then

        path = data.pathFunc()
    end

    path = table.reverse(path)

    local startTime = global.dataMgr:getServerTime()

    local troopData = {
        lAllyName = "",
        lAttackEndTime = startTime + time - alreadyTime,
        lAttackStartTime = startTime - alreadyTime,
        lAttackType = 2,
        lAvator = data.avatar or 1,
        lCityID = path[#path],
        lCityUniqueId = path,
        lCostRes = 238,
        lDstType = 1,
        lID = id,
        lKind = 1,
        lSpeed = 40,
        isMonster = data.isMonster,
        lState = data.state or 2, -- 2 进攻 11 正在发生战斗
        lTarget = path[1],
        lTargetAvator = 1,
        lUserID = global.userData:getUserId(),
        lWildKind = 0,
        szName = "未命名",
        szSrcName = "小村庄",
        szTargetName = name,
        szUserName = name,--修改点3   部队名字？   
        tgWarrior = {
            [1] = {
                lCount = 53,
                lFrom = 0,
                lID = 1031,
            },
        },
    }

    if data.heroId then
        troopData.lHeroID = {
            [1] = data.heroId,
        }
    end
    if global.g_worldview and global.g_worldview.attackMgr then
        global.g_worldview.attackMgr:dealAttack(troopData)
    end
    return 0
end

--[[
***增加城池特效

***cityId   绑定的城池ID    默认主城id
***x        相对城池的x     默认0
***y        相对城池的y     默认0     
***isLoop   是否循环        默认循环
***id       特效唯一id
***file     文件名
***animation    动画名     默认 animation0

]]--

function ScriptHandler:autoAddCityEffect(data)

    local cityId = data.cityId or self.mainId
    local pos = global.g_worldview.const:convertCityId2Pix(cityId)
    local x = pos.x + (data.x or 0)
    local y = pos.y + (data.y or 0)

    if data.isLoop == nil then data.isLoop = true end

    local isLoop = data.isLoop
    local id = data.id or 0
    local file = data.file
    local animation = data.animation or "animation0"
    local panel = global.g_worldview.mapPanel

    if file then

        local csb = resMgr:createCsbAction(file, animation, isLoop, not isLoop, nil,nil)
        csb:setPosition(cc.p(x,y))
        csb:setTag(id)
        panel.effectNode:addChild(csb)
    end 
end

--[[
***增加特效

***x        特效位置
***y        特效位置
***isLoop   是否循环        默认循环
***id       特效唯一id
***file     文件名
***animation    动画名     默认 animation0

]]--

function ScriptHandler:autoAddEffect(data)

    local x = data.x or 0
    local y = data.y or 0

    if data.isLoop == nil then data.isLoop = true end

    local isLoop = data.isLoop
    local id = data.id or 0
    local file = data.file
    local animation = data.animation or "animation0"
    local panel = global.g_worldview.mapPanel

    if file then

        local csb = resMgr:createCsbAction(file, animation, isLoop, not isLoop, nil,nil)
        csb:setPosition(cc.p(x,y))
        csb:setTag(id)
        panel.effectNode:addChild(csb)
    end 
end

--[[
***增加屏幕特效

***x        特效位置
***y        特效位置
***isLoop   是否循环        默认循环
***id       特效唯一id
***file     文件名
***animation    动画名     默认 animation0

]]--

function ScriptHandler:autoAddScreenEffect(data)
        
    local x = data.x or 0
    local y = data.y or 0

    if data.yFunc then

        y = data.yFunc()
    end

    if data.xFunc then

        x = data.xFunc()
    end

    local panelName = data.panelName or "UIWorldPanel"

    if data.isLoop == nil then data.isLoop = true end

    local isLoop = data.isLoop
    local id = data.id or 0
    local file = data.file
    local animation = data.animation or "animation0"
    local panel = global.panelMgr:getPanel(panelName)

    self.effectBindPanel[id] = panelName

    if file then

        local csb = resMgr:createCsbAction(file, animation, isLoop, not isLoop, nil,nil)
        csb:setTag(id)
        csb:setPosition(cc.p(x,y))
        panel:addChild(csb)
    end 
end

--[[
***移除特效

***id       特效唯一ID

]]--

function ScriptHandler:autoRemoveEffect(data)
    
    local id = data.id or 0
    global.g_worldview.mapPanel.effectNode:removeChildByTag(id)    
    global.panelMgr:getPanel(self.effectBindPanel[id]):removeChildByTag(id)    
end

--[[
***播放音效

***key      音效key

]]--
function ScriptHandler:autoPlaySound(data)
    
    local key = data.key or ""
    if data.delay and data.delay > 0 then
        global.delayCallFunc(function()
            gevent:call(gsound.EV_ON_PLAYSOUND,key)
        end, nil, data.delay)
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,key)
    end
end

--[[
***播放音乐

***key      音乐key

]]--
function ScriptHandler:autoPlayMusic(data)
    
    local key = data.key or ""
    gsound.playBgm(key)
end

--[[
***更新特效

***id           特效唯一id
***animation    动画名称 
***isLoop       是否循环        默认循环

]]--
function ScriptHandler:autoUpdateEffect(data)

    if data.isLoop == nil then data.isLoop = true end

    local id = data.id
    local animation = data.animation or "animation"
    local isLoop = data.isLoop

    local target = global.g_worldview.mapPanel.effectNode:getChildByTag(id) or global.panelMgr:getPanel(self.effectBindPanel[id]):getChildByTag(id)

    if target then

        target.timeLine:setLastFrameCallFunc(function()
        
            if not isLoop then
                
                target:removeFromParent()                
            end
        end)

        target.timeLine:play(animation,isLoop)
    end
end

--[[
***添加模态
]]--
function ScriptHandler:autoAddModel(data)

    local node,listener = global.uiMgr:addSceneModel()
    self.modelNode = node
    global.scMgr:CurScene().model = listener
end

--[[
***释放莫泰
]]--
function ScriptHandler:autoRemoveModel(data)
    
    if self.modelNode and not tolua.isnull(self.modelNode) then

        self.modelNode:removeFromParent()
        global.scMgr:CurScene().model = nil
    end
end

--[[
***释放莫泰
]]--
function ScriptHandler:autoShowWarnning()
    
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10194, function()

        global.worldApi:setAlert(1, function(msg)
            
            global.g_worldview.mapPanel:closeChoose()
        end)        
    end)
end

--[[
***等待其他时间调用dealScript
***taskEvent 指定等待的事件
]]--
local waitPool = 0
function ScriptHandler:autoWait(data)
    
    global.guideMgr:setTaskEvent(data.taskEvent,waitPool)
    
    if data.maxTime then

        local waitID = waitPool
        global.delayCallFunc(function()

            global.guideMgr:stopWait(waitID)            
        end,nil,data.maxTime)
    end

    waitPool = waitPool + 1

    return -1
end

function ScriptHandler:ctor()
    
    self.effectBindPanel = {}
end
 
return ScriptHandler