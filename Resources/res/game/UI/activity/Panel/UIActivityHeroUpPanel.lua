--region UIActivityHeroUpPanel.lua
--Author : yyt
--Date   : 2018/02/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIActivityHeroUpPanel  = class("UIActivityHeroUpPanel", function() return gdisplay.newWidget() end )
local UIActivityHeroUpCell = require("game.UI.activity.cell.UIActivityHeroUpCell")
local UITableView =  require("game.UI.common.UITableView")

function UIActivityHeroUpPanel:ctor()
    self:CreateUI()
end

function UIActivityHeroUpPanel:CreateUI()
    local root = resMgr:createWidget("activity/upgradeHero_activity_panel")
    self:initUI(root)
end

function UIActivityHeroUpPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/upgradeHero_activity_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = CloseBtn.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.bg.FileNode_1)
    self.banner = self.root.Node_export.bg.banner_export
    self.tb_item_content = self.root.Node_export.tb_item_content_export
    self.tb_content = self.root.Node_export.tb_content_export
    self.tb_top = self.root.Node_export.tb_top_export
    self.tb_add = self.root.Node_export.tb_add_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.time_node = self.root.Node_export.time_node_mlan_12_export
    self.time = self.root.Node_export.time_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END

    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)

    self.tableView = UITableView.new()
        :setSize(self.tb_content:getContentSize(), self.tb_top, self.tb_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIActivityHeroUpCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.FileNode_1:setData(function ()
        global.panelMgr:closePanel("UIActivityHeroUpPanel")
    end)


    self.isScring = false 
    self.tableView:registerScriptHandler(handler(self, function()

        self.isScring = true 
        if self.testA then 
            gscheduler.unscheduleGlobal(self.testA)
        end 

        self.testA = global.delayCallFunc(function()
            self.isScring = false 
        end,0,0.2)  
    end), cc.SCROLLVIEW_SCRIPT_SCROLL)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIActivityHeroUpPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE , function () 
        if self.data then 
            self:setData(self.data)
        end 
    end)
    
    self.tableView:setData({})

end 

function UIActivityHeroUpPanel:reFresh()
    if self.data then 
        self:setData(self.data)
    end 
end

function UIActivityHeroUpPanel:setData(data)

    global.netRpc:delHeartCall(self)

    local now =  global.dataMgr:getServerTime()
    local born =  global.dailyTaskData:getBornTime()
    local configtime = self:getAllTime()
    local endtime = 0
    for _ ,v in pairs(configtime) do 
        if (v.start_time-1)*86400+ born <= now and  now < (v.end_time * 86400 + born) then 
            endtime = (v.end_time * 86400 + born)
        end 
    end 

    global.netRpc:addHeartCall(function () 
        local now =  global.dataMgr:getServerTime()
        local time = endtime - now
        if time == 0 then 
            if self.setData and global.panelMgr:isPanelOpened("UIActivityHeroUpPanel") then 
                self:setData(self.data)
            end 
            return 
        end 
        self.time:setString(global.vipBuffEffectData:getDayTime(time))
    end, self)

    global.UIActivityHeroUpPanelCell = {} 
    self:initTouch()
    self.data = data
    self.tableView:setData(self:getActivityData())
end

function UIActivityHeroUpPanel:getAllTime()

    local time = {}
    local configData = luaCfg:legend_hero_act()
    for k,v in pairs(configData) do
        local isExits = false 
        for k,vv in pairs(time) do --检测是否存在
            if vv.start_time == v.start_time and vv.end_time ==v.end_time then 
                isExits = true
            end 
        end
        if not isExits then 
            table.insert(time , {start_time =v.start_time  ,  end_time= v.end_time})   
        end 
    end
    table.sort(time , function (A ,B) return A.start_time < B.start_time end )
    return time 
end 


function UIActivityHeroUpPanel:getActivityData()

    local checkTime = function (hero) 
        local born =  global.dailyTaskData:getBornTime()
        local now =  global.dataMgr:getServerTime()
        return (hero.start_time-1)*86400+ born <= now and  now < (hero.end_time * 86400 + born)
    end 

    local heroList = {}
    local configData = luaCfg:legend_hero_act()
    for k,v in pairs(configData) do
        if (v.class == 3 or v.class == 5) and checkTime(v) then
            table.insert(heroList, v)
        end
    end

    local getConfigAct = function (heroId, class)
        -- body
        for k,v in pairs(configData) do
            if v.class == class and v.heroId == heroId then
                return v
            end
        end
    end

    local temp = {}
    for k,v in pairs(heroList) do
        local mineHero = global.heroData:getGotHeroDataById(v.heroId)
        if mineHero then
            local curHeroClass = mineHero.serverData.lStar
            -- local showClass = curHeroClass < 3 and 3 or 5
            local showClass = v.class

            -- 如果当前3阶没有领取
            -- local tempClass3 = getConfigAct(v.heroId, 3)
            -- if showClass == 5 and global.ActivityData:getActHeroUpgrade(tempClass3.id) == 0 then
            --     showClass = 3
            -- end
            local config = clone(getConfigAct(v.heroId, showClass))           
            config.curHeroClass = curHeroClass
            config.tips_panel = self
            table.insert(temp, config)
        else
            local config = clone(getConfigAct(v.heroId, v.class))
            config.tips_panel = self
            table.insert(temp, config)
        end
    end
    table.sort(temp, function (s1, s2) return s1.order < s2.order end)
    return temp

end

function UIActivityHeroUpPanel:close_panel(sender, eventType)
    global.panelMgr:closePanel("UIActivityHeroUpPanel")
end


function UIActivityHeroUpPanel:initTouch()
    --添加监听  
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

local moveMax_x = 20
local moveMax_y = 30
local  prohibit_slide= 0 
function UIActivityHeroUpPanel:onTouchMoved(touch, event)

    if prohibit_slide == 1  then return  end 

    local y =  math.abs((self.y - touch:getLocation().y)) > moveMax_y
    local x =  math.abs((self.x - touch:getLocation().x)) > moveMax_x
    
    if y  then 
        prohibit_slide = 1
        for _ ,v in pairs(global.UIActivityHeroUpPanelCell or {} ) do 
            if v.setTBTouchEable then 
                v:setTBTouchEable(false)
            end 
        end 
        return 
    end 

    if x and  not self.isScring then 
        self.tableView:setTouchEnabled(false)
        prohibit_slide = 1 
    end 
end

function UIActivityHeroUpPanel:onTouchBegan(touch, event)

    if self.isScring then 
        return 
    end 
    prohibit_slide =  0 
    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 
    return true
end

function UIActivityHeroUpPanel:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    for _ ,v in pairs(global.UIActivityHeroUpPanelCell or {} ) do 
        if v.setTBTouchEable then 
            v:setTBTouchEable(true)
        end 
    end
end

function UIActivityHeroUpPanel:onTouchCancel()
    self.tableView:setTouchEnabled(true)
end 

function UIActivityHeroUpPanel:ClearEventListener()
        
    if self.touchEventListener  then 
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener  = nil
    end
end 

function UIActivityHeroUpPanel:onExit()

    global.netRpc:delHeartCall(self)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    self:ClearEventListener()

end 


--CALLBACKS_FUNCS_END

return UIActivityHeroUpPanel

--endregion
