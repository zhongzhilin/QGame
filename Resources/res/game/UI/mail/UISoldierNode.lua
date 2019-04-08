--region UISoldierNode.lua
--Author : yyt
--Date   : 2016/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldierNode  = class("UISoldierNode", function() return gdisplay.newWidget() end )

function UISoldierNode:ctor()
    self:CreateUI()
end

function UISoldierNode:CreateUI()
    local root = resMgr:createWidget("mail/mall_war_troops")
    self:initUI(root)
end

function UISoldierNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mall_war_troops")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.unknow = self.root.unknow_export
    self.NodeContent = self.root.NodeContent_export
    self.blue_bg = self.root.NodeContent_export.soldier_panel.blue_bg_export
    self.node_icon = self.root.NodeContent_export.soldier_panel.node_icon_export
    self.bgA = self.root.NodeContent_export.bgA_export
    self.bgD = self.root.NodeContent_export.bgD_export
    self.num1 = self.root.NodeContent_export.num1_export
    self.num2 = self.root.NodeContent_export.num2_export
    self.star = self.root.NodeContent_export.star_export
    self.star1_bj = self.root.NodeContent_export.star_export.star1_bj_export
    self.star1 = self.root.NodeContent_export.star_export.star1_bj_export.star1_export
    self.star2 = self.root.NodeContent_export.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.NodeContent_export.star_export.star2_bj_export
    self.star3 = self.root.NodeContent_export.star_export.star2_bj_export.star3_export
    self.star4 = self.root.NodeContent_export.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.NodeContent_export.star_export.star3_bj_export
    self.star5 = self.root.NodeContent_export.star_export.star3_bj_export.star5_export
    self.star6 = self.root.NodeContent_export.star_export.star3_bj_export.star6_export

--EXPORT_NODE_END
    self.battlePanel = global.panelMgr:getPanel("UIMailBattlePanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISoldierNode:setData(data, troopType)

    -- 空部队处理
    self.NodeContent:setVisible(true)
    if data and data.lID and data.lID == -1 then
        self.unknow:setVisible(false)
        self.NodeContent:setVisible(false)
        return
    end
    
    self.unknow:setVisible(false)
    if data == nil then
        self.NodeContent:setVisible(false)
        if troopType then
            self.unknow:setVisible(true)
        end
        return
    end
    
    self.NodeContent:setVisible(true)
    self.data = data
    self.bgA:setVisible(true)
    self.bgD:setVisible(true)
    if troopType == 1 then
        self.bgD:setVisible(false)
    else
        self.bgA:setVisible(false)
    end

    self.num1:setVisible(true)
    self.num2:setVisible(true)
    if not self.battlePanel:checkUnLock(5, troopType) then
        self.bgD:setVisible(false)
        self.num1:setVisible(false)
        self.num2:setVisible(false)
    end

    if self.battlePanel:checkUnLock(7, troopType) then

        self.num1:setString(data.lCount)
        if data.lKilled == 0 then
            self.num2:setString(data.lKilled)
        else
            self.num2:setString("-"..data.lKilled)
        end
    else
        self.num1:setString("?")
        self.num2:setString("?")
    end

    local soldier_data = luaCfg:get_soldier_train_by(data.lID)
    local isSoldier = true
    if not soldier_data then
        isSoldier = false
        soldier_data = luaCfg:get_wild_property_by(data.lID)
    else
        if soldier_data.race <= 0 or soldier_data.race > 9 then
            isSoldier = false
        end
    end

    if self.battlePanel:checkUnLock(5, troopType) then

        self.node_icon.pic:setVisible(true)
        self.blue_bg:setVisible(true)
        if isSoldier then
            self.node_icon.pic:setScale(1)
            global.tools:setSoldierBustBattle(self.node_icon,soldier_data)
        else
            self.node_icon.pic:setScale(0.25)
            global.tools:setSoldierBust(self.node_icon,soldier_data)
            local clipData = luaCfg:get_picture_by(soldier_data.id*10+2)
            if not clipData then
                clipData = luaCfg:get_wild_picture_by(soldier_data.id*10+2)
            end
            self.node_icon.pic:setScale(0.25*clipData.scale/100)
        end
    else
        self.unknow:setVisible(true)
        self.blue_bg:setVisible(false)
        self.node_icon.pic:setVisible(false)
    end

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end
    if data.lSlv and (data.lSlv > 0) and (soldier_data.type ~= 0) and self.battlePanel:checkUnLock(5, troopType) then 
        showlvStar(data.lSlv or 1)
    else
        showlvStar(-1)
    end
        
end

--CALLBACKS_FUNCS_END

return UISoldierNode

--endregion
