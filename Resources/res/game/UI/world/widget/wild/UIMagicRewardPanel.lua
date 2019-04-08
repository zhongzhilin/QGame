--region UIMagicRewardPanel.lua
--Author : untory
--Date   : 2016/12/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIMagicRewardInfoItem = require("game.UI.world.widget.wild.UIMagicRewardInfoItem")
local UITownSoldier = require("game.UI.world.widget.wild.UITownSoldier")
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIMagicRewardPanel  = class("UIMagicRewardPanel", function() return gdisplay.newWidget() end )

function UIMagicRewardPanel:ctor()
    self:CreateUI()
end

function UIMagicRewardPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_miracle_reward_bg")
    self:initUI(root)
end

function UIMagicRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_miracle_reward_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_mlan_12_export
    self.FileNode_1 = UIMagicRewardInfoItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.bg_view = self.root.Node_export.bg_view_export
    self.num1 = self.root.Node_export.recruit_title.num1_mlan_5_export
    self.num = self.root.Node_export.recruit_title.num_export
    self.round1 = self.root.Node_export.recruit_title.round1_mlan_5_export
    self.round = self.root.Node_export.recruit_title.round_export
    self.tips1 = self.root.Node_export.recruit_title.tips1_mlan_10_export
    self.d1 = UITownSoldier.new()
    uiMgr:configNestClass(self.d1, self.root.Node_export.recruit_title.d1)
    self.d2 = UITownSoldier.new()
    uiMgr:configNestClass(self.d2, self.root.Node_export.recruit_title.d2)
    self.d3 = UITownSoldier.new()
    uiMgr:configNestClass(self.d3, self.root.Node_export.recruit_title.d3)
    self.d4 = UITownSoldier.new()
    uiMgr:configNestClass(self.d4, self.root.Node_export.recruit_title.d4)
    self.wall_lv1 = self.root.Node_export.recruit_title_0.wall_lv1_mlan_5_export
    self.wall_lv = self.root.Node_export.recruit_title_0.wall_lv_export
    self.buff1 = self.root.Node_export.recruit_title_0.buff1_mlan_5_export
    self.buff = self.root.Node_export.recruit_title_0.buff_export
    self.a1 = UITownSoldier.new()
    uiMgr:configNestClass(self.a1, self.root.Node_export.recruit_title_0.a1)
    self.a2 = UITownSoldier.new()
    uiMgr:configNestClass(self.a2, self.root.Node_export.recruit_title_0.a2)
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitclick(sender, eventType) end)
--EXPORT_NODE_END 

    -- print(self.FileNode_2:getScale(),'self.FileNode_2')
    -- print(self.FileNode_2.root:getScale(),'self.FileNode_2')

    uiMgr:addWidgetTouchHandler(self.close_node.close_btn_export, function(sender, eventType) self:close_call(sender, eventType) end)
    self.close_node:setData(function ()
        global.panelMgr:closePanel("UIMagicRewardPanel")
    end)
end

function  UIMagicRewardPanel:close_call(sender, eventType)
    global.panelMgr:closePanel("UIMagicRewardPanel")
end

function UIMagicRewardPanel:setData(data,world_camp_data,cfgData)
    -- body
    local tgSoldier = data.tgSoldier
    local tgSoldierCount = #tgSoldier
    for i = 1,4 do

        local d = self["d"..i]

        if i <= tgSoldierCount then

            d:setVisible(true)
            d:setData(tgSoldier[i],true)
        else
            
            d:setVisible(false)
        end
    end


    self.name:setString(global.luaCfg:get_local_string(10190))
    if not cfgData then
        -- 自己占领的奇迹的奖励界面
        self.tips1:setString(global.luaCfg:get_local_string(10249))
        -- self.FileNode_1:setVisible(false)
        self.FileNode_1:setData()
        self.Node.recruit_title_0:setVisible(false)
        self.round:setVisible(false)
        self.round1:setVisible(false)
        self.bg_view:setVisible(true)
    else
        self.tips1:setString(global.luaCfg:get_local_string(11042))
        -- self.FileNode_1:setVisible(true)
        self.Node.recruit_title_0:setVisible(true)
        self.round:setVisible(true)
        self.round1:setVisible(true)
        self.bg_view:setVisible(false)

        self.FileNode_1:setData(cfgData)
        self.a1:setData({lID = 8071,lCount = world_camp_data.towerNum})
        self.a2:setData({lID = 8072,lCount = world_camp_data.trapNum})
        self.round:setString(data.lCurRound + 1)
        self.num:setString(data.lPower)
        self.wall_lv:setString(world_camp_data.wallLv)
        self.buff:setString(string.format("%s%%",world_camp_data.defBuff))

        --润稿翻译处理 张亮
        global.tools:adjustNodePos(self.wall_lv1,self.wall_lv,5)
        global.tools:adjustNodePos(self.buff1,self.buff,5)
        global.tools:adjustNodePos(self.round1,self.round,5)
    end
    global.tools:adjustNodePos(self.num1,self.num,5)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMagicRewardPanel:exitCall(sender, eventType)

    global.panelMgr:closePanelForBtn("UIMagicRewardPanel")
end

function UIMagicRewardPanel:exitclick(sender, eventType)
    self:exitCall()
end
--CALLBACKS_FUNCS_END

return UIMagicRewardPanel

--endregion
