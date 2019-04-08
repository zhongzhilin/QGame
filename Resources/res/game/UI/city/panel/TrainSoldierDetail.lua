--region TrainSoldierDetail.lua
--Author : wuwx
--Date   : 2016/08/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local TrainSoldierDetail  = class("TrainSoldierDetail", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

local UISoldierBufferControl = require("game.UI.common.UISoldierBufferControl")


function TrainSoldierDetail:ctor()
    self:CreateUI()
end

function TrainSoldierDetail:CreateUI()
    local root = resMgr:createWidget("train/train_second_info")
    self:initUI(root)
end

function TrainSoldierDetail:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "train/train_second_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.trim_top = self.root.trim_top_export
    self.title = self.root.title_export
    self.building_name = self.root.title_export.building_name_fnt_export
    self.scrollView = self.root.scrollView_export
    self.soldier_bg = self.root.scrollView_export.soldier_bg_export
    self.name = self.root.scrollView_export.name_export
    self.des = self.root.scrollView_export.des_export
    self.atk_num = self.root.scrollView_export.atk_num_export
    self.dPower_num = self.root.scrollView_export.dPower_num_export
    self.iftDef_num = self.root.scrollView_export.iftDef_num_export
    self.cvlDef_num = self.root.scrollView_export.cvlDef_num_export
    self.acrDef_num = self.root.scrollView_export.acrDef_num_export
    self.magDef_num = self.root.scrollView_export.magDef_num_export
    self.speed_num = self.root.scrollView_export.speed_num_export
    self.capacity_num = self.root.scrollView_export.capacity_num_export
    self.perPop_num = self.root.scrollView_export.perPop_num_export
    self.perRes_num = self.root.scrollView_export.perRes_num_export
    self.soldier = self.root.scrollView_export.soldier_export
    self.atk_num_add = self.root.scrollView_export.atk_num_add_export
    self.dPower_num_add = self.root.scrollView_export.dPower_num_add_export
    self.iftDef_num_add = self.root.scrollView_export.iftDef_num_add_export
    self.cvlDef_num_add = self.root.scrollView_export.cvlDef_num_add_export
    self.acrDef_num_add = self.root.scrollView_export.acrDef_num_add_export
    self.magDef_num_add = self.root.scrollView_export.magDef_num_add_export
    self.speed_num_add = self.root.scrollView_export.speed_num_add_export
    self.capacity_num_add = self.root.scrollView_export.capacity_num_add_export
    self.perPop_num_add = self.root.scrollView_export.perPop_num_add_export
    self.perRes_num_add = self.root.scrollView_export.perRes_num_add_export
    self.perTime_num = self.root.scrollView_export.perTime_num_export
    self.soldier_skill = self.root.scrollView_export.soldier_skill_mlan_6_export
    self.Button_2 = self.root.scrollView_export.Node_2.Button_2_export
    self.skill_icon_2 = self.root.scrollView_export.Node_2.Button_2_export.skill_icon_2_export
    self.Button_3 = self.root.scrollView_export.Node_3.Button_3_export
    self.skill_icon_3 = self.root.scrollView_export.Node_3.Button_3_export.skill_icon_3_export
    self.Button_4 = self.root.scrollView_export.Node_4.Button_4_export
    self.skill_icon_4 = self.root.scrollView_export.Node_4.Button_4_export.skill_icon_4_export
    self.Button_5 = self.root.scrollView_export.Node_5.Button_5_export
    self.skill_icon_5 = self.root.scrollView_export.Node_5.Button_5_export.skill_icon_5_export
    self.Button_6 = self.root.scrollView_export.Node_6.Button_6_export
    self.skill_icon_6 = self.root.scrollView_export.Node_6.Button_6_export.skill_icon_6_export
    self.Button_1 = self.root.scrollView_export.Node_1.Button_1_export
    self.skill_icon_1 = self.root.scrollView_export.Node_1.Button_1_export.skill_icon_1_export

    uiMgr:addWidgetTouchHandler(self.Button_2, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_3, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_4, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_5, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_6, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:unLockSkillHandler(sender, eventType) end)
--EXPORT_NODE_END
    global.panelMgr:trimScrollView(self.scrollView,self.trim_top)
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

end

function TrainSoldierDetail:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("TrainSoldierDetail")
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function TrainSoldierDetail:unLockSkillHandler(sender, eventType)

    local tag = sender:getTag()
    local configCamp = luaCfg:camp_lvup()
    local skillData = {}
    for _,v in pairs(configCamp) do
        if v.buildingId == self.buildingData.buildingType and v.skillOrder == tag then
                
            local skills = luaCfg:get_soldier_skill_by(v.skillId)
            local str = global.luaCfg:get_translate_string(10854, self.buildingData.buildsName, v.level, skills.skillName)
            global.tipsMgr:showWarning(str)
            return         
        end
    end

end

--CALLBACKS_FUNCS_END

function TrainSoldierDetail:setData(data,buildingData)

    self.data = data
    local id = data.id
    local property = luaCfg:get_soldier_property_by(id)
    local soldierData = luaCfg:get_soldier_train_by(id)

    local isfull,class,nextClass = global.soldierData:getSoldierClassBy(buildingData.serverData.lGrade)
    local lvupData = luaCfg:get_soldier_lvup_by(nextClass+1)

    for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do
        if self[v.."_num"] then
            self[v.."_num"]:setString(math.ceil(property[v]*(lvupData.upPro+100)/100))
        end
    end

   for i,v in ipairs(self.SOLDIER_PROPERTY) do
        if self[v.."_num_add"] then
            self[v.."_num_add"]:setVisible(false)

        end
    end 

    local control =  UISoldierBufferControl.new()
    control:setData(self,self.data,nil,class)

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

    self.property = property 


    self:setSoldierSkill(buildingData)

end

function TrainSoldierDetail:setSoldierSkill(buildingData)

    self.soldier_skill:setVisible(true)
    self.scrollView.Sprite_85_0_0_0:setVisible(true)

    -- 城墙 / 侦察营
    if buildingData.id == 12 or buildingData.id == 14 then
        self.soldier_skill:setVisible(false)
        self.scrollView.Sprite_85_0_0_0:setVisible(false)
        for i=1,6 do
            local btnBg = self["Button_"..i]
            btnBg:setVisible(false)
        end
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

    for i=1,6 do
        local skillIcon = self["skill_icon_"..i]
        local btnBg = self["Button_"..i]
        btnBg:setVisible(true)
        if skillData[i] then

            global.colorUtils.turnGray(skillIcon, false)
            local skills = luaCfg:get_soldier_skill_by(skillData[i].skillId)
            global.panelMgr:setTextureFor(skillIcon, skills.icon)     

            if skillData[i].level <= curLv then

                btnBg:setTouchEnabled(false)
                -- tips
                local trainPanel = global.panelMgr:getPanel("TrainPanel")
                local tempdata ={information=skills, param=true}
                self["m_TipsControl"..i] = UIItemTipsControl.new()
                self["m_TipsControl"..i]:setdata(skillIcon, tempdata, self.tips_node)
            else
                btnBg:setTouchEnabled(true)
                global.colorUtils.turnGray(skillIcon, true)
            end
        end
    end
end


function TrainSoldierDetail:onExit()

    for i=1,6 do
        if  self["m_TipsControl"..i] then 
            self["m_TipsControl"..i]:ClearEventListener()
        end
    end
end


function TrainSoldierDetail:setBuffAdd(msg)

    if msg.tgEffect and msg.tgEffect[1]  and   msg.tgEffect[1] and msg.tgEffect[1].tgEffect then 
        -- dump(msg  , "waht the fuck msg ")
        local  tgEffect= self:effectHandel(msg.tgEffect[1].tgEffect)
    end 
end

-- 1.进攻战斗力
-- 2.破坏力
-- 3.防步战斗力
-- 4.防骑战斗力
-- 5.防弓战斗力
-- 6.防法战斗力
-- 7.速度
-- 8.载重
-- 9.全防战斗力

TrainSoldierDetail.SOLDIER_PROPERTY = 
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

 
function TrainSoldierDetail:effectHandel(msg)
    print(debug.traceback())

    local temp  ={}

    for _ ,v in pairs(msg) do 

        if not global.EasyDev:CheckContrains(temp , v.lEffectID) then 
            table.insert(temp , v.lEffectID)
        end 
    end

    -- dump(temp , "temp")

    local effect_arr = {} 

    for _ ,v in  pairs(temp) do 

        local effect ={} 
        effect.lEffectID = v
        effect.lVal = 0 
        effect.effect_data = luaCfg:get_data_type_by(effect.lEffectID)

        for _ ,vv in pairs(msg)  do 

            if vv.lEffectID  == v then 

                effect.lVal =effect.lVal + vv.lVal

            end 
        end 
        table.insert(effect_arr , effect)
    end

    -- dump(effect_arr ,"effect_arr") 

    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 
        self[v] = 0         
        print(v ,"self[v]")
    end 

    for _ ,v in pairs(effect_arr) do 

        if  self.data.type == v.effect_data.soldierType  or v.effect_data.soldierType == 99    then 

            if  v.effect_data.natureType == 9 then -- 全防  

                for _ , vv  in pairs(def)  do 

                    if v.effect_data.extra == "%" then 

                        self[vv] = self[vv] +  self.property[vv] * v.lVal  / 100 

                    else 
                        self[vv]  =self[vv]  + v.lVal

                    end 
                end

            else
                if v.effect_data.extra == "%" then 

                    self[self.SOLDIER_PROPERTY[v.effect_data.natureType]]  = self[self.SOLDIER_PROPERTY[v.effect_data.natureType]] + self.property[self.SOLDIER_PROPERTY[v.effect_data.natureType]] * v.lVal / 100 

                else
                    self[self.SOLDIER_PROPERTY[v.effect_data.natureType]]  = self[self.SOLDIER_PROPERTY[v.effect_data.natureType]] + v.lVal          

                end  
            end 

        end 

    end


    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 

        if self[v] >  0 then 

            if self[v.."_num_add"] then
                
                self[v.."_num_add"]:setVisible(true)
            
                self[v.."_num_add"]:setString("+ "..self[v])

            end 

        end 
    end 
end 


return TrainSoldierDetail

--endregion
