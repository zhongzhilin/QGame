--region UIHpSoldierCard.lua
--Author : wuwx
--Date   : 2016/11/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHpSoldierCard  = class("UIHpSoldierCard", function() return gdisplay.newWidget() end )
local UIISoldierTipsControl = require("game.UI.common.UIISoldierTipsControl")

function UIHpSoldierCard:ctor()
end

function UIHpSoldierCard:CreateUI()
    local root = resMgr:createWidget("hospital/soldier_icon")
    self:initUI(root)
end

function UIHpSoldierCard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/soldier_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_node = self.root.Panel_1.portrait_node_export
    self.dismiss_btn = self.root.Panel_1.dismiss_btn_export
    self.select_bg = self.root.Panel_1.select_bg_export
    self.need_heal = self.root.Panel_1.need_heal_export
    self.num = self.root.Panel_1.num_export
    self.name = self.root.Panel_1.name_export
    self.star = self.root.Panel_1.star_export
    self.star1_bj = self.root.Panel_1.star_export.star1_bj_export
    self.star1 = self.root.Panel_1.star_export.star1_bj_export.star1_export
    self.star2 = self.root.Panel_1.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.Panel_1.star_export.star2_bj_export
    self.star3 = self.root.Panel_1.star_export.star2_bj_export.star3_export
    self.star4 = self.root.Panel_1.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.Panel_1.star_export.star3_bj_export
    self.star5 = self.root.Panel_1.star_export.star3_bj_export.star5_export
    self.star6 = self.root.Panel_1.star_export.star3_bj_export.star6_export

    uiMgr:addWidgetTouchHandler(self.dismiss_btn, function(sender, eventType) self:giveUpSoldier(sender, eventType) end)
--EXPORT_NODE_END

end

function UIHpSoldierCard:setData(data)

    self.data = data
    self.num:setString(data.num)
    
    local soldierData = luaCfg:get_soldier_train_by(data.lID)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)
    self.need_heal:setVisible(data.isWounded)
    self.name:setString(soldierData.name)
    self.m_TipsControl = UIISoldierTipsControl.new()
    if data.tips_panel then 
        local tips_node = data.tips_panel.tips_node
        soldierData.showType = "UIHpSoldierCard"
        if tips_node then 
            self.m_TipsControl:setdata(self.select_bg ,soldierData,tips_node)
        end 
    end 

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end

    local id,dataBuild = global.cityData:getBuildingIdBySoldierId(data.lID)
    if soldierData.race ~=0  and  dataBuild and dataBuild.serverData and (soldierData.type ~= 0) then
        showlvStar(dataBuild.serverData.lGrade or 1)
    else
        showlvStar(-1)
    end

    self.dismiss_btn:setVisible(self.data.isrecruit)
    self.dismiss_btn:setTouchEnabled(self.data.isrecruit)
end

function UIHpSoldierCard:setSelected(isSelected)
    self.select_bg:setVisible(isSelected)

    if self.data.isrecruit then 
        self.dismiss_btn:setTouchEnabled(isSelected)
    else 
        self.dismiss_btn:setTouchEnabled(false)
    end 
end

function UIHpSoldierCard:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

function UIHpSoldierCard:onHP()
    
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHpSoldierCard:giveUpSoldier(sender, eventType)
  local panel =   global.panelMgr:openPanel("UIDissMissSoldierPanel")
  panel:setData(self.data )
end

--CALLBACKS_FUNCS_END

return UIHpSoldierCard

--endregion
