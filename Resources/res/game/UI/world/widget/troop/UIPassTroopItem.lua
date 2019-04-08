--region UIPassTroopItem.lua
--Author : untory
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPassTroopItem  = class("UIPassTroopItem", function() return gdisplay.newWidget() end )

function UIPassTroopItem:ctor()
    
    self:CreateUI()
end

function UIPassTroopItem:CreateUI()
    local root = resMgr:createWidget("world/mainland/fly_troops_list")
    self:initUI(root)
end

function UIPassTroopItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/fly_troops_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ItemBg = self.root.ItemBg_export
    self.troops_list = self.root.ItemBg_export.troops_list_export
    self.troops_hero = self.root.ItemBg_export.troops_list_export.troops_hero_export
    self.hero_bg = self.root.ItemBg_export.troops_list_export.hero_bg_export
    self.list_scale = self.root.ItemBg_export.troops_list_export.list_scale_export
    self.player_name = self.root.ItemBg_export.troops_list_export.player_name_export
    self.btn_dissolution = self.root.ItemBg_export.troops_list_export.btn_dissolution_export

    uiMgr:addWidgetTouchHandler(self.btn_dissolution, function(sender, eventType) self:fireTroop_click(sender, eventType) end)
--EXPORT_NODE_END

    self:initTextColor()
end

function UIPassTroopItem:setData(data)
    
    self.data = data

    if data.lHeroID == nil then data.lHeroID = {[1]=0} end
    if data.lHeroID[1] ~= 0 then 
        local heroData = global.heroData:getHeroPropertyById(data.lHeroID[1])
        -- self.troops_hero:loadTexture(heroData.nameIcon, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.troops_hero,heroData.nameIcon)
    else
        self.troops_hero:loadTexture("ui_surface_icon/troops_list_noicon.jpg", ccui.TextureResType.plistType)
    end

    self:setLordName(data)
    self.list_scale:setString(global.troopData:getTroopsScaleById(data.lID))
end

function UIPassTroopItem:setLordName(data)
    
    local textColor = gdisplay.COLOR_WHITE
    local posY = 0
    if data.szName ~= "nil" then
        self.player_name:setString(data.szName)
        if data.lUserID ~= global.userData:getUserId() then

            local curState = data.lAvator
            if curState == 0 then
                lAvatorId = 10142
                textColor = self.COLOR_YELLOW 
            elseif curState == 2 or curState == 3 then
                lAvatorId = 10141
                textColor = self.COLOR_GREEN 
            elseif curState == 4 then
                lAvatorId = 10143
                textColor = self.COLOR_RED 
            end
            -- self.player_relation:setVisible(true)
            -- self.player_relation:setString(luaCfg:get_local_string(lAvatorId))
            -- self.player_relation:setTextColor(textColor)
            posY = 78.5
        else
            textColor = self.COLOR_OWNCOLOR
            -- self.player_relation:setVisible(false)
            posY = 66.5
        end
        self.player_name:setTextColor(textColor)
    else
        posY = 66.5
        self.player_name:setString("-")
    end
    self.player_name:setPositionY(posY)
end

function UIPassTroopItem:initTextColor()
    
    self.COLOR_OWNCOLOR = cc.c3b(255, 226, 165)  -- 浅黄色  (自己)
    self.COLOR_GREEN = cc.c3b(87, 213, 63)       -- 浅绿色  (同盟/联盟  、行军中)
    self.COLOR_YELLOW = cc.c3b(255, 208, 65)     -- 黄色    (中立)
    self.COLOR_RED = cc.c3b(180, 29, 11)         -- 红色    (敌对)
    self.COLOR_BLUE = cc.c3b(36, 108, 198)       -- 深蓝色  (驻守城内)
    self.COLOR_ORANGE = cc.c3b(255, 119, 57)     -- 橙色    (驻守城外)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPassTroopItem:item_click(sender, eventType)

end

function UIPassTroopItem:item_click(sender, eventType)

end

function UIPassTroopItem:fireTroop_click(sender, eventType)

    local cityId = global.g_worldview.worldPanel.chooseCityId
    local areaId = global.panelMgr:getPanel("UIPassTroopPanel"):getIndex()
    local troopId = self.data.lID

    global.worldApi:passTroop(cityId, areaId, troopId, function()
        
        global.tipsMgr:showWarning("PortOk")
    end)
end
--CALLBACKS_FUNCS_END

return UIPassTroopItem

--endregion
