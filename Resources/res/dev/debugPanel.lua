--region debugPanel.lua
--Author : wuwx
--Date   : 2016/07/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetSwitch = require("game.UI.set.UISetSwitch")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local debugPanel  = class("debugPanel", function() return gdisplay.newWidget() end )
local app_cfg = require "app_cfg"
local crypto  = require "hqgame"
local cjson = require "base.pack.json"

debugPanel.CC_SHOW_FPS = false

function debugPanel:ctor()
    self:CreateUI()
end

function debugPanel:CreateUI()
    local root = global.resMgr:createWidget("ui/debug_bg")
    self:initUI(root)
end

function debugPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    global.uiMgr:configUITree(self.root)
    global.uiMgr:configUILanguage(self.root, "ui/debug_bg")

    local uiMgr = global.uiMgr

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.RandomDoor_swith = UISetSwitch.new()
    uiMgr:configNestClass(self.RandomDoor_swith, self.root.ScrollView.DEBUG_BG.RandomDoor_node.RandomDoor_swith)
    self.guide_swith = UISetSwitch.new()
    uiMgr:configNestClass(self.guide_swith, self.root.ScrollView.DEBUG_BG.guide_node.guide_swith)
    self.fpsdown_swith = UISetSwitch.new()
    uiMgr:configNestClass(self.fpsdown_swith, self.root.ScrollView.DEBUG_BG.fpsdown_node.fpsdown_swith)
    self.textAccount = self.root.ScrollView.DEBUG_BG.Account_bj.textAccount_export
    self.textAccount = UIInputBox.new()
    uiMgr:configNestClass(self.textAccount, self.root.ScrollView.DEBUG_BG.Account_bj.textAccount_export)
    self.update_text = self.root.ScrollView.DEBUG_BG.update_bj.update_text_export
    self.update_text = UIInputBox.new()
    uiMgr:configNestClass(self.update_text, self.root.ScrollView.DEBUG_BG.update_bj.update_text_export)
    self.Journal_swith = UISetSwitch.new()
    uiMgr:configNestClass(self.Journal_swith, self.root.ScrollView.DEBUG_BG.Journal_node.Journal_swith)

    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.showFPS, function(sender, eventType) self:showFPS(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.onReduceSpeed, function(sender, eventType) self:onReduceSpeed(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.onAcceSpeed, function(sender, eventType) self:onAcceSpeed(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.onNormalSpeed, function(sender, eventType) self:onNormalSpeed(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.closeVoice, function(sender, eventType) self:closeVoice(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.openVoice, function(sender, eventType) self:openVoice(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.closeMusic, function(sender, eventType) self:closeMusic(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.openMusic, function(sender, eventType) self:openMusic(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.showWorld, function(sender, eventType) self:showWorld(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.newTroop, function(sender, eventType) self:newTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.wall, function(sender, eventType) self:wall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.wallValue, function(sender, eventType) self:wallValue(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.getItem, function(sender, eventType) self:getItem(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.setNoTouchMove, function(sender, eventType) self:setNoTouchMove(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.closeGuide, function(sender, eventType) self:closeGuide(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.drawGuideRect, function(sender, eventType) self:drawGuideRect(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.showDailyMission, function(sender, eventType) self:showDailyMission(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.controlLogLevel, function(sender, eventType) self:controlLogLevel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resouceSpeed, function(sender, eventType) self:resouceSpeed(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.openAllCity, function(sender, eventType) self:openAllCity(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resourceAll, function(sender, eventType) self:resourceAll(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resourceUp, function(sender, eventType) self:resourceUp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.soldierUp, function(sender, eventType) self:soldierUp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.showDailyMission_0, function(sender, eventType) self:beAttack(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.showDailyMission_0_0, function(sender, eventType) self:noAttack(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.setServerTime, function(sender, eventType) self:setServerTime(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.openBattle, function(sender, eventType) self:openBattle(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resetServerTime, function(sender, eventType) self:setServerTime(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.simTest, function(sender, eventType) self:simTest(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.simMiracle, function(sender, eventType) self:magicocc(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.getEquip, function(sender, eventType) self:getEquip(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.equipStrengthen, function(sender, eventType) self:equipStrengthen(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.OPStrengthen, function(sender, eventType) self:skipGuide(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.GetPackage_node, function(sender, eventType) self:GetPackage(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Account, function(sender, eventType) self:onModifyAccount(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.dump, function(sender, eventType) self:onOffDump(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.dump_2, function(sender, eventType) self:onOnDump(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.update, function(sender, eventType) self:onChangeUpdate(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.lvBuild, function(sender, eventType) self:upBuildLvHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.warTime, function(sender, eventType) self:fightTimeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.lordLv, function(sender, eventType) self:upLordLvHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.heroLv, function(sender, eventType) self:upHeroLvHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resourceUp_0, function(sender, eventType) self:dropTest(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resourceUp_0_0, function(sender, eventType) self:timeMachine(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.openAllCity_0, function(sender, eventType) self:buyGift(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.modifyServer, function(sender, eventType) self:onModifyServer(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resourceUp_0_0_0, function(sender, eventType) self:autokillmonster(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.resourceUp_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1.resourceUp_0_0_0_0_0, function(sender, eventType) self:resPKcount(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1.resourceUp_0_0_0_0_0_0.Text_resourceUp, function(sender, eventType) self:modify_birthday(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1.resourceUp_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1.resourceUp_0_0_0_0_0_0_0_0, function(sender, eventType) self:changeAccount(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0_0_0_0, function(sender, eventType) self:cloneTroop(sender, eventType) end)
--EXPORT_NODE_END
    self.root.ScrollView.DEBUG_BG.Node_1.resourceUp_0_0_0_0_0_0_0.Text_resourceUp:setString("删除商队")

    self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0_0_0.Text_resourceUp:setString("人工崩溃")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0_0_0, function(sender, eventType) self:onGetCrash(sender, eventType) end)

    self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0.Text_resourceUp:setString("开始新游戏")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0, function(sender, eventType) self:newGame(sender, eventType) end)

    self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0_0.Text_resourceUp:setString("开启release日志")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0_0, function(sender, eventType) self:openReleaseLog(sender, eventType) end)

    self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0.Text_resourceUp:setString("删除更新包")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:deletePatch(sender, eventType) end)

    self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0.Text_resourceUp:setString("触发隔天")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:nextDay(sender, eventType) end)


    self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0.Text_resourceUp:setString("充值测试")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0.resourceUp_0_0_0_0_0, function(sender, eventType) self:rechargeTest(sender, eventType) end)

    self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0_0.Text_resourceUp:setString("龙潭跳关")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0_0, function(sender, eventType) self:bossPassHandler(sender, eventType) end)

    self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0_0_0.Text_resourceUp:setString("切换到999")
    uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0.resourceUp_0_0_0_0_0_0_0_0, function(sender, eventType) self:switch999(sender, eventType) end)



    -- self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0.Text_resourceUp:setString("直线shader")
    -- uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0, function(sender, eventType) self:lineShader1(sender, eventType) end)

    -- self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0_0.Text_resourceUp:setString("曲线shader")
    -- uiMgr:addWidgetTouchHandler(self.root.ScrollView.DEBUG_BG.Node_1_0_0_0.resourceUp_0_0_0_0_0_0, function(sender, eventType) self:lineShader2(sender, eventType) end)

	-- local MAX_NUM_OF_PER_ROW = 4
	
	-- local idx = 0
	-- local node = cc.Node:create()
	-- self.root.ScrollView_1.btn_node = node
 --    self.root.ScrollView_1:addChild(node)
 --    local innerSize = self.root.ScrollView_1:getInnerContainerSize()
	-- for i,item in pairs(DebugData) do
 --    	local root = global.resMgr:createWidget("ui/debug_btn")
	--     global.uiMgr:configUITree(root)
	--     global.uiMgr:configUILanguage(root, "ui/debug_btn")
	--     node:addChild(root)
	--     local contentSize = root.Button_1:getContentSize()
	--    	local r = math.floor(idx/MAX_NUM_OF_PER_ROW)
	--    	local c = idx%MAX_NUM_OF_PER_ROW
	--     root:setPosition(cc.p(contentSize.width*0.5+20+c*(contentSize.width+30),innerSize.height-contentSize.height*0.5-20-r*(contentSize.height+30)))
	--     root.Button_1:setTitleText(item.name)
	--     root.Button_1:setTitleFontSize(30)

	--     global.uiMgr:addWidgetTouchHandler(root.Button_1, function(sender, eventType) 
	--     	local call = handler(self,self[item.func])
	--     	call()
	--     end)

	--     idx = idx+1
	-- end

    global.debugData = global.debugData or {}

    global.debugData.isOpenRandom = false
    self.RandomDoor_swith:setSelect(false)
    self.RandomDoor_swith:addEventListener(function(isOpen)
        
        global.debugData.isOpenRandom = isOpen
    end)
    
    self.guide_swith:addEventListener(function(isOpen)
        
        -- global.debugData.isSkipEventGuide = isOpen
        cc.UserDefault:getInstance():setBoolForKey("skip_event_guide_disabled",isOpen)
    end)
    self.guide_swith:setSelect(cc.UserDefault:getInstance():getBoolForKey("skip_event_guide_disabled",false))

    global.debugData.isFpsDown = true
    self.fpsdown_swith:setSelect(true)
    self.fpsdown_swith:addEventListener(function(isOpen)
        
        global.debugData.isFpsDown = isOpen
    end)


    self.update_text:setString(cc.UserDefault:getInstance():getStringForKey("debug_update_addr",""))

    local t_isOpen = cc.UserDefault:getInstance():getBoolForKey("debug_close_print",false)
    self.Journal_swith:setSelect(t_isOpen)
    self.Journal_swith:addEventListener(function(i_isOpen)
        
        cc.UserDefault:getInstance():setBoolForKey("debug_close_print",i_isOpen)
        if i_isOpen then
            print = function ()
                -- body
            end
            dump = function() end
        else
            print = echo
            require("res.common.base.common")
        end
    end)
end

-- function debugPanel:lineShader1()
--     -- body
--     self.menuMainCallback()
--     global.isStraightLineShader = not global.isStraightLineShader
-- end

-- function debugPanel:lineShader2()
--     -- body
--     self.menuMainCallback()
--     global.isCurveLineShader = not global.isCurveLineShader
-- end
function debugPanel:switch999()
    -- body
    cc.UserDefault:getInstance():setStringForKey("selectSever",999)
    global.tipsMgr:showWarning("使用成功!")
    global.funcGame.RestartGame()  
end


function debugPanel:bossPassHandler(sender, eventType)
    
    global.panelMgr:openPanel("UIGMGetItemPanel"):setNextData("不需要输入", "需要通关的关卡数:", function (num1, num2)
        -- body
         global.commonApi:debugCommSet(function ()
            
            global.tipsMgr:showWarning("使用成功!")

        end, 20,  num2, 0)
    end)

    self.menuMainCallback()

end

function debugPanel:rechargeTest(sender, eventType)
    self.menuMainCallback()
    
    if not global.rechargeTest then
        global.rechargeTest = true
        if global.rechargeTestAmount == 0.01 then
            global.rechargeTestAmount = 0.1
        elseif global.rechargeTestAmount == 0.1 then
            global.rechargeTestAmount = 1
        else
            global.rechargeTestAmount = 0.01
        end
        global.tipsMgr:showWarningText("开启测试充值,金额="..global.rechargeTestAmount)
    else
        global.rechargeTest = false
        global.tipsMgr:showWarningText("正常充值")
    end
end

function debugPanel:nextDay(sender, eventType)

    global.panelMgr:openPanel("UIGMGetItemPanel"):setNextData("不需要输入", "需要隔的天数:", function (num1, num2)
        -- body
         global.commonApi:debugCommSet(function ()
            
            global.loginApi:getLoginDetail(function(ret, msg)
                --登陆直通车 获取主城信息
                if ret.retcode == WCODE.OK then
                    global.dataMgr:init(msg)
                    global.scMgr:gotoMainScene()
                end
            end)

        end, 3, 0, num2)
    end)

    self.menuMainCallback()

   
end


function debugPanel:onGetCrash()

    if global.tools:isIos() then
        -- 4 Error,  3 Warning,  2 Info, 1 Debug,  0 Verbose  -1 off
        buglyLog(0, "lua调试日志", " < 自定义日志输出 >: ")
    end

    local node=global.resMgr:createWidget("city/city_11")
    global.scMgr:CurScene():addChild(node)
    -- gevent_on_memory_warning()
end

function debugPanel:openReleaseLog()
    local isOpen = cc.UserDefault:getInstance():getBoolForKey("releaseIsOpenLog",false)

    cc.UserDefault:getInstance():setBoolForKey("releaseIsOpenLog",not isOpen)
    if not isOpen then
        LogMore:setLogLevel(1)
        print = function(...)
            local arg = {...}
            local finalarg = {}
            for k,v in pairs(arg) do
                table.insert(finalarg,tostring(v))
            end
            LogMore:logError(table.concat(finalarg, "\t"))
        end
        global.tipsMgr:showWarningText("开启成功")
    else
        print = function ()
            -- body
        end
        dump = function( ... )
            -- body
        end
        global.tipsMgr:showWarningText("关闭成功")
    end
    debugPanel.menuMainCallback(btn)
end

function debugPanel:deletePatch()
    -- body
    local patchPath = cc.FileUtils:getInstance():getWritablePath().."patch/";
    cc.FileUtils:getInstance():removeDirectory(patchPath) 
end

function debugPanel:newGame()

    self.menuMainCallback()
    
    local resetCall = function ()
           
        global.sdkBridge:startNewGame(function() 

            global.sdkBridge:deleteChannelInfo()
            global.sdkBridge:setLoginBind(false)
            global.funcGame.RestartGame()   
            -- gumengSdk.profileSignOff()
        end)
        
    end

    resetCall()

end

function debugPanel:confirmFunc(errcode1, errcode2, callBack)

    local confirm = function ()
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData(errcode2, function()
            callBack()
        end)
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")                
    panel:setData(errcode1, function()
        confirm()
    end)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function debugPanel:showFPS()
    -- local i_show_times = 0
	--show dsp
    self.CC_SHOW_FPS = not self.CC_SHOW_FPS
    local director = cc.Director:getInstance()
    --turn on display FPS
    director:setDisplayStats(self.CC_SHOW_FPS)
 
    -- if CC_SHOW_FPS then
    --     i_show_times = i_show_times + 1
    --     director:setDisplayMemory(i_show_times%2==0)
    -- end

    -- -- 刷新排行榜
    -- global.commonApi:debugCommSet(function ()
    -- end, 13,0,0)

end

function debugPanel:showDailyMission()
    -- body
    global.panelMgr:openPanel("UIDailyTaskPanel")

    self.menuMainCallback()
end

function debugPanel:getItem()
    -- body

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(nil, {10867, 10868, 10869})

    self.menuMainCallback()
end


function debugPanel:newTroop()

    global.panelMgr:openPanel("UITroopPanel")

    self.menuMainCallback()
end

function debugPanel:wall()

    -- self.menuMainCallback()

    global.scMgr:gotoWorldScene()
end

function debugPanel:wallValue()

    local heros = global.heroData:getGotHeroData()
    for _,v in ipairs(heros) do

        global.itemApi:itemUse(12803,1,0,v.heroId,function(msg)
        
        end)
    end

    self.menuMainCallback()
end

--减速
function debugPanel:onReduceSpeed()
    local i_timeScale = gscheduler.sharedScheduler:getTimeScale()
    i_timeScale = i_timeScale/2
    gscheduler.sharedScheduler:setTimeScale(i_timeScale)
end
--常速
function debugPanel:onNormalSpeed()
    gscheduler.sharedScheduler:setTimeScale(1)
end
--加速
function debugPanel:onAcceSpeed()
    local i_timeScale = gscheduler.sharedScheduler:getTimeScale()
    i_timeScale = i_timeScale*2
    gscheduler.sharedScheduler:setTimeScale(i_timeScale)
end

function debugPanel:closeVoice()
    -- gsound.disableSounds()
    -- local isOpen = cc.UserDefault:getInstance():getBoolForKey("debug_remove_all_res_building",false)
    -- cc.UserDefault:getInstance():setBoolForKey("debug_remove_all_res_building",not isOpen)
    -- global.funcGame.RestartGame()
    -- gaudio.reset()
    -- global.g_worldview.mapPanel.upEffectNode:removeAllChildren()
    global.tipsMgr:showWarning("available mem="..global.funcGame:getUseMemMB()..",loading time="..global.m_loadingNetTimeCost)
end

function debugPanel:openVoice()
    -- gsound.enableSounds()
    -- local textureCache = cc.Director:getInstance():getTextureCache()
    -- local info = textureCache:getCachedTextureInfo()
    -- print(info)
    -- global.tipsMgr:showWarning(string.format("账号：%s",global.userData:getAccount()))
    -- local okCall = function(isReconnect)
    --     -- body
    --     global.techData:resumeDeal()
    --     gevent:call(global.gameEvent.EV_ON_GAME_RESUME)
    --     global.unionApi:getRedCount(function() end,nil)
    -- end
    -- global.netRpc:reconnectSocket(okcall)
    local isOpen = cc.UserDefault:getInstance():getBoolForKey("debug_open_google_recharge",false)
    cc.UserDefault:getInstance():setBoolForKey("debug_open_google_recharge",not isOpen)
    global.funcGame:RestartGame()
end

function debugPanel:closeMusic()
    -- gaudio.pauseMusic()

    for i=#global.g_all_timeline,1,-1 do
        timeline = global.g_all_timeline[i]
        if timeline and not tolua.isnull(timeline) then
            if timeline:isPlaying() then
                timeline:pause()
            else
                timeline:resume()
            end
        else
            table.remove(global.g_all_timeline,i)
        end
    end
end

local i = 1
function debugPanel:openMusic()
    -- gaudio.resumeMusic()
    -- global.netRpc:NetTestReport()
    
    global.resMgr:unloadRes()
    -- global.panelMgr:destroyAllCachePanel()
    -- if i > 6 then
    --     i = 1
    -- end
    -- global.panelMgr:getPanel("UIAccRechargePanel"):gpsTBPos(i)
    -- i=i+1

    -- global.panelMgr:getPanel("UITurntableFullPanel"):test()
    -- debugPanel.menuMainCallback()

end

function debugPanel:setNoTouchMove()
    cc.ScrollView:setNoTouchMove(not cc.ScrollView:isNoTouchMove())
end

function debugPanel:openBattle()
    
    global.panelMgr:openPanel("UIGMBattle")
    
    self.menuMainCallback()
end

function debugPanel:equipStrengthen()
   
    global.panelMgr:openPanel("UIGMColStrong") 
    self.menuMainCallback()
end

function debugPanel:closeGuide()
    global.guideMgr:stop()
    
    if global.guideMgr:getCurGuideType() == 1 then
        
        global.commonApi:setGuideStep(global.guideMgr:getCurStep(),function()
        
            global.guideMgr:cleanCache()
            global.guideMgr.isInScript = false
        end)
    else
        global.commonApi:setGuideStep(999998,function()
        
            global.guideMgr:cleanCache()
            global.guideMgr.isInScript = false
        end) 
    end    

    if global.scMgr:isMainScene() then
        global.loginApi:getLoginDetail(function(ret, msg)
            --登陆直通车 获取主城信息
            if ret.retcode == WCODE.OK then

                global.dataMgr:init(msg)
                global.scMgr:gotoMainScene()
            end
        end)
    else

        global.scMgr:gotoMainSceneWithAnimation()
    end    
    
    self.menuMainCallback()
end

function debugPanel:drawGuideRect()
    global.guideData:setGuideRect()
end

function debugPanel:controlLogLevel()
    if log.get_loglevel() == log.LFATAL then
        log.set_loglevel(log.LTRACE)
        print("日志等级切换到LTRACE")
    else
        log.set_loglevel(log.LFATAL)
        print("日志等级切换到LFATAL")    
    end
end

function debugPanel:openAllCity()
    
    global.cityApi:buildAllOpen( function(msg)

        -- global.loginApi:getLoginDetail(function(ret, msg)
        --     --登陆直通车 获取主城信息
        --     if ret.retcode == WCODE.OK then

        --         global.dataMgr:init(msg)
        --         global.scMgr:gotoMainScene()
        --     end
        -- end)

        global.funcGame:RestartGame()
    end)
end

function debugPanel:resouceSpeed()


end

function debugPanel:resourceAll()
    
    global.cityApi:resourceAll( function(msg)

        for _,v in pairs(msg.tgBuilds or {}) do
           
           global.cityData:setBdResById( v.lBuildID, v.lBdRes )
        end
        gevent:call(global.gameEvent.EV_ON_CITY_UPDATE_BUILDINGS_STATE)

        global.userData:resetTurntableTimes(1)
        if global.panelMgr:getPanel("UITurntableFullPanel") then
            global.panelMgr:getPanel("UITurntableFullPanel"):setTouchUse(true)
        end
    end)

end


function debugPanel:showWorld(sender, eventType)
    global.scMgr:gotoWorldScene()
end

function debugPanel:resourceUp(sender, eventType)
    global.cityApi:resourceUp( function(msg)
        global.tipsMgr:showWarning("GM使用成功")
    end)
end

function debugPanel:soldierUp(sender, eventType)
    global.cityApi:soldierUp( function(msg)
        if msg.tgSoldier then
            for i,v in ipairs(msg.tgSoldier) do
                local outStr = "GM使用成功->士兵"
                local soldierTrainData = global.luaCfg:get_soldier_train_by(v.lID)
                outStr = outStr .. soldierTrainData.name.."总数："..v.lCount
                global.tipsMgr:showWarning(outStr)
                -- global.soldierData:addSoldierWithCover(v)
            end
        end
    end)
end

function debugPanel:beAttack(sender, eventType)
    
    -- tip 滚动显示
    -- global.tipsMgr:showWarningLoop(" 1 ---------------- ", 1)
    -- global.tipsMgr:showWarningLoop(" 2 ---------------- ", 2)
    -- global.tipsMgr:showWarningLoop(" 3 ---------------- ", 3)
    -- global.tipsMgr:showWarningLoop(" 4 ---------------- ", 4)
    -- global.tipsMgr:showWarningLoop(" 5 ---------------- ", 5)
    -- global.tipsMgr:showWarningLoop(" 6 ---------------- ", 6)
    -- global.tipsMgr:showWarningLoop(" 7 ---------------- ", 7)
    -- global.tipsMgr:showWarningLoop(" 8 ---------------- ", 8)
    -- global.tipsMgr:showTipsList()
   
end

function debugPanel:noAttack(sender, eventType)
    -- local wallNumPanel = global.panelMgr:getPanel("UIWallNumPanel") 
    -- wallNumPanel:setData(14)
    -- wallNumPanel:debugData(0, 0)


    self.menuMainCallback()
    
    if global.scMgr:isWorldScene() and global.g_worldview.worldPanel.chooseCityId then

        global.commonApi:debugCommSet(function ()
            global.tipsMgr:showWarningText("No Occupy success!")
        end, 21, global.g_worldview.worldPanel.chooseCityId, 0)

    else

        global.tipsMgr:showWarningText("只能在大地图并且选中建筑之后才能使用")
    end


end

--设置整点通知
function debugPanel:setServerTime(sender, eventType)
    local reset = false
    local function callback(msg)
        local timeConf = global.luaCfg:time()
        local gameEvent = global.gameEvent
        for i,v in ipairs(msg.tagPairs) do
            local timeId = v.lID
            if timeConf[timeId] then
                if reset then
                    timeConf[timeId].time = v.lValue
                else
                    timeConf[timeId].time = global.funcGame.convertCurrZoneTime(v.lValue)
                end
            end
        end
        gevent:call(gameEvent.EV_ON_SOLDIERS_UPDATE)
    end
    if sender:getName() == "resetServerTime" then
        reset = true
    end
    global.cityApi:gmSetSTimeReq(callback,reset)
end

function debugPanel:simTest(sender, eventType)

    global.panelMgr:openPanel("UIGMBattlePanel")
    
    self.menuMainCallback()
end

function debugPanel:magicocc(sender, eventType)

    self.menuMainCallback()
    
    if global.scMgr:isWorldScene() and global.g_worldview.worldPanel.chooseCityId then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("debugmac01", function()
            
            global.worldApi:miracleOccupyReq(global.g_worldview.worldPanel.chooseCityId,function()
                

            end)
        end)
    else

        global.tipsMgr:showWarningText("只能在大地图并且选中奇迹之后才能使用")
    end    
end

function debugPanel:getEquip(sender, eventType)

    global.panelMgr:openPanel("UIGMGetEquipPanel")

    self.menuMainCallback()
end

function debugPanel:skipGuide(sender, eventType)

    -- global.userData:setGuide(true)

    global.guideMgr:stop()
    global.commonApi:setGuideStep(global.guideMgr:getCurStep(),function()
        
        -- global.guideMgr:cleanCache()
        global.guideMgr.isInScript = false
    end)

    global.scMgr:gotoMainSceneWithAnimation()
    
    self.menuMainCallback()
end

function debugPanel:GetPackage(sender, eventType)


    global.itemApi:GMGetItem(function()
       
        self.menuMainCallback()
    end,10702,1)
end

function debugPanel:onModifyAccount(sender, eventType)
    local account_str = self.textAccount:getString()
    if account_str and account_str ~= "" then
        cc.UserDefault:getInstance():setStringForKey("account",account_str)
        global.funcGame.RestartGame()
    end
end

function debugPanel:onOffDump(sender, eventType)

    if  global.temp_dump then return end 
    global.temp_dump = dump
    dump = function() end 
end

function debugPanel:onOnDump(sender, eventType)
    
    if global.temp_dump then 
        dump =  global.temp_dump
    end 

    global.temp_dump = nil 

end

function debugPanel:onChangeUpdate(sender, eventType)

    local account_str = self.update_text:getString()
    cc.UserDefault:getInstance():setStringForKey("debug_update_addr",account_str)
    global.funcGame.RestartGame()
end

-- 指定某个建筑提升到某个等级
function debugPanel:upBuildLvHandler(sender, eventType)
    
    if global.scMgr:isMainScene() then

        global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)
            global.commonApi:debugCommSet(function ()

                global.loginApi:getLoginDetail(function(ret, msg)
                    --登陆直通车 获取主城信息
                    if ret.retcode == WCODE.OK then
                        global.dataMgr:init(msg)
                        global.scMgr:gotoMainScene()
                    end
                end)

            end, 1, num1, num2)  
        end,  {10870, 10871, 10872}, {global.g_cityView.curSelectBuildId})
    else
        global.tipsMgr:showWarning("只能在内城对建筑的进行升级操作")
    end

    self.menuMainCallback()

end

-- 指定当前选中地点战斗剩余时间
function debugPanel:fightTimeHandler(sender, eventType)

 
    if global.scMgr:isWorldScene() and global.g_worldview.worldPanel.chooseCityId then

        global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)            

            if num2 == 9998 then
                global.funcGame:gpsWorldCity(num1, 0, true)
            else
                global.commonApi:debugCommSet(function ()
                    end, 7, num1, num2)  -- 战斗结束剩余时间
            end            

        end, {10873, "MapId:", 10874}, {global.g_worldview.worldPanel.chooseCityId})

    else
        global.tipsMgr:showWarningText("只能在大地图并且选中地点之后才能使用")
    end    

    self.menuMainCallback()

end

-- 指定领主等级至多少级
function debugPanel:upLordLvHandler(sender, eventType)

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)

        global.commonApi:debugCommSet(function ()
        end, 8, num1, num2)  
    end, {10875, 10879, 10876}, {global.userData:getUserId()})

    self.menuMainCallback()

end

-- 指定英雄等级至多少级
function debugPanel:upHeroLvHandler(sender, eventType)

    local defaultHeroId = nil
    if global.panelMgr:getTopPanelName() == "UIHeroPanel"  then
        local heroPanel = global.panelMgr:getPanel("UIHeroPanel")
        defaultHeroId = heroPanel.chooseHeroData.heroId
    end
    
    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)

        global.commonApi:debugCommSet(function ()
        end, 9, num1 , num2)  
    end, {10877, 10878, 10876}, {defaultHeroId})

    self.menuMainCallback()

end

function debugPanel:dropTest(sender, eventType)
    

    self.menuMainCallback()

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)
        global.commonApi:debugCommSet(function (msg )

        local panel = global.panelMgr:openPanel("UIPromptPanel")

        panel:setData(msg.szRet or "return nil !",function ()
        end)

        end, 2, num1 , num2)  
    end, {"drop Test","dropID", "Count"})

    
end


function debugPanel:timeMachine(sender, eventType)
    
    self.menuMainCallback()

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)

        num2 = num2 or 0
        global.commonApi:debugCommSet(function ()


        end, 14, num1, num2)

        global.tipsMgr:showWarning("success 可能需要重新进入界面 或游戏")

        global.delayCallFunc(function()

            global.loginApi:getLoginDetail(function(ret, msg)
                --刷新魔晶数量
                if ret.retcode == WCODE.OK then
                -- global.guideMgr:init()
                global.dataMgr:init(msg)
                end
            end)

        end, 0 , num2 + 5)

            

    end,  {"时光机", "请输入ID", "输入时间:单位S"})
end


function debugPanel:buyGift(sender, eventType)

    self.menuMainCallback()

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)
        global.commonApi:debugCommSet(function ()

        end, 4, num2, num2)
    end,  {"购买礼包", "不要输入!", "请输入gift ID :"})
end

function debugPanel:onModifyServer(sender, eventType)
    local defaultSelectSeverId = tonumber(cc.UserDefault:getInstance():getStringForKey("selectSever"))
    if defaultSelectSeverId ~= 8 then
        cc.UserDefault:getInstance():setStringForKey("selectSever",8)
        global.tipsMgr:showWarning("成功切换到8服")
        global.funcGame.RestartGame()
    else
        cc.UserDefault:getInstance():deleteValueForKey("selectSever")
        global.funcGame.RestartGame()
    end
end

function debugPanel:autokillmonster(sender, eventType)

    self.menuMainCallback()

    if global.scMgr:isWorldScene() and global.g_worldview.worldPanel.chooseCityId then

        if global.scMgr:isWorldScene() and global.g_worldview.worldPanel.chooseCityId then

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("全军出击 "..global.g_worldview.worldPanel.chooseCityId, function()
                global.commonApi:debugCommSet(function () end, 12, 1, global.g_worldview.worldPanel.chooseCityId)
            end)
        end    
    end 
    
end

function debugPanel:deleteShopQueue(sender, eventType)
    global.commonApi:debugCommSet(function ()
        global.tipsMgr:showWarning("商队删除成功")
    end, 18, global.troopData:getShoperTroopId(), nil)
end

function debugPanel:cloneTroop(sender, eventType)

    dump(global.debugTroop ,"global.debugTroo////////////")
        
    if  global.debugTroop then 
        
        global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)
            global.commonApi:debugCommSet(function ()
            end, 11, global.debugTroop.lID, num2)
        end,  {"cloneTroop","部队名字", "数量"} , {global.debugTroop.szName, 5})
    end 

end

function debugPanel:resPKcount(sender, eventType)

    self.menuMainCallback()


   if global.panelMgr:getTopPanelName() ~="UIPKPanel" then 
        return global.tipsMgr:showWarning("请打开竞技场")    
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")

    panel:setData("是否重置次数", function()

        global.commonApi:debugCommSet(function ()

            local panel = global.panelMgr:getTopPanel()
            panel.mydata.lCount =global.luaCfg:get_hero_arena_by(1).para
            panel:updateSelfInfo(panel.mydata)

        end, 15,  1, 1)

    end)

end

function debugPanel:modify_birthday(sender, eventType)

    self.menuMainCallback()

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (num1, num2)
        global.commonApi:debugCommSet(function ()

        end, 17, num2, num2)
    end,  {"修改生日", "不要输入!", "请输入秒数:"})
    
end

function debugPanel:changeAccount(sender, eventType)
    
    self.menuMainCallback()

    global.panelMgr:openPanel("UIGMGetItemPanel"):setData(function (name, serverid)
        
        if name == "" then
            return global.tipsMgr:showWarningText("请输入领主名！")
        end
        if serverid == "" then
            return global.tipsMgr:showWarningText("请输入服务器id！")
        end

        local requestData = {}
        local original = gdevice.getOpenUDID()
        local fake = crypto.md5(original..app_cfg.server_list_pw, false)
        requestData.sn = original
        requestData.sc = fake
        requestData.code = "gmlogin"
        requestData.sid = tonumber(serverid)
        requestData.nickname = name

        local urlHead = "http://192.168.10.20:8484/verify.php"
        local url = urlHead..'?'
        for k,v in pairs(requestData) do 
            url=url..'&'..k..'='..v
        end 

        print(" --> debug changecount url:" .. url)

        local responseCall = function (request, retCode)
            if retCode == 0 then 

                if request then 
                    local rootData = cjson.decode(request:getResponseData())
                    dump(rootData, " ///// rootData:")
                    local msg = rootData.param  
                    global.userData:setAccount(msg.login_name)
                    global.userData:setCountry(msg.country)

                    local svr_id = msg.svr_id
                    if not svr_id then  
                        log.error("--->author successfully,but no svr_id")
                        svr_id = global.loginData:getFirstServerId()
                    end
                    svr_id = global.loginData:checkSvrId(svr_id)
                    if msg.sn then
                        global.loginData:setHttpSn(msg.sn)
                    end
                    if msg.sc then
                        global.loginData:setHttpSc(msg.sc)
                    end
                    global.loginData:setCurServerId(svr_id)
                    cc.UserDefault:getInstance():setStringForKey("selectSever",svr_id)
                    global.sdkBridge:setBindInfo(msg or {})
                end

                global.funcGame:RestartGame()
            end
        end
       
        local function onRequestFinished(event)
            local request = event.request
            if event.name == "inprogress" then
                return 
            elseif event.name == "failed" then
            elseif event.name == "completed" then  
                local responsData = request:getResponseData() 
                if responsData then
                    log.trace("---->http call requesturl=%s, respone =%s", url, vardump(cjson.decode(request:getResponseData())))
                    local retCode = cjson.decode(responsData).ret
                    responseCall(request, retCode)
                end
            end 
        end

        local request = gnetwork.createHTTPRequest(onRequestFinished, url, app_cfg.server_list_method)
        request:addRequestHeader("Content-Type:application/text")
        request:setTimeout(15)
        request:start() 

    end,  {"切换账号", "领主名:", "服务器id:"}, nil, true)

end
--CALLBACKS_FUNCS_END

function debugPanel.menuMainCallback(sender)
    if debugPanel.instance ~= nil then
        if debugPanel.visible == true then
            debugPanel.visible = false
        else
            debugPanel.visible = true  
        end
        
        debugPanel.instance:setVisible(debugPanel.visible)
    end
end

function debugPanel.createPanel(parent, visible)    
    gdisplay.loadSpriteFrames("commonui_0.plist", "commonui_0.png")
    local btn = ccui.Button:create("ui_button/btn_bag_now.jpg",nil,nil,ccui.TextureResType.plistType)
    btn:setTitleText("DEBUG")
    btn:setTitleFontSize(25)
    btn:setTitleColor(gdisplay.COLOR_RED)
    btn:setPosition(gdisplay.width-100, gdisplay.height - 30)
    btn:setScale9Enabled(true)
    btn:setContentSize(cc.size(100,50))
    parent:addChild(btn, 255)

    local ins = debugPanel.new()
    parent:addChild(ins, 200)
    debugPanel.instance = ins
    
    visible = visible or false
    debugPanel.visible = visible
    debugPanel.instance:setVisible(visible)

    debugPanel.addDragOperation(btn)
end

function debugPanel.addDragOperation(btn)
    local layer_x, layer_y
    local winSize = gdisplay.size
    local isshow = true
    local function OnDebug(sender, eventType)  
        if eventType == ccui.TouchEventType.began then
            isshow = true;
            layer_x, layer_y = sender:getPosition(); 
        elseif eventType == ccui.TouchEventType.moved then
            local begain_pos = sender:getTouchBeganPosition();
            local move_pos = sender:getTouchMovePosition();
            local offset_x = move_pos .x - begain_pos.x;
            local offset_y = move_pos .y - begain_pos.y;
            local new_pos_x = layer_x + offset_x
            local new_pos_y = layer_y + offset_y
            sender:setPosition(new_pos_x,new_pos_y);
            if sender:getPositionX() <  sender:getContentSize().width/2 then
                sender:setPositionX(sender:getContentSize().width/2);
            elseif sender:getPositionX() + sender:getContentSize().width/2 > winSize.width then
                sender:setPositionX(winSize.width - sender:getContentSize().width/2);
            end
            if sender:getPositionY() < sender:getContentSize().height/2 then
                sender:setPositionY(sender:getContentSize().height/2);
            elseif sender:getPositionY() + sender:getContentSize().height/2 > winSize.height then
                sender:setPositionY(winSize.height - sender:getContentSize().height/2);
            end
            -- if new_pos_x + debug_layer:getContentSize().width*1.2 < winSize.width then
            --     debug_layer:setPosition(new_pos_x + debug_layer:getContentSize().width*0.2,sender:getPositionY()- debug_layer:getContentSize().height*0.5)
            -- else
            --     debug_layer:setPosition(new_pos_x - debug_layer:getContentSize().width*1.2,sender:getPositionY()- debug_layer:getContentSize().height*0.5)
            -- end
            -- if debug_layer:getPositionY() < 0 then
            --     debug_layer:setPositionY(0);
            -- elseif debug_layer:getPositionY() + debug_layer:getContentSize().height > winSize.height then
            --     debug_layer:setPositionY(winSize.height - debug_layer:getContentSize().height);
            -- end

            if math.abs(offset_y) > 5 or math.abs(offset_x) > 5 then
                isshow = false
            end

        elseif eventType == ccui.TouchEventType.ended then

            if isshow then debugPanel.menuMainCallback(btn) end        
        end
    end
    global.uiMgr:addWidgetTouchHandler(btn, OnDebug, true)
end

gDebugPanel = debugPanel

--endregion
