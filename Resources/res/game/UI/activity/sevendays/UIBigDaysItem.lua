--region UIBigDaysItem.lua
--Author : anlitop
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBigDaysItem  = class("UIBigDaysItem", function() return gdisplay.newWidget() end )

function UIBigDaysItem:ctor()
    
end

function UIBigDaysItem:CreateUI()
    local root = resMgr:createWidget("activity/sevendays/sevenday_big_btn")
    self:initUI(root)
end

function UIBigDaysItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/sevendays/sevenday_big_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.sevenday_red_btn = self.root.sevenday_red_btn_export
    self.red_sellect = self.root.sevenday_red_btn_export.red_sellect_export
    self.red_point = self.root.sevenday_red_btn_export.red_point_export
    self.red_point_text = self.root.sevenday_red_btn_export.red_point_export.red_point_text_export
    self.sevenday_green_btn = self.root.sevenday_green_btn_export
    self.green_select = self.root.sevenday_green_btn_export.green_select_export
    self.green_point = self.root.sevenday_green_btn_export.green_point_export
    self.green_point_text = self.root.sevenday_green_btn_export.green_point_export.green_point_text_export
    self.day = self.root.day_export
    self.finish = self.root.finish_export

    uiMgr:addWidgetTouchHandler(self.sevenday_red_btn, function(sender, eventType) self:onClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.sevenday_green_btn, function(sender, eventType) self:onClick2(sender, eventType) end)
--EXPORT_NODE_END

    self.sevenday_red_btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.sevenday_green_btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)

    self.green_select:setVisible(false)
    self.red_sellect:setVisible(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBigDaysItem:setData(data , call)

    self.data = data 

    self.call  = call 

     uiMgr:setRichText(self, "day", 50141 ,{num = self.data.index })

    self.sevenday_green_btn:setVisible(self.data.index <= self.data.now_day )

    self.finish:setVisible(self.data.finish)

    self.sevenday_red_btn:setVisible(not self.sevenday_green_btn:isVisible())

    self:updatePointState()

end


function UIBigDaysItem:updateSelect(index)


    if self.data.index == index  then 
        
        self.green_select:setVisible(true)

        self.red_sellect:setVisible(true)
    else
            
        self.green_select:setVisible(false)
        self.red_sellect:setVisible(false)
    
    end  

    self.old_index = index
end 


function UIBigDaysItem:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_SERVERDAY_SELECT_UPDATE,function(event , index)

        self:updatePointState()        

        if index and index == -1 then return end 

        self:updateSelect(index or self.old_index)

    end)

end 

function UIBigDaysItem:updatePointState()

    local status , number = global.ActivityData:getSevenDayRedPointNumber(self.data.index)
    self.red_point:setVisible(status and  global.severDataRequestComplete and self.data.index <= self.data.now_day )
    self.red_point_text:setString(number)
    self.green_point:setVisible(status and  global.severDataRequestComplete and self.data.index <= self.data.now_day )
    self.green_point_text:setString(number)

end 

function UIBigDaysItem:onClick(sender, eventType)
    
    if self.call then 
        self.call()
    end 
    
end

function UIBigDaysItem:onClick2(sender, eventType)

    if self.call then 
        self.call()
    end 
end
--CALLBACKS_FUNCS_END

return UIBigDaysItem

--endregion
