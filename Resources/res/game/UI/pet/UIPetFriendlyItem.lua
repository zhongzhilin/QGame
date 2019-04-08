--region UIPetFriendlyItem.lua
--Author : yyt
--Date   : 2017/12/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetFriendlyItem  = class("UIPetFriendlyItem", function() return gdisplay.newWidget() end )

function UIPetFriendlyItem:ctor()
    self:CreateUI()
end

function UIPetFriendlyItem:CreateUI()
    local root = resMgr:createWidget("pet/pet_fourth_node")
    self:initUI(root)
end

function UIPetFriendlyItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_fourth_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.wy_btn = self.root.Node_2.wy_btn_export
    self.consum = self.root.Node_2.consum_mlan_10_export
    self.consumeNum = self.root.Node_2.consumeNum_export
    self.friend = self.root.Node_2.friend_mlan_10_export
    self.add = self.root.Node_2.add_export
    self.friendNum = self.root.Node_2.add_export.friendNum_export
    self.quit = self.root.Node_2.quit_export
    self.icon = self.root.Node_2.icon_export

    uiMgr:addWidgetTouchHandler(self.wy_btn, function(sender, eventType) self:feedHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.wy_btn:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

local iconPic = {
    [1] = "icon/item/item_icon_002.png",
    [2] = "icon/item/item_icon_004.png",
    [3] = "icon/item/item_icon_001.png",
    [4] = "icon/item/item_icon_003.png",
}

function UIPetFriendlyItem:setData(data)
    
    self.data = data
    local itemData = luaCfg:get_item_by(data.id)
    global.panelMgr:setTextureFor(self.icon, iconPic[data.id])
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    self.consumeNum:setString(data.resources)
    self.friendNum:setString(data.friendly)

    global.tools:adjustNodePos(self.consum , self.consumeNum)
    global.tools:adjustNodePos(self.friend , self.add)

end

function UIPetFriendlyItem:feedHandler(sender, eventType)
    
    if eventType == ccui.TouchEventType.began then
        global.petFriPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if global.petFriPanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
        -- 达到满级
        if global.petData:isGodAnimalMaxLv(global.petFriPanel.data.type) then
            return global.tipsMgr:showWarning("petLvMax")
        end

        global.panelMgr:openPanel("UIFeedResPanel"):setData(self.data)
    end
    
end

--CALLBACKS_FUNCS_END

return UIPetFriendlyItem

--endregion
