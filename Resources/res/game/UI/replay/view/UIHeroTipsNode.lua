--region UIHeroTipsNode.lua
--Author : anlitop
--Date   : 2017/07/31
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
local UITipsSoliderNode = require("game.UI.replay.view.UITipsSoliderNode")
local UIEqipNode = require("game.UI.replay.view.UIEqipNode")
--REQUIRE_CLASS_END

local UIHeroTipsNode  = class("UIHeroTipsNode", function() return gdisplay.newWidget() end )
local luaCfg  = global.luaCfg

local UITipsSoliderNode = require("game.UI.replay.view.UITipsSoliderNode")

function UIHeroTipsNode:ctor()
    self:CreateUI()
end

function UIHeroTipsNode:CreateUI()
    local root = resMgr:createWidget("common/war_tips_node")
    self:initUI(root)
end

function UIHeroTipsNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/war_tips_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node1 = self.root.bg.node1_export
    self.lord_name = self.root.bg.node1_export.lord_name_export
    self.hero_bg = self.root.bg.node1_export.hero.hero_bg_export
    self.portrait_node = self.root.bg.node1_export.hero.hero_bg_export.portrait_node_export
    self.hero_icon = self.root.bg.node1_export.hero.hero_bg_export.portrait_node_export.hero_icon_export
    self.hero_quality = self.root.bg.node1_export.hero.hero_quality_export
    self.hero_epic = self.root.bg.node1_export.hero.hero_quality_export.hero_epic_export
    self.heroLv = self.root.bg.node1_export.hero.heroLv_export
    self.hero_def_icon = self.root.bg.node1_export.hero.hero_def_icon_export
    self.hero_attack_icon = self.root.bg.node1_export.hero.hero_attack_icon_export
    self.right_kuang = self.root.bg.node1_export.right_kuang_export
    self.left_kuang = self.root.bg.node1_export.left_kuang_export
    self.start_node = self.root.bg.node1_export.start_node_export
    self.start_node = UIHeroStarList.new()
    uiMgr:configNestClass(self.start_node, self.root.bg.node1_export.start_node_export)
    self.hero_name = self.root.bg.Node_11.arms_mlan_5.hero_name_export
    self.troop_name = self.root.bg.Node_11.type_mlan_5.troop_name_export
    self.chief_number = self.root.bg.Node_11.destructive_mlan_7.chief_number_export
    self.combat_num = self.root.bg.Node_11.atk_combat_mlan_8.combat_num_export
    self.soliderScrollView = self.root.soliderScrollView_export
    self.FileNode_1 = UITipsSoliderNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.soliderScrollView_export.FileNode_1)
    self.equip_1 = self.root.equip_node.equip_1_export
    self.equip_1 = UIEqipNode.new()
    uiMgr:configNestClass(self.equip_1, self.root.equip_node.equip_1_export)
    self.equip_2 = self.root.equip_node.equip_2_export
    self.equip_2 = UIEqipNode.new()
    uiMgr:configNestClass(self.equip_2, self.root.equip_node.equip_2_export)
    self.equip_3 = self.root.equip_node.equip_3_export
    self.equip_3 = UIEqipNode.new()
    uiMgr:configNestClass(self.equip_3, self.root.equip_node.equip_3_export)
    self.equip_4 = self.root.equip_node.equip_4_export
    self.equip_4 = UIEqipNode.new()
    uiMgr:configNestClass(self.equip_4, self.root.equip_node.equip_4_export)
    self.equip_5 = self.root.equip_node.equip_5_export
    self.equip_5 = UIEqipNode.new()
    uiMgr:configNestClass(self.equip_5, self.root.equip_node.equip_5_export)
    self.equip_6 = self.root.equip_node.equip_6_export
    self.equip_6 = UIEqipNode.new()
    uiMgr:configNestClass(self.equip_6, self.root.equip_node.equip_6_export)

--EXPORT_NODE_END

     self.soldier_first_ps ={}
    self.soldier_first_ps.x , self.soldier_first_ps.y =   self.FileNode_1:getPosition()


    global.tools:adjustNodePosForFather(self.hero_name:getParent(),self.hero_name)

    global.tools:adjustNodePosForFather(self.troop_name:getParent(),self.troop_name)

    global.tools:adjustNodePosForFather(self.combat_num:getParent(),self.combat_num)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


-- t] -     "lCommand"    = 2
-- [LUA-print] -     "lHeroAttr"   = 5710
-- [LUA-print] -     "lHeroID"     = 8205
-- [LUA-print] -     "lHeroLV"     = 36
-- [LUA-print] -     "lLeaderName" = "AmeliaJonete"
-- [LUA-print] -     "lTroopID"    = 70007
-- [LUA-print] -     "lTroopName"  = "未命名"
-- [LUA-print] -     "lTroopPower" = 24492
-- [LUA-print] -     "lTroopType"  = 4
-- [LUA-print] -     "lUid"        = 4000151
-- [LUA-print] -     "tagSoldier" = {
-- [LUA-print] -         1 = {
-- [LUA-print] -             "chief"       = true
-- [LUA-print] -             "lIndex"      = 0
-- [LUA-print] -             "lTroopID"    = 70007
-- [LUA-print] -             "lUid"        = 4000151
-- [LUA-print] -             "lcount"      = 5
-- [LUA-print] -             "soldierId"   = 8061
-- [LUA-print] -             "soldierLV"   = 2
-- [LUA-print] -             "soldierType" = 1
-- [LUA-print] -         }
-- [LUA-print] -         2 = {
-- [LUA-print] -             "chief"       = true
-- [LUA-print] -             "lIndex"      = 1
-- [LUA-print] -             "lTroopID"    = 70007
-- [LUA-print] -             "lUid"        = 4000151
-- [LUA-print] -             "lcount"      = 2
-- [LUA-print] -             "soldierId"   = 8062
-- [LUA-print] -             "soldierLV"   = 2
-- [LUA-print] -             "soldierType" = 1
-- [LUA-print] -         }
-- [LUA-print] -         3 = {
-- [LUA-print] -             "lIndex"      = 2
-- [LUA-print] -             "lTroopID"    = 70007
-- [LUA-print] -             "lUid"        = 4000151
-- [LUA-print] -             "lcount"      = 8146
-- [LUA-print] -             "soldierId"   = 31
-- [LUA-print] -             "soldierType" = 1
-- [LUA-print] -         }
-- [LUA-print] -     }
-- [LUA-print] -     "tips_type"   = "replayHero"
-- [LUA-print] -     "war_type"    = 3
-- [LUA-print] - }

function UIHeroTipsNode:setData(data)
    
    self.data = data

    dump(self.data ,"UIHeroTipsNode ///////////dump")


     self.hero_name:setString("-")
     self.lord_name:setString("-")
     self.chief_number:setString("-")

    self:cleanOldData()
    self.start_node:setVisible(false)

    local setHero = function (HeroData)

        if HeroData.lHeroID and HeroData.lHeroID > 0 then 

            local pro = global.heroData:getHeroPropertyById(HeroData.lHeroID)
            if not pro then return end
            global.panelMgr:setTextureFor(self.hero_icon,pro.nameIcon)
            self.hero_quality:setVisible(pro.quality ~=  1 )
            self.hero_quality:setVisible(false)
            self.heroLv:setVisible(true)
            self.heroLv:setString("lv"..HeroData.lHeroLV)
            self.hero_icon:setScale(0.3)

            local maxChief = self.data.lHeroAttr or   0 

            local nowChief =  0 


            for _ ,v in pairs(self.data.tagSoldier) do 

                if v.chief then 
                    nowChief= nowChief + global.luaCfg:get_soldier_property_by(v.soldierId).perPop * v.lcount
                end 

            end 

            if nowChief > maxChief  then nowChief = maxChief end 

            self.chief_number:setString(nowChief.."/"..maxChief)

            self.hero_attack_icon:setVisible(pro.heroType == 1 )
            self.hero_def_icon:setVisible(not self.hero_attack_icon:isVisible())


            if HeroData.tagEquip then 
                for _ ,v in pairs(HeroData.tagEquip) do 
                    local data = luaCfg:get_equipment_by(v)
                    self["equip_"..data.type]:setData(data)
                end 
            end 

           self.hero_name:setString(pro.name)

            self.start_node:setVisible(true)
            global.heroData:setHeroIconBg(self.data.lHeroID, self.left_kuang, self.right_kuang)
            self.start_node:setData(self.data.lHeroID , self.data.lHeroStar or 0 )

        else 
            self.hero_icon:setSpriteFrame("ui_surface_icon/troops_list_noicon.jpg")
            self.hero_icon:setScale(1)
            self.hero_quality:setVisible(false)
            self.heroLv:setVisible(false)
        end

        self.lord_name:setString(HeroData.lLeaderName)

    end 



    if self.data.lTroopID == 5 then  -- 城堡 

        self.hero_icon:setSpriteFrame("ui_surface_icon/icon_wall.png")
        self.hero_icon:setScale(1)
        self.hero_quality:setVisible(false)
        self.heroLv:setVisible(false)
        self.lord_name:setString( global.luaCfg:get_local_string(10090))

    elseif  self.data.lTroopType == 4 then  -- 英雄类型
    
        setHero(self.data)

    else 

        self.hero_icon:setSpriteFrame("ui_surface_icon/troops_list_noicon.jpg")
        self.hero_icon:setScale(1)
        self.hero_quality:setVisible(false)
        self.heroLv:setVisible(false)


        if   self.data.war_type == 2  then  -- 打野地

            local info = luaCfg:get_wild_res_by(self.data.lHeroID)
            self.lord_name:setString(info.name)

        elseif self.data.war_type == 3 then -- 打野怪

            local info = luaCfg:get_wild_monster_by(self.data.lHeroID)

           self.lord_name:setString(info.name)

        elseif self.data.war_type == 4 then 


        elseif self.data.war_type == 5 then  -- 营地

            local info = luaCfg:get_world_camp_by(self.data.lHeroID)
            self.lord_name:setString(info.name)

   
        elseif self.data.war_type == 6 then  --小村庄


        elseif self.data.war_type == 7 then  -- 奇迹

        --     local info = luaCfg:get_world_miracle_by(self.data.lHeroID)
        --     self.lord_name:setString(info.name)

        end  

    end

    self.data.lTroopName = self.data.lTroopName or "-"
    self.data.lLeaderName = self.data.lLeaderName or "-"

    self.troop_name:setString( self.data.lTroopName)

    self.combat_num:setString(self.data.lTroopPower)


    local xx  = 0 
    local yy  = 0 

    for _ ,v in pairs(self.data.tagSoldier or {} ) do 

         if xx >= 4 then 
            xx = 0 
            yy = yy + 1
         end 

        local soliderNode = UITipsSoliderNode.new()

        soliderNode:setPositionX(xx *soliderNode:getContentSize().width + self.soldier_first_ps.x)
        soliderNode:setPositionY( self.soldier_first_ps.y - yy * soliderNode:getContentSize().height)

        soliderNode:setData(v)

        self.soliderScrollView:addChild(soliderNode)

        xx  =  xx + 1 
    end 

end




function UIHeroTipsNode:cleanOldData()

    self.hero_attack_icon:setVisible(false)
    self.hero_def_icon:setVisible(false)


    for i =1 , 6 do 
        self["equip_"..i]:reset(i) 
    end

    self.soliderScrollView:removeAllChildren()
end 


return UIHeroTipsNode

--endregion
