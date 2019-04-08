--region UIAccChestWidget.lua
--Author : wuwx
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAccChestWidget  = class("UIAccChestWidget", function() return gdisplay.newWidget() end )

function UIAccChestWidget:ctor()
    self:CreateUI()
end

function UIAccChestWidget:CreateUI()
    local root = resMgr:createWidget("activity/recharge_activity/chest_node")
    self:initUI(root)
end

function UIAccChestWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/recharge_activity/chest_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bar = self.root.bar_export
    self.node_num = self.root.node_num_export
    self.num = self.root.num_export
    self.diamond_icon = self.root.diamond_icon_export

--EXPORT_NODE_END
end

function UIAccChestWidget:setData(data)

    -- self.bg:setVisible(false)
    self.num:setString(data.point)
    -- local state = 1
    -- local currentState = global.dailyTaskData:getBoxs()[data.sort].state
    -- if currentState == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
    --     state = 0
    -- elseif currentState == WDEFINE.DAILY_TASK.TASK_STATE.GETD then
    -- end

    -- self:setState(state)
    local sw = 18
    local s2w = self.num:getContentSize().width

    local px1 = -(sw+s2w)*0.5+sw*0.5
    self.diamond_icon:setPositionX(px1)
    self.num:setPositionX(px1+sw*0.5)
end

function UIAccChestWidget:setState(state)
    if state == 0 then
        -- self.unGetEffect:setVisible(true)

    else
        -- self.unGetEffect:setVisible(false)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAccChestWidget:onGet(sender, eventType)
end
--CALLBACKS_FUNCS_END

return UIAccChestWidget

--endregion
