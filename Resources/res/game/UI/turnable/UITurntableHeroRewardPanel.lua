--region UITurntableHeroRewardPanel.lua
--Author : wuwx
--Date   : 2017/12/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITurntableHeroItem = require("game.UI.turnable.UITurntableHeroItem")
--REQUIRE_CLASS_END

local UITurntableHeroRewardPanel  = class("UITurntableHeroRewardPanel", function() return gdisplay.newWidget() end )

function UITurntableHeroRewardPanel:ctor()
    self:CreateUI()
end

function UITurntableHeroRewardPanel:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_hero_reward")
    self:initUI(root)
end

function UITurntableHeroRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_hero_reward")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.go_ten = self.root.node_centre.go_ten_export
    self.btn_ten = self.root.node_centre.btn_ten_export
    self.ten_gray = self.root.node_centre.btn_ten_export.ten_gray_export
    self.btn_ten_icon = self.root.node_centre.btn_ten_export.btn_ten_icon_export
    self.btn_ten_text = self.root.node_centre.btn_ten_export.btn_ten_text_export
    self.FileNode_1 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.node_centre.FileNode_1)
    self.FileNode_2 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.node_centre.FileNode_2)
    self.FileNode_3 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.node_centre.FileNode_3)
    self.FileNode_4 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.node_centre.FileNode_4)
    self.FileNode_5 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.node_centre.FileNode_5)
    self.FileNode_6 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_6, self.root.node_centre.FileNode_6)
    self.FileNode_7 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_7, self.root.node_centre.FileNode_7)
    self.FileNode_8 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_8, self.root.node_centre.FileNode_8)
    self.FileNode_9 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_9, self.root.node_centre.FileNode_9)
    self.FileNode_10 = UITurntableHeroItem.new()
    uiMgr:configNestClass(self.FileNode_10, self.root.node_centre.FileNode_10)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onBgClose(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_ten, function(sender, eventType) self:onGet(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_ten, function(sender, eventType) self:onAgain(sender, eventType) end)
--EXPORT_NODE_END
end

function UITurntableHeroRewardPanel:setData(data, isTurnHalf)

    self.isTurnHalf = isTurnHalf
   
    local itemId = 6
    local num = 0
    for i,v in ipairs(data) do
        self["FileNode_"..i]:setData(v)
        self["FileNode_"..i]:showName()
        if tonumber(v.itemID) == 6 then
            num = num+tonumber(v.num)
        end
    end
    if tonumber(itemId) == 6 and tonumber(num) > 0 then
        global.propData:addProp(itemId,num,true)
    end

    self.isOver = false
    -- self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function ()
        
    local nodeTimeLine = resMgr:createTimeline("turntable/turntable_hero_reward")
    -- nodeTimeLine:setTimeSpeed(0.8)
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        self.isOver = true
    end)
    self:runAction(nodeTimeLine)
    -- end)))


    local data = global.luaCfg:get_turntable_hero_cfg_by(1)
    local Tencost = data.Tencost
    self.btn_ten_text:setString(9)
    self.m_Tencostc = Tencost
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,Tencost) then
        -- self.btn_ten_text:setTextColor(gdisplay.COLOR_RED)
        -- global.colorUtils.turnGray(self.ten_gray,true)
        -- self.btn_normal:setTouchEnabled(false)
        self.diaTenNotEnough = true
    else
        self.btn_ten_text:setTextColor(cc.c3b(255, 184, 34))
        global.colorUtils.turnGray(self.ten_gray,false)
    end


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITurntableHeroRewardPanel:onGet(sender, eventType)
    global.panelMgr:closePanel("UITurntableHeroRewardPanel")
end

function UITurntableHeroRewardPanel:onAgain(sender, eventType)
    global.panelMgr:closePanel("UITurntableHeroRewardPanel")

    if self.isTurnHalf then
        local panel = global.panelMgr:getPanelFileHandler("UITurntableHalfPanel")
        if panel then
            panel:onCostTenDiamond()
        else
            global.panelMgr:openPanel("UITurntableHalfPanel"):onCostTenDiamond()
        end
    else
        local panel = global.panelMgr:getPanelFileHandler("UITurntableHeroPanel")
        if panel then
            panel:onCostTenDiamond()
        else
            global.panelMgr:openPanel("UITurntableHeroPanel"):onCostTenDiamond()
        end
    end
end

function UITurntableHeroRewardPanel:onBgClose(sender, eventType)
    if not self.isOver then
        return
    end
    self:onGet()
end

function UITurntableHeroRewardPanel:onExit()

    if self.isTurnHalf then
        global.userData:resetFirstDyFreeLotteryCount()
        local panel = global.panelMgr:getPanelFileHandler("UITurntableHalfPanel")
        if panel then
            panel:initState()
        end
    else
        global.userData:resetFirstFreeLotteryCount()
        local panel = global.panelMgr:getPanelFileHandler("UITurntableHeroPanel")
        if panel then
            panel:refresh()
        end
    end
end

--CALLBACKS_FUNCS_END

return UITurntableHeroRewardPanel

--endregion
