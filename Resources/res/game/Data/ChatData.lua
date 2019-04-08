
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local global = global
local luaCfg = global.luaCfg
local chat_cfg = require("asset.config.chat_cfg")
local crypto  = require "hqgame"

local _M = {
    allChat  = {},
    template = {},
    curChat  = {},
    curSelectUser = {},
    chatUnionGift = {},
}

function _M:init()  

    if self.template and table.nums(self.template) > 0 then
    else
        self.transRecode = {}  -- 翻译纪录
        self:initParm()        -- 初始化参数
        self:initTemplate()    -- 所有ui模板初始化
        self:readShieldList()  -- 读取本地玩家屏蔽列表
    end
end

function _M:initParm()

    self.currChatType = 0      -- 当前聊天类型
    for i=2,4 do 
        self["firstPush"..i] = true  -- 是否第一次拉取
        self["page"..i] = 0          -- 数据拉取是否全部完成
    end

    self.currChatPage = 2      
    local chatPage = cc.UserDefault:getInstance():getStringForKey("ChatSelect")
    if chatPage ~= "" then
        self.currChatPage = tonumber(chatPage)
    end
end

-- 预先初始化所有需要的ui模板
local CHATITEM_TYPE = {
    [1] = "UIChatPrivateL",    
    [2] = "UIChatPrivateR",     
}
function _M:initTemplate()
    
    local itemTable = {}
    for i=1,#CHATITEM_TYPE do
        local tb = {}
        local item = require("game.UI.chat.item."..CHATITEM_TYPE[i]).new()
        item:retain()
        tb.id = i
        tb.item = item
        table.insert(itemTable, tb)
    end
    self.template = itemTable
end

------------------------------ 添加ui数据 ---------------------------

function _M:getChatMsg(msg)

    msg = msg or {}
    local data = {}
    local id = #msg
    for _,v in pairs(msg) do
        local chatData = self:addUiData(v, id)
        table.insert(data,  chatData)
        id = id - 1
    end
    table.sort( data, function(s1, s2) return s1.id < s2.id end )
    return data
end

function _M:addUiData(v, id)

    local data = clone(v)
    data.id = id
    data.sendState = data.sendState or 0
    data.cellH = 0 
    data.textSize = {0, 0}
    data.timeStr = ""

    -- 翻译状态
    data.tranStr   = data.tranStr or ""  
    data.tranState = data.tranState or 0
    
    --- itemType 消息显示内容模板
    if data.lFrom == global.userData:getUserId() then
        data.itemType = 2
    else
        data.itemType = 1 
    end
    --- itemKind (1 普通消息2 分享战报)
    if data.tagSpl then
        data.itemKind = 2
    else
        data.itemKind = 1
    end 

    self:checkCellUI(data)
    return data
end

-- 初始化当条聊天消息
function _M:resetChatUI(cellData)
    -- body
    cellData.cellH = 0
    cellData.textSize = {0, 0}
    self:checkCellUI(cellData)
    if cellData.timeStr ~= "" then
        cellData.cellH = cellData.cellH + chat_cfg.chat_item_ui.item_cell_time
    end
end

-- sendState 消息发送状态
-- (0 已发送 1 发送中 2 发送失败)

-- cellH       单个cell显示高度
-- timeStr     时间显示内容
-- textSize    文本内容显示宽高
function _M:checkCellUI(data)

    for _,itemFile in pairs(self.template) do
        if data.itemType == itemFile.id then
            itemFile.item:setData(data)
            local height, textSize = itemFile.item.ItemControl:setTableCellHeight()
            -- 已翻译节点高度
            if data.tranState == 1 then
                height = height + chat_cfg.chat_item_ui.transNode_height
            end
            data.cellH = height
            data.textSize = textSize
        end
    end
end

------- 刷新时间并更新ui数据
function _M:updateTime(curChatData)
 
    table.sort(curChatData, function (c1, c2) 

        c1.id = c1.id or 0
        c2.id = c2.id or 0
        c1.lTime = c1.lTime or 0
        c2.lTime = c2.lTime or 0

        if c1.lTime == c2.lTime then
            return c1.id < c2.id 
        else
            return c1.lTime < c2.lTime 
        end
    end)

    local tempData = {}
    for i=1,#curChatData do
        
        local last = curChatData[i]
        if i > 1 then
            local pre = curChatData[i-1]
            local curTimeStr = self:checkIsSameTime(pre, last)
            if curTimeStr ~= "" then
                local data = self:checkRefershTime(last)
                last.cellH = data.cellH
                last.timeStr = curTimeStr
            else               
                if last.timeStr ~= "" then
                   last.timeStr = ""
                   last.cellH = last.cellH - chat_cfg.chat_item_ui.item_cell_time
                end
            end
        else
            local data = self:checkRefershTime(last)
            last.cellH = data.cellH
            last.timeStr = data.timeStr
        end
    end
    tempData = curChatData
    return tempData
end

function _M:checkIsSameTime(preChat, lastChat)
    
    local preStr = self:getReceiveTimeStr(preChat.lTime)
    local lastStr = self:getReceiveTimeStr(lastChat.lTime)

    if preStr == lastStr then
        return ""
    else
        return lastStr
    end
end

function _M:checkRefershTime(data)

    local tempData = {}
    local timePadding = chat_cfg.chat_item_ui.item_cell_time
    local curTimeStr = self:getReceiveTimeStr(data.lTime)
    if data.timeStr == "" and curTimeStr ~= "" then
        data.cellH = data.cellH + timePadding
        data.timeStr = curTimeStr
    end
    tempData = data
    return tempData
end

function _M:getReceiveTimeStr(receiveTime)

    local timeStr = ""
    local curTime = global.dataMgr:getServerTime()
    local timePa = curTime-receiveTime
    if timePa >= 60 then -- 超过一分钟显示时间
        if timePa < 3600 then
            timeStr = luaCfg:get_local_string(10281, math.floor(timePa/60))
        else
            timeStr = global.mailData:getDataTime(receiveTime)
        end
    end
    return timeStr
end


------------------------------ 已拉取数据存储 ---------------------------

-- self.allChat = {[1] = {key=0, value={}, lPage=0}}
-- key : 对方userid     (2 表示国家   3 表示联盟)
-- value： 所有聊天记录数据

function _M:getAllChat()
    return self.allChat
end

function _M:getChatByKey(toUserId)
    
    for _,v in pairs(self.allChat) do
        if v.key == toUserId then
            return v
        end
    end
    return nil
end

--- 上次刷新的记录数据
function _M:setCurChat(data)
    self.curChat = data
end

-- 更新当前用户聊天记录
function _M:saveChat(toUserId, data, curPage)
    for i,v in pairs(self.allChat) do
        if v.key == toUserId then
            self.allChat[i].value = data
            v.lPage = curPage 
            return
        end
    end

    local chat = {}
    chat.key=toUserId
    chat.value=data
    chat.lPage=curPage
    table.insert(self.allChat, chat)
end

function _M:reflushData(data)

    if #self.curChat == 0 then
        table.insert(self.curChat, data[1] or {})
    end

    for _,v in pairs(data) do

        for _,curInfo in pairs(self.curChat) do
            
            if curInfo.lFrom == v.lFrom then
                v.szFrom = curInfo.szFrom
                v.lFaceID = curInfo.lFaceID
                v.szAllyNick = curInfo.szAllyNick
            end
        end
    end
end

function _M:inertChat(chat, data)
    
    local chatNum = #chat
    local i = 0
    for _,v in pairs(chat) do
        v.id = i + chatNum
        table.insert(data, v)
        i = i + 1
    end
    table.sort(data, function(s1, s2) return s1.id < s2.id end )
    return data
end

function _M:addChat(toUserId, data)

    local temp = {}
    table.insert(temp, data)

    temp = self:getChatMsg(temp)
    for _,v in pairs(self.allChat) do
        if v.key == toUserId then
            temp[1].id = 1 + (#v.value)
            self:refershUserInfo(v.value, temp[1])
            table.insert(v.value, temp[1])
            return
        end
    end

    local chat = {}
    chat.key=toUserId
    chat.value=temp
    chat.lPage=1
    table.insert(self.allChat, chat)
end

-- 刷新用户聊天记录信息
function _M:refershUserInfo(data, curInfo)

    for _,v in pairs(data) do
        if curInfo.lFrom == v.lFrom then
            v.szFrom = curInfo.szFrom
            v.lFaceID = curInfo.lFaceID
            v.szAllyNick = curInfo.szAllyNick
            v.lBackID = curInfo.lBackID
            v.lTotem = curInfo.lTotem or 0
        end
    end
end

function _M:getChatId( data )
    
    local toUserId = 0
    if data.lType == 1 then

        local m_userId = global.userData:getUserId()
        if data.lFrom and m_userId ~= data.lFrom then
            toUserId = data.lFrom
        elseif data.lTo and m_userId ~= data.lTo then
            toUserId = data.lTo
        end
    else
        toUserId = data.lType
    end
    return toUserId

end

-- 删除记录
-- 2 国家、3 联盟、4系统
function _M:removeChatByKey(key)
    
    for _,v in pairs(self.allChat) do      
        if v.key == key then
            v.value = {}
        end
    end

    if key == 2 or key == 3 or key == 4 then
        for i=2,4 do
            self["page"..i] = 0
        end
    end
end

function _M:cleanAllChat()
    self.allChat = {}
end

------------------------------------- 聊天类型 -------------------------------------
function _M:chatResume()

    for i=2,4 do
        self["firstPush"..i] = true
    end

    self:cleanAllChat()
    self:setIsResume(true)
    self:pushUnionUnRead()
    self:refershChatRecruitMsg()
    self:refershUnionGift()
    global.isTranslating = nil
end

function _M:setFirstPush(lType, value)
    self["firstPush"..lType] = value or false
end
function _M:getFirstPush(lType)  
    return self["firstPush"..lType] 
end

-- 当前聊天类型(1，私聊 2，世界  3，联盟)
function _M:setCurLType(lType)
    self.currChatType = lType
end
function _M:getCurLType()
    return self.currChatType or 0
end


-- 国家联盟当前聊天分页
function _M:setCurChatPage(page)
    
    self.currChatPage = page
end
function _M:getCurChatPage()
    
    return self.currChatPage or 0
end

-- 当前是否加入联盟
function _M:isJoinUnion()
    
    local allyId = global.userData:getlAllyID()
    if allyId == 0 then
        return false
    else
        return true
    end
end

function _M:getChatItem(type)
    
    return CHATITEM_TYPE[type]
end

function _M:setIsPushAll(chatPage)
    self["page"..chatPage] = 1
end

function _M:getIsPushAll(chatPage)
    return  self["page"..chatPage]
end

-- 联盟红点
function _M:setUnionUnRead(num)
    self.unionUnRead = num
    gevent:call(global.gameEvent.EV_ON_UNION_CHATUNREAD)
end
function _M:getUnionUnRead()
    return self.unionUnRead or 0
end

function _M:pushUnionUnRead()

    global.chatApi:getUnReadNum(function (msg)
        self.unionUnRead = msg.lCount or 0
        gevent:call(global.gameEvent.EV_ON_UNION_CHATUNREAD)
    end ,2)
end

-- 切入后台记录
function _M:setIsResume(isResume)
    self.isResume = isResume
end
function _M:getIsResume()
    return self.isResume or false
end

------------------------ 聊天屏蔽成员 ----------------------

function _M:getShield()
    
    return self.shieldUser
end

-- 从本地读取屏蔽名单
function _M:readShieldList()

    self.shieldUser = {}      -- 玩家屏蔽列表
    local id = global.userData:getUserId()
    local shieldList = cc.UserDefault:getInstance():getStringForKey("SHIELDLIST"..id)
    if shieldList ~= "" then
        self.shieldUser = self:decodeShieldList(shieldList)
    end
end

-- 加入屏蔽名单
function _M:addShield(userId)

    if not self.shieldUser then return end
    for i,v in ipairs(self.shieldUser) do
        if v == userId then
            return
        end
    end

    -- 发送屏蔽协议
    global.chatApi:operateChatList(function(msg)
    end, 2, {userId})

    table.insert(self.shieldUser, userId)
    self:writeShieldList(self.shieldUser)
    gevent:call(global.gameEvent.EV_ON_CHAT_SHIELD)
    global.tipsMgr:showWarning("BLACK_LIST_SUCCESS")
end

-- 从屏蔽名单中移除
function _M:removeShield(userId)
    if not self.shieldUser then return end
    for i,v in ipairs(self.shieldUser) do
        
        if v == userId then
            global.chatApi:operateChatList(function(msg)
            end, 4, {userId}) -- 解除屏蔽协议
            
            table.remove(self.shieldUser, i)
            self:writeShieldList(self.shieldUser)
            gevent:call(global.gameEvent.EV_ON_CHAT_SHIELD)
            global.tipsMgr:showWarning("BLACK_LIST_RELIEIVE")
            break
        end
    end


end

-- 当前聊天对象是否已被屏蔽
function _M:isShieldUser(userId)
    if not self.shieldUser then return end
    for i,v in ipairs(self.shieldUser) do        
        if v == userId then                        
            return true
        end
    end
    return false
end

-- 过滤屏蔽名单聊天消息
function _M:shieldChat(data)

    if not data then return end

    local temp = {}
    local checkShield = function (userId)    
        for _,v in pairs(self.shieldUser) do
            if v == userId then
                return true
            end
        end
        return false
    end

    for i,v in pairs(data) do
        if not checkShield(v.lFrom) then 
            table.insert(temp, v)
        end
    end

    return temp
end

-- 写入
function _M:writeShieldList(data)

    local shieldList = ""
    for _,v in pairs(data) do
        shieldList = shieldList .. v .. "#"
    end
    local id = global.userData:getUserId()
    cc.UserDefault:getInstance():setStringForKey("SHIELDLIST"..id, shieldList)
    cc.UserDefault:getInstance():flush()
end

-- 解析
function _M:decodeShieldList(shieldList)

    local shield = {}
    local list = string.split(shieldList, "#")
    for _,v in ipairs(list) do
        table.insert(shield, tonumber(v))
    end
    return shield
end


-- 翻译过的消息记录
function _M:addTranslateRecode(data, transState)

    local md5Key = self:getTranslateKey(data)
    for _,v in pairs(self.transRecode) do
        if md5Key == v.key then
            v.transState = transState
            return
        end
    end

    local recode = {}
    recode.key = md5Key
    recode.tranStr = data.tranStr or ""
    recode.transState = transState or 0
    table.insert(self.transRecode, recode)
end

function _M:getTranslateRecode(key)

    for _,v in pairs(self.transRecode) do
        if key == v.key then
            return v.tranStr or "", v.transState or 0
        end
    end
    return "", 0
end

function _M:getTranslateKey(data)

    local destStr  = data.destStr or ""
    local szFrom   = data.szFrom  or ""
    local timeStr  = data.lTime   or ""
    return crypto.md5(destStr..szFrom..timeStr, false)
end


-- 系统公告
-- tagSpl.lValue = 2    --跑马灯id
-- tagSpl.szInfo = ""   --跑马灯内容参数
function _M:getSysNotice(tagSpl)

    if not tagSpl then return end

    local str = ""
    local szInfo = global.tools:strSplit(tagSpl.szInfo, '|')
    local noticId = tonumber(szInfo[1] or 0)
    local szParams = {}
    for i=2,#szInfo do
        if szInfo[i] and szInfo[i] ~= "" then
            table.insert(szParams, szInfo[i] or 0)
        end
    end
    local noticeData = global.luaCfg:get_public_notice_by(noticId)
    if not noticeData then return "" end
    local richData = global.luaCfg:get_richText_by(noticeData.desId)
    if richData and richData.text then
        local richTextData = global.uiMgr:decodeRichData(richData.text)
        self.battleInfo = table.get2DimensionTable()
        local keyTable = global.chatData:getNoticParm({id=noticId, szParams=szParams})
        local parmValue = function (key)
            for k,v in pairs(keyTable) do
                if key == k then
                    return v
                end
            end
            return ""
        end
        for _,v in ipairs(richTextData) do
            if v.label then
                str = str .. v.label   
            elseif v.key then
                str = str .. parmValue(v.key)
            end
        end
    end
    return str
end

-- 获取系统公告文本
function _M:getNoticParm(data)

    local noticeData = luaCfg:get_public_notice_by(data.id)
    local worldConst = require("game.UI.world.utils.WorldConst")
    local arg = {}

    local typeId = noticeData.typeId
    if typeId == 1 then

        local heroData = luaCfg:get_hero_property_by(tonumber(data.szParams[3] or 0)) or {}
        local heroName = heroData.name or ""
        arg.name = data.szParams[1] or ""
        arg.num = data.szParams[2] or ""
        arg.heroName = heroName
    elseif typeId == 2 then
    elseif typeId == 3 then
        
        local worldData = luaCfg:get_world_type_by(tonumber(data.szParams[4] or 0)) or ""
        local sType = worldData.name or ""
        arg.union = string.format("【%s】%s",data.szParams[1] or "", data.szParams[2] or "")
        arg.name = data.szParams[3] or ""
        arg.sType = sType   --TODO

    elseif typeId == 4 then
        arg.name = data.szParams[1] or ""
        arg.union = string.format("【%s】%s",data.szParams[2] or "", data.szParams[3] or "")
    elseif typeId == 5 then
        arg.name = data.szParams[1] or ""
        arg.level = data.szParams[2] or ""
    elseif typeId == 6 then
        arg.name = data.szParams[1] or ""
        arg.num = data.szParams[2] or ""
    elseif typeId == 7 then
        
        local count = tonumber(data.szParams[4] or 0)
        if count > 100000 then 
            count = 100000
        elseif count > 50000 then
            count = 50000
        else
            count = 10000
        end
        if self.battleInfo[tonumber(data.szParams[5])][count] == true then
            return false
        else
            self.battleInfo[tonumber(data.szParams[5])][count] = true
        end

        local truePos = worldConst:converPix2Location(cc.p(data.szParams[1] or 0, data.szParams[2] or 0))
        arg.castleName = data.szParams[3] or ""
        arg.Pos = string.format("(%s,%s)",truePos.x,truePos.y)      
        arg.num = count    

    elseif typeId == 8 then

        arg.Union1Name = string.format("【%s】%s",data.szParams[1] or "", data.szParams[2] or "")
        arg.Union2Name = string.format("【%s】%s",data.szParams[3] or "", data.szParams[4] or "")
    elseif typeId == 9 then

        arg.Union1Name = string.format("【%s】%s",data.szParams[1] or "", data.szParams[2] or "")
        arg.Union2Name = string.format("【%s】%s",data.szParams[3] or "", data.szParams[4] or "")
    elseif typeId == 10 or typeId == 11 then    

        local actData = luaCfg:get_activity_by(tonumber(data.szParams[1] or 0)) or {}
        arg.activity_name = actData.name or ""

    elseif typeId == 12 then

        local worldData = luaCfg:get_world_type_by(tonumber(data.szParams[1] or 0)) or {}
        local sType = worldData.name or ""
        local truePos = worldConst:converPix2Location(cc.p(data.szParams[2] or 0, data.szParams[3] or 0))

        arg.miracleName = sType
        arg.unionName = string.format("【%s】%s",data.szParams[4] or "", data.szParams[5] or "")
        arg.Pos = string.format("(%s,%s)",truePos.x,truePos.y)      
        arg.num = data.szParams[6] or ""  --TODO

    elseif typeId == 26 then

        local count = tonumber(data.szParams[4] or 0)
        if count > 100000 then 
            count = 100000
        elseif count > 50000 then
            count = 50000
        else
            count = 10000
        end
        if self.battleInfo[tonumber(data.szParams[5])][count] == true then
            return false
        else
            self.battleInfo[tonumber(data.szParams[5])][count] = true
        end
        local truePos = worldConst:converPix2Location(cc.p(data.szParams[1] or 0, data.szParams[2] or 0))
        local worldData = luaCfg:get_world_type_by(tonumber(data.szParams[3] or 0)) or {}
        arg.castleName = worldData.name or ""
        arg.Pos = string.format("(%s,%s)",truePos.x,truePos.y)      
        arg.num = count 
    elseif typeId == 38 then

        local actData = luaCfg:get_activity_by(tonumber(data.szParams[1] or 0)) or {}
        arg.activity_name = actData.name or ""
        arg.time = data.szParams[2] or ""

    elseif typeId == 39 then
        --todo  
        local actData = luaCfg:get_activity_by(tonumber(data.szParams[1] or 0)) or {}
        arg.activity_name = actData.name or ""

    elseif typeId >= 30 and typeId <= 34 then

        arg.name = data.szParams[1] or ""
        local equipData = luaCfg:get_equipment_by(tonumber(data.szParams[2] or 0)) or {}
        arg.equip = equipData.name or ""
        arg.lv = data.szParams[3] 

    elseif typeId == 28 or typeId == 29 then

        arg.name = data.szParams[1] or ""
        local equipData = luaCfg:get_equipment_by(tonumber(data.szParams[2] or 0)) or {}
        arg.equip = equipData.name or ""

    elseif typeId == 35 then

        arg.name = data.szParams[1] or ""
        local itemData = luaCfg:get_item_by(tonumber(data.szParams[2] or 0)) or luaCfg:get_equipment_by(data.szParams[1] or 0) or {}
        arg.item = itemData.itemName or itemData.name or ""

    elseif typeId == 36 then

        arg.name = data.szParams[1] or ""
        local typeData = luaCfg:get_divine_by(tonumber(data.szParams[2] or 0)) or {}
        arg.type = typeData.name or ""

    elseif typeId == 37 then

        arg.name = data.szParams[1] or ""
        arg.num = data.szParams[2]  or ""
        local shopData = luaCfg:get_random_shop_by(tonumber(data.szParams[3] or 0)) or {}
        arg.itme =  shopData.name or ""


    elseif typeId == 46 then
        
        if #data.szParams == 2 then

            arg.name = data.szParams[1]
            local wild = tonumber(data.szParams[2])
            arg.temple = luaCfg:get_wild_res_by(wild).name
        else

            arg.name = string.format("【%s】%s",data.szParams[1],data.szParams[2])
            local wild = tonumber(data.szParams[3])
            arg.temple = luaCfg:get_wild_res_by(wild).name
        end     
    elseif typeId == 47 then

        if #data.szParams == 5 then

            local landId = tonumber(data.szParams[2] or 1)

            arg.name = data.szParams[1] or ""
            arg.land = luaCfg:get_map_region_by(landId).name
            arg.num = data.szParams[4] or 0
        else
                
            local landId = tonumber(data.szParams[3] or 1)
            arg.name = string.format("【%s】%s",data.szParams[1],data.szParams[2])
            arg.land = luaCfg:get_map_region_by(landId).name
            arg.num = data.szParams[5] or 0
        end     
    elseif typeId == 48 then
        local truePos = worldConst:converPix2Location(cc.p(data.szParams[4],data.szParams[5]))

        arg.union = string.format("【%s】%s",data.szParams[1],data.szParams[2])
        arg.land = string.format("%s(%s,%s)",data.szParams[3],truePos.x,truePos.y)
    elseif typeId == 50 then
        
        local landId = tonumber(data.szParams[1])
        arg.landname = luaCfg:get_map_region_by(landId).name
        local officalId = tonumber(data.szParams[2])
        arg.postname1 = luaCfg:get_official_post_by(officalId).typeName     
        arg.lordname1 = data.szParams[3]
        arg.lordname2 = data.szParams[4]
        officalId = tonumber(data.szParams[5])
        arg.postname2 = luaCfg:get_official_post_by(officalId).typeName 

    elseif typeId == 75 then
        
        if data.szParams then 
            arg.key_1 = data.szParams[1] or '-'
            arg.key_2 = data.szParams[2] or '-'
            arg.key_3 = data.szParams[3] or '-'
        else 
            arg.key_1 =  '-'
            arg.key_2 =  '-'
            arg.key_3 =  '-'
        end 

    elseif typeId == 58 then

        local getMirByType = function (lType)
            -- body
            for i,v in ipairs(luaCfg:world_miracle()) do
                if v.type == lType then
                    return v.name
                end
            end
        end
        arg.name = getMirByType(tonumber(data.szParams[1]))
    elseif typeId == 59 then

        local getCampByType = function (lType)
            -- body
            for i,v in ipairs(luaCfg:world_camp()) do
                if v.type == lType then
                    return v.name
                end
            end
        end
        arg.name = getCampByType(tonumber(data.szParams[1]))
    
    elseif typeId == 60 then

        local sType = luaCfg:get_all_miracle_name_by(tonumber(data.szParams[4])).name

        arg.key_1 = data.szParams[1]
        arg.key_2 = data.szParams[2]
        arg.key_4 = data.szParams[3]
        arg.key_3 = sType
    elseif typeId == 61 then

        arg.activity = luaCfg:get_activity_by(tonumber(data.szParams[1])).name
        arg.name1 = data.szParams[2] or '-'
        arg.name2 = data.szParams[3] or '-'
        arg.name3 = data.szParams[4] or '-'

    elseif typeId == 75 then

        if data.szParams then 
            arg.key_1 = data.szParams[1] or '-'
            arg.key_2 = data.szParams[2] or '-'
            arg.key_3 = data.szParams[3] or '-'
        else 
            arg.key_1 =  '-'
            arg.key_2 =  '-'
            arg.key_3 =  '-'
        end 

    elseif typeId == 62 then

        arg.name = luaCfg:get_worldboss_by(tonumber(data.szParams[1])).trueName
        arg.lv = data.szParams[2]

    elseif typeId == 77 or typeId == 78 then

        local heroName = luaCfg:get_hero_property_by(tonumber(data.szParams[2])).name
        arg.name = data.szParams[1] or "-"
        arg.heroName = heroName
        
    elseif typeId == 79 then

        if data.szParams then
            arg.key_1 = data.szParams[1] or "-"
        end

    end


    return arg
end

-- 500字符限制
function _M:checkLength(str)
    
    str = str or ""
    local list = string.utf8ToList(str)
    if table.nums(list) > 500 then 
        global.tipsMgr:showWarning("TextLong")
        return false
    end
    return true
end


-- 聊天联盟置顶
function _M:setChatRecruitMsg(msg)
    -- body
    self.chatRecruitMsg = msg
end
-- 上架X时间后消失
function _M:checkChatRecruitMsg()
    -- body
    local MAX_STAYTIME = luaCfg:get_config_by(1).UnionChatTime
    if self.chatRecruitMsg then
        self.chatRecruitMsg.lTime = self.chatRecruitMsg.lTime or 0
        local stayTime = global.dataMgr:getServerTime() - self.chatRecruitMsg.lTime
        if stayTime >= MAX_STAYTIME*60 then
            gevent:call(global.gameEvent.EV_ON_CHATTOP_UNIONRECRUIT, nil)
        end
    end
end

function _M:getChatRecruitMsg()
    -- body
    local MAX_STAYTIME = luaCfg:get_config_by(1).UnionChatTime
    if self.chatRecruitMsg then
        self.chatRecruitMsg.lTime = self.chatRecruitMsg.lTime or 0
        local stayTime = global.dataMgr:getServerTime() - self.chatRecruitMsg.lTime
        if stayTime < MAX_STAYTIME*60 then
            return self.chatRecruitMsg
        end
    end
    return nil
end
function _M:refershChatRecruitMsg()
    global.chatApi:getMsgInfo(function(msg)
        msg.tagMsg = msg.tagMsg or {}
        if (#msg.tagMsg > 0) then
            self.chatRecruitMsg = msg.tagMsg[1]
            gevent:call(global.gameEvent.EV_ON_CHATTOP_UNIONRECRUIT, nil)
        end
    end, 5)
end


--- 联盟聊天红包列表
function _M:setChatUnionGift(data)
    -- body
    self.chatUnionGift = data
end
function _M:getChatUnionGift()
    -- body
    return self.chatUnionGift or {}
end
function _M:removeUnionGiftLog(giftId)
    -- body
    self.chatUnionGift = self.chatUnionGift or {}
    for k,v in pairs(self.chatUnionGift) do
        if v.lID == giftId then
            table.remove(self.chatUnionGift, k)
            gevent:call(global.gameEvent.EV_ON_UNION_REDBAG)
            break
        end
    end
end
function _M:addUnionGiftLog(data)
    -- body
    if not data.lID then return end
    self.chatUnionGift = self.chatUnionGift or {}
    for k,v in pairs(self.chatUnionGift) do
        if v.lID == data.lID then
            return
        end
    end
    table.insert(self.chatUnionGift, data)
    gevent:call(global.gameEvent.EV_ON_UNION_REDBAG)
end
-- 检测红包是否失效
function _M:checkUnionGiftLog()
    -- body

    --  print(" ----------------------------------- getServerTime -------------------- 22222>> " .. global.dataMgr:getServerTime())
    self.chatUnionGift = self.chatUnionGift or {}
    if table.nums(self.chatUnionGift) == 0 then return end
    for k,v in pairs(self.chatUnionGift) do
        if v.lAddTime < global.dataMgr:getServerTime() then
            self:removeUnionGiftLog(v.lID)
        end
    end
end
function _M:refershUnionGift()

    global.chatApi:chatRedGift(function (msg, ret)
        dump(msg, " === ==>refershUnionGift:"..ret)
        if ret == 0 then
            msg = msg or {}
            global.chatData:setChatUnionGift(msg.tagLog or {})
            self:checkUnionGiftLog()
            gevent:call(global.gameEvent.EV_ON_UNION_REDBAG)
        end
    end, 3, {0})
end
-- 退出联盟，清空红包
function _M:cleanUnionGift()

    self.chatUnionGift = self.chatUnionGift or {}
    for k,v in pairs(self.chatUnionGift) do
        local szPara = global.tools:strSplit(v.szName, '|')
        szPara[1] = szPara[1] or "0"
        if tonumber(szPara[1]) == 3 then
            table.remove(self.chatUnionGift, k)
        end
    end
    gevent:call(global.gameEvent.EV_ON_UNION_REDBAG)
end


global.chatData = _M

--endregion
