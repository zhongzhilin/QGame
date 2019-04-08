                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   --region UIRechargePanel.lua
--Author : yyt
--Date   : 2017/03/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
local rechargeData = global.rechargeData
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UIRechargePanel  = class("UIRechargePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIRechargeCell = require("game.UI.recharge.UIRechargeCell")
local UIRechargeNode = require("game.UI.recharge.UIRechargeNode")

function UIRechargePanel:ctor()
    self:CreateUI()
end

function UIRechargePanel:CreateUI()
    local root = resMgr:createWidget("recharge/recharge_main_ui")
    self:initUI(root)
end

function UIRechargePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/recharge_main_ui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title_node = self.root.title_node_export
    self.titleText = self.root.title_node_export.titleText_fnt_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.top = self.root.top_export
    self.table_node = self.root.table_node_export
    self.PageView_1 = self.root.PageView_1_export
    self.pointNode = self.root.pointNode_export
    self.FileNode_2 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)
    self.noGift = self.root.noGift_export

    uiMgr:addWidgetTouchHandler(self.PageView_1, function(sender, eventType) self:touEvnenter(sender, eventType) end, true)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.FileNode_2)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIRechargeCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)


    self.PageView_1:addEventListener(handler(self, self.pageViewEvent))

    self.node_touch = cc.Node:create()
    self:addChild(self.node_touch)
end

function UIRechargePanel:pageViewEvent(sender, eventType )
   
    if not self.sliderData then return end
    if eventType == ccui.PageViewEventType.turning then

        -- 滑动到循环页
        local currPageIndex = self.PageView_1:getCurrentPageIndex()
        self:updatePointState(currPageIndex)
    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIRechargePanel:tableMove()
    self.isStartMove = true
end

function UIRechargePanel:setIdx(index)
    self.idxCharge = index

    local strId = index == 1 and 11172 or 11173
    self.titleText:setString(luaCfg:get_local_string(strId))
end

function UIRechargePanel:onEnter()

    self.isStartMove = false
    self.isPageMove = false
    self:setData()

    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        self:initSlider()
    end)

    self:addEventListener(global.gameEvent.EV_ON_DAILY_GIFT, function ()
        if self.initRecharge then
            self:initRecharge(true)
        end
    end)

    global.loginApi:clickPointReport(nil,11,nil,nil)

    if _NO_RECHARGE then 
        global.panelMgr:closePanel("UIRechargePanel")
        return global.tipsMgr:showWarning("FuncNotFinish")
    end 

end


function UIRechargePanel:registerMove()

    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.node_touch)
end

function UIRechargePanel:onExit(touch, event)
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIRechargePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIRechargePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIRechargePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIRechargePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIRechargePanel:setData()

    -- 充值列表
    self:initRecharge()

    -- 广告条
    -- self:initSlider()
    
end

function UIRechargePanel:refresh(shop_data)
    global.advertisementData:delDataByPosition2(shop_data)
    self:initSlider()
    self.shopdata  =  shop_data 


    if self.shopdata then 
        global.panelMgr:closePanel("UIGiftPanel")
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(self.shopdata.dropid).dropItem, true)
        self.shopdata = nil 
    end 

    self:initSlider()

end 

function UIRechargePanel:initRecharge(isNotify)

    self.noGift:setVisible(false)

    local initData = function ()
        -- body
        local setCType = function (data, ltype)
            for k,v in pairs(data) do
                v.cType = ltype
            end
            return data
        end
        if self.tableView then  
            local idxCharge = self.idxCharge or 1
            if idxCharge == 1 then
                local data = clone(rechargeData:getCharge())                
                self.tableView:setData(setCType(data,1))
            elseif idxCharge == 8 then

                local data = global.rechargeData:getChargeDailyList()
                self.tableView:setData(setCType(data,2), isNotify)
                self.noGift:setVisible(#data == 0)
            end
        end 
    end
    
    if isNotify then
        initData()
    else
        global.rechargeApi:getRechargeList(function (msg)
            rechargeData:initServer(msg.tgRecharge or {})
            initData()
        end)
    end

end

function UIRechargePanel:initSlider()

    if true then  -- 屏蔽滑动广告
        return 
    end 

    local data = global.advertisementData:getDataByPosition(7 , nil)
    if data  then 
        self.ad  = data 
        self:showSlider()
    end
end

function UIRechargePanel:jumpToIndex(index)

    self.PageView_1:jumpToPercentHorizontal( index/(#self.sliderData+1) *100 )
end

function UIRechargePanel:sellUNLL()
    self.PageView_1:removeAllPages()
    --  加入首部循环页
    local repeatItem1 = UIRechargeNode.new()
    repeatItem1:setData(self.ad,true)
    self.PageView_1:addPage(repeatItem1)
     self:setPoint(0) 
end 

local limit_number = 20 

function UIRechargePanel:showSlider()

    if not  self.ad.isvalid then 
        self:sellUNLL()
        return 
    end 

    local sliderData = self.ad.data
    self.sliderData = self.ad.data

    if #self.sliderData > limit_number then  -- 限制显示======== 
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


function UIRechargePanel:startTimer()
    if not self.sliderData or  #self.sliderData <1 then 
        return 
    end 
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 5)
    end
end 

function UIRechargePanel:closeTimer()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end 


-- 开始自动播放
function UIRechargePanel:playAuto()
    self:startTimer()
end

function UIRechargePanel:countDownHandler(dt)

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
function UIRechargePanel:setPoint(num)
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
function UIRechargePanel:updatePointState(index)
   
    if index == (#self.sliderData+1)  then
        index = 1
    elseif index == 0 then
        index = #self.sliderData
    end

    for i=1,#self.sliderData do
        global.colorUtils.turnGray(self.pointNode.Node_1["Image_"..i], i~=(index))
    end
end

function UIRechargePanel:exit_call(sender, eventType)
    local idxCharge = self.idxCharge or 1
    local strPanel = idxCharge == 1 and "UIRechargePanel" or "UIRechargePanelDaily"
    global.panelMgr:closePanelForBtn(strPanel)  
    self:closeTimer()
end

function UIRechargePanel:touEvnenter(sender, eventType)

    if not self.sliderData then return end

    local currPageIndex = self.PageView_1:getCurrentPageIndex()
    if eventType == 0 then 
        self:closeTimer()
    end 
    if eventType == 1 then
    elseif eventType == 2 or eventType == 3 then
        self:startTimer()
        if currPageIndex == (#self.sliderData+1) then
            self:jumpToIndex(1)
        elseif currPageIndex == 0 then
            self:jumpToIndex(#self.sliderData)
        end
    end

end

-- 魔晶不足购买成功回调
function UIRechargePanel:setCallBack(callfunc)
    self.callfunc = callfunc
end

--CALLBACKS_FUNCS_END

return UIRechargePanel

--endregion
