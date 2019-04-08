--region UIApproveItem.lua
--Author : yyt
--Date   : 2017/07/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIApproveItem  = class("UIApproveItem", function() return gdisplay.newWidget() end )

function UIApproveItem:ctor()
    self:CreateUI()
end

function UIApproveItem:CreateUI()
    local root = resMgr:createWidget("diplomatic/apply_node")
    self:initUI(root)
end

function UIApproveItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diplomatic/apply_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.union_name = self.root.Node_1.Image_4.union_name_export
    self.btn_refuse = self.root.Node_1.btn_refuse_export
    self.btn_agree = self.root.Node_1.btn_agree_export

    uiMgr:addWidgetTouchHandler(self.btn_refuse, function(sender, eventType) self:refuseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_agree, function(sender, eventType) self:agreeHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIApproveItem:setData(data)

    self.data = data
    if data.lFlag then
        self.union_name:setString( global.luaCfg:get_local_string(10333, data.lFlag) .. data.lszname)
    else
        self.union_name:setString(data.lszname or "")
    end
end

-- 拒绝申请
function UIApproveItem:refuseHandler(sender, eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10724, function()

        global.unionApi:getUserRelationShip(function (msg) 
            gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)
        end, 4, self.data.lUid)

    end)
    panel.text:setString(global.luaCfg:get_local_string(10724, self.data.lszname))
end

-- 同意申请
function UIApproveItem:agreeHandler(sender, eventType)
    
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10723, function()

        global.unionApi:getUserRelationShip(function (msg) 
            gevent:call(global.gameEvent.EV_ON_APPROVECOUNT_UPDATE)
        end, 3, self.data.lUid)

    end)
    panel.text:setString(global.luaCfg:get_local_string(10723, self.data.lszname))
end
--CALLBACKS_FUNCS_END

return UIApproveItem

--endregion
