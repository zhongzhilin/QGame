--region UIHeroExpChoose.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroExpChoose  = class("UIHeroExpChoose", function() return gdisplay.newWidget() end )

function UIHeroExpChoose:ctor()
end

function UIHeroExpChoose:CreateUI()
    local root = resMgr:createWidget("hero_exp/choose_hero")
    self:initUI(root)
end

function UIHeroExpChoose:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/choose_hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.help_btn = self.root.help_btn_export
    self.addIcon1 = self.root.help_btn_export.addIcon1_export

    uiMgr:addWidgetTouchHandler(self.addIcon1, function(sender, eventType) self:shopHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroExpChoose:setData(call , heroData , checkCall)

    self.call = call 
    self.heroData = heroData

    self.checkCall = checkCall 
end 

function UIHeroExpChoose:shopHandler(sender, eventType)
        
    print("excute ->>.")

    if self.checkCall then 
        if  not self.checkCall() then 
            return 
        end 
    end 

    local curHeroData = self.heroData
    local data = global.heroData:getGotHeroData()
    local springHero =global.unionData:getMySpringHero()
    for key , v in ipairs(data) do 
        if table.hasval(springHero  ,v.heroId) then 
            table.remove(data , key)
        end 
    end 
    local panel = global.panelMgr:openPanel("UISelectHeroPanel")
    panel:setData(data[1] , nil ,nil ,data)
    panel:setTarget(self)
    panel:setExitCall(function()
    end)
end

function UIHeroExpChoose:setHeroIcon(heroData)
    if self.call then 
        self.call(heroData)
    end 
end 

--CALLBACKS_FUNCS_END

return UIHeroExpChoose

--endregion
