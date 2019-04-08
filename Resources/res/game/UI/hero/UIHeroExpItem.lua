--region UIHeroExpItem.lua
--Author : Administrator
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroExpItem  = class("UIHeroExpItem", function() return gdisplay.newWidget() end )

function UIHeroExpItem:ctor()
    
end

function UIHeroExpItem:CreateUI()
    local root = resMgr:createWidget("hero/hero_exp_bar")
    self:initUI(root)
end

function UIHeroExpItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_exp_bar")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.strengthBuy = self.root.strengthBuy_export
    self.exp_bar_bg = self.root.exp_bar_bg_export
    self.icon_Exp = self.root.icon_Exp_export
    self.hero_exp1 = self.root.hero_exp1_export
    self.tips = self.root.tips_export

    uiMgr:addWidgetTouchHandler(self.strengthBuy, function(sender, eventType) self:addEnergy_click(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:configUILanguage(self.tips, "hero/hero_lv_tips_node")


    global.tipsMgr:registerLongPress(self, self.exp_bar_bg, self.tips ,
        function() end, function(beginPos)

            local pos = self:convertToNodeSpaceAR(beginPos)            

            self.tips:runAction(cc.FadeIn:create(0.2))
            self.tips:setPosition(pos)

            local outNodePos = self.tips.outNode:convertToWorldSpace(cc.p(0,0))
            if outNodePos.x > gdisplay.width then

                self.tips:setPositionX(self.tips:getPositionX() + (gdisplay.width - outNodePos.x))
            end

            self.tips.Image_1.max_node.max_lv_export:setString(global.heroData:getHeroTrueMaxLevel())

            --润稿跟随   
            global.tools:adjustNodePos(self.tips.Image_1.max_node.max_lv1_mlan_12,self.tips.Image_1.max_node.max_lv_export)
            global.tools:adjustNodePos(self.tips.Image_1.max_node.max_lv_export,self.tips.Image_1.max_node.max_lv2_mlan_2)
        end)
end

function UIHeroExpItem:setData(serverData)

    self.data = serverData
    -- local par = 0

    local contentExp = serverData.lCurEXP or 0

    serverData.lGrade =  serverData.lGrade or 0 

    if serverData.lGrade >= global.heroData:getHeroMaxLevel() then

        -- self.exp_LoadingBar:setPercent(100)
        -- par = 100
        self.hero_exp1:setString("MAX")
        self.strengthBuy:setEnabled(false)
    else
        local config = luaCfg:get_hero_exp_by(serverData.lGrade) or {}
        local nextExp =config.exp or 1
        -- self.exp_LoadingBar:setPercent(contentExp / nextExp * 100)
        -- par = contentExp / nextExp * 100
        self.hero_exp1:setString(contentExp .. "/" .. nextExp)
        self.strengthBuy:setEnabled(not (serverData.isMode or serverData.lState == -1))
    end

    self.icon_Exp:setPositionX(310 - self.hero_exp1:getContentSize().width)

    -- self.exp_loading_pic:setPositionX(par / 100 * 261)    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroExpItem:addEnergy_click(sender, eventType)
    
    if not self.data then return end
    if self.data.lGrade >= global.heroData:getHeroTrueMaxLevel() then

        global.tipsMgr:showWarning("HeroLvLimit")
        return
    end

    local panel = global.panelMgr:openPanel("UISpeedPanel")
    panel:setData(nil, 0, panel.TYPE_HERO_EXP, self.data.lID)
end
--CALLBACKS_FUNCS_END

return UIHeroExpItem

--endregion
