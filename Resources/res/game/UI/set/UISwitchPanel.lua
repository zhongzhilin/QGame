--region UISwitchPanel.lua
--Author : zzl
--Date   : 2018/03/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UISwitchPanel  = class("UISwitchPanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UISwithCell = require("game.UI.set.UISwithCell")

function UISwitchPanel:ctor()
    self:CreateUI()
end

function UISwitchPanel:CreateUI()
    local root = resMgr:createWidget("settings/gift_set")
    self:initUI(root)
end

function UISwitchPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/gift_set")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_16_export
    self.TimeNode = self.root.TimeNode_export
    self.TimeNode = UISetTIme.new()
    uiMgr:configNestClass(self.TimeNode, self.root.TimeNode_export)
    self.table_content = self.root.table_content_export
    self.table_add_node = self.root.table_add_node_export
    self.top_node = self.root.top_node_export
    self.item_content = self.root.item_content_export
    self.bottom_node = self.root.bottom_node_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
            :setSize(self.table_content:getContentSize(), self.top_node, self.bottom_node)-- 设置大小， scrollview滑动区域（定位置， 低位置）
            :setCellSize(self.item_content:getContentSize()) -- 每个小intem 的大小
            :setCellTemplate(UISwithCell) -- 回调函数
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
            :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
            :setColumn(1)
    self.table_add_node:addChild(self.tableView)

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISwitchPanel:exit_call(sender, eventType)

    global.panelMgr:closePanel("UISwitchPanel")
end

function UISwitchPanel:onEnter() 

end

function UISwitchPanel:setData(swithctype)

    local data ={} 

    self.tableView:setData({})

    if swithctype == 1 then 

        self.panel_name:setString(gls(11136))

        global.privateData = { 

            {id =1 , title = 11137 ,des= 11139  , status = true } ,

            {id =2 , title = 11138 ,des =  11140 , status = true} ,
        }

        global.PushInfoAPI:getConfigureList(2,0,function(ret,msg)

            for key ,v in pairs(msg.tagPushInfo or {}) do 

                global.privateData[key].status = v.lstate == 1 
            end 

            dump(global.privateData ,"privateData'")

            self.tableView:setData(global.privateData)
        end)
    end     

end 


--CALLBACKS_FUNCS_END

return UISwitchPanel

--endregion
