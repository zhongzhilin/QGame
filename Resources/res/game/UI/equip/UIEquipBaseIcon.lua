--region UIEquipBaseIcon.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipBaseIcon  = class("UIEquipBaseIcon", function() return gdisplay.newWidget() end )

function UIEquipBaseIcon:ctor()
    
end

function UIEquipBaseIcon:CreateUI()
    local root = resMgr:createWidget("equip/equipment_node")
    self:initUI(root)
end

function UIEquipBaseIcon:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equipment_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN 
    self.quit = self.root.quit_export
    self.empty_icon = self.root.empty_icon_export
    self.icon = self.root.icon_export
    self.noUnlockIcon = self.root.noUnlockIcon_export

    uiMgr:addWidgetTouchHandler(self.icon, function(sender, eventType) self:icon_call(sender, eventType) end)
--EXPORT_NODE_END

    self.light = resMgr:createWidget("effect/equip_ad_lv")
    self.icon:addChild(self.light)
    self.light:setPosition(cc.p(90,90))
    self.light:setVisible(false)    
end

function UIEquipBaseIcon:onEnter()
    -- print(self.timeLine,'self.timeLine')
    -- self.timeLine:play('animation1',true)    
end

function UIEquipBaseIcon:setEmptyIndex(index, isUnlock)

    self.noUnlockIcon:setVisible(isUnlock or false)
    self.empty_icon:setVisible(true)
    self.icon:setVisible(false)

    self.icon:setTouchEnabled(false)        
    self.empty_icon:setSpriteFrame("ui_surface_icon/equipment_" .. index .. ".png")    

    self.quit:setSpriteFrame(string.format("ui_surface_icon/hero_equipment_bg.png"))

    self.light:setVisible(false)    
end

function UIEquipBaseIcon:setCallback(callback)
 
    
    self.callback = callback
    self.icon:setTouchEnabled(true)    
end

function UIEquipBaseIcon:setData(data,isNotCanSuit,strongLv)
	
    self.noUnlockIcon:setVisible(false)
    self.empty_icon:setVisible(false)
    self.icon:setVisible(true)

    self.icon:setTouchEnabled(false)
    global.panelMgr:setTextureForAsync(self.icon,data.icon,true)	
    -- self.icon:loadTextureNormal(data.icon,ccui.TextureResType.localType)
    -- self.icon:loadTexturePressed(data.icon,ccui.TextureResType.localType)

	-- self.quit:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",data.quality))
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",data.quality),true)

    -- if not isNotCanSuit then

    --     self.icon:setColor(cc.c3b(255,255,255))
    -- else

    --     self.icon:setColor(cc.c3b(255,0,0))
    -- end

    if strongLv then

        funcGame:initEquipLight(self.light, strongLv)
    else
        self.light:setVisible(false)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIEquipBaseIcon:icon_call(sender, eventType)

    local topPanel = global.panelMgr:getTopPanelName()
    if topPanel == "UIMailBattlePanel" then

        local sPanel = global.panelMgr:getPanel("UIMailBattlePanel")
        if eventType == ccui.TouchEventType.began then
            sPanel.isBattleMove = false
        end
        if eventType == ccui.TouchEventType.ended then
        
            if sPanel.isBattleMove then 
                return
            end

            if self.callback then
                self.callback()
            end
        end
    else

        if eventType == ccui.TouchEventType.ended then

            if self.callback then
                self.callback()
            end
        end
    end
end
--CALLBACKS_FUNCS_END

return UIEquipBaseIcon

--endregion
