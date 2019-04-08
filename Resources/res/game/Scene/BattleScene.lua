
local datetime = require "datetime"
local pbpack   = require "pbpack" 

local gevent = gevent
local gameEvent = global.gameEvent

local global = global
local define = global.define

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local paraMgr = global.paraMgr

local battleApi = global.battleApi

local userData = global.userData
local luaCfg = global.luaCfg
local battleMgr = global.battleMgr

require("define")

local battleCfg = require("battle_cfg")

local func = global.funcGame

local SEARCH_ANI_START = "first"
local SEARCH_ANI_LOOP = "second"
local SEARCH_ANI_STOP = "third"

local _M = {}
_M = class("BattleScene", function() return gdisplay.newScene("BattleScene") end )
                        
function _M:ctor() 
    self:InitBg()

    self.preBg = cc.Sprite:create("map_prepare.jpg")
    self:addChild(self.preBg, -1)
    self.preBg:setPosition(gdisplay.size.width / 2, gdisplay.size.height / 2)

    self.battlefield = Battlefield:create()    
    self:addChild(self.battlefield)
    self.battlefield:setVisible(false)

    self.mStatusLabel = cc.LabelTTF:create("", "arial", 18)
    self:addChild(self.mStatusLabel)
    self.mStatusLabel:setPosition(gdisplay.size.width / 2, gdisplay.size.height / 2)

    self.mPingLabel = cc.LabelTTF:create("", "arial", 18)
    self:addChild(self.mPingLabel)
    self.mPingLabel:setAnchorPoint(cc.p(1, 1))
    self.mPingLabel:setPosition(gdisplay.size.width, gdisplay.size.height)

    self:InitBattleAni()
    local root = resMgr:createWidget("BattleCancel")
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)

    local closeBtn = self.root:getChildByName("btn_close")
    uiMgr:addWidgetTouchHandler(closeBtn, function(sender, eventType)
        if self.mIsLocal then            
            gevent:call(global.gameEvent.EV_ON_BATTLE_EVENT_EXIT)
        else
            gevent:call(global.gameEvent.EV_ON_BATTLE_EVENT_EXIT)
            global.battleApi:BattleCancel(function()
                
            end)
        end
    end)
    self.mCloseBtn = closeBtn
end

function _M:onEnter()

    self:addEventListener(gameEvent.EV_ON_BATTLE_EVENT_EXIT, function(evt)
        log.debug("============> EV_ON_BATTLE_EVENT_EXIT ret %s", self.mIsLocal)
        if self.mIsLocal then
            if userData:GetCharId() == nil then
                global.scMgr:gotoLoginScene()
            else
                global.scMgr:gotoMainScene()
            end
        else
            global.scMgr:gotoMainScene()
        end
    end)

    self:addEventListener(gameEvent.EV_ON_BATTLE_EVENT_PAUSE, function(evt)
        self.mPaused = true
    end)

    self:addEventListener(gameEvent.EV_ON_BATTLE_EVENT_RESUME, function(evt)
        self.mPaused = false
    end)

    self:addEventListener(gameEvent.EV_ON_BATTLE_EVENT_END, function(evt, winIndex)
        if self.mIsLocal then

        else
            if not self.mFinished then
                local callBack = function(ret)
                     log.debug("============> EV_ON_BATTLE_EVENT_END ret %s", ret)
                end        
                battleApi:BattleEnd(winIndex, callBack)
            end
        end
    end)

    self:addEventListener(gameEvent.EV_ON_BATTLE_ACTION_FRAME, function(evt, userid, x, y, skill_index, card_index, hero_index)
        if self.mIsLocal then
            local action = {
                idx = userid,
                action = {
                    action_x = x,
                    action_y = y,
                    action_skill = skill_index,
                    action_slave = card_index,
                }
            }
            table.insert(self.allActions, action)
            if skill_index and skill_index ~= 0 then
                BattlefieldManager:getInstance():OnUseSkillEnd(skill_index, 0)
            elseif card_index and card_index ~= 0 then
                BattlefieldManager:getInstance():OnUseCardEnd(card_index, 0)
            end
        else
            if not self.mFinished then
                local callBack = function(ret)
                    log.debug("============> EV_ON_BATTLE_ACTION_FRAME ret %s", ret)
                    if skill_index and skill_index ~= 0 then
                        BattlefieldManager:getInstance():OnUseSkillEnd(skill_index, ret)
                    elseif card_index and card_index ~= 0 then
                        BattlefieldManager:getInstance():OnUseCardEnd(card_index, ret)
                    end
                end        
                battleApi:BattleAction(userid, x, y, skill_index, card_index, callBack)
            end
        end
    end)

    self:addEventListener(gameEvent.EV_ON_BATTLE_NOTIFY, function(evt, msg)
        if msg.type == WPBCONST.BTL_MSG_TYPE_INIT then
            local initMsg = msg.msg_init

            log.debug("===============> msg_init %s", vardump(initMsg))

            for k,v in pairs(initMsg.btlusers) do
                local master = v.master
                v.skills = battleMgr:GetSkills(v.skills)
                v.skills = battleMgr:GetFakeSkills(master.level)
                v.slaves = battleMgr:GetFakeSlaves(master.level)
            end
            self:StartBattle(msg.msg_init)
        elseif msg.type == WPBCONST.BTL_MSG_TYPE_START then
            self.battlefield:StartBattle()
            self:StartGame()
        elseif msg.type == WPBCONST.BTL_MSG_TYPE_FRAME then
            self:OnFrameData(msg.msg_frame)
        elseif msg.type == WPBCONST.BTL_MSG_TYPE_FINISH then
            self.mFinished = true
            local ret = 0

            log.debug("===============> BTL_MSG_TYPE_FINISH ret %s self.mPlayerIdx %s msg %s", ret, self.mPlayerIdx, vardump(msg))
            if self.mPlayerIdx == msg.msg_finish.winner_idx then
                ret = 1
                BattlefieldManager:getInstance():Win()
            else                
                BattlefieldManager:getInstance():Lose()
            end
            global.funcGame.EndGame(ret, msg.msg_finish.winner_idx)
        end
    end)
end

function _M:OnFrameData(msg)
    local datetime = require("datetime")
    local curTime = msg.sendtm
    if self.lastTime ~= nil then
        local pingMs = math.ceil((curTime - self.lastTime))
        self.mPingLabel:setString(string.format("包间隔 %.2fms", pingMs))
        -- log.debug("=================> recive frame %d after frame %d %f ms curTime %f", msg.frame, self.lastFrame, pingMs)
    end
    local packData = pbpack.pack(msg, "BtlFrame") 
    BattlefieldManager:getInstance():OnFrameAction(packData, string.len(packData))
    self.lastTime = msg.sendtm
    self.lastFrame = msg.frame
end

function _M:onExit() 

    self.lastTime = nil
    self.lastFrame = nil

    BattlefieldManager:getInstance():DestroyBattleField()

    gsound.stopBgm()
    
    self:removeAllChildren(true)

    self:unscheduleAll()
    self:removeAllEventListener()

    global.resMgr:unloadStageRes()    
    global.resMgr:unloadRes("BattleScene")
    
end

function _M:StartGame()    
    self.mStarted = true
    BattlefieldManager:getInstance():StartGame()

    if self.mIsLocal then
        self.frameIndex = 0
        local sendFunc = function()
            if not self.mPaused then                    
                self.frameIndex = self.frameIndex + 1
                self:SendFrame()
            end
        end
        self:schedule(sendFunc, 1 / 10) 
    end
end

function _M:RunBattle(isLocal, stageId)
    self.mIsLocal = isLocal
    self.mStageId = stageId or 90001
    if not self.mIsLocal then
        battleApi:BattlePrepare(function(ret)
            log.debug("=================> BattlePrepare %s", ret)
        end)
    else
        local msg_init = battleMgr:GetFakeInitMsg()
        if _M.USE_NO_FAKE then
            msg_init = battleMgr:GetInitMsg()
        end
        self:StartBattle(msg_init)
    end
end

function _M:SendFrame()
    
    local datetime = require("datetime")
    local data = {
        frame = self.frameIndex,
        actions = self.allActions,
        sendtm = datetime.clock() * 1000,
    }
    
    self.allActions = {}

    -- log.debug("============> SendFrame %s", vardump(data))

    self:OnFrameData(data)
end

function _M:StartBattle(msg)


    local initStr = pbpack.pack(msg, "BtlInit")
    local stageStr = battleMgr:GetStageStr(self.mStageId)
    local moraleStr = battleMgr:GetMoraleInfoStr()

    local moraleInfo = pbpack.unpack(moraleStr, "BattleMoraleInfo")

    local stage = pbpack.unpack(stageStr, "SBfStage")

    self.bgm = stage.music
    if self.bgm then
        gsound.playBgm(self.bgm)
    end

    log.debug("========================> stage %s", vardump(stage))
    log.debug("========================> msg.btlusers %s", vardump(msg.btlusers))
    log.debug("========================> stageStr len %s", string.len(stageStr))

    local user_id, enemy_id = stage.userid, stage.enemyid
    for i,v in ipairs(msg.btlusers) do
        if v.charid == userData:GetCharId() then
            user_id = v.idx
            self.mPlayerIdx = v.idx
            break
        end
    end

    for i,v in ipairs(stage.players) do
        if v.id == user_id then
            v.camp = 1
        else
            v.camp = 2
        end
    end

    local data = {
        stage = stage,
        users = msg.btlusers,
        seed = msg.seed,
        morale_info = moraleInfo
    }

    self.battlefield:PrepareBattle(userData:GetCharId() or user_id, initStr, string.len(initStr), stageStr, string.len(stageStr), moraleStr, string.len(moraleStr))
    self.battleInfo = data
    
    log.debug("self.battleInfo ========> %s\n battleSeed %d", vardump(self.battleInfo), seed)

    local loadFunc = function()  
        self.totalStageResCount = 0
        local loadResCallBack = function(percent)  
            if self == nil or self.totalStageResCount == nil then
                return
            end
            self.totalStageResCount = self.totalStageResCount - 1
            -- log.debug("=============>　loadResCallBack self.totalStageResCount %s %s", self.totalStageResCount, self.totalStageResList[#self.totalStageResList - self.totalStageResCount])
        end    
        local resCount, resList = global.resMgr:preLoadBattleRes(data, loadResCallBack)
        self.totalStageResCount = self.totalStageResCount + resCount
        self.totalStageResList = resList
    end
    loadFunc()

    self.root:setVisible(false)

    self.mCanShowStopAni = false
    self.loadedStageResCount = 0
    self:ShowSearchStartAni()
end

function _M:OnBattleAniEnd(anim)
    if anim == SEARCH_ANI_START then 
        self:ShowSearchLoopAni()
    elseif anim == SEARCH_ANI_LOOP then
        self.mCanShowStopAni = true
        self:CheckStopSearch()
    elseif anim == SEARCH_ANI_STOP then
        self:ShowBattleStartAni()
    elseif anim == "show" then        
        self:HideBattleAni()
        self.preBg:setVisible(false)
        self.battlefield:setVisible(true)
        for k,v in pairs(self.totalStageResList) do
            log.debug("=============>　loadResCallBack cache %s", v)
            local resourceMgr = ResourceManager:getInstance()
            for i=1,5 do
                resourceMgr:CacheArmature(resourceMgr:Create(v))
            end
        end

        if self.mIsLocal then
            global.delayCallFunc(function()
                gevent:call(gameEvent.EV_ON_BATTLE_NOTIFY, { type = WPBCONST.BTL_MSG_TYPE_START })
            end, nil, 1)
        else
            local callBack = function(ret)

            end        
            battleApi:BattleFight(callBack)
        end
    end
end

function _M:CheckStopSearch()
    if self.mCanShowStopAni and self.totalStageResCount == self.loadedStageResCount then
        self:ShowSearchStopAni()
    end
end

function _M:InitBattleAni()
    local function animationEvent(armatureBack, movementType, movementID)
        log.debug("==============> movementType %s movementID %s", movementType, movementID)
        if movementType == ccs.MovementEventType.complete then    
            self:OnBattleAniEnd(movementID)
        elseif movementType == ccs.MovementEventType.loopComplete then  
            self:OnBattleAniEnd(movementID)
        end
    end
    if self.cloud == nil then
        self.cloud = resMgr:createArmature("battle_search_ani_start")    
        self.cloud:getAnimation():setMovementEventCallFunc(animationEvent)
        self:addChild(self.cloud, 2)
        self.cloud:setVisible(false)
        self.cloud:setPosition(cc.p(gdisplay.size.width * 0.5, gdisplay.size.height * 0.5))
    end 

    if self.battleAni == nil then
        self.battleAni = resMgr:createArmature("battle_search_ani_cloud")    
        self.battleAni:getAnimation():setMovementEventCallFunc(animationEvent)
        self:addChild(self.battleAni, 2)
        self.battleAni:setPosition(cc.p(gdisplay.size.width * 0.5, gdisplay.size.height * 0.5))
    end
end

function _M:ShowSearchStartAni()
    if self.cloud then
        self.cloud:setVisible(true)
        self.cloud:getAnimation():play(SEARCH_ANI_START)
    else
        log.debug("============== !ERROR! ShowSearchStartAni has no cloud ani")
    end
end

function _M:ShowSearchLoopAni()
    if self.cloud then
        self.cloud:setVisible(true)
        self.cloud:getAnimation():play(SEARCH_ANI_LOOP)
    else
        log.debug("============== !ERROR! ShowSearchLoopAni has no cloud ani")
    end
end

function _M:ShowSearchStopAni()
    self.root:setVisible(false)
    if self.cloud then
        self.cloud:setVisible(true)
        self.cloud:getAnimation():play(SEARCH_ANI_STOP)
    else
        log.debug("============== !ERROR! ShowSearchStopAni has no cloud ani")
    end
end

function _M:HideSearchAni()
    if self.cloud then
        self.cloud:setVisible(false)
    end
end

function _M:ShowBattleStartAni()
    if self.battleAni then
        self.battleAni:getAnimation():play("show")
        self.preBg:runAction(cc.ScaleTo:create(1, 2))
    else
        log.debug("============== !ERROR! ShowBattleStartAni has no battle ani")
    end
end

function _M:HideBattleAni()
    if self.battleAni then
        self.battleAni:setVisible(false)
    else
        log.debug("============== !ERROR! HideBattleAni has no battle ani")
    end
end

function _M:getStageId()
    return self.mStageId
end

return _M

