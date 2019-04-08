
--region UIBattleErrorcode.lua
--Author : yyt
--Date   : 2017/09/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleErrorcode  = class("UIBattleErrorcode", function() return gdisplay.newWidget() end )

function UIBattleErrorcode:ctor()
    self:CreateUI()
end

function UIBattleErrorcode:CreateUI()
    local root = resMgr:createWidget("common/battle_errorcode_bg")
    self:initUI(root)
end

function UIBattleErrorcode:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/battle_errorcode_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.title = self.root.Node_export.title_export
    self.Text = self.root.Node_export.btnBattle.Text_mlan_8_export
    self.time = self.root.Node_export.time_export
    self.node_tableView = self.root.Node_export.node_tableView_export
    self.topNode = self.root.Node_export.topNode_export
    self.bottomNode = self.root.Node_export.bottomNode_export
    self.tbSize = self.root.Node_export.tbSize_export
    self.cellSize = self.root.Node_export.cellSize_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btnBattle, function(sender, eventType) self:checkMailHandler(sender, eventType) end)
--EXPORT_NODE_END

    local UITableView = require("game.UI.common.UITableView")
    local UIBattleCell = require("game.UI.commonUI.UIBattleCell")
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize())
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIBattleCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.text = self.Text
    self.roleHead = self.Node.btnBattle.Image_1
    self.posX = self.roleHead:getPositionX()

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBattleErrorcode:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.onCloseHandler and (not global.guideMgr:isPlaying()) then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.onCloseHandler and (not global.guideMgr:isPlaying()) then
            self:onCloseHandler()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_BATTLEERRORCODE_SHOW, function ()
        if self.checkHeroPanel then
            self:checkHeroPanel()
        end
    end)

    self.isShow = true

end

-- {titleStr="", reportId=1011, tagItem={}}
function UIBattleErrorcode:setData(data)

    self.data = data
    self.title:setString(data.titleStr)
    self.tableView:setData(data.tagItem)

    self.Node:setScaleY(0)
    self.Node:setVisible(true)
    self.Node:stopAllActions()
    self.Node:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.45,1,1)))

    -- 倒计时
    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end
    self.dt = 5
    self.cutTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimerHandler), 1)
    self:cutTimerHandler(0)

    self.text:setPositionX(self.posX - 10)

    self:checkHeroPanel()

end

function UIBattleErrorcode:checkHeroPanel()

    self.root:setVisible(true)
    local heroPanel = global.panelMgr:getPanel("UIHeroLvUp")
    if heroPanel.isShow then
        self.root:setVisible(false)
    end
end

function UIBattleErrorcode:cutTimerHandler()

    if tolua.isnull(self.time) then return end
    self.time:setString(global.luaCfg:get_local_string(10839, self.dt))
    if self.dt <= 0 then
        if self.cutTimer ~= nil then
            gscheduler.unscheduleGlobal(self.cutTimer)
            self.cutTimer = nil
        end
        self:onCloseHandler()
    end
    self.dt = self.dt - 1
end

function UIBattleErrorcode:onExit()
    if self.cutTimer ~= nil then
        gscheduler.unscheduleGlobal(self.cutTimer)
        self.cutTimer = nil
    end
    self.isShow = false
end

function UIBattleErrorcode:onCloseHandler(sender, eventType)
    if not tolua.isnull(self.Node) then
        self.Node:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create(), cc.CallFunc:create(function ()
            global.panelMgr:closePanel("UIBattleErrorcode")
            global.heroData:checkWaitPanel()
        end)))
    end
end

function UIBattleErrorcode:checkMailHandler(sender, eventType)

    if global.guideMgr:isPlaying() then
        self:onCloseHandler()
        return
    end

    global.chatApi:getBattleInfo(self.data.reportId ,function(msg)
        
        global.panelMgr:closePanel("UIBattleErrorcode")
        msg.tagMail = msg.tagMail or {}
        if not msg.tagMail.lType then return end
        global.mailData:setTitleStrByData(msg.tagMail)

        local panel = nil
        if msg.tagMail.lType == 3 then
            panel = global.panelMgr:openPanel("UIBattleNonePanel")
            msg.tagMail.mailID = msg.tagMail.lID
            msg.tagMail.isErrorCode = true
            panel:setData(msg.tagMail)
        else
            panel = global.panelMgr:openPanel("UIMailBattlePanel")
            panel:setData(msg.tagMail, false)
            panel:showCollect()
        end

    end, global.userData:getUserId(), 1)
end
--CALLBACKS_FUNCS_END

return UIBattleErrorcode

--endregion
