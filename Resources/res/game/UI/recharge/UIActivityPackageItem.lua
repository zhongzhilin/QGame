--region UIActivityPackageItem.lua
--Author : anlitop
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityPackageItem  = class("UIActivityPackageItem", function() return gdisplay.newWidget() end )

function UIActivityPackageItem:ctor()
    self:CreateUI()
end

function UIActivityPackageItem:CreateUI()
    local root = resMgr:createWidget("recharge/package_list")
    self:initUI(root)
end

function UIActivityPackageItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/package_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.name = self.root.bg_export.name_export
    self.icon = self.root.bg_export.icon_export
    self.buy_gift = self.root.bg_export.buy_gift_export
    self.gift_price_text = self.root.bg_export.buy_gift_export.gift_price_text_export
    self.gift_value_sprite = self.root.bg_export.gift_value_sprite_export
    self.discount = self.root.bg_export.discount_export
    self.time_node = self.root.bg_export.time_node_export
    self.gift_overtime_text = self.root.bg_export.time_node_export.gift_overtime_text_export
    self.vipNode = self.root.bg_export.vipNode_export
    self.vip = self.root.bg_export.vipNode_export.vip_export
    self.diaNode = self.root.bg_export.diaNode_export
    self.gift_icon_sprite = self.root.bg_export.diaNode_export.gift_icon_sprite_export
    self.gift_num_text = self.root.bg_export.diaNode_export.gift_num_text_export
    self.limit_text = self.root.bg_export.limit_text_export

    uiMgr:addWidgetTouchHandler(self.buy_gift, function(sender, eventType) self:onPay(sender, eventType) end)
--EXPORT_NODE_END
    
    self.bg:setSwallowTouches(false)
    self.bg:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIActivityPackageItem:onPay(sender, eventType)

    if not self.data then

        return
     end 

     local data = clone(self.data)

    global.sdkBridge:app_sdk_pay(data.id,function()

        if data.id == global.advertisementData.firstRechargeId then 
            
            local item = global.luaCfg:get_drop_by(data.dropid).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true )

            global.userData:setFirstPay(false)
        else 

            local item = global.luaCfg:get_drop_by(data.dropid).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true )

            global.advertisementData:delDataByPosition2(data)
        end

    end)
    
end

function UIActivityPackageItem:setData(data)

    self.diaNode:setVisible(data.id == 35) 
    local posX = data.id == 35 and 150 or 0
    self.vipNode:setPositionX(posX)

    self.data = data 

    self.name:setString(self.data.name)
    self.gift_num_text:setString(self.data.resource_num)

    if self.data.mini_icon  and self.data.mini_icon ~= "" then 

        -- global.panelMgr:setTextureFor( self.icon,self.data.mini_icon)
        global.panelMgr:setTextureFor(self.icon, self.data.mini_icon)
        -- self.icon:setSpriteFrame(self.data.mini_icon)
    end 

    self.gift_price_text:setString(self.data.unit..self.data.cost)


    self.data.time = self.data.lEndTime - global.dataMgr:getServerTime()

    if  self.data.time >= 0 then 
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
        end
        self:updateOverTimeUI()

    end 

    self.time_node:setVisible(not self.data.hidetimer)


    self.discount:setString(global.advertisementData:getGiftScale(self.data.id))

    self.vip:setString(global.luaCfg:get_gift_by(self.data.id).vip_point)

    global.tools:adjustNodePos(self.name,self.limit_text,5)

end
--CALLBACKS_FUNCS_END

function UIActivityPackageItem:updateOverTimeUI()

    if not self.data then 
         --protect 
        return 
    end 

    self.data.time =self.data.lEndTime - global.dataMgr:getServerTime()
    -- local curr = global.dataMgr:getServerTime()
    -- local rest = math.floor(self.lEndTime - curr)
    if  self.data.time  < 0 then 
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
        -- return
         self.data.time  = 0 
    end 

    self.gift_overtime_text:setString(global.funcGame.formatTimeToHMS( self.data.time ))

end         


return UIActivityPackageItem

--endregion
