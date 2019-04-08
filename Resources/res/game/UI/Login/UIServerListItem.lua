--region UIServerListItem.lua
--Author : yyt
--Date   : 2016/08/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIServerListItem  = class("UIServerListItem", function() return gdisplay.newWidget() end )

function UIServerListItem:ctor()
    
    self:CreateUI()
end

function UIServerListItem:CreateUI()
    local root = resMgr:createWidget("login/server_list")
    self:initUI(root)
end

function UIServerListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/server_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.titleName = self.root.titleName_export
    self.server_close = self.root.server_close_export
    self.server_open = self.root.server_open_export

--EXPORT_NODE_END
end

function UIServerListItem:setData(data)
    
    self.titleName:setString(data.name)

    if data.state == 0 then
        self.server_close:setVisible(true)
        self.server_open:setVisible(false)
    else 
        self.server_close:setVisible(false)
        self.server_open:setVisible(true)
    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIServerListItem

--endregion
