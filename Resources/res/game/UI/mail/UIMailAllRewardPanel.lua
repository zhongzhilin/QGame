--region UIMailAllRewardPanel.lua
--Author : yyt
--Date   : 2018/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailAllRewardPanel  = class("UIMailAllRewardPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIMailAllRewardCell = require("game.UI.mail.UIMailAllRewardCell")

function UIMailAllRewardPanel:ctor()
    self:CreateUI()
end

function UIMailAllRewardPanel:CreateUI()
    local root = resMgr:createWidget("mail/mail_getReward_all")
    self:initUI(root)
end

function UIMailAllRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_getReward_all")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.tableView_size = self.root.Node_export.tableView_size_export
    self.cell = self.root.Node_export.tableView_size_export.cell_export
    self.Button_1 = self.root.Node_export.Button_1_export
    self.tableviewnode = self.root.Node_export.tableviewnode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:jump_call(sender, eventType) end)
--EXPORT_NODE_END
    self.tableView = UITableView.new()
        :setSize(self.tableView_size:getContentSize())
        :setCellSize(self.cell:getContentSize())
        :setCellTemplate(UIMailAllRewardCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tableviewnode:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIMailAllRewardPanel:setData(data)
    
    self.data = data
    self.tableView:setData(data)
    self.Button_1:setEnabled(table.nums(data) > 0)
end

function UIMailAllRewardPanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIMailAllRewardPanel")
end

function UIMailAllRewardPanel:jump_call(sender, eventType)
    
    local idList = {}
    for i,v in ipairs(self.data) do
        table.insert(idList, v.lID)
    end

    global.mailApi:actionMail(idList, 2, function(msg)

        gevent:call(gsound.EV_ON_PLAYSOUND,"mail_collect")

        -- 修改选中邮箱读取状态
        for i,v in ipairs(self.data) do
            global.mailData:updataReadState(v.lID, v.lType)
        end

        global.mailData:updataGiftState(idList)
        global.tipsMgr:showWarning("EMAIL_RECEIVE_COMPLETE") 
        global.panelMgr:closePanel("UIMailAllRewardPanel")

    end)


end

--CALLBACKS_FUNCS_END

return UIMailAllRewardPanel

--endregion
