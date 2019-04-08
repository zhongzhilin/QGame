--region UIMailTypeItem.lua
--Author : yyt
--Date   : 2016/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailTypeItem  = class("UIMailTypeItem", function() return gdisplay.newWidget() end )

function UIMailTypeItem:ctor()
    
     self:CreateUI()
end

function UIMailTypeItem:CreateUI()
    local root = resMgr:createWidget("mail/mail_first_node")
    self:initUI(root)
end

function UIMailTypeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_first_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.itemIcon = self.root.itemIcon_export
    self.itemName = self.root.itemName_export
    self.itemNum = self.root.itemNum_export

--EXPORT_NODE_END
     self.guide_mail = self.root.guide_mail

end

function UIMailTypeItem:setData(data)

  --  dump(data,"一级界面一级界面一级界面一级界面一级界面")
    self.guide_mail:setName("guide_mail" .. data.typeId)

    if data == nil then return end

    self.itemNum:setString("")
    self.itemName:setString(data.name)

    if data.unReadNum > 0 then 
        self.itemNum:setString(data.unReadNum)
    end
    -- 个人私聊
    local chatUnReadNum = global.mailData:getCurPriUnReadNum()
    if data.typeId == 3 and chatUnReadNum > 0 then
        self.itemNum:setString(chatUnReadNum)
    end
    self.itemIcon:setSpriteFrame(data.firstIcon)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMailTypeItem

--endregion
