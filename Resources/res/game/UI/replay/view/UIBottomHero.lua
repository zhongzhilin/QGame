--region UIBottomHero.lua
--Author : anlitop
--Date   : 2017/06/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END
local luaCfg = global.luaCfg
local UIBottomHero  = class("UIBottomHero", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")

local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

local luaCfg = global.luaCfg

function UIBottomHero:ctor()
    self:CreateUI()
end

function UIBottomHero:CreateUI()
    local root = resMgr:createWidget("player/node/player_bottom_hero")
    self:initUI(root)
end

function UIBottomHero:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/player_bottom_hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_view = self.root.portrait_view_export
    self.portrait_node = self.root.portrait_view_export.portrait_node_export
    self.hero_icon = self.root.portrait_view_export.portrait_node_export.hero_icon_export
    self.normal_quality = self.root.portrait_view_export.normal_quality_export
    self.hero_quality = self.root.hero_quality_export
    self.hero_epic = self.root.hero_quality_export.hero_epic_export
    self.start_node = self.root.start_node_export
    self.start_node = UIHeroStarList.new()
    uiMgr:configNestClass(self.start_node, self.root.start_node_export)
    self.node_killed = self.root.node_killed_export
    self.type = self.root.type_export
    self.wild_icon = self.root.wild_icon_export
    self.heroName = self.root.heroName_export
    self.heroLv = self.root.heroLv_export
    self.left_kuang = self.root.left_kuang_export
    self.right_kuang = self.root.right_kuang_export
    self.select_bg = self.root.select_bg_export
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
function UIBottomHero:setData(data)
    
    self.data = clone(data)  
    -- self.hero_icon:setSpriteFrame("ui_surface_icon/troops_list_noicon.jpg")
    dump(self.data ,"UIBottomHero")

    self.wild_icon:setVisible(false)

    self.buffIcon:setScale(0)

    local bule = cc.c3b( 36,108 ,  198)

    local zhufang = {global.luaCfg:get_local_string(10096),bule }
    local gongji = {global.luaCfg:get_local_string(10124) , gdisplay.COLOR_RED}
    local gongcheng ={global.luaCfg:get_local_string(10125), bule}
    local lueduo = {global.luaCfg:get_local_string(10126), gdisplay.COLOR_WHITE}
    local fangyu = {global.luaCfg:get_local_string(10127), bule}
    local fangong ={ global.luaCfg:get_local_string(10189), gdisplay.COLOR_RED}
    local tc=  function (text, strAndColr)
        text:setString(strAndColr[1])
        text:setTextColor(strAndColr[2])
    end  

-- 1   占领(攻击方)
-- 2   攻击(攻击方)
-- 3   侦查(攻击方)
-- 4   增援(攻击方，防御方)
-- 5   驻防(防御方)
-- 6   内城(防御方) 防御
-- 10  城外驻防(防御方)  反扑
-- //部队类型  1:城池战  2.打野地 3.打野怪 4.英雄类型 5.怪物营地 6.小村庄 7.奇迹战斗


-- //战斗类型  1:城池战  2.打野地 3.打野怪 5.怪物营地 6.小村庄 7.奇迹战斗

    self.start_node:setVisible(false)

    local setHero = function (HeroData)
    
        if HeroData.lHeroID then 

            local pro = global.heroData:getHeroPropertyById(HeroData.lHeroID )
            if pro then
                global.panelMgr:setTextureFor(self.hero_icon,pro.nameIcon)
                self.hero_quality:setVisible(pro.quality ~=  1 )
                self.hero_quality:setVisible(false)
            end
            self.heroLv:setVisible(true)
            self.heroLv:setString("lv"..HeroData.lHeroLV)
            self.hero_icon:setScale(0.3)
       
            self.start_node:setVisible(true)
            global.heroData:setHeroIconBg(HeroData.lHeroID, self.left_kuang, self.right_kuang)
            self.start_node:setData(self.data.lHeroID , self.data.lHeroStar or 0 )

        else 
            self.hero_icon:setSpriteFrame("ui_surface_icon/troops_list_noicon.jpg")
            self.hero_icon:setScale(1)
            self.hero_quality:setVisible(false)
            self.heroLv:setVisible(false)
        end 

        self.heroName:setString(HeroData.lLeaderName)
    end 
    

    if self.data.war_type == 1 or  self.data.war_type == 6 then ---城池站


        setHero(data)

        if self.data.lCommand == 2 then 

            tc(self.type, gongji)

        elseif self.data.lCommand == 6 then 

            tc(self.type, fangyu)

        elseif self.data.lCommand == 10 then 

            tc(self.type, zhufang)

        elseif self.data.lCommand == 5  then 

            tc(self.type, zhufang)
        end 

    else 

        self.hero_icon:setSpriteFrame("ui_surface_icon/troops_list_noicon.jpg")
        self.hero_icon:setScale(1)
        self.hero_quality:setVisible(false)
        self.heroLv:setVisible(false)

        if self.data.lCommand == 10 and self.data.lTroopType ==3 then 

            tc(self.type, fangong)
        end 

        if self.data.lCommand == 6 and self.data.lTroopType ==2 then 
            tc(self.type, fangong)
        end

        if self.data.lCommand == 6 and self.data.lTroopType ==3 then 

            tc(self.type, fangong)
        end

        if self.data.lCommand == 10 and self.data.lTroopType == 3 then 

            tc(self.type, fangong)
        end


        if   self.data.war_type == 2  then  -- 打野地

            -- self.wild_icon:setVisible(true)
            -- self.hero_icon:setVisible(false)
                
            if self.data.lTroopType == 4 then  -- 英雄类型

                setHero(data)
            else 

                local info = luaCfg:get_wild_res_by(self.data.lHeroID)
                self.heroName:setString(info.name)
            end 
            -- local suface = luaCfg:get_world_surface_by(info.file)
            -- global.panelMgr:setTextureFor(self.wild_icon,suface.worldmap)
            
            if self.data.lCommand == 10  then 

                tc(self.type, fangyu)
            end

            if self.data.lCommand == 6 then 

                tc(self.type, fangong)
            end


            if self.data.lCommand == 5 then 

                tc(self.type, zhufang)
            end 
 

        elseif self.data.war_type == 3 or self.data.war_type ==9 then -- 打野怪  世界boos

            -- self.wild_icon:setVisible(true)
            -- self.hero_icon:setVisible(false)

            local info = luaCfg:get_wild_monster_by(self.data.lHeroID) or {}

            print(info , "info ///////")

            self.heroName:setString(info.name or "")

            if self.data.lCommand == 10  then 

                 tc(self.type, fangyu)
            end

            if self.data.lCommand == 6  then 

                 tc(self.type, fangong)
            end

            -- local suface = luaCfg:get_world_surface_by(info.file)
            -- global.panelMgr:setTextureFor(self.wild_icon,suface.worldmap)

        elseif self.data.war_type == 4 then 

            -- self.heroName:setString(luaCfg:get_wild_monster_by(self.data.lHeroID))

        elseif self.data.war_type == 5 then  -- 营地

            -- self.wild_icon:setVisible(true)
            --  self.hero_icon:setVisible(false)
             if self.data.lTroopType == 4 then  -- 英雄类型

                setHero(data)
            
            elseif self.data.lTroopID == 5 then 

            else  

                local info = luaCfg:get_world_camp_by(self.data.lHeroID)
                self.heroName:setString(info.name)
            end 

            -- local suface = luaCfg:get_world_surface_by(info.file)
            -- global.panelMgr:setTextureFor(self.wild_icon,suface.worldmap)

            if  self.data.lCommand ==  10 then 
                tc(self.type, zhufang)
            else 
                tc(self.type, zhufang)
            end 

        elseif self.data.war_type == 6 then  --小村庄

             --上面已经处理过

        elseif self.data.war_type == 7 then  -- 奇迹

            -- self.wild_icon:setVisible(true)
            -- self.hero_icon:setVisible(false)

            if self.data.lTroopType == 4 then  -- 英雄类型
                setHero(data)
            elseif self.data.lTroopID == 5 then 
 
            else 
                local info = luaCfg:get_world_miracle_by(self.data.lHeroID)
                self.heroName:setString(info.name)
            end 

            -- local suface = luaCfg:get_world_surface_by(info.file)
            -- global.panelMgr:setTextureFor(self.wild_icon,suface.worldmap)

            if  self.data.lCommand ==  10 then 
                tc(self.type, zhufang)
            end 

            if  self.data.lCommand ==  5 then 
                tc(self.type, zhufang)
            end

            if  self.data.lTroopID == 5 then 
                tc(self.type, zhufang)
            end 
            
        end  

    end 


    if self.data.lTroopID == 5 then  -- 城堡 

        self.buffIcon:setScale(0)

        self.hero_icon:setSpriteFrame("ui_surface_icon/icon_wall.png")
        self.hero_icon:setScale(1)
        self.hero_quality:setVisible(false)
        self.heroLv:setVisible(false)

        self.heroName:setString( global.luaCfg:get_local_string(10090))

        tc(self.type, zhufang)
    end 


    self:updateCount(data)

    self:addtips()
end

function UIBottomHero:updateCount(data)

    self.data = clone(data)

    -- if self.data.lHeroID  == 8203 then 
    --     dump(self.data ,"self.data///////////")
    -- end 

    local soldier_count = 0 
    for _  ,v in pairs(self.data.tagSoldier or {} ) do 
        soldier_count  = soldier_count + v.lcount
    end 
    global.colorUtils.turnGray(self.root, soldier_count <= 0 )

    if soldier_count > 0 then 

        global.colorUtils.turnGray(self.start_node, false )

        if self.data.lHeroID and  self.data.lHeroStar  then 
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

function UIBottomHero:turnGray(status)
    for i=1 , 5 do 
        self["light"..i]:setVisible(status)
    end 
end 

function UIBottomHero:addtips()

    self.data.tips_type  = "replayHero"


    local  node = global.panelMgr:getPanel("UIRePlayerPanel").tips_node

    if  self.m_TipsControl then  -- 城墙需要每次都更新数据

        self.m_TipsControl:updateData(self.data)

    else 
        self.m_TipsControl = UIItemTipsControl.new()

        self.m_TipsControl:setdata(self.normal_quality  , self.data,node)
    end 

    local tempdata  = {}
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
    -- global.colorUtils.turnGray()

end


function UIBottomHero:getBuffAddByFrom(lFrom)

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


function UIBottomHero:cleanTips()
    if self. m_TipsControl then 

        self. m_TipsControl:ClearEventListener()
        self.m_TipsControl = nil 

    end    
end 

function UIBottomHero:showAction0()
    self:setLocalZOrder(global.dataMgr:getServerTime())
    actionManger.getInstance():createTimeline(self.root ,"bottomHero" , true , true)
end 

function UIBottomHero:hideHeroLight()
    local  timeLine = actionManger.getInstance():createTimeline(self.root  ,"bottomHero1" , true , true)
end 


function UIBottomHero:onExit()

    self:cleanTips()
end 

return UIBottomHero

--endregion
