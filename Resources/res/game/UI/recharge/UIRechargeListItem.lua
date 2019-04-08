--region UIRechargeListItem.lua
--Author : anlitop
--Date   : 2017/11/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRechargeListItem  = class("UIRechargeListItem", function() return gdisplay.newWidget() end )

function UIRechargeListItem:ctor()
    self:CreateUI()
end

function UIRechargeListItem:CreateUI()
    local root = resMgr:createWidget("recharge/recharge_list_icon")
    self:initUI(root)
end

function UIRechargeListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/recharge_list_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.light = self.root.light_export
    self.icon = self.root.icon_export
    self.red_bg = self.root.Image.red_bg_export
    self.name = self.root.name_export
    self.red_point = self.root.red_point_export

--EXPORT_NODE_END


end


local panel = global.EasyDev.RECHARGE_PANEL

function UIRechargeListItem:setData(data)
    
    self.data = data 
    local goToPanel = panel[self.data.id]
    self.light:setVisible(goToPanel == global.panelMgr:getTopPanelName())
    self.red_bg:setVisible(goToPanel == global.panelMgr:getTopPanelName())
    self.red_point:setVisible(false)

    local updateCall = function (panel)
        self.red_point:setVisible(false)
        if panel == "UIFundPanel" then 
            for _ , v in ipairs(global.luaCfg:fund()) do 
               if  global.propData:getFundState(v.ID) == 1  then 
                    self.red_point:setVisible(true)
                end 
            end 
        elseif panel == "UIDiamondBankPanel" then 

            self.red_point:setVisible(global.propData:curBankCanGet())

        elseif panel =="UISevenDayRechargePanel" then 

            self.red_point:setVisible(global.rechargeData:isSevenDayRed())
            
        elseif panel == "UIMonthCardPanel" then

            self.red_point:setVisible(global.rechargeData:isMonthGet())
        elseif panel == "UITurntableEnterPanel" then
            self.red_point:setVisible(global.userData:getFreeLotteryCount() <= 0)  -- or global.userData:getDyFreeLotteryCount() <= 0)
        elseif panel == "UIRechargePanelDaily" then
            self.red_point:setVisible(global.userData:getlDailyGiftCount() > 0)
        end  
    end 

    self.name:setString(self.data.texct)

    global.panelMgr:setTextureFor(self.icon, self.data.icon)

    self:addEventListener(global.gameEvent.BANKUPDATE , function () 
        updateCall(goToPanel)
    end)


    self:addEventListener(global.gameEvent.EV_ON_SEVENDAYRECHARGE , function () 
        updateCall(goToPanel)
    end)


    self:addEventListener(global.gameEvent.EV_ON_UI_RECHARGE , function () 
        updateCall(goToPanel)
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES , function () 
        updateCall(goToPanel)
    end)

    self:addEventListener(global.gameEvent.EV_ON_DAILY_GIFT, function ()
        updateCall(goToPanel)
    end)

    updateCall(goToPanel)
end 



--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIRechargeListItem

--endregion
