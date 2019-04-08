--region UIChestBuyPanel.lua
--Author : anlitop
--Date   : 2017/07/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChestBuyPanel  = class("UIChestBuyPanel", function() return gdisplay.newWidget() end )

local dailyTaskData = global.dailyTaskData

function UIChestBuyPanel:ctor()
    self:CreateUI()
end

function UIChestBuyPanel:CreateUI()
    local root = resMgr:createWidget("chest/addCount")
    self:initUI(root)
end

function UIChestBuyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chest/addCount")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.use_btn = self.root.Node_export.use_btn_export
    self.gray_spite = self.root.Node_export.use_btn_export.gray_spite_export
    self.diamond = self.root.Node_export.use_btn_export.diamond_export
    self.Title = self.root.Node_export.node.Title_export
    self.describe = self.root.Node_export.node.describe_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.use_btn, function(sender, eventType) self:confirm(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIChestBuyPanel:exit_click(sender, eventType)

    global.panelMgr:closePanel("UIChestBuyPanel")

end


function UIChestBuyPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 

         self:setData(self.type , self.panel)

    end)


    self:addEventListener(global.gameEvent.EV_ON_DAILY_REGISTER,function() 

        self:setData(self.type , self.panel)

    end)

end 


function UIChestBuyPanel:setData(buy_type , panel)

    print("set data 中文//////////////////")

    self.type = buy_type 

    self.panel  = panel 

    print( self.type ," self.type ")
    
    print(  self.panel  ,"  self.panel  ")

    local count  = 0 

    local configinfo = nil

    if self.type  ==3 then 

        count = dailyTaskData:getFreeCostCout()+1

        configinfo = global.luaCfg:get_free_chest_by(1)


    elseif self.type  == 4 then 

        count =  dailyTaskData:getMonsterCostCout()+1

        configinfo = global.luaCfg:get_wild_chest_by(2)

    end  

    if not  count   or count <= 0 then 
        count = 1 
    end

    if not configinfo then 
        global.tipsMgr:showWarning("config erro")        
        return 
    end 

    if count > configinfo.maxCost then 
        count = configinfo.maxCost 
    end 

    print(count,"count")

    self.cost = tonumber(configinfo["cost"..count])

    self.DIAMOND = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

    self.diamond:setString(tostring(self.cost))

-- 
    print(self.DIAMOND ,"self.DIAMOND")

    print(self.cost , "self.cost")


    if  self.type == 3 then 

        self.Title:setString(global.luaCfg:get_localization_by(10848).value)

        global.uiMgr:setRichText(self,"describe",50094,{num=self.cost})
    else 

        self.Title:setString(global.luaCfg:get_localization_by(10716).value)
        global.uiMgr:setRichText(self,"describe",50148,{num=self.cost})
    end 

    -- local str = string.format(global.luaCfg:get_localization_by(10717).value ,self.cost)
    -- self.describe:setString(str)


    if self.cost > self.DIAMOND then 

        self.diamond:setTextColor(gdisplay.COLOR_RED)
    else 
        
        self.diamond:setTextColor(gdisplay.COLOR_WHITE)
    end 

end 

function UIChestBuyPanel:confirm(sender, eventType)

    if self.cost > self.DIAMOND then 

        global.tipsMgr:showWarning("ItemUseDiamond")

        return 
    end 

    global.taskApi:getRewardBag(self.type, function(msg)

        if not self.panel then return end 

        self.panel:cleanTimer()

        if self.type == 3 then 

            self.panel:freeBagHandler()
            dailyTaskData:initFreeBagNum(msg.tgPack,true)

        elseif self.type == 4 then 

            dailyTaskData:initVipBagNum(msg.tgPack, true)
        end 
 
        self.panel:setData()

        self:exit_click()

    end, 1)

end
--CALLBACKS_FUNCS_END

return UIChestBuyPanel

--endregion
