--region UITaskDescGiftItem.lua
--Author : untory
--Date   : 2016/08/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITaskDescGiftItem  = class("UITaskDescGiftItem", function() return gdisplay.newWidget() end )

function UITaskDescGiftItem:ctor()
  
  self:CreateUI()  
end

function UITaskDescGiftItem:CreateUI()
    local root = resMgr:createWidget("task/task_second_node")
    self:initUI(root)
end

function UITaskDescGiftItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_second_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Image_8 = self.root.Image_8_export
    self.bg = self.root.bg_export
    self.icon = self.root.icon_export
    self.name = self.root.name_export
    self.count = self.root.count_export

--EXPORT_NODE_END
    global.funcGame:initBigNumber(self.count, 1)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function UITaskDescGiftItem:setData(msg)

	local itemId = msg[1]
	local itemNum = msg[2]

	local itemData = luaCfg:get_item_by(itemId)
	local itemName = itemData.itemName
	local itemIcon = itemData.itemIcon

	self.name:setString(itemName)

    if itemId < 6 then
        self.icon:setScale(1)
    else
        self.icon:setScale(0.3)
    end
    
    local quality = itemData.quality
    if quality == 0 then quality = 1 end
    -- self.bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",quality))
    
    -- self.icon:setSpriteFrame(itemIcon)
    global.panelMgr:setTextureFor(self.icon,itemIcon)
    global.panelMgr:setTextureFor(self.bg,string.format("icon/item/item_bg_0%d.png",quality))

	self.count:setString(itemNum)

    -- self.Image_8:setVisible(index % 2 ~= 0)
end

return UITaskDescGiftItem

--endregion
