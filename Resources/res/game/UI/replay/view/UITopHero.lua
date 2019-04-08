--region UITopHero.lua
--Author : anlitop
--Date   : 2017/06/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UITopHero  = class("UITopHero", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")

local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UITopHero:ctor()
    self:CreateUI()
end

function UITopHero:CreateUI()
    local root = resMgr:createWidget("player/node/player_top_hero")
    self:initUI(root)
end

function UITopHero:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/player_top_hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.type = self.root.type_export
    self.portrait_view = self.root.portrait_view_export
    self.portrait_node = self.root.portrait_view_export.portrait_node_export
    self.hero_icon = self.root.portrait_view_export.portrait_node_export.hero_icon_export
    self.normal_bg = self.root.portrait_view_export.normal_bg_export
    self.heroLv = self.root.heroLv_export
    self.right_kuang = self.root.right_kuang_export
    self.left_kuang = self.root.left_kuang_export
    self.hero_quality = self.root.hero_quality_export
    self.hero_epic = self.root.hero_quality_export.hero_epic_export
    self.start_node = self.root.start_node_export
    self.start_node = UIHeroStarList.new()
    uiMgr:configNestClass(self.start_node, self.root.start_node_export)
    self.node_killed = self.root.node_killed_export
    self.select_bg = self.root.select_bg_export
    self.heroName = self.root.heroName_export
    self.light1 = self.root.light1_export
    self.light2 = self.root.light2_export
    self.light3 = self.root.light3_export
    self.light4 = self.root.light4_export
    self.light5 = self.root.light5_export
    self.buffIcon = self.root.buffIcon_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function UITopHero:setData(data)
    

    local bule = cc.c3b( 36,108 ,  198)
    
    local zhufang = {global.luaCfg:get_local_string(10096),bule }
    local gongji =  { global.luaCfg:get_local_string(10124),gdisplay.COLOR_RED }
    local gongcheng = {global.luaCfg:get_local_string(10125),bule }
    local lueduo = { global.luaCfg:get_local_string(10126),gdisplay.COLOR_WHITE }
    local fangyu = { global.luaCfg:get_local_string(10127),gdisplay.COLOR_BULE }
    local fangong = { global.luaCfg:get_local_string(10189),gdisplay.COLOR_RED }
    local qiyi = { global.luaCfg:get_local_string(10210) , cc.c3b( 255,165 , 0)}

    local tc=  function (text, strAndColr)
        text:setString(strAndColr[1])
        text:setTextColor(strAndColr[2])
    end  


    self.data = clone(data)
    self.start_node:setVisible(false)

    self.buffIcon:setScale(0)

    if self.data.lTroopType == 4 then 
        if self.data.lHeroID then 
            local pro = global.heroData:getHeroPropertyById(self.data.lHeroID)
            if not pro then 
                --protect 
                return 
            end 

            if pro then
                global.panelMgr:setTextureFor(self.hero_icon,pro.nameIcon)
                self.hero_quality:setVisible(pro.quality ~= 1 )
                self.hero_quality:setVisible(false)
            end
            self.heroLv:setVisible(true)
            self.heroLv:setString("lv"..data.lHeroLV)

            self.start_node:setVisible(true)
            global.heroData:setHeroIconBg(self.data.lHeroID, self.left_kuang, self.right_kuang)
            self.start_node:setData(self.data.lHeroID , self.data.lHeroStar or 0 )

        else 
            self.hero_icon:setSpriteFrame("ui_surface_icon/troops_list_noicon.jpg")
            self.hero_icon:setScale(1)
            self.hero_quality:setVisible(false)
            self.heroLv:setVisible(false)
        end 

        self.heroName:setString(data.lLeaderName)
    end 


    if self.data.lCommand == 2 then 

       tc(self.type,gongji)
        
    elseif self.data.lCommand == 10 then 

       tc(self.type,fangyu)
    end 

    if self.data.lCommand == 1 then 
    
       tc(self.type,gongcheng)
    end 

    if self.data.lCommand == 6 then 
    
       tc(self.type,lueduo)

    end 

    if self.data.lCommand == 7 then 
    
       tc(self.type,qiyi)
    end 

    self:updateCount(data)

    self:addtips()
end


function UITopHero:updateCount(data)

    self.data =  clone(data)

    local soldier_count = 0 

    for _  ,v in pairs(self.data.tagSoldier) do 
        soldier_count  = soldier_count + v.lcount
    end 

    global.colorUtils.turnGray(self.root, soldier_count <= 0 )

    if soldier_count > 0 then 

        global.colorUtils.turnGray(self.start_node, false )

        if self.data.lHeroID and self.data.lHeroStar  then

            print("设置TopHero 180 "  ,self.data.lHeroID  ,  self.data.lHeroStar)

            self.start_node:setData(self.data.lHeroID , self.data.lHeroStar )
        end 
    end 

    self:turnGray(soldier_count > 0)
    global.colorUtils.turnGray(self.type, false)
    global.colorUtils.turnGray(self.select_bg, false)

    global.colorUtils.turnGray(self.node_killed, false)
    self.node_killed:setVisible(soldier_count <= 0)


    self:addtips()
end 


function UITopHero:addtips()

    self.data.tips_type  = "replayHero"


    local  node = global.panelMgr:getPanel("UIRePlayerPanel").tips_node

    if  self.m_TipsControl then  -- 城墙需要每次都更新数据

        self.m_TipsControl:updateData(self.data)

    else 
        self.m_TipsControl = UIItemTipsControl.new()

        self.m_TipsControl:setdata(self.normal_bg  , self.data,node)
    end 

    local tempdata = {} 

    if not self.m_TipsControl1  then 
        self.m_TipsControl1 = UIItemTipsControl.new()
         tempdata={information={}, tips_type="UIBuffDes",} 
        tempdata.itemAdd = self:getBuffAddByFrom(7)
        tempdata.divineAdd = self:getBuffAddByFrom(5)
        self.m_TipsControl1:setdata(self.buffIcon, tempdata, global.panelMgr:getTopPanel().tips_node)
    else 
        tempdata ={information={}, tips_type="UIBuffDes",} 
        tempdata.itemAdd = self:getBuffAddByFrom(7)
        tempdata.divineAdd = self:getBuffAddByFrom(5)
        self.m_TipsControl1:updateData(tempdata)
    end

    if tempdata.itemAdd[2] == 0 and tempdata.divineAdd[2] == 0 then 
    else
        self.buffIcon:setScale(0.8)
    end 
    -- global.colorUtils.turnGray(self.buffIcon,  tempdata.itemAdd[2] == 0 and tempdata.divineAdd[2] == 0)

end

function UITopHero:getBuffAddByFrom(lFrom)

    local tagbuffEffectFight = self.data.tagbuffEffectFight or {}
    for k,v in pairs(tagbuffEffectFight) do
        if v.lFrom == lFrom then
            local temp = {}
            table.insert(temp, v.lBuffId)
            table.insert(temp, v.lBuffValue)
            return temp
        end
    end
    return {0, 0}
end

function UITopHero:turnGray(status)
    for i=1 , 5 do 
        self["light"..i]:setVisible(status)
    end 
end 

function UITopHero:showAction0()
    self:setLocalZOrder(global.dataMgr:getServerTime())
    actionManger.getInstance():createTimeline(self.root  ,"topHero" , true , true)
end 

function UITopHero:hideHeroLight()
    local  timeLine = actionManger.getInstance():createTimeline(self.root  ,"topHero1" , true , true)
end 

return UITopHero

--endregion
