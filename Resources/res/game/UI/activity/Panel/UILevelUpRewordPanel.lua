--region UILevelUpRewordPanel.lua
--Author : anlitop
--Date   : 2017/08/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UILevelUpRewordPanel  = class("UILevelUpRewordPanel", function() return gdisplay.newWidget() end )


local UITableView =  require("game.UI.common.UITableView")
local UIStrongRewardItemCell = require("game.UI.activity.cell.UIStrongRewardItemCell")


function UILevelUpRewordPanel:ctor()
    self:CreateUI()
end

function UILevelUpRewordPanel:CreateUI()
    local root = resMgr:createWidget("activity/upgrade_activity_panel")
    self:initUI(root)
end

function UILevelUpRewordPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/upgrade_activity_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = CloseBtn.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.bg.FileNode_1)
    self.bg_reward = self.root.Node_export.bg.bg_reward_mlan_20_export
    self.banner = self.root.Node_export.bg.banner_export
    self.schedule = self.root.Node_export.bg.time_bg.schedule_mlan_4.schedule_mlan_8_export
    self.time = self.root.Node_export.bg.time_bg.time_mlan_4.time_export
    self.tb_item_content = self.root.Node_export.tb_item_content_export
    self.introduce = self.root.Node_export.introduce_export
    self.tb_content = self.root.Node_export.tb_content_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.tb_top = self.root.Node_export.tb_top_export
    self.tb_add = self.root.Node_export.tb_add_export
    self.combat = self.root.Node_export.upgrade_mlan_2.combat_export
    self.reward = self.root.Node_export.get_mlan_2.reward_mlan_4_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END
    
    self.tips_node = cc.Node:create()

    self.root:addChild(self.tips_node)

    self.tableView = UITableView.new()
        :setSize(self.tb_content:getContentSize(), self.tb_top, self.tb_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIStrongRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(1)
    self.tb_add:addChild(self.tableView)


    self.FileNode_1:setData(function ()

        global.panelMgr:closePanel("UILevelUpRewordPanel")


    end )


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
    
    global.tools:adjustNodePosForFather(self.reward:getParent(),self.reward)



end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UILevelUpRewordPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE , function () 
        if self.data then 
            self:setData(self.data)
        end 
    end)
    
    self.tableView:setData({})
end 

function UILevelUpRewordPanel:referSchedule(level)

    if level == 0 then return end

    local reword = {}
    local count  = 0 

    for index, v in ipairs(global.luaCfg:point_reward() or {} ) do 

        if v.activity_id == self.data.activity_id then 

            local temp = clone(v)
            local curState = self:getCurProcess(level, v.rank)
            if curState == 1 then 
                count = count + 1 
            end
            table.insert(reword ,temp)
        end 
    end 
    self.schedule:setString(count.."/"..#reword)
end

function UILevelUpRewordPanel:setData(data)

    global.UILevelUpRewordPanelCell = {} 

    self:initTouch()

    self.data = data 
    
    self.combat:getParent():setString(gls(11162))

    self.bg_reward:setVisible(true)

    if self.data.activity_id == 15001 then   -- 七天城堡升级

        self.bg_reward:setVisible(false)
        self:updateCastle()

    elseif  self.data.activity_id == 16001  then -- 七天领主升级

        self.bg_reward:setVisible(false)
        self:updateLeader()
    
    elseif self.data.activity_id == 3001  then 

        self:updateLeaderComp()

    elseif self.data.activity_id == 21001 then 

        self:buildAndHero(21001)


    elseif  self.data.activity_id == 72001 then 

        self:heroShare()
        
        self.combat:getParent():setString(gls(11164))

        self.bg_reward:setVisible(false)

    elseif  self.data.activity_id == 73001 then 

        self:Dragonhallenge()

        self.bg_reward:setVisible(false)

    elseif  self.data.activity_id == 22001 then 

        self:buildAndHero(22001)
    end 

    self.banner:loadTexture(self.data.banner, ccui.TextureResType.plistType)
    
     -- uiMgr:setRichText(self, "introduce", self.data.desc ,{})

     local str = global.luaCfg:get_local_string(self.data.desc)

     self.combat:setString(str)

    global.tools:adjustNodePosForFather(self.combat:getParent(),self.combat)

    global.loginApi:clickPointReport(nil,self.data.activity_id,4,nil)
end




function UILevelUpRewordPanel:buildAndHero(id)--建筑 和 英雄

    local call = function (cruntPoint) 

        local reword = {}

        local count  = 0

        local temp = {} 

        for _ ,v in pairs(global.luaCfg:point_reward() or {}) do

            if v.activity_id == self.data.activity_id then 

                table.insert(temp , v )

            end 
        end 

        table.sort(temp , function(A ,B ) return A.point  < B.point end)

        for index  ,v in pairs (temp) do 

            local temp2 = clone( v)

            if not  ( v.point > cruntPoint) then 

                count  =count + 1 

                temp2.killed = true 
            end 

            temp2.tips_panel = self

            temp2.cruntPoint  = cruntPoint

            table.insert(reword ,temp2)
        end 

        table.sort(reword , function(A ,B) return A.point <  B.point end)
        
        self.schedule:setString(count.."/"..#reword)

        self.tableView:setData(reword)

    end 

    global.itemApi:combatRank(function(msg)
        dump(msg ,"12313")
        local getValue = function (lType) 
            for _ ,v in ipairs(msg.tgRank or {} ) do 
                if v.lType == lType then 
                    return v.lValue
                end  
            end 
            return 0 
        end 
        if id == 21001 then 
            call(getValue(3)) 
        elseif id == 22001 then 
            call(getValue(2)) 
        end 
    end)

    -- call(0) 
end 


function UILevelUpRewordPanel:updateLeaderComp() -- 领主战力

    local level =  0 

    local call = function () 

        local reword = {}

        local count  = 0

        local temp = {} 

        for _ ,v in pairs(global.luaCfg:point_reward() or {}) do

            if v.activity_id == self.data.activity_id then 

                table.insert(temp , v )

            end 
        end 

        table.sort(temp , function(A ,B ) return A.point  < B.point end)

        for index  ,v in pairs (temp) do 

            local temp2 = clone( v)

            if not  ( index  > level) then 

                count  =count + 1 

                temp2.killed = true 
            end 

            temp2.tips_panel = self

            temp2.cruntPoint  = global.userData:getPower()

            table.insert(reword ,temp2)
        end 

        table.sort(reword , function(A ,B) return A.point <  B.point end)
        
        self.schedule:setString(count.."/"..#reword)

        self.tableView:setData(reword)

    end 

    global.ActivityAPI:ActivityRankReq( self.data.activity_id,0,  50 , function (ret, msg)
    -- global.ActivityAPI:ActivityRankReq({self.data.activity_id},function(ret,msg)
            
        if msg and msg.tagItem and  msg.tagItem[1] and msg.tagItem[1].lValue and self.data  then 

            level =  msg.tagItem[1].lValue

            call() 
            
        end 
    end)

    -- call()

end 



function UILevelUpRewordPanel:updateLeader() -- 领主等级

    local level =  0 

    local call = function () 

        local reword = {}

        local count  = 0 

        for index, v in ipairs(global.luaCfg:point_reward() or {} ) do 

            if v.activity_id == self.data.activity_id then 

                local temp = clone( v)

                local curState = self:getCurProcess(level, v.rank)
                temp.killed = curState == 1 and true or false
                if temp.killed then 
                    count = count + 1 
                end

                temp.tips_panel = self
                temp.cruntPoint  =global.userData:getLevel()

                table.insert(reword ,temp)
            end 
        end 

        table.sort(reword , function(A ,B) return A.point <  B.point end)


        self.schedule:setString(count.."/"..#reword)


        self.tableView:setData(reword)

    end


    global.ActivityAPI:ActivityRankReq( self.data.activity_id,0,  50 , function (ret, msg)
        if msg and msg.tagItem and  msg.tagItem[1] and msg.tagItem[1].lValue and self.data  then 
            level =  msg.tagItem[1].lValue
            call() 
        end 
    end)
    call()

end 

-- lValue 领取进度二进制解析   (0未领取 1已领取)
function UILevelUpRewordPanel:getCurProcess(lValue, id)

    if lValue == 0 then return 0 end
    local d2Data = {}
    local d2Table = global.tools:d2b(lValue) -- 二进制
    for i=32,29,-1 do
        table.insert(d2Data, d2Table[i])
    end
    return d2Data[id] or 0
end



function UILevelUpRewordPanel:heroShare() -- 英雄分享

    local state =  0
    local progress =  0


    local call = function () 

        local reword = {}

        local count  = 0

        local temp = {} 

        for _ ,v in pairs(global.luaCfg:point_reward() or {}) do

            if v.activity_id == self.data.activity_id then 

                table.insert(temp , v )

            end 
        end 

        table.sort(temp , function(A ,B ) return A.point  < B.point end)

        for index  ,v in ipairs (temp) do 

            local temp2 = clone( v)

            local curState = self:getCurProcess(state, v.rank)
            temp2.killed = curState == 1 and true or false
            if temp2.killed then 
                count = count + 1 
            end

            temp2.tips_panel = self
            temp2.cruntPoint  = progress
            table.insert(reword ,temp2)
        end 

        table.sort(reword , function(A ,B) return A.point <  B.point end)
        
        self.schedule:setString(count.."/"..#reword)

        self.tableView:setData(reword)

    end 

    global.ActivityAPI:ActivityRankReq( self.data.activity_id, 0,  50 , function (ret, msg)
    -- global.ActivityAPI:ActivityRankReq({self.data.activity_id},function(ret,msg)

        dump(msg , "holy shit")
        dump(ret , "holy shit ret")
            
        if msg and  msg.tagItem and msg.tagItem[1] and msg.tagItem[1].lValue  then 

            state =  msg.tagItem[1].lValue
            progress=  msg.tagItem[1].lRank
            call () 
            
        end 
    end)

    call()

end 


function UILevelUpRewordPanel:Dragonhallenge() -- 龙潭 挑战

    local state =  0 
    local progress =  0

    local call = function () 

        local reword = {}

        local count  = 0

        local temp = {} 

        for _ ,v in pairs(global.luaCfg:point_reward() or {}) do

            if v.activity_id == self.data.activity_id then 

                table.insert(temp , v )

            end 
        end 

        table.sort(temp , function(A ,B ) return A.point  < B.point end)

        for index  ,v in ipairs (temp) do 

            local temp2 = clone( v)

        local curState = self:getCurProcess(state, v.rank)
            temp2.killed = curState == 1 and true or false
            if temp2.killed then 
                count = count + 1 
            end

            temp2.tips_panel = self
            temp2.cruntPoint  = progress
            table.insert(reword ,temp2)
        end 

        table.sort(reword , function(A ,B) return A.point <  B.point end)
        
        self.schedule:setString(count.."/"..#reword)

        self.tableView:setData(reword)

    end 

    global.ActivityAPI:ActivityRankReq( self.data.activity_id, 0,  50 , function (ret, msg)
    -- global.ActivityAPI:ActivityRankReq({self.data.activity_id},function(ret,msg)

        dump(msg , "holy shit")
        dump(ret , "holy shit ret")
            
        if msg and  msg.tagItem and msg.tagItem[1] and msg.tagItem[1].lValue  then 

            state =  msg.tagItem[1].lValue
            progress=  msg.tagItem[1].lRank

            call () 
            
        end 
    end)

    call()

end 




function UILevelUpRewordPanel:updateCastle() -- 城堡等级


    local level =  0 

    local temp = {} 

    for _ ,v in pairs(global.luaCfg:point_reward() or {}) do

        if v.activity_id == self.data.activity_id then 

            table.insert(temp , v )

        end 
    end 
    table.sort(temp , function(A ,B ) return A.point  < B.point end)

    for index ,v  in ipairs(temp) do 
            
        if v.point >  global.cityData:getBuildingById(1).serverData.lGrade then 

            break
        end 

        level = index
    end

    print(level , "level//////////////////////")


    local call = function () 

        local reword = {}

        local count  = 0

        local temp = {} 

        for _ ,v in pairs(global.luaCfg:point_reward() or {}) do

            if v.activity_id == self.data.activity_id then 

                table.insert(temp , v )

            end 
        end 

        table.sort(temp , function(A ,B ) return A.point  < B.point end)

        for index  ,v in ipairs (temp) do 

            local temp2 = clone( v)

            local curState = self:getCurProcess(level, v.rank)
            temp2.killed = curState == 1 and true or false
            if temp2.killed then 
                count = count + 1 
            end

            temp2.tips_panel = self
            temp2.cruntPoint  = global.cityData:getBuildingById(1).serverData.lGrade
            table.insert(reword ,temp2)
        end 

        table.sort(reword , function(A ,B) return A.point <  B.point end)
        
        self.schedule:setString(count.."/"..#reword)

        self.tableView:setData(reword)

    end 

    global.ActivityAPI:ActivityRankReq( self.data.activity_id,0,  50 , function (ret, msg)
    -- global.ActivityAPI:ActivityRankReq({self.data.activity_id},function(ret,msg)
            
        if msg and  msg.tagItem and msg.tagItem[1] and msg.tagItem[1].lValue  then 

            level =  msg.tagItem[1].lValue

            call () 
            
        end 
    end)

    call()

end 


function UILevelUpRewordPanel:close_panel(sender, eventType)

    global.panelMgr:closePanel("UILevelUpRewordPanel")

end



function UILevelUpRewordPanel:initTouch()
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

function UILevelUpRewordPanel:onTouchMoved(touch, event)

    if prohibit_slide == 1  then return  end 


    local y =  math.abs((self.y - touch:getLocation().y)) > moveMax_y
    local x =  math.abs((self.x - touch:getLocation().x)) > moveMax_x
    
    if y   then 

        prohibit_slide = 1

        for _ ,v in pairs(global.UILevelUpRewordPanelCell or {} ) do 

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

    
function UILevelUpRewordPanel:test()
    for _ ,v in pairs(global.UILevelUpRewordPanelCell or {} ) do 

        if v.tableView then 
            v.tableView:scrollToLeft()
        end 

    end 
end 


function UILevelUpRewordPanel:onTouchBegan(touch, event)

     if self.isScring then 
        return 
     end 

    prohibit_slide =  0 

    -- self.isScring = false 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 
    return true
end

function UILevelUpRewordPanel:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    for _ ,v in pairs(global.UILevelUpRewordPanelCell or {} ) do 

        if v.setTBTouchEable then 

            v:setTBTouchEable(true)
        end 

    end 
end

function UILevelUpRewordPanel:onTouchCancel()

    self.tableView:setTouchEnabled(true)
end 
 

function UILevelUpRewordPanel:ClearEventListener()
        
    if self.touchEventListener  then 
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener  = nil
    end
end 

function UILevelUpRewordPanel:onExit()
    
    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

    self:ClearEventListener()

end 
 

--CALLBACKS_FUNCS_END

return UILevelUpRewordPanel

--endregion
