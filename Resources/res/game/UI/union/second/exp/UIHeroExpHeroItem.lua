--region UIHeroExpHeroItem.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIHeroExpHeroItem  = class("UIHeroExpHeroItem", function() return gdisplay.newWidget() end )

function UIHeroExpHeroItem:ctor()
    
end

function UIHeroExpHeroItem:CreateUI()
    local root = resMgr:createWidget("hero_exp/hero_node")
    self:initUI(root)
end

function UIHeroExpHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/hero_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.my_btn = self.root.my_btn_export
    self.head_icon = self.root.my_btn_export.head_icon_export
    self.lv = self.root.my_btn_export.lv_export
    self.right = self.root.my_btn_export.right_export
    self.left = self.root.my_btn_export.left_export
    self.my_red_bg = self.root.my_btn_export.my_red_bg_export
    self.hero_name = self.root.my_btn_export.my_red_bg_export.hero_name_export
    self.start = self.root.my_btn_export.start_export
    self.start = UIHeroStarList.new()
    uiMgr:configNestClass(self.start, self.root.my_btn_export.start_export)
    self.name_bg = self.root.name_bg_export
    self.name = self.root.name_export
    self.exit_bt = self.root.exit_bt_export

    uiMgr:addWidgetTouchHandler(self.my_btn, function(sender, eventType) self:chooseHero(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.exit_bt, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

    
function UIHeroExpHeroItem:setData(heroId) 
    self.data = heroId 
    self:updataUI()
end 

local luaCfg = global.luaCfg 

function UIHeroExpHeroItem:updataUI()

    if not self.data then 
        return 
    end 
    
    local data = global.luaCfg:get_hero_property_by(self.data)
    global.panelMgr:setTextureFor(self.head_icon,data.nameIcon)
    -- self.start:setVisible(false)
    self.hero_name:setString(data.name)
    if data.serverData and data.serverData.lGrade then 
        self.lv:setString(string.format(luaCfg:get_local_string(10019),data.serverData.lGrade))
    end 
    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)

end 

function UIHeroExpHeroItem:chooseHero(sender, eventType)
        
    print("excute ->>.")
    local curHeroData = global.luaCfg:get_hero_property_by(self.data)

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

function UIHeroExpHeroItem:setMode(state)

    self.my_red_bg:setVisible(state)
    self.name_bg:setVisible(state)
    self.name:setVisible(state)
end 


function UIHeroExpHeroItem:setSpringHero(heroData )

    self.name:setString(heroData.szName)
    self.lv:setString("Lv"..heroData.lLevel)
end 



function UIHeroExpHeroItem:setEnabled(state)
    self.my_btn:setTouchEnabled(state)
end 

function UIHeroExpHeroItem:getChooseHero()

    return global.luaCfg:get_hero_property_by(self.data)
end 


function UIHeroExpHeroItem:setHeroIcon(heroData)

    if not heroData then return end 

    self.data =  heroData.heroId

    self:updataUI()
end

function UIHeroExpHeroItem:setExitCall(exitCall)

    self.exitCall = exitCall
end 

function UIHeroExpHeroItem:exit_call(sender, eventType)
    
    if self.exitCall then 

        self.exitCall ()        
    end 
end
--CALLBACKS_FUNCS_END

return UIHeroExpHeroItem

--endregion
