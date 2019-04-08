--region UILeveL_item.lua
--Author : anlitop
--Date   : 2017/03/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILeveL_item  = class("UILeveL_item", function() return gdisplay.newWidget() end )

function UILeveL_item:ctor()
    self:CreateUI()
end

function UILeveL_item:CreateUI()
    local root = resMgr:createWidget("vip/level_item")
    self:initUI(root)
end

function UILeveL_item:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "vip/level_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.vip_level_bg = self.root.vip_level_bg_export
    self.number = self.root.vip_level_bg_export.number_export

--EXPORT_NODE_END
end

function UILeveL_item:setData(data)
  -- isavliad 
  -- level 
  self.data =data 
  self:updateUI()
end 

function UILeveL_item:updateUI()
  global.colorUtils.turnGray(self.vip_level_bg,self.data.isvalid)
  self.number:setString(self.data.level)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UILeveL_item

--endregion
