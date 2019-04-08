--region UIMailEdit.lua
--Author : yyt
--Date   : 2017/03/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailEdit  = class("UIMailEdit", function() return gdisplay.newWidget() end )

function UIMailEdit:ctor()
end

function UIMailEdit:CreateUI()
    local root = resMgr:createWidget("mail/mail_edit")
    self:initUI(root)
end

function UIMailEdit:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_edit")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.select = self.root.bg.Button_1.select_export

    uiMgr:addWidgetTouchHandler(self.root.bg.Button_1, function(sender, eventType) self:selectAllHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bg.giftBtn, function(sender, eventType) self:giftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bg.deleteBtn, function(sender, eventType) self:deleteHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bg.readBtn, function(sender, eventType) self:readHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.giftBtn = self.root.bg.giftBtn
    self.deleteBtn = self.root.bg.deleteBtn
    self.readBtn = self.root.bg.readBtn
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMailEdit:setData(call, typeId)

    self.isSelected = false
    self.select:setVisible(self.isSelected)
    self.m_call = call

    -- 聊天列表
    if typeId == 3 then
        self.giftBtn:setVisible(false)
    else
        self.giftBtn:setVisible(true)
    end

    self.readBtn:setVisible(true)
    self.deleteBtn:setPositionX(594)
    if typeId == 7 then
        self.giftBtn:setVisible(false)
        self.readBtn:setVisible(false)
        self.deleteBtn:setPositionX(gdisplay.width/2)
    end

end

-- 全选
function UIMailEdit:selectAllHandler(sender, eventType)
    
    self.isSelected = (not self.isSelected)
    self.select:setVisible(self.isSelected)
    self.m_call(self.isSelected, 1)
end

-- 一键领取
function UIMailEdit:giftHandler(sender, eventType)

    self.m_call(nil, 2)
end

-- 删除
function UIMailEdit:deleteHandler(sender, eventType)

    self.m_call(nil, 3)
end

-- 一键已读
function UIMailEdit:readHandler(sender, eventType)

    self.m_call(nil, 4)
end
--CALLBACKS_FUNCS_END

return UIMailEdit

--endregion
