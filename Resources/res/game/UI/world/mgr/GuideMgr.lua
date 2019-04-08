local GuideMgr = class("LineViewMgr")
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local g_worldview = nil

function GuideMgr:ctor()

    g_worldview = global.g_worldview    
end


--[[
***创建野地

***kind     类型          
***id       唯一标识                
***cityId   绑定的城池ID    默认主城id
***x        相对城池的x     默认0
***y        相对城池的y     默认0     

]]--

function GuideMgr:autoAddWild(data)

    local kind = data.kind or 30012    
    local id = data.id or 0    
    local cityId = data.cityId or self.mainId
    local pos = g_worldview.const:convertCityId2Pix(cityId)
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
    g_worldview.areaDataMgr:wildResNotify(tagWildRes)

end


--[[
***创建怪物

***kind     类型          
***id       唯一标识                
***cityId   绑定的城池ID    默认主城id
***x        相对城池的x     默认0
***y        相对城池的y     默认0     

]]--

function GuideMgr:autoAddMonster(data)

    if data.isNeedAction == nil then data.isNeedAction = true end

    local startTime = global.dataMgr:getServerTime()
    local kind = data.kind or 170011    
    local id = data.id or 0    
    local cityId = data.cityId or self.mainId
    local pos = g_worldview.const:convertCityId2Pix(cityId)
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

    g_worldview.areaDataMgr:wildObjNotify(tagWildMonster)
end


--[[
***标记已经做完了引导
]]--

function GuideMgr:autoSignGuide(data)
    
    global.userData:setGuide(true)    
end


--[[
***创建村庄

***ids       id列表
]]--

function GuideMgr:autoAddEmpty(data)

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

        local pos = g_worldview.const:convertCityId2Pix(id)
        local _x = pos.x
        local _y = pos.y
        local _szCityName = cv.szCityName
        local _id = cv.lCityID

        local res = {id = _id,x = _x,y = _y,name = _szCityName, sData = cv}
        g_worldview.mapPanel:addMapObj({waitType = "cityNode",data = res})
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

function GuideMgr:autoAddCity(data)

    local id = data.id or 0
    local name = data.name or "defaultName" 
    local state = data.state or 0
    local pos = g_worldview.const:convertCityId2Pix(id)
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

    local panel = g_worldview.mapPanel 

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
    end

    return 0
end

--[[
***开始震动

***power    振幅          默认20          
***speed    振频          默认0.05

]]--

function GuideMgr:autoStartShaky(data)

    local power = data.power or 20
    local speed = data.speed or 0.05

    local scrollView = g_worldview.worldPanel.m_scrollView    
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

function GuideMgr:autoEndShaky(data)

    local scrollView = g_worldview.worldPanel.m_scrollView        
    scrollView:stopActionByTag(12)
    scrollView:setPositionY(-65)

    return 0
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

function GuideMgr:autoEnterWorld(data)

    local id = data.id or 0    
    local name = data.name or "defaultName" 
    local state = data.state or 0
    local pos = g_worldview.const:convertCityId2Pix(id)
    local x = pos.x
    local y = pos.y
    data.avatar = data.avatar or 1
    data.lv = data.lv or 1
    data.Kind = data.Kind or 1

    self.mainId = id

    g_worldview.worldPanel:enterWorld({lCitys = {
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

function GuideMgr:autoGpsLine(data)
    
    local x = data.x or 0
    local y = data.y or 0 
    local time = data.time or 1
    local ease = data.ease or 1
    local delay = data.delay or time

    local cat = cc.Node:create()    
    global.g_worldview.mapPanel.effectNode:addChild(cat)    
    cat:scheduleUpdate(function(node,dt)

        local nextPos = cc.p(cat:getPosition())
        g_worldview.worldPanel.m_scrollView:setOffset(cc.p(nextPos.x * -1,nextPos.y * -1))
    end)
    
    cat:setPosition(g_worldview.const:convertScreenPos2Map(cc.p(gdisplay.width / 2,gdisplay.height / 2)))
    
    local moveTo = cc.MoveTo:create(time,cc.p(cc.p(x,y)))    
    
    cat:runAction(cc.Sequence:create(cc.EaseInOut:create(moveTo,ease),cc.RemoveSelf:create()))
    
    return delay
end

--[[
***显示黑屏说明

***time     显示时间    默认5秒
***des      显示文本          
***title    标题
***delay    持续时间    默认完全阻塞
***isFadeIn 是否淡入
]]--



function GuideMgr:autoShowDes(data)

    global.panelMgr:openPanel("UIGuideBGPanel"):setData(data)
    
    return data.delay or -1  
end

--[[
***延时

***time     时间

]]--

function GuideMgr:autoDelay(data)
    local time = data.time or 10
    return time
end

--[[
***拉近拉远摄像头

***scale     大小     默认0.5
***time      时间     默认0.75

]]--

function GuideMgr:autoScaleTo(data)
    
    local scale = data.scale or 0.75
    local time = data.scale or 0.5
    time = math.floor(60 * time)

    local scrollView = g_worldview.worldPanel.m_scrollView    

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
***拉近拉远摄像头

***id        定位城池id     默认主城
***time      时间           默认1
***ease      线性           默认开启，线性值为2，需要关闭设置为1

]]--

function GuideMgr:autoGpsCity(data)
    local id = data.id or self.mainId
    local time = data.time or 1
    local ease = data.ease or 2

    local cat = cc.Node:create()    
    global.g_worldview.mapPanel.effectNode:addChild(cat)    
    cat:scheduleUpdate(function(node,dt)

        local nextPos = cc.p(cat:getPosition())
        g_worldview.worldPanel.m_scrollView:setOffset(cc.p(nextPos.x * -1,nextPos.y * -1))
    end)
    cat:setPosition(g_worldview.const:convertScreenPos2Map(cc.p(gdisplay.width / 2,gdisplay.height / 2)))
    
    local target = g_worldview.mapPanel:getCityById(id) or g_worldview.mapPanel:getWildObjById(id)

    local moveTo = cc.MoveTo:create(time,cc.p(target:getPosition()))    
    
    cat:runAction(cc.Sequence:create(cc.EaseInOut:create(moveTo,ease),cc.RemoveSelf:create()))
    
    return time
end

--[[
***显示npc

***side      方向           默认0           0左边 1右边
***des       说话内容       
***npc       npc           

]]--

function GuideMgr:autoShowNpc(data)
    
    global.panelMgr:openPanel("UINPCPanel"):setData(data)
    return -1
end

--[[
***插入子剧情

***name     子剧情文件目录

]]--

function GuideMgr:autoInsertStory(data)
    
    local name = data.name
    if name then

        local tb = clone(require("game.UI.world.script." .. name)) 
        tb = table.reverse(tb)
        
        -- dump(tb,"tb..")

        for _,v in ipairs(tb) do
            table.insert(self.script,1,v)
        end

        -- dump(self.script)
    end
end

--[[
***返回主城

]]--

function GuideMgr:autoGotoMainScene(data)
    
    global.scMgr:gotoMainSceneWithAnimation()
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

function GuideMgr:autoAddTroop(data)

    local id = data.id or 4706 --**唯一ID，实验改写 
    local name = data.name or "暴君盖伊"--**部队名字，实验改写
    local time = data.time or 10
    local path = data.path or {[1] = 560051033,[2] = 560051032}

    path = table.reverse(path)

    local startTime = global.dataMgr:getServerTime()

    local troopData = {
        lAllyName = "",
        lAttackEndTime = startTime + time,
        lAttackStartTime = startTime,
        lAttackType = 2,
        lAvator = 1,
        lCityID = path[#path],
        lCityUniqueId = path,
        lCostRes = 238,
        lDstType = 1,
        lID = id,
        lKind = 1,
        lSpeed = 40,
        lState = 2,
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

    g_worldview.attackMgr:dealAttack(troopData)
    return 0
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

function GuideMgr:autoAddEffect(data)

    local x = data.x or 0
    local y = data.y or 0

    if data.isLoop == nil then data.isLoop = true end

    local isLoop = data.isLoop
    local id = data.id or 0
    local file = data.file
    local animation = data.animation or "animation0"
    local panel = g_worldview.mapPanel

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

function GuideMgr:autoAddScreenEffect(data)
        
    local x = data.x or 0
    local y = data.y or 0
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

function GuideMgr:autoRemoveEffect(data)
    
    local id = data.id or 0
    g_worldview.mapPanel.effectNode:removeChildByTag(id)    
    global.panelMgr:getPanel(self.effectBindPanel[id]):removeChildByTag(id)    
end

--[[
***播放音效

***key      音效key

]]--
function GuideMgr:autoPlaySound(data)
    
    local key = data.key or ""
    gevent:call(gsound.EV_ON_PLAYSOUND,key)
end

--[[
***播放音乐

***key      音乐key

]]--
function GuideMgr:autoPlayMusic(data)
    
    local key = data.key or ""
    gsound.playBgm(key,true,false,0)
end

--[[
***更新特效

***id           特效唯一id
***animation    动画名称 
***isLoop       是否循环        默认循环

]]--
function GuideMgr:autoUpdateEffect(data)

    if data.isLoop == nil then data.isLoop = true end

    local id = data.id
    local animation = data.animation or "animation"
    local isLoop = data.isLoop

    local target = g_worldview.mapPanel.effectNode:getChildByTag(id) or global.panelMgr:getPanel(self.effectBindPanel[id]):getChildByTag(id)

    if target then

        target.timeLine:setLastFrameCallFunc(function()
        
            if not isLoop then
                
                target:removeFromParent()                
            end
        end)

        target.timeLine:play(animation,isLoop)
    end
end

function GuideMgr:autoAddModel(data)

    global.uiMgr:addTopModal()
end

function GuideMgr:handleTask(task)

    print("handle" .. task.key)
    return self["auto" .. task.key](self,task.data or {}) or 0
end

function GuideMgr:stop()
    
    global.stopDelayCallFunc(self.scheduleID)
    global.userData:setWorldCityID(self.worldCityId)
end

function GuideMgr:dealScript()
    
    if #self.script == 0 then return end

    local task = self.script[1]
    table.remove(self.script,1)

    local delayTime = self:handleTask(task)
    if delayTime > 0 then
        self.scheduleID = global.delayCallFunc(self.dealScript,self,delayTime)       
    elseif delayTime ~= -1 then

        self:dealScript()
    end    
end

function GuideMgr:play(storyName)

    self.worldCityId = global.userData:getWorldCityID()
    self.effectBindPanel = {}

    local tb = require("game.UI.world.script." .. storyName)
    self.script = clone(tb)
    self:dealScript()
end

return GuideMgr
