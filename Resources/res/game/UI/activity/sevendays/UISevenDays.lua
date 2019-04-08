--region UISevenDays.lua
--Author : anlitop
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDaysItem = require("game.UI.activity.sevendays.UIDaysItem")
local UIBigDaysItem = require("game.UI.activity.sevendays.UIBigDaysItem")
--REQUIRE_CLASS_END

local UISevenDays  = class("UISevenDays", function() return gdisplay.newWidget() end )
local UISevenDaysItemCell = require("game.UI.activity.cell.UISevenDaysItemCell")


local UITableView =  require("game.UI.common.UITableView")

function UISevenDays:ctor()
    self:CreateUI()
end

function UISevenDays:CreateUI()
    local root = resMgr:createWidget("activity/sevendays/sevendays_bg")
    self:initUI(root)
end

function UISevenDays:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/sevendays/sevendays_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.bg.title_export
    self.rest_time = self.root.bg.gift_name_bg.rest_time_mlan_12_export
    self.over_time = self.root.bg.gift_name_bg.over_time_export
    self.FileNode_1 = UIDaysItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.bg.FileNode_1)
    self.FileNode_2 = UIDaysItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.bg.FileNode_2)
    self.FileNode_3 = UIDaysItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.bg.FileNode_3)
    self.FileNode_4 = UIDaysItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.bg.FileNode_4)
    self.FileNode_5 = UIDaysItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.bg.FileNode_5)
    self.FileNode_6 = UIDaysItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.bg.FileNode_6)
    self.FileNode_7 = UIBigDaysItem.new()
    uiMgr:configNestClass(self.FileNode_7, self.root.bg.FileNode_7)
    self.dayNode = self.root.bg.dayNode_export
    self.day_text = self.root.bg.dayNode_export.day_text_export
    self.tb_item_content = self.root.tb_item_content_export
    self.tb_content = self.root.tb_content_export
    self.tb_bottom = self.root.tb_bottom_export
    self.tb_top = self.root.tb_top_export
    self.tb_add = self.root.tb_add_export

    uiMgr:addWidgetTouchHandler(self.root.bg.title_export.intro_btn, function(sender, eventType) self:info_click(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) 
        global.panelMgr:closePanel("UISevenDays" )
    end)


    self.tableView = UITableView.new()
    :setSize(self.tb_content:getContentSize(), self.tb_top, self.tb_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
    :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
    :setCellTemplate(UISevenDaysItemCell) -- 回调函数
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

        if self.test then 
            self:test(false)
        end 

        self.testA = gscheduler.scheduleGlobal(function()
            
            if self.test then 
                self:test(true)
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


function UISevenDays:info_click(sender, eventType)
        
    self:cleanSchedule()

    local data =global.luaCfg:get_introduction_by(21)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)

end
--CALLBACKS_FUNCS_END

function UISevenDays:initData()

    self:initTouch()

    local dayCall = function () 

        for i =1 , 7  do 

            local data = {} 

            data.now_day = self.now_day or  0

            data.index =  i

            data.finish = self:checkFinsh(i) 

            local node =  self["FileNode_"..i]

            node:setData(data ,function () 

                gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE , i)

            end)

        end
    end 


    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE,function(event , index)
        if index and index == -1 then 
        else 
            dayCall()
            self:updateSelect(index or self.index ) --活动 通知可能报错 /// 
        end 
    end)

    dayCall()

    self:addEventListener(global.gameEvent.EV_ON_PANEL_CLOSE,function(event , name)
        if  global.panelMgr:getTopPanel() == self and name ~= "UIItemRewardPanel" then 
            if self and self.updateData then 
                self.old = true 
                self:updateData()  
            end          
        end 
    end)                

end



function UISevenDays:updateData()

    global.ActivityAPI:SevenActivityReq(function(msg)
        dump(msg , "msg=>>>>>>>")
        if self.setMsg then 
            self:setMsg(msg)
        end 
    end)

end 

function UISevenDays:setMsg(msg)

    if not msg then 
        return 
    end 

    self.now_day = msg.lDay

    self.tagTask = msg.tagTask

     global.severDataRequestComplete = true 

    gevent:call(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE , self.index or self.now_day)
end 


function  UISevenDays:checkFinsh(day)

    local state = true 

    local temp  = {} 

    local  target  =  global.luaCfg:get_seven_day_by(day)
    
    for i = 1 , target.max do

        local id = target["target"..i]

        table.insert(temp , id)
    end


    if not self.tagTask then 

        return  false 
    end 


    for _ ,v in pairs(self.tagTask or {}) do 

        for _ ,vv in pairs(temp ) do 

            if v.lID ==  vv and  v.lState ~= 2 then  

                state = false
            
                return state 

            end     
        end 

    end 


    return state 
end 


function UISevenDays:updateSelect(index) 

    self.tableView:stopScrolling()
    
    self.index = index or self.index 

    index  = index  or  self.index 

    global.UISevenDaysCell = {} 

    local str = string.format(global.luaCfg:get_local_string(10352), index)

    self.day_text:setString(str)

    local  target  =  global.luaCfg:get_seven_day_by(index) or {}

    local temp = {}

    local getServerData = function(taskId) 

        for _ , v in pairs( self.tagTask or {} )  do

            if v.lID  == taskId then 

                return v 
            end 
        end 

    end

    for i = 1, target.max or 0 do

        local data=  {}
        data.id     =  target["target"..i]
        data.reward =  target["reward"..i]
        data.type   = target["go"..i.."Type"]
        data.target = target["go"..i.."Target"]
        data.day    =  index 
        data.now_day = self.now_day
        data.bg =target["ui"..i]

        local  serverdata = getServerData(data.id)

        if serverdata then 

            data.state = serverdata.lState 
            data.now = serverdata.lProgress

        else

            data.state =  0 
            data.now = 0

        end  

        data.serverdata = serverdata

        data.index = i 

        data.tips_panel = self


        table.insert(temp , data)
    end 
    
    self.tableView:setData( temp , self.old)

    self.old = false 

end 

function UISevenDays:setData(data)



    self:cleanTimer()

    self.data = data 

    global.severDataRequestComplete = false

    if not self.timer then 
        self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTime), 1)
    end

    self:updateOverTime()

     self.now_day = self:getNowDay(self.data.serverdata.lEndTime - global.dataMgr:getServerTime())

     print(  self.now_day,"  self.now_day")

     if not self.now_day or  self.now_day  <= 0 then self.now_day  =1  end 
     if self.now_day  > 7  then self.now_day  =7   end 

    self:initData()

    self:updateData()

end


function UISevenDays:getNowDay(time)

    local dayTime =  time - time % (24*60*60) -- 余数

    local remnantTime = time % (24*60*60)

    local day  = math.floor( dayTime / (24*60*60) )

    return 7 - day 
end 

function UISevenDays:getTimeStr(time)

    local str =  nil 

    local dayTime =  time - time % (24*60*60) -- 余数

    local remnantTime = time % (24*60*60)

    local day  = dayTime / (24*60*60)

    if day >= 1 then 
        
         -- str =global. luaCfg:get_local_string(10675,day, global.funcGame.formatTimeToHMS(remnantTime))
        str = global.funcGame.formatTimeToHMS(remnantTime)

    else 
        
        str = global.funcGame.formatTimeToHMS(remnantTime)
    end 

    return  str 
end 


function UISevenDays:updateOverTime()

    local time =  -1 

    if self.data.serverdata.lStatus == 1 then  -- 已开启    

        time = self.data.serverdata.lEndTime - global.dataMgr:getServerTime()
    end 
    
    if time >=  0 then 

        self.over_time:setString(self:getTimeStr(time))

    else 

        self.over_time:setString("00:00:00")

        self:cleanTimer()

        global.panelMgr:closePanel("UISevenDays" )
        
    end 

    -- global.tools:adjustNodeMiddle(self.over_time ,self.rest_time)
end 


function UISevenDays:cleanTimer()

   if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end


    if self.timer2 then 


        gscheduler.unscheduleGlobal(self.timer2)

        self.timer2 = nil
    end 

end 

function UISevenDays:onExit()


    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

    self:cleanSchedule()

    self:cleanTimer()

    self:ClearEventListener()

    self.index =   nil

    self.tableView:setData({})

    if self.exitCall_ then 
        self.exitCall_()
        self.exitCall_ = nil 
    end 

end 

function UISevenDays:setExitCall(call)

    self.exitCall_ = call

end 


function UISevenDays:initTouch()
    --添加监听  
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

function UISevenDays:onTouchMoved(touch, event)

    if prohibit_slide == 1 then return  end 

    local y =  math.abs((self.y - touch:getLocation().y)) > moveMax_y
    local x =  math.abs((self.x - touch:getLocation().x)) > moveMax_x
    
    if y   then 

        prohibit_slide = 1


        for _ ,v in pairs(global.UISevenDaysCell or {} ) do 

            if v.setTBTouchEable then 

                v:setTBTouchEable(false)
            end 

        end 

        -- self:test()
        return 
    end 

    if x and  not self.isScring then 

        self.tableView:setTouchEnabled(false)

        prohibit_slide = 1 
    end 

end

    
function UISevenDays:test(state)

    for _ ,v in pairs(global.UISevenDaysCell or {} ) do 
        
        if v.setTBTouchEable then 

            v:setTBTouchEable(state)
        end 
    end 
end 


function UISevenDays:onTouchBegan(touch, event)

    if self.isScring then 
        return 
     end 


    prohibit_slide =  0 

     -- self.isScring = false 

    self:cleanSchedule()
    
    if  self.testtouc == true  then 
        self.testtouc  = false 
        return 
    end 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 
    return true
end

function UISevenDays:onTouchEnded(touch, event)

    self:cleanSchedule()

    -- self.scheduleID = global.delayCallFunc(function()
    --     self.testtouc = true 
    --     -- print("触发模拟点击/。。。。。。。。。。。")
    --     -- CCHgame:sendTouch(cc.p(self.tb_top:getPositionX(),self.tb_top:getPositionX()-10))
    --     self.tableView:stopScrolling()

    -- end,0,0.3)    

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    for _ ,v in pairs(global.UISevenDaysCell or {} ) do 

        if v.setTBTouchEable then 

            v:setTBTouchEable(true)
        end 
    end 

end
    

function UISevenDays:onTouchCancel()

    self:onTouchEnded()
end 


function UISevenDays:cleanSchedule()

    if self.scheduleID then 
        gscheduler.unscheduleGlobal(self.scheduleID)
    end 

end 
 

function UISevenDays:ClearEventListener()
        
    if self.touchEventListener  then 
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener  = nil
    end
end 




return UISevenDays

--endregion
