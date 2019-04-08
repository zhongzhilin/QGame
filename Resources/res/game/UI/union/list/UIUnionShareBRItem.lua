--region UIUnionShareBRItem.lua
--Author : wuwx
--Date   : 2017/01/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionShareBRItem  = class("UIUnionShareBRItem", function() return gdisplay.newWidget() end )

function UIUnionShareBRItem:ctor()
    self:CreateUI()
end

function UIUnionShareBRItem:CreateUI()
    local root = resMgr:createWidget("chat/share_war")
    self:initUI(root)
end

function UIUnionShareBRItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/share_war")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.txtBtn = self.root.txtBtn_export
    self.txtContent = self.root.txtBtn_export.txtContent_export
    self.time = self.root.time_export

    uiMgr:addWidgetTouchHandler(self.txtBtn, function(sender, eventType) self:openReportHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.txtBtn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.txtBtn:setSwallowTouches(false)
end

-- required int32      lKey        = 1;//1战报
-- required int32      lValue      = 2;//配表id
-- required string     szInfo      = 3;//简介内容
-- required string     szParam     = 4;//战斗id      
function UIUnionShareBRItem:setData(data)
    self.data = data
    self.time:setString(global.funcGame.formatTimeToYMDHMS(data.lTime))
    self.txtContent:setString(self:getTextContent(data.szInfo))
end

function UIUnionShareBRItem:getTextContent(szInfo)
    
    local showStr = szInfo
    local strTb = global.mailData:getMailTitleByInfo(szInfo)
    if #strTb > 1 then     
        showStr = global.luaCfg:get_local_string(10299, strTb[1].."\n"..strTb[2])
    end
    return showStr
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionShareBRItem:openReportHandler(sender, eventType)
    
end
--CALLBACKS_FUNCS_END

return UIUnionShareBRItem

--endregion
