--region UIPushMessgePanel.lua
--Author : anlitop
--Date   : 2017/03/31
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UIPushMessgePanel  = class("UIPushMessgePanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIPushMessgeItemCell = require("game.UI.set.UIPushMessgeItemCell")

function UIPushMessgePanel:ctor()
    self:CreateUI()
end

function UIPushMessgePanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_message")
    self:initUI(root)
end

function UIPushMessgePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_message")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.TimeNode = self.root.TimeNode_export
    self.TimeNode = UISetTIme.new()
    uiMgr:configNestClass(self.TimeNode, self.root.TimeNode_export)
    self.table_content = self.root.table_content_export
    self.table_add_node = self.root.table_add_node_export
    self.top_node = self.root.top_node_export
    self.item_content = self.root.item_content_export
    self.bottom_node = self.root.bottom_node_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

self.tableView = UITableView.new()
        :setSize(self.table_content:getContentSize(), self.top_node, self.bottom_node)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.item_content:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIPushMessgeItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(1)
self.table_add_node:addChild(self.tableView)
end

function UIPushMessgePanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIPushMessgePanel")
end

function UIPushMessgePanel:onEnter() 
    -- self:setData()
    --self:getConfigureData()
    --self:updateStatus(global.PushConfigData:getConfigData())
      self.pushdata = global.PushConfigData:getConfigData()
      self:updateUI()
end
-- message PushInfo
-- {
--     required int32      lType = 1;
--     required int32      lstate = 2;//0表示关  1 表示开启
-- }
function UIPushMessgePanel:getConfigureData()
    global.PushInfoAPI:getConfigureList(0,0,function(ret,msg)
        if ret.retcode ==0 then 
            if msg then 
                self:updateStatus(msg.tagPushInfo)
            end 
        end 
    end)
end


function UIPushMessgePanel:updateStatus(msg)
    msg = msg or {}
    for _  ,v  in pairs(msg)do 
        for _, vv in pairs(self.pushdata) do
            if vv.id == v.lType then
                vv.status = (v.lstate==1)
                break
            end 
        end 
    end
    self:updateUI()
end 

function UIPushMessgePanel:setData()
    self.pushdata =  global.luaCfg:push_type()
    for _, v in pairs(self.pushdata) do
        if v.status==nil then 
          v.status = true
        end 
    end
end


function  UIPushMessgePanel:updateUI()
    self.tableView:setData(self.pushdata)
end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIPushMessgePanel

--endregion
