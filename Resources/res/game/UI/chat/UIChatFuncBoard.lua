--region UIChatFuncBoard.lua
--Author : yyt
--Date   : 2017/01/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local chat_cfg = require("asset.config.chat_cfg")
local app_cfg = require "app_cfg"
local crypto  = require "hqgame"
local worldConst = require("game.UI.world.utils.WorldConst")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChatFuncBoard  = class("UIChatFuncBoard", function() return gdisplay.newWidget() end )

function UIChatFuncBoard:ctor()

end

function UIChatFuncBoard:CreateUI()
    
end

function UIChatFuncBoard:initUI(root)

    root:removeFromParent()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIChatFuncBoard:setData(data)

    self.data = data or {}
    self.curType = global.chatData:getCurLType()
    self:setButtons(data.itemType)
end

local CHAT_BUTTONS = {
    SHARE_TMP = {
        title = 10288,
        call = "share_temp_call",
    },
    SCREEN = {
        title = 10472,
        call = "screen_call",
    },
    PRIVATE = {
        title = 10284,
        call = "private_call",
    },
    COPY = {
        title = 10285,
        call = "copy_call",
    },
    TRANSLATE = {
        title = 10286,
        call = "translate_call",
    },
    RETURNTRANSLATE = {
        title = 10864,
        call = "return_translate_call",
    },
    OPEN = {    
        title = 10287,
        call = "open_call",
    },
    SHARE = {
        title = 10288,
        call = "share_call",
    },
    GPS = {
        title = 10097,
        call = "open_call",
    },
    -- APPLYUNION = {
    --     title = 10282,
    --     call = "joinUnion_call",
    -- },
    JOINUNION = {
        title = 10283,
        call = "joinUnion_call",
    },
}

function UIChatFuncBoard:joinUnion_call()
    
    local curAllyId = tonumber(self.data.tagSpl.lValue)
    if global.userData:checkJoinUnion() then
        global.tipsMgr:showWarning(luaCfg:get_local_string(10083))
    else
        global.unionApi:joinUnion(curAllyId, 1, function(msg)
            global.unionData:setInUnion(msg.tgAlly)
            global.tipsMgr:showWarning(luaCfg:get_local_string(10080))
            global.panelMgr:closePanel("UIChatPanel")
            global.panelMgr:openPanel("UIHadUnionPanel")
        end)
    end
end

function UIChatFuncBoard:share_temp_call()
    
    local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    local chatPanel = global.panelMgr:getPanel("UIChatPanel")
    local isVisi = chatPanel.sharePanel:isVisible()
    if not isVisi then

        if not chatPanel.shareNode then
            local shareNode = require("game.UI.mail.UIBattleShare").new()
            shareNode:setPosition(cc.p(0, 0))
            shareNode:CreateUI()
            chatPanel.sharePanel:addChild(shareNode)
            chatPanel.shareNode = shareNode
        end
        chatPanel:hideFuncBorard()
        chatPanel:showSharePanel()
        global.mailData:setTitleStr(self.data.tagSpl.szInfo)
        chatPanel.shareNode:setData(self.data.tagSpl.szParam, "UIChatPanel")
    else
        chatPanel:hideSharePanel()
    end
end

function UIChatFuncBoard:share_call()
    
    local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    local tagSpl = {}
    tagSpl.lKey = self.data.tagSpl.lKey
    tagSpl.lValue = 0
    tagSpl.szParam = ""    
    tagSpl.szInfo = self.data.tagSpl.szInfo--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl)
end

-- scrap
function UIChatFuncBoard:screen_call()

    -- local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    -- if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    -- global.chatData:addShield(self.data.selectUserId)
end

function UIChatFuncBoard:private_call()
    
    local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    if not self.data.selectUserId or (self.data.selectUserId == global.userData:getUserId()) then
        global.tipsMgr:showWarning("unionMyNot")
        return 
    end

    local panel = global.panelMgr:openPanel("UIChatPrivatePanel")
    panel:setCurMsgPri(self.data)
    panel:init(self.data.selectUserId, self.data.szFrom)
end

function UIChatFuncBoard:copy_call()
    
    local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    if self.data.tagSpl and self.data.tagSpl.lKey == 5 then

        local tagSpl = self.data.tagSpl
        local str = luaCfg:get_local_string(tagSpl.lValue, tagSpl.szInfo or "", tagSpl.szParam or "")
        CCHgame:setPasteBoard(str)
    else
        CCHgame:setPasteBoard(self.data.szContent)
    end
    
end

function UIChatFuncBoard:translate_call()
    
    local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    if self.data.tranState == 0 then 
        
        if self.data.tranStr and self.data.tranStr ~= "" then
            self.data.tranState = 1
            global.chatData:addTranslateRecode(self.data, 1)
            global.chatData:resetChatUI(self.data)
            gevent:call(global.gameEvent.EV_ON_CHAT_TRANSLATE)
        else

            -- 开始翻译
            global.isTranslating = true
            gevent:call(global.gameEvent.EV_ON_CHAT_TRANSLATEING, global.chatData:getTranslateKey(self.data))
            self:setTranslateHttp(function (responseData)

                if not responseData  then return end 

                if not self.data then return end

                local tranStr = ""
                if responseData and responseData.ret == 0 then
                    tranStr = gnetwork.decodeURI(responseData.translation) or "translate fail!"
                else
                    tranStr = self.data.destStr or ""
                end
                self.data.tranStr = self:dealTranStr(tranStr)
                self.data.tranState = 1
                global.chatData:addTranslateRecode(self.data, 1)
                global.chatData:resetChatUI(self.data)
                gevent:call(global.gameEvent.EV_ON_CHAT_TRANSLATE)
                -- 翻译结束
                gevent:call(global.gameEvent.EV_ON_CHAT_TRANSLATEING)

            end, self.data.destStr or "")
        end
    end

end

-- 实体字符编码
local htmlCode = {["&#39;"]="'",  ["&#160;"]=" ", ["&#60;"]="<", ["&#62;"]=">", ["&#38;"]="&", ["&#34;"]="",
["&#165;"]="¥", ["&#8364;"]="€", ["&#215;"]="×", ["&#247;"]="÷", ["&quot;"]="", ["\\"]=""}

function UIChatFuncBoard:dealTranStr(str)
    for k,v in pairs(htmlCode) do
        str = string.gsub(str, k, v)
    end
    return str
end

function UIChatFuncBoard:setTranslateHttp(resqonsecall, sourceText)

    local url = self:getUrl(sourceText)
    local function onRequestFinished(event)

        local request = event.request
        if event.name == "completed" then  
            
            dump(request:getResponseData(), "==>request:getResponseData()>>>>>>:")
            local cjson = require "base.pack.json"
            local responseData = cjson.decode(request:getResponseData())
            resqonsecall(responseData)
        else
            global.tipsMgr:showWarning("translateError")
            gevent:call(global.gameEvent.EV_ON_CHAT_TRANSLATEING)
        end
        global.isTranslating = nil 
    end
    local request = gnetwork.createHTTPRequest(onRequestFinished, url, app_cfg.server_list_method, true, true)
    request:addRequestHeader("Content-Type:application/text")
    request:setTimeout(15)
    request:start() 
end

function UIChatFuncBoard:getUrl(sourceText)
    
    local requestData = {}
    local original = gdevice.getOpenUDID()
    local fake = crypto.md5(original..app_cfg.server_list_pw, false)
    requestData.sn = original
    requestData.sc = fake

    local encodeURI = function (s)
        s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
        return string.gsub(s, " ", "+")
    end

    requestData.text = gnetwork.encodeURI(sourceText)
    requestData.target = global.sdkBridge:getCountryShort()
    
    local app_cfg = require("app_cfg")
    local url = app_cfg.get_plat_url(1)
    local urlHead = url.."translator/tran.php"
    local url = urlHead..'?'
    for k,v in pairs(requestData) do 
        url=url..'&'..k..'='..v
    end 
    print("--> translate Url: " .. url)
    return url
end

function UIChatFuncBoard:return_translate_call()
    -- body
    local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

    if self.data.tranState == 1 then 
        
        self.data.tranState = 0 -- 正常状态
        global.chatData:addTranslateRecode(self.data, 0)
        global.chatData:resetChatUI(self.data)
        gevent:call(global.gameEvent.EV_ON_CHAT_TRANSLATE)
    end
end

function UIChatFuncBoard:open_call()
    
    local key = self.data.tagSpl.lKey
    if key == 1 then
        local tempData = clone(self.data)
        local reportId = self.data.tagSpl.szParam
        global.chatApi:getBattleInfo( reportId ,function(msg)
            
            msg.tagMail = msg.tagMail or {}
            global.mailData:setTitleStr(tempData.tagSpl.szInfo)
            local panel = global.panelMgr:openPanel("UIMailBattlePanel")
            panel:setData(msg.tagMail, false, true)

        end)
    elseif key == 2 then
        local str = self.data.tagSpl.szInfo .. " return test"            
        local func = loadstring(str)

        if func then

            local equipData = func()

            if equipData then

                global.equipData:bindConfData(equipData)                    
                equipData.lID = 0
                global.panelMgr:openPanel("UIEquipPutDown"):setData(equipData,true):setEquipInfo(false,0,true,nil)
            else
                global.tipsMgr:showWarningText("equip data decode fail!(data)")                        
            end
        else    
            global.tipsMgr:showWarningText("equip data decode fail!(func)")                        
        end      
    elseif key == 3 then
        local str = self.data.tagSpl.szInfo .. " return test"
        local func = loadstring(str)

        if func then

            local data = func()

            if data then
                
                -- local pos = worldConst:converLocation2Pix(cc.p(data.posY,data.posX))                            
                -- global.funcGame:gpsWorldPos(cc.p(pos.x,pos.y))
                global.funcGame:gpsWorldCity(data.cityId, data.wildKind)
                global.panelMgr:closePanel("UIChatPanel")
            else
                global.tipsMgr:showWarningText("equip data decode fail!(data)")                        
            end
        else    
            global.tipsMgr:showWarningText("equip data decode fail!(func)")                        
        end
    elseif key == 4 then

        local str = self.data.tagSpl.szInfo .. " return test"            
        local func = loadstring(str)

        if func then

            local data = func()

            if data then
                
                global.panelMgr:openPanel("UIShareHero"):setData(data)
            else
                global.tipsMgr:showWarningText("equip data decode fail!(data)")                        
            end
        else    
            global.tipsMgr:showWarningText("equip data decode fail!(func)")                        
        end

    elseif key == 6 then 

        local szInfo = global.tools:strSplit(self.data.tagSpl.szInfo, '|')
        local noticeData = global.luaCfg:get_public_notice_by(tonumber(szInfo[1] or 0))
        if noticeData and noticeData.viewType < 0 then

            local szParams = {}
            for i=1,#szInfo do
                if szInfo[i] and szInfo[i] ~= "" then
                    table.insert(szParams, szInfo[i] or 0)
                end
            end
            local mapId = tonumber(szParams[#szParams] or 0)
            if mapId ~= 0 then
                global.funcGame:gpsWorldCity(mapId, 1, true, function ()
                    global.panelMgr:openPanel("UIMiracleDoorHistoryPanel"):setData(mapId)
                end)
            end

        else

            local actId = 0
            if noticeData and noticeData.viewType > 1 then
                actId = noticeData.viewType
            else
                actId = tonumber(szInfo[2] or 0)
            end
            local isExitActivity = global.ActivityData:gotoActivityPanelById(actId)
            if not isExitActivity then
                global.tipsMgr:showWarning("activity_end")
            end

        end

    -- elseif key == 7 then

    --     local curAllyId = tonumber(self.data.tagSpl.lValue)
    --     if curAllyId and curAllyId ~= 0 then 
    --         global.unionApi:getUnionInfo(function (msg)
    --             msg.tgAlly = msg.tgAlly or {}
    --             local panel  = global.panelMgr:openPanel("UIJoinUnionPanel")
    --             panel:setData(msg.tgAlly)
    --             panel.m_inputMode  = 0
    --             panel:updateUI()
    --         end, curAllyId)
    --     else 
    --         global.tipsMgr:showWarning("castle_union")
    --     end  
    elseif key == 8 then
        
        global.panelMgr:closePanel("UIChatPanel")
        if global.userData:checkJoinUnion() then --已有联盟信息界面
            global.panelMgr:openPanel("UIHadUnionPanel")
            global.panelMgr:openPanel("UIUWarListPanel")
        else --选择加入联盟列表
            global.panelMgr:openPanel("UIUnionPanel"):setData()
        end
    elseif key == 9 then
        if global.funcGame:checkBuildAndBuildLV(32) then 
            global.panelMgr:closePanel("UIChatPanel")
            global.panelMgr:openPanel("UIHeroExpListPanel")
        end 
    elseif key == 10 then
        
        local data = self.data
        local szPara = global.tools:strSplit(data.tagSpl.szParam, '+')
        local giftId = tonumber(szPara[1] or "0")
        global.chatApi:chatRedGift(function (msg, ret)
            global.panelMgr:openPanel("UIChatGiftPanel"):setData(data, msg, ret)
        end, 2, {giftId})

    elseif key == 11 then -- 神兽分享
        
        local tagSpl = self.data.tagSpl
        local data = {}
        data.lValue = tagSpl.lValue
        data.szParams = global.tools:strSplit(tagSpl.szInfo, '@') 
        global.panelMgr:openPanel("UIPetDetailPanel"):setData(data)
    elseif key == 12 then

        if self.data and self.data.tagSpl and self.data.tagSpl.szParam then
            local szParams = global.tools:strSplit(self.data.tagSpl.szParam, '+') 
            if szParams and szParams[2] then
                global.funcGame:gpsWorldCity(tonumber(szParams[2]), 1, true, function ()
                end)
            end
        end
    end
end

function UIChatFuncBoard:getItemKind(itemKind)

    -- 联盟欢迎私信
    if self.data.tagSpl and self.data.tagSpl.lKey == 5 then
        return 1
    end
    -- 系统公告
    if self.data.lFrom == 0 then
        return 3
    end

    return itemKind
end


function UIChatFuncBoard:setButtons(itemType)    

    local buttons = {}
    local itemKind = self:getItemKind(self.data.itemKind)
    
    --别人看到
    if itemType == 1 then

        -- 普通
        if itemKind == 1 then
            --私聊、复制、翻译
            if self.curType == 1 then  -- 私聊
                buttons = {CHAT_BUTTONS.COPY}
            else
                buttons = {CHAT_BUTTONS.PRIVATE,CHAT_BUTTONS.COPY}
            end    

            -- 是否处于翻译状态
            -- if self.data.tranState == 0 then
            --     table.insert(buttons, CHAT_BUTTONS.TRANSLATE)
            -- else
            --     table.insert(buttons, CHAT_BUTTONS.RETURNTRANSLATE)
            -- end

        -- 分享
        elseif itemKind == 2 then
            --查看、私聊、转发

            local key = self.data.tagSpl.lKey
            if key == 1 then
                buttons = {CHAT_BUTTONS.OPEN,CHAT_BUTTONS.PRIVATE,CHAT_BUTTONS.SHARE_TMP}
            elseif key == 2 then
                buttons = {CHAT_BUTTONS.OPEN,CHAT_BUTTONS.PRIVATE}
            elseif key == 3 then
                buttons = {CHAT_BUTTONS.GPS,CHAT_BUTTONS.PRIVATE,CHAT_BUTTONS.SHARE}
            elseif key == 4 then
                buttons = {CHAT_BUTTONS.OPEN,CHAT_BUTTONS.PRIVATE}
            elseif key == 7 then
                -- local params = global.tools:strSplit(self.data.tagSpl.szInfo, '@')
                -- params[2] = params[2] or ""
                -- if tonumber(params[2]) == 1 then
                buttons = {CHAT_BUTTONS.JOINUNION}
                -- else
                --     buttons = {CHAT_BUTTONS.APPLYUNION}
                -- end
            elseif key == 8 or key == 9 or key == 11 or key == 10 then
                buttons = {CHAT_BUTTONS.OPEN}
            elseif key == 12 then
                buttons = {CHAT_BUTTONS.GPS}
            end  
        elseif itemKind == 3 then      
            buttons = {CHAT_BUTTONS.OPEN}
        end

    --自己看到
    elseif itemType == 2 then        
        if itemKind == 1 then               
            -- 复制
            buttons = {CHAT_BUTTONS.COPY}
        elseif itemKind == 2 then 
            -- 查看转发            
            local key = self.data.tagSpl.lKey

            if key == 1 then
                buttons = {CHAT_BUTTONS.OPEN,CHAT_BUTTONS.SHARE_TMP}
            elseif key == 2 then
                buttons = {CHAT_BUTTONS.OPEN}
            elseif key == 3 then
                buttons = {CHAT_BUTTONS.GPS,CHAT_BUTTONS.SHARE}
            elseif key == 4 then
                buttons = {CHAT_BUTTONS.OPEN}
            elseif key == 7 then
                -- local params = global.tools:strSplit(self.data.tagSpl.szInfo, '@')
                -- params[2] = params[2] or ""
                -- if tonumber(params[2]) == 1 then
                buttons = {CHAT_BUTTONS.JOINUNION}
                -- else
                --     buttons = {CHAT_BUTTONS.APPLYUNION}
                -- end
            elseif key == 8 or key == 9 or key == 11 or key == 10 then
                buttons = {CHAT_BUTTONS.OPEN}
            elseif key == 12 then
                buttons = {CHAT_BUTTONS.GPS}
            end            
        end           
    end

    local btnCount = #buttons

    self:removeAllChildren()

    if btnCount == 0 then 
        -- global.tipsMgr:showWarning("the chat  been errors")
        return 
     end 

    local widget = resMgr:createWidget("chat/chat_btn_" .. btnCount)
    uiMgr:configUITree(widget)
    self:addChild(widget)

    for i = 1,btnCount do

        local btnConf = buttons[i]
        local btn = widget["Button_" .. i .. "_export"]
        btn["Text_" .. i .. "_export"]:setString(luaCfg:get_local_string(btnConf.title))

        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType)

            local topPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
            if topPanel.hideFuncBorard then  topPanel:hideFuncBorard() end

            self[btnConf.call](self)
            
        end)
    end

    self.row = widget.row_export
end
--CALLBACKS_FUNCS_END

return UIChatFuncBoard

--endregion
