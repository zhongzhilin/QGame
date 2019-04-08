--region UIUnionModifyFlag.lua
--Author : wuwx
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIUnionModifyFlag  = class("UIUnionModifyFlag", function() return gdisplay.newWidget() end )

function UIUnionModifyFlag:ctor()
    self:CreateUI()
end

function UIUnionModifyFlag:CreateUI()
    local root = resMgr:createWidget("union/union_flag")
    self:initUI(root)
end

function UIUnionModifyFlag:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_flag")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_mlan_15_export
    self.node_tableView = self.root.Node_export.node_tableView_export
    self.leftBtn = self.root.Node_export.leftBtn_export
    self.rightBtn = self.root.Node_export.rightBtn_export
    self.selected_flag = self.root.Node_export.selected_flag_export
    self.selected_flag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.selected_flag, self.root.Node_export.selected_flag_export)
    self.free_btn = self.root.Node_export.free_btn_export
    self.charge_btn = self.root.Node_export.charge_btn_export
    self.dia_icon = self.root.Node_export.charge_btn_export.dia_icon_export
    self.dia_num = self.root.Node_export.charge_btn_export.dia_num_export
    self.itemLayout = self.root.Node_export.itemLayout_export
    self.contentLayout = self.root.Node_export.contentLayout_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create, function(sender, eventType) self:createHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:leftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:rightHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_btn, function(sender, eventType) self:freeSaveHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.charge_btn, function(sender, eventType) self:chargeSaveHandler(sender, eventType) end)
--EXPORT_NODE_END

    local UITableView = require("game.UI.common.UITableView")
    local UIUnionFlagCell = require("game.UI.union.list.UIUnionFlagCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize())
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionFlagCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

end

function UIUnionModifyFlag:tableMove()
    
    local offsetX = self.tableView:getContentOffset().x
    local itemW = self.itemLayout:getContentSize().width
    local minX = self.tableView:minContainerOffset().x

    if offsetX > -(itemW/2) then
        self.leftBtn:setEnabled(false)
        self.rightBtn:setEnabled(true)
    elseif offsetX < -(itemW/2) and offsetX > (minX+itemW/2) then
        self.leftBtn:setEnabled(true)
        self.rightBtn:setEnabled(true)
    elseif offsetX <= (minX+itemW/2) then
        self.leftBtn:setEnabled(true)
        self.rightBtn:setEnabled(false)
    end   
end

function UIUnionModifyFlag:onEnter()

    self.leftBtn:setEnabled(false)
    self.rightBtn:setEnabled(true)

    self:setData()
end

function UIUnionModifyFlag:setData()
    self.data = global.unionData:getInUnion()

    local flags = clone(global.luaCfg:union_flag())
    table.sort(flags, function(s1, s2) return s1.array < s2.array end)
    self.tableView:setData(flags)
    
    if not self.data.lTotemChg or self.data.lTotemChg <= 0 then
        self.data.lTotemChg = 0
        self.m_costRmb = 0
    else
        self.m_costRmb = global.luaCfg:get_config_by(1).unionFlag
    end
    self.free_btn:setVisible(self.m_costRmb<=0)
    self.charge_btn:setVisible(self.m_costRmb>0)
    self.dia_num:setString(self.m_costRmb)
    global.tools:adjustNodePos(self.dia_icon,self.dia_num)
    self:checkDiamondEnough(self.m_costRmb)

    self.selected_flag:setData(self.data.lTotem)
    self.m_lTotem = self.data.lTotem
end

function UIUnionModifyFlag:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.dia_num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.dia_num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UIUnionModifyFlag:setFlag(lTotem)
    self.m_lTotem = lTotem
    self.selected_flag:setData(self.m_lTotem)
end

function UIUnionModifyFlag:save()
    if self.m_lTotem == self.data.lTotem then
        return global.tipsMgr:showWarning("unionFlagCurrent")
    end

    self.data.lTotem = self.m_lTotem
    self.data.lTotemChg = self.data.lTotemChg + 1
    local param = {lTotem = self.m_lTotem,lUpdateID={9}}
    global.unionApi:setAllyUpdate(param, function()
        global.unionData:setInUnion(self.data)
        global.tipsMgr:showWarning("unionFlagOK")
        global.panelMgr:closePanel("UIUnionModifyFlag")
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL,true)
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionModifyFlag:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUnionModifyFlag")
end

function UIUnionModifyFlag:freeSaveHandler(sender, eventType)

    self:save()
end

function UIUnionModifyFlag:chargeSaveHandler(sender, eventType)
    if not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND, self.m_costRmb, self.dia_num) then
        return 
    end

    self:save()
end

function UIUnionModifyFlag:createHandler(sender, eventType)
    
end

function UIUnionModifyFlag:leftHandler(sender, eventType)

    local offset = self.tableView:getContentOffset()
    local itemW = self.itemLayout:getContentSize().width
    local maxX = self.tableView:maxContainerOffset().x
    local minX = self.tableView:minContainerOffset().x
    local flags = global.luaCfg:union_flag()
    local moveX = offset.x + 6*itemW
    if moveX > maxX then
        moveX = maxX
    end
    global.uiMgr:addSceneModel(0.5)
    self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.3)  

end

function UIUnionModifyFlag:rightHandler(sender, eventType)
    local offset = self.tableView:getContentOffset()
    local itemW = self.itemLayout:getContentSize().width
    local minX = self.tableView:minContainerOffset().x
    local flags = global.luaCfg:union_flag()
    local moveX = offset.x - 6*itemW
    if moveX < minX then
        moveX = minX
    end
    global.uiMgr:addSceneModel(0.5)
    self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.3)
end
--CALLBACKS_FUNCS_END

return UIUnionModifyFlag

--endregion
