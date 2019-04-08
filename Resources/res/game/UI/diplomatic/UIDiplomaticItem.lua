--region UIDiplomaticItem.lua
--Author : yyt
--Date   : 2017/07/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDiplomaticItem  = class("UIDiplomaticItem", function() return gdisplay.newWidget() end )

function UIDiplomaticItem:ctor()
    self:CreateUI()
end

function UIDiplomaticItem:CreateUI()
    local root = resMgr:createWidget("diplomatic/diplomatic_1st_node")
    self:initUI(root)
end

function UIDiplomaticItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diplomatic/diplomatic_1st_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.bg.name_export
    self.union_name = self.root.bg.union_name_export
    self.lv = self.root.bg.lv_export
    self.arming = self.root.bg.arming_export
    self.applyiny = self.root.bg.applyiny_export

    uiMgr:addWidgetTouchHandler(self.root.bg.arming_export.modifyBtn, function(sender, eventType) self:editRelationHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bg.applyiny_export.btn_cancel, function(sender, eventType) self:cancelHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIDiplomaticItem:setData(data)

    self.data = data
    self.name:setString(data.lszname)
    self.union_name:setString(data.lAllyName or "-")
    self.lv:setString(data.lLv)
    
    self.arming:setVisible(false)
    self.applyiny:setVisible(false)
    if data.lstate == 1 then
        self.arming:setVisible(true)
    else
        self.applyiny:setVisible(true)
    end

end

-- 申请中立
function UIDiplomaticItem:editRelationHandler(sender, eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10721, function()

        global.unionApi:getUserRelationShip(function (msg) 
            gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)
        end, 5, self.data.lUid)
    end)
    panel.text:setString(global.luaCfg:get_local_string(10721, self.data.lszname))

end

-- 取消申请
function UIDiplomaticItem:cancelHandler(sender, eventType)
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10722, function()

        global.unionApi:getUserRelationShip(function (msg) 
            gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)
        end, 6, self.data.lUid)
    end)
    panel.text:setString(global.luaCfg:get_local_string(10722, self.data.lszname))
end
--CALLBACKS_FUNCS_END

return UIDiplomaticItem

--endregion
