--region Bottom.lua
--Author : wuwx
--Date   : 2016/09/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local dailyTaskData = global.dailyTaskData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIFinishTip = require("game.UI.commonUI.widget.UIFinishTip")
--REQUIRE_CLASS_END

local Bottom  = class("Bottom", function() return gdisplay.newWidget() end )

function Bottom:ctor()
    
end

function Bottom:CreateUI()
    local root = resMgr:createWidget("common/mainui_bot_bg")
    self:initUI(root)
end

function Bottom:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/mainui_bot_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.chatNode = self.root.chatNode_export
    self.txtChatType = self.root.chatNode_export.txtChatType_export
    self.chatRNode = self.root.chatNode_export.chatRNode_export
    self.bgHead = self.root.chatNode_export.chatRNode_export.bgHead_export
    self.bgHeadBg = self.root.chatNode_export.chatRNode_export.bgHeadBg_export
    self.chatHeadNode = self.root.chatNode_export.chatRNode_export.chatHeadNode_export
    self.txt_chat = self.root.chatNode_export.chatRNode_export.txt_chat_export
    self.spReadState = self.root.btn_info.spReadState_export
    self.mailUnReadText = self.root.btn_info.spReadState_export.mailUnReadText_export
    self.unionSpRead = self.root.btn_union.unionSpRead_export
    self.unionUnReadText = self.root.btn_union.unionSpRead_export.unionUnReadText_export
    self.spUnionState = self.root.btn_union.spUnionState_export
    self.mailUnUnionText = self.root.btn_union.spUnionState_export.mailUnUnionText_export
    self.btn_build = self.root.btn_build_export
    self.build_red = self.root.btn_build_export.build_red_export
    self.hero_point = self.root.hero_point_export
    self.FinshTip = self.root.FinshTip_export
    self.FinshTip = UIFinishTip.new()
    uiMgr:configNestClass(self.FinshTip, self.root.FinshTip_export)

    uiMgr:addWidgetTouchHandler(self.root.btn_chat, function(sender, eventType) self:onClickChatHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_world, function(sender, eventType) self:onGotoWorldHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bag, function(sender, eventType) self:onClickBagHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_info, function(sender, eventType) self:onClickInfoHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_union, function(sender, eventType) self:onClickUnionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_build, function(sender, eventType) self:onCallBuildListPanelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_hero, function(sender, eventType) self:onClickHeroHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.lizi = self.root.lizi_rea
    self.lizi:stopSystem()

    local callBB = function(event, state)
        -- body
        if self.PlayBagEffect then 
            self:PlayBagEffect(state)
        end 
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY,callBB)

    local callBB1 = function(eventName)
        -- body
        if self.referMailUnReadNum then
            self:referMailUnReadNum()
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM,callBB1)

    local callBB2 = function(eventName)
        -- body
        if not self.flushHeroState then return end
        self:flushHeroState()
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_EQUIP_FLUSH,callBB2)
    self:addEventListener(global.gameEvent.EV_ON_UI_HERO_FLUSH,callBB2)
    self:addEventListener(global.gameEvent.EV_ON_ITEM_UPDATE,callBB2)    
    self:addEventListener(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES,callBB2)
    self:addEventListener(global.gameEvent.EV_ON_HERO_FREE,callBB2)


    -- 刷新建造列表可建造红点显示
    local callBB2 = function(eventName)
        -- body
        if tolua.isnull(self.build_red) then return end
        self.build_red:setVisible(global.cityData:isShowBuildRed())
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_BUILD_RED_FLUSH,callBB2)

    local callBB2 = function(eventName,isnet)
        -- body
        if tolua.isnull(self.spUnionState) then return end
        local total = global.userData:getTotallAllyRedCount()
        self.spUnionState:setVisible(total>0)
        self.mailUnUnionText:setString(total)
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH,callBB2)

    if gdevice.model=="iphone 5" then
        self.txt_chat:setContentSize(cc.size(self.txt_chat:getContentSize().width, self.txt_chat:getContentSize().height+1))
    end
    
end

function Bottom:flushHeroState()

    self.isShowHeroPoint = false
    local buildData = global.cityData:getTopLevelBuild(15)
    if not buildData then
        return
    end

    local isCanSuit = global.heroData:isAnyOneCanSuit()
    local isCanReward = global.userData:getFreeLotteryCount() <= 0  -- or global.userData:getDyFreeLotteryCount() <= 0
    if isCanSuit or isCanReward then
        self.isShowHeroPoint = true
    end

    global.funcGame:checkAnyHeroCanBeContion(function(isShow)
        if not self.isShowHeroPoint and isShow then
            self.isShowHeroPoint = true
        end 
    end, true)
end

function Bottom:checkCanPersuadePoint()

    self.hero_point:setVisible(self.isShowHeroPoint)
    local knowHeroData = global.heroData:getHeroDataInCome() or {}
    local serverData = knowHeroData.serverData

    if serverData then
        local contentTime = global.dataMgr:getServerTime()
        local persuadeTime = global.heroData:getPersuadeTime()
        local m_restTime = persuadeTime - contentTime
        if persuadeTime == 0 then
            m_restTime = 0
        end
        if m_restTime == 0 then
            self.hero_point:setVisible(true)
        end
    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function Bottom:PlayBagEffect(state)

    if state == 0 then
        
        local nodeTimeLine = resMgr:createTimeline("common/mainui_bot_bg")
        nodeTimeLine:play("animation0", false)
        self:runAction(nodeTimeLine)

        self.lizi:resetSystem()
    else
        self:stopAllActions()
        local nodeTimeLine = resMgr:createTimeline("common/mainui_bot_bg")
        nodeTimeLine:play("animation1", false)
        self:runAction(nodeTimeLine)

        self.lizi:stopSystem()
    end
end


function Bottom:onClickChatHandler(sender, eventType)

    global.panelMgr:openPanel("UIChatPanel")
end

function Bottom:onGotoWorldHandler(sender, eventType)
    g_profi:time_show()
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_map")
    if not global.scMgr:isWorldScene() then

        global.commonApi:sendGameFps("10#"..CCHgame:getFps())
        global.scMgr:gotoWorldSceneWithAnimation()
    else

        global.commonApi:sendGameFps("20#"..CCHgame:getFps())
        global.g_worldview.mapPanel:cleanSchedule()
        -- global.panelMgr:getPanel("UIMapPanel"):cleanSchedule()
        global.scMgr:gotoMainSceneWithAnimation()
    end
    
end

function Bottom:onClickBagHandler(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_backpack")
    local panel =global.panelMgr:openPanel("UIBagPanel")

end

function Bottom:onClickInfoHandler(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_mailbox")
    global.panelMgr:openPanel("UIMailPanel")
end

function Bottom:onClickUnionHandler(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_union")
    if global.userData:checkJoinUnion() then
        --已有联盟信息界面
        local panel = global.panelMgr:openPanel("UIHadUnionPanel")
    else
        --选择加入联盟列表
        local panel = global.panelMgr:openPanel("UIUnionPanel"):setData()
    end
end

function Bottom:onClickHeroHandler(sender, eventType)

    local buildData = global.cityData:getTopLevelBuild(15)
    if not buildData then
        global.tipsMgr:showWarning('NewGuide02')
        return
    end
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_hero")
    global.panelMgr:openPanel("UIHeroPanel"):setMode1()
end


function Bottom:onExit()

    global.netRpc:delHeartCall(self)
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end
function Bottom:onEnter()

    self.isShowHeroPoint = false
    global.netRpc:addHeartCall(function ()
        -- body
        if self.checkCanPersuadePoint then
            self:checkCanPersuadePoint()
        end
        if self.addUnionBuildHelp then
            self:addUnionBuildHelp()
        end
    end,self)
    self:addUnionBuildHelp()
    self:checkCanPersuadePoint()
    self:flushHeroState()

    self.m_eventListenerCustomList = {}
    self.btn_build:setVisible(global.scMgr:isWorldScene() == false)

    if not global.scMgr:isWorldScene() then

        self.root.btn_world:loadTextureNormal("ui_surface_icon/mainui_map_icon.png",ccui.TextureResType.plistType)
        self.root.btn_world:loadTexturePressed("ui_surface_icon/mainui_map_icon.png",ccui.TextureResType.plistType)        
    else

        self.root.btn_world:loadTextureNormal("ui_surface_icon/mainui_world_icon.png",ccui.TextureResType.plistType)
        self.root.btn_world:loadTexturePressed("ui_surface_icon/mainui_world_icon.png",ccui.TextureResType.plistType)
    end

    self:chatEventListener()

    self:referMailUnReadNum()
    self:initChatText()

    gevent:call(global.gameEvent.EV_ON_UI_UNION_RED_FLUSH)

    global.sdkBridge:checkUserBind()  -- 进入游戏后，更新下绑定信息

    global.chatData:refershChatRecruitMsg()
    global.petData:refershActiveSkill()
end 

function Bottom:dailyRegister(m_firstIn)
    if global.scMgr:isWorldScene() or global.guideMgr:isPlaying() then return end
    local register = dailyTaskData:getTagSignInfo()
    local flag = dailyTaskData:getCurDay(register.lLastSign)
    if (register.lLastSign == 0 or flag == 1 ) and dailyTaskData:getIsFirstOnEnter() and global.userData:isEventGuideDone(40001) then
        dailyTaskData:setIsFirstOnEnter()
        global.panelMgr:openPanel("UIRegisterPanel"):setData(register)
    else 
        if _NO_RECHARGE then return end  -- 测试需要屏蔽 2018年10月24日19:22:16  

        -- 改为 登录必弹首冲   内外城切换随机弹出广告  广告内容优先首冲  其次是月卡和礼包随机
        if m_firstIn or math.random(1 , 2) == 1 then 
            if global.userData:canFirstPay() then
                return global.panelMgr:openPanel("UIFirRechargePanel"):setData()
            end
            local canRanT = {}
            local data =global.advertisementData:getRandomAD()
            if data then
                table.insert(canRanT,1)
            end
            if not global.rechargeData:isHadSuperMonthCard() then
                table.insert(canRanT,2)
            end
            if #canRanT < 1 then
                return
            end
            local randId = math.random(1 ,#canRanT)
            local randId = math.random(1 ,#canRanT)
            local randId = math.random(1 ,#canRanT)
            if canRanT[randId] == 1 then
                local panel = global.panelMgr:openPanel("UIADGiftPanel")
                panel:setData()
            elseif canRanT[randId] == 2 then
                local panel = global.panelMgr:openPanel("UIMonthCardPanel")  
                panel:setData()
            end
        end 
    end
end

function Bottom:chatEventListener()
    
    --- 国家、联盟有新消息
    self:addEventListener(global.gameEvent.EV_ON_CHAT_NEWMESSAGE, function (event, msg)
        if msg and self.setChatData and msg.lType ~= 1 then
            self:setChatData(msg)           
        end
    end) 

    -- 退出联盟
    self:addEventListener(global.gameEvent.EV_ON_UNION_QUITUNION, function ()
        self:initChatText()
        -- 清除联盟相关数据
        global.chatData:removeChatByKey(3)
        global.chatData:setFirstPush(3, true)
    end)

    -- 切入后台聊天数据
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        self:initChatText()
    end) 

    -- 修改名字
    self:addEventListener(global.gameEvent.EV_ON_UPDATE_USERNAME, function ()
        self:initChatText()
    end) 

    -- 屏蔽聊天
    self:addEventListener(global.gameEvent.EV_ON_CHAT_SHIELD, function ()
        self:initChatText()
    end)

    -- 重连成功之后，刷新
    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        self:initChatText()
    end)


end

function Bottom:isMemberHaveHelp()--盟友请求建设帮助
  
    if global.scMgr:isWorldScene() then
        return false
    end

    local buildData= global.cityData:getBuildingById(22)
    local isBuilded = buildData.serverData.lStatus ~= WDEFINE.CITY.BUILD_STATE.BLANK and buildData.serverData.lGrade >= 1
    if global.userData:getlAllyID() ~=0 and isBuilded then 
        return global.unionData:getNumberBuildState()
    end 
    return false 
end

function Bottom:isExistLatest(data, value)
    for _, v in ipairs(data or {} ) do 
        if v.lUserID  == value.lUserID and  v.lQID == value.lQID  and v.lAddTime > value.lAddTime then 
            return true 
        end 
    end 
    return false 
end
function Bottom:addUnionBuildHelp()--盟友请求建设帮助

    local removeIcon = function () 
        if self.unionBuildHelp then
            self.unionBuildHelp:removeFromParent()
            self.unionBuildHelp = nil
        end
    end 

    if self:isMemberHaveHelp() then 
        if not self.unionBuildHelp  then 
            self.unionBuildHelp = require("game.UI.city.widget.UIFloatBtnWidget").new() 
            self.unionBuildHelp:setPosition(cc.p(650, 480))
            self.root:addChild(self.unionBuildHelp)
            self.unionBuildHelp:setData(1,function()

                removeIcon()
                global.unionData:setNumberBuildState(false)

                global.unionApi:HelpList(function (msg) 
                    msg = msg or {}
                    table.sort(msg.tagHelpLog or {}  , function(A,B)
                        return A.lAddTime > B.lAddTime
                    end)
                    table.sort(msg.tagHelp or {} , function(A,B)
                        return A.lAddTime > B.lAddTime
                    end)
                    local helpData = {}
                    for _, v in ipairs(msg.tagHelp or {} ) do 
                        if v.lEndTime > global.dataMgr:getServerTime() and (v.lCountLimit > v.lCount) and (not self:isExistLatest(msg.tagHelp , v)) then 
                            table.insert(helpData, v)
                        end 
                    end 
                    local arr = {} 
                    for _, v in ipairs(helpData) do 
                        if not v.lStale and v.lUserID ~= global.userData:getUserId() then 
                            table.insert(arr , v.lID)
                        end 
                    end 
                    if #arr > 0 then 
                        global.unionApi:helpBuild(arr, function (msg) 
                            local add  = ""
                            if msg and msg.tgItem then 
                                for _ , v in pairs(msg.tgItem) do 
                                    local item = global.luaCfg:get_item_by(v.lID)
                                    add = add .. item.itemName
                                    add = add .."+".. v.lCount
                                end 
                            end 
                            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_unionhelpothers")
                            global.tipsMgr:showWarning("union_help02", add)
                        end)
                    else
                        global.tipsMgr:showWarning("union_help04")
                    end 
                end)
            end)

            self.unionBuildHelp:setIcon("ui_surface_icon/union_help_hammer.png")
            self.unionBuildHelp.root.btn.bg:setSpriteFrame("ui_surface_icon/city_train_get2.png")
        end 
    else
        removeIcon()
    end 
  
end 

function Bottom:referMailUnReadNum()
    
    --　邮件未读数量
    local mailUnReadNum = global.mailData:getMailUnReadNum()
    if mailUnReadNum <= 0 then
        self.spReadState:setVisible(false)
    else
        self.spReadState:setVisible(true)
        self.mailUnReadText:setString(mailUnReadNum)
    end
end

function Bottom:initChatText()

    local curSelect = 2
    local allyId = global.userData:getlAllyID()
    if allyId ~= 0 then
        curSelect = global.chatData:getCurChatPage()
    end

    global.chatApi:getMsgInfo(function(msg)

        if not self.setChatData then return end

        msg.tagMsg = msg.tagMsg or {}
        local msgNum = #msg.tagMsg
        local data = global.chatData:shieldChat(msg.tagMsg)
        if msgNum > 0 then
            self:setChatData(data[1] or {})
        else
            if self.chatNode then
                self.chatNode:setVisible(false)
            end
        end

    end,  curSelect)

end

function Bottom:setChatData(data)

    -- 系统公告
    if data.lFrom and data.lFrom == 0 then

        local noticStr = global.chatData:getSysNotice(data.tagSpl)
        self.txt_chat:setString(noticStr)
        local head = luaCfg:get_rolehead_by(501) 
        global.tools:setCircleAvatar(self.chatHeadNode, head)
        self.txtChatType:setString(global.luaCfg:get_local_string(10765))  
        local posX = self.txtChatType:getContentSize().width
        self.chatRNode:setPositionX(posX)

    else

        if table.nums(data) == 0 and self.chatNode then
            self.chatNode:setVisible(false)
            return
        end
        -- 被屏蔽玩家
        if global.chatData:isShieldUser(data.lFrom) then
            return
        end
        if self.chatNode then
            self.chatNode:setVisible(true)
        end
        self:setChatText(data)   -- 内容
        local head = luaCfg:get_rolehead_by(data.lFaceID or 101)  -- 头像
        global.tools:setCircleAvatar(self.chatHeadNode, global.headData:convertHeadData(data,head))
        local lType = data.lType -- 聊天类型
        if lType == 2 then
            self.txtChatType:setString(global.luaCfg:get_local_string(10303)) -- 国家
        elseif lType == 3 then
            self.txtChatType:setString(global.luaCfg:get_local_string(10304)) -- 联盟
        elseif lType == 4 then
            self.txtChatType:setString(global.luaCfg:get_local_string(10765)) -- 系统
        end
        local posX = self.txtChatType:getContentSize().width
        self.chatRNode:setPositionX(posX)

        -- 下载用户头像
        if data.szCustomIco and data.szCustomIco ~= "" then
            local tdata = {}
            table.insert(tdata,data.szCustomIco)
            local storagePath = global.headData:downloadPngzips(tdata)
            table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
                -- body
                global.tools:setCircleAvatar(self.chatHeadNode, global.headData:convertHeadData(data,head))
            end))
        end
    end

end

function Bottom:setChatText( lastChat )

    local str = ""
    if lastChat.tagSpl and lastChat.tagSpl.lKey == 1 then
        local strTb = string.split(lastChat.tagSpl.szInfo, "@")

        if #strTb > 1  then
            local strTemp = global.luaCfg:get_local_string(10299, strTb[1].."\n"..strTb[2])  
            if strTemp ~= "" then
                str = strTemp
            end
        else
            str = lastChat.tagSpl.szInfo
        end
    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 2 then

        local str1 = lastChat.tagSpl.szInfo .. " return test"
        local func = loadstring(str1)

        if func then
            local equipData = func()
            if equipData then
                global.equipData:bindConfData(equipData)
                local strongLv = ""
                
                if equipData.lStronglv > 0 then
                    strongLv = " +" .. equipData.lStronglv
                end                   
                str = luaCfg:get_local_string(10654, equipData.confData.name .. strongLv)
            else
                str = "equip data decode fail!(data)"                    
            end
        else    
            str = "equip data decode fail!(func)"                            
        end 
    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 3 then

        local str1 = lastChat.tagSpl.szInfo .. " return test"
        local func = loadstring(str1)

        if func then
            local data = func()
            if data then               
                str = luaCfg:get_local_string(10698,(data.name or "O-V-C-N-S") .. " (" .. data.posX .. "," .. data.posY .. ")")
            else
                str = "equip data decode fail!(data)"                    
            end
        else    
            str = "equip data decode fail!(func)"                            
        end 
    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 4 then

        local str1 = lastChat.tagSpl.szInfo .. " return test"
        local func = loadstring(str1)

        if func then
            local data = func()
            if data then               
                local heroPro = global.heroData:getHeroPropertyById(data.serverData.lID)
                if heroPro.quality == 1 then
                    str = luaCfg:get_local_string(10702,heroPro.name .. " Lv."..data.serverData.lGrade)
                else
                    if heroPro.iconBg == 'ui_surface_icon/hero_kuang4.png' then -- 传说
                        str = luaCfg:get_local_string(10933,heroPro.name .. " Lv."..data.serverData.lGrade)
                    else
                        str = luaCfg:get_local_string(10701,heroPro.name .. " Lv."..data.serverData.lGrade)
                    end
                end                              
            else
                str = "equip data decode fail!(data)"                    
            end
        else    
            str = "equip data decode fail!(func)"                            
        end 
    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 7 then

        local tagSpl  = lastChat.tagSpl
        local szParam = global.tools:strSplit(tagSpl.szParam, '@')   
        local showStr = luaCfg:get_local_string(10793, unpack(szParam))
        str = luaCfg:get_local_string(10776, showStr)

    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 8 then

        local tagSpl  = lastChat.tagSpl
        if tagSpl.lValue and tagSpl.lValue == -1 then -- 主动发起支援
            str = luaCfg:get_local_string(10965, tagSpl.szInfo or "welcome")
        else
            str = luaCfg:get_local_string(10964)
        end

    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 9 then

        local itemData = luaCfg:get_item_by(tonumber(lastChat.tagSpl.lValue)) or {}
        str = luaCfg:get_local_string(10998, itemData.itemName or "")
    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 10 then

        local localId = lastChat.lType == 2 and 11129 or 11095
        str = luaCfg:get_local_string(localId)

    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 11 then 
        local tagSpl = lastChat.tagSpl
        local parm = global.tools:strSplit(tagSpl.szInfo, '@') 
        local tempPet = global.petData:getPetConfig(tonumber(parm[1]), tagSpl.lValue)
        local name = tempPet.name .. " (".. tempPet.phaseName ..")"
        str = luaCfg:get_local_string(11089, name)
    elseif lastChat.tagSpl and lastChat.tagSpl.lKey == 12 then

        local szParams = global.tools:strSplit(lastChat.tagSpl.szParam, '+') 
        local configId = {[1]=11102, [2]=11101, [3]=11100}
        local typeId = tonumber(szParams[1] or "1") 
        local atkStr = luaCfg:get_local_string(configId[typeId])
        str = luaCfg:get_local_string(10965, atkStr)
    else
        str = lastChat.szContent or ""
    end

    if lastChat.lFrom == global.userData:getUserId() then
        lastChat.szFrom = global.userData:getUserName()
    end
    str = lastChat.szFrom..":"..str

    self.txt_chat:setString(str)
end

function Bottom:onCallBuildListPanelHandler(sender, eventType)
    local cityView = global.g_cityView
    local buildList = cityView:getBuildListPanel()
    if tolua.isnull(buildList) then return end
    local isVisi = buildList:isVisible()
    if not isVisi then
        cityView:showBuildListPanel()
    else
        cityView:hideBuildListPanel()
    end
end

function Bottom:enter_stroe_click(sender, eventType)
    local panel = global.panelMgr:openPanel("UIStorePanel")  
end 

function Bottom:onMonthCard(sender, eventType)
    local panel = global.panelMgr:openPanel("UIMonthCardPanel")  
    panel:setData()
end

--CALLBACKS_FUNCS_END

return Bottom

--endregion
