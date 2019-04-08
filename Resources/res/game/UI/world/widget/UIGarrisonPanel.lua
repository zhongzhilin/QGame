--region UIGarrisonPanel.lua
--Author : yyt
--Date   : 2016/11/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIGarrisonItemCell = require("game.UI.world.widget.UIGarrisonItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonPanel  = class("UIGarrisonPanel", function() return gdisplay.newWidget() end )

function UIGarrisonPanel:ctor()
    self:CreateUI()
end

function UIGarrisonPanel:CreateUI()
    local root = resMgr:createWidget("world/info/garrison_bj")
    self:initUI(root)
end

function UIGarrisonPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/garrison_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.titleNode = self.root.titleNode_export
    self.topNode = self.root.topNode_export
    self.itemSize = self.root.itemSize_export
    self.tableSize = self.root.tableSize_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tableSize:getContentSize(),self.topNode)
        :setCellSize(self.itemSize:getContentSize())
        :setCellTemplate(UIGarrisonItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self:addChild(self.tableView)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGarrisonPanel:onEnter()
    
    local refershCall = function()
        self:refershTroopData()
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,refershCall)
end

function UIGarrisonPanel:setData(cityId, data)
    
    data = data or {}

    self.cityId = cityId
    self.tableView:setData(self:sortGarrTroop(data))
end

function UIGarrisonPanel:refershTroopData()
    
    global.worldApi:villageTroop(self.cityId, function(msg)
        
        --if  msg.tgTroop and self:checkMyTroop(msg.tgTroop) then
        self:setData(self.cityId, msg.tgTroop or {})
        -- else
        --     self.tableView:setData({})
        --     global.panelMgr:closePanel("UIGarrisonPanel") 
        -- end
    end)
end

function UIGarrisonPanel:checkMyTroop(data)
    
    local userId = global.userData:getUserId()
    for _,v in pairs(data) do
        if userId == v.lUserID and global.troopData:checkTroop(v) then
            return true
        end
    end
    return false
end

function UIGarrisonPanel:sortGarrTroop(data)
    
    local m_garrData = {}
    local m_useId = global.userData:getUserId()
    for _,v in pairs(data) do
        if m_useId == v.lUserID then
            table.insert(m_garrData, v)
        end
    end
    for _,v in pairs(data) do
        if m_useId ~= v.lUserID then
            table.insert(m_garrData, v)
        end
    end
    return m_garrData
end

function UIGarrisonPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIGarrisonPanel")  
    
end

--CALLBACKS_FUNCS_END

return UIGarrisonPanel

--endregion
