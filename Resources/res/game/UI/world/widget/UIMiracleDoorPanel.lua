--region UIMiracleDoorPanel.lua
--Author : Untory
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
local UIWildSoldier = require("game.UI.world.widget.wild.UIWildSoldier")
--REQUIRE_CLASS_END
local UIAttackBoard = require("game.UI.world.widget.UIAttackBoard")

local UIMiracleDoorPanel  = class("UIMiracleDoorPanel", function() return gdisplay.newWidget() end )

function UIMiracleDoorPanel:ctor()
    self:CreateUI()
end

function UIMiracleDoorPanel:CreateUI()
    local root = resMgr:createWidget("wild/temple_1st_bg")
    self:initUI(root)
end 

function UIMiracleDoorPanel:setObj(obj)
    self.obj = obj
end

function UIMiracleDoorPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_1st_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)
    self.name = self.root.Node_export.name_export
    self.inside_name = self.root.Node_export.Node_1.name_mlan_3.inside_name_export
    self.protect_desc = self.root.Node_export.Node_1.protect_desc_export
    self.time = self.root.Node_export.Node_1.protect_desc_export.time_export
    self.combat = self.root.Node_export.Node_1.combat_mlan_8.combat_export
    self.type_icon = self.root.Node_export.Node_1.type_bj.type_icon_export
    self.collection = self.root.Node_export.collection_export
    self.attack = self.root.Node_export.attack_export
    self.d1 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d1, self.root.Node_export.recruit_title.d1)
    self.d2 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d2, self.root.Node_export.recruit_title.d2)
    self.d3 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d3, self.root.Node_export.recruit_title.d3)
    self.d4 = UIWildSoldier.new()
    uiMgr:configNestClass(self.d4, self.root.Node_export.recruit_title.d4)
    self.a1 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a1, self.root.Node_export.recruit_title_0.a1)
    self.a2 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a2, self.root.Node_export.recruit_title_0.a2)
    self.a3 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a3, self.root.Node_export.recruit_title_0.a3)
    self.a4 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a4, self.root.Node_export.recruit_title_0.a4)
    self.attack_detail = self.root.Node_export.attack_detail_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collectionHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack, function(sender, eventType) self:militaryHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIMiracleDoorPanel:setData(data,city)

    self.data = data
    self.designerData = luaCfg:get_wild_res_by(data.lKind)

    self.combat:setString(self.designerData.combat)

    global.tools:adjustNodePosForFather(self.combat:getParent(),self.combat)

    self.surfaceData = luaCfg:get_world_surface_by(self.designerData.file)
    local pos = global.g_worldview.const:converPix2Location(cc.p(self.data.lPosX, self.data.lPosY))

    self.name:setString(string.format("%s(%s,%s)",self.designerData.name,pos.x,pos.y))
    self.inside_name:setString(self.designerData.name)
    global.panelMgr:setTextureFor(self.type_icon, self.surfaceData.worldmap)
    self.type_icon:setScale(self.surfaceData.iconSize)

    global.tools:adjustNodePosForFather(self.inside_name:getParent(),self.inside_name)

    self:startCheckTimeForProtect()
    self.protectEndTime = self.data.lFlushTime or 0
    self:checkTimeForProtect()

    if city:isInProtect() then

        self.isInProtect = true
        self.protect_desc:setString(luaCfg:get_local_string(10846))
    else
        self.isInProtect = false
        self.protect_desc:setString(luaCfg:get_local_string(10847))
    end
    global.tools:adjustNodePosForFather(self.protect_desc,self.time)

    local attackS = self.data.tagAtkSoldiers or {}
    for i = 1,4 do
        if attackS[i] then
            self["a"..i]:setVisible(true)
            self["a"..i]:setData(attackS[i],true)
        else
            self["a"..i]:setVisible(false)
        end
    end

    local defS = self.data.tagDefSoldiers or {}
    for i = 1,4 do
        if defS[i] then
            self["d"..i]:setVisible(true)
            self["d"..i]:setData(defS[i],true)
        else
            self["d"..i]:setVisible(false)
        end
    end

    --润稿处理 张亮
    global.tools:adjustNodePosForFather(self.inside_name:getParent(),self.inside_name)
    global.tools:adjustNodePosForFather(self.time:getParent(),self.time)
    global.tools:adjustNodePosForFather(self.combat:getParent(),self.combat)

end


function UIMiracleDoorPanel:startCheckTimeForProtect()
    
    if self.scheduleListenerIdProtect then

        gscheduler.unscheduleGlobal(self.scheduleListenerIdProtect)
    end

    self.scheduleListenerIdProtect = gscheduler.scheduleGlobal(function()
            
        self:checkTimeForProtect()
    end, 1) 
end

function UIMiracleDoorPanel:checkTimeForProtect()
    
    local contentTime = self.protectEndTime - global.dataMgr:getServerTime()
    if contentTime < 0 then contentTime = 0 end

    -- if contentTime == 0 then

    --     self.time:setVisible(false)
    --     return
    -- end

    local str = global.troopData:timeStringFormat(contentTime)
    self.time:setString(str)

    global.tools:adjustNodePosForFather(self.time:getParent(),self.time)

end

function UIMiracleDoorPanel:onExit()

    if self.scheduleListenerIdProtect then

        gscheduler.unscheduleGlobal(self.scheduleListenerIdProtect)
    end
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMiracleDoorPanel:exitCall(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UIMiracleDoorPanel")
end

function UIMiracleDoorPanel:collectionHandler(sender, eventType)
    
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

function UIMiracleDoorPanel:onEnter()
    if self.attackBoard and not tolua.isnull(self.attackBoard) then
        self.attackBoard:close()
        self.attackBoard = nil
    end
end
function UIMiracleDoorPanel:militaryHandler(sender, eventType)
    -- global.tipsMgr:showWarning("488")

    if self.isInProtect then
        global.tipsMgr:showWarning("ProtectNot")
        return
    end

    local openCall = function()
        local attackBoard = UIAttackBoard.new()
        attackBoard:changeSharpPos()
        attackBoard:setCity(self.obj,self.designerData.energy)
        self.attack_detail:addChild(attackBoard)
        self.attack_detail:setLocalZOrder(2)
        self.attackBoard = attackBoard
    end

    openCall()
end

function UIMiracleDoorPanel:shareHandler(sender, eventType)

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
--CALLBACKS_FUNCS_END

return UIMiracleDoorPanel

--endregion
