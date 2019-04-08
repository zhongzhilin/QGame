--region UIUShopWidget.lua
--Author : wuwx
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUShopWidget  = class("UIUShopWidget", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIUShopWidget:ctor()
    -- self:CreateUI()
end

function UIUShopWidget:CreateUI()
    local root = resMgr:createWidget("union/union_shop_widget")
    self:initUI(root)
end

function UIUShopWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_shop_widget")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon_view = self.root.icon_view_export
    self.icon = self.root.icon_export
    self.count_text = self.root.count_text_export
    self.xian = self.root.xian_export

--EXPORT_NODE_END
end

function UIUShopWidget:setData(data,itemData)
    self.data = data
    local dData = global.luaCfg:get_union_shop_by(data.lID)

    -- self.icon:setSpriteFrame(itemData.itemIcon)
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)


    local quality = itemData.quality
    if quality == 0 then quality = 1 end
    -- self.icon_view:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",quality))
    global.panelMgr:setTextureFor(self.icon_view,string.format("icon/item/item_bg_0%d.png",quality))

    if data.lCurCount then
        self.count_text:setString(data.lCurCount)
    end

    --限购标识
    self:showLimit(dData.personal > 0 )
    --限量显示数量
    self:showCount(dData.limited > 0)
    
    local tempdata = {data =  self.data , information = itemData}         
    if self.data.tips_node then 
        if self.m_TipsControl then 
             self.m_TipsControl:updateData(tempdata)
        else 
            self.m_TipsControl = UIItemTipsControl.new()
            self.m_TipsControl:setdata(self.icon,tempdata,self.data.tips_node)
        end 
    end 
end

function UIUShopWidget:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl = nil 
    end 
end


function UIUShopWidget:showLimit(isShow)
    self.xian:setVisible(isShow)
end

function UIUShopWidget:showCount(isShow)
    self.count_text:setVisible(isShow)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUShopWidget

--endregion
