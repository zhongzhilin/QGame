--region UIGarrisonHead.lua
--Author : untory
--Date   : 2017/02/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonHead  = class("UIGarrisonHead", function() return gdisplay.newWidget() end )

function UIGarrisonHead:ctor()
    
    self:CreateUI()
end

function UIGarrisonHead:CreateUI()
    local root = resMgr:createWidget("hero/city_hero_garrison")
    self:initUI(root)
end

function UIGarrisonHead:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/city_hero_garrison")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.Node_1.icon_export
    self.quality = self.root.Node_1.quality_export

--EXPORT_NODE_END
	
	self.root:setPositionY(260)
	local actionList = {      
		cc.EaseInOut:create(cc.MoveTo:create(1,cc.p(0,230)),2),
		cc.EaseInOut:create(cc.MoveTo:create(1,cc.p(0,260)),2),
		cc.EaseInOut:create(cc.MoveTo:create(1,cc.p(0,230)),2),
		cc.EaseInOut:create(cc.MoveTo:create(1,cc.p(0,260)),2),
		cc.FadeOut:create(0.4),
        cc.DelayTime:create(2),
        cc.FadeIn:create(0.2),  
    }
	self.root:runAction(cc.RepeatForever:create(cc.Sequence:create(actionList)))

end

local frameBg = {
    [1] = "icon/divine/divination_1.png",
    [3] = "icon/divine/divination_2.png",
    [5] = "icon/divine/divination_3.png",
}

function UIGarrisonHead:onEnter()
	
	self:addEventListener(gameEvent.EV_ON_UI_HERO_FLUSH,function()
		if self.buildType == 1 then
        	self:checkState(1)
        end
    end)

	self:addEventListener(gameEvent.EV_ON_UI_HEAD_FLUSH, function(event, buildType)
		if self.buildType == buildType then
			self:checkState(buildType)
		end
    end)

end

function UIGarrisonHead:checkData(data)

	if data and data.nameIcon then
		
		self:setVisible(true)
		-- self.icon:setSpriteFrame(data.nameIcon)
    	global.panelMgr:setTextureFor(self.icon,data.nameIcon)
	else
		self:setVisible(false)
	end
	
end

function UIGarrisonHead:setBuildType(lType)
	self.buildType = lType
end

function UIGarrisonHead:checkState(buildType)

	self.quality:setVisible(false)
	local data = {}
	local scale = 1
	if buildType == 1 then

		data = global.heroData:getHeroHeadData()
		scale = 0.19

	elseif buildType == 25 then

		local lState = global.refershData:getDivState()
		local curDivId = lState - 10000
        local temp = global.luaCfg:get_divine_by(curDivId)
        if temp then
            data.nameIcon = temp.icon
        	scale = 0.5
        	self.quality:setVisible(true)
    		global.panelMgr:setTextureFor(self.quality,frameBg[temp.quality])
        	self.quality:setScale(0.7)
        end
	end

	self.icon:setScale(scale)
	self:checkData(data)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIGarrisonHead

--endregion
