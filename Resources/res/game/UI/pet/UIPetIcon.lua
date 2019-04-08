--region UIPetIcon.lua
--Author : yyt
--Date   : 2017/12/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetIcon  = class("UIPetIcon", function() return gdisplay.newWidget() end )

function UIPetIcon:ctor()
    self:CreateUI()
end

function UIPetIcon:CreateUI()
    local root = resMgr:createWidget("pet/pet_page_node")
    self:initUI(root)
end

function UIPetIcon:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_page_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.nodePos = self.root.nodePos_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetIcon:setData(data)
	-- body
    if not data then return end
    local node = resMgr:createCsbAction(data.Animation, "animation0" , true)
    node:setPosition(self.nodePos:getPosition())
    local petConfig = global.luaCfg:get_pet_type_by(data.type)
    node:setScale(petConfig.scale[data.growingPhase])
    self.root:addChild(node)
end

--CALLBACKS_FUNCS_END

return UIPetIcon

--endregion
