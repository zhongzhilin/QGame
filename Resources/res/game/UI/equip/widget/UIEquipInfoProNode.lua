--region UIEquipInfoProNode.lua
--Author : Administrator
--Date   : 2017/03/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local TextScrollControl = require("game.UI.common.UITextScrollControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipInfoProNode  = class("UIEquipInfoProNode", function() return gdisplay.newWidget() end )

function UIEquipInfoProNode:ctor()
    
end

function UIEquipInfoProNode:CreateUI()
    local root = resMgr:createWidget("equip/equip_info_pro_node")
    self:initUI(root)
end

function UIEquipInfoProNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_info_pro_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pro = self.root.pro_export
    self.pro_num = self.root.pro_export.pro_num_export
    self.pro_next = self.root.pro_next_export
    self.pro_num_next = self.root.pro_next_export.pro_num_next_export

--EXPORT_NODE_END
end

function UIEquipInfoProNode:setData(name,num1,num2,isSuccess,isNeedScroll)
    
    if isSuccess == 1 then
        self.pro_num_next:setTextColor(cc.c3b(87,213,63))
        self.pro_next:setTextColor(cc.c3b(87,213,63))
    elseif isSuccess == 0 then
        self.pro_num_next:setTextColor(cc.c3b(255,226,165))
        self.pro_next:setTextColor(cc.c3b(87,213,63))
    elseif isSuccess == -1 then
        self.pro_num_next:setTextColor(cc.c3b(180,29,11))
        self.pro_next:setTextColor(cc.c3b(87,213,63))
    end

    self:setVisible(true)
    self.pro:setString(name)
    self.pro_num:setString(num1)
    self.pro_next:setString(name)

    if isNeedScroll then

        self.pro_num_next:setString(num1)
        TextScrollControl.startScroll(self.pro_num_next,num2,1)
    else
        self.pro_num_next:setString(num2)
    end 

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.pro_num:getParent(),self.pro_num)
    global.tools:adjustNodePosForFather(self.pro_num_next:getParent(),self.pro_num_next)

    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEquipInfoProNode

--endregion
