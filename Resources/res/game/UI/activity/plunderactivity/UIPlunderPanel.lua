--region UIPlunderPanel.lua
--Author : anlitop
--Date   : 2017/09/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIActivityPointNode = require("game.UI.activity.Node.UIActivityPointNode")
--REQUIRE_CLASS_END

local UIPlunderPanel  = class("UIPlunderPanel", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIPlunderItemCell = require("game.UI.activity.cell.UIPlunderItemCell")
local luaCfg = global.luaCfg

function UIPlunderPanel:ctor()
    self:CreateUI()
end

function UIPlunderPanel:CreateUI()
    local root = resMgr:createWidget("activity/exp_activity/point_rank_panel")
    self:initUI(root)
end

function UIPlunderPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/exp_activity/point_rank_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_3 = self.root.Node_export.FileNode_3_export
    self.FileNode_3 = UIActivityPointNode.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.FileNode_3_export)
    self.rank_text = self.root.Node_export.Node_2.text_node.rank_text_mlan_6_export
    self.tb_item_content = self.root.Node_export.tb_item_content_export
    self.tb_content = self.root.Node_export.tb_content_export
    self.tb_top = self.root.Node_export.tb_top_export
    self.tb_add = self.root.Node_export.tb_add_export
    self.btn_node = self.root.Node_export.btn_node_export
    self.intro_btn = self.root.Node_export.intro_btn_export
    self.close_bt = self.root.Node_export.close_bt_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.leagueReward = self.root.Node_export.leagueReward_mlan_56_export
    self.name_bg = self.root.Node_export.name_bg_export
    self.act_name = self.root.Node_export.name_bg_export.act_name_export

    uiMgr:addWidgetTouchHandler(self.root.touch, function(sender, eventType) self:close_panel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.close_bt, function(sender, eventType) self:bt_close_panel(sender, eventType) end)
--EXPORT_NODE_END


  self.tableView = UITableView.new()
    :setSize(self.tb_content:getContentSize(), self.tb_top, self.tb_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
    :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
    :setCellTemplate(UIPlunderItemCell) -- 
    :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.isScring = false 
    self.tableView:registerScriptHandler(handler(self, function()

        self.isScring = true 

        if self.testA then 
            gscheduler.unscheduleGlobal(self.testA)
        end 

        if self.setCellTouch then 
            self:setCellTouch(false)
        end 
        self.testA = gscheduler.scheduleGlobal(function()
            
            if self.setCellTouch then 
                self:setCellTouch(true)
            end
            self.isScring = false 

            if self.testA then 
                gscheduler.unscheduleGlobal(self.testA)
            end
        end , 0.2)

    end), cc.SCROLLVIEW_SCRIPT_SCROLL)


    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)

    local z =  self.FileNode_3:getLocalZOrder()

    self.intro_btn:setLocalZOrder(z+ 1 )
    self.close_bt:setLocalZOrder(z+ 2 )

    self.name_bg:setLocalZOrder(z + 3 )

    self.leagueReward:setLocalZOrder(z+4)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN



function UIPlunderPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE , function () 
        if self.data then 
            self:setData(self.data)
        end 
    end)
    
end 

local leagueActivity = {
    11001 , 
}

function UIPlunderPanel:setData(data) 

    self.data = data 

    self.leagueReward:setVisible(table.hasval(leagueActivity ,self.data.activity_id))

    self.act_name:setString(self.data.name)

    local point_data = global.ActivityData:getActivityBoxData(self.data.activity_id)
    self.FileNode_3:setData(point_data)

    local drop_data =  global.ActivityData:getRankRewardByActivityID(self.data.activity_id)

    for _ ,v in pairs(drop_data) do 

        v.tips_panel = self
    end 

    table.sort( drop_data , function (A , B) return A.rank_min < B.rank_min end )

    self.tableView:setData(drop_data)

    self:initTouch()
    self:initBtn()
end 


function UIPlunderPanel:close_panel(sender, eventType)

    global.panelMgr:closePanel("UIPlunderPanel")

end

function UIPlunderPanel:infoCall(sender, eventType)

    
    local data =global.luaCfg:get_introduction_by(tonumber(self.data.desc))

    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)

end

function UIPlunderPanel:bt_close_panel(sender, eventType)

    global.panelMgr:closePanel("UIPlunderPanel")

end


function UIPlunderPanel:initBtn()

    local btnCount = #self.data.btn

    print(btnCount,"btnCount")

    local btnNode = resMgr:createWidget("activity/activity_btns/btn_" .. btnCount)
    self.btn_node:removeAllChildren()
    self.btn_node:addChild(btnNode)

    uiMgr:configUITree(btnNode)

    -- dump(self.data.btn)
    -- dump(btnNode)
    for index, panel_index in pairs(self.data.btn) do

        print(panel_index ,  "panel_index ////////")

        local btn = btnNode["btn_" .. index]

        local btn_item =luaCfg:get_btn_by(self.data.btn[index])

        btn.text:setString(btn_item.name)

        btn:loadTextures(btn_item.pic,btn_item.pic,nil,ccui.TextureResType.plistType)

        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType) 

            local call = global.ActivityData:getCallBack("UIPlunderPanel" , panel_index , self.data )
            if call then 
                call()
            end 
        end)
    end
end


function UIPlunderPanel:initTouch()
    local touchNode = cc.Node:create()
     self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end


local moveMax_x = 30
local moveMax_y = 30
local  prohibit_slide= 0 

function UIPlunderPanel:onTouchMoved(touch, event)

    if prohibit_slide == 1 then return  end 

    local y =  math.abs((self.y - touch:getLocation().y)) > moveMax_y
    local x =  math.abs((self.x - touch:getLocation().x)) > moveMax_x
    
    if  y  then 

        prohibit_slide = 1

        return 
    end 
    if x and  not self.isScring then 

        self.tableView:setTouchEnabled(false)

        prohibit_slide = 1 
    end 

end

    
function UIPlunderPanel:setCellTouch(state)

    for _ ,v in pairs(self.tableView:getCells()) do 
        
        if v.tv_target and  v.tv_target.item  and v.tv_target.item.setTBTouchEable then 

            v.tv_target.item:setTBTouchEable(state)
        end 
    end 
end 


function UIPlunderPanel:onTouchBegan(touch, event)

    if self.isScring then 
        return 
     end 

    prohibit_slide =  0 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 

    return true
end

function UIPlunderPanel:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    self:setCellTouch(true)

end

function UIPlunderPanel:onExit()

    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

end 

--CALLBACKS_FUNCS_END

return UIPlunderPanel

--endregion
