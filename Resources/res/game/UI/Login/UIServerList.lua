--region UIServerList.lua
--Author : yyt
--Date   : 2016/08/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIServerList  = class("UIServerList", function() return gdisplay.newWidget() end )
local UIServerListCell = require("game.UI.Login.UIServerListCell")
local UITableView = require("game.UI.common.UITableView")

function UIServerList:ctor()
    self:CreateUI()
end

function UIServerList:CreateUI()
    local root = resMgr:createWidget("login/server_2rd")
    self:initUI(root)
end

function UIServerList:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/server_2rd")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.listPanel = self.root.Node_export.listPanel_export
    self.item = self.root.Node_export.listPanel_export.item_export
    self.nodePosition = self.root.Node_export.nodePosition_export
    self.bottom = self.root.Node_export.bottom_export
    self.table_node = self.root.Node_export.table_node_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.listPanel:getContentSize(), self.nodePosition,self.bottom)
        :setCellSize(self.item:getContentSize())
        :setCellTemplate(UIServerListCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.table_node:addChild(self.tableView)

end

function UIServerList:registerTouchListener()
    local  listener = cc.EventListenerTouchOneByOne:create()

    local function touchBegan(touch, event)
       return true
    end

    local function touchMoved(touch, event)
    end

    local function touchEnded(touch, event)
        self:exit_call()
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.touch)
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIServerList:setData(data)
    -- body
    
    self.tableView:setData(data)
end

function UIServerList:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIServerList")
end
--CALLBACKS_FUNCS_END

return UIServerList

--endregion
