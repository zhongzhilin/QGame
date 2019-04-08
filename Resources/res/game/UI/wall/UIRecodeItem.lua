--region UIRecodeItem.lua
--Author : yyt
--Date   : 2017/09/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRecodeItem  = class("UIRecodeItem", function() return gdisplay.newWidget() end )

function UIRecodeItem:ctor()
    self:CreateUI()
end

function UIRecodeItem:CreateUI()
    local root = resMgr:createWidget("wall/burn_tips_node")
    self:initUI(root)
end

function UIRecodeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/burn_tips_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.txt = self.root.txt_export

--EXPORT_NODE_END
    self.textH = self.txt:getContentSize().height
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRecodeItem:setData(data)
	-- body
	self.icon:setPositionY(data.cellH)
    self.txt:setPositionY(data.cellH-self.textH-5)
	
	local cdata = data.cdata
	local str = ""
    local timeStr = global.mailData:getTime(0, cdata.lAddTime)
    if cdata.lType == 1 then
       uiMgr:setRichText(self, "txt", 50143, {time=timeStr, name=cdata.szName, name1=cdata.szParam or "", itemNum=cdata.lNum, burnSpeed=cdata.lValue})
    else
       uiMgr:setRichText(self, "txt", 50144, {time=timeStr, name=cdata.szName, name1=cdata.szParam or "", itemNum=cdata.lNum, burnSpeed=cdata.lValue})
    end
end

--CALLBACKS_FUNCS_END

return UIRecodeItem

--endregion
