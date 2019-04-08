--region UISkinBuffText.lua
--Author : anlitop
--Date   : 2017/09/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISkinBuffText  = class("UISkinBuffText", function() return gdisplay.newWidget() end )

function UISkinBuffText:ctor()
    self:CreateUI()
end

function UISkinBuffText:CreateUI()
    local root = resMgr:createWidget("world/mapavatar/buff_node")
    self:initUI(root)
end

function UISkinBuffText:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mapavatar/buff_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.content = self.root.content_export
    self.add = self.root.content_export.add_export
    self.describe = self.root.content_export.describe_export

--EXPORT_NODE_END

    --滚动字 张亮
    -- uiMgr:initScrollText(self.describe)

end


function UISkinBuffText:setData(data)

	if not data then return end 

	if data.buff then 
		self.describe:setString(data.buff)
	else 
		self.describe:setString("")
	end  

	if data.effect then 
		self.add:setString("+"..data.effect)
	else
		self.add:setString("")
	end 


    self.add:setPositionX(self.describe:getPositionX()+self.describe:getContentSize().width+5)


end 

function UISkinBuffText:getContentSize()

	return self.content:getContentSize()
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISkinBuffText

--endregion
