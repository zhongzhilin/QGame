--region UIWorldUnlock.lua
--Author : Untory
--Date   : 2017/09/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldUnlock  = class("UIWorldUnlock", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIWorldUnlockItemCell = require("game.UI.world.widget.UIWorldUnlockItemCell")

function UIWorldUnlock:ctor()
    self:CreateUI()
end

function UIWorldUnlock:CreateUI()
    local root = resMgr:createWidget("world/info/unlockk_bj")
    self:initUI(root)
end

function UIWorldUnlock:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/unlockk_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.info = self.root.Node_export.info_export
    self.leftBtn = self.root.Node_export.leftBtn_export
    self.rightBtn = self.root.Node_export.rightBtn_export
    self.tableview_node = self.root.Node_export.tableview_node_export
    self.tableview_item = self.root.Node_export.tableview_item_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_43, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.go, function(sender, eventType) self:addTips(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.no, function(sender, eventType) self:delHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:leftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:rightHandler(sender, eventType) end)
--EXPORT_NODE_END


    self.tableView = UITableView.new()
        :setSize(self.tableview_node:getContentSize())
        :setCellSize(self.tableview_item:getContentSize())
        :setCellTemplate(UIWorldUnlockItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)

    self.tableview_node:getParent():addChild(self.tableView)
    self.tableView:setPosition(self.tableview_node:getPosition())

    -- self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)
end

function UIWorldUnlock:tableMove()
    
    local offsetX = self.tableView:getContentOffset().x
    local itemW = self.tableview_item:getContentSize().width
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

function UIWorldUnlock:setData()

    local resLevel = global.userData:getResLevel()
    local map_unlock_list = luaCfg:map_unlock_list()

    local list = {}
    for _,v in ipairs(map_unlock_list) do

        if v.lv == resLevel then
            
            table.insert(list,v)
        end
    end

    self.tableView:setData(list)

    uiMgr:setRichText(self, 'info', 50213, {lv = resLevel})
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldUnlock:exitCall(sender, eventType)

    global.panelMgr:closePanelForBtn("UIWorldUnlock")

end

function UIWorldUnlock:addTips(sender, eventType)

    global.worldApi:freeToMove(1,function()
        
        global.userData:cleanFreeToMoveCity()
        global.scMgr:gotoWorldSceneWithAnimation()
    end)
end

function UIWorldUnlock:delHandler(sender, eventType)

    
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("flycity02", function()
        global.worldApi:freeToMove(2,function()
        
            global.userData:cleanFreeToMoveCity()
            global.scMgr:gotoWorldSceneWithAnimation()
        end)
    end)        
end

function UIWorldUnlock:leftHandler(sender, eventType)

    -- local offset = self.tableView:getContentOffset()
    -- local itemW = self.tableview_item:getContentSize().width
    -- local maxX = self.tableView:maxContainerOffset().x
    -- local minX = self.tableView:minContainerOffset().x
    -- local moveX = offset.x + itemW
    -- if moveX > maxX then
    --     moveX = maxX
    -- end
    -- global.uiMgr:addSceneModel(0.5)
    -- self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.3)  
end

function UIWorldUnlock:rightHandler(sender, eventType)

    -- local offset = self.tableView:getContentOffset()
    -- local itemW = self.tableview_item:getContentSize().width
    -- local minX = self.tableView:minContainerOffset().x
    -- local moveX = offset.x - itemW
    -- if moveX < minX then
    --     moveX = minX
    -- end
    -- global.uiMgr:addSceneModel(0.5)
    -- self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.3)
end
--CALLBACKS_FUNCS_END

return UIWorldUnlock

--endregion
