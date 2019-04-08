--region UITurntableRewardPanel.lua
--Author : wuwx
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntableRewardPanel  = class("UITurntableRewardPanel", function() return gdisplay.newWidget() end )

function UITurntableRewardPanel:ctor()
    self:CreateUI()
end

function UITurntableRewardPanel:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_reward_new")
    self:initUI(root)
end

function UITurntableRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_reward_new")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.quit = self.root.Node_1.quit_export
    self.icon = self.root.Node_1.quit_export.icon_export
    self.count_text = self.root.Node_1.quit_export.count_text_export
    self.item_name = self.root.Node_1.item_name_export
    self.divFreeBtn = self.root.Node_1.divFreeBtn_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onBgClose(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.divFreeBtn, function(sender, eventType) self:onSure(sender, eventType) end)
--EXPORT_NODE_END
end

function UITurntableRewardPanel:setData(itemData, isTurnHalf)
    dump(itemData)
    self.isTurnHalf = isTurnHalf
    local itemId = itemData.itemID
    local num = itemData.num
    self.root.m_csbName = "turntable/turntable_reward_new"
    self.root.m_actionStr = "animation0"
    local tiemline = global.resMgr:addCsbTimeLine(self.root,nil,nil,nil,function()
        -- body
        self.root.m_csbName = "turntable/turntable_reward_new"
        self.root.m_actionStr = "animation1"
        global.resMgr:addCsbTimeLine(self.root,true,nil,nil)
    end)
    local data = global.luaCfg:get_local_item_by(itemId)
    self.item_name:setString(data.itemName)
    if num then
        self.count_text:setVisible(true)
        self.count_text:setString(num)
    else
        self.count_text:setVisible(false)
    end

    global.panelMgr:setTextureForAsync(self.icon,data.itemIcon,true)
    global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",data.quality),true)

    if tonumber(itemId) == 6 then
        global.propData:addProp(itemId,num,true)
    end
end

function UITurntableRewardPanel:onExit()

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

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITurntableRewardPanel:onSure(sender, eventType)
    global.panelMgr:destroyPanel("UITurntableRewardPanel")
end

function UITurntableRewardPanel:onBgClose(sender, eventType)
    global.panelMgr:destroyPanel("UITurntableRewardPanel")
end

--CALLBACKS_FUNCS_END

return UITurntableRewardPanel

--endregion
