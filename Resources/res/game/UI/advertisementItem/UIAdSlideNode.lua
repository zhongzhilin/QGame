--region UIAdSlideNode.lua
--Author : anlitop
--Date   : 2017/03/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAdSlideNode  = class("UIAdSlideNode", function() return gdisplay.newWidget() end )
local UIAdvertisementItem = require("game.UI.advertisementItem.UIAdvertisementItem")

function UIAdSlideNode:ctor()
    -- self:CreateUI()
end

function UIAdSlideNode:CreateUI()
    local root = resMgr:createWidget("advertisement/ad_slide_node")
    self:initUI(root)

end

function UIAdSlideNode:refurbish(data)

    global.advertisementData:delDataByPosition2(data)
    self.isStartMove = false
    global.UIAdSlideNodeisMove = "NOTMOVE"
    self:registerMove()
    self.shopdata  =  data 
    if self.shopdata then 
        global.panelMgr:closePanel("UIADGiftPanel")
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(self.shopdata.dropid).dropItem)
        self.shopdata = nil 
    end 

    self:setData(self.position)
end 


function UIAdSlideNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "advertisement/ad_slide_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.PageView_1 = self.root.PageView_1_export
    self.pointNode = self.root.pointNode_export

--EXPORT_NODE_END
    self.PageView_1:addEventListener(handler(self, self.pageViewEvent))
    self.node_touch = cc.Node:create()
    self:addChild(self.node_touch)
    uiMgr:addWidgetTouchHandler(self.PageView_1, function(sender, eventType) self:touEvnenter(sender, eventType) end, true)

end

function UIAdSlideNode:registerMove()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.node_touch)
end

function UIAdSlideNode:pageViewEvent(sender, eventType )
    if not self.sliderData then return end
    if eventType == ccui.PageViewEventType.turning then
        -- 滑动到循环页
        local currPageIndex = self.PageView_1:getCurrentPageIndex()
        self:updatePointState(currPageIndex)
    end

end

function UIAdSlideNode:getPageViewCurrentPageIndex()
    -- print(self.PageView_1:getCurrentPageIndex(),"self.PageView_1:getCurrentPageIndex()")
    return self.PageView_1:getCurrentPageIndex()
end

function UIAdSlideNode:setPageViewCurrentPageIndex(index)
    self.page_index  = index
end 

local beganPos = cc.p(0,0)
local isMoved = false
function UIAdSlideNode:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIAdSlideNode:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIAdSlideNode:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        global.UIAdSlideNodeisMove = "MOVE"
        return
    end
    global.UIAdSlideNodeisMove = "NOTMOVE"
end

function UIAdSlideNode:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end


function UIAdSlideNode:onEnter()
    self.isStartMove = false
    global.UIAdSlideNodeisMove = "NOTMOVE"
    self.innited = true 
    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        self:setData(self.position)
    end)

    self:closeTimer()
end 


function UIAdSlideNode:setData(position,page_index)
    self:setPageViewCurrentPageIndex(page_index)
    self.position = position
    self:initSlider(position)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIAdSlideNode:initSlider(position)

    local data = global.advertisementData:getDataByPosition(position)
    if data then 
        self.ad  =data 
        self:showSlider()
    end 
end 

function UIAdSlideNode:jumpToIndex(index)

    -- dump(self.sliderData)
    self.PageView_1:jumpToPercentHorizontal( index/(#self.sliderData+1) *100 )
end
function UIAdSlideNode:hidegift()

    self.PageView_1:removeAllPages()
    local repeatItem1 = UIAdvertisementItem.new()
    repeatItem1:setData(self.ad,true)
    repeatItem1.panel = self
    self.PageView_1:addPage(repeatItem1) 
    self:setPoint(0)

end 

local limit_number = 20  -- 限制数量===== 

function UIAdSlideNode:closeTimer()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end 


function UIAdSlideNode:startTimer()
    if  not self.sliderData  or #self.sliderData<=1 then 
        return 
    end 
     if not self.m_countDownTimer then
        self.chronograph = 0
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 5)
    end
end 


function UIAdSlideNode:showSlider()

    if ( self.ad and  self.ad.isvalid == false) or _NO_RECHARGE then 
        self:hidegift()
        return 
    end 

    local sliderData = self.ad.data
    self.sliderData  = sliderData


    if #self.sliderData > limit_number then  -- 限制显示======= 
        for i = #self.sliderData, 1, #self.sliderData - limit_number do
            table.remove(self.recordNotify_arr, i)
        end
    end 

    self.PageView_1:removeAllPages()

    local createNode = function (node , time , data) 
        local node = node

        local call  = function()
            if  not tolua.isnull(self) and not tolua.isnull(node) and not node.isCreate then 
                local repeatItem1 = UIAdvertisementItem.new()
                repeatItem1:setData(data)
                repeatItem1.panel = self
                node:addChild(repeatItem1)
                node.isCreate =true 
            end
        end
        node.createCall = call 

        if time == 0  then 
            node.createCall()
        else 
            gscheduler.performWithDelayGlobal(node.createCall, time)
        end 
    end 

    local partTime = 0.1 
    if #sliderData > 0 then
        local node = gdisplay.newWidget()
        createNode(node ,  partTime , sliderData[#sliderData])
        self.PageView_1:addPage(node) 
        for i,v in ipairs(sliderData) do
            local node = gdisplay.newWidget()
            v.panel = self
            self.PageView_1:addPage(node)
            local time = i* partTime
            if i == 1  then 
                time =  0 
            end
            if time > 1 then 
                time = 1 
            end 
            createNode(node , time ,  v)
        end 
        local node = gdisplay.newWidget()
        createNode(node , partTime , sliderData[1])
        self.PageView_1:addPage(node) 
    end
    
    self:setPoint(#sliderData)
    
    self:jumpToIndex(self.page_index or 1 ) 
    self:updatePointState(self.page_index or 1)
    self:playAuto()
end

-- 开始自动播放
function UIAdSlideNode:playAuto()
     self:startTimer()
end

function UIAdSlideNode:countDownHandler(dt)
    -- self.chronograph  =self.chronograph+1 
    -- if self.chronograph > global.EasyDev.AD_SLIDE_TIME then 
    --     self.chronograph =0
    -- else
    --     return  
    -- end 
    if not self.PageView_1  then 
        return 
    end 
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
    if self.sliderData[currPageIndex] then
        global.loginApi:clickPointReport(nil,21,self.sliderData[currPageIndex].id,nil)
    end


    self:updatePointState(currPageIndex)
end

-- slider 点
function UIAdSlideNode:setPoint(num)
    for i=1,limit_number do
        if  self.pointNode.Node_1["Image_"..i] then 
            self.pointNode.Node_1["Image_"..i]:setVisible(i<=num)
        end  
    end
    if num > 0 then
        local posX = self.pointNode.Node_1["Image_"..num]:getPositionX()
        self.pointNode:setPositionX(gdisplay.width/2-posX/2)
    end


end
-- 当前页点亮
function UIAdSlideNode:updatePointState(index)
   
    if index == (#self.sliderData+1)  then
        index = 1
    elseif index == 0 then
        index = #self.sliderData
    end

    for i=1,#self.sliderData do
        global.colorUtils.turnGray(self.pointNode.Node_1["Image_"..i], i~=(index))
    end
end
 
function UIAdSlideNode:onExit()
   self:closeTimer()
   self.page_index = nil 
end 

function UIAdSlideNode:touEvnenter(sender, eventType)

    local currPageIndex = self.PageView_1:getCurrentPageIndex()

    if not self.sliderData then return end
    local currPageIndex = self.PageView_1:getCurrentPageIndex()
    if eventType == 0 then 
        self:closeTimer()
    elseif eventType == 1 then
    elseif eventType == 2 or eventType == 3 then
        self:startTimer()
        if currPageIndex == (#self.sliderData+1) then
            self:jumpToIndex(1)
        elseif currPageIndex == 0 then
            self:jumpToIndex(#self.sliderData)
        end
    end

end
 
--CALLBACKS_FUNCS_END

return UIAdSlideNode

--endregion
