
local crypto   = require "hqgame"
local datetime = require "datetime"
local msgpack = require "msgpack"
local app_cfg = require "app_cfg"
local gm_console = require("dev.gm_console")

local DbgPanel = class("DbgPanel", 
    function() return gdisplay.newColorLayer(cc.c4b(128, 162, 232, 151)) end)
    
DbgPanel.instance = nil
DbgPanel.visible = true 
DbgPanel.subNode = nil
DbgPanel.input01 = nil
DbgPanel.input02 = nil
DbgPanel.input03 = nil
DbgPanel.bshow = true

local PanelCfg = {
    tabHight = 20, gap = 10, line = 15,
    mainSize = {w = 840, h = 600},
    menuSize = {w = 820, h = 200},
    outSize  = {w = 600, h = 350},
}

local tempNode
local heroList
local heroIndex

local createScrollView = function(w, h)
    local scrollView = cc.ScrollView:create()
    scrollView:setViewSize(cc.size(w, h))
    scrollView:setPosition(cc.p(0, 0))
    scrollView:ignoreAnchorPointForPosition(true)
    local containerNode = cc.Node:create()
    containerNode:setContentSize(cc.size(w, h))
    scrollView:setContainer(containerNode)
    scrollView:updateInset()
    scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL )
    scrollView:setClippingToBounds(true)
    scrollView:setBounceable(true)
    scrollView:setDelegate()
    return scrollView
end

local allses = 100
local function testHttp(host, n)
    local stat = {}
    for i = 1, n do 
        allses = allses + 1
        local idx = allses
        local request = gnetwork.createHTTPRequest(function(event)
            local ok = (event.name == "completed")
            local request = event.request
            
            if not ok then
                -- 请求失败，显示错误代码和错误消息
                log.debug("http %d req failed:%s,%d,%s", idx, event.name, request:getErrorCode(), request:getErrorMessage())
                return
            end
            
            local code = request:getResponseStatusCode()
            stat[i].r = datetime.clock()
            log.debug("http %d, %s, %s, %d", idx, stat[i].e - stat[i].s, stat[i].r - stat[i].s, code)
            --log.debug("REQUEST - getResponseHeadersString() =\n%s", event.request:getResponseHeadersString())
            
        end, host, "GET")
        --log.debug("---------------s %d:%s", i,  datetime.clock())
        stat[i] = {}
        stat[i].s = datetime.clock()
        request:start()
        --log.debug("---------------e %d:%s", i, datetime.clock()) 
        stat[i].e = datetime.clock()
    end    
end

local tcpses = 9000
local function testTcp(n)
    local stat = {}
    for i = 1, n do
        tcpses = tcpses + 1
        local tidx = tcpses
        local function rsp_test(res, idx, str)
            stat[i].r = datetime.clock()
            log.debug("tcp %d, %s, %s", tidx, stat[i].e - stat[i].s, stat[i].r - stat[i].s)
        end
        stat[i] = {}
        stat[i].s = datetime.clock()        
        global.netRpc:Call("gmcmd", "test", rsp_test, "test") 
        stat[i].e = datetime.clock()
    end
    
end

local function getGmBtns()
    local cmd_list = gm_console:getCmdList()
    local btns = {}

    for i, cmdItem in ipairs(cmd_list) do 
        local function sendGM(tag, sender)
            
            local params = DbgPanel.getInputs()
            local ret, msg = gm_console:send_gm(cmdItem, params)
            DbgPanel.dbgTrace(msg)
        end

        local btn = {}
        btn.text = cmdItem.desc
        btn.exec = sendGM
        table.insert(btns, btn)
    end

    return btns
end

local mainMenu = {
    
    {
        text = "战斗",  gmlv = 99,
        btns = {   
            { text = "Win", exec = function(tag, sender) 
                global.gameReq:GmCmd("set_battle_check_flag", false)
                BattlefieldManager:getInstance():Win()
            end
            },
            { text = "Lose", exec = function(tag, sender) 
                BattlefieldManager:getInstance():Lose()
            end
            },
            { text = "开启战斗日志", exec = function(tag, sender) 
                BattlefieldManager:getInstance():OpenBattleLog()
            end
            },
            { text = "关闭战斗日志", exec = function(tag, sender) 
                BattlefieldManager:getInstance():CloseBattleLog()
            end
            },          
            { text = "开战斗Debug", exec = function(tag, sender)
                BattlefieldManager:getInstance():ShowDebug()
            end
            },
            { text = "关战斗Debug", exec = function(tag, sender)
                BattlefieldManager:getInstance():HideDebug()
            end
            },
            { text = "设置受伤闪烁时间", exec = function(tag, sender)                
                local timeText = DbgPanel.input01:getText()
                local timeNum = tonumber(timeText)
                BattlefieldManager:getInstance():SetBlinkTime(timeNum)
            end
            },
            { text = "设置受伤闪烁颜色1", exec = function(tag, sender)              
                local colorText = DbgPanel.input01:getText()
                local colorArr = string.split(colorText, ",")
                log.debug("===========> colorText %s, colorArr %s", colorText, vardump(colorArr))
                local r, g, b = tonumber(colorArr[1]), tonumber(colorArr[2]), tonumber(colorArr[3])
                BattlefieldManager:getInstance():SetBlinkColor1(r, g, b)
            end
            },
            { text = "设置受伤闪烁颜色2", exec = function(tag, sender)       
                local colorText = DbgPanel.input01:getText()
                local colorArr = string.split(colorText, ",")
                local r, g, b = tonumber(colorArr[1]), tonumber(colorArr[2]), tonumber(colorArr[3])
                BattlefieldManager:getInstance():SetBlinkColor2(r, g, b)
            end
            },
            { text = "设置受伤闪烁透明", exec = function(tag, sender)       
                local alpha = tonumber(DbgPanel.input01:getText())
                BattlefieldManager:getInstance():SetBlinkAlpha(alpha)
            end
            },
            { text = "设置战斗速度", exec = function(tag, sender)      
                local speed = tonumber(DbgPanel.input01:getText())
                BattlefieldManager:getInstance():SetBattleSpeed(speed)
            end
            },
             { text = "开启碰撞区域", exec = function(tag, sender)                      
                BattlefieldManager:getInstance():ShowImpact()
            end
            },
            { text = "FPS开", exec = function(tag, sender)
                cc.Director:getInstance():setDisplayStats(true)              
            end
            },
            { text = "FPS关", exec = function(tag, sender)
                cc.Director:getInstance():setDisplayStats(false)
            end
            },
            { text = "FPS30", exec = function(tag, sender)
                cc.Director:getInstance():setAnimationInterval(1.0/30.0) 
            end
            },
            { text = "FPS60", exec = function(tag, sender)
                cc.Director:getInstance():setAnimationInterval(1.0/60.0) 
            end
            },    
            { text = "FPS设置", exec = function(tag, sender)
                local fps = tonumber(DbgPanel.input01:getText())
                if fps > 0 then
                    cc.Director:getInstance():setAnimationInterval(1.0/fps) 
                end
            end
            },    
            { text = "结束PVP", exec = function(tag, sender)
                global.battleApi:BattleEnd(1, function(ret)
                    log.debug("=================> BattleEnd %s", ret)
                end)
            end
            },    
            { text = "测试飞机", exec = function(tag, sender)   
                local degree = tonumber(DbgPanel.input01:getText()) or 30
                local spd = tonumber(DbgPanel.input02:getText()) or 200
                local s = cc.Director:getInstance():getRunningScene()
                local sSize = s:getContentSize()
                local x1, y1
                x1 = sSize.width / 4 + math.random(sSize.width / 2)
                y1 = math.random(sSize.height)
                
                BattlefieldManager:getInstance():TestPlane(x1, y1, degree, spd)
                DbgPanel.visible = false
                DbgPanel.instance:setVisible(DbgPanel.visible)
            end
            },     
            { text = "测试抖屏", exec = function(tag, sender)                   
                BattlefieldManager:getInstance():ShakeAll(20, 20, 2)
                DbgPanel.visible = false
                DbgPanel.instance:setVisible(DbgPanel.visible)
                local scheduleId = nil
                local times = 0
                scheduleId = gscheduler.scheduleGlobal(function()            
                    BattlefieldManager:getInstance():ShakeAll(20, 20, 2)
                    times = times + 1
                    if times >= 4 then
                        gscheduler.unscheduleGlobal(scheduleId)
                    end
                end, 0.1)
            end
            },    
            { text = "测试正式数据", exec = function(tag, sender)
                local battleScene = require("game.Scene.BattleScene")
                battleScene.USE_NO_FAKE = true
            end
            },    
            { text = "测试语音SDK", exec = function(tag, sender)
                log.debug("=============> cc %s", vardump(cc))
                log.debug("=============> yvtool %s", vardump(yvcc))
                if yvcc then
                    log.debug("=============> yvtool.YVTool %s", vardump(yvcc.YVTool))
                end
                log.debug("=============> ct %s", vardump(ct))
            end
            }, 
            { text = "获取用户id", exec = function(tag, sender)
                log.debug("=============> %d", global.loginData:getAccId())
            end
            },   
            { text = "转化关卡数据", exec = function(tag, sender)
                local pbpack   = require "pbpack" 
                local fileUtils = cc.FileUtils:getInstance()

                local pve = global.luaCfg:pve()
                for k,v in pairs(pve) do
                    log.debug("==============> pve %s", vardump(v))
                    local stage = global.battleMgr:GetStage(v.id)
                    local stageStr = pbpack.pack(stage, "SBfStage")
                    local stageFilePath = "asset/level_pve/" .. v.id .. ".bin"
                    log.debug("==============> stageFilePath %s str len %s", stageFilePath, string.len(stageStr))

                    fileUtils:writeStringToFile(stageStr, stageFilePath)

                    stageStr = global.battleMgr:GetStageStr(v.id)
                    local stageData = pbpack.unpack(stageStr, "SBfStage")
                    log.debug("==============> stageData %s", vardump(stageData))
                    log.debug("==============> stageStr len1 %s", string.len(stageStr))
                end

                local moraleInfo = require("battle_cfg").morale_info
                local moraleInfoStr = pbpack.pack(moraleInfo, "BattleMoraleInfo")
                fileUtils:writeStringToFile(moraleInfoStr, "asset/level_pve/morale_info.bin")
            end
            },    
        },
        bgclr = cc.c4b(194, 194, 194, 255),
    },
    {
        text = "测试",  gmlv = 99,
        btns = {   
            { text = "更改开服天数", exec = function(tag, sender) 
                local days = tonumber(DbgPanel.input01:getText())
                global.gmApi:sendGMRpc("set_open_server_time", { time = tostring(days) })
            end
            },
            { text = "测试旋转", exec = function(tag, sender) 
                local sharedDirector = cc.Director:getInstance()
                local scene = TestRotateLayer:scene()
                sharedDirector:pushScene(scene)
            end
            },
            { text = "测试内存", exec = function(tag, sender) 
                global.panelMgr:openPanel("TestMemPanel")                
            end
            },
            { text = "测试Http请求", exec = function(tag, sender)     
                local text = DbgPanel.input01:getText()
                local method = "POST"
                local url = "http://portal.gmflb.net:8000"
                if text ~= "" then
                    url = text
                end
                local request = nil
                request = gnetwork.createHTTPRequest(function(event)
                    if event.name == "inprogress" then
                        return
                    end
                    
                    local ok = (event.name == "completed")
                    local request = event.request
                    
                    if not ok then
                        -- 请求失败，显示错误代码和错误消息
                        log.debug("httpcall not complete:%s, %s", request:getErrorCode(), request:getErrorMessage())
                        return
                    end
                    
                    local code = request:getResponseStatusCode()
                    if code ~= 200 then
                        -- 请求结束，但没有返回 200 响应代码
                        log.debug("httpcall error status:%s", code)
                        return
                    end
                    
                    -- 请求成功
                    local response = request:getResponseData()
                    log.debug("==========> response %s", response)
                end, url, method)                
                request:addRequestHeader("Content-Type:application/x-www-form-urlencoded")
                local postdata = "test"
                request:setPOSTData(postdata, #postdata)
                
                request:setTimeout(3)
                request:start()        
            end
            },
            { text = "打开面板", exec = function(tag, sender)    
                local text = DbgPanel.input01:getText()
                global.panelMgr:openPanel(text)
            end
            },
            { text = "打开世界场景", exec = function(tag, sender)
                global.panelMgr:openPanel("UIMapPanel")
            end
            },
            { text = "打开A*测试", exec = function(tag, sender)
                global.panelMgr:openPanel("UITestAstarPanel")
            end
            },
            { text = "测试战斗发包", exec = function(tag, sender)
                global.panelMgr:openPanel("UITestBattlePanel")
            end
            },
            { text = "重启游戏", exec = function(tag, sender)
                global.funcGame.RestartGame()
            end
            },
        },
        bgclr = cc.c4b(194, 194, 194, 255),
    },
    {
        text = "demo面板",  gmlv = 99,
        btns = {   
            { text = "英雄属性", exec = function(tag, sender) 
                global.panelMgr:openPanel("UIHeroAttributePanel")
            end
            },
        },
        bgclr = cc.c4b(194, 194, 194, 255),
    },

    {
        text = "GM",  gmlv = 99,
        btns = getGmBtns(),
        bgclr = cc.c4b(194, 194, 194, 255),
    },
    {
        text = "工具",  gmlv = 99,
        btns = {   
            { text = "显示所有道具", exec = function(tag, sender) 
                local itemTable = global.luaCfg:itemtable()
                DbgPanel.subNode:removeAllChildren()
                local subSize = DbgPanel.subNode:getContentSize()
                local scrollView = createScrollView(subSize.width, subSize.height)
                local scrollViewNode = scrollView:getContainer()
                DbgPanel.subNode:addChild(scrollView)
                local menu = cc.Menu:create()
                scrollViewNode:addChild(menu)
                local subWidth = 0
                local subHeight = 0
                cc.MenuItemFont:setFontSize(20)
                local xx = {}
                for k,v in pairs(itemTable) do
                    table.insert(xx, clone(v))
                end
                table.sort(xx, function(a, b)
                    return a.id < b.id
                end)
                for k,v in ipairs(xx) do
                    log.debug("==================> item %s", v.name)
                    local item = cc.MenuItemFont:create(v.name)
                    item:setDisabledColor(cc.c3b(32,32,64))
                    item:setColor(cc.c3b(0, 94, 94))
                    item:setEnabled(true)
                    item:registerScriptTapHandler(function()
                        local num = tonumber(DbgPanel.input01:getText())
                        num = num or 1
                        log.debug("================> add item %s id %d num %d", v.name, v.id, num)
                        global.gmApi:addItem(v.id, num)
                    end)
                    menu:addChild(item)
                    local s = item:getContentSize()
                    local tmp = subWidth + s.width + 20
                    if tmp > subSize.width then
                        subWidth = s.width + 20
                        subHeight = subHeight - s.height - 3
                    else
                        subWidth = tmp
                    end
                    item:setPosition(subWidth - s.width / 2 - 20, subHeight - s.height / 2)
                end
                menu:setPosition(0, -1 * subHeight + 50)
                scrollViewNode:setContentSize(cc.size(subSize.width, -1 * subHeight + 50))
                scrollView:updateInset()
            end
            }, 
            { text = "获取纸币", exec = function(tag, sender) 
                local itemNum = tonumber(DbgPanel.input01:getText())
                if itemNum == 0 or itemNum == nil then
                    itemNum = 99999
                end
                global.gmApi:addItem(WCONST.ITEM.TID.NOTE, itemNum)
            end
            }, 
            { text = "获取黄金", exec = function(tag, sender) 
                local itemNum = tonumber(DbgPanel.input01:getText())
                if itemNum == 0 or itemNum == nil then
                    itemNum = 99999
                end
                global.gmApi:addItem(WCONST.ITEM.TID.GOLD, itemNum)
            end
            }, 
            { text = "获取钻石", exec = function(tag, sender) 
                local itemNum = tonumber(DbgPanel.input01:getText())
                if itemNum == 0 or itemNum == nil then
                    itemNum = 99999
                end
                global.gmApi:addItem(WCONST.ITEM.TID.NORMAL_POINT, itemNum)
            end
            }, 
            { text = "获取经验", exec = function(tag, sender) 
                local itemNum = tonumber(DbgPanel.input01:getText())
                if itemNum == 0 or itemNum == nil then
                    itemNum = 99999
                end
                global.gmApi:addItem(WCONST.ITEM.TID.EXP, itemNum)
            end
            }, 
            { text = "一键设置等级", exec = function(tag, sender)
                local level = tonumber(DbgPanel.input01:getText())
                global.gmApi:sendGMRpc("onekey_level", { setlv = level })
            end
            },   
        },
        bgclr = cc.c4b(194, 194, 194, 255),
    },

    {
        text = "多语言",  gmlv = 99,
        btns = {   
            { text = "设置语言", exec = function(tag, sender) 
                global.panelMgr:openPanel("UILanguageSetting")
                DbgPanel.menuMainCallback()
            end
            },
        },
        bgclr = cc.c4b(194, 194, 194, 255),
    },
}

function DbgPanel.menuTabCallback(tag, sender)
    local glv = app_cfg.get_cli_gmlv()
    if glv > 1 then 
        return 
    end
    
    local menu = tolua.cast(sender:getParent(), "Menu")
    local tab = menu:getParent()
    tab:onTabClick(tag, sender)
end

function DbgPanel.menuMainCallback(tag, sender)
    if DbgPanel.instance ~= nil then
        if DbgPanel.visible == true then
            DbgPanel.visible = false
        else
            DbgPanel.visible = true  
        end
        
        DbgPanel.instance:setVisible(DbgPanel.visible)
    end
end

function DbgPanel.createPanel(parent, visible)
    local menu = cc.Menu:create()
    cc.MenuItemFont:setFontSize(30)
    cc.MenuItemFont:setFontName("Arial")
    local item = cc.MenuItemFont:create("DEBUG")
    item:setColor(gdisplay.COLOR_RED)
    item:registerScriptTapHandler(DbgPanel.menuMainCallback)
    menu:addChild(item)
    menu:setPosition(55, gdisplay.height - 18)
    parent:addChild(menu, 255)

    local ins = DbgPanel.new()
    parent:addChild(ins, 255)

    local mysize = ins:getContentSize()
    ins:setPosition(25, gdisplay.height - mysize.height - 30)
    
    DbgPanel.menu = menu
    DbgPanel.instance = ins
    
    visible = visible or false
    DbgPanel.visible = visible
    DbgPanel.instance:setVisible(visible)
end

function DbgPanel.dbgTrace(instr)

end

local function CreateMenu(cfg, parent)
    local width = 0
    local menu = cc.Menu:create()
    local items = {}
    
    for k, m in pairs(cfg) do
        cc.MenuItemFont:setFontSize(30)
        cc.MenuItemFont:setFontName("Arial")
        local text = m.text or "INVALID"
        local clr = gdisplay.COLOR_BLUE
        if m.default == true then
           clr = gdisplay.COLOR_WHITE 
        end
        local item = cc.MenuItemFont:create(text)
        item:setDisabledColor(cc.c3b(32,32,64))
        item:setColor(clr)
        item:setEnabled(true)
        item:registerScriptTapHandler(DbgPanel.menuTabCallback)
        local s = item:getContentSize()
        width = width + s.width + 30
        menu:addChild(item)
        
        -- 子面板
        local pan = gdisplay.newColorLayer(m.bgclr)
        pan:setContentSize(PanelCfg.menuSize.w, PanelCfg.menuSize.h)
        pan:setPosition(PanelCfg.gap, PanelCfg.mainSize.h - PanelCfg.menuSize.h - PanelCfg.tabHight * 2)
        
        -- 子面板上的按钮
        local subwidth = 0
        local submenu = cc.Menu:create()
        local yval = 18
        for sk, sm in pairs(m.btns) do
            cc.MenuItemFont:setFontSize(24)
            local subitem = cc.MenuItemFont:create(sm.text)
            subitem:setDisabledColor(cc.c3b(32,32,64))
            subitem:setColor(cc.c3b(0, 94, 94))
            subitem:registerScriptTapHandler(sm.exec)
            local s = subitem:getContentSize()
            local tmp = subwidth + s.width + 20
            if tmp > PanelCfg.menuSize.w then
                submenu:setPosition(subwidth/2 + PanelCfg.gap, PanelCfg.menuSize.h - yval)
                submenu:alignItemsHorizontallyWithPadding(20)
                pan:addChild(submenu)  
                submenu = cc.Menu:create()
                subwidth = 0
                yval = yval + s.height + 8
            end
            subwidth = subwidth + s.width + 20
            submenu:addChild(subitem)     
        end
        submenu:setPosition(subwidth/2 + PanelCfg.gap, PanelCfg.menuSize.h - yval)
        submenu:alignItemsHorizontallyWithPadding(20)
        pan:addChild(submenu)
        
        parent:addChild(pan)
        if m.default == true then
            pan:setVisible(true)
        else
            pan:setVisible(false)
        end 
        
        table.insert(items, {ptr = item, pan = pan})
        
    end
    menu:alignItemsHorizontallyWithPadding(30)
    
    return menu, items, width - 30
end

local function CreateInput(parent, pos, handler, defstr)
    defstr = defstr or  ""
    local editBoxSize = { width = 200, height = 40 }
    local textEdit = ccui.EditBox:create(editBoxSize, "Dbg_green_edit.png")
    textEdit:setPosition(pos)

    textEdit:setInputMode(0)
    textEdit:setInputFlag(1)
    textEdit:setFontName("Arial")
    textEdit:setFontSize(23)
    textEdit:setFontColor(cc.c3b(255,0,0))
    textEdit:setPlaceHolder(defstr)
    textEdit:setPlaceholderFontColor(cc.c3b(255,255,255))
    textEdit:setMaxLength(1000)
    textEdit:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --Handler
    textEdit:registerScriptEditBoxHandler(handler)
    parent:addChild(textEdit)
    
    return textEdit
end

function DbgPanel:ctor()
    self:setContentSize({ width = PanelCfg.mainSize.w, height = PanelCfg.mainSize.h })
    local menu, items, width  = CreateMenu(mainMenu, self)
    menu:setPosition(width/2 + PanelCfg.gap, PanelCfg.mainSize.h - PanelCfg.tabHight)
    self:addChild(menu) 
    self.menu = menu
    self.tabitems = items
    self:setTouchEnabled(true)

    tempNode = cc.Node:create()
    self:addChild(tempNode, 2)
    
    local outpan = gdisplay.newColorLayer(cc.c4b(151, 151, 151, 255))
    outpan:setContentSize(PanelCfg.outSize.w, PanelCfg.outSize.h)
    outpan:setPosition(PanelCfg.gap, PanelCfg.gap)
    self:addChild(outpan) 

    DbgPanel.subNode = outpan

    local function editHandler(strEventName,pSender)
--        local edit = tolua.cast(pSender,"CCEditBox")
--        local strFmt = string.format("editBox %p event: %s , text:%s", edit, strEventName, edit:getText())
--        log.debug(strFmt)
    end
    
    local eposx = PanelCfg.outSize.w + 120 
    DbgPanel.input01 = CreateInput(self, { x = eposx, y = PanelCfg.outSize.h - 20}, editHandler, "Input01")
    DbgPanel.input02 = CreateInput(self, { x = eposx, y = PanelCfg.outSize.h - 80}, editHandler, "Input02")
    DbgPanel.input03 = CreateInput(self, { x = eposx, y = PanelCfg.outSize.h - 140}, editHandler, "Input03")
    
    DbgPanel.loglabel = labelOutput
end

function DbgPanel:onTabClick(tag, sender)
    for k,v in pairs(self.tabitems) do
        if v.ptr == sender then
            v.ptr:setColor(gdisplay.COLOR_WHITE)
            v.pan:setVisible(true)
        else
            v.ptr:setColor(gdisplay.COLOR_BLUE)
            v.pan:setVisible(false)
        end
    end
end

function DbgPanel.getInputs()
    local inputs = {DbgPanel.input01:getText(), DbgPanel.input02:getText(), DbgPanel.input03:getText()}
    local params = {}
    for i, str in ipairs(inputs) do
        if str ~= "" then
            table.insert(params, str)
        end
    end

    return params
end

--log.setdbgcall(DbgPanel.dbgTrace)

gDbgPanel = DbgPanel