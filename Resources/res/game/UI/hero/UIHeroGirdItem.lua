--region UIHeroGirdItem.lua
--Author : Untory
--Date   : 2017/11/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIHeroGirdItem  = class("UIHeroGirdItem", function() return gdisplay.newWidget() end )

function UIHeroGirdItem:ctor()
    self:CreateUI()
end

function UIHeroGirdItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_Pokedex_list")
    self:initUI(root)
end

function UIHeroGirdItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_Pokedex_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.button_node = self.root.button_node_export
    self.hero_icon = self.root.button_node_export.Button_1.Button_29.hero_icon_export
    self.left = self.root.button_node_export.Button_1.Button_29.left_export
    self.right = self.root.button_node_export.Button_1.Button_29.right_export
    self.hero_type = self.root.button_node_export.Button_1.Button_29.hero_type_export
    self.hero_name = self.root.button_node_export.Button_1.Button_29.hero_name_export
    self.already_get = self.root.button_node_export.Button_1.Button_29.already_get_mlan_5_export
    self.FileNode_1 = UIHeroStarList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.button_node_export.Button_1.Button_29.FileNode_1)
    self.unlock_come_lv = self.root.button_node_export.Button_1.unlock_come_lv_export

--EXPORT_NODE_END
    self.button_node.Button_1.Button_29:setSwallowTouches(false)
    self.button_node.Button_1:setSwallowTouches(false)
end

function UIHeroGirdItem:setData(data)


    self.hero_name:setString(data.name)
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon)    
    self.hero_type:loadTexture(data.typeIcon, ccui.TextureResType.plistType)
    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)


    -- global.colorUtils.turnGray(self.root, not (data.state == 1 or data.state == 3 or data.state == 4) )
    
    if global.panelMgr:isPanelOpened('UIHeroComePool') then

        if data.isTurnTableHalf then
            self.already_get:setVisible(false)
            self.unlock_come_lv:setVisible(false)
            global.colorUtils.turnGray(self.button_node.Button_1.Button_29, false)
        else 
            self.already_get:setVisible(data.state == 1 or data.state == 3 or data.state == 4)
            self.unlock_come_lv:setVisible(false)
            global.colorUtils.turnGray(self.button_node.Button_1.Button_29, not (data.state == 1 or data.state == 3 or data.state == 4 or data.isWillCome))
            if not (data.state == 1 or data.state == 3 or data.state == 4 or data.isWillCome) then
                self.unlock_come_lv:setVisible(true)
                self.unlock_come_lv:setString(global.luaCfg:get_local_string(11141,data.comeLv))
            end
        end
        self:setScale(0.93)
    else
        self:setScale(1)
        self.unlock_come_lv:setVisible(false)
        self.already_get:setVisible(false)
        global.colorUtils.turnGray(self.button_node.Button_1.Button_29, not (data.state == 1 or data.state == 3 or data.state == 4))
    end

    if data.serverData then 
        self.FileNode_1:setData(data.heroId,data.serverData.lStar or 1)
    else
        self.FileNode_1:setData(data.heroId,1)
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIHeroGirdItem

--endregion
