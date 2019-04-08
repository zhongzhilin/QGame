--region UITurntableHeroItem.lua
--Author : wuwx
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntableHeroItem  = class("UITurntableHeroItem", function() return gdisplay.newWidget() end )

function UITurntableHeroItem:ctor()
    
end

function UITurntableHeroItem:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_hero_reward_list")
    self:initUI(root)
end

function UITurntableHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_hero_reward_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.randomBtn = self.root.randomBtn_export
    self.effect1 = self.root.randomBtn_export.effect1_export
    self.quit = self.root.randomBtn_export.quit_export
    self.icon = self.root.randomBtn_export.quit_export.icon_export
    self.count_text = self.root.randomBtn_export.quit_export.count_text_export
    self.name_text = self.root.randomBtn_export.quit_export.name_text_export
    self.effect2 = self.root.randomBtn_export.effect2_export

    uiMgr:addWidgetTouchHandler(self.randomBtn, function(sender, eventType) self:randomHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.randomBtn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)

end

function UITurntableHeroItem:setData(i_data, isRoot)

    if type(i_data) ~= 'table' then return end

    self.randomBtn:setTouchEnabled(false)
    self.effect1:setVisible(false)
    self.effect2:setVisible(false)
    self.count_text:setVisible(true)
    -- self.name_text:setVisible(false)
    local data = global.luaCfg:get_local_item_by(i_data.itemID)
    self.heroItemData = i_data
    self.id = i_data.itemID
    self.data = data
    self.name_text:setString(data.itemName)
    self.count_text:setString(i_data.num)
    self.testStr = data.itemName
    if not i_data.isPool then
        self:showHighLv()
    end

    if i_data.random and i_data.random == 1 and isRoot and not i_data.isPool then

        local getLatticeData = function (pos)
            -- body
            for k,v in pairs(global.luaCfg:lattice()) do
                if v.pos == pos then
                    return v
                end
            end
        end
        local latConfig = getLatticeData(i_data.pos)
        if latConfig then
            global.panelMgr:setTextureForAsync(self.icon,latConfig.icon,true)
            self.name_text:setString(latConfig.name)
            global.panelMgr:setTextureForAsync(self.quit, string.format("icon/item/item_bg_0%d.png",latConfig.quality), true)
        end
        self.count_text:setVisible(false)
        self.randomBtn:setTouchEnabled(true)
        
    else
        global.panelMgr:getPanel("UITurntableHeroPanel"):showTips(self.icon,i_data.itemID)
        global.panelMgr:setTextureForAsync(self.icon,data.itemIcon,true)
        global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",data.quality),true)
    end

end

function UITurntableHeroItem:setTestStr(n)
    -- self.item_name:setString(self.testStr.."_"..n)
end

function UITurntableHeroItem:showHighLv()
    if (self.heroItemData.itemLv and self.heroItemData.itemLv > 0) then
        if not self.nodeTimeLine then
            local nodeTimeLine = resMgr:createTimeline("turntable/turntable_hero_reward_list",nil,self.root)
            nodeTimeLine:play("animation0", true)
            self.root:runAction(nodeTimeLine)
            self.nodeTimeLine = nodeTimeLine
        end
        self.effect1:setVisible(true)
        self.effect2:setVisible(true)
    end
end

function UITurntableHeroItem:showName()
    self.name_text:setVisible(true)
end

function UITurntableHeroItem:getItemId()
    return self.id
end

function UITurntableHeroItem:onExit()
    if self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl = nil
    end
    self.nodeTimeLine = nil
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITurntableHeroItem:randomHandler(sender, eventType)
    global.panelMgr:openPanel("UITurntablePool"):setData(self.heroItemData)
end
--CALLBACKS_FUNCS_END

return UITurntableHeroItem

--endregion
