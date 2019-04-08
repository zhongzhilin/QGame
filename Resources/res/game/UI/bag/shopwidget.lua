--region shopwidget.lua
--Author : anlitop
--Date   : 2017/03/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local shopwidget  = class("shopwidget", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function shopwidget:ctor()
    -- self:CreateUI()
end

function shopwidget:CreateUI()
    local root = resMgr:createWidget("bag/shop_widget")
    self:initUI(root)

end

function shopwidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/shop_widget")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_view = self.root.icon_view_export
    self.icon = self.root.icon_export
    self.xian = self.root.xian_export

--EXPORT_NODE_END


end

function shopwidget:onExit()
    
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl = nil 
    end 
end


function shopwidget:setData(data)
    -- body
    self.data  =data 

    if self.m_TipsControl then
        self.m_TipsControl:updateData(data)
    else 
        self.m_TipsControl = UIItemTipsControl.new()
        self.m_TipsControl:setdata(self.icon,data,data.tips_node)
    end 
     
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return shopwidget

--endregion
