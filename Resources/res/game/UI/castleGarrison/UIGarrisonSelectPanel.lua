--region UIGarrisonSelectPanel.lua
--Author : yyt
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIGarrisonSelectHero = require("game.UI.castleGarrison.UIGarrisonSelectHero")
--REQUIRE_CLASS_END

local UIGarrisonSelectPanel  = class("UIGarrisonSelectPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIGarrisonHeroCell = require("game.UI.castleGarrison.UIGarrisonHeroCell")

function UIGarrisonSelectPanel:ctor()
    self:CreateUI()
end

function UIGarrisonSelectPanel:CreateUI()
    local root = resMgr:createWidget("castle_garrison/choose_node")
    self:initUI(root)
end

function UIGarrisonSelectPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/choose_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.upRow = self.root.Node_1.upRow_export
    self.FileNode_1 = self.root.Node_1.FileNode_1_export
    self.FileNode_1 = UIGarrisonSelectHero.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_1.FileNode_1_export)
    self.FileNode_2 = self.root.Node_1.FileNode_2_export
    self.FileNode_2 = UIGarrisonSelectHero.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.Node_1.FileNode_2_export)
    self.tbNode = self.root.Node_1.tbNode_export
    self.tbSize = self.root.Node_1.tbSize_export
    self.cellSize = self.root.Node_1.cellSize_export
    self.topNode = self.root.Node_1.topNode_export
    self.botNode = self.root.Node_1.botNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_1.btn_1, function(sender, eventType) self:confirmHandler(sender, eventType) end)
--EXPORT_NODE_END
    
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIGarrisonHeroCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.tbNode:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGarrisonSelectPanel:setHeroBuffs()

    local getBuffDetail = function (heroData)
        -- body
        if not heroData then return end
        heroData.serverData = heroData.serverData or {}
        local interiorBase = heroData.serverData.lbase[3] or 0
        local interiorAdd  = heroData.serverData.lextra[3] or 0
        local toaInterior = interiorBase + interiorAdd

        local buffDetail = {}
        for i=1,2 do
            local curEffect = self.data["effect_"..i] 
            local curEffectType = self.data["effect_"..i.."_num"]
            if curEffect and curEffect ~= 0 then

                local tempBuff = {}
                tempBuff.lBuffid = curEffect
                if curEffectType == 1 then
                    tempBuff.lValue =  math.ceil(toaInterior/100*0.25)
                    if self.data.building_id == 18 then
                        tempBuff.lValue =  math.ceil(toaInterior/100*0.1)
                    end
                elseif curEffectType == 2 then

                    local build_gar_pro = luaCfg:garrison_pro()
                    local times = 1
                    for _,v in ipairs(build_gar_pro) do
                        if v.building == self.data.building_id then
                            times = v.pro / 100
                        end
                    end

                    tempBuff.lValue = math.ceil((toaInterior / 5) * times)
                elseif curEffectType == 3 then
                    tempBuff.lValue = math.ceil(toaInterior*10)
                elseif curEffectType == 0 then -- 城堡加成规则
                    tempBuff.lValue =  math.floor(toaInterior / luaCfg:get_config_by(1).garrisonScale)
                    if tempBuff.lBuffid == 2006 then
                        tempBuff.lValue = tempBuff.lValue*10
                    end
                end                 
                table.insert(buffDetail, tempBuff)
            end 
        end

        if self.data.building_id == 1 then --城堡技能加成
            local heroSkills = self:getHeroSkillAdd(heroData.heroId)
            for _,v in pairs(heroSkills) do
                table.insert(buffDetail, v)
            end
        end

        return buffDetail, toaInterior
    end

    self.heroData = {}
    local recruitHero = global.heroData:getGotHeroData()
    for _,v in pairs(recruitHero) do
        
        local temp = {}
        temp.lid = v.heroId
        temp.lstate = 0
        if global.heroData:isHeroGarrision(v.heroId) then -- 驻防状态
            temp.lstate = 2   
        end
        temp.tagBuffDetail, temp.toaInterior = getBuffDetail(v)
        table.insert(self.heroData, temp)
    end
    if table.nums(self.heroData) > 1 then
        table.sort(self.heroData, function(s1, s2) return s1.toaInterior > s2.toaInterior end)
    end

    -- 推荐没有驻防中内政值最高的英雄
    local isRecommond = true
    local recToaInterior = 0
    for i,v in ipairs(self.heroData) do
        v.recommend = 0
        if v.lstate ~= 2 and isRecommond then
            v.recommend = 1
            isRecommond = false
            recToaInterior = v.toaInterior
        end
    end
    if isRecommond and table.nums(self.heroData) > 0 then
        self.heroData[1].recommend = 1
        recToaInterior = self.heroData[1].toaInterior
    end


    -- 获取当前选择英雄内政值
    local selToaInterior, temp = 0, 0
    for _,v in pairs(recruitHero) do
        if self.curHeroId and v.heroId == self.curHeroId then 
            temp, selToaInterior = getBuffDetail(v)  
        end
    end

    self:checkToaInterior(recToaInterior, selToaInterior)

end

-- 检测当前英雄推荐内政值是否大于当前选择英雄
function UIGarrisonSelectPanel:checkToaInterior(recToaInterior, selToaInterior)

    if self.heroData and table.nums(self.heroData) > 0 then
        if selToaInterior > recToaInterior then
            for i,v in ipairs(self.heroData) do
                if v.recommend == 1 then
                    v.recommend = 0
                end
            end
        end
    end
end

-- 获取英雄技能加成
function UIGarrisonSelectPanel:getHeroSkillAdd(heroId)
    -- body

    local skillBuffs = {}
    local recruitHero = global.heroData:getGotHeroData()
    local otherBuffList = {}
    for _,v in pairs(recruitHero) do
        
        if v.heroId == heroId then

            local skills = v.serverData.lSkill
            for _,vv in ipairs(skills) do

                if vv ~= 0 then
                    
                    local skillData = luaCfg:get_skill_by(vv)
                    if skillData and skillData.garrison == 1 then

                        local buffId = skillData.buff[1]
                        local buffValue = skillData.value[1]
                        otherBuffList[buffId] = otherBuffList[buffId] or 1
                        otherBuffList[buffId] =  (1 - buffValue/100)*otherBuffList[buffId]
                    end
                end                
            end
        end
    end

    for k,v in pairs(otherBuffList) do
        local temp = {}
        temp.lBuffid = k
        temp.lValue = (1-v)*100
        table.insert(skillBuffs, temp)
    end

    return skillBuffs
end

function UIGarrisonSelectPanel:setData(data, index)
    
    self.data = data
    self.index = index
    local buildId = data.building_id
    data.serData = data.serData or {} 
    local heroId = data.serData["lPos"..index]
    self.curHeroId = heroId

    self.tableView:setData({})
    self.FileNode_1:setVisible(false)
    self.FileNode_2:setVisible(false)
    self.upRow:setVisible(false)
    self.FileNode_1:setPositionX(-355)
    self.FileNode_2:setPositionX(-33)
    if not heroId then
        self.FileNode_1:setPositionX(-185)
    end

    self:setHeroBuffs()
    self.tableView:setData(self.heroData)
    if not heroId then
        self:refershSelect(self:getRecommondHero())
        if self:getRecommondHero() and  self:getRecommondHero().lid then -- protect 
            self:selectAndGps(self:getRecommondHero().lid)
        end 
    else
        self:refershSelect()
        self:selectAndGps(heroId)
    end
    
end

function UIGarrisonSelectPanel:selectAndGps(heroId)
    -- body
    self:refershSelectState(heroId)
    local tableData = self.tableView:getData()
    for index,v in ipairs(tableData) do
        if v.lid == heroId then
            self.tableView:jumpToCellByIdx(index-1, true)
            break
        end
    end
end

-- 获取推荐英雄
function UIGarrisonSelectPanel:getRecommondHero()

    if table.nums(self.heroData) == 0 then return end
    for i,v in ipairs(self.heroData) do
        if v.recommend == 1 then
            return v
        end
    end
    return -1
end

function UIGarrisonSelectPanel:refershBuff(heroId)

    if self.curHeroId then  
        self.upRow:setVisible(true) 
        self.FileNode_1:setVisible(true)
        self.FileNode_2:setVisible(true)
        self.FileNode_1:setData(self:getHeroDataById(self.curHeroId))
        if heroId and heroId > 0 then
            local addInterior = global.heroData:getHeroInterior(heroId) - global.heroData:getHeroInterior(self.curHeroId)
            local data = {addInterior=addInterior, nodeData=self:getHeroDataById(self.curHeroId)}
            self.FileNode_2:setData(self:getHeroDataById(heroId), data)
        else
            self.FileNode_2:setData()
        end
    else
        self.FileNode_1:setVisible(true)
        self.FileNode_1:setData(self:getHeroDataById(heroId))
    end
end

function UIGarrisonSelectPanel:getHeroDataById(heroId)

    if not heroId then return nil end
    for i,v in ipairs(self.heroData) do
        if v.lid == heroId then
            return v
        end
    end
    return nil
end

function UIGarrisonSelectPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIGarrisonSelectPanel")
end

function UIGarrisonSelectPanel:confirmHandler(sender, eventType)
    
    local isNoChange = self.curHeroId and self.curHeroId == self:getCurSelectId()
    local noSelected = self:getCurSelectId() == 0

    if isNoChange or noSelected then 
        global.panelMgr:closePanel("UIGarrisonSelectPanel")
        return 
    end

    if self.data.building_id == 1 then

        global.commonApi:heroAction(self:getCurSelectId(), 5, self.index, 1, 0, function(msg)
            global.panelMgr:closePanel("UIGarrisonSelectPanel")
            global.heroData:updateVipHero(msg.tgHero[1])
            global.tipsMgr:showWarning("garrisonSuccessful")
            gevent:call(global.gameEvent.EV_ON_GARRISON_BUILD)
        end)

    else

        global.cityApi:setGarrison(function (msg)
            -- body
            global.panelMgr:closePanel("UIGarrisonSelectPanel")
            global.heroData:updateVipHero(msg.tgHero[1])
            global.tipsMgr:showWarning("garrisonSuccessful")
            gevent:call(global.gameEvent.EV_ON_GARRISON_BUILD)

        end, self.data.building_id, self:getCurSelectId(), self.index)
    end

end

function UIGarrisonSelectPanel:getCurSelectId()
    local curSelectId, curToaInterior = 0, 0
    for _,v in ipairs(self.heroData) do
        if v.isSelected == 1 then
            curSelectId = v.lid
            curToaInterior = v.toaInterior
        end
    end
    return curSelectId, curToaInterior
end

function UIGarrisonSelectPanel:refershSelectState(lid, isNoRset)
    for i,v in ipairs(self.heroData) do
        if v.lid == lid then
            v.isSelected = 1
        else
            v.isSelected = 0
        end
    end
    self.tableView:setData(self.heroData, isNoRset)
end

-- 
function UIGarrisonSelectPanel:refershSelect(heroData, isNoRset)

    if not heroData then
        heroData = {lid=-1}
    end
    if heroData.lid == self:getCurSelectId() then 
        return 
    end
    self:refershSelectState(heroData.lid, isNoRset)
    self:refershBuff(heroData.lid)
end

function UIGarrisonSelectPanel:onExit()
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
end 

--CALLBACKS_FUNCS_END

return UIGarrisonSelectPanel

--endregion
