--region UIADGiftPanel.lua
--Author : anlitop
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local  UIADGiftItem  =  require("game.UI.advertisementItem.UIADGiftItem")

local UIADGiftPanel  = class("UIADGiftPanel", function() return gdisplay.newWidget() end )

function UIADGiftPanel:ctor()
    self:CreateUI()
end

function UIADGiftPanel:CreateUI()
    local root = resMgr:createWidget("advertisement/ad_gift_panel")
    self:initUI(root)
end

function UIADGiftPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "advertisement/ad_gift_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.PageView_1 = self.root.PageView_1_export
    self.close_btn = self.root.close_btn_export
    self.pointNode = self.root.pointNode_export
    self.title = self.root.gift_name_bg.title_export
    self.back_bt = self.root.back_bt_export

    uiMgr:addWidgetTouchHandler(self.close_btn, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:click_to_right(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_2, function(sender, eventType) self:click_to_left(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.back_bt, function(sender, eventType) self:click_back(sender, eventType) end)
--EXPORT_NODE_END

    self.PageView_1:addEventListener(handler(self, self.pageViewEvent))
    uiMgr:addWidgetTouchHandler(self.PageView_1, function(sender, eventType) self:touEvnenter(sender, eventType) end, true)
 

    self.node_touch = cc.Node:create()
    self:addChild(self.node_touch)

    local  tips_node = cc.Node:create()
    self:addChild(tips_node,99)
    self.tips_node = tips_node

    self.back_bt:setVisible(false)

end

function UIADGiftPanel:pageViewEvent(sender, eventType )
    if not self.sliderData then return end
    if eventType == ccui.PageViewEventType.turning then
        local currPageIndex = self.PageView_1:getCurrentPageIndex()
        self:updatePointState(currPageIndex)
    end
end




--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIADGiftPanel:tableMove()
    self.isStartMove = true
end

function UIADGiftPanel:onEnter()
    self.isStartMove = false
    self.isPageMove = false
    self:registerMove()
    self.want_exit = false 

    local callDeal = function ()
        -- body
        if self.isDaily then
            self:setData(self.top1_id, true)
        else
            local nextID = nil 
            if global.advertisementData:getLastBuyGiftID()then 
                nextID =  global.luaCfg:get_gift_by(global.advertisementData:getLastBuyGiftID()).buy_next_gift
            end 
            self:setData(nextID or self.top1_id )
        end
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, callDeal)
    self:addEventListener(global.gameEvent.EV_ON_DAILY_GIFT, callDeal)
    
end

function UIADGiftPanel:registerMove()

    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.node_touch)
end


local beganPos = cc.p(0,0)
local isMoved = false
function UIADGiftPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end

local  max_movex = 10
local  max_movey = 10 
function UIADGiftPanel:onTouchMoved(touch, event)
    isMoved = true
    if self.isMoveing  then 
       
        if math.abs(beganPos.x - touch:getLocation().x) > max_movex  then 
            self.isLR = true 
            self.moveingType = 1 
            self.isMoveing = false
            for _ ,v in pairs(self.pageviewchild) do 
                v:clearTouches()
            end
        end 
        
        if math.abs(beganPos.y - touch:getLocation().y ) > max_movey and    self.isLR== false then 
            self.PageView_1:setTouchEnabled(false)
            self.moveingType = 2 
            self.isMoveing = false
        end 
    end 
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIADGiftPanel:onTouchEnded(touch, event)
    self.PageView_1:setTouchEnabled(true)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
    end


-- print(isMoved,"isMoved")
-- print(self.moveingType ,"self.moveingType == 2 ")
    
    if isMoved and self.moveingType == 2 and self.want_exit == false then
        global.delayCallFunc(function()
            CCHgame:sendTouch(cc.p(1,1))    
        end,nil,0)        
    end
    self.isLR = false
    self.isMoveing =true
end

function UIADGiftPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIADGiftPanel:setData(top1_id, isDaily)
    self.top1_id = top1_id 
    self.isDaily = isDaily
    print(self.top1_id,"top1_id")
    -- 充值列表
    -- self:initRecharge()
    -- 广告条
    self:initSlider(false)
    self.close_btn:setVisible(not self.back_bt:isVisible())

    local str = isDaily and global.luaCfg:get_recharge_list_by(8).texct or global.luaCfg:get_recharge_list_by(3).texct
    self.title:setString(str)
end

function UIADGiftPanel:refresh(shop_data)
    global.advertisementData:delDataByPosition2(shop_data)
    self.shopdata = shop_data
    if self.shopdata then 
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(self.shopdata.dropid).dropItem, true)
        self.shopdata = nil 
    end 
    self:initSlider(false)
end 

function UIADGiftPanel:initRecharge()
    
    global.rechargeApi:getRechargeList(function (msg)
        rechargeData:initServer(msg.tgRecharge or {})
        local data = rechargeData:getCharge()
        self.tableView:setData(data)
    end)

end

function UIADGiftPanel:initSlider()

    if self.isDaily then
        if not  global.rechargeData:isHaveAvailableGift() then 
            global.panelMgr:closePanel("UIADGiftPanel")
            return 
        end 
    else
        if not  global.advertisementData:isHaveAvailableAD() then 
            global.panelMgr:closePanel("UIADGiftPanel")
            return
        end 
    end

    local temp = {} 
    if self.isDaily then
        temp = global.rechargeData:getChargeDailyList()
    else 
        local  checkContain = function (ad)
            for _, v in pairs(temp) do 
                if v.id == ad.id then 
                    return false 
                end 
            end
            return true  
        end
        for _ ,v  in pairs(global.advertisementData:getAllAD()) do 
            if v.isvalid then 
                for _ , vv in ipairs(v.data) do
                    if checkContain(vv) then 
                        table.insert(temp ,vv)
                    end 
                end 
            end 
        end
    end

    if self.top1_id then  -- 讲点进来的礼包 放在第一个位置//////
        local index1= temp[1]
        local replace =  nil 
        for index ,v in pairs(temp) do 
            if v.id == self.top1_id  then 
                temp[index] = index1               
                temp[1] = v
                replace  =v 
                break 
            end             
        end

        if replace  then 
            table.remove(temp ,1)
            table.sort(temp ,function(A ,B) return A.range < B.range end )
            table.insert(temp , 1 , replace)
        end 
    else 
        table.sort(temp ,function(A ,B) return A.range < B.range end )
    end 


    self.PageView_1:removeAllPages()
    -- self.ttt  = 0 

    self.pageviewchild = {}

    for _  ,v in pairs(temp) do 
        v.panel = self
    end


    self.sliderData = temp
    if # self.sliderData > 0 then
        --  加入首部循环页
        local repeatItem1 = UIADGiftItem.new()

        gscheduler.performWithDelayGlobal(function()
            if  repeatItem1.setData then 
                repeatItem1:setData(self.sliderData[#self.sliderData] , handler(self,self.refresh))
            end 
        end, 0.1)

        self.PageView_1:addPage(repeatItem1) 

        table.insert(  self.pageviewchild , repeatItem1)

        for i,v in ipairs(self.sliderData) do
            local item= UIADGiftItem.new()
            local time = i*0.1
            if i == 1  then 
                time =  0 
            end 
            if  time == 0  then 
                item:setData(v,handler(self,self.refresh))
            else 
                gscheduler.performWithDelayGlobal(function()
                    if item.setData then 
                        item:setData(v,handler(self,self.refresh))
                    end 
                end, time)
            end 
            self.PageView_1:addPage(item)
            table.insert(  self.pageviewchild , item)
        end 
        --  加入尾部循环页
        local repeatItem2 = UIADGiftItem.new()

        gscheduler.performWithDelayGlobal(function()
            if  repeatItem2.setData then 
                repeatItem2:setData(self.sliderData[1],handler(self,self.refresh))
            end 
        end, #self.sliderData * 0.1)

        self.PageView_1:addPage(repeatItem2) 

        table.insert(  self.pageviewchild , repeatItem2)
    end
    self:setPoint(#self.sliderData)
    self:updatePointState(1)
    self:jumpToIndex(1) 
end



function UIADGiftPanel:jumpToIndex(index)

    self.PageView_1:jumpToPercentHorizontal( index/(#self.sliderData+1) *100 )
end

function UIADGiftPanel:sellUNLL()
    self.PageView_1:removeAllPages()
    --  加入首部循环页
    local repeatItem1 = UIRechargeNode.new()
    repeatItem1:setData(self.ad,true)
    self.PageView_1:addPage(repeatItem1)
     self:setPoint(0) 
end 

local limit_number = 20 

function UIADGiftPanel:showSlider()

    if not  self.ad.isvalid then 
        self:sellUNLL()
        return 
    end 

    local sliderData = self.ad.data
    self.sliderData = self.ad.data

    if #self.sliderData > limit_number then  -- 限制显示======================================
        for i = #self.sliderData, 1, #self.sliderData -limit_number do
            table.remove(self.recordNotify_arr, i)
        end
    end 

    self.PageView_1:removeAllPages()
    if #sliderData > 0 then
        --  加入首部循环页
        local repeatItem1 = UIRechargeNode.new()
        repeatItem1:setData(sliderData[#sliderData])
        self.PageView_1:addPage(repeatItem1) 
        
        for i,v in ipairs(sliderData) do
            local item= UIRechargeNode.new()
            item:setData(v)
            self.PageView_1:addPage(item)
        end 
        --  加入尾部循环页
        local repeatItem2 = UIRechargeNode.new()
        repeatItem2:setData(sliderData[1])
        self.PageView_1:addPage(repeatItem2) 
    end
    self:setPoint(#sliderData)
    
    self:jumpToIndex(1) 
    self:updatePointState(1)

    self:playAuto()
end


function UIADGiftPanel:startTimer()
    if not self.sliderData or  #self.sliderData <1 then 
        return 
    end 
    -- if not self.m_countDownTimer then
    --     self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 5)
    -- end
end 

function UIADGiftPanel:closeTimer()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end 


-- 开始自动播放
function UIADGiftPanel:playAuto()
    self:startTimer()
end

function UIADGiftPanel:countDownHandler(dt)

    local currPageIndex = self.PageView_1:getCurrentPageIndex()
    if currPageIndex  == (#self.sliderData + 1) then 
        
        currPageIndex = 1
        self:jumpToIndex(currPageIndex)
    elseif currPageIndex  == 0 then

        currPageIndex = #self.sliderData
        self:jumpToIndex(currPageIndex)
    else
        currPageIndex = currPageIndex + 1
        self.PageView_1:scrollToPage(currPageIndex)
    end
    self:updatePointState(currPageIndex)

end

-- slider 点
function UIADGiftPanel:setPoint(num)
    print(num,"num")
    for i=1,limit_number do
        self.pointNode.Node_1["Image_"..i]:setVisible(i<=num)
    end
    if num > 0 then
        local posX = self.pointNode.Node_1["Image_"..num]:getPositionX()
        self.pointNode:setPositionX(gdisplay.width/2-posX/2)
    end
end
-- 当前页点亮
function UIADGiftPanel:updatePointState(index)

    if index == (#self.sliderData+1)  then
        index = 1
    elseif index == 0 then
        index = #self.sliderData
    end

    for i=1,#self.sliderData do
        global.colorUtils.turnGray(self.pointNode.Node_1["Image_"..i], i~=(index))
    end
end

function UIADGiftPanel:exit_call(sender, eventType)
       global.panelMgr:closePanel("UIADGiftPanel")
end

function UIADGiftPanel:exit_back(sender, eventType)

    self.want_exit =true
    if eventType == 2 then
        self:exit_call()
    end
end


function UIADGiftPanel:touEvnenter(sender, eventType)
    if not self.sliderData then return end
    if eventType == 0 then 
        -- self:closeTimer()
    end 
    if eventType == 1 then
    elseif eventType == 2 or eventType == 3 then
        self:TurnHanel()
    end
end


function UIADGiftPanel:TurnHanel()
    local currPageIndex = self.PageView_1:getCurrentPageIndex()
        if currPageIndex == (#self.sliderData+1) then
             self:jumpToIndex(1)
        elseif currPageIndex == 0 then
        print("currPageIndex == 0")
        self:jumpToIndex(#self.sliderData)
    end
   
end 

function UIADGiftPanel:onExit()

    self.back_bt:setVisible(false)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
     self.PageView_1:removeAllPages()

     self.want_exit =  nil
     
    self.top1_id = nil
end

-- 魔晶不足购买成功回调
function UIADGiftPanel:setCallBack(callfunc)
    self.callfunc = callfunc
end



function UIADGiftPanel:click_to_right(sender, eventType)
    -- local currPageIndex = self.PageView_1:getCurrentPageIndex()
    -- print(currPageIndex,"currPageIndex")
    -- if currPageIndex == (#self.sliderData) then
    --     self.PageView_1:scrollToPage(1)
    --     self:jumpToIndex(2)
    -- else
    -- end
    -- print(eventType,"eventType")
    -- if  eventType ==2 then  
    --     local currPageIndex = self.PageView_1:getCurrentPageIndex()
    --     self.PageView_1:scrollToPage(currPageIndex+1)
    --     self.isbut =true 
    --     self.currPageIndex =currPageIndex + 1 
    -- end 
end

function UIADGiftPanel:click_to_left(sender, eventType)
    -- if  eventType ==2 then 
    --     self.isbut =true 
    --     local currPageIndex = self.PageView_1:getCurrentPageIndex()
    --     print(currPageIndex,"click_to_left")
    --     self.PageView_1:scrollToPage(currPageIndex-1)
    --     self.currPageIndex =currPageIndex -1 
    -- end 
end

function UIADGiftPanel:click_back(sender, eventType)
    global.panelMgr:openPanel("UIRechargePanel")
    global.panelMgr:closePanel("UIADGiftPanel")
end
--CALLBACKS_FUNCS_END

return UIADGiftPanel

--endregion

