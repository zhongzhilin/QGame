--region UIGotHeroPanel.lua
--Author : untory
--Date   : 2017/04/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGotHeroPanel  = class("UIGotHeroPanel", function() return gdisplay.newWidget() end )

function UIGotHeroPanel:ctor()
    
    self:CreateUI()
end

function UIGotHeroPanel:CreateUI()
    local root = resMgr:createWidget("effect/get_hero")
    self:initUI(root)
end

function UIGotHeroPanel:initUI(root)

	self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/get_hero")
-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.parent = self.root.parent_export
    self.hero_pick = self.root.parent_export.hero.hero_pick_export
    self.heroName = self.root.parent_export.hero.heroName_export
    self.shishi = self.root.parent_export.shishi_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.parent_export.Button_1, function(sender, eventType) self:close_by_btn(sender, eventType) end)
--EXPORT_NODE_END
end

function UIGotHeroPanel:setData(data)    

    if not data then return end 

	self.data = data
	-- self.hero_pick:setSpriteFrame(self.data.nameIcon)
    global.panelMgr:setTextureFor(self.hero_pick,data.nameIcon)
	self.heroName:setString(self.data.name)

	self.nodeTimeLine = resMgr:createTimeline("effect/get_hero")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)

    self.nodeTimeLine:play("animation0",false)

    self.isOuted = true
    self.parent:setOpacity( 255)
    self.parent:setScale(1)

    self.nodeTimeLine:setLastFrameCallFunc(function()
  
  		self.isOuted = false
  		self.nodeTimeLine:play("animation1",true)
    end)

    
    -- self.shishi:setScale(5)
    if data.iconBg == 'ui_surface_icon/hero_kuang4.png' then
		
		gevent:call(gsound.EV_ON_PLAYSOUND,"hero_get_2")		
		self.shishi:setVisible(true)
		-- self.shishi:stopAllActions()
  --   	self.shishi:runAction(cc.Sequence:create(cc.DelayTime:create(1.2),cc.Show:create(),cc.Spawn:create(cc.EaseIn:create(
  --   		cc.ScaleTo:create(0.4,1),3.5),cc.FadeIn:create(0.25))))    	
    else

    	self.shishi:setVisible(false)
    	gevent:call(gsound.EV_ON_PLAYSOUND,"hero_get_1")
    end        

    if data.heroType == 3 then

        gevent:call(global.gameEvent.EV_ON_UI_GOT_GOV_HERO)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGotHeroPanel:exit(sender, eventType)

	if self.isOuted then return end
	self.isOuted = true

	self.parent:runAction(cc.FadeOut:create(0.2))
	self.parent:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.7),cc.CallFunc:create(function()
		
		global.panelMgr:closePanel("UIGotHeroPanel")
	end)))
end

function UIGotHeroPanel:close_by_btn(sender, eventType)

	if self.isOuted then return end
	self.isOuted = true

	self.parent:runAction(cc.FadeOut:create(0.2))
	self.parent:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.7),cc.CallFunc:create(function()
		
		global.panelMgr:closePanel("UIGotHeroPanel")
	end)))
end
--CALLBACKS_FUNCS_END

return UIGotHeroPanel

--endregion
