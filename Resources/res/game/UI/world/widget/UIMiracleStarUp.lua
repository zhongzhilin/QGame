--region UIMiracleStarUp.lua
--Author : Untory
--Date   : 2018/02/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UICommonStars = require("game.UI.world.widget.UICommonStars")
local UIMiracleStarUpPro = require("game.UI.world.widget.UIMiracleStarUpPro")
--REQUIRE_CLASS_END

local UIMiracleStarUp  = class("UIMiracleStarUp", function() return gdisplay.newWidget() end )

function UIMiracleStarUp:ctor()
    self:CreateUI()
end

function UIMiracleStarUp:CreateUI()
    local root = resMgr:createWidget("hero/miracle_star_up")
    self:initUI(root)
end

function UIMiracleStarUp:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/miracle_star_up")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.node1 = self.root.Node_export.bg_export.node1_export
    self.effect = self.root.Node_export.bg_export.effect_export
    self.up_btn = self.root.Node_export.up_btn_export
    self.stars1 = UICommonStars.new()
    uiMgr:configNestClass(self.stars1, self.root.Node_export.stars1)
    self.stars2 = UICommonStars.new()
    uiMgr:configNestClass(self.stars2, self.root.Node_export.stars2)
    self.buff_0 = UIMiracleStarUpPro.new()
    uiMgr:configNestClass(self.buff_0, self.root.Node_export.buff_0)
    self.buff_1 = UIMiracleStarUpPro.new()
    uiMgr:configNestClass(self.buff_1, self.root.Node_export.buff_1)
    self.buff_2 = UIMiracleStarUpPro.new()
    uiMgr:configNestClass(self.buff_2, self.root.Node_export.buff_2)
    self.buff_3 = UIMiracleStarUpPro.new()
    uiMgr:configNestClass(self.buff_3, self.root.Node_export.buff_3)
    self.cost = self.root.Node_export.update_cost_mlan_8.cost_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.up_btn, function(sender, eventType) self:up_star(sender, eventType) end)
--EXPORT_NODE_END
end

function UIMiracleStarUp:getReward(miracleType,star)
    
    local rewards = luaCfg:miracle_upgrade()
    for  _,v in ipairs(rewards) do
        if v.type == miracleType and star == v.lv then
            return v
        end
    end

    return false
end

function UIMiracleStarUp:setData(miracleRewardData,miracleData,star)
    

    self.stars1:setData(star)
    self.stars2:setData(star + 1)

    local miracleType = miracleData.lType
    local rewardData = self:getReward(miracleType,star)   
    local nextRewardData = self:getReward(miracleType,star + 1)   
    self.cityId = miracleData.lMapID

    self.cost:setString(nextRewardData.cost)

    for i = 0,3 do
        self['buff_' .. i]:setVisible(false)
    end

    for i,v in ipairs(miracleRewardData.buff) do
        self['buff_' .. (i - 1)]:setData(v,nextRewardData.upPro,rewardData.upPro)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMiracleStarUp:exitCall(sender, eventType)
    
    global.panelMgr:closePanelForBtn('UIMiracleStarUp')
end

function UIMiracleStarUp:up_star(sender, eventType)
    
    global.worldApi:miracleStarUp(self.cityId,function(msg)
        global.panelMgr:closePanel('UIMiracleStarUp')
        global.panelMgr:getPanel('UIMagicOwnPanel'):upStar()
        global.tipsMgr:showWarning('cityUpgradeSuccess')
    end)
end
--CALLBACKS_FUNCS_END

return UIMiracleStarUp

--endregion
