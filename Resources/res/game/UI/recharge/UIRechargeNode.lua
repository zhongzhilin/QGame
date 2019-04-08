--region UIRechargeNode.lua
--Author : yyt
--Date   : 2017/03/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRechargeNode  = class("UIRechargeNode", function() return gdisplay.newWidget() end )

function UIRechargeNode:ctor()
    self:CreateUI()
end

function UIRechargeNode:CreateUI()
    local root = resMgr:createWidget("recharge/rechargeSlider")
    self:initUI(root)
end

function UIRechargeNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/rechargeSlider")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.invalid_sprite = self.root.invalid_sprite_export
    self.invalid_overtime_text = self.root.invalid_sprite_export.timer_Node_0.invalid_overtime_text_export
    self.sold_out = self.root.invalid_sprite_export.sold_out_mlan_8_export
    self.Button_1 = self.root.Button_1_export
    self.bg = self.root.Button_1_export.Node_1.bg_export
    self.limitNode = self.root.Button_1_export.Node_1.limitNode_export
    self.gift_text = self.root.Button_1_export.Node_1.limitNode_export.gift_text_export
    self.firstExtraDia = self.root.Button_1_export.Node_1.limitNode_export.firstExtraDia_export
    self.icon = self.root.Button_1_export.Node_1.icon_export
    self.priceText = self.root.Button_1_export.Node_1.priceText_export
    self.getDiamond = self.root.Button_1_export.Node_1.priceText_export.getDiamond_export
    self.gift_name_text = self.root.Button_1_export.gift_name_text_export
    self.timer_node = self.root.Button_1_export.timer_node_export
    self.time = self.root.Button_1_export.timer_node_export.time_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:clickHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.invalid_sprite_export = self.root.invalid_sprite_export
    self.gift_name_text_export  =self.root.Button_1_export.gift_name_text_export

    self.Button_1:setSwallowTouches(false)
    self.Button_1:setZoomScale(0)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIRechargeNode:hideUI(isinvalid)
    if isinvalid then 
        self.invalid_sprite_export:setVisible(true)
        self.root.Button_1_export.Node_1:setVisible(false)
        self.timer_node:setVisible(false)
        self.gift_name_text_export:setVisible(false)
    else
        self.gift_name_text_export:setVisible(true)
        self.invalid_sprite_export:setVisible(false)
        self.root.Button_1_export.Node_1:setVisible(true)
        self.timer_node:setVisible(true)
    end  
end 


function UIRechargeNode:overtime()
     self.overtime  = self.data.lEndTime - global.dataMgr:getServerTime()
    if  self.overtime <=1 then 
        self.overtime =0
        self:closeTimer()
    end 
    self.invalid_overtime_text:setString(global.funcGame.formatTimeToHMS( self.overtime))
end

function UIRechargeNode:closeTimer()
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
      if self.timer2 then
        gscheduler.unscheduleGlobal(self.timer2)
       self.timer2 = nil
    end
end 

function UIRechargeNode:setData(data,isinvalid)
    self.data = data
    self.isinvalid = isinvalid 
    self:hideUI(isinvalid)
    if isinvalid then 
        if not self.timer2 then 
            self.timer2 = gscheduler.scheduleGlobal(handler(self,self.overtime), 1)
        end
        self:overtime()
        return 
    end 
    if not self.data.lEndTime then 
         self.data.lEndTime = global.dailyTaskData:getCurZeroTime()
    end 

    self.getDiamond:setString(data.resource_num)
    if data.resource and data.resource~="" then 
        self.icon:setSpriteFrame(data.resource)
    end 
    if data.banner and data.banner ~="" then 
        -- self.bg:loadTexture(data.banner, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.bg,data.banner)
    end 
    uiMgr:setRichText(self, "gift_text", 50047, {})
    
     self.gift_name_text_export:setString(data.name)

    -- 限购礼包
    local limitData = luaCfg:get_drop_by(data.limit_reward)
    if limitData then
        
        self.limitNode:setVisible(true)
        local dropData = limitData.dropItem[1]
        self.firstExtraDia:setString(dropData[2])
    else
        self.limitNode:setVisible(false)
    end

    -- 倒计时
    if self.data.lEndTime - global.dataMgr:getServerTime() >= 0 then 
      
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
        end
        self:updateOverTimeUI()
    end 
    
    if self.data.hidetimer then 

       self.timer_node:setVisible(false)
        
        self.gift_name_text:setPositionY(self.timer_node:getPositionY())
    end 
end

function UIRechargeNode:updateOverTimeUI()

    self.overtime= self.data.lEndTime - global.dataMgr:getServerTime()
    -- local curr = global.dataMgr:getServerTime()
    -- local rest = math.floor(self.lEndTime - curr)
    if  self.overtime < 0 then 
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
          self.overtime  = 0 
    end 
    self.time:setString(global.funcGame.formatTimeToHMS(self.overtime))
end 


function UIRechargeNode:clickHandler(sender, eventType)
    print("ok",eventType, self.isinvalid  )
    if self.isinvalid then 
        if eventType ==  2 then
            global.tipsMgr:showWarning("gift_sold_out")
        end 
        return 
    end 

    local sPanel = global.panelMgr:getPanel("UIRechargePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end
        self.data.time = self.overtime 
        global.panelMgr:openPanel("UIADGiftPanel"):setData(self.data.id, handler(self, self.buySuccess))
        global.loginApi:clickPointReport(nil,20,self.data.id,nil)
    end

end

function UIRechargeNode:buySuccess(msg)
  local sPanel = global.panelMgr:getPanel("UIRechargePanel")
  sPanel:refresh(self.data)
end

function UIRechargeNode:onExit( )
   self:closeTimer()
end

--CALLBACKS_FUNCS_END

return UIRechargeNode

--endregion
