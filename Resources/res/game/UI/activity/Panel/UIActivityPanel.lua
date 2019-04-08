--region UIServerSwitchPanel.lua
--Author : anlitop
--Date   : 2017/04/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITitleList = require("game.UI.activity.Node.UITitleList")
 --REQUIRE_CLASS_END
local UIActivityPanel  = class("UIActivityPanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIActivityItemCell = require("game.UI.activity.cell.UIActivityItemCell")


function UIActivityPanel:ctor()
    self:CreateUI()
end

function UIActivityPanel:CreateUI()
    local root = resMgr:createWidget("activity/activity_main_ui")
    self:initUI(root)
end

function UIActivityPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_main_ui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_export
    self.tableview_content = self.root.tableview_content_export
    self.tableview_item = self.root.tableview_item_export
    self.tableview_top = self.root.tableview_top_export
    self.tableview_bootom = self.root.tableview_bootom_export
    self.tableview_add = self.root.tableview_add_export
    self.FileNode_3 = UITitleList.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.FileNode_3)

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end)
    self.tableView = UITableView.new()
            :setSize(self.tableview_content:getContentSize(), self.tableview_top, self.tableview_bootom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
            :setCellSize(self.tableview_item:getContentSize()) -- 每个小intem 的大小
            :setCellTemplate(UIActivityItemCell) -- 回调函数
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
            :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
            :setColumn(1)
    self.tableview_add:addChild(self.tableView)
end

-- //活动
-- message Activity
-- {
--     required int32      lActId  = 1;        //活动ID
--     required int32      lStatus = 2;        //活动状态 0:尚未开始  1：正在进行 8：等待发将  9：已经结束
--     required int32      lEndTime    = 3;        //结束时间
--     required int32      lBngTime    = 4;        //开始时间
--     optional int32      lParam  = 5;        //扩展字段
-- }

function UIActivityPanel:setData(activity_type,original)

    local  swithPanel = function() 

        self.activity_type = activity_type

        self.original = original

        self:reFreshActivity()
    end 

    swithPanel()

    self.FileNode_3:setData(global.luaCfg:activity_list())


end 



function UIActivityPanel:setGPSActivityId(gps_activity_id , notOpen)

    self.gps_activity_id = gps_activity_id
    self.notOpen =notOpen
end 


function UIActivityPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE,function()

        self:setData(self.activity_type,true)

    end)

    self.in_panel = true 
end

function UIActivityPanel:onExit()


    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

    
    self.in_panel =  nil  

    self.notOpen = nil 

end 

function  UIActivityPanel:reFreshActivity()
    
    self.data = global.ActivityData:getCurrentActivityData(self.activity_type)

    if not self.data or  #self.data< 1  and  self.in_panel  then

        global.tipsMgr:showWarning("no_activity")

        -- global.panelMgr:closePanel("UIActivityPanel")
        self:updataUI()
    else 
        self:updataUI()
    end 
end 


function UIActivityPanel:updataUI()

    local  title = ""

    if  self.activity_type ==3 then  --大型

        title = global.luaCfg:get_localization_by(10547).value

    elseif  self.activity_type ==1 then  -- 每日

        title = global.luaCfg:get_localization_by(10546).value

    elseif  self.activity_type ==2 then -- 开服 

        title = global.luaCfg:get_localization_by(10548).value

    end

    self.panel_name:setString(title)

    local tb = {}

    for _,v in pairs(self.data) do

        table.insert(tb,v)
    end
    -- table.sort(tb,function (A,B)
    --     return A.activity_id < B.activity_id
    -- end)

    self.tableView:setData(tb,self.original)

    if   self.gps_activity_id  then 
        self:gps(self.gps_activity_id)
        self.gps_activity_id  = nil 
    end 
end 

function UIActivityPanel:exit_call(sender, eventType) 

    self.original = false 

    self.tableView:setData({})

    self.in_panel = nil  

    self.gps_activity_id = nil
    

    global.panelMgr:closePanel("UIActivityPanel")

end 

function UIActivityPanel:gps(activity_id)

    for index , v  in pairs(self.data ) do 

        if v.activity_id == activity_id then 

            self.tableView:jumpToCellYByIdx(#self.data - index + 1, true)

            if not self.notOpen then 
                self:openDetailedPanel(activity_id)
            end 
            return
        end 
    end
end 

function UIActivityPanel:openDetailedPanel(activity_id)

    for _ , v in pairs(self.tableView:getCells()) do 

        if v.tv_target.data.activity_id == activity_id then 

            v.tv_target:onClick(true)

            return
        end 
    end 

end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIActivityPanel

--endregion
