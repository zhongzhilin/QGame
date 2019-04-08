--region UIWildSoldierPanel.lua
--Author : yyt
--Date   : 2016/11/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UITableView = require("game.UI.common.UITableView")
local UIWildSoldierItemCell = require("game.UI.world.widget.wild.UIWildSoldierItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIWildResPro = require("game.UI.world.widget.wild.UIWildResPro")
--REQUIRE_CLASS_END
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")

local UIWildSoldierPanel  = class("UIWildSoldierPanel", function() return gdisplay.newWidget() end )

function UIWildSoldierPanel:ctor()
    self:CreateUI()
end

function UIWildSoldierPanel:CreateUI()
    local root = resMgr:createWidget("wild/wild_ziyuan_bj3")
    self:initUI(root)
end

function UIWildSoldierPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_ziyuan_bj3")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)
    self.name = self.root.Node_export.name_export
    self.FileNode_1 = self.root.Node_export.FileNode_1_export
    self.FileNode_1 = UIWildResPro.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1_export)
    self.collection = self.root.Node_export.collection_export
    self.collectionnew = self.root.Node_export.collectionnew_export
    self.attack = self.root.Node_export.attack_export
    self.scrollView = self.root.Node_export.scrollView_export
    self.tableContent = self.root.Node_export.tableContent_export
    self.itemContent = self.root.Node_export.itemContent_export
    self.topNode = self.root.Node_export.topNode_export
    self.bottomNode = self.root.Node_export.bottomNode_export
    self.attack_detail = self.root.Node_export.attack_detail_export
    self.noHeroGarrison = self.root.Node_export.noHeroGarrison_mlan_40_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collectionnew, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:action_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.titleNode = self.Node.title_node

    local size = self.tableContent:getContentSize()
    self.tableView = UITableView.new()
        :setSize(size, self.topNode, self.bottomNode)
        :setCellSize(self.itemContent:getContentSize())
        :setCellTemplate(UIWildSoldierItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.scrollView:addChild(self.tableView)
    self.tableView:setPositionY(self.titleNode:getPositionY() - size.height + 25)
     self.close_node:setData(function ()
        global.panelMgr:closePanel("UIWildSoldierPanel")
    end)

 end

function  UIWildSoldierPanel:close_call(sender, eventType)
    global.panelMgr:closePanel("UIWildResOwnerPanel")
end
function UIWildSoldierPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,function()
        self:reloadData()
    end)
end

function UIWildSoldierPanel:setData(data)
    self.data = data
    self.designerData = luaCfg:get_wild_res_by(data.lKind)
    local pos = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))

    self.name:setString(string.format("%s(%s,%s)",self.designerData.name,pos.x,pos.y))

    global.g_worldview.worldPanel.chooseCityId = self.data.lResID
    global.g_worldview.worldPanel.chooseCityName = self.designerData.name

    self.FileNode_1:setOverCall(handler(self,self.hpOver))
    
    self:reloadData()    
end

function UIWildSoldierPanel:reloadData()
    
    local troopsData = global.troopData:getTroopsByCityId(self.data.lResID)
    
    for _,v in ipairs(troopsData) do
        
        v._tempData = v._tempData or {}
        v._tempData.designerData = self.designerData

        local heroId = 0
        if v.lHeroID then
       
            heroId = v.lHeroID[1] 
        end 

        if heroId == 0 then
        
            v._tempData.add = 0        
        else

            local heroData = luaCfg:get_hero_property_by(heroId)
            v._tempData.add = global.heroData:getHeroGovAdd(heroId)

            --if heroData.heroType ~= 3 then
            --    v._tempData.add = 0
            --end
        end        
    end

    table.sortBySortList(troopsData,{{"_tempData.add","max"}})

    for i,v in ipairs(troopsData) do
        
        if i ~= 1 then
        
            v._tempData.add = 0
        end        
    end

    self.noHeroGarrison:setVisible(#troopsData == 0)

    self.tableView:setData(troopsData)

    self.FileNode_1:setData(self.data,self.designerData,true)
end

function UIWildSoldierPanel:setObj(obj)
    
    self.obj = obj
end

function UIWildSoldierPanel:hpOver()
    self:onCloseHandler()
    global.tipsMgr:showWarning("ResVillageDis")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWildSoldierPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIWildSoldierPanel")
end

function UIWildSoldierPanel:collect_click(sender, eventType)
    local cityId = self.data.lResID
    -- if global.collectData:checkCollect(cityId) then

    --     local tempData = {}
    --     tempData.lMapID = self.designerData.file
    --     tempData.lPosX = self.data.lPosX
    --     tempData.lPosY = self.data.lPosY
    --     tempData.szName = self.designerData.name

    --     local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
    --     collectPanel:setData( cityId, tempData)
    -- else
    --     global.tipsMgr:showWarning("Collectionend")
    -- end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("GiveUpOppucy", function()
        
        global.worldApi:giveupOcc(cityId,function()
                    
            global.panelMgr:closePanel("UIWildSoldierPanel")
            global.tipsMgr:showWarning("giveUpWild")
            gevent:call(global.gameEvent.EV_ON_UI_LEISURE)
        end)    
    end)
end

function UIWildSoldierPanel:action_click(sender, eventType)

    local openCall = function()
        local attackBoard = UIAttackBoard.new()
        attackBoard:changeSharpPos()
        attackBoard:setCity(self.obj,self.designerData.energy)

        self.attack_detail:addChild(attackBoard)
        self.attack_detail:setLocalZOrder(2)
        self.attackBoard = attackBoard
    end

    local isSelfProect,endTime = global.g_worldview.worldPanel:isMainCityProtect()

    if isSelfProect and self.obj:isOccupire() and false then

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        local str = global.troopData:timeStringFormat(endTime - global.dataMgr:getServerTime())
        panel:setData("ProtectPrompt", function()
                
            global.worldApi:removeProtection(function(msg)
                    
                openCall()
            end)
        end,str,global.luaCfg:get_config_by(1).protectCD / 60)
    else

        openCall()
    end   
end

function UIWildSoldierPanel:infoCall(sender, eventType)

    local panel = global.panelMgr:openPanel("UIIntroducePanel")
    panel:setData(luaCfg:get_introduction_by(15))
end

function UIWildSoldierPanel:shareHandler(sender, eventType)

    local x = self.data.lPosX
    local y = self.data.lPosY
    local posXY = global.g_worldview.const:converPix2Location(cc.p(x, y))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)

    local surfaceData = luaCfg:get_world_surface_by(self.designerData.file) 
    local lWildKind = surfaceData.mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.designerData.name, posX = x,posY = y,cityId = self.data.lResID,wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl) 

end

function UIWildSoldierPanel:collectionHandler(sender, eventType)

    local cityId = self.data.lResID
    if global.collectData:checkCollect(cityId) then

        local tempData = {}
        tempData.lMapID = self.designerData.file
        tempData.lPosX = self.data.lPosX
        tempData.lPosY = self.data.lPosY
        tempData.szName = self.designerData.name

        local collectPanel = global.panelMgr:openPanel("UICollectPanel") 
        collectPanel:setData( cityId, tempData)
    else
        global.tipsMgr:showWarning("Collectionend")
    end
end
--CALLBACKS_FUNCS_END

return UIWildSoldierPanel

--endregion
