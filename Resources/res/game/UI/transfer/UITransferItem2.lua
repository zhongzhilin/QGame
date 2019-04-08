--region UITransferItem2.lua
--Author : zzl
--Date   : 2018/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITransferItem2  = class("UITransferItem2", function() return gdisplay.newWidget() end )

function UITransferItem2:ctor()
    
end

function UITransferItem2:CreateUI()
    local root = resMgr:createWidget("resource/res_transport_node2")
    self:initUI(root)
end

function UITransferItem2:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_transport_node2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.food_num = self.root.food_num_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITransferItem2:setData(data)
    self.data =data 
    self.food_num:setString(data)
end 

function UITransferItem2:res_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UITransferItem2

--endregion
