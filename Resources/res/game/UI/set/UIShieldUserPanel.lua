--region UIShieldUserPanel.lua
--Author : yyt
--Date   : 2017/03/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UIShieldUserPanel  = class("UIShieldUserPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIShieldUserCell = require("game.UI.set.UIShieldUserCell")

function UIShieldUserPanel:ctor()
    self:CreateUI()
end

function UIShieldUserPanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_shieldUser")
    self:initUI(root)
end

function UIShieldUserPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_shieldUser")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.TimeNode = UISetTIme.new()
    uiMgr:configNestClass(self.TimeNode, self.root.TimeNode)
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.top = self.root.top_export
    self.table_node = self.root.table_node_export

--EXPORT_NODE_END
    
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.top)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIShieldUserCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

end

function UIShieldUserPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIShieldUserPanel:tableMove()
    self.isStartMove = true
end

function UIShieldUserPanel:onEnter()
    
    self.m_eventListenerCustomList = {}
    self.isStartMove = false
    self:refersh()

end

function UIShieldUserPanel:setData(data)
    
    self.tableView:setData(data)
end

function UIShieldUserPanel:refersh()
    
    -- 获取用户详细信息
    global.chatApi:getUserInfo(function(msg)
        
        self:setData(msg.tgInfo or {})
        
        -- 下载用户头像
        if msg.tgInfo then
            local data = {}
            for i,v in pairs(msg.tgInfo) do
                if v.szCustomIco ~= "" then
                    table.insert(data,v.szCustomIco)
                end
            end
            local storagePath = global.headData:downloadPngzips(data)
            table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
                -- body
                if self and not tolua.isnull(self.tableView) then
                    self.tableView:setData(self.tableView:getData(),true)
                end
            end))
        end
    end, global.chatData:getShield())
end

function UIShieldUserPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIShieldUserPanel")  
end

--CALLBACKS_FUNCS_END

return UIShieldUserPanel

--endregion
