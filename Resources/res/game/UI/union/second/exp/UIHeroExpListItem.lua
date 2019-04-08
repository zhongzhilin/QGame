--region UIHeroExpListItem.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroExpHeroItem = require("game.UI.union.second.exp.UIHeroExpHeroItem")
local UIHeroExpChoose = require("game.UI.union.second.exp.UIHeroExpChoose")
local UIHeroExpTimeItem = require("game.UI.union.second.exp.UIHeroExpTimeItem")
--REQUIRE_CLASS_END

local UIHeroExpListItem  = class("UIHeroExpListItem", function() return gdisplay.newWidget() end )

function UIHeroExpListItem:ctor()
    self:CreateUI()
end

function UIHeroExpListItem:CreateUI()
    local root = resMgr:createWidget("hero_exp/hero_union_node")
    self:initUI(root)
end

function UIHeroExpListItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/hero_union_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.main_player_name = self.root.main_player_name_export
    self.pro = self.root.exp_pro_mlan_8.pro_export
    self.main_hero = self.root.main_hero_export
    self.main_hero = UIHeroExpHeroItem.new()
    uiMgr:configNestClass(self.main_hero, self.root.main_hero_export)
    self.choose_hero = self.root.choose_hero_export
    self.choose_hero = UIHeroExpChoose.new()
    uiMgr:configNestClass(self.choose_hero, self.root.choose_hero_export)
    self.less_hero = self.root.less_hero_export
    self.less_hero = UIHeroExpHeroItem.new()
    uiMgr:configNestClass(self.less_hero, self.root.less_hero_export)
    self.help_name = self.root.less_hero_export.help_name_export
    self.over_time = self.root.over_time_export
    self.over_time = UIHeroExpTimeItem.new()
    uiMgr:configNestClass(self.over_time, self.root.over_time_export)

--EXPORT_NODE_END

    self.choose_hero:setData(function(data) 

        self:star(data)

    end ,self:getChooseHero() , function ()

       local inotherHeroData =global.unionData:getMyInOtherHeroData()

        if global.dataMgr:getServerTime() > self.data.lEndTime  then 

            global.tipsMgr:showWarning("heroExpTimeOver")

            return false 
        elseif global.userData:getUserId()  == self.data.lOwnID then 

            global.tipsMgr:showWarning("canHelpSelf")
            return false 

        elseif inotherHeroData then 

            global.tipsMgr:showWarning("oneTimeExp")
            return false 
        end 

        return true 
    end )

    self.main_hero:setEnabled(false)
    self.less_hero:setEnabled(false)

    self.main_hero:setMode(false)
    self.less_hero:setMode(false)

    self.less_hero.exit_bt:setVisible(false)
    self.main_hero.exit_bt:setVisible(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroExpListItem:setData(data) 

    self.data =data 
     
    local mainHero = global.unionData:getSpingSitHero(data, 0)
    local lessHero = global.unionData:getSpingSitHero(data , 1)


    self.choose_hero:setVisible(not lessHero)
    self.less_hero:setVisible(not self.choose_hero:isVisible())

    self.main_hero:setVisible(mainHero ~= nil)
    self.main_player_name:setVisible(mainHero ~= nil)

    if mainHero then

        self.main_hero:setData(mainHero.lHeroID)
        self.main_hero:setSpringHero(mainHero)
        self.main_hero.start:setData(mainHero.lHeroID ,tonumber(mainHero.szParams))

        self.main_player_name:setString(mainHero.szName)
    end 

    if lessHero then 

        self.less_hero:setData(lessHero.lHeroID)
        self.help_name:setString(lessHero.szName)

        self.less_hero:setSpringHero(lessHero)
        self.less_hero.start:setData(lessHero.lHeroID ,tonumber(lessHero.szParams))
    end 

    self.over_time:setData(self.data.lEndTime , function () 
    end)


    self.pro:setString(global.luaCfg:get_local_item_by(self.data.lToolID).typePara2.."%")


    global.tools:adjustNodePosForFather(self.pro:getParent(),self.pro , 10 )

end  

function UIHeroExpListItem:getChooseHero()

    return self.current_choose_hero or global.heroData:getGotHeroData()[1]
end 


function UIHeroExpListItem:star(herodata)

    if not herodata then return end 

    global.unionApi:heroSpring(function (msg) 

        global.panelMgr:openPanel("UIHeroExpPanel")

    end ,  2 , herodata.heroId , self.data.lID)
end 


--CALLBACKS_FUNCS_END

return UIHeroExpListItem

--endregion
