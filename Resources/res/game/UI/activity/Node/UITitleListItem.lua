--region UITitleListItem.lua
--Author : zzl
--Date   : 2017/12/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITitleListItem  = class("UITitleListItem", function() return gdisplay.newWidget() end )

function UITitleListItem:ctor()
    
end

function UITitleListItem:CreateUI()
    local root = resMgr:createWidget("activity/activity_btns/title_list_item")
    self:initUI(root)
end

function UITitleListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_btns/title_list_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.light = self.root.light_export
    self.icon = self.root.icon_export
    self.red_bg = self.root.Image.red_bg_export
    self.name = self.root.name_export
    self.red_point = self.root.red_point_export

    uiMgr:addWidgetTouchHandler(self.root.Button_7, function(sender, eventType) self:click_call(sender, eventType) end)
--EXPORT_NODE_END

    --新手引导
    self.Button_7 = self.root.Button_7
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITitleListItem:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_ACTIVITY_RED, function ()
        if self.checkRedPoint then
            self:checkRedPoint()
        end
    end)
end

local activity_type = global.EasyDev.activity_type

function UITitleListItem:setData(data) 

    self.data = data 
    

    self.Button_7:setName("guide" .. self.data.id)

    local chooseType = global.panelMgr:getPanel("UIActivityPanel").activity_type

    self.light:setVisible(chooseType == activity_type[self.data.id])
    self.red_bg:setVisible(chooseType == activity_type[self.data.id])
    self.name:setString(self.data.texct)
    global.panelMgr:setTextureFor( self.icon,self.data.icon)

    self:checkRedPoint()

end 

function UITitleListItem:checkRedPoint()
    self.red_point:setVisible(false)
    if  self.data.id == 2 then
        self.red_point:setVisible(global.ActivityData:isActivityRed())
    end
end


function UITitleListItem:click_call(sender, eventType)
   global.panelMgr:getPanel("UIActivityPanel"):setData(activity_type[self.data.id])
end
--CALLBACKS_FUNCS_END

return UITitleListItem

--endregion
