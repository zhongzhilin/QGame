--region UIISoldierTipsNode.lua
--Author : anlitop
--Date   : 2017/05/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIISoldierTipsNode  = class("UIISoldierTipsNode", function() return gdisplay.newWidget() end )


local UISoldierBufferControl = require("game.UI.common.UISoldierBufferControl")

function UIISoldierTipsNode:ctor()
    self:CreateUI()
end

function UIISoldierTipsNode:CreateUI()
    local root = resMgr:createWidget("common/soldier_tips_node")
    self:initUI(root)
end

function UIISoldierTipsNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/soldier_tips_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.node1 = self.root.board_export.node1_export
    self.soldier_name = self.root.board_export.node1_export.soldier_name_export
    self.arms_name = self.root.board_export.Node_11.arms_mlan_4.arms_name_export
    self.type_name = self.root.board_export.Node_11.type_mlan_4.type_name_export
    self.dPower_num = self.root.board_export.Node_11.destructive_mlan_5.dPower_num_export
    self.dPower_num_add = self.root.board_export.Node_11.destructive_mlan_5.dPower_num_export.dPower_num_add_export
    self.atk_num = self.root.board_export.Node_11.atk_combat_mlan_7.atk_num_export
    self.atk_num_add = self.root.board_export.Node_11.atk_combat_mlan_7.atk_num_export.atk_num_add_export
    self.speed_num = self.root.board_export.base_property.speed_mlan_4.speed_num_export
    self.speed_num_add = self.root.board_export.base_property.speed_mlan_4.speed_num_export.speed_num_add_export
    self.perPop_num = self.root.board_export.base_property.manpower_mlan_6.perPop_num_export
    self.capacity_num = self.root.board_export.base_property.weight_mlan_4.capacity_num_export
    self.capacity_num_add = self.root.board_export.base_property.weight_mlan_4.capacity_num_export.capacity_num_add_export
    self.food_consume_num = self.root.board_export.base_property.food_mlan_6.food_consume_num_export
    self.iftDef_num = self.root.board_export.def_property.def_infantry_mlan_8.iftDef_num_export
    self.iftDef_num_add = self.root.board_export.def_property.def_infantry_mlan_8.iftDef_num_export.iftDef_num_add_export
    self.acrDef_num = self.root.board_export.def_property.def_archer_mlan_8.acrDef_num_export
    self.acrDef_num_add = self.root.board_export.def_property.def_archer_mlan_8.acrDef_num_export.acrDef_num_add_export
    self.cvlDef_num = self.root.board_export.def_property.def_cav_mlan_8.cvlDef_num_export
    self.cvlDef_num_add = self.root.board_export.def_property.def_cav_mlan_8.cvlDef_num_export.cvlDef_num_add_export
    self.magDef_num = self.root.board_export.def_property.def_mage_mlan_8.magDef_num_export
    self.magDef_num_add = self.root.board_export.def_property.def_mage_mlan_8.magDef_num_export.magDef_num_add_export
    self.food_num = self.root.board_export.train_need.food_num_export
    self.wood_num = self.root.board_export.train_need.wood_num_export
    self.gold_num = self.root.board_export.train_need.gold_num_export
    self.stone_num = self.root.board_export.train_need.stone_num_export
    self.gift_overtime_text = self.root.board_export.need_time_node.timer_Node.gift_overtime_text_export
    self.portrait_node = self.root.board_export.portrait_node_export
    self.skill_icon_1 = self.root.board_export.skill_icon_1_export
    self.skill_icon_2 = self.root.board_export.skill_icon_2_export
    self.skill_icon_3 = self.root.board_export.skill_icon_3_export
    self.skill_icon_4 = self.root.board_export.skill_icon_4_export
    self.skill_icon_5 = self.root.board_export.skill_icon_5_export
    self.skill_icon_6 = self.root.board_export.skill_icon_6_export

--EXPORT_NODE_END


    --文本重叠处理 张亮

    global.tools:adjustNodePosForFather(self.arms_name:getParent(),self.arms_name)
    global.tools:adjustNodePosForFather(self.type_name:getParent(),self.type_name)
    global.tools:adjustNodePosForFather(self.dPower_num:getParent(),self.dPower_num)
    global.tools:adjustNodePosForFather(self.atk_num:getParent(),self.atk_num)
    global.tools:adjustNodePosForFather(self.speed_num:getParent(),self.speed_num)
    global.tools:adjustNodePosForFather(self.perPop_num:getParent(),self.perPop_num)
    global.tools:adjustNodePosForFather(self.capacity_num:getParent(),self.capacity_num)
    global.tools:adjustNodePosForFather(self.food_consume_num:getParent(),self.food_consume_num)
    global.tools:adjustNodePosForFather(self.iftDef_num:getParent(),self.iftDef_num)
    global.tools:adjustNodePosForFather(self.acrDef_num:getParent(),self.acrDef_num)
    global.tools:adjustNodePosForFather(self.cvlDef_num:getParent(),self.cvlDef_num)
    global.tools:adjustNodePosForFather(self.magDef_num:getParent(),self.magDef_num)

    


end

function  UIISoldierTipsNode:setData(data, isNoShowBuff)

    -- print("xcvoasdjiflaksjdfklajsdflk asjdlfk")
    -- dump(data ,"sjldflasjkdfl0923eropwier")

    self.data = data

    local property =global.luaCfg:get_soldier_property_by(self.data.id)
    local soldierData = global.luaCfg:get_soldier_train_by(self.data.id)

    if not property then
        return 
    end 

    self.soldier_name:setString(property.name)
    
    local monsType = ""

    local id = 0 

    if property.monsType == 1 then
        id= 10363
    elseif property.monsType == 2 then
        id= 10364
    elseif property.monsType == 3 then
        id= 10365
    elseif property.monsType == 4 then
        id= 10366
    elseif property.monsType == 5 then
        id= 10640
    elseif property.monsType == 6 then
        id= 10367
    end

    self.arms_name:setString(global.luaCfg:get_local_string(id))

    local skill = ""
    if property.skill ==1 then
        skill = global.luaCfg:get_local_string(10435)
    else 
        skill = global.luaCfg:get_local_string(10436)
    end 

    self.type_name:setString(skill)

    -- self.soldier_pic:setSpriteFrame(soldierData.pic)
    -- global.panelMgr:setTextureFor(self.soldier_pic,soldierData.pic)
    -- self.soldier_pic:setScale(0.3)

    global.tools:setSoldierBust(self.portrait_node,property)
    -- self.destructive_num:setString(property.dPower) -- 破坏力
    -- self.atk_num:setString(property.atk) -- 进攻破坏力
    -- self.speed_num:setString(property.speed)
    -- self.manpower_num:setString(property.perPop)
    -- self.weight_num:setString(property.capacity)
    -- self.def_infantry_num:setString(property.iftDef)
    -- self.def_archer_num:setString(property.acrDef)
    -- self.def_cav_num:setString(property.cvlDef)
    -- self.def_mage_num:setString(property.magDef)

 


    self.food_consume_num:setString(property.perRes)


    local setProperty = function (updata) 

        for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do
            if self[v.."_num"] then
                if updata  and  i <= 8  then 
                    self[v.."_num"]:setString(math.ceil(property[v]*(updata.upPro+100)/100))
                else 
                    self[v.."_num"]:setString(property[v])
                end 
                self[v.."_num"]:setTextColor(gdisplay.COLOR_WHITE)
            end

            if self[v.."_num_add"] then

                self[v.."_num_add"]:setVisible(false)
            end 
        end
    end


    local lvupData = nil
    local control =  nil

    if not  self.data.hideBuff then  --领主自己士兵 tips 
        
        if not isNoShowBuff then
            control =  UISoldierBufferControl.new()
        end

        local id,dataBuild = global.cityData:getBuildingIdBySoldierId(self.data.id)


        if self.data.race ~=0 and  dataBuild and dataBuild.serverData and (self.data.type ~= 0) then

            local isfull,curclass,nextClass = global.soldierData:getSoldierClassBy(dataBuild.serverData.lGrade)


            lvupData =global.luaCfg:get_soldier_lvup_by(curclass + 1 )

            setProperty(lvupData)

            if control then
                control:setData(self, self.data ,nil , curclass)   
            end

        else 
            setProperty(nil)

            if control then
                control:setData(self, self.data ,nil , nil)  
            end

        end 

    else 


        if not isNoShowBuff then
            control =  UISoldierBufferControl.new()
        end

        if global.luaCfg:get_soldier_train_by(self.data.soldierId).race ~=0 then --死灵其实没有阶级   (士兵等级就是建筑等级)
            local isfull,curclass,nextClass = global.soldierData:getSoldierClassBy(self.data.soldierLV or 1)

            lvupData =global.luaCfg:get_soldier_lvup_by(curclass + 1)
            setProperty(lvupData)

            if control then
                control:setRePlayBuff(self.data.lUid , self.data.lTroopID , self.data.soldierId , self  , curclass)
            end
        else 
            setProperty(nil)
            if control then
                control:setRePlayBuff(self.data.lUid , self.data.lTroopID , self.data.soldierId , self  , nil)
            end
        end 
    end  

    if type(soldierData.perCost)=="table" then 
        self.food_num:setString(soldierData.perCost[1][2]) -- 1 
        self.wood_num:setString(soldierData.perCost[2][2]) -- 3 
        self.gold_num:setString(0)  
        self.stone_num:setString(soldierData.perCost[3][2]) --4 
    end 

    self.gift_overtime_text:setString(global.funcGame.formatTimeToHMS(soldierData.perTime))







    for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do

        if self[v.."_num"] and self[v.."_num_add"] then
            global.tools:adjustNodePosForFather(self[v.."_num"],self[v.."_num_add"] , -15)
        end 
    end 

    -- 士兵技能解锁
    local curLv, curId = 0, 0

    local id,dataBuild = global.cityData:getBuildingIdBySoldierId(self.data.id)
    if dataBuild and dataBuild.serverData and (soldierData.type ~= 0) then
        curLv = dataBuild.serverData.lGrade or 1
        curId = dataBuild.buildingType
    end

    if self.data.hideBuff then  -- 战斗录像
        curLv =  self.data.soldierLV or 1 
    end 

    print(curId ,"curId")
    print(curLv ,"curLv")

    local configCamp = global.luaCfg:camp_lvup()
    local skillData = {}
    for _,v in pairs(configCamp) do
        if v.buildingId == curId and v.level <= curLv and v.skillId ~= 0 then
            table.insert(skillData, v)
        end
    end

    if table.nums(skillData) > 1 then
        table.sort(skillData, function(s1, s2) return s1.level < s2.level end)
    end

    for i=1,6 do
        local skillIcon = self["skill_icon_"..i]
        if skillData[i] then
            skillIcon:setVisible(true)
            local skills = global.luaCfg:get_soldier_skill_by(skillData[i].skillId)
            global.panelMgr:setTextureFor(skillIcon, skills.icon)            
        else
            skillIcon:setVisible(false)
        end
    end


end


function UIISoldierTipsNode:getContentSize() --qaq
    return  self.board:getContentSize()
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIISoldierTipsNode

--endregion
