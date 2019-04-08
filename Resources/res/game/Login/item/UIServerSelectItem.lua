--region UIServerSelectItem.lua
--Author : ethan
--Date   : 2016/05/05
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIServerSelectItem  = class("UIServerSelectItem", function() return gdisplay.newWidget() end )

function UIServerSelectItem:ctor()
    
end

function UIServerSelectItem:CreateUI()
    local root = resMgr:createWidget("login/server_select_item")
    self:initUI(root)
end

function UIServerSelectItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/server_select_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.txt_title = self.root.txt_title_export
    self.txt_name = self.root.txt_name_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

--[1] = {tip=0 id=7007 typ=1 st=2 ver=999999999 addr={} name="philip1" newst=2 sys=7 area=7 }

function UIServerSelectItem:setData(data)
    if data then
        self.txt_title:setString(data.area)
        self.txt_name:setString(data.name)        
    else
        self.txt_title:setString("")
        self.txt_name:setString("")
    end
end

return UIServerSelectItem

--endregion
