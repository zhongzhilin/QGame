--region ItemControl.lua
--Author : yiyongtao
--Date   : 2017/01/59
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local chat_cfg = require("asset.config.chat_cfg")

local ItemControl  = class("ItemControl")
local UIRecruitEffect = require("game.UI.chat.UIRecruitEffect")

function ItemControl:ctor(root)
    self:initUI(root)
end

function ItemControl:initUI(root)
    self.root = root
    self.Panel = self.root.Panel_export
    self.NodeTitle = self.root.NodeTitle_export
    self.IconNode = self.root.NodeTitle_export.btnHead.IconNode_export
    self.txtName = self.root.NodeTitle_export.txtName_export
    self.txtUnion = self.root.NodeTitle_export.txtUnion_export
    self.timeNode = self.root.NodeTitle_export.timeNode_export
    self.txtBtn = self.root.txtBtn_export
    self.txtContent = self.root.txtBtn_export.txtContent_export
    self.label = self.root.txtBtn_export.label_export
    self.btnHead = self.root.NodeTitle_export.btnHead
    self.vipNode = self.root.NodeTitle_export.vipNode_export
    self.txtVip = self.root.NodeTitle_export.vipNode_export.txtVip_export
    self.txtContentLabel = self.root.txtBtn_export.txtContentLabel_export
    self.vipbg = self.root.NodeTitle_export.vipNode_export.vipbg_export
    uiMgr:addWidgetTouchHandler(self.txtBtn, function(sender, eventType) self:txtClickHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btnHead, function(sender, eventType) self:headClickHandler(sender, eventType) end, true)

    self.headFrame = self.root.NodeTitle_export.btnHead.IconNode_export.headFrame_export

    -- 设置ui属性
    self.txtBtn:setSwallowTouches(false)
    self.txtBtn:setPressedActionEnabled(false)
    self.txtContent:setTextAreaSize(cc.size(self.txtContent:getContentSize().width,0))
    self.textSize = {}
    self.btnHead:setSwallowTouches(false)

end

function ItemControl:setData(data)

    self.data = data

    self.textData = {}
    self:showTitle(data)
    self:showTime()
    self:showText()
    self:showHead(data)
    self:showHeadFrame(data)
    self:showEffect()
end

-- 特效背景框显示
function ItemControl:showEffect()

    if not tolua.isnull(self.effect) then
        self.effect:setVisible(false)
    end
    if self.data.itemKind == 2 then
        local key = self.data.tagSpl.lKey
        if key == 7 then
            if not self.effect then
                self.effect = UIRecruitEffect.new() 
                self.effect:CreateUI()
                self.root:addChild(self.effect)
                if self.data.itemType == 1 then 
                    self.effect:setPosition(cc.p(400,18))
                else
                    self.effect:setPosition(cc.p(318,18))
                end
            end
            self.effect:setVisible(true)
            self.effect.top:setPositionY(self.txtBtn:getContentSize().height-5)
        end
    end
end

-- 头像
function ItemControl:showHead(data)
    -- body
    local head = global.headData:getCurHead()
    if data.lFrom ~= global.userData:getUserId() then
        head = luaCfg:get_rolehead_by(data.lFaceID or 101)
    end
    if data.lFrom == 0 then -- 系统公告
        head = luaCfg:get_rolehead_by(501)
        self.btnHead:setTouchEnabled(false)
    else
        self.btnHead:setTouchEnabled(true)
        head = global.headData:convertHeadData(data,head)
    end
    -- global.tools:setClipCircleAvatarWithScale(self.IconNode, head)
    global.tools:setClipCircleAvatarWithScale(self.IconNode, head)
end

-- 头像背景框
function ItemControl:showHeadFrame(data)

    if not data.lBackID then 
        self.headFrame:setVisible(false)
    else
        self.headFrame:setVisible(true)
        local info = luaCfg:get_role_frame_by(data.lBackID) or luaCfg:get_role_frame_by(1)
        if data.lFrom == global.userData:getUserId() then
            info = global.userheadframedata:getCrutFrame()
        end       
        global.panelMgr:setTextureFor(self.headFrame, info.pic)
    end 
end

-- 名称称号设置
function ItemControl:showTitle(data)
    -- body
    data.lVipLevel = data.lVipLevel or 0

    local curChatChannel = global.chatData:getCurLType()
    local isWorldChat = curChatChannel ~= 1  

    self.vipNode:setVisible(false)
    if isWorldChat then

        local isMine  = data.itemType == 2 and global.vipBuffEffectData:isVipEffective() 
        local isOther = data.itemType ~= 2 and data.lVipLevel > 0
        if isMine then
            self.vipNode:setVisible(true)
            self.txtVip:setString(global.vipBuffEffectData:getVipLevel())
            data.lVipLevel = global.vipBuffEffectData:getVipLevel()
        end

        if isOther then
            self.vipNode:setVisible(true)
            self.txtVip:setString(data.lVipLevel)           
        end

        if data.lVipLevel > 0 then
            self.vipbg:setSpriteFrame(string.format("ui_surface_icon/vip_bg_%d.png", (data.lVipLevel+1)/2))
        end
    end

    self:showName(data)
    self.textData.lVipLevel = data.lVipLevel
    self.textData.lTotem    = data.lTotem
    self.textData.lAllyID   = data.lAllyID
end

-- 名字
function ItemControl:showName(data)

    -- 系统公告
    if data.lFrom == 0 then
        self.textData = data
        return
    end

    -- 解析官职
    local decodeClass = function (value)
        -- body
        local curMaxClass = 0
        local d2Table = global.tools:d2b(value) -- 二进制
        for i=32,29,-1 do
            if d2Table[i] == 1 then
                curMaxClass = i
            end
        end
        return (33 - curMaxClass)
    end

    -- 设置文本 
    local setText = function (data)
        -- body
        if data.union_name then
            self.txtUnion:setVisible(true)
            self.txtUnion:setString(luaCfg:get_local_string(10333, data.union_name))
        else
            self.txtUnion:setVisible(false)
        end

        if data.official_name then
            self.txtName:setString(luaCfg:get_local_string(10333, data.official_name) .. data.name)
        else
            self.txtName:setString(data.name)
        end
        self.textData = data
    end

    local curChatChannel = global.chatData:getCurLType()

    if curChatChannel == 1 then
        self.txtName:setVisible(false)
        self.txtUnion:setVisible(false)
    else

        self.txtName:setVisible(true)
        local shortName, name = "", ""
        local isLeader = false
        if data.itemType == 2 then
            shortName = global.unionData:getInUnionShortName()
            name = global.userData:getUserName()
            isLeader = global.unionData:isLeader()
        else
            shortName = data.szAllyNick
            name = data.szFrom
            isLeader = false
            local classData = global.unionData:getUnionClass(data.lAllyRank)  
            if classData and classData.id == 1 then
                isLeader = true
            end
        end

        if shortName and shortName ~= "" then

            if isLeader then
                local leadStr = global.unionData:getUnionClass(5).text
                if curChatChannel == 2 then
                    setText({union_name=shortName, official_name=leadStr, name=name})
                else
                    setText({official_name=leadStr, name=name})
                end
            else              
                -- 是否有官职 
                if data.lAllyClass and data.lAllyClass ~= 0 then 

                    local curClass = decodeClass(data.lAllyClass)
                    local posData = luaCfg:get_union_position_btn_by(curClass) or {} 
                    local strPosi = posData.text or ""
                    if curChatChannel == 2 then
                        setText({union_name=shortName, official_name=strPosi, name=name})
                    else
                        setText({official_name=strPosi, name=name})
                    end
                else
        
                    if curChatChannel == 2 then
                        setText({union_name=shortName, name=name})
                    else
                        setText({name=name})
                    end
                end
            end
        else
            setText({name=name})
        end
    end
end

function ItemControl:getData()
    return self.textData
end

-- 时间便条
function ItemControl:showTime()

    self.timeNode:setVisible(false)
    local posText = chat_cfg.chat_item_ui.item_cell_pos
    local curTime = global.dataMgr:getServerTime()
    local timeSize = chat_cfg.chat_item_ui.item_cell_timeSize
    local time = curTime- (self.data.lTime or 0) 
    -- 超过一分钟显示时间
    if  self.data.timeStr ~= "" then 

        self.timeNode:setVisible(true)
        self.timeNode.txtBg.text:setString(self.data.timeStr)
        local textW = self.timeNode.txtBg.text:getContentSize().width + 20
        self.timeNode.txtBg:setContentSize(cc.size(textW, timeSize[3]))
        self.timeNode.txtBg.text:setPositionX(textW/2)
    end
end

-- 文本内容
function ItemControl:showText()

    -- 根据消息类型获取文本内容
    local contentStr,isOutline,textColor = self:getTextContent()

    -- 用于翻译
    self.data.destStr = contentStr
    local md5Key = global.chatData:getTranslateKey(self.data)
    local tranStr, tranState = global.chatData:getTranslateRecode(md5Key)
    if tranState == 1 then
        contentStr = self.data.destStr .. "\n\n" .. tranStr
        self.data.tranStr = tranStr
        self.data.tranState = tranState
    end

    self.txtContent:setTailEnabled(false)   --不用省略号机制
    self.txtContent:setString(contentStr)

    if isOutline then
        self.txtContent:setTextColor(textColor)
        -- self.txtContent:enableOutline(cc.c4b(0,0,0,255),2)
    else
        self.txtContent:setTextColor(cc.c3b(0,0,0))
        -- self.txtContent:enableOutline(cc.c4b(0,0,0,255),0)
    end    

    self:adjustText(contentStr)
    
    local padding = chat_cfg.chat_item_ui.item_cell_padding
    local uiH = self.txtBtn:getContentSize().height + padding 
    self.Panel:setContentSize( cc.size( self.Panel:getContentSize().width , uiH))
end

---　点击文本，显示复制、翻译功能框
function ItemControl:txtClickHandler(sender, eventType)

    local chatPanel = global.panelMgr:getPanel(global.panelMgr:getTopPanelName())
    if eventType == ccui.TouchEventType.began then
        chatPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if chatPanel.isStartMove then 
            return
        end

        -- 正在翻译
        if global.isTranslating then 
            return
        end
        
        -- 系统维护公告
        local isNotice = self.data.tagSpl and self.data.tagSpl.lKey and self.data.tagSpl.lKey == 6
        local isSystem = self.data.lFrom == 0
        if isNotice and isSystem then
            local szInfo = global.tools:strSplit(self.data.tagSpl.szInfo, '|')
            local noticeData = global.luaCfg:get_public_notice_by(tonumber(szInfo[1] or 0))
            if noticeData and noticeData.viewType == 0 then 
                return 
            end 
        end
       
        local x1, y1 =  self.NodeTitle:getPosition() 
        local posY = self.root:convertToWorldSpace( cc.p(x1, y1) ).y + 75

        if chatPanel.nodeMaxPosY and (posY > chatPanel.nodeMaxPosY) then

            local tableH = chatPanel.TableSize:getContentSize().height
            local cellH = self.data.cellH
            if (cellH >= tableH)  and (posY < tableH+cellH/2)  then
                posY = gdisplay.height/2
            else
                posY = chatPanel.nodeMaxPosY
            end   
        end
        
        local rowPosX = 0
        local posX = self.txtBtn:getPositionX()
        if self.data.itemType == 1 then
            posX = posX + self.txtBtn:getContentSize().width/2
        else
            posX = posX - self.txtBtn:getContentSize().width/2
        end
        rowPosX = posX

        -- 超出屏幕，居左或巨右显示
        local minPosX = chat_cfg.chat_item_ui.funcNode_Width/2 - 75
        local maxPosX = gdisplay.width - chat_cfg.chat_item_ui.funcNode_Width/2

        if posX < minPosX then
            posX = minPosX
        --elseif  posX > maxPosX then
        --    posX = maxPosX
        end

        --记录当前选中userid
        self.data.selectUserId = self:getCurSelectUserId()

        -- 显示复制等功能节点
        local nodePos = cc.p(posX, posY)
        if chatPanel.showFuncBorard then --[protect]
            chatPanel:showFuncBorard(self.data, nodePos, rowPosX)
        end 

    end

end


---　用户头像点击，拉取用户信息
function ItemControl:headClickHandler(sender, eventType)

    local currPanel = global.panelMgr:getTopPanelName()
    local chatPanel = global.panelMgr:getPanel(currPanel)
    if eventType == ccui.TouchEventType.began then
        chatPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        
        if chatPanel.isStartMove then 
            return
        end

        -- 系统公告
        if self.data.lFrom == 0 then
            return
        end
        
        local selectUserId = 0
        if self.data.itemType == 1 then
            selectUserId = self:getCurSelectUserId()
        else
            selectUserId = global.userData:getUserId()
        end

        -- 获取用户详细信息
        global.chatApi:getUserInfo(function(msg)
               
            msg.tgInfo = msg.tgInfo or {}
            local panel = global.panelMgr:openPanel("UIChatUserInfoPanel")
            panel:setData(msg.tgInfo[1])
            local currPanel = global.panelMgr:getPanel(currPanel)
            if currPanel.refershData then currPanel:refershData(msg.tgInfo[1]) end

        end, {selectUserId} )
    end

end

--　根据消息类型获取显示文本
function ItemControl:getTextContent()

    local showStr = self.data.szContent
    local isOutline = false
    local textColor = cc.c3b(255,226,165)

    if self.data.itemKind == 2 then

        local key = self.data.tagSpl.lKey

        if key == 1 then
            
            showStr = self:getBattleMailStr()

        elseif key == 2 then

            showStr,textColor = self:getEquipStr()
        elseif key == 3 then

            showStr = self:getPosStr()
        elseif key == 4 then

            showStr = self:getHeroStr()
        elseif key == 5 then

            showStr,textColor = self:getUninoWelComeStr()
        elseif key == 6 then

            showStr,textColor = global.chatData:getSysNotice(self.data.tagSpl),  cc.c3b(238,217,76)
        elseif key == 7 then

            showStr = self:getUninoRecruitStr()
        elseif key == 8 then

            showStr, textColor = self:getUnionWarStr()

        elseif key == 9 then

            showStr = self:getUnionSpringStr()
        elseif key == 10 then

            showStr, textColor = self:getUnionGift()
        elseif key == 11 then

            showStr = self:getPetStr()
        elseif key == 12 then

            showStr, textColor = self:getUnionPve()
        end

        isOutline = true        
    end

    return showStr,isOutline,textColor
end

-- 联盟boss、联盟村庄、联盟城市
function ItemControl:getUnionPve()

    local tagSpl = self.data.tagSpl
    local szParams = global.tools:strSplit(tagSpl.szParam, '+') 
    local configId = {[1]=11102, [2]=11101, [3]=11100}
    local typeId = tonumber(szParams[1] or "1")
    local atkStr = luaCfg:get_local_string(configId[typeId])
    local showStr = "    " .. luaCfg:get_local_string(10965, atkStr)
    if global.tools:isAndroid() or global.tools:isIos() then
        showStr = "   " .. showStr
    end

    return showStr, cc.c3b(252, 93, 93)
end

--  联盟礼包
function ItemControl:getUnionGift()
    -- body
    local localId = self.data.lType == 2 and 11129 or 11095
    local showStr = luaCfg:get_local_string(localId)
    self.label:setString(showStr)
    if self.label:getContentSize().width <= 415 then
        showStr = showStr .. "\n"
    end
    return showStr, cc.c3b(225,226,165)
end

-- 神兽分享
function ItemControl:getPetStr()

    local tagSpl = self.data.tagSpl
    local parm = global.tools:strSplit(tagSpl.szInfo, '@') 
    local tempPet = global.petData:getPetConfig(tonumber(parm[1]), tagSpl.lValue)
    local name = tempPet.name .. " (".. tempPet.phaseName ..")"
    local showStr = luaCfg:get_local_string(11089, name)
    return showStr .. "\n"
end

-- 联盟英雄试炼 
function ItemControl:getUnionSpringStr()
    -- body
    local showStr = ""
    local tagSpl = self.data.tagSpl
    local itemData = luaCfg:get_item_by(tonumber(tagSpl.lValue)) or {}
    showStr = luaCfg:get_local_string(10998, itemData.itemName or "")
    return showStr
end

-- 联盟聊天发送支援消息
function ItemControl:getUnionWarStr()
    -- body
    local showStr = ""
    local tagSpl = self.data.tagSpl
    if tagSpl.lValue and tagSpl.lValue == -1 then -- 主动发起支援
        showStr = "    " .. luaCfg:get_local_string(10965, tagSpl.szInfo or "welcome")
    else
        showStr = "    " .. luaCfg:get_local_string(10964)
    end

    if global.tools:isAndroid() or global.tools:isIos() then
        showStr = "   " .. showStr
    end

    return showStr, cc.c3b(252, 93, 93)
end

-- unionShortName .. "|" .. unionName .. "|" .. flagId
function ItemControl:getUninoRecruitStr()

    local tagSpl = self.data.tagSpl
    -- dump(tagSpl, "--> getUninoRecruitStr: ")
    local szParam = global.tools:strSplit(tagSpl.szParam, '@')   
    local showStr = "  " .. luaCfg:get_local_string(10793, unpack(szParam))
    if self.data.itemType == 1 then
        showStr = "  " .. showStr
    end
    return showStr
end

function ItemControl:getUninoWelComeStr()

    local tagSpl = self.data.tagSpl
    local str = luaCfg:get_local_string(tagSpl.lValue, tagSpl.szInfo or "", tagSpl.szParam or "")
    return str or "welcome~", cc.c3b(0,0,0)
end

function ItemControl:getHeroStr()
    
    local showStr = ""
    local str = self.data.tagSpl.szInfo .. " return test"            
    local func = loadstring(str)

    if func then

        local data = func()
        if data then            
        
            local heroPro = global.heroData:getHeroPropertyById(data.serverData.lID)
            if heroPro.quality == 1 then
                showStr = luaCfg:get_local_string(10702,heroPro.name .. " Lv."..data.serverData.lGrade)
            else
                if heroPro.iconBg == 'ui_surface_icon/hero_kuang4.png' then -- 传说
                    showStr = luaCfg:get_local_string(10933,heroPro.name .. " Lv."..data.serverData.lGrade)
                else
                    showStr = luaCfg:get_local_string(10701,heroPro.name .. " Lv."..data.serverData.lGrade)
                end
            end            
        else
            showStr = "equip data decode fail!(data)"                    
        end
    else    
        showStr = "equip data decode fail!(func)"                            
    end

    return showStr
end

function ItemControl:getPosStr()
    
    local showStr = ""
    local str = self.data.tagSpl.szInfo .. " return test"            
    local func = loadstring(str)

    if func then

        local posData = func()
        if posData then         
            local name = posData.name
            dump(posData)
            if posData.wildKind and posData.wildKind == 3 then
                -- 分享联盟boss支持翻译
                local itemData = global.luaCfg:get_union_task_by(posData.name)
                name = itemData.taskName
            end
            showStr = luaCfg:get_local_string(10698,(name or "O-V-C-N-S") .. " (" .. posData.posX .. "," .. posData.posY .. ")")
            -- showStr = luaCfg:get_local_string(10654, equipData.confData.name .. strongLv)                    
        else
            showStr = "equip data decode fail!(data)"                    
        end
    else    
        showStr = "equip data decode fail!(func)"                            
    end

    return showStr
end

-- 分享装备文本
function ItemControl:getEquipStr()

    local showStr = ""
    local textColor = cc.c3b(255,226,165)
    local str = self.data.tagSpl.szInfo .. " return test"            
    local func = loadstring(str)

    if func then

        local equipData = func()
        if equipData then
            global.equipData:bindConfData(equipData)
            local strongLv = ""           
            if equipData.lStronglv > 0 then
                strongLv = " +" .. equipData.lStronglv
            end                              
            textColor = cc.c3b(unpack(luaCfg:get_quality_color_by(equipData.confData.quality).rgb))
            showStr = luaCfg:get_local_string(10654, equipData.confData.name .. strongLv)                    
        else
            showStr = "equip data decode fail!(data)"                    
        end
    else    
        showStr = "equip data decode fail!(func)"                            
    end

    return showStr,textColor
end

-- 分享战报文本
function ItemControl:getBattleMailStr()
    
    local showStr = ""
    local strTb = global.mailData:getMailTitleByInfo(self.data.tagSpl.szInfo) --string.split(self.data.tagSpl.szInfo, "@")
    if #strTb > 1  then

        local spaceStr = ""
        for i = 1,100 do
            spaceStr = spaceStr.." "
            local tempStr = luaCfg:get_local_string(10299, strTb[1]..spaceStr.."")

            self.label:setString( tempStr )
            local strW =  self.label:getContentSize().width + chat_cfg.chat_item_ui.width_head
            if strW > chat_cfg.chat_item_ui.width_max then 
                
                break
            end
        end
        showStr = luaCfg:get_local_string(10299, strTb[1]..spaceStr..strTb[2])
    end

    return showStr
end

-- 针对从右往左输入的语言特殊处理
-- 编码范围 exp：
-- （ U+0590 – U+059F） 希伯来字符 
-- （ U+0600 – U+06FF） 阿拉伯字符
local RTL_LIST = {
    [1] = {"0600", "06FF"},
    [2] = {"0590", "059F"},
    [3] = {"0750", "077F"},
    [4] = {"FB50", "FDFF"},
    [5] = {"FE70", "FEFF"},
    [6] = {"0B80", "0BFF"},
}

-- 获取文本长度
function ItemControl:getTextWidth(contentStr)

    local bgSize = chat_cfg.chat_item_ui.contentBg_size
    local contentBgHeadW = chat_cfg.chat_item_ui.width_head

    self.label:setString(contentStr)
    local tW = self.label:getContentSize().width
    if global.tools:isIos() and tW == 0 and contentStr ~= "" then
        tW = chat_cfg.chat_item_ui.width_max
    end

    local strW = tW + contentBgHeadW
    if strW > chat_cfg.chat_item_ui.width_max then
        strW = chat_cfg.chat_item_ui.width_max
    elseif strW < bgSize[1]  then  
        strW = bgSize[1]
    end

    return strW
end

-- 根据消息文本内容调整位置大小
function ItemControl:adjustText(contentStr)
    contentStr = contentStr or "-"
    local textContentSize = chat_cfg.chat_item_ui.content_size
    local contentBgHeadW = chat_cfg.chat_item_ui.width_head
    local bgSize = chat_cfg.chat_item_ui.contentBg_size
    local posTxtY = chat_cfg.chat_pos.txt_content[2]
    local posTitleY = chat_cfg.chat_pos.title_head[2]

    -- 设置换行
    self.txtContent:setContentSize(cc.size(textContentSize[1], textContentSize[2]))
    
    local label = self.txtContent:getVirtualRenderer()
    local desSize = label:getContentSize()

    -- 复用问题，每次设置初始值，不然就是上个item的ui值
    self.textSize = {desSize.width, desSize.height}   
    if self.data.textSize[1] <= 0 or self.data.textSize[2] <= 0 then
        self.data.textSize = self.textSize
    end
    desSize.width = self.data.textSize[1]
    desSize.height = self.data.textSize[2]
    self.txtContent:setContentSize(desSize)

    
    local contentAddH = desSize.height - textContentSize[2] 
    if contentAddH < 0 then contentAddH = 0 end

    self.label:setString( contentStr )
    local strW =  self.label:getContentSize().width + contentBgHeadW
    -- 字符串長度檢測
    local strLen = string.utf8len(contentStr)

    if strLen > 200 then 
        strW = chat_cfg.chat_item_ui.width_max + 1
    end

    -- 是否换行
    local isChangLine = true
    if desSize.height <= (textContentSize[2]+10) then
        contentAddH = 0
        isChangLine = false
    end

    -- if strW <= chat_cfg.chat_item_ui.width_max then
    --     contentAddH = 0
    -- end
    if isChangLine then  --strW > chat_cfg.chat_item_ui.width_max then
        strW = chat_cfg.chat_item_ui.width_max
        posTxtY = posTxtY + contentAddH/2
        posTitleY = posTitleY + contentAddH
    elseif strW < bgSize[1]  then  
        strW = bgSize[1]
    end

    -- 翻译状态,文本长度检测
    local strWDes  =  self:getTextWidth(self.data.destStr) 
    local strWTran =  self:getTextWidth(self.data.tranStr)
    local strW1 = strWDes > strWTran and strWDes  or strWTran
    local strW2 = strWDes > strWTran and strWTran or strWDes
    strW = self.data.tranState == 1 and strW1 or strW
 
    self.txtBtn:setContentSize(cc.size( strW, bgSize[2] + contentAddH ))
    self.txtContent:setPositionY(posTxtY)

    local posContentRX = chat_cfg.chat_pos.txt_contentR[1]
    local posContentLX = chat_cfg.chat_pos.txt_content[1]

    self.txtContent:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
    if self.data.itemType == 1 then
        self.txtContent:setPositionX(posContentLX)
    else
        self.txtContent:setPositionX(posContentRX - (chat_cfg.chat_item_ui.width_max-self.txtBtn:getContentSize().width))
        if not isChangLine then
           self.txtContent:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        end
    end

    -- 阿拉伯文处理
    self.androidOffX = 0
    self.data.txtPosX = self.txtContent:getPositionX()
    local isSpecUnicode = string.utf8_to_unicode(contentStr, RTL_LIST)
    local isNoMaxWidth = strWDes < chat_cfg.chat_item_ui.width_max
    if isSpecUnicode and isNoMaxWidth and global.tools:isAndroid() then
        
        strW= self.data.tranState == 1 and strW2 or strW
        local offsetX = chat_cfg.chat_item_ui.width_max - strW - 10
        if self.data.itemType == 1 then
            self.androidOffX = offsetX
            self.txtContent:setPositionX(posContentLX - offsetX)
        else
            self.txtContent:setPositionX(posContentRX - (chat_cfg.chat_item_ui.width_max-self.txtBtn:getContentSize().width)+offsetX)
        end 
    end

    self.NodeTitle:setPositionY(posTitleY)
end

function ItemControl:getOffetXAndroid()
    -- body
    return self.androidOffX
end

-- 获取当前选中用户的userid
function ItemControl:getCurSelectUserId()

    local lToId = self.data.lFrom
    if global.chatData:getCurLType() == 1 then
    
        local lFromId = global.userData:getUserId()
        if self.data.lTo and lFromId == lToId then
            lToId = self.data.lTo
        end
    end

    return lToId
end

--　初始化ui 数据
function ItemControl:setTableCellHeight()
    
    local cellHeight = self.Panel:getContentSize().height + self.data.cellH
    local textSize = {self.textSize[1], self.textSize[2]}
    return cellHeight, textSize
end

return ItemControl

--endregion