--region UIHeroListItem.lua
--Author : yyt
--Date   : 2016/09/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIHeroListItem  = class("UIHeroListItem", function() return gdisplay.newWidget() end )

function UIHeroListItem:ctor()
    
    self:CreateUI()
end

function UIHeroListItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_node1")
    self:initUI(root)
end

function UIHeroListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_node1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btnBg = self.root.btnBg_export
    self.hero_icon = self.root.hero_icon_export
    self.hero_type = self.root.hero_type_export
    self.hero_name = self.root.hero_name_export
    self.hero_name1 = self.root.hero_name1_export
    self.hero_nameLv = self.root.hero_nameLv_export
    self.right = self.root.right_export
    self.left = self.root.left_export
    self.select_bg = self.root.select_bg_export
    self.equipState = self.root.equipState_export
    self.FileNode_1 = UIHeroStarList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.btnBg, function(sender, eventType) self:heroItem_click(sender, eventType) end)
--EXPORT_NODE_END
    self.btnBg:setSwallowTouches(false)
    self.itemSwitch = {}
    self.selectHeroPanel = global.panelMgr:getPanel("UISelectHeroPanel")
    self.heroPanel = global.panelMgr:getPanel("UIHeroPanel")
end

function UIHeroListItem:setData( data )
    
    self.data = data
    self.btnBg:setName("heorlistitem" .. self.data.heroId)
    self.equipState:setVisible(false)
    self.select_bg:setVisible(false)
    -- self.hero_icon:loadTexture(data.nameIcon, ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon)
    -- self.hero_quality:setVisible(data.quality == 2)

    if self.data.serverData and  self.data.serverData.lStar then 
        self.FileNode_1:setData(self.data.heroId,self.data.serverData.lStar)
    end 

    self.hero_type:loadTexture(data.typeIcon, ccui.TextureResType.plistType)
    self.hero_name:setString(data.name)

    self.hero_name:setVisible(true)
    self.hero_name1:setVisible(false)
    self.hero_nameLv:setVisible(true)
    if data.serverData and data.serverData.lGrade then 
        self.hero_nameLv:setString(string.format(luaCfg:get_local_string(10019),data.serverData.lGrade)) 
    end 

    if data.isActivityHero then
        self.hero_nameLv:setVisible(false)
        self.hero_name:setVisible(false)
        self.hero_name1:setVisible(true)
        self.hero_name1:setString(data.name)
    end
    
    global.heroData:setHeroIconBg(self.data.heroId, self.left, self.right)

end

function UIHeroListItem:flushResPoint(data)
    
    self.equipState:setVisible(global.heroData:checkHeroIsHavaNewEquip(self.data) or global.heroData:checkHeroIsCanUpdateSkill(self.data) or global.heroData:checkHeroIsCanUpdateStar(self.data)) 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIHeroListItem:setCallBackFunc(callFunc, itemSwitch, isHeroPanel)
    self.itemSwitch = {}
    self.itemSwitch = itemSwitch
    self.callBack = callFunc
    self.isHeroPanel = isHeroPanel
end

function UIHeroListItem:heroItem_click(sender, eventType)

    if self.data.isActivityHero then 
        gsound.stopEffect("city_click")
        return 
    end

    if self.selectHeroPanel.isMove  or self.heroPanel.isMove then 
        gsound.stopEffect("city_click")

        return 
    end

    gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    
    
    if not self.isHeroPanel then
        self.callBack(self.data)
    end
    self:refershSelectState(sender:getTag())
end

function UIHeroListItem:refershSelectState( _curTag )

    for k,v in pairs(self.itemSwitch) do
        if v.btnBg:getTag() == _curTag  then
            v.select_bg:setVisible(true)

            if self.isHeroPanel then
                
                if (self.selectHeroPanel.curHeroTag ~= _curTag ) and (not self.selectHeroPanel.SELECT_FIRST) then
                    self.callBack(self.data)
                    local item = self:getItemByTag(self.selectHeroPanel.curHeroTag)
                    v.select_bg:setVisible(true)
                    item.select_bg:setVisible(false)
                    self.selectHeroPanel.SELECT_FIRST = false
                    self.selectHeroPanel.curHeroTag = _curTag
                    return
                end

                if self.selectHeroPanel.SELECT_FIRST then
                    self.callBack(self.data)
                    self.selectHeroPanel.SELECT_FIRST = false
                    v.select_bg:setVisible(true)

                    self.selectHeroPanel.curHeroTag = _curTag
                else
                    -- self.callBack(nil)
                    -- self.selectHeroPanel.SELECT_FIRST = true
                    -- v.select_bg:setVisible(false)
                end
                
            end
        else
            v.select_bg:setVisible(false)
        end
    end    
end

function UIHeroListItem:getItemByTag( _tag )

        for _,v in pairs(self.itemSwitch) do
            
            if v.btnBg:getTag() == _tag  then
                return v
            end
        end
end

--CALLBACKS_FUNCS_END

return UIHeroListItem

--endregion
