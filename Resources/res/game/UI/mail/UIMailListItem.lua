--region UIMailListItem.lua
--Author : yyt
--Date   : 2016/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local mailData = global.mailData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailListItem  = class("UIMailListItem", function() return gdisplay.newWidget() end )

function UIMailListItem:ctor()
    
    self:CreateUI()
end

function UIMailListItem:CreateUI()
    local root = resMgr:createWidget("mail/mail_second_node")
    self:initUI(root)
end

function UIMailListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_second_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.checkBox = self.root.checkBox_export
    self.CellBtn = self.root.CellBtn_export
    self.bgHead = self.root.CellBtn_export.bgHead_export
    self.bgHeadBg = self.root.CellBtn_export.bgHeadBg_export
    self.picNormal = self.root.CellBtn_export.picNormal_export
    self.Node_1 = self.root.CellBtn_export.Node_1_export
    self.headframe = self.root.CellBtn_export.headframe_export
    self.texName = self.root.CellBtn_export.texName_export
    self.texContent = self.root.CellBtn_export.texContent_export
    self.texTime = self.root.CellBtn_export.texTime_export
    self.readStateChat = self.root.CellBtn_export.readStateChat_export
    self.mailUnReadText = self.root.CellBtn_export.readStateChat_export.mailUnReadText_export
    self.spReadState = self.root.CellBtn_export.spReadState_export
    self.spRewardState = self.root.CellBtn_export.spRewardState_export

    uiMgr:addWidgetTouchHandler(self.checkBox, function(sender, eventType) self:checkHandler(sender, eventType) end)
--EXPORT_NODE_END
    
    self.CellBtn:setPressedActionEnabled(false)
    self.CellBtn:setSwallowTouches(false)

end

function UIMailListItem:setData(data)
    if not data then return end
    -- 状态
    self.data = data
    self:setSelectAll()

    self:initMailType(data) 
end

function UIMailListItem:initMailType( data )

    self.contentParm = {}
    local lType = mailData._MAILTYPEID
    self.spRewardState:setVisible(true)

    self.readStateChat:setVisible(false)
    self.spReadState:setVisible(false)

    if lType ~= 3 then
        self.spReadState:setVisible(true)
        self.texTime:setString(mailData:getTime(data.mailID, nil, lType))
        self.spReadState:setVisible(data.state ~= 1)
    end

    self.Node_1.pic:setScale(1)
    self.bgHead:setVisible(false)
    self.bgHeadBg:setVisible(false)
    self.picNormal:setVisible(true)
    self.Node_1:setVisible(false)
    self.headframe:setVisible(false)


    if lType == 1 then  
        self:initSystemItem(data)
    elseif lType == 2 then  
    elseif lType == 3 then  
        self:initOwnMail(data)
    elseif lType == 4 or lType == 8 then  
        self:initSystemItem(data)
    elseif lType == 5 then  
        self:initBattleItem(data) 
    elseif lType==6 or lType==7 then 
        self:initBattleItem(data) 
    end 

end

function UIMailListItem:initOwnMail(data)

    self.Node_1:setVisible(true)
    self.picNormal:setVisible(false)
    self.bgHead:setVisible(true)
    self.bgHeadBg:setVisible(true)
    self.spRewardState:setVisible(false)
    self.readStateChat:setVisible(true)
    self.headframe:setVisible(true)


    self.texTime:setString(mailData:getTime(0, data.lTime))
    self.readStateChat:setVisible(data.lNewCount > 0)
    self.mailUnReadText:setString(data.lNewCount)

    local head = clone(luaCfg:get_rolehead_by(data.lFaceID)) 
    if head then
        local clipWidth = math.abs(head.x2 - head.x1)
        if clipWidth <= 0 then  
            head.scale = head.scale2 - 4
        else
            head.scale = head.scale2 
        end
        global.tools:setClipCircleAvatarWithScale(self.Node_1, global.headData:convertHeadData(data,head))
    end

    local headFrameInfo =  global.luaCfg:get_role_frame_by(data.lBackID)

    if headFrameInfo then 

        global.panelMgr:setTextureFor(self.headframe,headFrameInfo.pic)

    end 


    if data.szAllyNick and data.szAllyNick ~= "" then
        self.texName:setString("【"..data.szAllyNick.."】"..data.szName)
    else
        self.texName:setString(data.szName)
    end
    
    local str = ""
    -- 加入联盟欢迎私信
    if data.lType and data.lType ~= 0 then
        local strTb = global.tools:strSplit(data.szLastText, '|') or {}
        str = luaCfg:get_local_string(tonumber(strTb[2]) or 0, strTb[4] or "", strTb[3] or "") or ""
    else
        str = data.szLastText
    end

    self.texContent:setString(str)

end

function UIMailListItem:getContentParm()
    return self.contentParm
end

function UIMailListItem:getDefName(data)
 
    if data.lFightType and data.lFightType ~= 1 then
        local rwData = mailData:getDataByType(data.lFightType, tonumber(data.szDefName)) or {}
        return rwData.name or ""
    else         
        return data.szDefName or ""
    end
end

function UIMailListItem:initBattleItem(data)

    self.spRewardState:setVisible(false)
    if data.lMailID and data.lMailID ~= 0 then
        local temp = luaCfg:get_email_by(data.lMailID) 
        local iconData = luaCfg:icon()

        for _,v in pairs(iconData) do
           
            if  (mailData:isBattle(v.firstType)) and v.secondType == temp.secondType then
            
                self.picNormal:setSpriteFrame(v.mailIcon)
                local texId = tonumber(temp.Title)
                local mailId = tonumber(temp.mailName)

                self.texName:setString(luaCfg:get_local_string(texId,  self:getDefName(data.tgFightReport)))  
                local killCount, loseCount, scale, ltype = self:getSoldierCount(data.tgFightReport)        
                -- 新手引导特殊处理
                if (not data.tgFightReport.tgAtkUser) and data.lBigFight ~= 1 then
                    killCount = 50
                end 
                self.texContent:setString(luaCfg:get_local_string(mailId, global.funcGame:_formatBigNumber(killCount, 1), global.funcGame:_formatBigNumber(loseCount, 1)))
                table.insert(self.contentParm, killCount)
                table.insert(self.contentParm, loseCount)

                if data.tgFightReport.lPurpose == 3 then
                    self.contentParm = {}
                    self:checkListState(mailId,scale, ltype, data.tgFightReport.lResult, loseCount, killCount)
                end
            end
        end

        -- 全军覆没
        if data.firstType == 3 then
            self.texContent:setString(luaCfg:get_local_string(10199))
        end

    else
        self.picNormal:setSpriteFrame(mailData:getItemIcon(1))
    end

end

function  UIMailListItem:initSystemItem(data)

    if data.firstType == 2 then 
        local temp = luaCfg:get_email_by(12001) 
        self.texContent:setString(luaCfg:get_local_string( tonumber(temp.mailName)))  
        self.texName:setString(temp.Title)
    else
        local str = ""
        if data.lMailID and data.lMailID ~= 0 then
            local lmailData = luaCfg:get_email_by(data.lMailID)
            if lmailData then
                str = luaCfg:get_local_string(tonumber(lmailData.mailName))
                if str == "" then
                    str = lmailData.mailName
                end
                self.texName:setString(lmailData.Sender)
            else
                self.texName:setString(data.Sender)
            end
        else
            str = data.mailName
            if data.lCustom == 1 and str ~= "" then -- 自定义邮件
                local cjson = require "base.pack.json"
                local responseData = cjson.decode(str)
                local curLan = global.languageData:getCurrentLanguage()
                str = responseData[curLan] or responseData["en"]
            end

            -- 自定义标题
            local tempMail = luaCfg:get_email_by(11001)
            self.texName:setString(tempMail.Sender)
        end
        self.texContent:setString(str)
    end
    self.spRewardState:setVisible(data.itemState == 0 and data.appendixContent ~=0)
    -- self.Node_1.pic
    self.picNormal:setSpriteFrame(mailData:getItemIcon(data.secondType))
end


function UIMailListItem:checkListState(mailId, scale, ltype, lResult, loseCount, killCount)

    --print("mailId: "..mailId)
   -- print("scale, lType, lResult, loseCount, killCount: "..scale.."  "..ltype.." "..lResult.." "..loseCount.." "..killCount)
    if ltype == 1 then
        if lResult == 1 then
            self.texContent:setString(string.format(luaCfg:get_local_string(mailId),global.funcGame:_formatBigNumber(scale, 1), global.funcGame:_formatBigNumber(loseCount,1)))          
            table.insert(self.contentParm, scale)
            table.insert(self.contentParm, loseCount)
        else
            self.texContent:setString(string.format(luaCfg:get_local_string(mailId),global.funcGame:_formatBigNumber(loseCount, 1)))
            table.insert(self.contentParm, loseCount)
        end
    else
        killCount = killCount or 0 
        local temp = {killCount, 1, 2, 3, 4 , 5 , 6,  7,  8, 9 , 10} --防止 format 参数不够报错
        if mailId then 
            self.texContent:setString(string.format(luaCfg:get_local_string(mailId) or "%s" ,unpack(temp)))
        end 
        table.insert(self.contentParm, killCount)
    end
end

function UIMailListItem:getSoldierCount(data)
    
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

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- 当前item是否是全选状态
function UIMailListItem:setSelectAll()

    -- 编辑状态
    self.CellBtn:stopAllActions()
    if global.m_listPanel.isEditSelect then

        local curPos1 = cc.p(gdisplay.width/2 + 80, self.CellBtn:getPositionY())
        local action = cc.MoveTo:create(0.2, curPos1)
        self.CellBtn:runAction(action)

    else
        self.CellBtn:setPositionX(gdisplay.width/2)
    end

    self:selectState()
end

-- 选中状态
function UIMailListItem:selectState()

    self.checkBox:setSelected(self.data.isSelected == true)
end

function UIMailListItem:checkHandler(sender, eventType)

    self.data.isSelected = (not self.data.isSelected)
    self:selectState()
end
--CALLBACKS_FUNCS_END

return UIMailListItem

--endregion
