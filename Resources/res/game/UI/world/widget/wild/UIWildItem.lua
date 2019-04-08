--region UIWildItem.lua
--Author : yyt
--Date   : 2016/12/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildItem  = class("UIWildItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
function UIWildItem:ctor()
    
end

function UIWildItem:CreateUI()
    local root = resMgr:createWidget("wild/wild_item")
    self:initUI(root)
end

function UIWildItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_1.quit_export
    self.icon = self.root.Node_1.icon_export
    self.count_text = self.root.Node_1.count_text_export
    self.itemName = self.root.Node_1.itemName_export
    self.rare_item = self.root.Node_1.rare_item_export
    self.item_name = self.root.Node_1.rare_item_export.item_name_mlan_3_export

--EXPORT_NODE_END


    self.rate = self.item_name

end

function UIWildItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end


function UIWildItem:setData(data, bossId)
    -- body
    self.data = data 
    self.m_TipsControl = UIItemTipsControl.new()
    self.m_TipsControl:setdata(self.icon,data,data.tips_node)
    self.rare_item:setVisible(false)

    if bossId ~= nil then

        local itemId = data.information.itemId or data.information.id
        local wildData = global.luaCfg:get_wild_monster_by(bossId) or {}
        wildData.seeitem2 = wildData.seeitem2 or {}

        for i,v in ipairs(wildData.seeitem2) do
            if v == itemId then
                self.rare_item:setVisible(true)
                self.rate:setString(gls(11127))
                break
            end
        end

        if not  self.rare_item:isVisible()  then 
            for i,v in ipairs(wildData.seeitem3) do
                if v == itemId then
                    self.rare_item:setVisible(true)
                    self.rate:setString(gls(11128))
                    break
                end
            end
        end 
    end


end

 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWildItem

--endregion
