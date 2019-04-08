--region UITechInfoNormalItem.lua
--Author : yyt
--Date   : 2017/03/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITechInfoNormalItem  = class("UITechInfoNormalItem", function() return gdisplay.newWidget() end )

function UITechInfoNormalItem:ctor()
    
end

function UITechInfoNormalItem:CreateUI()
    local root = resMgr:createWidget("science/tech_normal_condition")
    self:initUI(root)
end

function UITechInfoNormalItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/tech_normal_condition")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.condition = self.root.Node_1.condition_export
    self.state = self.root.Node_1.state_export
    self.speed_btn = self.root.Node_1.speed_btn_export
    self.speed = self.root.Node_1.speed_btn_export.speed_mlan_4_export

    uiMgr:addWidgetTouchHandler(self.speed_btn, function(sender, eventType) self:goHandler(sender, eventType) end)
--EXPORT_NODE_END
	self.bg = self.root.Node_1.Image_1
	self.speedText = self.speed
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITechInfoNormalItem:setData(conditId, triggerType)

	self.conditId = conditId
	self.triggerType = triggerType
	self.speed_btn:setVisible(false)
	if triggerType == 1 then

		local lvData = luaCfg:get_science_lvup_by(conditId)
    	local scienceData = global.techData:getTechById(lvData.id)
		self.condition:setString(luaCfg:get_local_string(10416, scienceData.name, lvData.lv))

	elseif triggerType == 2 then
		
		local buildData = {}
		local conditData = luaCfg:get_target_condition_by(conditId)
		local pos = luaCfg:buildings_pos()
		for _,v in pairs(pos) do
			if v.buildingType == conditData.objectId then
				buildData = v
			end
		end
		self.condition:setString(luaCfg:get_local_string(10416, buildData.buildsName, conditData.condition)) 
		self:setState(global.funcGame:checkTarget(conditId))
		self.speed_btn:setVisible(false)
	else
		local triggerData = luaCfg:get_item_by(self.conditId[1])
		self.condition:setString(triggerData.itemName.."  ".. global.funcGame:_formatBigNumber( self.conditId[2] , 2 ))

		self:setState(global.cityData:checkResource(self.conditId))
	end

end

function UITechInfoNormalItem:setState(flag)
	
	if flag then
		self.condition:setTextColor(cc.c3b(225,226,165))
		self.state:setSpriteFrame("ui_surface_icon/check_box_checked.png")
	else
		self.condition:setTextColor(cc.c3b(225,0,0))
		self.state:setSpriteFrame("ui_surface_icon/check_box.png")
		self.speed_btn:setVisible(true)
		if self.triggerType == 1 then
			self.speedText:setString(luaCfg:get_local_string(10014))
		else
			self.speedText:setString(luaCfg:get_local_string(10308))
		end
	end
end


function UITechInfoNormalItem:goHandler(sender, eventType)
	
	if self.triggerType == 1 then 

		local lvData = luaCfg:get_science_lvup_by(self.conditId)
	    local scienceData = global.techData:getTechById(lvData.id)
		local data = global.panelMgr:getPanel("UIScienceDPanel"):getTechById(scienceData.id)
		if global.techData:isTeching(scienceData.id) then
	        global.panelMgr:openPanel("UITechNowPanel"):setData(data)
	    else
	        global.panelMgr:openPanel("UITechInfoPanel"):setData(data)
	    end 
	else

		local getPanel = global.panelMgr:openPanel("UIResGetPanel")
        getPanel:setData(global.resData:getResById(self.conditId[1]), true)
	end

end
--CALLBACKS_FUNCS_END

return UITechInfoNormalItem

--endregion
