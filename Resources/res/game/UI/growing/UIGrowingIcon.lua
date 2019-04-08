--region UIGrowingIcon.lua
--Author : zzl
--Date   : 2018/02/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGrowingIcon  = class("UIGrowingIcon", function() return gdisplay.newWidget() end )

function UIGrowingIcon:ctor()
end

function UIGrowingIcon:CreateUI()
    local root = resMgr:createWidget("growing_up/growing_icon")
    self:initUI(root)
end

function UIGrowingIcon:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "growing_up/growing_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.red_bg = self.root.Button_1.red_bg_export
    self.describe = self.root.Button_1.red_bg_export.describe_mlan_5_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:click_call(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGrowingIcon:click_call(sender, eventType)

    global.panelMgr:openPanel("UIGrowingPanel")
end
--CALLBACKS_FUNCS_END


function UIGrowingIcon:onEnter()


    local nodeTimeLine =resMgr:createTimeline("growing_up/growing_icon")

    self.root:runAction(nodeTimeLine)

    nodeTimeLine:play("animation0",true)



end 

function UIGrowingIcon:onEixt()
    
end 

function UIGrowingIcon:setData(data)

    -- self.data = data 

end 

return UIGrowingIcon

--endregion
