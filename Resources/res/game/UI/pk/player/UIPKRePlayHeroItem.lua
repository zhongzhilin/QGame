--region UIPKRePlayHeroItem.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIPKRePlayHeroItem  = class("UIPKRePlayHeroItem", function() return gdisplay.newWidget() end )

function UIPKRePlayHeroItem:ctor()
    
end

function UIPKRePlayHeroItem:CreateUI()
    local root = resMgr:createWidget("player_kill/player/player_hero")
    self:initUI(root)
end

function UIPKRePlayHeroItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/player/player_hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.area = self.root.area_export
    self.bt_bg = self.root.bt_bg_export
    self.troops_hero = self.root.bt_bg_export.troops_hero_export
    self.hero_type = self.root.bt_bg_export.hero_type_export
    self.hero_bg = self.root.bt_bg_export.hero_bg_export
    self.nameBg = self.root.bt_bg_export.nameBg_export
    self.nameBg1 = self.root.bt_bg_export.nameBg1_export
    self.heroName = self.root.bt_bg_export.heroName_export
    self.heroLv = self.root.bt_bg_export.heroLv_export
    self.starlist = UIHeroStarList.new()
    uiMgr:configNestClass(self.starlist, self.root.bt_bg_export.starlist)
    self.left = self.root.bt_bg_export.left_export
    self.right = self.root.bt_bg_export.right_export
    self.power = self.root.bt_bg_export.power_export
    self.defenPowerIcon = self.root.bt_bg_export.defenPowerIcon_export
    self.failed = self.root.bt_bg_export.failed_export
    self.victory = self.root.bt_bg_export.victory_export
    self.effect = self.root.bt_bg_export.effect_export
    self.hurt = self.root.hurt_export

    uiMgr:addWidgetTouchHandler(self.bt_bg, function(sender, eventType) self:click_call(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPKRePlayHeroItem:onEnter()

    self.bt_bg:setTouchEnabled(false)
end 

function UIPKRePlayHeroItem:onExit()
    
    if self.nodeTimeLine and not tolua.isnull(self.nodeTimeLine) then 
        self.nodeTimeLine:gotoFrameAndPause(0)
    end 
end 

--  3 = {
-- [LUA-print] -                 "lGrade" = 40
-- [LUA-print] -                 "lID"    = 8216
-- [LUA-print] -                 "lPower" = 4013
-- [LUA-print] -             }


local luaCfg = global.luaCfg

function UIPKRePlayHeroItem:setData(data)

	self.data = data 
    local heroData = clone(global.luaCfg:get_hero_property_by(data.lID))
    heroData.serverData = data
    self:updateUI(heroData)

    self.power:setString(self.data.lPower)
end 

function UIPKRePlayHeroItem:updateUI(data)


    -- dump(data ,"data-->>UIPKRePlayHeroItem")

    self.bt_bg:setVisible(data and data.heroId ~=nil )

    if not data or data.heroId ==nil then 
        return 
    end 

    global.panelMgr:setTextureFor(self.troops_hero,data.nameIcon)
    self.heroName:setString(data.name)
    if data.serverData and data.serverData.lGrade then 
        self.heroLv:setString(string.format(luaCfg:get_local_string(10019),data.serverData.lGrade))
    end 
    self.hero_type:loadTexture(data.typeIcon, ccui.TextureResType.plistType)
    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)

    if data.serverData and data.serverData.lStar then 

        self.starlist:setData(data.heroId ,data.serverData.lStar)
       
    end 
end



local action_table ={
    ----actionName   time 
    { "animation0" , 1 , },

    { "animation1" , 2 , "ui_DivineItme" ,0.1  },

    { "animation2" , 3 , "Player_VS" ,0.7},

    { "animation3" , 4 ,},

    { "animation4" , 4 , },
    
    { "animation5" , 0.5 , "Player_Initial", 0.3},

    { "animation6" , 0.5 , },
}

function UIPKRePlayHeroItem:restUI()

    self.root:stopAllActions()

    self.nodeTimeLine =global.resMgr:createTimeline("player_kill/player/player_hero")
    self.root:runAction(self.nodeTimeLine)
    self.nodeTimeLine:gotoFrameAndPause(0)
end 


function UIPKRePlayHeroItem:runRePlayAction(tag , nomusic) 

    self.root:stopAllActions()

    self.nodeTimeLine = nil

    local animation = ""

    self.nodeTimeLine =global.resMgr:createTimeline("player_kill/player/player_hero")

    animation = action_table[tag]

    self.nodeTimeLine:play(animation[1], false)

    self.root:runAction(self.nodeTimeLine)

    if  animation[3] and animation~=""  then 
        if nomusic then return end 
         global.delayCallFunc(function()
            gevent:call(gsound.EV_ON_PLAYSOUND, animation[3])
        end,0 , animation[4] or 0)
    end 

    return animation[2]

end 

local  panelMgr = global.panelMgr

function UIPKRePlayHeroItem:click_call(sender, eventType)
    
    dump(self.data ,"sdf")


    if true then return end 


    local call = function(msg)

            msg.tgHero = msg.tgHero or {}
            msg.tgEquip = msg.tgEquip or {}
            if not msg.tgHero.lID then return end                   
            local heroData  = {}
            local equipData = {}
            for index,v in ipairs(msg.tgEquip) do        
                local equipLua = luaCfg:equipment()  
                for _,vv in pairs(equipLua) do
                    if vv.id == v.lGID then
                        v.lType = vv.type
                        break
                    end
                end
                equipData[v.lType] = {id = v.lGID, lv = v.lStronglv, lType = v.lType, lCombat=v.lCombat, tgAttr=v.tgAttr}
            end
            heroData.equipData = equipData
            heroData.serverData = msg.tgHero
            panelMgr:openPanel("UIShareHero"):setData(heroData)
    end

    local msg =panelMgr:getPanel("UIPKRePlayPanel"):getheroInfo(self.data.lID , self.data.userId)

    dump(msg ,"what the fuck ")

    call(msg)
end

function UIPKRePlayHeroItem:item_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIPKRePlayHeroItem

--endregion
