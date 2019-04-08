--region UIUShopRecordItem.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUShopRecordItem  = class("UIUShopRecordItem", function() return gdisplay.newWidget() end )

function UIUShopRecordItem:ctor()
    self:CreateUI()
end

function UIUShopRecordItem:CreateUI()
    local root = resMgr:createWidget("union/union_show_info_list")
    self:initUI(root)
end

function UIUShopRecordItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_show_info_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.node.bg_export
    self.text1 = self.root.node.text1_export
    self.text2 = self.root.node.text2_export

--EXPORT_NODE_END
end

function UIUShopRecordItem:setData(data)
    self.data = data

    self.text1:setString(global.funcGame.formatTimeToYMDHMS(data.lTime))

    local str = data.szName
    local dData = global.luaCfg:get_union_shop_by(data.lID)
    local itemData = global.luaCfg:get_item_by(dData.itemID)
    if data.lType == 1 then
        --购买记录
        self.text2:setTextColor(cc.c3b(255,226,165))
        str = str..global.luaCfg:get_local_string(10420,data.lCount,itemData.itemName)
    else
        --进货
        self.text2:setTextColor(cc.c3b(87,213,63))
        str = str..global.luaCfg:get_local_string(10422,data.lCount,itemData.itemName)
    end
    self.text2:setString(str)

    self.bg:setVisible((self:getParent():getIdx()+1)%2==1)

    -- global.tools:adjustNodePos(self.text2,self.text3)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUShopRecordItem

--endregion
