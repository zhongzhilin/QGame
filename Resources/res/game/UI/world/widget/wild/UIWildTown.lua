--region UIWildTown.lua
--Author : untory
--Date   : 2016/12/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local gameEvent = global.gameEvent
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIWildTownPro = require("game.UI.world.widget.wild.UIWildTownPro")
local UITownSoldier = require("game.UI.world.widget.wild.UITownSoldier")
--REQUIRE_CLASS_END

local UIWildTown  = class("UIWildTown", function() return gdisplay.newWidget() end )

function UIWildTown:ctor()
    self:CreateUI()
end

function UIWildTown:CreateUI()
    local root = resMgr:createWidget("wild/wild_camp_bg")
    self:initUI(root)
end

function UIWildTown:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_camp_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_export
    self.close_noe = self.root.Node_export.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.Node_export.close_noe_export)
    self.FileNode_1 = UIWildTownPro.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.collection = self.root.Node_export.collection_export
    self.attack = self.root.Node_export.attack_export
    self.level = self.root.Node_export.level_mlan_8.level_export
    self.num1 = self.root.Node_export.recruit_title.num1_mlan_6_export
    self.num = self.root.Node_export.recruit_title.num_export
    self.round1 = self.root.Node_export.recruit_title.round1_mlan_6_export
    self.round = self.root.Node_export.recruit_title.round_export
    self.d1 = UITownSoldier.new()
    uiMgr:configNestClass(self.d1, self.root.Node_export.recruit_title.d1)
    self.d2 = UITownSoldier.new()
    uiMgr:configNestClass(self.d2, self.root.Node_export.recruit_title.d2)
    self.d3 = UITownSoldier.new()
    uiMgr:configNestClass(self.d3, self.root.Node_export.recruit_title.d3)
    self.d4 = UITownSoldier.new()
    uiMgr:configNestClass(self.d4, self.root.Node_export.recruit_title.d4)
    self.wall_lv1 = self.root.Node_export.recruit_title_0.wall_lv1_mlan_6_export
    self.wall_lv = self.root.Node_export.recruit_title_0.wall_lv_export
    self.buff1 = self.root.Node_export.recruit_title_0.buff1_mlan_6_export
    self.buff = self.root.Node_export.recruit_title_0.buff_export
    self.a1 = UITownSoldier.new()
    uiMgr:configNestClass(self.a1, self.root.Node_export.recruit_title_0.a1)
    self.a2 = UITownSoldier.new()
    uiMgr:configNestClass(self.a2, self.root.Node_export.recruit_title_0.a2)
    self.attack_detail = self.root.Node_export.attack_detail_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:militaryHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END

  --  uiMgr:addWidgetTouchHandler(self.close_noe.close_btn_export, function(sender, eventType) self:close_call(sender, eventType) end)
   self.close_noe:setData(function ()
        global.panelMgr:closePanel("UIWildTown")
    end)
end

function  UIWildTown:close_call(sender, eventType)
    global.panelMgr:closePanel("UIWildTown")
end

function UIWildTown:flushContent()
    
    global.worldApi:getMonsterTownInfo(self.data.lMapID,function(msg)
        
        msg.lType = self.data.lType
        self:setData(msg,self.city,true)
    end)
end

function UIWildTown:getWorldCamp(campType)
    
    local world_camp = luaCfg:world_camp()

    for _,v in ipairs(world_camp) do

        if v.type == campType then

            return v
        end
    end
end

function UIWildTown:setData(data,city,isNeedCheckClose)
    
    self.city = city
    self.data = data

    -- dump(">>>>>>>>>tag check plus",city:getPlusData())

    local g_worldview = global.g_worldview
    local world_camp_data = self:getWorldCamp(data.lType) or {}
    local meter = g_worldview.const:converPix2Location(cc.p(data.lPosx,data.lPosy))
    self.name:setString(string.format("%s(%s,%s)",world_camp_data.name,meter.x,meter.y))
    self.FileNode_1:setData(world_camp_data,data,self.city:getSurfaceData(),city:getPlusData())
    -- self.level1:setString(world_camp_data.reqLv)
    self.world_camp_data = world_camp_data

    local tgSoldier = data.tgSoldier
    local tgSoldierCount = #tgSoldier
    for i = 1,4 do

        local d = self["d"..i]

        if i <= tgSoldierCount then

            d:setVisible(true)
            d:setData(tgSoldier[i],true)
        else
            
            d:setVisible(false)
        end
    end

    self.a1:setData({lID = 8071,lCount = world_camp_data.towerNum})
    self.a2:setData({lID = 8072,lCount = world_camp_data.trapNum})

    self.wall_lv:setString(world_camp_data.wallLv)
    self.buff:setString(string.format("%s%%",world_camp_data.defBuff))
    self.round:setString(data.lCurRound + 1)
    self.num:setString(data.lPower)

    if isNeedCheckClose then

        if data.lCurHp == world_camp_data.hp then
            
            global.panelMgr:closePanel("UIWildTown")
        elseif data.lCurHp == 0 then

            
            global.panelMgr:closePanel("UIWildTown")
        end
    end
    
    
    --  local data1 = {
    --     lCurHp    = 800,
    --     lCurRound = 0,
    --     lMapID    = 500683757,
    --     lPosx     = 20332,
    --     lPosy     = -17732,
    --     lPower    = 1000,
    --     lType = 21,
    --     tgSoldier = {
    --         [1] = {
    --             lCount = 591,
    --             lID    = 21081,
    --         },
    --         [2] = {
    --             lCount = 123,
    --             lID    = 21081,
    --         },
    --         [3] = {
    --             lCount = 2,
    --             lID    = 21081,
    --         },
    --         [4] = {
    --             lCount = 284,
    --             lID    = 21081,
    --         }
    --     }
    -- }

    --润稿翻译处理 张亮
    global.tools:adjustNodePos(self.num1,self.num,5)
    global.tools:adjustNodePos(self.round1,self.round,5)
    global.tools:adjustNodePos(self.wall_lv1,self.wall_lv,5)
    global.tools:adjustNodePos(self.buff1,self.buff,5)

    -- global.tools:adjustNodePosForFather(self.level1:getParent(),self.level1)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWildTown:collectionHandler(sender, eventType)
    
    local cityId = self.city:getId()
    if global.collectData:checkCollect(cityId) then

        local surfaceData = self.city:getSurfaceData()
        local szName = self.city:getName()
        local x, y = self.city:getPosition()
        local lMapID = surfaceData.id

        local tempData = {}
        tempData.lMapID = lMapID
        tempData.lPosX = x
        tempData.lPosY = y
        tempData.szName = szName

        local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
        collectPanel:setData( cityId, tempData)        
    else
        global.tipsMgr:showWarning("Collectionend")
    end
end


function UIWildTown:onEnter()
    
    local callBB = function(event,id)

        if self.data.lMapID == id then
        
            self:flushContent()
        end        
    end
    self:addEventListener(gameEvent.EV_ON_MONSTER_CAMP,callBB)
end

function UIWildTown:militaryHandler(sender, eventType)
    if self.city:isInProtect() then
        global.tipsMgr:showWarning("ProtectNot")
        return
    end

    if global.unionData:isMineUnion(0) then

        global.tipsMgr:showWarning("57")
        return
    end
    
    local mainCityLv = global.cityData:getTopLevelBuild(1).serverData.lGrade or 0
    if self.world_camp_data and self.world_camp_data.reqLv and mainCityLv < self.world_camp_data.reqLv then

        global.tipsMgr:showWarning("64")
        return
    end

    local afterCheckOccupyCall = function()
        
        global.troopData:setTargetData(2)
        global.panelMgr:openPanel("UITroopPanel")    
    end

    global.worldApi:checkOccupy(self.city,function(msg)        

        if msg.lStatus == 0 then

            afterCheckOccupyCall()
        else

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("MaxOccupy", afterCheckOccupyCall)
        end
    end)    
end

function UIWildTown:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIWildTown")
    -- self:flushContent()
end

function UIWildTown:infoCall(sender, eventType)

    local panel = global.panelMgr:openPanel("UIIntroducePanel")
    panel:setData(luaCfg:get_introduction_by(7))
end

function UIWildTown:shareHandler(sender, eventType)
    
    local x, y = self.city:getPosition()
    local posXY = global.g_worldview.const:converPix2Location(cc.p(x, y))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)
    local lWildKind = self.city:getSurfaceData().mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.city:getName(), posX = x,posY = y,cityId = self.city:getId(),wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl) 

end
--CALLBACKS_FUNCS_END

return UIWildTown

--endregion
