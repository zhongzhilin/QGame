--region UIUnionMemDetails.lua
--Author : wuwx
--Date   : 2017/01/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionMemProDetails = require("game.UI.union.widget.UIUnionMemProDetails")
--REQUIRE_CLASS_END

local UIUnionMemDetails  = class("UIUnionMemDetails", function() return gdisplay.newWidget() end )

function UIUnionMemDetails:ctor()
    self:CreateUI()
end

function UIUnionMemDetails:CreateUI()
    local root = resMgr:createWidget("union/union_memdata")
    self:initUI(root)
end

function UIUnionMemDetails:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_memdata")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.line = self.root.Node_export.line_export
    self.FileNode_1 = UIUnionMemProDetails.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.Node_2 = self.root.Node_export.Node_2_export
    self.request = self.root.Node_export.Node_2_export.transfertt.request_mlan_5_export
    self.Node_1 = self.root.Node_export.Node_1_export
    self.request = self.root.Node_export.Node_1_export.request.request_mlan_5_export
    self.request = self.root.Node_export.Node_1_export.btn_transfer.request_mlan_5_export
    self.request = self.root.Node_export.Node_1_export.btn_tick.request_mlan_5_export
    self.request = self.root.Node_export.Node_1_export.btn_down.request_mlan_5_export
    self.request = self.root.Node_export.Node_1_export.btn_up.request_mlan_5_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_2_export.transfertt, function(sender, eventType) self:restransfer(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_1_export.request, function(sender, eventType) self:mailHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_1_export.btn_transfer, function(sender, eventType) self:transferHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_1_export.btn_tick, function(sender, eventType) self:tickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_1_export.btn_down, function(sender, eventType) self:downHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_1_export.btn_up, function(sender, eventType) self:upHandler(sender, eventType) end)
--EXPORT_NODE_END
end


function UIUnionMemDetails:setData(data,unionInfo,allData)
-- message AllyMember
-- {
--     required int32      lID         = 1;
--     required int32      lRole       = 2;
--     required string     szName      = 3;
--     required int32      lFace       = 4;//头像
--     required int32      lPower      = 5;//战力值
--     required int32      lLastTime   = 6;//最近登录时间
--     required int32      lOnline     = 7;//1在线0不在线
--     required int32      lClass      = 8;//1-4
--     required int32      lApply      = 9;//0未申请，1-4申请的官职
-- }
    self.data = data
    self.unionInfo = unionInfo
    self.FileNode_1:setData(data,unionInfo,allData)

    local def =self.bg:getContentSize()

    if global.panelMgr:getPanel("UIUnionMemberPanel").isOtherWay then 
        self.bg:setContentSize(cc.size(def.width , 820 ))
    else 
        self.bg:setContentSize(cc.size(def.width , 865))
    end 

    self.Node_2:setVisible(global.panelMgr:getPanel("UIUnionMemberPanel").isOtherWay)
    self.Node_1:setVisible(not global.panelMgr:getPanel("UIUnionMemberPanel").isOtherWay)
end

function UIUnionMemDetails:onExit(data)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnionMemDetails:mailHandler(sender, eventType)

    if self.data.lID == global.userData:getUserId() then
        global.tipsMgr:showWarning("unionMyNot")
        return
    end

    global.panelMgr:closePanel("UIUnionMemDetails")
    global.panelMgr:openPanel("UIChatPrivatePanel"):init(self.data.lID)
end

function UIUnionMemDetails:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIUnionMemDetails")
end

--转让盟主
function UIUnionMemDetails:transferHandler(sender, eventType)
    if self.data.lRole<=0 then
        return global.tipsMgr:showWarning("unionAbroad")
    end

    if not global.panelMgr:getPanel("UIUnionMemberPanel"):isMineUnion() then
        return global.tipsMgr:showWarning("unionWrong")
    end

    if not global.unionData:isLeader() then
        return global.tipsMgr:showWarning("unionNoBoss")
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("unionBossEnter", function()
        -- 确认
        global.unionApi:allyAction(function(msg)
            -- body
            global.tipsMgr:showWarning("unionBossGo")
            global.panelMgr:closePanel("UIUnionMemDetails")
        end,4,0,self.data.lID)
            
    end,self.data.szName)
end

--踢出联盟
function UIUnionMemDetails:tickHandler(sender, eventType)
    if global.userData:isMine(self.data.lID) then
        return global.tipsMgr:showWarning("unionMyNot")
    end

    if self.data.lRole<=0 then
        return global.tipsMgr:showWarning("unionAbroad")
    end

    if not global.panelMgr:getPanel("UIUnionMemberPanel"):isMineUnion() then
        return global.tipsMgr:showWarning("unionWrong")
    end
    
    if not global.unionData:isHadPower(13) then 
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    --操作对象阶级太高了
    if self.data.lRole >= global.userData:getlAllyRole() then 
        return global.tipsMgr:showWarning("Unionpower03")
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("unionFromEnter", function()
        -- 确认
        global.unionApi:tickMember(function(msg)
            -- body
            global.panelMgr:closePanel("UIUnionMemDetails")
        end,self.data.lID)
            
    end,self.data.szName)
end

--降阶级
function UIUnionMemDetails:downHandler(sender, eventType)
    if global.userData:isMine(self.data.lID) then
        return global.tipsMgr:showWarning("unionMyNot")
    end

    if self.data.lRole<=0 then
        return global.tipsMgr:showWarning("unionAbroad")
    end

    if not global.panelMgr:getPanel("UIUnionMemberPanel"):isMineUnion() then
        return global.tipsMgr:showWarning("unionWrong")
    end

    if not global.unionData:isHadPower(6) then 
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    --操作对象阶级太高了
    if self.data.lRole >= global.userData:getlAllyRole() then 
        return global.tipsMgr:showWarning("Unionpower03")
    end

    if self.data.lRole <= 1 then 
        return global.tipsMgr:showWarning("unionLvMin")
    end

    local down = self.data.lRole-1
    global.unionApi:allyAction(function(msg)
        if down == self.data.lRole then return end

        self.data.lRole = self.data.lRole-1
        self:setData(self.data, self.unionInfo)
        global.tipsMgr:showWarning("unionDowmOK")
    end,3,down,self.data.lID)
end

--升阶级
function UIUnionMemDetails:upHandler(sender, eventType)
    if global.userData:isMine(self.data.lID) then
        return global.tipsMgr:showWarning("unionMyNot")
    end

    if self.data.lRole<=0 then
        return global.tipsMgr:showWarning("unionAbroad")
    end

    if not global.panelMgr:getPanel("UIUnionMemberPanel"):isMineUnion() then
        return global.tipsMgr:showWarning("unionWrong")
    end

    if not global.unionData:isHadPower(7) then 
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    local lRole = global.unionData:getInUnionMemlRole()
    --操作对象阶级太高了
    if self.data.lRole >= lRole then 
        return global.tipsMgr:showWarning("Unionpower03")
    end

    if self.data.lRole == 4 then 
        return global.tipsMgr:showWarning("unionLVmax")
    end

    if (lRole <= self.data.lRole+1) then 
        return global.tipsMgr:showWarning("unionLVmax")
    end

    local up = self.data.lRole+1
    global.unionApi:allyAction(function(msg)
        if up == self.data.lRole then return end

        self.data.lRole = self.data.lRole+1
        self:setData(self.data, self.unionInfo)
        global.tipsMgr:showWarning("unionUpOK")
    end,3,self.data.lRole+1,self.data.lID)
end

function UIUnionMemDetails:restransfer(sender, eventType)
    --dump(self.data)
        
    if global.userData:isMine(self.data.lID) then
        return global.tipsMgr:showWarning("unionMyNot")
    end

    if not global.troopData:isShoperIdle() then
        return global.tipsMgr:showWarning("resTransport")
    end
    
    if not self.data.lMapID or self.data.lMapID == 0 then
        return global.tipsMgr:showWarning("unionMateNoCity")
    end

    local attackMode = 11
    local forceType = 0
    local troopId = global.troopData:getShoperTroopId()
    global.worldApi:pathTime(global.userData:getWorldCityID(), self.data.lMapID , troopId , attackMode , forceType ,function(msg)
        global.panelMgr:closePanel("UIUnionMemDetails")
        if tolua.isnull(self) then return end 
        global.panelMgr:openPanel("UITransferPanel"):setData(msg , self.data)
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionMemDetails

--endregion
