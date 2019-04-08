--region TrainUpSoldierDetail.lua
--Author : wuwx
--Date   : 2017/12/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local TrainUpSoldierDetail  = class("TrainUpSoldierDetail", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

local UISoldierBufferControl = require("game.UI.common.UISoldierBufferControl")

-- 1.进攻战斗力
-- 2.破坏力
-- 3.防步战斗力
-- 4.防骑战斗力
-- 5.防弓战斗力
-- 6.防法战斗力
-- 7.速度
-- 8.载重
-- 9.全防战斗力

TrainUpSoldierDetail.SOLDIER_PROPERTY = 
{
    "atk",
    "dPower",
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
    "speed",
    "capacity",
    "alldef",
    "perPop",
    "perRes"
}


local def = {
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
}

function TrainUpSoldierDetail:ctor()
    self:CreateUI()
end

function TrainUpSoldierDetail:CreateUI()
    local root = resMgr:createWidget("train/train_uplv_info")
    self:initUI(root)
end

function TrainUpSoldierDetail:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_uplv_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.trim_top = self.root.trim_top_export
    self.title = self.root.title_export
    self.building_name = self.root.title_export.building_name_fnt_export
    self.scrollView = self.root.scrollView_export
    self.ps_node = self.root.scrollView_export.ps_node_export
    self.soldier_bg = self.root.scrollView_export.soldier_bg_export
    self.name = self.root.scrollView_export.name_export
    self.des = self.root.scrollView_export.des_export
    self.atk_num_next = self.root.scrollView_export.Node_next.atk_num_next_export
    self.dPower_num_next = self.root.scrollView_export.Node_next.dPower_num_next_export
    self.iftDef_num_next = self.root.scrollView_export.Node_next.iftDef_num_next_export
    self.cvlDef_num_next = self.root.scrollView_export.Node_next.cvlDef_num_next_export
    self.acrDef_num_next = self.root.scrollView_export.Node_next.acrDef_num_next_export
    self.magDef_num_next = self.root.scrollView_export.Node_next.magDef_num_next_export
    self.speed_num_next = self.root.scrollView_export.Node_next.speed_num_next_export
    self.capacity_num_next = self.root.scrollView_export.Node_next.capacity_num_next_export
    self.perPop_num_next = self.root.scrollView_export.Node_next.perPop_num_next_export
    self.perRes_num_next = self.root.scrollView_export.Node_next.perRes_num_next_export
    self.atk_num_add_next = self.root.scrollView_export.Node_next.atk_num_add_next_export
    self.dPower_num_add_next = self.root.scrollView_export.Node_next.dPower_num_add_next_export
    self.iftDef_num_add_next = self.root.scrollView_export.Node_next.iftDef_num_add_next_export
    self.cvlDef_num_add_next = self.root.scrollView_export.Node_next.cvlDef_num_add_next_export
    self.acrDef_num_add_next = self.root.scrollView_export.Node_next.acrDef_num_add_next_export
    self.magDef_num_add_next = self.root.scrollView_export.Node_next.magDef_num_add_next_export
    self.speed_num_add_next = self.root.scrollView_export.Node_next.speed_num_add_next_export
    self.capacity_num_add_next = self.root.scrollView_export.Node_next.capacity_num_add_next_export
    self.perPop_num_add_next = self.root.scrollView_export.Node_next.perPop_num_add_next_export
    self.perRes_num_add_next = self.root.scrollView_export.Node_next.perRes_num_add_next_export
    self.perTime_num_next = self.root.scrollView_export.Node_next.perTime_num_next_export
    self.atk_num = self.root.scrollView_export.Node_now.atk_num_export
    self.dPower_num = self.root.scrollView_export.Node_now.dPower_num_export
    self.iftDef_num = self.root.scrollView_export.Node_now.iftDef_num_export
    self.cvlDef_num = self.root.scrollView_export.Node_now.cvlDef_num_export
    self.acrDef_num = self.root.scrollView_export.Node_now.acrDef_num_export
    self.magDef_num = self.root.scrollView_export.Node_now.magDef_num_export
    self.speed_num = self.root.scrollView_export.Node_now.speed_num_export
    self.capacity_num = self.root.scrollView_export.Node_now.capacity_num_export
    self.perPop_num = self.root.scrollView_export.Node_now.perPop_num_export
    self.perRes_num = self.root.scrollView_export.Node_now.perRes_num_export
    self.atk_num_add = self.root.scrollView_export.Node_now.atk_num_add_export
    self.dPower_num_add = self.root.scrollView_export.Node_now.dPower_num_add_export
    self.iftDef_num_add = self.root.scrollView_export.Node_now.iftDef_num_add_export
    self.cvlDef_num_add = self.root.scrollView_export.Node_now.cvlDef_num_add_export
    self.acrDef_num_add = self.root.scrollView_export.Node_now.acrDef_num_add_export
    self.magDef_num_add = self.root.scrollView_export.Node_now.magDef_num_add_export
    self.speed_num_add = self.root.scrollView_export.Node_now.speed_num_add_export
    self.capacity_num_add = self.root.scrollView_export.Node_now.capacity_num_add_export
    self.perPop_num_add = self.root.scrollView_export.Node_now.perPop_num_add_export
    self.perRes_num_add = self.root.scrollView_export.Node_now.perRes_num_add_export
    self.perTime_num = self.root.scrollView_export.Node_now.perTime_num_export
    self.soldier = self.root.scrollView_export.soldier_export
    self.soldier_skill = self.root.scrollView_export.soldier_skill_mlan_12_export
    self.star1_now_bj = self.root.scrollView_export.star1_now_bj_export
    self.star1 = self.root.scrollView_export.star1_now_bj_export.star1_export
    self.star2 = self.root.scrollView_export.star1_now_bj_export.star2_export
    self.star2_now_bj = self.root.scrollView_export.star2_now_bj_export
    self.star3 = self.root.scrollView_export.star2_now_bj_export.star3_export
    self.star4 = self.root.scrollView_export.star2_now_bj_export.star4_export
    self.star3_now_bj = self.root.scrollView_export.star3_now_bj_export
    self.star5 = self.root.scrollView_export.star3_now_bj_export.star5_export
    self.star6 = self.root.scrollView_export.star3_now_bj_export.star6_export
    self.star1_next_bj = self.root.scrollView_export.star1_next_bj_export
    self.star1_next = self.root.scrollView_export.star1_next_bj_export.star1_next_export
    self.star2_next = self.root.scrollView_export.star1_next_bj_export.star2_next_export
    self.star2_next_bj = self.root.scrollView_export.star2_next_bj_export
    self.star3_next = self.root.scrollView_export.star2_next_bj_export.star3_next_export
    self.star4_next = self.root.scrollView_export.star2_next_bj_export.star4_next_export
    self.star3_next_bj = self.root.scrollView_export.star3_next_bj_export
    self.star5_next = self.root.scrollView_export.star3_next_bj_export.star5_next_export
    self.star6_next = self.root.scrollView_export.star3_next_bj_export.star6_next_export
    self.unlock = self.root.scrollView_export.unlock_export
    self.Button_1 = self.root.scrollView_export.Node_1.Button_1_export
    self.skill_icon_1 = self.root.scrollView_export.Node_1.Button_1_export.skill_icon_1_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
--EXPORT_NODE_END
    -- global.panelMgr:trimScrollView(self.scrollView,self.trim_top)
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

    self:adapt()
    
end

function TrainUpSoldierDetail:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("TrainUpSoldierDetail")
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function TrainUpSoldierDetail:unLockSkillHandler(sender, eventType)
    -- local tag = sender:getTag()
    -- local configCamp = luaCfg:camp_lvup()
    -- local skillData = {}
    -- for _,v in pairs(configCamp) do
    --     if v.buildingId == self.buildingData.buildingType and v.skillOrder == tag then
                
    --         local skills = luaCfg:get_soldier_skill_by(v.skillId)
    --         local str = global.luaCfg:get_translate_string(10854, self.buildingData.buildsName, v.level, skills.skillName)
    --         global.tipsMgr:showWarning(str)
    --         return         
    --     end
    -- end
end
--CALLBACKS_FUNCS_END


function TrainUpSoldierDetail:adapt()

    
    local sHeight =(gdisplay.height - 75)
    local defY = self.scrollView:getContentSize().height
    self.scrollView:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 

    else
        self.scrollView:setTouchEnabled(false)
        self.scrollView:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.scrollView:getContentSize().height- self.ps_node:getPositionY()

        for _ ,v in pairs(self.scrollView:getChildren()) do 
        print(tt)

            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

end 

function TrainUpSoldierDetail:setData(data,buildingData)

    self.data = data
    local id = data.id
    local property = luaCfg:get_soldier_property_by(id)
    local soldierData = luaCfg:get_soldier_train_by(id)
    local isfull,curclass,nextClass = global.soldierData:getSoldierClassBy(buildingData.serverData.lGrade)
    local lvupData = luaCfg:get_soldier_lvup_by(nextClass + 1)
    local curlvupData = luaCfg:get_soldier_lvup_by(curclass + 1)

    for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do

        if self[v.."_num"] then
            if i <= 8 then
                self[v.."_num"]:setString(math.ceil(property[v]*(curlvupData.upPro+100)/100))
                self[v.."_num_next"]:setString(math.ceil(property[v]*(lvupData.upPro+100)/100))
            else
                self[v.."_num"]:setString(property[v])
                self[v.."_num_next"]:setString(property[v])
            end
        end
    end

   for i,v in ipairs(self.SOLDIER_PROPERTY) do


        if self[v.."_num_add"] then

            self[v.."_num_add"]:setVisible(false)
            self[v.."_num_add_next"]:setVisible(false)

        end
    end 

    local showlvStar = function (lv,isnext)
        local suffix = ""
        if isnext then
            suffix = "_next"
        end
        for i=1,6 do
            self["star"..i..suffix]:setVisible(lv >= i)
        end
    end
    showlvStar(curclass)
    showlvStar(nextClass,true)


    local control =  UISoldierBufferControl.new()
    control:setData(self,self.data,nil,curclass,nextClass)

    self.building_name:setString(luaCfg:get_local_string(10622,buildingData.buildsName,buildingData.serverData.lGrade))
    --self.lv:setString(buildingData.serverData.lGrade)
    -- self.soldier:loadTexture(soldierData.pic, ccui.TextureResType.plistType)
    --张亮润稿处理

    -- self.soldier:setSpriteFrame(soldierData.pic)
    global.panelMgr:setTextureFor(self.soldier,soldierData.pic)
    local clipData = luaCfg:get_picture_by(id*10+3)
    self.soldier:setScale(clipData.scale/100)
    -- self.soldier_bg:loadTexture(soldierData.pic, ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.soldier_bg,soldierData.pic)
    self.name:setString(property.name)
    self.des:setString(property.info)
    self.perTime_num:setString(global.funcGame.formatTimeToHMS(soldierData.perTime))
    self.perTime_num_next:setString(global.funcGame.formatTimeToHMS(soldierData.perTime))

    self.property = property 


    self:setSoldierSkill(buildingData,isfull,nextClass)
    self.unlock:setVisible(not isfull)

    local lvupData = luaCfg:get_soldier_lvup_by(nextClass+1)
    self.unlock:setString(global.luaCfg:get_translate_string(10968,buildingData.buildsName,lvupData.buildLv,nextClass,property.name))
end

function TrainUpSoldierDetail:setSoldierSkill(buildingData,isfull,nextClass)

    self.soldier_skill:setVisible(true)
    self.scrollView.Sprite_85_0_0_0:setVisible(true)

    -- 城墙 / 侦察营
    if buildingData.id == 12 or buildingData.id == 14 then
        self.soldier_skill:setVisible(false)
        self.scrollView.Sprite_85_0_0_0:setVisible(false)
        self.Button_1:setVisible(false)
        return
    end

    -- 士兵技能解锁
    self.buildingData = buildingData
    local curLv = buildingData.serverData.lGrade
    local curId = buildingData.buildingType
    self.buildingData = buildingData
    local configCamp = luaCfg:camp_lvup()
    local skillData = {}
    for _,v in pairs(configCamp) do
        if v.buildingId == curId and v.skillId ~= 0 then 
            table.insert(skillData, v)
        end
    end

    if table.nums(skillData) > 1 then
        table.sort(skillData, function(s1, s2) return s1.level < s2.level end)
    end

    local i = 1
    local skillIcon = self["skill_icon_"..i]
    local btnBg = self["Button_"..i]
    btnBg:setVisible(true)
    if skillData[nextClass] then

        local skills = luaCfg:get_soldier_skill_by(skillData[nextClass].skillId)
        global.panelMgr:setTextureFor(skillIcon, skills.icon)     
        skillIcon.Sprite_num:setSpriteFrame(string.format("ui_surface_icon/icon_lv%s.png",skills.lv))

        btnBg:setTouchEnabled(false)
        -- tips
        local trainPanel = global.panelMgr:getPanel("TrainPanel")
        local tempdata ={information=skills, param=true}
        self["m_TipsControl"..i] = UIItemTipsControl.new()
        self["m_TipsControl"..i]:setdata(skillIcon, tempdata, self.tips_node)
    end
end


function TrainUpSoldierDetail:onExit()

    for i=1,6 do
        if  self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end
    end
end

return TrainUpSoldierDetail

--endregion
