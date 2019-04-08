--region UITownTopInfo.lua
--Author : untory
--Date   : 2016/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITownTopInfo  = class("UITownTopInfo", function() return gdisplay.newWidget() end )

function UITownTopInfo:ctor()
    self:CreateUI()
end

function UITownTopInfo:CreateUI()
    local root = resMgr:createWidget("wild/wild_top_num_node")
    self:initUI(root)
end

function UITownTopInfo:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_top_num_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.LoadingBar = self.root.Panel_1.LoadingBar_export
    self.loadingTag = self.root.Panel_1.loadingTag_export
    self.num = self.root.num_export

--EXPORT_NODE_END
end

function UITownTopInfo:setData( data )

	local pen = data.lCurHp / data.lMaxHp

	self.num:setString(data.lCurRound + 1)
	self.LoadingBar:setPercent(pen * 100)
	self.loadingTag:setPositionX(70 * pen)

    data.lNextTime = data.lNextTime or 0
	if data.lNextTime == 0 then

		self:setVisible(false)
	end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UITownTopInfo

--endregion
