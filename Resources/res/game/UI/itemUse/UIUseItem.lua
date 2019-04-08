--region UIUseItem.lua
--Author : yyt
--Date   : 2016/08/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUseItem  = class("UIUseItem", function() return gdisplay.newWidget() end )

function UIUseItem:ctor()
    
    self:CreateUI()
end

function UIUseItem:CreateUI()
    local root = resMgr:createWidget("bag/item_use_node")
    self:initUI(root)
end

function UIUseItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/item_use_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.selectBg = self.root.selectBg_export
    self.icon = self.root.icon_export
    self.num = self.root.num_export
    self.name = self.root.name_export
    self.red_point = self.root.red_point_export

    uiMgr:addWidgetTouchHandler(self.bg, function(sender, eventType) self:item_click(sender, eventType) end)
--EXPORT_NODE_END
	self.bg:setPressedActionEnabled(false)
	self.bg:setSwallowTouches(false)

	self.speedPanel = global.panelMgr:getPanel("UISpeedPanel")
end

function UIUseItem:onEnter()
	
	self:initAction()
	self.selectBg:setVisible(false)
end

function UIUseItem:setData( data )

	self.data = data
	self.selectBg:setVisible(false)
	-- self.icon:setSpriteFrame(data.itemIcon)
    global.panelMgr:setTextureFor(self.icon,data.itemIcon)
	self.bg:setName("bg" .. self.data.itemId)

	if data.itemId == 6 then
		local diamondTotalNum = tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))
		self.num:setString(diamondTotalNum)
	else
		self.num:setString(global.normalItemData:getItemById(data.itemId).count)
	end 
	self.name:setString(data.itemName)
	-- self.bg:loadTextureNormal(string.format("ui_surface_icon/item_bg_0%d.png",data.quality), ccui.TextureResType.plistType)
	-- self.bg:loadTexturePressed(string.format("ui_surface_icon/item_bg_0%d.png",data.quality), ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.bg,string.format("icon/item/item_bg_0%d.png",data.quality))

	self.red_point:setVisible(self.data.red)    
end

function UIUseItem:setNumVisible(isVi)
	self.num:setVisible(isVi)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUseItem:ActionGo()
	self.selectBg:setVisible(true)
	self.nodeTimeLine = resMgr:createTimeline("bag/item_use1")
	self.nodeTimeLine:play("item_use", false)
	self.speedPanel:runAction(self.nodeTimeLine)

	local function CallGo()
 		self.scheduleGo = gscheduler.scheduleGlobal(function()
 			if self.bottomBgAction then
        		self:bottomBgAction()
        	end
    	end, 1/30)
 	end
    self:runAction(cc.CallFunc:create(CallGo))
end

function UIUseItem:ActionBack()

	self.selectBg:setVisible(false)
	self.nodeTimeLine = resMgr:createTimeline("bag/item_use1")
	self.nodeTimeLine:play("item_use_back", false)
	self.speedPanel:runAction(self.nodeTimeLine)
	local function CallBack()
 		self.scheduleBack = gscheduler.scheduleGlobal(function()
 			if self.bottomBgBackAction then
        		self:bottomBgBackAction()
        	end
    	end, 1/30)
 	end
   
    self:runAction(cc.Sequence:create(cc.CallFunc:create(CallBack),cc.DelayTime:create(0.25),
			cc.CallFunc:create(handler(self,self.initAction))))
end

function UIUseItem:item_click(sender, eventType)

	self.speedPanel.isNeedUse = true
	self.speedPanel.curItemTag = sender:getTag()
	if self.speedPanel.isMove then
    	gsound.stopEffect("city_click")
		return
	end

	if type(eventType) == "number" and eventType == -100 then
	else
		gsound.stopEffect("city_click")
    	gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    end
	
	global.uiMgr:addSceneModel(0.25)
	self.speedPanel:setItemData(self.data)
   
	if (self.speedPanel.firstTag ~= sender:getTag()) and (not self.speedPanel.isFirstClick) then
		self:refershSelectState(sender)
		global.uiMgr:addSceneModel(0.5)
		self:runAction(cc.Sequence:create(cc.CallFunc:create(handler(self,self.ActionBack)),cc.DelayTime:create(0.3),
			cc.CallFunc:create(handler(self,self.ActionGo))))
		self.speedPanel.isFirstClick = false
		return
	end

	self:refershSelectState(sender)
	if  self.speedPanel.isFirstClick then
		-- 第一次进入默认展开
		if type(eventType) == "number" and eventType == -100 then

			local titlePoX, titlePoY = self.speedPanel.txt_Title:getPosition()
			self.speedPanel.topModel:setContentSize(cc.size(self.speedPanel.topModel:getContentSize().width, 850))
			self.speedPanel.bg:setContentSize(cc.size(self.speedPanel.bg:getContentSize().width, 868))
			self.speedPanel.txt_Title:setPosition(cc.p(titlePoX, 826))
			
		    self.nodeTimeLine = global.resMgr:createTimeline("bag/item_use1")
		    self.speedPanel:runAction(self.nodeTimeLine)
		    self.nodeTimeLine:gotoFrameAndPause(16)

		    self.speedPanel.restTime_node:setPosition(cc.p(titlePoX, 826))

		else
			self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01),
				cc.CallFunc:create(handler(self,self.ActionGo))))
		end
		self.speedPanel.isFirstClick = false

	else
		self:ActionBack()
		self.speedPanel.isFirstClick = true
	end
end

function UIUseItem:initAction()

	self.speedPanel.usePanel:setPosition(cc.p(0, 25))
	self.speedPanel.itemPanel:setPosition(cc.p(0, 25))
	self.speedPanel.bg:setContentSize(cc.size(709, 500))
	self.speedPanel.txt_Title:setPosition(cc.p(353, 457.46))
	self.speedPanel.restTime_node:setPosition(cc.p(353, 457.46))
	self.selectBg:setVisible(false)
end

function UIUseItem:refershSelectState(sender)

    for k,v in pairs(self.speedPanel.itemSwitch) do
        if v.bg:getTag() == sender:getTag()  then
            v.selectBg:setVisible(true)
            self.speedPanel.firstTag = v.bg:getTag()
        else
            v.selectBg:setVisible(false)
        end
    end    
end

function UIUseItem:bottomBgAction()
	
	local speed = 700/15
	local bgSize = self.speedPanel.bg:getContentSize().height
	local titlePoX, titlePoY = self.speedPanel.txt_Title:getPosition()
	if bgSize >= 850 then
		gscheduler.unscheduleGlobal(self.scheduleGo)
		self.speedPanel.topModel:setContentSize(cc.size(self.speedPanel.topModel:getContentSize().width, 850))
		return
	end

	self.speedPanel.bg:setContentSize(cc.size(self.speedPanel.bg:getContentSize().width, math.floor(bgSize+speed)))
	self.speedPanel.txt_Title:setPosition(cc.p(titlePoX, math.floor(titlePoY + speed)))
	self.speedPanel.restTime_node:setPosition(cc.p(titlePoX, math.floor(titlePoY + speed)))
end

function UIUseItem:bottomBgBackAction()
	
	local speed = 700/15
	local bgSize = self.speedPanel.bg:getContentSize().height
	local titlePoX, titlePoY = self.speedPanel.txt_Title:getPosition()
	if bgSize <= 500 then
		gscheduler.unscheduleGlobal(self.scheduleBack)
		self.speedPanel.topModel:setContentSize(cc.size(self.speedPanel.topModel:getContentSize().width, 500))
		return
	end
	self.speedPanel.bg:setContentSize(cc.size(self.speedPanel.bg:getContentSize().width, math.floor(bgSize-speed)))
	self.speedPanel.txt_Title:setPosition(cc.p(titlePoX, math.floor(titlePoY - speed)))
	self.speedPanel.restTime_node:setPosition(cc.p(titlePoX, math.floor(titlePoY - speed)))
end

function UIUseItem:onExit()
	
	 self:initAction()
     self.isFirstClick = true
end

function UIUseItem:setIcon(icon)
	global.panelMgr:setTextureFor(self.icon,icon)
end

--CALLBACKS_FUNCS_END

return UIUseItem

--endregion
