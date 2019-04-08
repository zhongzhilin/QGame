--region UIMailDetailPanel.lua
--Author : yyt
--Date   : 2016/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local app_cfg = require "app_cfg"
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailDetailPanel  = class("UIMailDetailPanel", function() return gdisplay.newWidget() end )
local worldConst = require("game.UI.world.utils.WorldConst")

local UITableView = require("game.UI.common.UITableView")
local UIMailRewardItem = require("game.UI.mail.UIMailRewardItem")

local _currentMailID = 0
local _GIFTSTATE = 0
local _appendixContent = 0

UIMailDetailPanel.itemCache = {}

function UIMailDetailPanel:ctor()
    self:CreateUI()
end

function UIMailDetailPanel:CreateUI()
    local root = resMgr:createWidget("mail/mail_three_bg")
    self:initUI(root)
end

function UIMailDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_three_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.common_title = self.root.common_title_export
    self.texTitleHead = self.root.common_title_export.texTitleHead_fnt_mlan_12_export
    self.panel_bg3 = self.root.panel_bg3_export
    self.imgHead = self.root.panel_bg3_export.imgHead_export
    self.texName = self.root.panel_bg3_export.texName_export
    self.topLayout = self.root.panel_bg3_export.topLayout_export
    self.bottomLayout = self.root.panel_bg3_export.bottomLayout_export
    self.scrollviewPanel = self.root.panel_bg3_export.scrollviewPanel_export
    self.texContent = self.root.panel_bg3_export.scrollviewPanel_export.texContent_export
    self.richContent = self.root.panel_bg3_export.scrollviewPanel_export.richContent_export
    self.splitGift = self.root.panel_bg3_export.scrollviewPanel_export.splitGift_export
    self.itemLayout = self.root.panel_bg3_export.scrollviewPanel_export.itemLayout_export
    self.mailTitle = self.root.mailTitle_export
    self.mailTime = self.root.mailTime_export
    self.btn_getGift = self.root.btn_getGift_export
    self.txt_get = self.root.btn_getGift_export.txt_get_mlan_4_export
    self.btn_deleteMail = self.root.btn_deleteMail_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.btn_getGift, function(sender, eventType) self:getGift(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_deleteMail, function(sender, eventType) self:deleteMail(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.common_title.esc, function(sender, eventType) self:btn_exit(sender, eventType) end)
    self.scrollviewPanel:setScrollBarEnabled(false)
    self.scrollviewPanelNode = cc.Node:create()
    self.scrollviewPanel:addChild(self.scrollviewPanelNode)
    self.scroSize = self.scrollviewPanel:getContentSize()

    self.scrollviewPanel:addEventListener(function()
        self:scrollEvent()
    end) 

    self:adapt()
end


function UIMailDetailPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 

function UIMailDetailPanel:scrollEvent()
    self.isStartMove = nil
end

function UIMailDetailPanel:registerMoveAction()

    local nextPanel = global.panelMgr:getPanel("UIMailListPanel")
    local touchNode = cc.Node:create()
    self:addChild(touchNode)

    local  listener = cc.EventListenerTouchOneByOne:create()
    local beginTime = 0
    local moveDelet = 0

    local function touchBegan(touch, event)

        if self:getPositionX() ~= 0 then return false end
   
        nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))

        beginTime = global.dataMgr:getServerTime()

        nextPanel:stopAllActions()
        self.isStartMove = true
        moveDelet = 0

        return true  
    end

    local function touchMoved(touch, event)

        if not self.isStartMove then

            return
        end

        local diff = touch:getDelta()
        moveDelet = moveDelet + diff.x

        local isTouch = self.scrollviewPanel:isTouchEnabled()
        
        if isTouch == true then

            if math.abs(diff.x) / 1.5 > math.abs(diff.y) then

                self.scrollviewPanel:setTouchEnabled(false)
            else

                return
            end
        end

        local nextPanelX = nextPanel:getPositionX() + diff.x / 2
        local currentPosX = self:getPositionX() + diff.x
        
        if currentPosX > gdisplay.width then
            currentPosX = gdisplay.width
            self:setPosition(cc.p(currentPosX, 0))
            nextPanel:setPosition(cc.p(0 , 0))
            return
        end
        if (currentPosX+diff.x) >= 0 then
            self:setPosition(cc.p(currentPosX, 0))
            nextPanel:setPosition(cc.p(nextPanelX , 0))
        end
    end

    local function touchEnded(touch, event)

        if not self.isStartMove then

            return
        end

        self.scrollviewPanel:setTouchEnabled(true)

        local diff = touch:getDelta()
        local moveWidth = (touch:getLocation().x - touch:getStartLocation().x)*2

        local currentPosX = self:getPositionX() 
        log.debug(currentPosX)

        local contentTime = global.dataMgr:getServerTime()  - beginTime

        local speed = moveDelet / (contentTime)

        log.debug("speed is " .. speed .. " " .. moveDelet .. " " .. contentTime)

        if currentPosX >= gdisplay.width / 2 or speed > 1500 then
            
            self:btn_exit()
        else


            local contentX = self:getPositionX()
            local time = contentX / gdisplay.width * 0.2
            self:runAction(cc.MoveTo:create(time,cc.p(0,0)))

            nextPanel:setPosition(cc.p(-gdisplay.width / 2, 0))
        end
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)

    touchNode:setLocalZOrder(8)

    self.lis = listener
end

function UIMailDetailPanel:onEnter()
    
    self.isInBack = false

    -- local tempItemData = global.mailData:getItemMailData(global.mailData._CURRENTMAILID)
    --self:setData(tempItemData)
end

--  "Sender"          = ""
-- [LUA-print] -     "appendixContent" = 1
-- [LUA-print] -     "firstType"       = 1
-- [LUA-print] -     "itemState"       = 0
-- [LUA-print] -     "lFromID"         = 0
-- [LUA-print] -     "lMailID"         = 11001
-- [LUA-print] -     "mailContent"     = ""
-- [LUA-print] -     "mailID"          = 2
-- [LUA-print] -     "mailName"        = ""
-- [LUA-print] -     "secondType"      = 1
-- [LUA-print] -     "state"           = 1
-- [LUA-print] -     "tgFightReport" = {
-- [LUA-print] -     }
-- [LUA-print] -     "tgItems" = {
-- [LUA-print] -         1 = {
-- [LUA-print] -             "lCount" = 200
-- [LUA-print] -             "lID"    = 6
-- [LUA-print] -         }
-- [LUA-print] -         2 = {
-- [LUA-print] -             "lCount" = 2
-- [LUA-print] -             "lID"    = 10801
-- [LUA-print] -         }
-- [LUA-print] -         3 = {
-- [LUA-print] -             "lCount" = 2
-- [LUA-print] -             "lID"    = 10901
-- [LUA-print] -         }
-- [LUA-print] -         4 = {
-- [LUA-print] -             "lCount" = 2
-- [LUA-print] -          

-- t] -     "Sender"          = ""
-- [LUA-print] -     "appendixContent" = 0
-- [LUA-print] -     "firstType"       = 1
-- [LUA-print] -     "itemState"       = -1
-- [LUA-print] -     "lFromID"         = 0
-- [LUA-print] -     "lMailID"         = 10140
-- [LUA-print] -     "mailContent"     = ""
-- [LUA-print] -     "mailID"          = 7645
-- [LUA-print] -     "mailName"        = ""
-- [LUA-print] -     "secondType"      = 1
-- [LUA-print] -     "state"           = 1
-- [LUA-print] -     "tgFightReport" = {
-- [LUA-print] -     }
-- [LUA-print] -     "time"            = 1493222322
-- [LUA-print] - }
-- [LUA-print] touch end

function UIMailDetailPanel:pullByHttp(id, resqonsecall)

    local app_cfg = require "app_cfg"
    local urlHead = app_cfg.get_plat_url().."download/custom.php"
    local url = urlHead..'?'
    local requestData = {id=id, language=global.languageData:getCurrentLanguage()}
    for k,v in pairs(requestData) do 
        url=url..'&'..k..'='..v
    end 

    local function onRequestFinished(event)

        local request = event.request
        if event.name == "inprogress" then
            print("------------------- pullByHttp mail event inprogress! ------------------")
            return 
        elseif event.name == "failed" then
            print("------------------- pullByHttp mail event failed ------------------")
        elseif event.name == "completed" then  
            
            dump(request:getResponseData(), "==>pullByHttp:getResponseData()>>>>>>:")
            local cjson = require "base.pack.json"
            local responseData = cjson.decode(request:getResponseData())
            resqonsecall(responseData)
        end
    end
    local request = gnetwork.createHTTPRequest(onRequestFinished, url, app_cfg.server_list_method, nil, true)
    request:addRequestHeader("Content-Type:application/text")
    request:setTimeout(15)
    request:start() 
end

function UIMailDetailPanel:setData(msg, isNeedMoveAction)  

    self.isInit = false
    self.panel_bg3:setVisible(false)
    self.root.split_line1:setVisible(false)
    self.mailTitle:setVisible(false)
    self.mailTime:setVisible(false)
    self.btn_getGift:setVisible(false)
    self.btn_deleteMail:setVisible(false)

    -- 自定义邮件
    if msg.lCustom == 1 then
        self:pullByHttp(msg.mailContent, function (repMsg)
            -- body
            if repMsg and repMsg.ret == 0 then
                global.mailData:updatelCustomMail(msg.mailID, repMsg.title, repMsg.content)
                if self.initData then 
                    self:initData(global.mailData:getItemMailData(msg.mailID), isNeedMoveAction)
                end 
            else
                print("------------------- pullByHttp mail fail! ------------------")
            end
        end)
    else
        self:initData(msg, isNeedMoveAction)
    end
end

function UIMailDetailPanel:initData(msg, isNeedMoveAction)  

    self.isInit = true
    self.panel_bg3:setVisible(true)
    self.root.split_line1:setVisible(true)
    self.mailTitle:setVisible(true)
    self.mailTime:setVisible(true)
    self.btn_getGift:setVisible(true)
    self.btn_deleteMail:setVisible(true)

    self.data = msg or {} 
    self.lmailData = luaCfg:get_email_by(msg.lMailID) 
    self.texTitleHead:setString(global.mailData._MAILTITLE)
    self.mailTime:setString(global.mailData:getData(msg.mailID))
    
    -- 邮件标题
    if self.lmailData then
        self.texName:setString(self.lmailData.Sender)
        local titleStr = luaCfg:get_local_string(tonumber(self.lmailData.mailName))
        if titleStr == "" then
            self.mailTitle:setString(self.lmailData.mailName)
        else
            self.mailTitle:setString(titleStr)
        end
    else
        self.mailTitle:setString(msg.mailName)
        self.texName:setString(msg.Sender)
    end
    
    -- 邮件内容
    self:setMailContent(msg)

    self.imgHead:setSpriteFrame(global.mailData:getItemIcon(msg.secondType))
    if msg.appendixContent ~=0 then
        self:initScroll(msg.tgItems or {})
        self:checkGetState(msg.itemState)
    end

    self:refershState(msg)


    --　添加手势滑动
    if isNeedMoveAction then 
        if not self.lis then
            self:registerMoveAction()
        end
    else
        if self.lis then
            cc.Director:getInstance():getEventDispatcher():removeEventListener(self.lis)
            self.lis = nil
        end
    end

end

-- 普通类型邮件
function UIMailDetailPanel:commonMailStr(lType, msg, strTb, pos)
    
    if not self.lmailData then return "", {} end
    local localId = tonumber(self.lmailData.mailContent)

    local str = ""
    local args = {}
    if lType == 1 then

        str = luaCfg:get_local_string(localId, pos.x, pos.y, strTb[3])
        args = {pos.x, pos.y, strTb[3]}

    elseif lType == 2 then

        -- 占领奇迹奖励邮件
        if localId == 10234 then
            local sData = luaCfg:get_world_type_by(tonumber(strTb[3])) or  luaCfg:get_wild_res_by(tonumber(strTb[3]))
            if not sData then
                sData = luaCfg:get_all_miracle_name_by(tonumber(strTb[3]))  
            end
            sData = sData or {}
            strTb[3] = sData.name or ""
        end
        str = luaCfg:get_local_string(localId, strTb[3] ,pos.x, pos.y)
        args = {strTb[3] ,pos.x, pos.y}

    elseif lType == 3 then

        str = luaCfg:get_local_string(localId, pos.x, pos.y)
        args = {pos.x, pos.y}

    elseif lType == 4 then
        
        local nameLevel = luaCfg:get_union_position_btn_by(tonumber(msg.mailContent))
        if nameLevel then
            msg.mailContent = nameLevel.text
        end
        str = luaCfg:get_local_string(localId, msg.mailContent)
        args = {msg.mailContent}

    elseif lType == 5 then

        self.lTargetId = tonumber(strTb[3])
        local szShortName = global.unionData:getUnionShortName(strTb[1])
        str = luaCfg:get_local_string(localId, string.format("%s%s",szShortName,strTb[2]))
        args = {string.format("%s%s",szShortName,strTb[2])}

    elseif lType == 6 then               
        str = luaCfg:get_local_string(localId, msg.mailContent)
        args = {msg.mailContent}
    end
    return str,args
end

local activity_point={
    10121 ,
    10141 ,
    10155 ,
    10168 ,
    10165 , --英雄战力积分
    10166 , -- 城建战力积分
    10153 , 
}

local activity_rank ={
    10167 ,
    10163 ,
    10164 ,
    10170 , -- 战斗力 积分
}

local activity_boss ={ -- 世界boss 
    16007 , 
    16008 , 
    16009 , 
    16010 , 
}

local activity_boss_join ={ -- 世界boss 参与奖励 

    16011 , 
    16012 , 
    16013 , 
    16014 , 
}

--     "Sender"          = ""
-- [LUA-print] -     "appendixContent" = 1
-- [LUA-print] -     "firstType"       = 1
-- [LUA-print] -     "itemState"       = 1
-- [LUA-print] -     "lFromID"         = 0
-- [LUA-print] -     "lMailID"         = 10120
-- [LUA-print] -     "mailContent"     = "4"
-- [LUA-print] -     "mailID"          = 750862
-- [LUA-print] -     "mailName"        = ""
-- [LUA-print] -     "secondType"      = 1
-- [LUA-print] -     "state"           = 1
-- [LUA-print] -     "tgFightReport" = {
-- [LUA-print] -     }
-- [LUA-print] -     "tgItems" = {

--各类特殊邮件
function UIMailDetailPanel:specialMailStr(msg, strTb)
    

    dump(msg,"//////////////////////////////////")
    dump(strTb)
    --dump(self.lmailData)
    if not self.lmailData then return "", {} end
    local localId = tonumber(self.lmailData.mailContent)
    local str = ""
    local args = {}
    if msg.lMailID == 41009 then

        --开启boss邮件
        local taskData = global.luaCfg:get_union_task_by(tonumber(strTb[2]))
        str = luaCfg:get_local_string(localId, strTb[1],taskData.taskName)
        args = {strTb[1],taskData.taskName}
    elseif msg.lMailID == 41010 then

        --挑战失败邮件
        local taskData = global.luaCfg:get_union_task_by(tonumber(strTb[1]))
        str = luaCfg:get_local_string(localId, taskData.taskName)
        args = {taskData.taskName}
    elseif msg.lMailID == 45001 then

        --运送资源邮件
        str = "----"
        args = {strTb[1],strTb[2],strTb[3],strTb[4],strTb[5]}
        --dump(args,"fjlasdjflasdkjfl;asjd")
    elseif msg.lMailID == 11001 or  msg.lMailID == 11004  then 
        -- 欢迎邮件
        local initMail = luaCfg:get_email_by(msg.lMailID)
        str = initMail.mailContent        
    elseif msg.lMailID == 41011 then
        --联盟欢迎加入邮件
        local uName = luaCfg:get_local_string(10333, strTb[1]) .. strTb[2] 
        str = luaCfg:get_local_string(localId, uName)
        args = {uName}
    elseif msg.lMailID == 10128  or  msg.lMailID ==10124 or  msg.lMailID==10142  then 
        -- 活动 积分 排名 邮件
        str = luaCfg:get_local_string(localId, strTb[2] or "default" ,strTb[1] or "default")
        args = {strTb[2] or "default" ,strTb[1] or "default"}
    elseif msg.lMailID == 16004 or msg.lMailID == 16003 then

        local wildRes = luaCfg:get_wild_res_by(tonumber(strTb[1])) or {}
        str = luaCfg:get_local_string(localId, wildRes.name or "" ,strTb[2] or "" ,strTb[3] or "")   
        args = {wildRes.name or "" ,strTb[2] or "" ,strTb[3] or ""}
    elseif msg.lMailID == 16005  then    

        local wildRes = luaCfg:get_wild_res_by(tonumber(strTb[1])) or {}
        str = luaCfg:get_local_string(localId, wildRes.name or "" ,strTb[2] or "" ,strTb[3] or "", strTb[4] or "") 
        args = {wildRes.name or "" ,strTb[2] or "" ,strTb[3] or "", strTb[4] or ""}
    elseif msg.lMailID == 16006 then    

    local miracleData = luaCfg:get_all_miracle_name_by(tonumber(strTb[1])) or {}
        local miracleName = miracleData.name
        local allySimple = strTb[3] or ""
        local name = strTb[2]
        if allySimple ~= "" then
            name = string.format("【%s】%s",allySimple,strTb[2])
        end
        local initMail = luaCfg:get_email_by(msg.lMailID)
        str = luaCfg:get_translate_string(tonumber(initMail.mailContent), miracleName or "",name or "")
        args = {miracleName or "",name or ""}
    elseif msg.lMailID == 10146 or msg.lMailID == 10147  then 
        -- 个人外交关系
        local initMail = luaCfg:get_email_by(msg.lMailID)
        str = luaCfg:get_local_string(tonumber(initMail.mailContent), msg.mailContent)
        args = {msg.mailContent}
    elseif msg.lMailID == 10151  then
        local initMail = luaCfg:get_email_by(msg.lMailID)
        local sData = luaCfg:get_world_miracle_by(tonumber(strTb[1]))
        str = luaCfg:get_local_string(tonumber(initMail.mailContent), sData.name)
        args = {sData.name}
    elseif msg.lMailID  == 12003 then 

        local initMail = luaCfg:get_email_by(msg.lMailID)
        local skinData = global.luaCfg:get_world_city_image_by(tonumber(msg.mailContent))
        str = luaCfg:get_local_string(tonumber(initMail.mailContent), skinData.name)
        args = {skinData.name}
    elseif msg.lMailID  == 10150 then 

        local initMail = luaCfg:get_email_by(msg.lMailID)
        str = luaCfg:get_local_string(tonumber(initMail.mailContent))
        args = {}
    elseif msg.lMailID  ==  10104 then 

        local initMail = luaCfg:get_email_by(msg.lMailID)
        str = luaCfg:get_local_string(tonumber(initMail.mailContent),msg.mailContent)
        args = {msg.mailContent}
    elseif  table.hasval(activity_point ,  msg.lMailID)  then --活动掠夺， 杀怪  等  积分奖励

        local initMail = luaCfg:get_email_by(msg.lMailID)

        local activity_id =  0  --
        for _ , v in  pairs(global.luaCfg:activity()) do 
            if v.para2 == msg.lMailID then 
                activity_id = v.activity_id
            end 
        end

        local point  = 0 

        for _ ,v in pairs(global.luaCfg:point_reward()) do 

            if v.activity_id == activity_id and  v.rank  == tonumber(msg.mailContent) then 
                point  = v.point
            end 
        end
        -- print(point,"point..//////////////",activity_id,"activity_id")
        str = luaCfg:get_local_string(tonumber(initMail.mailContent),point)

        print(str ,"str////")
        args = {point}

    elseif  msg.lMailID == 10154 then 

        local initMail = luaCfg:get_email_by(msg.lMailID)
        local strTb = global.tools:strSplit(msg.mailContent,'|') or {}
        str = luaCfg:get_local_string(tonumber(initMail.mailContent),msg.mailContent)

        args = {strTb[2],strTb[1]}

    elseif msg.lMailID == 10152  then 

        -- 解锁新功能
        local lvName = ""
        local initMail = luaCfg:get_email_by(msg.lMailID) 
        local temp = {}

        local strTb = global.tools:strSplit(msg.mailContent,'|') or {}
        local lv = tonumber(strTb[2] or 2) 
        strTb[1] = strTb[1] or 0

        if strTb[1] == "1" then
            temp = luaCfg:get_lord_lvup_by(lv)
            lvName = luaCfg:get_local_string(10761)
        else
            temp = luaCfg:get_city_lvup_by(lv)
            lvName = luaCfg:get_local_string(10762)
        end

        local conStr = ""
        for i=temp.maxNum,1,-1 do
            if conStr == "" then
                conStr = temp["func"..i]
            else
                conStr = temp["func"..i] .. "," .. conStr 
            end
        end
        str = luaCfg:get_local_string(tonumber(initMail.mailContent), lvName, lv, conStr)
        args = {lvName, lv, conStr}
    elseif msg.lMailID == 16002 then
        
        local initMail = luaCfg:get_email_by(msg.lMailID)
        str = luaCfg:get_translate_string(tonumber(initMail.mailContent), strTb[1] or "", strTb[2] or "")
        args = {strTb[1] or "", strTb[2] or ""}
    elseif msg.lMailID == 10156 then

        str = " "
        local postname1 = luaCfg:get_official_post_by(tonumber(strTb[1])).typeName  
        local lordname1 = strTb[2]
        local postname2 = luaCfg:get_official_post_by(tonumber(strTb[3])).typeName 
        args = {postname1, lordname1, postname2}
   
    elseif msg.lMailID == 10157 then

        str = " "
        local lordname1 = strTb[1]  
        local postname1 = luaCfg:get_official_post_by(tonumber(strTb[2])).typeName 
        local postname2 = luaCfg:get_official_post_by(tonumber(strTb[3])).typeName 
        args = {lordname1, postname1, postname2}
    elseif msg.lMailID == 10158 then

        str = " "
        local postname1 = luaCfg:get_official_post_by(tonumber(strTb[1])).typeName  
        local lordname1 = strTb[2]
        local postname2 = luaCfg:get_official_post_by(tonumber(strTb[3])).typeName 
        args = {postname1, lordname1, postname2}
    elseif msg.lMailID == 44001 then

        str = " "

        local inviter = strTb[1]
        local worldCampType = tonumber(strTb[2])
        local cityId = tonumber(strTb[3])
        local pixelpos = worldConst:convertCityId2Pix(cityId)
        local cord = worldConst:converPix2Location(pixelpos)
        local function getWorldCamp(campType)
            local world_camp = luaCfg:world_camp()

            for _,v in ipairs(world_camp) do

                if v.type == campType then

                    return v
                end
            end
        end
        local dststr = string.format("%s(%s,%s)",getWorldCamp(worldCampType).name,cord.x,cord.y)
        str = global.luaCfg:get_translate_string(10992,inviter,dststr)
        args = {inviter, dststr}

    elseif table.hasval(activity_boss ,  msg.lMailID) then 

        local strTb = global.tools:strSplit(msg.mailContent,'|') or {}
        args = {strTb[2] , strTb[1]} 
        str  = " "

    elseif table.hasval(activity_rank ,  msg.lMailID) then

        local strTb = global.tools:strSplit(msg.mailContent,'|') or {}
        args = {strTb[2] , strTb[1]} 
        str  = " "

    elseif table.hasval(activity_boss_join ,  msg.lMailID) then 
        str  = " "
        args ={msg.mailContent}

    elseif msg.lMailID == 16015 then 
        str  = " "

        local name = global.luaCfg:get_all_miracle_name_by(tonumber(msg.mailContent)).name
        args ={name}

    elseif msg.lMailID == 10172 then

        local strTb = global.tools:strSplit(msg.mailContent,'+') or {}
        str =" "
        args = {strTb[1] , strTb[2]} 


    elseif msg.lMailID == 10173 then

         str =" "
        args = {msg.mailContent} 

    elseif msg.lMailID == 10174 then 
        str =" "
        local serveridArr = global.tools:strSplit(msg.mailContent,' ') or {}
        local name = "" 
        for _ ,v in pairs(serveridArr) do 
            if name == "" then 
                name = global.ServerData:getServerNameById(v)
            else
               name = name ..",".. global.ServerData:getServerNameById(v)
            end 
        end 
        args ={name}
        
    elseif msg.lMailID == 10175 then 

        local strTb = global.tools:strSplit(msg.mailContent,'|') or {}
        str =" "
        local serveridArr = global.tools:strSplit(strTb[2],' ') or {}
        local name = "" 
        for _ ,v in pairs(serveridArr) do 
            if name == "" then 
                name = global.ServerData:getServerNameById(v)
            else
               name = name ..",".. global.ServerData:getServerNameById(v)
            end 
        end 

        local time = global.tools:strSplit(strTb[1],' ') or {}

        args ={global.mailData:getDataTime(tonumber(time[1])).." — "..global.mailData:getDataTime(tonumber(time[2])), name}

    elseif msg.lMailID == 10169 then

        str = " "
        local temp = luaCfg:get_all_miracle_name_by(tonumber(msg.mailContent)) or {}
        local mirname = temp.name or ""
        local pixelpos = worldConst:convertCityId2Pix(tonumber(msg.mailContent))
        local cord = worldConst:converPix2Location(pixelpos)
        args = {mirname, cord.x,cord.y}
    elseif  msg.lMailID == 10171 then

        str = " "
        local strTb = global.tools:strSplit(msg.mailContent,'|') or {}
        local heroPropD = global.heroData:getHeroPropertyById(tonumber(strTb[1]))
        args = {heroPropD.name, strTb[2] or 3}
    end
    return str,args
end

function UIMailDetailPanel:setMailContent(msg)

    self.texContent:setVisible(true)
    self.richContent:setVisible(false) 
    -- local isRichTest = false

    local strTb = global.tools:strSplit(msg.mailContent,'|') or {}

    local str = ""
    local args = {}
    -- 烧城邮件
    local fireCityStrCall = function ()
                
        local pos = worldConst:converPix2Location(cc.p(strTb[1], strTb[2]))
        str = luaCfg:get_local_string(10198,pos.x,pos.y)
        local downLv = 1
        if (#strTb >= 3) then
            local data = self:getStrTb(strTb)
            for _,v in pairs(data) do
                
                if v.id and v.id ~= "0" then
                    local buildInfo = luaCfg:get_buildings_pos_by(tonumber(v.id))
                    if buildInfo then
                        -- local strName = luaCfg:get_local_string(10197,buildInfo.buildsName, v.lv)
                        str = str.." "..buildInfo.buildsName
                        downLv = v.lv
                    end
                end
            end
        end
        args = {str, downLv}
    end 

    
    if msg.firstType == 2 then

        fireCityStrCall()
    else
        
        if msg.lMailID and  msg.lMailID ~= 0 then
            
            local localId,lType = 0, 0
            if self.lmailData then 
                localId = tonumber(self.lmailData.mailContent)
                lType = global.mailData:getMailShowType(localId)
            end

            -- 正常显示           
            local specStr,arg = self:specialMailStr(msg, strTb)
            args = arg

            print("specStr "  , specStr)
            print("lType" , lType)
            print("localId" , localId)

            dump(args,"args at 1")

            if specStr ~= "" then
                str = specStr
            else
                local pos = cc.p(0, 0)           
                if msg.firstType ~= 4 then
                    if #strTb > 1  and lType ~= 5 then
                        pos = worldConst:converPix2Location(cc.p(strTb[1], strTb[2]))
                    end
                end

                str,args = self:commonMailStr(lType, msg, strTb, pos)
                dump(args,"args at 2")
            end

            if str == "" and self.lmailData then
                str = self.lmailData.mailContent
            end

            -- 富文本显示
            if msg.lMailID == 15001 then
                isRichTest = true 
            end

        else
            str = msg.mailContent
        end

    end

    str = str or ""

    --dump(args,"args at 3")
    --dump(self.lmailData)

    local textH = 0
    local richTextKey = ""
    if self.lmailData then
        richTextKey =  self.lmailData.richText
    end
    local isRichTest = (richTextKey ~= "") 


    if isRichTest then
        
        local richTextId = tonumber(richTextKey)
        local datas = {}
        for index,v in ipairs(args) do
            datas['key_'..index] = v
        end        

        dump(datas,">>>check datas")        

        self.texContent:setVisible(false)
        self.richContent:setVisible(true)
        -- local heroName = luaCfg:get_hero_property_by(tonumber(msg.mailContent)).name  
        uiMgr:setRichText(self, "richContent", richTextId, datas)
        textH = self.richContent:getRichTextSize().height        
    else
        self.texContent:setTextAreaSize(cc.size(self.texContent:getContentSize().width,0))
        self.texContent:setString(str)
        local label = self.texContent:getVirtualRenderer()
        local desSize = label:getContentSize()
        self.texContent:setContentSize(desSize)
        textH = self.texContent:getContentSize().height
    end

    local itemH = self.itemLayout:getContentSize().height
    local contentSize = gdisplay.height - self.topLayout:getContentSize().height - self.bottomLayout:getContentSize().height
    local containerSize = textH 
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.scrollviewPanel:setContentSize(cc.size(gdisplay.width, contentSize))
    self.scrollviewPanel:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    self.scrollviewPanel:setPosition(cc.p(0, self.scroSize.height-contentSize))
    
    if isRichTest then
        self.richContent:setPositionY(containerSize)
    else
        self.texContent:setPositionY(containerSize - textH/2)
    end

    self.scrollviewPanel:jumpToTop()
    self.isRichTest = isRichTest
end

-- 去除相同元素 
function UIMailDetailPanel:getStrTb(strTb)

    local temp={} 

    for i=3,#strTb do
        local id = strTb[i]
        local lv = self:getBuildLevel(strTb, id)
        temp[id]=lv
    end

    local strTemp={} 
    for key,val in pairs(temp) do 
        local t = {}
        t.id = key
        t.lv = val
        table.insert(strTemp,t)               
    end
    return strTemp
end

function UIMailDetailPanel:getBuildLevel(strTb, buildId)

    local lv = 0
    for _,v in pairs(strTb) do
        if buildId == v then
            lv = lv + 1 
        end
    end
    return lv
end

function UIMailDetailPanel:checkGetState( state )

    local isGet = false
    if state == 1 then
        isGet = true
    end
    local children = self.scrollviewPanelNode:getChildren()
    for i,v in ipairs(children) do
        global.colorUtils.turnGray(v.reward_icon, isGet ) 
        global.colorUtils.turnGray(v.bg, isGet ) 
    end
end

function UIMailDetailPanel:refershState(msg)

    if not msg then 
        
        -- 防止报错 处理 
        return         
    end 

    _currentMailID = msg.mailID
    _GIFTSTATE = msg.itemState
    _appendixContent = msg.appendixContent

    self.btn_getGift:setEnabled(true)

    self.btn_getGift:setPositionX(360)
    self.btn_deleteMail:setPositionX(360)
    if msg.appendixContent == 0 then
        self.splitGift:setVisible(false)
    end
    if self:isAskJoinUnion() or self:isAskMoveCity() or self:isAskMoveCityMode2() then
        self.btn_getGift:setVisible(true)
        self.btn_deleteMail:setVisible(true)
        self.btn_getGift:setPositionX(250)
        self.btn_deleteMail:setPositionX(470)
        self.txt_get:setString(luaCfg:get_local_string(10307))

        if _GIFTSTATE ~= 0 then
            self.btn_getGift:setEnabled(false)
        else 
            self.btn_getGift:setEnabled(true)
        end 
    else
        self.txt_get:setString(luaCfg:get_local_string(10308))

        if msg.appendixContent == 0 then
            self.btn_getGift:setVisible(false)
            self.btn_deleteMail:setVisible(true)
        else
            if _GIFTSTATE ~= 0 then
                self.btn_getGift:setVisible(false)
                self.btn_deleteMail:setVisible(true)
            else 
                self.btn_getGift:setVisible(true)
                self.btn_deleteMail:setVisible(false)
            end 
        end
    end
end

function UIMailDetailPanel:initScroll(data)

    self.splitGift:setVisible(true)

    local textH = 0 
    if self.isRichTest then
        textH = self.richContent:getRichTextSize().height
    else
        textH = self.texContent:getContentSize().height
    end

    local splitSize = self.splitGift.bg:getContentSize()
    local itemH = self.itemLayout:getContentSize().height
    local contentSize = gdisplay.height - self.topLayout:getContentSize().height - self.bottomLayout:getContentSize().height
    local containerSize = (#data)*itemH + textH + splitSize.height
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.scrollviewPanel:setContentSize(cc.size(gdisplay.width, contentSize))
    self.scrollviewPanel:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    self.scrollviewPanel:setPosition(cc.p(0, self.scroSize.height-contentSize))

    local y,posY  = 0, 0
    if self.isRichTest then
        self.richContent:setPositionY(containerSize)
        y = self.richContent:getPositionY()
        posY = y - textH - splitSize.height
    else 
        self.texContent:setPositionY(containerSize - textH/2)
        y = self.texContent:getPositionY()
        posY = y - textH/2 - splitSize.height
    end
    self.splitGift:setPositionY(posY)
    
    local i = 1
    for _,v in pairs(data) do
        v.tips_node = self.tips_node
        self.item = self:getItem() 
        self.item:setPosition(0, posY - i * itemH)
        self.item:setData(v)
        self.scrollviewPanelNode:addChild(self.item)
        i = i+1
    end
    self.scrollviewPanel:jumpToTop()
end

function UIMailDetailPanel:getItem()
    
    local res = nil
    if #self.itemCache == 0 then
        res = UIMailRewardItem.new()
        res:retain()
    else
        res = self.itemCache[1]
        table.remove(self.itemCache,1)
    end
    return res
end

function UIMailDetailPanel:onExit()
    
    local children = self.scrollviewPanelNode:getChildren()
    for i,v in ipairs(children) do
        v:removeFromParent()
        table.insert(self.itemCache,v)
    end
end

function UIMailDetailPanel:onDestroyCallFunc()
    
    for i,v in ipairs(self.itemCache) do
        v:release()
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMailDetailPanel:btn_exit(sender, eventType) 
    
    if not self.isInit then
        return
    end
    self.isInBack = true
    global.sactionMgr:closePanelForAction("UIMailDetailPanel", "UIMailListPanel")
    self:updateInit()
end

function UIMailDetailPanel:getGift(sender, eventType)

    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"mail_collect")

    if self.isAskJoinUnion and self:isAskJoinUnion() then
        --邀请加入联盟邮件
        if not global.unionData:isMineUnion(0) then
            return global.tipsMgr:showWarning(luaCfg:get_local_string(10083))
        end
        if not self.lTargetId then
            return global.tipsMgr:showWarning("联盟id没有传过来"..vardump(self.data))
        end
        global.unionApi:allyAction(function()

            -- 同意
            global.mailData:updataGiftState({_currentMailID})
            global.mailApi:actionMail({_currentMailID}, 2, function(msg) end)
            
            if self.refershState then
                self:refershState(global.mailData:getItemMailData(_currentMailID))
            end
            global.tipsMgr:showWarning(luaCfg:get_local_string(10080))

        end,8,1,self.lTargetId)
    elseif self.isAskMoveCity and self:isAskMoveCity() then
        local strTb = global.tools:strSplit(self.data.mailContent,'|') or {}
        global.funcGame:highMoveCity(function()
            -- body
            global.worldApi:sendInviteMoveCity(function(msg)

                global.mailData:updataGiftState({_currentMailID})
                global.mailApi:actionMail({_currentMailID}, 2, function(msg) end)

                if self.refershState then
                    self:refershState(global.mailData:getItemMailData(_currentMailID))
                end

                if self.closeMailPanel then 
                    self:closeMailPanel()
                end 
                if global.scMgr:isWorldScene() then
                    msg = {lCityID = tonumber(strTb[3])}
                    global.g_worldview.worldPanel:setMainCityData(msg,true)
                    global.tipsMgr:showWarning("InviteMove01")
                else
                    global.scMgr:gotoWorldSceneWithAnimation()
                    global.tipsMgr:showWarning("InviteMove01")
                end        
                -- body
            end,2,strTb[3],nil)
        end)
    elseif self.isAskMoveCityMode2 and self:isAskMoveCityMode2() then

        global.funcGame:highMoveCitySpecial(function()
            local strTb = global.tools:strSplit(self.data.mailContent,'|') or {}                
            local tmpCall = function()
             
                global.worldApi:freeToMove(strTb[2],function(msg)

                    global.mailData:updataGiftState({_currentMailID})
                    global.mailApi:actionMail({_currentMailID}, 2, function(msg) end)

                    if self.refershState then
                        self:refershState(global.mailData:getItemMailData(_currentMailID))
                    end

                    if self.closeMailPanel then 
                        self:closeMailPanel()
                    end 
                    if global.scMgr:isWorldScene() then
                        -- msg = {lCityID = tonumber(strTb[3])}
                        global.g_worldview.worldPanel:setMainCityData(msg,true)
                        global.tipsMgr:showWarning("InviteMove01")
                    else
                        global.scMgr:gotoWorldSceneWithAnimation()
                        global.tipsMgr:showWarning("InviteMove01")
                    end                              
                end)
            end

            if global.troopData:isEveryTroopIsInsideCity() then

                tmpCall()
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")        
                panel:setData("CityMoveTroopsNo", function()
                       
                    tmpCall()
                end)
            end
        end)
    else
        
        global.mailData:updataGiftState({_currentMailID})
        global.mailApi:actionMail({_currentMailID}, 2, function(msg) end)
        
        if self.refershState then
            self:refershState(global.mailData:getItemMailData(_currentMailID))
        end
        global.tipsMgr:showTaskTips(luaCfg:get_local_string(10005)) 

        if self.checkGetState then 
            self:checkGetState(1)
        end 
    end
end

function UIMailDetailPanel:closeMailPanel()
    -- body
    global.panelMgr:closePanel("UIMailDetailPanel")
    global.panelMgr:closePanel("UIMailListPanel")
    global.panelMgr:closePanel("UIMailPanel")
    global.panelMgr:getPanel("UIMailPanel"):setPosition(cc.p(0, 0))
end


function UIMailDetailPanel:deleteMail(sender, eventType)

    global.mailApi:actionMail({_currentMailID}, 3, function(msg)
        -- dump(msg)
        if not self.updateInit or not self.isAskJoinUnion then 
            print("UIMailDetailPanel 791  >>>>>>>>>>>>> method nil  error ")
            return 
        end 

        global.sactionMgr:closePanelForAction("UIMailDetailPanel", "UIMailListPanel")
        global.mailData:deleteMail({_currentMailID})
        self:updateInit()

        if self:isAskJoinUnion() then
            --拒绝加入联盟邮件
            if not self.lTargetId then
                return global.tipsMgr:showWarning("联盟id没有传过来"..vardump(self.data))
            end
            global.unionApi:allyAction(function()
                -- 拒绝
            end,8,0,self.lTargetId)
        elseif self:isAskMoveCity() then
            local strTb = global.tools:strSplit(self.data.mailContent,'|') or {}
            global.worldApi:sendInviteMoveCity(function()
                global.tipsMgr:showWarning("UnionInvitation")
                -- body
            end,3,strTb[3],nil)
        end
    end)
end

function UIMailDetailPanel:updateInit()
    local  panel = global.panelMgr:getPanel("UIMailListPanel")
    panel:initData()
end


function UIMailDetailPanel:exit_call(sender, eventType)

    self.isInBack = true
    global.sactionMgr:closePanelForAction("UIMailDetailPanel", "UIMailListPanel")
    self:updateInit()
   
end
--CALLBACKS_FUNCS_END

function UIMailDetailPanel:isAskJoinUnion()
    return self.lmailData and (self.lmailData.firstType == 4 and self.lmailData.secondType == 2)
end

function UIMailDetailPanel:isAskMoveCity()
    if not self.data then return false end
    return (self.data.lMailID == 44001)
end

function UIMailDetailPanel:isAskMoveCityMode2()
    if not self.data then return false end
    return (self.data.lMailID == 43002)
end

return UIMailDetailPanel

--endregion
