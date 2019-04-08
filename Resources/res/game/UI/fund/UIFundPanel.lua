--region UIFundPanel.lua
--Author : anlitop
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UIFundPanel  = class("UIFundPanel", function() return gdisplay.newWidget() end )
local UIFundItemCell = require("game.UI.fund.UIFundItemCell")
local TabControl = require("game.UI.common.UITabControl")
local UITableView = require("game.UI.common.UITableView")

function UIFundPanel:ctor()
    self:CreateUI()
end

function UIFundPanel:CreateUI()
    local root = resMgr:createWidget("fund/fund_bj")
    self:initUI(root)
end

function UIFundPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "fund/fund_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.Mode2 = self.root.Mode2_export
    self.red_point_1 = self.root.Mode2_export.Button_1.red_point_1_export
    self.red_point_2 = self.root.Mode2_export.Button_2.red_point_2_export
    self.item_content = self.root.item_content_export
    self.tb_cotent = self.root.tb_cotent_export
    self.tb_add = self.root.tb_add_export
    self.top_node = self.root.top_node_export
    self.vip = self.root.top_node_export.vip_export
    self.buy_number_text = self.root.top_node_export.buy_number_text_export
    self.buy_gift = self.root.top_node_export.buy_gift_export
    self.node_gray1 = self.root.top_node_export.buy_gift_export.node_gray1_export
    self.gift_price_text = self.root.top_node_export.buy_gift_export.gift_price_text_export
    self.FileNode_1 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.buy_gift, function(sender, eventType) self:onPay(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType)  

        global.panelMgr:closePanel("UIFundPanel")

    end)

    local node = cc.Node:create()
    node:setPositionY(self.top_node:getPositionY()-3)
    self.root:addChild(node)

    self.tableView = UITableView.new()
        :setSize(self.tb_cotent:getContentSize(), node)
        :setCellSize(self.item_content:getContentSize())
        :setCellTemplate(UIFundItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.tabControl = TabControl.new(self.Mode2, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))



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


function UIFundPanel:onTabButtonChanged(index , old)

    self.data  = global.propData:getFundInfo()

    self.tableView:stopScrolling()

    local data = {} 

    for _ , v in ipairs(global.luaCfg:fund()) do 

         if v.type == index then 

            table.insert(data, v )
        end 
    end 

    self.tableView:setData(data, (old and old==99))

    -- self.gift_price_text:setString(global.luaCfg:get_config_by(1).fundmoney)

    local gift = global.luaCfg:get_gift_by(57)

    self.gift_price_text:setString(gift.unit..gift.cost)


    -- self:setNumberRichText(self.data.lCurCount or 0 )

    self.buy_gift:setVisible(not self.data.lOwns)

    -- if tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) > global.luaCfg:get_config_by(1).fundmoney  then 
    --     self.gift_price_text:setTextColor(gdisplay.COLOR_WHITE)
    -- else 
    --     self.gift_price_text:setTextColor(gdisplay.COLOR_RED)
    -- end 

    -- 设置小红点

    self.red_point_1:setVisible(false)
    self.red_point_2:setVisible(false)

    for _ , v in ipairs(global.luaCfg:fund()) do 

       if  global.propData:getFundState(v.ID) == 1  then 

            self["red_point_"..v.type]:setVisible(true)
       end 
    end 

end


function UIFundPanel:setNumberRichText(number)

    global.uiMgr:setRichText(self,"buy_number_text",50218,{num =number})

end 


-- 魔晶库和开服基金
-- required int32      lKind = 1;  //1存款 2基金
-- required int32      lType = 2;  //操作档位
-- required int32      lOperate = 3;   //操作类型0查看1储蓄2取出/领取
-- optional int32      lParam = 4;  //操作数量  
-- optional int64      lTarget = 5;    //操作目标


function UIFundPanel:onPay(sender, eventType)

    -- if not (tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) > global.luaCfg:get_config_by(1).fundmoney ) then 
    --     global.tipsMgr:showWarning("ItemUseDiamond")
    --     return 
    -- end 

    -- local panel = global.panelMgr:openPanel("UIPromptPanel")

    -- panel:setData( global.tipsMgr:getTipsText("fund01" ,global.luaCfg:get_config_by(1).fundmoney), function ()

    --     global.itemApi:bankAction(function (msg)
    --         dump(msg ,"啦去后刷新界面。。。。")
    --         global.tipsMgr:showWarning("fund02")
    --     end ,2, 1 , 1 , 1, 1)

    -- end)

    if global.vipBuffEffectData:getVipLevel() < 3 then
        return global.tipsMgr:showWarning("fundCanBuy")
    end

    global.sdkBridge:app_sdk_pay(57,function()
        -- 已经监听礼包发货通知
        global.tipsMgr:showWarning("fund02")
    end)


end


function UIFundPanel:onEnter()


    self:addEventListener(global.gameEvent.BANKUPDATE , function () 

        self:onTabButtonChanged(self.tabControl:getSelectedIdx(), 99 )
    end)

    -- self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE , function () 

    --     if tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) > global.luaCfg:get_config_by(1).fundmoney  then 
    --         self.gift_price_text:setTextColor(gdisplay.COLOR_WHITE)
    --     else 
    --         self.gift_price_text:setTextColor(gdisplay.COLOR_RED)
    --     end

    -- end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE_SUCCESS, function (event , data)
        if data.lID == 57 then 
            --拉去一下服务器数据 ， 更新ui
            -- global.itemApi:updateBankDate()

        end 
    end)

    self.tabControl:setSelectedIdx(1)

    self:onTabButtonChanged(1)

    --拉去一下服务器数据 ， 更新ui
    global.itemApi:updateBankDate()

    self:initTouch()

    self.vip:setString(global.luaCfg:get_gift_by(57).vip_point)

end 





function UIFundPanel:initTouch()
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

function UIFundPanel:onTouchMoved(touch, event)

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

    
function UIFundPanel:setCellTouch(state)

    for _ ,v in pairs(self.tableView:getCells()) do 
        
        if v.tv_target and  v.tv_target.item  and v.tv_target.item.setTBTouchEable then 

            v.tv_target.item:setTBTouchEable(state)
        end 
    end 
end 


function UIFundPanel:onTouchBegan(touch, event)

    if self.isScring then 
        return 
     end 

    prohibit_slide =  0 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 

    return true
end

function UIFundPanel:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    self:setCellTouch(true)

end


function UIFundPanel:onTouchCancel()

    self:onTouchEnded()
end 




--CALLBACKS_FUNCS_END

return UIFundPanel