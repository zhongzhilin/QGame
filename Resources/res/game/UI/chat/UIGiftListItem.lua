--region UIGiftListItem.lua
--Author : yyt
--Date   : 2018/02/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGiftListItem  = class("UIGiftListItem", function() return gdisplay.newWidget() end )

function UIGiftListItem:ctor()
    self:CreateUI()
end

function UIGiftListItem:CreateUI()
    local root = resMgr:createWidget("chat/chat_unionGiftListNode")
    self:initUI(root)
end

function UIGiftListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_unionGiftListNode")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_node = self.root.portrait_node_export
    self.headFrame = self.root.portrait_node_export.headFrame_export
    self.name = self.root.name_export
    self.time = self.root.time_export
    self.quit = self.root.item.quit_export
    self.itemName = self.root.item.itemName_export
    self.icon = self.root.item.icon_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGiftListItem:setData(data)
    -- body
    local head = {}
    head.path = luaCfg:get_rolehead_by(data.lFaceID or 101).path
    head.scale = 85
    global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data,head))

    if not data.lBackID then 
        self.headFrame:setVisible(false)
    else
        self.headFrame:setVisible(true)
        local info = luaCfg:get_role_frame_by(data.lBackID) or luaCfg:get_role_frame_by(1)
        if data.lFrom == global.userData:getUserId() then
            info = global.userheadframedata:getCrutFrame()
        end       
        global.panelMgr:setTextureFor(self.headFrame, info.pic)
    end 
    self.name:setString(data.szName or "")

    if data.tagItem and data.tagItem[1] then
        local itemId = data.tagItem[1].lID
        local itemData = luaCfg:get_item_by(itemId) or luaCfg:get_equipment_by(itemId)
        if itemData then
            global.panelMgr:setTextureForAsync(self.icon, itemData.itemIcon or itemData.icon, true)
            global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
            self.itemName:setString(itemData.itemName or itemData.name)
        end
    end

    self.time:setString(global.funcGame.formatTimeToMDHMS(data.lAddTime or global.dataMgr:getServerTime()))

end

--CALLBACKS_FUNCS_END

return UIGiftListItem

--endregion
