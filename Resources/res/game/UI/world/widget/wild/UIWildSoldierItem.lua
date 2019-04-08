--region UIWildSoldierItem.lua
--Author : yyt
--Date   : 2016/11/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildSoldierItem  = class("UIWildSoldierItem", function() return gdisplay.newWidget() end )

function UIWildSoldierItem:ctor()
    self:CreateUI()
end

function UIWildSoldierItem:CreateUI()
    local root = resMgr:createWidget("wild/wild_ziyuan_d")
    self:initUI(root)
end

function UIWildSoldierItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_ziyuan_d")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.lord_name = self.root.lord_name_export
    self.point1 = self.root.lord_name_export.point1_export
    self.troop_scale = self.root.troop_scale_export
    self.union = self.root.union_export
    self.point3 = self.root.union_export.point3_export
    self.cityState = self.root.cityState_mlan_7_export
    self.textContent = self.root.textContent_export
    self.hero_face = self.root.hero_face_export

    uiMgr:addWidgetTouchHandler(self.root.Button, function(sender, eventType) self:backHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIWildSoldierItem:setData(data)

    self.data = data
    
    self.lord_name:setString(self.data.szName)
    -- self.troop_name:setString(self.data.szName)
    self.troop_scale:setString(global.troopData:getTroopsScaleByData(self.data.tgWarrior))
    self.cityState:setString(global.unionData:getInUnionName())

    local heroId = 0
    if self.data.lHeroID then
       
        heroId = self.data.lHeroID[1] 
    end
    
    local heroData = luaCfg:get_hero_property_by(heroId)
    
    if not heroData then

        self.hero_face:setVisible(false)
        self.union:setString("-")
        self.cityState:setString("-")
    else
    
     
        local add = self.data._tempData.add

        -- self.hero_face:setSpriteFrame(heroData.nameIcon)
        global.panelMgr:setTextureFor(self.hero_face,heroData.nameIcon)
        self.hero_face:setVisible(true)

        if add > 0 then

            local totalAdd = math.floor(add * self.data._tempData.designerData.yield) + 200
            local str = totalAdd ..luaCfg:get_local_string(10076)
            self.cityState:setString(luaCfg:get_local_string(10692, str))
        else
            self.cityState:setString("-")
        end

        -- 英雄内政值
        self.union:setString(global.heroData:getHeroInterior(heroId))

    end    

    -- if data.lState == 5 or data.lState == 10 then
    --     self.cityState:setString(luaCfg:get_local_string(10096))
    --     self.cityState:setTextColor(cc.c3b(255, 226, 165))
    -- elseif data.lState == 11 then
    --     self.cityState:setString(luaCfg:get_local_string(10100))  
    --     self.cityState:setTextColor(cc.c3b(180, 29, 11))
    -- end

  


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIWildSoldierItem:backHandler(sender, eventType)
    
    if self.data.lState == 11 then
        global.tipsMgr:showWarning("237")
        return
    end

    global.worldApi:callBackTroop(self.data.lID,1,function()
        -- global.panelMgr:getPanel("UIWildSoldierPanel"):reloadData()
    end)
end
--CALLBACKS_FUNCS_END

return UIWildSoldierItem

--endregion
