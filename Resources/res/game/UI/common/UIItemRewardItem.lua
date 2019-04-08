--region UIItemRewardItem.lua
--Author : Administrator
--Date   : 2016/08/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIItemRewardItem  = class("UIItemRewardItem", function() return gdisplay.newWidget() end )

function UIItemRewardItem:ctor()
    
    self:CreateUI()
end

function UIItemRewardItem:CreateUI()
    local root = resMgr:createWidget("bag/bag_reward_item")
    self:initUI(root)
end

function UIItemRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_reward_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.Image_3.icon_export
    self.count = self.root.Image_3.count_export
    self.name = self.root.Image_3.name_export
    self.quality = self.root.Image_3.quality_export

--EXPORT_NODE_END

end

function UIItemRewardItem:setData(data)
	-- body

    local itemId = data[1]
	local itemData = luaCfg:get_item_by(itemId)
	local count = data[2]

    self.icon:setScale(0.4)
    if not itemData then

        local equipData = luaCfg:get_equipment_by(itemId)
        self.name:setString(equipData.name)
        self.count:setString(string.format("+%d",count))
        global.panelMgr:setTextureFor(self.quality,string.format("icon/item/item_bg_0%d.png",equipData.quality))
        global.panelMgr:setTextureFor(self.icon,equipData.icon)
    else        

        local scaleSpec = {[7]=1.2, [8]=1.2}
        local whiteList = {[6]="",[9]=""}
        if itemId < 100 and  (not whiteList[itemId]) then
            self.icon:setScale(1)
            if scaleSpec[itemId] then
                self.icon:setScale(scaleSpec[itemId])
            end
        end

        local q = itemData.quality > 0 and itemData.quality or 0
        global.panelMgr:setTextureFor(self.quality,string.format("icon/item/item_bg_0%d.png",itemData.quality))
        self.name:setString(itemData.itemName)
        self.count:setString(string.format("+%d",count))

        if itemId < 100 then  -- 合图
            self.icon:setSpriteFrame(itemData.itemIcon)
        else
            global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIItemRewardItem

--endregion
