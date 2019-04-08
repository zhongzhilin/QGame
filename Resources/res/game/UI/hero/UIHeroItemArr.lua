--region UIHeroItemArr.lua
--Author : anlitop
--Date   : 2017/10/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroItem = require("game.UI.hero.UIHeroItem")
--REQUIRE_CLASS_END

local UIHeroItemArr  = class("UIHeroItemArr", function() return gdisplay.newWidget() end )

function UIHeroItemArr:ctor()
    self:CreateUI()
end

function UIHeroItemArr:CreateUI()
    local root = resMgr:createWidget("hero/heroItem2")
    self:initUI(root)
end

function UIHeroItemArr:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/heroItem2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.item_1 = UIHeroItem.new()
    uiMgr:configNestClass(self.item_1, self.root.item_1)
    self.item_2 = UIHeroItem.new()
    uiMgr:configNestClass(self.item_2, self.root.item_2)
    self.item_3 = UIHeroItem.new()
    uiMgr:configNestClass(self.item_3, self.root.item_3)
    self.hero_bottom = self.root.hero_bottom_export
    self.hero_top = self.root.hero_top_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function UIHeroItemArr:setData(data)

    self.data = data 

    for index ,v in ipairs(data) do 

        if   self["item_"..index] then 
             self["item_"..index]:setData(v) 
        end 

    end 

    self.hero_bottom:setVisible(data.bottombanner)
    self.hero_top:setVisible(data.topbanner)

end 

return UIHeroItemArr

--endregion
