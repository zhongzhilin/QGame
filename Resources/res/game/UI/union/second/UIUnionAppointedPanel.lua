--region UIUnionAppointedPanel.lua
--Author : wuwx
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionAppointedPanel  = class("UIUnionAppointedPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIUnionAppointedCell = require("game.UI.union.list.UIUnionAppointedCell")

function UIUnionAppointedPanel:ctor()
    self:CreateUI()
end

function UIUnionAppointedPanel:CreateUI()
    local root = resMgr:createWidget("union/union_position_bg")
    self:initUI(root)
end

function UIUnionAppointedPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_position_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.name = self.root.Node_7.name_export
    self.apply = self.root.Node_7.apply_export
    self.btn_out = self.root.Node_7.btn_out_export
    self.icon = self.root.Node_7.icon_export
    self.reward = self.root.Node_7.reward_export
    self.no = self.root.Node_7.no_mlan_18_export
    self.node_tableView = self.root.node_tableView_export
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export

    uiMgr:addWidgetTouchHandler(self.btn_out, function(sender, eventType) self:outHanlder(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn_bj.btn_apply, function(sender, eventType) self:applyHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionAppointedCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUnionAppointedPanel:exit_call()
    global.panelMgr:closePanelForBtn("UIUnionAppointedPanel")
end

function UIUnionAppointedPanel:setData(data,sData)
    self.data = data
    self.sData = sData


    --确保本界面打开前一定有联盟成员界面
    local tData = global.panelMgr:getPanel("UIUnionMemberPanel"):getApplyList(data.id)
    self.no:setVisible(#tData <= 0)
    self.tableView:setData(tData)

    self.apply:setString(self.data.text)

    if self.sData.data.szName then
        self.name:setString(self.sData.data.szName)
    else
        self.name:setString(global.luaCfg:get_local_string(10254))
    end
    self.reward:setString(global.luaCfg:get_local_string(10264,#sData.applyData,data.text))

    --润稿处理 张亮
    global.tools:adjustNodePos(self.apply,self.name)


    -- self.icon:setSpriteFrame(self.data.icon)
    global.panelMgr:setTextureFor(self.icon,self.data.icon)
end

function UIUnionAppointedPanel:checkIsFans(lApply)
    return self.data.id == lApply
end

function UIUnionAppointedPanel:getlClass()
    return self.data.id
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnionAppointedPanel:applyHandler(sender, eventType)
    if not global.unionData:isLeader() then
        if self.sData.data.lID and self.sData.data.lID == global.userData:getUserId() then
            --自己担任此职位，无需申请
            local tt = global.luaCfg:get_errorcode_by("unionPositionYes").text
            return global.tipsMgr:showWarning(string.format(tt,self.data.text))
        end

        if self.sData.isApplying then
            --已经申请过了
            return global.tipsMgr:showWarning("unionHadPositionApply")
        end

        -- 申请
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("unionPositionApply", function()
            -- 确认
            local function callback()
                gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
                global.tipsMgr:showWarning("unionPositionIng")
            end
            local function failCall()
                -- body
                global.tipsMgr:showWarning("unionHadPositionApply")
            end
            global.unionApi:allyAction(callback,1,self.data.id,nil,failCall)
                
        end,self.data.text)
    else
        return global.tipsMgr:showWarning("unionPositionBoss")
    end
end

function UIUnionAppointedPanel:outHanlder(sender, eventType)
    -- 卸任
    if not global.unionData:isLeader() then
        return global.tipsMgr:showWarning("unionPowerNot")
    end

    if not self.sData.data.lID then
        --没有人担任职位
        return global.tipsMgr:showWarning("unionPositionNot")
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("unionPositionRevoke", function()
        -- 确认
        global.unionApi:allyAction(function(msg)
            -- body
            gevent:call(global.gameEvent.EV_ON_UNION_MEMBER_REFRESH)
            global.tipsMgr:showWarning("unionPositionDes")
        end,5,self.data.id,self.sData.data.lID)
            
    end,self.sData.data.szName,self.data.text)
end
--CALLBACKS_FUNCS_END

return UIUnionAppointedPanel

--endregion
