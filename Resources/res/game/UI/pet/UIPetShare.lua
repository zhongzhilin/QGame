--region UIPetShare.lua
--Author : yyt
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetShare  = class("UIPetShare", function() return gdisplay.newWidget() end )

function UIPetShare:ctor()
    self:CreateUI()
end

function UIPetShare:CreateUI()
    local root = resMgr:createWidget("pet/pet_share")
    self:initUI(root)
end

function UIPetShare:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_share")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.closePanel = self.root.closePanel_export

    uiMgr:addWidgetTouchHandler(self.closePanel, function(sender, eventType) self:hidePanel_export(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.btnCancel, function(sender, eventType) self:cancelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btnCountry, function(sender, eventType) self:countryShareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btnUnion, function(sender, eventType) self:unionShareHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetShare:setData(data, curPanel)
    self.curPanel = curPanel
    self.data = data
end

function UIPetShare:hidePanel_export(sender, eventType)
    if not self.curPanel then return end
    local panel = global.panelMgr:getPanel(self.curPanel)
    if panel.hideSharePanel then
        panel:hideSharePanel()
    end
end

function UIPetShare:cancelHandler(sender, eventType)
    if not self.curPanel then return end
    local panel = global.panelMgr:getPanel(self.curPanel)
    if panel.hideSharePanel then
        panel:hideSharePanel()
    end
end

function UIPetShare:getShareInfo()

    local infoData = {}
    local petType = self.data.type
    local loadName = global.userData:getUserName()
    table.insert(infoData, petType)
    table.insert(infoData, loadName)
    table.insert(infoData, "0")
    table.insert(infoData, "0")

    -- 已经激活的主动技能id
    local getPetSkill = function ()
        -- body
        local skill = "0"
        for i=1,4 do
            local curSkill = global.petData:getGodSkillByKind(self.data.type, self.data.skill_type1[i])
            if curSkill.serverData and curSkill.serverData.lState == 2 then -- 已经解锁
                if skill ~= "" then
                    skill = skill .. "&" .. curSkill.serverData.lID
                else
                    skill = curSkill.serverData.lID
                end
            end
        end
        return skill
    end

    local allyId = global.userData:getlAllyID()
    if allyId ~= 0 then
        for i=1,3 do
            table.insert(infoData, "0")
        end
    end
    table.insert(infoData, global.userheadframedata:getCrutFrame().id)
    table.insert(infoData, self.data.serverData.lPower or 0)
    table.insert(infoData, getPetSkill())   

    local infoStr = ""
    for i,v in ipairs(infoData) do
        if infoStr ~= "" then
            infoStr = infoStr .. "@" .. tostring(v)
        else
            infoStr = tostring(v)
        end
    end 
    return infoStr
end

function UIPetShare:countryShareHandler(sender, eventType)

    local tagSpl = {}
    tagSpl.lKey = 11
    tagSpl.lValue = self.data.serverData.lGrade or 1
    tagSpl.szParam = ""
    tagSpl.szInfo = tostring(self:getShareInfo())
    tagSpl.lTime = 0

    local szContent = ""
    local lFromId = global.userData:getUserId()

    global.chatApi:senderMsg(function(msg)

        global.chatData:setCurLType(2)
        global.chatData:setCurChatPage(2)
        global.chatData:addChat(2, msg.tagMsg or {})
        global.panelMgr:openPanel("UIChatPanel")

        if self.curPanel == "UIPetInfoPanel" then
            global.panelMgr:closePanel(self.curPanel)
        end

    end, 2, szContent, lFromId, 0, tagSpl )

end

function UIPetShare:unionShareHandler(sender, eventType)

    local allyId = global.userData:getlAllyID()
    if allyId == 0 then
        global.tipsMgr:showWarning("ChatUnionNo")
        return
    end
    
    local tagSpl = {}
    tagSpl.lKey = 11
    tagSpl.lValue = self.data.serverData.lGrade or 1
    tagSpl.szParam = ""
    tagSpl.szInfo = tostring(self:getShareInfo())
    tagSpl.lTime = 0

    local szContent = ""
    local lFromId = global.userData:getUserId()

    global.chatApi:senderMsg(function(msg)

        global.chatData:setCurLType(3)
        global.chatData:setCurChatPage(3)
        global.chatData:addChat(3, msg.tagMsg or {})
        global.panelMgr:openPanel("UIChatPanel")
         
        if self.curPanel == "UIPetInfoPanel" then
            global.panelMgr:closePanel(self.curPanel)
        end

    end, 3, szContent, lFromId, 0,  tagSpl )

end
--CALLBACKS_FUNCS_END

return UIPetShare

--endregion
