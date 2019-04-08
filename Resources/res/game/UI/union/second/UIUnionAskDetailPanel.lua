--region UIUnionAskDetailPanel.lua
--Author : wuwx
--Date   : 2017/01/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionMemProDetails = require("game.UI.union.widget.UIUnionMemProDetails")
--REQUIRE_CLASS_END

local UIUnionAskDetailPanel  = class("UIUnionAskDetailPanel", function() return gdisplay.newWidget() end )

function UIUnionAskDetailPanel:ctor()
    self:CreateUI()
end

function UIUnionAskDetailPanel:CreateUI()
    local root = resMgr:createWidget("union/union_please_info")
    self:initUI(root)
end

function UIUnionAskDetailPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_please_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = UIUnionMemProDetails.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.request = self.root.Node_export.request.request_mlan_7_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.request, function(sender, eventType) self:inviteHandler(sender, eventType) end)
--EXPORT_NODE_END
end

-- 0联盟成员 1 聊天列表 2 个人外交 3 官职
function UIUnionAskDetailPanel:setData(data)

    self.data = data
    local listType = global.panelMgr:getPanel("UIUnionAskPanel"):getOthParam()
    self.listType = listType

    if listType == 2 then
        self.FileNode_1:setParam(2)
    end
    self.FileNode_1:setData(data)

    if listType == 1 then
        self.request:setString(global.luaCfg:get_local_string(10284))
    elseif listType == 2 then
        self.request:setString(global.luaCfg:get_local_string(10788))
    elseif listType == 3 then
        self.request:setString(global.luaCfg:get_local_string(10901))
    else
        self.request:setString(global.luaCfg:get_local_string(10327))
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnionAskDetailPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIUnionAskDetailPanel")
end

function UIUnionAskDetailPanel:inviteHandler(sender, eventType)
    
    if self.listType == 1 then

        global.panelMgr:closePanel("UIUnionAskDetailPanel")
        gevent:call(global.gameEvent.EV_ON_UNION_SELECTUSER, self.data)
    elseif self.listType == 2 then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData(10789, function()
            
            global.worldApi:callFight(self.data.lUserID, function ()
                -- body
                global.panelMgr:closePanel("UIUnionAskDetailPanel")
                global.tipsMgr:showWarning("dip_success", self.data.szName or "-")
                gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)
            end)
        end, self.data.szName or "-")
    elseif self.listType == 3 then


        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData('PostCD', function()
            local data = global.panelMgr:getPanel('UIOfficalPanel'):getData()
            global.worldApi:setOffical(data.curLandId,data.curOffId,self.data.lUserID, function (msg)            
                global.tipsMgr:showWarning("unionPositionOK")
                global.panelMgr:getPanel('UIOfficalInfoPanel'):setData(data.curOffId,msg.tagOfficialer[1])
                global.panelMgr:getPanel('UIOfficalPanel'):initData(msg)
                global.panelMgr:closePanel("UIUnionAskPanel")                
                global.panelMgr:closePanel("UIUnionAskDetailPanel")
            end)     
        end)          
    else

        if not global.unionData:isHadPower(14) then
            return global.tipsMgr:showWarning("unionPowerNot")
        end
        global.unionApi:allyAction(function(msg)
            -- body
            global.tipsMgr:showWarning("UnionInvitation")
            global.panelMgr:closePanel("UIUnionAskDetailPanel")
        end,7,0,self.data.lUserID)
    end
end
--CALLBACKS_FUNCS_END

return UIUnionAskDetailPanel

--endregion
