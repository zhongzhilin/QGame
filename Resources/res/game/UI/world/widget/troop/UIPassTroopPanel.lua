--region UIPassTroopPanel.lua
--Author : untory
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITableView = require("game.UI.common.UITableView")
local UIPassTroopItemCell = require("game.UI.world.widget.troop.UIPassTroopItemCell")
local UIPassTroopPanel  = class("UIPassTroopPanel", function() return gdisplay.newWidget() end )

function UIPassTroopPanel:ctor()
    self:CreateUI()
end

function UIPassTroopPanel:CreateUI()
    local root = resMgr:createWidget("world/mainland/fly_troops_bg")
    self:initUI(root)
end

function UIPassTroopPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/fly_troops_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.head_layout = self.root.head_layout_export
    self.tbsize = self.root.tbsize_export
    self.itsize = self.root.itsize_export
    self.topNode = self.root.topNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.head_layout.FileNode_1.esc, function(sender, eventType) self:exitCall(sender, eventType) end)


    self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize(),self.topNode)
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIPassTroopItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self:addChild(self.tableView)
    
end

function UIPassTroopPanel:setLandIndex(index)
    
    self.index = index
end

function UIPassTroopPanel:initEventListener()
    local refershCall = function()

        self:setData()
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,refershCall)
end


function UIPassTroopPanel:getIndex()
    
    return self.index
end

function UIPassTroopPanel:onEnter()
   
   self:setData()
   self:initEventListener()
end

function UIPassTroopPanel:setData()
   
   self.tableView:setData(global.troopData:getOwnTroopsByCityId(global.g_worldview.worldPanel.chooseCityId))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPassTroopPanel:exitCall()
    
    global.panelMgr:closePanel("UIPassTroopPanel")
end

--CALLBACKS_FUNCS_END

return UIPassTroopPanel

--endregion
