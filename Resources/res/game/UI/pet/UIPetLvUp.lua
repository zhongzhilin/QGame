--region UIPetLvUp.lua
--Author : yyt
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIPetLvUp  = class("UIPetLvUp", function() return gdisplay.newWidget() end )

function UIPetLvUp:ctor()
    self:CreateUI()
end

function UIPetLvUp:CreateUI()
    local root = resMgr:createWidget("pet/pet_lvup")
    self:initUI(root)
end

function UIPetLvUp:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_lvup")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node_1 = self.root.Node_1_export
    self.close_noe = self.root.Node_1_export.Node.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.Node_1_export.Node.close_noe_export)
    self.starLv = self.root.Node_1_export.starLv_export
    self.petPos = self.root.Node_1_export.petPos_export
    self.NodeStar = self.root.Node_1_export.NodeStar_export
    self.star10_bj = self.root.Node_1_export.NodeStar_export.star10_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star10_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star10_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star10_bj_export.starTotal9_export.star18_export
    self.star9_bj = self.root.Node_1_export.NodeStar_export.star9_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star9_bj_export.starTotal9_export.star18_export
    self.star8_bj = self.root.Node_1_export.NodeStar_export.star8_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star8_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star8_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star8_bj_export.starTotal9_export.star18_export
    self.star7_bj = self.root.Node_1_export.NodeStar_export.star7_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star7_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star7_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star7_bj_export.starTotal9_export.star18_export
    self.star6_bj = self.root.Node_1_export.NodeStar_export.star6_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star6_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star6_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star6_bj_export.starTotal9_export.star18_export
    self.star5_bj = self.root.Node_1_export.NodeStar_export.star5_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star5_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star5_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star5_bj_export.starTotal9_export.star18_export
    self.star4_bj = self.root.Node_1_export.NodeStar_export.star4_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star4_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star4_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star4_bj_export.starTotal9_export.star18_export
    self.star3_bj = self.root.Node_1_export.NodeStar_export.star3_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star3_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star3_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star3_bj_export.starTotal9_export.star18_export
    self.star2_bj = self.root.Node_1_export.NodeStar_export.star2_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star2_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star2_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star2_bj_export.starTotal9_export.star18_export
    self.star1_bj = self.root.Node_1_export.NodeStar_export.star1_bj_export
    self.starTotal9 = self.root.Node_1_export.NodeStar_export.star1_bj_export.starTotal9_export
    self.star17 = self.root.Node_1_export.NodeStar_export.star1_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.Node_1_export.NodeStar_export.star1_bj_export.starTotal9_export.star18_export
    self.txt_power = self.root.Node_1_export.Node_0.txt_power_export
    self.Node_1 = self.root.Node_1_export.Node_1_export
    self.txt1 = self.root.Node_1_export.Node_1_export.txt1_export
    self.data1_add = self.root.Node_1_export.Node_1_export.data1_add_export
    self.data1_num = self.root.Node_1_export.Node_1_export.data1_num_export
    self.Node_2 = self.root.Node_1_export.Node_2_export
    self.txt2 = self.root.Node_1_export.Node_2_export.txt2_export
    self.data2_add = self.root.Node_1_export.Node_2_export.data2_add_export
    self.data2_num = self.root.Node_1_export.Node_2_export.data2_num_export
    self.Node_3 = self.root.Node_1_export.Node_3_export
    self.txt3 = self.root.Node_1_export.Node_3_export.txt3_export
    self.data3_add = self.root.Node_1_export.Node_3_export.data3_add_export
    self.data3_num = self.root.Node_1_export.Node_3_export.data3_num_export
    self.Node_4 = self.root.Node_1_export.Node_4_export
    self.txt4 = self.root.Node_1_export.Node_4_export.txt4_export
    self.data4_add = self.root.Node_1_export.Node_4_export.data4_add_export
    self.data4_num = self.root.Node_1_export.Node_4_export.data4_num_export
    self.Node_5 = self.root.Node_1_export.Node_5_export
    self.txt5 = self.root.Node_1_export.Node_5_export.txt5_export
    self.data5_add = self.root.Node_1_export.Node_5_export.data5_add_export
    self.data5_num = self.root.Node_1_export.Node_5_export.data5_num_export
    self.Node_6 = self.root.Node_1_export.Node_6_export
    self.txt6 = self.root.Node_1_export.Node_6_export.txt6_export
    self.data6_add = self.root.Node_1_export.Node_6_export.data6_add_export
    self.data6_num = self.root.Node_1_export.Node_6_export.data6_num_export
    self.dataSkill = self.root.Node_1_export.Node_7.dataSkill_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END
    self.close_noe:setData(function ()
        global.panelMgr:closePanel("UIPetLvUp")
    end)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetLvUp:setData(data, oldPetLv)

    if not data then return end
    self.txt_power:setString(data.serverData.lPower)
    local petConfig = global.petData:getPetConfig(data.type, data.serverData.lGrade)
    local petPreConfig = global.petData:getPetConfig(data.type, oldPetLv)
    self.dataSkill:setString("+"..global.petData:getPetSkillPoint(data.type, oldPetLv, data.serverData.lGrade))

    -- 属性
    for i=1,6 do

        self["Node_"..i]:setVisible(false)
        local skill = global.petData:getPetPropertyClient(petConfig.propertyValueClient)
        if skill[i] then
            self["Node_"..i]:setVisible(true)
            local skillD = petConfig.propertyValue
            local dataType = luaCfg:get_data_type_by(skillD[i][1])
            self["txt"..i]:setString(skill[i][1])
            self["data"..i.."_num"]:setString(skill[i][2]/100 .. dataType.extra)

            local skillPre = global.petData:getPetPropertyClient(petPreConfig.propertyValueClient)
            local addPer = (skill[i][2] - skillPre[i][2])/100
            self["data"..i.."_add"]:setVisible(false)
            if addPer > 0 then
                self["data"..i.."_add"]:setVisible(true)
                self["data"..i.."_add"]:setString("+"..addPer .. dataType.extra)
            end
        end
    end

    -- 神兽
    local petConfig = global.petData:getPetConfig(data.type, data.serverData.lGrade)
    if petConfig then
        self.petPos:removeAllChildren()
        local node = resMgr:createCsbAction(petConfig.Animation, "animation0" , true)
        node:setScale(data.scaleLvUp[petConfig.growingPhase])
        self.petPos:addChild(node)
    end

    -- 设置星星
    local per = 10
    local lv = data.serverData.lGrade
    local curClass = math.ceil(lv/per) 
    for i=1,10 do
        self["star"..i.."_bj"]:setVisible(false)
        if i<=curClass then
            self["star"..i.."_bj"]:setVisible(true)
        end
    end

    self.starLv:setString("+"..(lv-per*(curClass-1)))
    local perStarWidth = 45
    local width = perStarWidth*curClass
    self.NodeStar:setPositionX(0-width/2)
    self.starLv:setPosition(cc.p(self.NodeStar:getPositionX()+width, self.NodeStar:getPositionY()))

    -- effect
    gevent:call(gsound.EV_ON_PLAYSOUND,"pet_levelup")
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("pet/pet_lvup")
    nodeTimeLine:play("animation0", false)
    self.root:runAction(nodeTimeLine)

end

function UIPetLvUp:exit(sender, eventType)
    global.panelMgr:closePanel("UIPetLvUp")
end
--CALLBACKS_FUNCS_END

return UIPetLvUp

--endregion
