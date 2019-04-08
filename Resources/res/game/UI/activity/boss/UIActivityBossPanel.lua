--region UIActivityBossPanel.lua
--Author : zzl
--Date   : 2017/12/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIActivityBossItem = require("game.UI.activity.boss.UIActivityBossItem")
--REQUIRE_CLASS_END

local UIActivityBossPanel  = class("UIActivityBossPanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIKillItemCell = require("game.UI.activity.cell.UIKillItemCell")
local luaCfg = global.luaCfg

function UIActivityBossPanel:ctor()
    self:CreateUI()
end

function UIActivityBossPanel:CreateUI()
    local root = resMgr:createWidget("activity/activity_world_boss/activity_world_boss_bj")
    self:initUI(root)
end

function UIActivityBossPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_world_boss/activity_world_boss_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.banner = self.root.Node_export.bg.banner_export
    self.act_name = self.root.Node_export.bg.act_name_export
    self.time_node = self.root.Node_export.bg.time_bg.time_node_mlan_6_export
    self.time = self.root.Node_export.bg.time_bg.time_node_mlan_6_export.time_export
    self.rank = self.root.Node_export.bg.time_bg.time_node_mlan_4.rank_export
    self.colse_bt = self.root.Node_export.colse_bt_export
    self.colse_bt = CloseBtn.new()
    uiMgr:configNestClass(self.colse_bt, self.root.Node_export.colse_bt_export)
    self.intro_btn = self.root.Node_export.intro_btn_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.tb_top = self.root.Node_export.tb_top_export
    self.tb_add = self.root.Node_export.tb_add_export
    self.btn_node = self.root.Node_export.btn_node_export
    self.FileNode_1 = self.root.Node_export.FileNode_1_export
    self.FileNode_1 = UIActivityBossItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1_export)
    self.FileNode_2 = self.root.Node_export.FileNode_2_export
    self.FileNode_2 = UIActivityBossItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.Node_export.FileNode_2_export)
    self.FileNode_3 = self.root.Node_export.FileNode_3_export
    self.FileNode_3 = UIActivityBossItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.FileNode_3_export)
    self.FileNode_4 = self.root.Node_export.FileNode_4_export
    self.FileNode_4 = UIActivityBossItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.Node_export.FileNode_4_export)
    self.FileNode_5 = self.root.Node_export.FileNode_5_export
    self.FileNode_5 = UIActivityBossItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.Node_export.FileNode_5_export)
    self.FileNode_6 = self.root.Node_export.FileNode_6_export
    self.FileNode_6 = UIActivityBossItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.Node_export.FileNode_6_export)
    self.tb_item_content = self.root.tb_item_content_export
    self.tb_content = self.root.tb_content_export

    uiMgr:addWidgetTouchHandler(self.root.touch, function(sender, eventType) self:close_panel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END

    self.colse_bt:setData(function()
        self:close_panel(0)
    end)

    self.tableView = UITableView.new()
    :setSize(self.tb_content:getContentSize(), self.tb_top, self.tb_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
    :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
    :setCellTemplate(UIKillItemCell) -- 
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

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIActivityBossPanel:onEnter()

    for  i =1 , 6 do 
        self["FileNode_"..i]:setData(i , function () 
            self:switchLevel(i)
        end)
    end 

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE , function () 
        if self.data then 
            self:setData(self.data)
        end 
    end)
end 

-- rint] -         1 = {
-- [LUA-print] -             "lActId"   = 26001
-- [LUA-print] -             "lBngTime" = 1514531700
-- [LUA-print] -             "lEndTime" = 1514532900
-- [LUA-print] -             "lParam"   = 1
-- [LUA-print] -             "lParam2"  = 0
-- [LUA-print] -             "lStatus"  = 1
-- [LUA-print] -         }


function UIActivityBossPanel:switchLevel(level)

    local drop_data =  global.ActivityData:getRankRewardListByActivityID(self.data.activity_id  , level)

    for  i =1 , 6 do 
        self["FileNode_"..i].noe:setVisible( level == i )
    end 

    for _ ,v in pairs(drop_data) do 

        v.tips_panel = self
    end 

    table.sort( drop_data , function (A , B) return A.rank_min < B.rank_min end )


    self.tableView:setData(drop_data)

end 


function UIActivityBossPanel:setData(activity)

    self.data = activity

    self.banner:loadTexture(self.data.banner, ccui.TextureResType.plistType)

    self.rank:setString("0")
    self.time_node:setVisible(false)
    self.act_name:setString(self.data.name)

    global.tools:adjustNodePosForFather(self.rank:getParent() , self.rank)

    global.ActivityAPI:ActivityListReq({self.data.activity_id},function(ret,msg)

        if msg and msg.tagAct then 
            if not tolua.isnull(self.rank) then
                self.rank:setString(msg.tagAct[1].lParam2 or 0 )
            end
            self.lv =  msg.tagAct[1].lParam
            self:switchLevel(self.lv)
        end 

    end)

    if self.lv then 
        self:switchLevel(self.lv)
    end 

    if self.data.serverdata.lStatus == 1 then 

        self.time_node:setString(global.luaCfg:get_local_string(11034))

        self.time_node:setVisible(true)

    elseif self.data.serverdata.lStatus == 0 then  

        self.time_node:setString(global.luaCfg:get_local_string(11033))

        self.time_node:setVisible(true)
    end 

    self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTime), 1)
    self:updateOverTime()

    self:initTouch()

    self:initBtn()
end 

function UIActivityBossPanel:initBtn()

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

            local call = global.ActivityData:getCallBack("UIActivityBossPanel" , panel_index , self.data )
            if call then 
                call(self.data.activity_id)
            end 
        end)
    end
end


function UIActivityBossPanel:updateOverTime(time)

    if not self.data then 
        if self.cleanTimer then 
            self:cleanTimer()
        end 

        return 
    end 

    local time = self.data.serverdata.lEndTime - global.dataMgr:getServerTime()

    if  self.data.serverdata.lStatus ==  0 then

        time = self.data.serverdata.lBngTime - global.dataMgr:getServerTime()

    end 


    if time >  0 then 

        self.time:setString(global.vipBuffEffectData:getDayTime(time))
        global.tools:adjustNodePosForFather(self.time:getParent(),self.time)

    else 

        self.time_node:setVisible(false)
        self:cleanTimer()

    end 

end 

function UIActivityBossPanel:onExit()

    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

    self:cleanTimer()

end 

function UIActivityBossPanel:cleanTimer()

   if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end
end 


function UIActivityBossPanel:close_panel(sender, eventType)

    global.panelMgr:closePanel("UIActivityBossPanel")
end


function UIActivityBossPanel:initTouch()
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

function UIActivityBossPanel:onTouchMoved(touch, event)

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

    
function UIActivityBossPanel:setCellTouch(state)

    for _ ,v in pairs(self.tableView:getCells()) do 
        
        if v.tv_target and  v.tv_target.item  and v.tv_target.item.setTBTouchEable then 

            v.tv_target.item:setTBTouchEable(state)
        end 
    end 
end 


function UIActivityBossPanel:onTouchBegan(touch, event)

    if self.isScring then 
        return 
     end 

    prohibit_slide =  0 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 

    return true
end

function UIActivityBossPanel:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    self:setCellTouch(true)

end


function UIActivityBossPanel:onTouchCancel()

    self:onTouchEnded()
end 


function UIActivityBossPanel:infoCall(sender, eventType)
     local data =global.luaCfg:get_introduction_by(tonumber(self.data.desc))

    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end
--CALLBACKS_FUNCS_END

--CALLBACKS_FUNCS_END

return UIActivityBossPanel

--endregion
