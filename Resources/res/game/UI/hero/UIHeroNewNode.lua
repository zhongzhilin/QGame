--region UIHeroNewNode.lua
--Author : Untory
--Date   : 2017/11/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UILongTipsControl = require("game.UI.common.UILongTipsControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroNewNode  = class("UIHeroNewNode", function() return gdisplay.newWidget() end )

function UIHeroNewNode:ctor()
    
end

function UIHeroNewNode:CreateUI()
    local root = resMgr:createWidget("hero/hero_new_node")
    self:initUI(root)
end

function UIHeroNewNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_new_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.strengthBuy = self.root.strengthBuy_export
    self.task_btn = self.root.task_btn_export
    self.loadingbar_bg = self.root.loadingbar_bg_export
    self.LoadingBar = self.root.loadingbar_bg_export.LoadingBar_export
    self.info = self.root.loadingbar_bg_export.info_export
    self.icon = self.root.icon_export

    uiMgr:addWidgetTouchHandler(self.strengthBuy, function(sender, eventType) self:addEnergy_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.task_btn, function(sender, eventType) self:onHelp(sender, eventType) end)
--EXPORT_NODE_END
    
    self.tipsControl = UILongTipsControl.new(self.icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
end

function UIHeroNewNode:onEnter()
    
    self.nodeTimeLine = resMgr:createTimeline("hero/hero_new_node")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)    
end

function UIHeroNewNode:setData(data)

    self.nodeTimeLine:gotoFrameAndPause(0)

    self.data = data
    global.panelMgr:setTextureFor(self.icon,'icon/item/item_icon_' .. data.heroId .. '.png')

    local itemId = self:getItemID()

    self.tipsControl:setData({information = luaCfg:get_item_by(itemId)})

    local count = global.normalItemData:getItemById(itemId).count
    local hero_strengthen = luaCfg:get_hero_strengthen_by(data.heroId)    
    local key = 'item' .. (data.serverData.lStar + 1)
    local grow = 1
    if hero_strengthen and  hero_strengthen[key] and type(hero_strengthen[key]) == "table" and #hero_strengthen[key] == 2 then
        dump(hero_strengthen[key],'hero_strengthen[key]')
        grow = hero_strengthen[key][2]
    end 
    local isGot = (data.state == 1 or data.state == 3 or data.state == 4)
    local maxStep = hero_strengthen.maxStep
    self.info:setString(count .. '/' .. grow)
    self.LoadingBar:setPercent(count / grow * 100)

    self.count = count
    self.isEnoughItem = (count >= grow)

    global.colorUtils.turnGray(self.task_btn,true) 
    self.task_btn.Sprite_1:setVisible(false)

    if data.serverData.lStar >= maxStep then
        -- 已经满街
        self.info:setString(luaCfg:get_local_string(10928))        
    else
        if self.isEnoughItem and isGot then
            self.nodeTimeLine:play('animation0',true)
            self.task_btn.Sprite_1:setVisible(true)
            global.colorUtils.turnGray(self.task_btn,false) 
        end
    end    

    self.task_btn:setEnabled(data.serverData.lStar < maxStep and isGot)
    -- global.colorUtils.turnGray(self.task_btn,data.serverData.lStar >= maxStep)
end

function UIHeroNewNode:getCurCount()
    return self.count
end

function UIHeroNewNode:getItemID()
    
    local items = luaCfg:item()
    for _,v in pairs(items) do

        if v.itemType == 123 and v.typePara1 == self.data.heroId then

            return v.itemId
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroNewNode:addEnergy_click(sender, eventType)

    global.panelMgr:openPanel("UIHeroNoOrder"):setData(nil, self.data.heroId)
end

function UIHeroNewNode:onHelp(sender, eventType)

    -- local oldData = clone(self.data)
    -- global.commonApi:heroAction(self.data.heroId, 7, 0, 0, 0, function(msg)
    
    --     global.heroData:updateVipHero(msg.tgHero[1])
    --     global.panelMgr:openPanel('UIHeroStarUp'):setData(oldData)
    -- end) 

    local panelName = global.panelMgr:getTopPanelName()
    global.panelMgr:openPanel('UIHeroStarUp'):setData(self.data,self.isEnoughItem,panelName)
end
--CALLBACKS_FUNCS_END

return UIHeroNewNode

--endregion
