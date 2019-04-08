--region UIUWarRecordItem.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarRecordItem  = class("UIUWarRecordItem", function() return gdisplay.newWidget() end )

function UIUWarRecordItem:ctor()
    self:CreateUI()
end

function UIUWarRecordItem:CreateUI()
    local root = resMgr:createWidget("union/union_battle_info")
    self:initUI(root)
end

function UIUWarRecordItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.Image_3.time_export
    self.icon = self.root.Image_3.icon_export
    self.atk_result = self.root.Image_3.atk_result_export
    self.atk_name = self.root.Image_3.atk_name_export
    self.def_result = self.root.Image_3.def_result_export
    self.def_name = self.root.Image_3.def_name_export
    self.btn_appointed = self.root.btn_appointed_export

    uiMgr:addWidgetTouchHandler(self.btn_appointed, function(sender, eventType) self:onLookHanlder(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUWarRecordItem:setData(data)
    self.data = data

    local iconNames = {
        [1001] = "ui_surface_icon/icon_mail_notice_101.png",
        [1002] = "ui_surface_icon/icon_mail_notice_102.png",
        [1101] = "ui_surface_icon/icon_mail_notice_104.png",
        [1102] = "ui_surface_icon/icon_mail_notice_103.png",
        [2001] = "ui_surface_icon/icon_mail_notice_201.png",
        [2002] = "ui_surface_icon/icon_mail_notice_202.png",
        [2101] = "ui_surface_icon/icon_mail_notice_204.png",
        [2102] = "ui_surface_icon/icon_mail_notice_203.png",
        [6001] = "ui_surface_icon/icon_mail_notice_301.png",
        [6002] = "ui_surface_icon/icon_mail_notice_302.png",
        [6101] = "ui_surface_icon/icon_mail_notice_304.png",
        [6102] = "ui_surface_icon/icon_mail_notice_303.png",
        [7001] = "ui_surface_icon/icon_mail_notice_501.png",
        [7002] = "ui_surface_icon/icon_mail_notice_502.png",
        [7101] = "ui_surface_icon/icon_mail_notice_204.png",
        [7102] = "ui_surface_icon/icon_mail_notice_203.png",
    }
    local frameName = iconNames[data.lWarType*1000+data.lParty*100+data.lResult]
    if frameName then
        self.icon:loadTexture(frameName,ccui.TextureResType.plistType)
    end

    if data.lResult == 1 then
        --进攻方胜利
        self.atk_result:setTextColor(cc.c3b(87, 213, 63))
        self.def_result:setTextColor(cc.c3b(180, 29, 11))
        self.atk_result:setString(global.luaCfg:get_local_string(10227))
        self.def_result:setString(global.luaCfg:get_local_string(10228))
    else
        --防守方胜利
        self.atk_result:setTextColor(cc.c3b(180, 29, 11))
        self.def_result:setTextColor(cc.c3b(87, 213, 63))
        self.atk_result:setString(global.luaCfg:get_local_string(10228))
        self.def_result:setString(global.luaCfg:get_local_string(10227))
    end

    local unionName = ""
    if data.szAtkAllyFlag and data.szAtkAllyFlag == "" then
        unionName = data.szAtkName
    else
        unionName = string.format("【%s】%s",data.szAtkAllyFlag, data.szAtkName)
    end
    self.atk_name:setString(unionName)

    local unionName = ""
    if data.szDefAllyFlag and data.szDefAllyFlag == "" then
        unionName = data.szDefName
    else
        unionName = string.format("【%s】%s",data.szDefAllyFlag, data.szDefName)
    end
    self.def_name:setString(unionName)

    self.time:setString(global.funcGame.getDurationToNow(data.lWarTime))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUWarRecordItem:onLookHanlder(sender, eventType)
    local reportId = self.data.szWarID

    global.chatApi:getBattleInfo( reportId ,function(msg)
        msg.tagMail = msg.tagMail or {}
        local panel = global.panelMgr:openPanel("UIMailBattlePanel")
        panel:setData(msg.tagMail,false, nil, true)
    end)
end
--CALLBACKS_FUNCS_END

return UIUWarRecordItem

--endregion
