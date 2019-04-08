local global = global
local luaCfg = global.luaCfg
local chat_cfg = require("asset.config.chat_cfg")

local _M = {
    _mailData = {}, 
    _mailTypeData = {}, 
    _mailDetailData = {[1]={}, [2]={},[3]={}, [4]={},[5]={},[6]={},[7]={},[8]={},},
    isNoFirst = false,
    mailCollect = {},
}

_M._MAILTITLE = ""    -- 邮件标题
_M._MAILTYPEID = 0    -- 邮件类型
_M._CURRENTMAILID = 0 -- 当前邮件id

local mailTypePanel = {
	[1] = {id=1, mailPanel="UIMailDetailPanel", },
	[2] = {id=2, mailPanel="UIMailDetailPanel", },
	[3] = {id=3, mailPanel="UIBattleNonePanel", },
	[4] = {id=4, mailPanel="UIMailDetailPanel", },
	[5] = {id=5, mailPanel="UIMailBattlePanel", },
    [6] = {id=6, mailPanel="UIMailBattlePanel", },
    [7] = {id=7, mailPanel="UIChatPrivatePanel", },
    [10] = {id=10, mailPanel="UIMailDetailPanel", },
}

function _M:init(msg, isPush) 

    self.titleStr = ""
    msg = msg or {}
    for _,v in pairs(msg) do
        self:addMail(v, isPush)
    end

    -- 进入初始化邮件类型
    if table.nums(self._mailTypeData) == 0 then
        self:setMailUnReadNum({})
    end
    self:updataData()
end

-- 收藏邮件
function _M:initMailHold(msg)
    -- body
    for _,v in pairs(msg or {}) do
        if not self:IsCollect(v.lID) then
            table.insert(self.mailCollect, self:changeServerData(v))
        end
    end
    self:updateMailHold()
end

-- 战报是否已经收藏
function _M:IsCollect(mailID)
    -- body
    for i,v in ipairs(self.mailCollect) do
        if v.mailID == mailID then
            return true
        end
    end
    return false
end

function _M:getMailHoldById(mailID)
    for i,v in ipairs(self.mailCollect) do
        if v.mailID == mailID then
            return v
        end
    end
end

function _M:deleteMailHold(_mailIDTb)

    for i,v in ipairs(_mailIDTb) do        
        for k,vv in ipairs(self.mailCollect) do
            if v == vv.mailID then
                table.remove(self.mailCollect, k)
                break
            end
        end
    end
    self:updateMailHold()
end

function _M:addMailHold(mailData)
    -- body
    if not mailData then return end
    if not mailData.mailID then return end
    for k,vv in ipairs(self.mailCollect) do
        if vv.mailID == mailData.mailID then
            print("collect exit!")
            return 
        end
    end
    table.insert(self.mailCollect, mailData)
    self:updateMailHold()
end

function _M:updateMailHold()
    -- body 
    self._mailDetailData[7] = clone(self.mailCollect)
    if table.nums(self._mailDetailData[7]) > 0 then
        table.sort(self._mailDetailData[7], function(s1, s2) 
            s1.time = s1.time or 0
            s2.time = s2.time or 0
            return s1.time > s2.time 
        end)
    end
end

function _M:isFirstLogic()
    self.isNoFirst = true
end

-- 添加邮件
function _M:addMail( msg, isPush )
    
    if self:checkMail(msg.lID) then
        self:addServerData(msg, isPush)
    end
end

function _M:checkMail( mailId )
    
    for _,v in pairs(self._mailData) do
        if mailId == v.mailID then
            return false
        end
    end
    return true
end

-- 将服务器数据转换成maildata数据
function _M:addServerData(v, isPush)
	
    table.insert(self._mailData, self:changeServerData(v))

    -- 新增邮件
    if self.isNoFirst and (not isPush) then
        self:updateUnReadNum(v.lType, 1)
    end
end

function _M:changeServerData(v)
    -- body

    local server = {}

    -- 邮件礼包附件
    if v.tgItems and table.nums(v.tgItems) > 0  and  (not self:isBattle(v.lType)) then
        server.appendixContent = 1
        server.tgItems = v.tgItems 
        if v.lState == 1 or v.lState == 0 then
            server.itemState = 0   -- 礼包未领取
        elseif v.lState == 2 then
            server.itemState = 1   -- 礼包已领取
        end
    else 
        server.appendixContent = 0  -- 没有礼包

        local lmailData = luaCfg:get_email_by(v.lMailID) 
        if (lmailData and lmailData.firstType == 4 and lmailData.secondType == 2) or v.lMailID == 44001 or v.lMailID == 43002 then
            if v.lState == 1 or v.lState == 0 then
                server.itemState = 0   -- 礼包未领取
            elseif v.lState == 2 then
                server.itemState = 1   -- 礼包已领取
            end
        else
            server.itemState = -1
        end
    end

    if v.tgItems and table.nums(v.tgItems) > 0  then
        server.tgItems = v.tgItems
    end


    -- 邮件读取状态
    if v.lState == 0 then
        server.state = 0
    else
        server.state = 1
    end

    -- 邮件类型图标
    server.firstType = v.lType
    -- 邮件图标
    server.secondType = 1

    server.Sender = v.szFromName or ""
    server.mailContent = v.szContent or ""

    server.mailName = v.szTitle or ""
    server.mailID = v.lID or 0
    server.time = v.lTime or 0
    server.tgFightReport = v.tgFightReport or {}
    server.lMailID = v.lMailID 
    server.lFromID = v.lFromID or 0
    server.isShortMail = v.isShortMail or 0 -- 是否是简报 0简报 1 详报
    server.lBigFight = v.lBigFight or 0 -- 是否是大战报 0小战报 1 大战报
    server.lCustom = v.lCustom or 0 -- 是否是自定义邮件 1 自定义

    return server

end

-- 修改自定义邮件状态
function _M:updatelCustomMail(_mailID, szTitle, szContent) 
    for k,v in pairs(self._mailData) do
        if _mailID == v.mailID then
            v.lCustom = 0
            v.mailName = szTitle
            v.mailContent = szContent
            v.Sender = global.luaCfg:get_email_by(11001).Sender
        end 
    end
end

-- 修改简报状态
function _M:updateDetailMail(_mailID, tgFightReport) 
    for k,v in pairs(self._mailData) do
        if _mailID == v.mailID then
            v.isShortMail = 1
            v.tgFightReport = tgFightReport
        end 
    end
end
-- 

function _M:updataData()    
    self:setMailDetailData()  
end

--------- 私聊未读数 ---------
function _M:addCurPriUnReadNum()
    self.chatPriUnReadNum = self.chatPriUnReadNum or 0
    self.chatPriUnReadNum = self.chatPriUnReadNum + 1
end

function _M:setCurPriUnReadNum(num)
    self.chatPriUnReadNum = num 
end

function _M:getCurPriUnReadNum()
    if self.chatPriUnReadNum < 0 then self.chatPriUnReadNum = 0 end
    return self.chatPriUnReadNum
end


-- 所有邮件标记已读
function  _M:updataMailStateAll(lType)

    for k,v in pairs(self._mailData) do

        local isCurType = lType and lType == v.firstType 
        if not lType then
            isCurType = true
        end

        if v.state == 0 and isCurType then
            v.state = 1
            -- 已读且礼包已领
            if v.itemState ~= 0 then
                self:updateUnReadNum(v.firstType, -1)
            else
                -- 联盟邀请同意邮件
                local lmailData = luaCfg:get_email_by(v.lMailID)
                if lmailData and (lmailData.firstType == 4) and (lmailData.secondType == 2) then
                    self:updateUnReadNum(v.firstType, -1)
                end
            end
        end
    end

    lType = self:checkMailType(lType)
    for _,v in pairs(self._mailTypeData) do              
        if v.typeId == lType then
            v.unReadNum =  0
            break
        end        
    end
    gevent:call(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM)

end

-- 1 系统 
-- 2 迁城系统邮件 
-- 3 敌我力量差距大战报 
-- 4 联盟 、5 战争战报 、 6 公告 、7 个人  8 pve战报 9 收藏类型 10 采集报告

-- 邮件type->表格type
function _M:checkMailType(typeId)
    
    -- 特殊邮件类型特殊处理
    if typeId == 2 then     -- 系统
        typeId = 1
    elseif typeId == 3 then -- 战争
        typeId = 5
    elseif typeId == 8 then -- PVE战报
        typeId = 6
    elseif typeId == 10 then -- 采集报告
        typeId = 8
    end
    return typeId
end

-- 表格type->邮件type
function _M:checkDetailType(typeId)
    if typeId == 2 then 
        typeId = 6
    elseif typeId == 6 then
        typeId = 8
    elseif typeId == 7 then
        typeId = 9
    elseif typeId == 8 then
        typeId = 10
    end
    return typeId
end

function _M:isBattle(firstType)
    return firstType == 5 or firstType == 8
end

function _M:setMailUnReadNum(msg)

    local typeData = luaCfg:type()
    self._mailTypeData = clone(typeData)
    for _,v in pairs(self._mailTypeData) do       
        for _,vv in pairs(msg) do
            local lType = self:checkMailType(vv.lID)
            if lType == 7 then
                self:setCurPriUnReadNum(vv.lValue)  -- 私聊未读数
            else
                if v.typeId == lType then
                    v.unReadNum = vv.lValue
                    break
                end
            end
        end 
    end
end

function _M:getMailUnReadNum()

    local totalUnReadNum = 0
    for _,v in pairs(self._mailTypeData) do       
        totalUnReadNum = totalUnReadNum + v.unReadNum
    end
    self.chatPriUnReadNum = self.chatPriUnReadNum or 0
    return totalUnReadNum + self.chatPriUnReadNum
end

-- parm: 1新增邮件 -1读取邮件
function _M:updateUnReadNum(typeId, parm)

    local lType = self:checkMailType(typeId)
    for _,v in pairs(self._mailTypeData) do              
        if v.typeId == lType then
            v.unReadNum =  v.unReadNum + parm   
        end        
    end
    gevent:call(global.gameEvent.EV_ON_UI_MAIL_UNREADNUM)
end

function  _M:updataReadState(mailID, curMailType)

    for k,v in pairs(self._mailData) do
        if v.mailID == mailID and v.state == 0 then
            v.state = 1
            -- 已读且礼包已领
            if v.itemState ~= 0 then
                self:updateUnReadNum(v.firstType, -1)
            else
                -- 联盟邀请同意邮件
                local lmailData = luaCfg:get_email_by(v.lMailID)
                if lmailData and (lmailData.firstType == 4) and (lmailData.secondType == 2) then
                    self:updateUnReadNum(v.firstType, -1)
                end
            end
            curMailType = nil
        end
    end

    if curMailType then
        self:updateUnReadNum(curMailType, -1)
    end

end

function _M:setMailDetailData()

    local  tb_SysData = {}
    local  tb_DevData = {}
    local  tb_OwnData = {}
    local  tb_UnionData = {}
    local  tb_BattleData = {}
    local  tb_BattlePvpData = {}
    local  tb_harvest = {}

    for k,v in pairs(self._mailData) do

        if v.firstType == 1 or v.firstType == 2 then
            table.insert(tb_SysData, v)
        elseif v.firstType == 3 or self:isBattle(v.firstType) then
            if not  v. tgFightReport.bPve then 
                table.insert(tb_BattleData, v)
            else
                table.insert(tb_BattlePvpData, v)
            end 
        elseif v.firstType == 7 then
            table.insert(tb_OwnData, v)
        elseif v.firstType == 4 then 
            table.insert(tb_UnionData, v)
        elseif v.firstType == 10 then 
            table.insert(tb_harvest, v)
        end
    end

    -- ltype 3、5战报分页处理(通知邮件数据处理)
    if not self.isNoFirst then

        table.sort(tb_SysData, function (m1, m2) return m1.mailID > m2.mailID end)
        table.sort(tb_BattleData, function (m1, m2) return m1.mailID > m2.mailID end)

        local resetMail = function (mailID)
            for k,v in pairs(self._mailData) do
                if v.mailID == mailID then
                    self._mailData[k] = nil
                end
            end
        end

        local checkFirstPage = function (data) -- 只保留第一分页数据
            for i=11, #data do
                if data[i] then
                    resetMail(data[i].mailID or 0)
                    data[i] = nil
                end
            end
        end
        checkFirstPage(tb_SysData)
        checkFirstPage(tb_BattleData)
    end

    self._mailDetailData[1] = tb_SysData
    self._mailDetailData[2] = tb_DevData
    self._mailDetailData[3] = tb_OwnData
    self._mailDetailData[4] = tb_UnionData
    self._mailDetailData[5] = tb_BattleData
    self._mailDetailData[6] = tb_BattlePvpData
    self._mailDetailData[8] = tb_harvest

    for i=1,8 do
        if table.nums(self._mailDetailData[i]) > 0 then
            table.sort(self._mailDetailData[i], function(s1, s2) 
                s1.time = s1.time or 0
                s2.time = s2.time or 0
                return s1.time > s2.time 
            end )
        end
    end

  
end

---- 获取邮件显示类型
function _M:getMailShowType(localId)

    local lType = 0
    --标记localization里有几个参数
    local showMailType = {
        [1] = {10211,  10213 , 10214 , 10239 , 10243, },
        [2] = {10212,  10234 , 10235 , },
        [3] = {10226,  10241 , },
        [4] = {10292,  10294, },
        [5] = {10245,  10290, 10306, 10313, 10315, 10317, 10319, 10376, 10377,},
        [6] = {10706, 10277,  10440, 10439, 10477,10532, 10556, 10512,10510,10519,10516,10618,10617,10637,10636,10634,10513,10650,},
    }

    for i=1,#showMailType do
        for _,v in pairs(showMailType[i]) do
            if v == localId then
                lType = i
            end
        end
    end

    return lType
end

function _M:getMailData()
    
    return self._mailData 
end

function _M:getMailPanel(id)
    
    if id == 8 then id = 5 end
    for _,v in pairs(mailTypePanel) do
    	if v.id == id then
    		return v.mailPanel 
    	end
    end
end

function _M:getMailTypeData(_typeId)
    
    for k,v in pairs(self._mailTypeData) do
        if v.typeId == _typeId then
            return v
        end
    end
end

function _M:getMailDetailData(_typeId)
    return self._mailDetailData[_typeId]
end
 
function _M:getItemMailData(_mailID)
    
    for k,v in pairs(self._mailData) do
        if _mailID == v.mailID then
            return v
        end 
    end
end

function  _M:getTypeIcon(_typeId)
    
    local iconList = luaCfg:icon()
    for k,v in pairs(iconList) do
        if v.firstType == _typeId then
            return v.firstIcon
        end
    end
end

function  _M:getItemIcon(iconType)
    
    local iconList = luaCfg:icon()
    for k,v in pairs(iconList) do
        if v.secondType == iconType then
            return v.mailIcon
        end
    end
    return "ui_surface_icon/icon_mail_temp.png"
end

function  _M:getTypeId(_typeTitle)
    
    for k,v in pairs(self._mailTypeData) do
        if v.name == _typeTitle then
            return v.typeId
        end
    end
end

function  _M:updataGiftState(_mailIDTb)

    local updateGift = function (_mailID)
        
        for k,v in pairs(self._mailData) do
            if v.mailID == _mailID then
                v.itemState = 1
                -- 更新未读信息             
                self:updateUnReadNum(v.firstType, -1)
            end
        end
    end
    
    for i,v in ipairs(_mailIDTb) do        
        updateGift(v)
    end

    self:updataData()
end

function _M:deleteMail(_mailIDTb)

    local delete = function (_mailID)
        
        for k,v in pairs(self._mailData) do
            if v.mailID == _mailID then

                table.remove(self._mailData, k)
                -- 更新未读信息   
                if v.state == 0 or v.itemState == 0 then         
                    self:updateUnReadNum(v.firstType, -1)
                end

                -- 删除战报
                if self:isBattle(v.firstType) then
                    self:deleteLocalFile(v.tgFightReport.szReportid)
                end

            end
        end
    end
    
    for i,v in ipairs(_mailIDTb) do        
        delete(v)
    end

    self:updataData()
end

function _M:getTime(_mailID, time, lType)

    local curTime = 0
    if time and _mailID == 0 then
        curTime = time
    else
        if lType and lType == 7 then -- 战报收藏
            local temp1 = self:getMailHoldById(_mailID)
            if temp1 then curTime = temp1.tgFightReport.lTime end
        else
            local temp2 = self:getItemMailData(_mailID)
            if temp2 then curTime = temp2.time  end
        end
    end
    return self:getFormatTime(curTime)
end

function _M:getFormatTime(curTime)

    local  currentTime = global.dataMgr:getServerTime()
    local strTime = ""
    local localStrId = 0 

    local time = currentTime - curTime
    if time <= 0 then time = 1 end
    local CurNum = 0 
    local CFG = chat_cfg.FORTIME
    if time >= CFG.YEAR then
        localStrId = 10084
        CurNum = CFG.YEAR
    elseif time >= CFG.MONTH then
        localStrId = 10085
        CurNum = CFG.MONTH
    elseif time >= CFG.DAY then
        localStrId = 10086
        CurNum = CFG.DAY
    elseif time >= CFG.HOUR then 
        localStrId = 10087
        CurNum = CFG.HOUR
    elseif time >= CFG.MINUTE then
        localStrId = 10088
        CurNum = CFG.MINUTE
    elseif time >= CFG.SECOND then
        localStrId = 10089
        CurNum = 1
    end
    
    strTime = math.floor(time/CurNum)
    if strTime <= 0 then strTime = 1 end
    local localStr = luaCfg:get_local_string(localStrId)
    return (strTime..localStr)

end

function _M:getData(_mailID)

    local tempData = self:getItemMailData(_mailID)
    if tempData == nil then
        return "00:00:00"
    end
    
    local strTime = self:getDataTime(tempData.time)
    return  strTime
end

-- 2017-1-6 12:00:00
function _M:getDataTime(time)
    
    local tempTable = global.funcGame.formatTimeToTime(time)
    local timeStr = luaCfg:get_local_string( 10017 , tempTable.hour, tempTable.minute, tempTable.second )
    local strTime = tempTable.year.."-"..tempTable.month.."-"..tempTable.day.."  "..timeStr
    return  strTime
end

function _M:getRandomName()
    
    local randID1 = math.random(2,64)
    local randID2 = math.random(65,163)
    local  tb_Name1 = luaCfg:get_rand_name_by(randID1)
    local  tb_Name2 = luaCfg:get_rand_name_by(randID2)

    return tb_Name1.text..tb_Name2.text
end

function _M:setTitleStr(curStr)
    self.titleStr = curStr
end
function _M:setCurMailTitleStr(lType, fightType, mailId, contentId, parmList)

    local strParm = "@"
    for _,v in pairs(parmList) do
        strParm = strParm..v.."/"
    end
    fightType = fightType or ""
    lType = lType or 0
    mailId = mailId or 0
    contentId = contentId or 0

    self.titleStr = lType.."@"..fightType.."@"..mailId.."@"..contentId..strParm
end
function _M:getCurMailTitleStr()

    return self.titleStr
end

-- 战报数据设置标题
function _M:setTitleStrByData(data)

    data = self:changeServerData(data)

    local contentParm = {}
    local getSoldierCount = function (data)
        -- body
        local killCount, loseCount, scale = 0, 0, 0
        local ltype = 0
        local userId = global.userData:getUserId()
        if data.tgAtkUser then
            for _,v in pairs(data.tgAtkUser) do
                if v.lUserID == userId then
                    ltype = 1
                end
            end
        end

        if ltype == 1 then
            if data.tgDefParty then 
                killCount = data.tgDefParty.lWoundCount + data.tgDefParty.llosCount
                scale = data.tgDefParty.lTotalTroop
            end
            if data.tgAtkParty then
                loseCount = data.tgAtkParty.llosCount +data.tgAtkParty.lWoundCount
            end

        else
            if data.tgDefParty then -- g
                -- loseCount = data.tgDefParty.lWoundCount
                loseCount = data.tgDefParty.llosCount +data.tgDefParty.lWoundCount
            end
            if data.tgAtkParty then -- f 
                -- killCount = data.tgAtkParty.llosCount
                 killCount = data.tgAtkParty.lWoundCount + data.tgAtkParty.llosCount
                scale = data.tgAtkParty.lTotalTroop
            end
        end
        return killCount, loseCount,  scale, ltype
    end

    local checkListState = function (mailId, scale, ltype, lResult, loseCount, killCount)
        if ltype == 1 then
            if lResult == 1 then          
                table.insert(contentParm, scale)
                table.insert(contentParm, loseCount)
            else
                table.insert(contentParm, loseCount)
            end
        else
            table.insert(contentParm, killCount)
        end
    end
    
    if data.lMailID and data.lMailID ~= 0 then
        local temp = luaCfg:get_email_by(data.lMailID) 
        local iconData = luaCfg:icon()
        for _,v in pairs(iconData) do
           
            if  (global.mailData:isBattle(v.firstType)) and v.secondType == temp.secondType then
            
                local mailId = tonumber(temp.mailName)
                local killCount, loseCount, scale, ltype = getSoldierCount(data.tgFightReport)
                table.insert(contentParm, killCount)
                table.insert(contentParm, loseCount)
                if data.tgFightReport.lPurpose == 3 then
                    contentParm = {}
                    checkListState(mailId,scale, ltype, data.tgFightReport.lResult, loseCount, killCount)
                end
            end
        end
    end

    local mailId = data.lMailID or 0
    local defName = data.tgFightReport.szDefName or ""
    local firstType = data.firstType or 0
    global.mailData:setCurMailTitleStr(firstType, data.tgFightReport.lFightType, mailId, defName,  contentParm)

    -- 查看战报结束红点数减少
    self:updataReadState(data.mailID)
 
end

function _M:getMailTitleByInfo(titleStr)

    local textTb = {}
    local strTb = string.split(titleStr, "@")

    local lType     = tonumber(strTb[1])
    local fightType = tonumber(strTb[2])
    local lMailId    = tonumber(strTb[3])
    local contentId = strTb[4]
    local strParm   = strTb[5]

    if lType ~= 3 and (not self:isBattle(lType)) then
        return strTb
    end


    if lType == 3 then

        table.insert(textTb, "")
        table.insert(textTb, luaCfg:get_local_string(10199))
    else

        local temp = luaCfg:get_email_by(lMailId)
        local texId = tonumber(temp.Title)
        local mailId = tonumber(temp.mailName)

        local strName = ""
        if fightType ~= 1 then
            local tempData = self:getDataByType(fightType, tonumber(contentId)) or {}
            strName = tempData.name or ""
        else         
            strName = contentId
        end

        local texName = luaCfg:get_local_string(texId, strName)
        table.insert(textTb, texName)

        local parm = string.split(strParm, "/")
        local texContent = luaCfg:get_local_string(mailId, unpack(parm))
        table.insert(textTb, texContent)

    end
    return textTb
end


-- 根据不同类型读取
-- fightLocalUserCity = 1, // 城池战斗
-- fightLocalUserMap = 2, // 地图战斗（资源、帐篷）
-- fightLocalMonster = 3, // 怪物
-- fightLocalLCStrongholdTower = 5, // 哨塔
-- fightLocalUserMapEmpty = 6,   // 小村庄
-- fightLocalLCStronghold = 7,
function _M:getDataByType(lType, id)
    
    if not id then return {name="-"} end
    local strId = id

    lType = tonumber(lType)
    id = tonumber(id)
    if lType == 2 or lType == 8 or lType == 18 then        
        local resData = luaCfg:get_wild_res_by(id)
        return resData
    elseif lType == 3 then

        local monsterData = luaCfg:get_wild_monster_by(id)
        if not monsterData then
            monsterData = luaCfg:get_wild_monster_by(id-math.floor(id%10)+1) or luaCfg:get_wild_monster_by(id-math.floor(id%10)+2)
        end
        return monsterData
    elseif lType == 5 or lType == 6 or lType == 7 then
        local sData = luaCfg:get_world_type_by(id)
        if not sData then
            sData = luaCfg:get_all_miracle_name_by(id)
        end
        return sData
    elseif lType == 9 then
        local monsterData = luaCfg:get_worldboss_by(id)        
        return luaCfg:get_wild_monster_by(monsterData.monsterID)
    else
        return {name=strId}
    end
end


-------------------- 大战报php下载 --------------------

local pbpack = require "pbpack"
local lfs = require "lfs"

function _M:getFileBasePath()
    return cc.FileUtils:getInstance():getWritablePath().."battleMail/"..global.loginData:getCurServerId()
end

function _M:getFilePath(szReportid)

    local basePath = self:getFileBasePath()
    local fileUtils = cc.FileUtils:getInstance()
    if not fileUtils:isDirectoryExist(basePath) then
        fileUtils:createDirectory(basePath)
    end
    local filename = basePath.."/".. tostring(szReportid)
    return filename
end

function _M:getRequestUrl(szReportid)

    local app_cfg = require "app_cfg"
    local urlHead = app_cfg.get_plat_url().."download/bigfight.php?"
    local requestData = {}
    requestData.fight_id = szReportid
    requestData.replay   = 0

    local url = urlHead..'svr_id='..global.loginData:getCurServerId()
    for k,v in pairs(requestData) do 
        url=url..'&'..k..'='..v
    end
    return url
end

function _M:deleteLocalFile(szReportid) 
    cc.FileUtils:getInstance():removeFile(self:getFilePath(szReportid))
end

function _M:getBattleFileData(szReportid)
    -- body
    szReportid = tostring(szReportid)
    local basePath = self:getFileBasePath()

    local status, data_name = self:CheckisExitsPlus(szReportid)
    print(status,    " --------------------- getBattleFileData status:")
    print(data_name, " --------------------- getBattleFileData data_name:")

    if status then 
        local pbText = io.readfile(basePath.."/"..data_name)
        pbText = self:replaceBoom(pbText)
        pbText = pbText or ""
        local data = global.netRpc:packBodyForOuter(pbText, "FightReport") 
        return data
    else
        global.tipsMgr:showWarning("Open FileError!")
    end 
end

function _M:replaceBoom(ret)

    ret = ret or ""
    local byteStr = ""
    if string.byte(ret,1)==9 and string.byte(ret,2)==10  then 
        for i=3, string.len(ret) do         
            local t = string.byte(ret, i)
            byteStr = byteStr .. string.char(t)
        end
    end
    return byteStr
end

function  _M:CheckisExitsPlus(szReportid) -- 返回 状态 和 文件名

    local allfile = self:getAllLocalFile()
    if not allfile then return false end 
    for _, v in pairs(allfile) do
        if tostring(szReportid) == v then 
            return true, v
        end          
    end 
    return false, nil
end 

function _M:getAllLocalFile()

    local filename_lsit = {} 
    if not cc.FileUtils:getInstance():isDirectoryExist(self:getFileBasePath()) then 
        return nil      
    end 
    function attrdir (path)
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                table.insert(filename_lsit , file)
            end 
        end
    end
    attrdir(self:getFileBasePath())
    return filename_lsit
end 


global.mailData = _M
