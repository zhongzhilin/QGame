--region UIDissMissSoldierPanel.lua
--Author : anlitop
--Date   : 2017/07/26
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END


local luaCfg = global.luaCfg
local UIDissMissSoldierPanel  = class("UIDissMissSoldierPanel", function() return gdisplay.newWidget() end )

local CountSliderControl = require("game.UI.common.UICountSliderControl")

function UIDissMissSoldierPanel:ctor()
    self:CreateUI()
end

function UIDissMissSoldierPanel:CreateUI()
    local root = resMgr:createWidget("hospital/dismiss_sec_bg")
    self:initUI(root)
end

function UIDissMissSoldierPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/dismiss_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.portrait_node = self.root.Node_export.icon_bg.portrait_node_export
    self.manpower = self.root.Node_export.manpower_export
    self.soldier_name = self.root.Node_export.soldier_name_export
    self.tips = self.root.Node_export.tips_export
    self.return_number = self.root.Node_export.return_number_export
    self.touch = self.root.Node_export.touch_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onexit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.dismiss_btn, function(sender, eventType) self:onDismissHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.sliderUpdate), true)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDissMissSoldierPanel:setData(data)

    self.soldierData = luaCfg:get_soldier_property_by(data.lID)

    self.soldier_name:setString(self.soldierData.name)

    global.tools:setSoldierAvatar(self.portrait_node,luaCfg:get_soldier_train_by(data.lID))

    self.scale = luaCfg:get_config_by(1).dismissPro

    self.sliderControl:setMaxCount(data.num)

    local str = global.luaCfg:get_local_string(10754,self.scale)
    self.tips:setString(str)

end 


function UIDissMissSoldierPanel:sliderUpdate()

    local currNum = self.sliderControl:getContentCount()

    local bingyuan =  self.soldierData.perPop * currNum


    self._return_number =math.floor( bingyuan * self.scale / 100 )

    self.manpower:setString(luaCfg:get_local_string(10753, self._return_number))
    self.return_number:setVisible(false)

end 

function UIDissMissSoldierPanel:onDismissHandler(sender, eventType)
    
    global.cityApi:returnSoldierSource(self.soldierData.id, self.sliderControl:getContentCount(),function(msg)
        if msg and msg.tgSoldiers then 
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
        end 
        gevent:call(global.gameEvent.EV_ON_SOLDIERS_UPDATE)

        global.tipsMgr:showWarning("DismissSoilder" , self._return_number)

        self:onexit_call()
    end)
end



function UIDissMissSoldierPanel:onexit_call(sender, eventType)
    global.panelMgr:closePanel("UIDissMissSoldierPanel")
end
--CALLBACKS_FUNCS_END

return UIDissMissSoldierPanel

--endregion
