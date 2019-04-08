--region UIHeroLvUp.lua
--Author : untory
--Date   : 2017/05/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local textScrollControl = require("game.UI.common.UITextScrollControl")
local UIHeroLvUp  = class("UIHeroLvUp", function() return gdisplay.newWidget() end )

function UIHeroLvUp:ctor()
    self:CreateUI()
end

function UIHeroLvUp:CreateUI()
    local root = resMgr:createWidget("hero/hero_lvup")
    self:initUI(root)
end

function UIHeroLvUp:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_lvup")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.herotop = self.root.Node.herotop_mlan_9_export
    self.levle = self.root.Node.herotop_mlan_9_export.levle_export
    self.name = self.root.Node.name_export
    self.hero_icon = self.root.Node.hero_icon.hero_icon_export
    self.combat_num = self.root.Node.num.combat_mlan_3.combat_num_export
    self.data1_num = self.root.Node.num.data1_mlan_6.data1_num_export
    self.data1_add = self.root.Node.num.data1_mlan_6.data1_add_export
    self.data4_num = self.root.Node.num.data4_mlan_6.data4_num_export
    self.data4_add = self.root.Node.num.data4_mlan_6.data4_add_export
    self.data2_num = self.root.Node.num.data2_mlan_6.data2_num_export
    self.data2_add = self.root.Node.num.data2_mlan_6.data2_add_export
    self.data3_num = self.root.Node.num.data3_mlan_6.data3_num_export
    self.data3_add = self.root.Node.num.data3_mlan_6.data3_add_export
    self.close_noe = self.root.Node.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.Node.close_noe_export)
    self.skill_node1 = self.root.Node.skill_node1_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END
    
    self.commandType = self.data3_num:getParent()

    self.close_noe:setData(function()
        self:exit()
    end)

end

function UIHeroLvUp:setData(data,preHeroData)
    
    dump(data,"data")
    dump(preHeroData,"preHeroData")

    local baseInfo = {1,3,4,2}
    -- self.hero_icon:setSpriteFrame(data.nameIcon)
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon)
    -- self.levle:setString(data.serverData.lGrade)

    data.serverData = data.serverData or {}
    preHeroData.serverData = preHeroData.serverData or {}

    self.combat_num:setString(data.serverData.lPower or 0)
    self.name:setString(data.name)
    -- self.commandType:setString(global.heroData:getCommanderStr(data))
    self.commandType:setString(global.luaCfg:get_local_string(10386))

    self.levle:setString(preHeroData.serverData.lGrade or 0)
    textScrollControl.startScrollFromTo(self.levle, preHeroData.serverData.lGrade or 0, data.serverData.lGrade or 0, 0.3)

    for i = 1,4 do
        if data.serverData.lbase and preHeroData.serverData.lbase then
            self["data" .. i .. "_num"]:setString(data.serverData.lbase[baseInfo[i]])
            self["data" .. i .. "_add"]:setString("+" .. data.serverData.lbase[baseInfo[i]] - preHeroData.serverData.lbase[baseInfo[i]]) 
        end           
    end

    local newSkills = {}
    for _,v in ipairs(data.serverData.lSkill or {}) do
        if v ~= 0 then
            local isOldHava = false
            for _,preV in ipairs(preHeroData.serverData.lSkill or {}) do
                
                if preV == v then
                    isOldHava = true
                    break  
                end
                
            end 

            if not isOldHava then
                table.insert(newSkills,v)
            end           
        end        
    end    

    for i = 1,6 do

        self.skill_node1["Skill_bg_" .. i]:setVisible(false)
    end

    local newSkillCount = #newSkills - 1

    for i,v in ipairs(newSkills) do

        local skillNode = self.skill_node1["Skill_bg_" .. i]        
        local skillConf = luaCfg:get_skill_by(v)   
        if skillConf then
            -- skillNode:setVisible(true)
            -- skillNode.Skill_icon:setSpriteFrame(skillConf.icon)
            global.panelMgr:setTextureFor(skillNode.Skill_icon,skillConf.icon)

            skillNode:setPosition(cc.p((i - 1) * 100 - newSkillCount * 50,-20))

            -- skillNode:setVisible(false)

            skillNode:removeChildByTag(1024)

            local effect = resMgr:createCsbAction("hero/hero_lvup_skill_effect","animation0",false,true)
            effect:setTag(1024)
            skillNode:runAction(cc.Sequence:create(cc.DelayTime:create(204 / 60),cc.Show:create()))
            effect:setPosition(cc.p(22,40))
            skillNode:addChild(effect)
        end        
    end

    local tW = self.herotop:getContentSize().width + self.levle:getContentSize().width

    global.tools:adjustNodePosForFather(self.herotop, self.levle , 20)

    -- local posX = gdisplay.width/2 - tW/2
    -- local posR = self.root.Node:convertToNodeSpace(cc.p(posX, 0))
    -- self.herotop:setPositionX(posR.x) 
    -- local x = posX + self.herotop:getContentSize().width
    -- local posL = self.herotop:convertToNodeSpace(cc.p(x, 0))
    -- self.levle:setPositionX(posL.x)

end

function UIHeroLvUp:onEnter()
    
    self.isShow = true

    self.nodeTimeLine = resMgr:createTimeline("hero/hero_lvup")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)

    self.nodeTimeLine:setTimeSpeed(1)

    self.nodeTimeLine:play("animation0",false)

    self.isStart = true

    -- self.nodeTimeLine:setLastFrameCallFunc(function()
    --     self.isStart = false
    -- end)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function()
        self.isStart = false
    end)))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroLvUp:exit(sender, eventType)

    if self.isStart then return end

    global.panelMgr:closePanel("UIHeroLvUp")
    self.isShow = false
    global.heroData:checkWaitPanel(true)
end
--CALLBACKS_FUNCS_END

return UIHeroLvUp 

--endregion


