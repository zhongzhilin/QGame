--region UIHeroItem.lua
--Author : yyt
--Date   : 2016/09/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroItem  = class("UIHeroItem", function() return gdisplay.newWidget() end )

function UIHeroItem:ctor()
    
end

function UIHeroItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_node2")
    self:initUI(root)
end

function UIHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_node2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg_line = self.root.bg_line_export
    self.hero_icon = self.root.btnBg.hero_icon_export
    self.hero_icon_bg = self.root.btnBg.hero_icon_bg_export
    self.loadingbar_bg = self.root.btnBg.loadingbar_bg_export
    self.bar_bg = self.root.btnBg.loadingbar_bg_export.bar_bg_export
    self.LoadingBar = self.root.btnBg.loadingbar_bg_export.LoadingBar_export
    self.lord = self.root.btnBg.loadingbar_bg_export.lord_export
    self.tips = self.root.btnBg.loadingbar_bg_export.lord_export.tips_export
    self.now_num = self.root.btnBg.loadingbar_bg_export.now_num_export
    self.total_num = self.root.btnBg.loadingbar_bg_export.total_num_export
    self.name = self.root.btnBg.name_export
    self.heroState = self.root.btnBg.heroState_export
    self.heroState0 = self.root.btnBg.heroState0_export
    self.hero_quality = self.root.btnBg.hero_quality_export
    self.hero_epic = self.root.btnBg.hero_quality_export.hero_epic_export
    self.hero_type = self.root.btnBg.hero_type_export
    self.hero_point = self.root.btnBg.hero_point_export
    self.effect_node = self.root.btnBg.effect_node_export
    self.hero_item_node = self.root.btnBg.hero_item_node_export
    self.fire_number = self.root.btnBg.hero_item_node_export.fire_number_export

    uiMgr:addWidgetTouchHandler(self.root.btnBg, function(sender, eventType) self:item_click(sender, eventType) end, true)
--EXPORT_NODE_END

    self.btnBg_guide =  self.hero_icon_bg -- 新手引导

    self.root.btnBg:setSwallowTouches(false)

    self.heroPanel = global.panelMgr:getPanel("UIHeroPanel")

    self.barW = self.lord:getContentSize().width
end

function UIHeroItem:setData( data )


    if not data   then return end
    if data.fake then self:setVisible(false ) return end 

    self:setVisible(true )

    global.colorUtils.turnGray(self.bar_bg ,  true)

    self.data = data

    if self.data.state == 2 then --如果是已结识
        self.hero_icon:setName("btnBg_guide")
    end


    self.name:setString(data.name)

    self.heroState:setVisible(data.state == 2)
    -- self.hero_icon:loadTexture(data.nameIcon, ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon)

    self.hero_point:setVisible(false)
    self.bg_line:setVisible(not data.hidechain)

    local turnGrayArr  = {self.hero_icon , self.name , self.hero_type , self.hero_quality} 

    local turnGrayExcute = function (state) 
        for _ ,v in pairs(turnGrayArr) do 
            global.colorUtils.turnGray(v,state)
        end 
    end

    if data.state ~= 1 and data.state ~= 3 and data.state ~= 4 then
        if data.state ~= 2 then
            self.heroState0:setVisible(self:checkCanKnow(data)) -- 英雄是否可结识

                if self:checkCanKnow(data) == true then --新手引导需要用到
                    self.btnBg_guide:setName("btnBg_guide"..data.heroId)
                end

        else
            self.heroState0:setVisible(false)
        end

        self.loadingbar_bg:setVisible(true)
        self.hero_point:setVisible(global.heroData:CheckRedPoint(self.data.heroId))
        self.effect_node:setVisible(true)
        self.hero_item_node:setVisible(true)

        turnGrayExcute(true)
    else

        self.heroState0:setVisible(false)
        self.loadingbar_bg:setVisible(false)
        self.effect_node:setVisible(false)
        self.hero_item_node:setVisible(false)

        turnGrayExcute(false)
    end

    local now =  global.heroData:getHeroImpress(self.data.heroId)

    local max = global.luaCfg:get_hero_property_by(self.data.heroId).impress

    self:stopAllActions()

    if now >= max then 
        now  = max 
        local nodeTimeLine = resMgr:createTimeline("hero/hero_node2")
        nodeTimeLine:play("animation0", true)
        self:runAction(nodeTimeLine)
    else 
        
        self.effect_node:setVisible(false)
    end         
   
    global.colorUtils.turnGray(self.loadingbar_bg, now <=0 )
    global.colorUtils.turnGray(self.bar_bg, true)

    self.heroState0:setVisible(false)
    self.heroState:setVisible(false)
    self.hero_quality:setVisible(self.data.quality == 2)
    self.hero_type:setSpriteFrame(self.data.typeIcon)
    self.total_num:setString("/"..max)
    self.now_num:setString(now)

    self.LoadingBar:setPercent(now/max * 100 )

    self.tips:setPositionX(self.barW* now/max)


    self.fire_number:setString(global.heroData:getHeroRoyalICount(self.data.heroId))
    
    self.hero_icon_bg:setSpriteFrame(self.data.iconBg)

end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroItem:checkCanKnow(data)
    
    local getItemId = function ()   
        local items = global.luaCfg:item()
        for _,v in pairs(items) do
            if v.itemType == 123 and v.typePara1 == data.heroId then
                return v.itemId
            end
        end
    end

    if global.normalItemData:getItemById(getItemId()).count > 0 then
        return true
    else
        return false
    end
end

function UIHeroItem:item_click(sender, eventType)
    
    if eventType == ccui.TouchEventType.ended then

        if self.heroPanel.isMove then return end

        if self.data.fake then return end 
        
        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")

        global.panelMgr:openPanel("UIDetailPanel"):setData(self.data)  

    end 

end
--CALLBACKS_FUNCS_END

return UIHeroItem

--endregion
