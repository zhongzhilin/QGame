--region UIApplyOffice.lua
--Author : wuwx
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIApplyOffice  = class("UIApplyOffice", function() return gdisplay.newWidget() end )

function UIApplyOffice:ctor()
end

function UIApplyOffice:CreateUI()
    local root = resMgr:createWidget("union/position_btn")
    self:initUI(root)
end

function UIApplyOffice:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/position_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.title = self.root.btn_export.title_mlan_3_export
    self.apply = self.root.btn_export.apply_mlan_6_export
    self.icon = self.root.btn_export.icon_export
    self.spReadState = self.root.spReadState_export
    self.Text = self.root.spReadState_export.Text_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:applyHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIApplyOffice:setData(data)
    self.data = data

    -- self.icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.icon,data.icon)
    self.title:setString(data.text)
    self.apply:setString("")
    self.spReadState:setVisible(false)

    self.isInit = false
end

function UIApplyOffice:setOfficeData(data)
    self.isInit = true
    self.sData = data
    self.spReadState:setVisible(false)

    if global.unionData:isLeader() and #data.applyData > 0 and global.panelMgr:getPanel("UIUnionMemberPanel"):isMineUnion() then
        --盟主显示红点
        self.spReadState:setVisible(true)
        self.Text:setString(#data.applyData)
    end
    if data.data.szName then
        self.apply:setString(data.data.szName)
    else
        self.apply:setString(global.luaCfg:get_local_string(10254))
    end

    if global.panelMgr:isPanelOpened("UIUnionAppointedPanel") then
        --刷新任命界面，包括自己的这个状态
        local panel = global.panelMgr:getPanel("UIUnionAppointedPanel")
        if panel:checkIsFans(self.data.id) then
            panel:setData(self.data,data)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIApplyOffice:applyHandler(sender, eventType)
    if not self.isInit then return end

    if global.panelMgr:getPanel("UIUnionMemberPanel"):isMineUnion() then
        -- 任命界面
        global.panelMgr:openPanel("UIUnionAppointedPanel"):setData(self.data,self.sData)
    else
        global.tipsMgr:showWarning("unionWrong")
    end
end
--CALLBACKS_FUNCS_END

return UIApplyOffice

--endregion
