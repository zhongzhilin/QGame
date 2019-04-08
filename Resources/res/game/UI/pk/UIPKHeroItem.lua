--region UIPKHeroItem.lua
--Author : zzl
--Date   : 2018/02/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroExpChoose = require("game.UI.union.second.exp.UIHeroExpChoose")
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIPKHeroItem  = class("UIPKHeroItem", function() return gdisplay.newWidget() end )

function UIPKHeroItem:ctor()
    
end

function UIPKHeroItem:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_hero_node")
    self:initUI(root)
end

function UIPKHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_hero_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.choose_hero = self.root.choose_hero_export
    self.choose_hero = UIHeroExpChoose.new()
    uiMgr:configNestClass(self.choose_hero, self.root.choose_hero_export)
    self.bt_bg = self.root.bt_bg_export
    self.troops_hero = self.root.bt_bg_export.troops_hero_export
    self.hero_bg = self.root.bt_bg_export.hero_bg_export
    self.nameBg = self.root.bt_bg_export.nameBg_export
    self.nameBg1 = self.root.bt_bg_export.nameBg1_export
    self.heroName = self.root.bt_bg_export.heroName_export
    self.heroLv = self.root.bt_bg_export.heroLv_export
    self.starlist = UIHeroStarList.new()
    uiMgr:configNestClass(self.starlist, self.root.bt_bg_export.starlist)
    self.left = self.root.bt_bg_export.left_export
    self.right = self.root.bt_bg_export.right_export
    self.hero_type = self.root.bt_bg_export.hero_type_export
    self.canchange = self.root.bt_bg_export.canchange_export
    self.default = self.root.default_export

    uiMgr:addWidgetTouchHandler(self.bt_bg, function(sender, eventType) self:click_call(sender, eventType) end)
--EXPORT_NODE_END
    
    self.default:setLocalZOrder(self.choose_hero:getLocalZOrder() + 1 )

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


local luaCfg = global.luaCfg

function UIPKHeroItem:onEnter()
    
    self.default:setVisible(false)
    self.canchange:setVisible(false)
end 

function UIPKHeroItem:onExit()

end 

function UIPKHeroItem:setData(data)

    self.data = data 

    self.bt_bg:setVisible(self.data and self.data.heroId ~=nil )
    self.choose_hero:setVisible(not self.bt_bg:isVisible())
    

    if not self.data or self.data.heroId ==nil then 
        return 
    end 

    local data = global.luaCfg:get_hero_property_by(self.data.heroId)
    global.panelMgr:setTextureFor(self.troops_hero,data.nameIcon)
    self.heroName:setString(data.name)
    if self.data.serverData and self.data.serverData.lGrade then 
        self.heroLv:setString(string.format(luaCfg:get_local_string(10019),self.data.serverData.lGrade))
    end 

    self.hero_type:loadTexture(data.typeIcon, ccui.TextureResType.plistType)
    global.heroData:setHeroIconBg(self.data.heroId, self.left, self.right)

    if self.data.serverData and  self.data.serverData.lStar then 
        self.starlist:setData(self.data.heroId ,self.data.serverData.lStar)
    end 
end


function UIPKHeroItem:click_call(sender, eventType)

end


function UIPKHeroItem:setHeroIcon(heroData)

    dump(heroData ,"chooseHerod")

    self:setData(heroData)
end 


function UIPKHeroItem:item_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIPKHeroItem

--endregion
