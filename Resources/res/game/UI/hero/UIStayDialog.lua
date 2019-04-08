--region UIStayDialog.lua
--Author : untory
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIStayDialog  = class("UIStayDialog", function() return gdisplay.newWidget() end )

function UIStayDialog:ctor()
    self:CreateUI()
end

function UIStayDialog:CreateUI()
    local root = resMgr:createWidget("hero/hero_detain_bg")
    self:initUI(root)
end

function UIStayDialog:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_detain_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.info = self.root.Node_export.info_mlan_54_export
    self.btn_magic_discount = self.root.Node_export.btn_magic_discount_export
    self.oldPrice = self.root.Node_export.btn_magic_discount_export.oldPrice_export
    self.linePic = self.root.Node_export.btn_magic_discount_export.oldPrice_export.linePic_export
    self.gift_discount_newprice_text = self.root.Node_export.btn_magic_discount_export.gift_discount_newprice_text_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_magic_discount, function(sender, eventType) self:bt_gift_discount_buy(sender, eventType) end)
--EXPORT_NODE_END
end

function UIStayDialog:setData(data)

    self.data = data   

    local gift_arr = global.luaCfg:gift()

    print(#gift_arr,"gift_arr/////")

    self.gift  = nil 

    for _ ,v in pairs(gift_arr) do 

        if v.dropid == self.data.heroId  then 

            self.gift = v  
            break
        end 
    end     


    if not self.gift then 

        self.btn_magic_discount:setVisible(self.gift)

        return 
    end

    self.oldPrice:setString(self.gift.unit..self.gift.price)
    self.linePic:setContentSize(cc.size(self.oldPrice:getContentSize().width, self.linePic:getContentSize().height))
    self.gift_discount_newprice_text:setString(self.gift.unit..self.gift.cost)


    local str = global.luaCfg:get_translate_string(10840, self.gift.unit..self.gift.cost, self.data.name)

    self.info:setString(str)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

 
function UIStayDialog:exitCall(sender, eventType)

    global.panelMgr:closePanel("UIStayDialog")

end


function UIStayDialog:bt_gift_discount_buy(sender, eventType)
    
    if not  self.gift then

        print("error // 98")
        return
    end 

    global.sdkBridge:app_sdk_pay( self.gift.id,function()

        global.panelMgr:closePanel("UIStayDialog")

        if  self.gift.id == global.advertisementData.firstRechargeId then 

            local item = global.luaCfg:get_drop_by( self.gift.dropid).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item, true )
            global.userData:setFirstPay(false)
        else 

            global.panelMgr:openPanel("UIGotHeroPanel"):setData(self.data)
        end 

    end)

end
--CALLBACKS_FUNCS_END

return UIStayDialog

--endregion
