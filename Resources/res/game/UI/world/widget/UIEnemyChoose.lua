--region UIEnemyChoose.lua
--Author : untory
--Date   : 2016/09/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEnemyChoose  = class("UIEnemyChoose", function() return gdisplay.newWidget() end )

function UIEnemyChoose:ctor()
  
	self:CreateUI()  
end

function UIEnemyChoose:CreateUI()
    local root = resMgr:createWidget("world/world_enemychoose")
    self:initUI(root)
end

function UIEnemyChoose:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_enemychoose")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.bj.btn1.name_export

    uiMgr:addWidgetTouchHandler(self.root.bj.btn1, function(sender, eventType) self:attack(sender, eventType) end)
--EXPORT_NODE_END
end

function UIEnemyChoose:setData(data)
	

end

function UIEnemyChoose:setCity(city)
	
	self.city = city
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIEnemyChoose:attack(sender, eventType)

	global.g_worldview.mapPanel:TEMP_ATTACK(cc.p(self.city:getPositionX(),self.city:getPositionY()))

	self:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0),cc.RemoveSelf:create()))
end
--CALLBACKS_FUNCS_END

return UIEnemyChoose

--endregion
