--region BuildListItem.lua
--Author : wuwx
--Date   : 2016/07/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildListItem  = class("BuildListItem", function() return gdisplay.newWidget() end )

function BuildListItem:ctor()
    
end

function BuildListItem:CreateUI()
    local root = resMgr:createWidget("city/build_icon")
    self:initUI(root)
end

function BuildListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.node_gray = self.root.btn_export.node_gray_export
    self.gray = self.root.btn_export.node_gray_export.gray_export
    self.icon = self.root.btn_export.node_gray_export.icon_export
    self.name = self.root.btn_export.name_export

--EXPORT_NODE_END
	self.btn:setSwallowTouches(false)
	-- self.btn:setPressedActionEnabled(true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


-- function BuildListItem:onOperateHandler(sender, eventType)
-- end

--CALLBACKS_FUNCS_END
function BuildListItem:setData(listdata,data)

    local picName = listdata.listIcon
    -- self.icon:loadTexture(picName,ccui.TextureResType.plistType)
    -- self.icon:setSpriteFrame(picName)
    global.panelMgr:setTextureFor(self.icon,picName)
    self.icon:setScale(listdata.scale/100)
	self.name:setString(listdata.buildsName)
    self.btn:setName("guide_building_widget" .. listdata.id)

    local isEnough = global.cityData:checkCondition(data)
    -- self.gray:setVisible(not isEnough)
    global.colorUtils.turnGray(self.node_gray, not isEnough)
end

function BuildListItem:getBtn()
    return self.btn
end

return BuildListItem

--endregion
