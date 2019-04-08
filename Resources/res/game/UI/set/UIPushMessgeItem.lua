--region UIPushMessgeItem.lua
--Author : anlitop
--Date   : 2017/03/31
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetSwitch = require("game.UI.set.UISetSwitch")
--REQUIRE_CLASS_END

local UIPushMessgeItem  = class("UIPushMessgeItem", function() return gdisplay.newWidget() end )

function UIPushMessgeItem:ctor()
    self:CreateUI()
end

function UIPushMessgeItem:CreateUI()
    local root = resMgr:createWidget("settings/settings_message_node")
    self:initUI(root)
end

function UIPushMessgeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_message_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.message_type = self.root.message_type_export
    self.message_content = self.root.message_content_export
    self.switch = UISetSwitch.new()
    uiMgr:configNestClass(self.switch, self.root.switch)

--EXPORT_NODE_END
    self.switch:addEventListener(function(isOpen)
        self.data.status = isOpen
        self:requestSwitch(isOpen)
    end)
end

function UIPushMessgeItem:requestSwitch(status)
    local id = self.data.id
    global.PushInfoAPI:operateSwitch(1,id,function(reg,msg) end)
end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPushMessgeItem:setData(data)
    self.data =data
    self:updateUI()
end 

function UIPushMessgeItem:updateUI()
    self.switch:setSelect(self.data.status,false ,true)
    self.message_type:setString(self.data.title)
    self.message_content:setString(self.data.text)
end 

function UIPushMessgeItem:onClick(sender, eventType)
end
--CALLBACKS_FUNCS_END

return UIPushMessgeItem

--endregion
