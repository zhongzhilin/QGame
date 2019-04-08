
local datetime = require "datetime"
local pbpack   = require "pbpack" 

local gevent = gevent
local gameEvent = global.gameEvent

local _M = {}
_M = class("LogoScene", function() return gdisplay.newScene("LogoScene") end )
                        
function _M:ctor() 
    self:InitBg()
    self.whiteBg = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
    self:addChild(self.whiteBg)

    local logoCfg = require("logo_cfg")

    local armatureMgr = ccs.ArmatureDataManager:getInstance()

    for i,v in ipairs(logoCfg.logo) do
        local node = cc.Node:create()
        node:setCascadeOpacityEnabled(true)
        self:addChild(node)

        local sprite = cc.Sprite:create(v.img)
        node:addChild(sprite)
        node:setOpacity(0)
        local sceneSize = self:getContentSize()
        sprite:setPosition(sceneSize.width / 2, sceneSize.height / 2)

        local arr = {}
        if i > 1 then
            table.insert(arr, DelayTime:create(3 * (i - 1)))
        else
            self.whiteBg:setColor(v.bg)
        end
        table.insert(arr, cc.CallFunc:create(function() 
            self.whiteBg:setColor(v.bg)
        end))
        table.insert(arr, cc.FadeIn:create(0.5))
        table.insert(arr, cc.DelayTime:create(1.5))
        table.insert(arr, cc.FadeOut:create(1))
        node:runAction(cc.Sequence:create(arr))

        local txt = "抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。\n适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。\n出版物号：ISBN 978-7-89387-035-4 沪新出科数[2016]79号\n新出广审[2016]180号 2014SR161790\n著作权人：成都甜橙网络技术有限公司\n出版单位：华东师范大学电子音像出版社有限公司"
        local labelOutput = cc.Label:createWithTTF(txt,"fonts/normal.ttf", 24,{width = 0, height = 0},cc.TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        node:addChild(labelOutput)
        labelOutput:setPosition(cc.p(gdisplay.cx,150))
        labelOutput:setLineHeight(35)
    end


    -- logoCfg.loadRes = logoCfg.loadRes or {}
    -- self.aniLoaded = (#logoCfg.loadRes == 0)
    -- logoCfg.logo = logoCfg.logo or {}
    -- self.isAnimEnd = (#logoCfg.logo == 0)

    -- for i,v in ipairs(logoCfg.loadRes) do
    --     local OnLoadAni = function(per)
    --         -- body
    --         log.debug("==========> OnLoadAni %s", per)
    --         if per == 1 then
    --             if self.aniLoaded  then
    --                 self:CreateLogin()
    --             else
    --                 self.aniLoaded = true
    --             end
    --         end
    --     end

    --     armatureMgr:addArmatureFileInfoAsync(v, OnLoadAni)
    -- end

    local arr = {}
    arr[#arr + 1] = cc.DelayTime:create(1 * #logoCfg.logo)
    arr[#arr + 1] = cc.CallFunc:create(function() 
        self.loginScene = global.scMgr:newScene("LoginScene")
        self.loginScene:retain()
    end)
    arr[#arr + 1] = cc.FadeIn:create(0.5)
    self:runAction(cc.Sequence:create(arr))

    local scheduleId = nil
    scheduleId = gscheduler.scheduleGlobal(function()
        if GLFIsProjectLoaded() then
            gscheduler.unscheduleGlobal(scheduleId)
            global.scMgr:SetCurScene(self.loginScene)
            global.scMgr:SetCurSceneName("LoginScene")
            cc.Director:getInstance():replaceScene(self.loginScene)
            self.loginScene:release()
            -- GLFCreateDebugPanel(self.loginScene, false)
            log.debug("=============> replaceScene(self.loginScene)")
        end
    end, 0)
end

function _M:onEnter()    
    math.randomseed(os.time())
    math.random()
end

function _M:onExit() 
  
end

return _M


