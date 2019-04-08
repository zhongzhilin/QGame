--region UIEqipNode.lua
--Author : anlitop
--Date   : 2017/08/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEqipNode  = class("UIEqipNode", function() return gdisplay.newWidget() end )

function UIEqipNode:ctor()
end

function UIEqipNode:CreateUI()
    local root = resMgr:createWidget("player/node/player_equip")
    self:initUI(root)
end

function UIEqipNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/player_equip")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.equipment_bg2 = self.root.equipment_bg2_export
    self.icon2 = self.root.equipment_bg2_export.iconParent.icon2_export
    self.qeuipment_bg3 = self.root.equipment_bg2_export.qeuipment_bg3_export
    self.strog = self.root.equipment_bg2_export.strog_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UIEqipNode:setData(data) 


    self.icon2:setVisible(true)

    global.panelMgr:setTextureFor(self.equipment_bg2,string.format("icon/item/item_bg_0%d.png",data.quality))
    global.panelMgr:setTextureFor(self.icon2,data.icon)

end 


local img  = "ui_surface_icon/equipment_%s.png"
local img2  = "ui_surface_icon/hero_equipment_bg.png"

function UIEqipNode:reset(i)

    self.equipment_bg2:setSpriteFrame(img2)

    self.icon2:setVisible(false)

    self.qeuipment_bg3:setSpriteFrame(string.format(img, i))
end 

return UIEqipNode

--endregion
