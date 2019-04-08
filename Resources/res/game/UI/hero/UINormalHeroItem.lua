--region UINormalHeroItem.lua
--Author : yyt
--Date   : 2016/09/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UIPromptPanel = require("game.UI.itemUse.UIPromptPanel")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UINormalHeroItem  = class("UINormalHeroItem", function() return gdisplay.newWidget() end )

function UINormalHeroItem:ctor()
    
    self:CreateUI()
end

function UINormalHeroItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_list_node")
    self:initUI(root)
end

function UINormalHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.click = self.root.click_export
    self.hero_name = self.root.hero_name_export
    self.hero_type = self.root.hero_type_export
    self.hero_grow = self.root.hero_grow_export
    self.condition = self.root.condition_export
    self.Get_state = self.root.Get_state_export
    self.btn_operate = self.root.btn_operate_export

    uiMgr:addWidgetTouchHandler(self.btn_operate, function(sender, eventType) self:onOperateHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.click:setPressedActionEnabled(false)
    self.click:setSwallowTouches(false)
    self.click:setVisible(false)

    self.HeroPanel = global.panelMgr:getPanel("UIHeroPanel")
end

function UINormalHeroItem:setData( data )

    if data == nil then return end
    self.data = data
    self.hero_name:setString(data.name)
    self.hero_type:setString(data.type)
    self.hero_grow:setString(data.grow1)
    self.condition:setString(data.condition)
    self.btn_operate:setVisible(data.state == 0)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UINormalHeroItem:onOperateHandler(sender, eventType)

    global.tipsMgr:showWarning("NotOpen")
    -- if  global.heroData:isCanRecruitHero() then
    --     global.tipsMgr:showWarning("HeroNumber")
    -- else
    --     local panel = global.panelMgr:openPanel("UIPromptPanel")
    --     panel:setData("HeroGet", handler(self, self.confirmCallBack))
    -- end
end

function UINormalHeroItem:confirmCallBack()

    self.btn_operate:setVisible(false)
    self.Get_state:setVisible(true)
    global.heroData:refershNormalHeroState(self.data.heroId)
    self.HeroPanel:initNodeData()
end


--CALLBACKS_FUNCS_END

return UINormalHeroItem

--endregion
