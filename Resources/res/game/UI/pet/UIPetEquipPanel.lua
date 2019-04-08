--region UIPetEquipPanel.lua
--Author : yyt
--Date   : 2017/12/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetEquipPanel  = class("UIPetEquipPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIPetEquipCell = require("game.UI.pet.UIPetEquipCell")

function UIPetEquipPanel:ctor()
    self:CreateUI()
end

function UIPetEquipPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_fifth")
    self:initUI(root)
end

function UIPetEquipPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_fifth")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.tintText = self.root.tintText_export
    self.curSelect = self.root.curSelect_mlan_12_export
    self.selectNum = self.root.curSelect_mlan_12_export.selectNum_export
    self.friPer = self.root.curSelect_mlan_12_export.friPer_mlan_4_export
    self.curFriendly = self.root.curFriendly_mlan_12_export
    self.curFrendlyNum = self.root.curFriendly_mlan_12_export.curFrendlyNum_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.topNode = self.root.topNode_export
    self.botNode = self.root.botNode_export
    self.table_node = self.root.table_node_export
    self.wy_btn = self.root.bottom.wy_btn_export
    self.friendly_bg = self.root.friendly_bg_export
    self.friendlyBarCur = self.root.friendly_bg_export.friendlyBarCur_export
    self.loadBarBg = self.root.friendly_bg_export.loadBarBg_export
    self.friendlyBar = self.root.friendly_bg_export.loadBarBg_export.friendlyBar_export
    self.loadingEffect = self.root.friendly_bg_export.loadBarBg_export.loadingEffect_export
    self.maxBar = self.root.friendly_bg_export.maxBar_export
    self.normalBar = self.root.friendly_bg_export.normalBar_export
    self.friendCur = self.root.friendly_bg_export.normalBar_export.friendCur_export
    self.friendMax = self.root.friendly_bg_export.normalBar_export.friendMax_export
    self.levelUp = self.root.friendly_bg_export.levelUp_export
    self.model = self.root.model_export

    uiMgr:addWidgetTouchHandler(self.wy_btn, function(sender, eventType) self:feedHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPetEquipCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)
    self.table_node:addChild(self.tableView)

    global.petEqiPanel = self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetEquipPanel:onEnter()

    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("pet/pet_fifth")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)

    self.isEnoughFri = false
    self.isPageMove = false
    self.model:setVisible(false)
    self:registerMove()
end

function UIPetEquipPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPetEquipPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end

    if self.scheduleListenerLoadCut then
        gscheduler.unscheduleGlobal(self.scheduleListenerLoadCut)
        self.scheduleListenerLoadCut = nil
    end
    if self.scheduleListenerLoadAdd then
        gscheduler.unscheduleGlobal(self.scheduleListenerLoadAdd)
        self.scheduleListenerLoadAdd = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIPetEquipPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIPetEquipPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPetEquipPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIPetEquipPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPetEquipPanel:setData(data)
    -- body
    self.data = data
    self.maxBar:setVisible(false)
    self.normalBar:setVisible(false)
    self.levelUp:setVisible(false)
    local nextLv = data.serverData.lGrade+1
    if data.serverData.lGrade >= data.maxLv then
        self.maxBar:setString("MAX")
        self.maxBar:setVisible(true)
        self.friendlyBar:setPercent(100)
    else
        self.normalBar:setVisible(true)
        local nextConfig = global.petData:getPetConfig(data.id, nextLv)
        self.friendCur:setString(data.serverData.lImpress)
        self.friendMax:setString(nextConfig.exp)
        self.friendlyBar:setPercent(data.serverData.lImpress/nextConfig.exp*100)
        self.friendlyBarCur:setPercent(data.serverData.lImpress/nextConfig.exp*100)
    end
    self:loadEffect() 
    

    self.equipData = {}
    local allEquip = clone(global.equipData:getAllEquipsForUI(2))
    for i,v in ipairs(allEquip) do
        local impr = luaCfg:get_equipment_by(v.confData.id).petImpress
        if impr > 0 then
            v.isSelected = 0
            table.insert(self.equipData, v)
        end
    end 
    table.sort(self.equipData, function(s1, s2) 
        local impr1 = luaCfg:get_equipment_by(s1.confData.id).petImpress
        local impr2 = luaCfg:get_equipment_by(s2.confData.id).petImpress
        return impr1 <  impr2
    end)
    self.tableView:setData(self.equipData)


    self.selectNum:setString(0)
    self.curFrendlyNum:setString(0)

    global.tools:adjustNodePosForFather(self.curSelect , self.selectNum)
    global.tools:adjustNodePosForFather(self.curFriendly , self.curFrendlyNum)
    global.tools:adjustNodePos(self.selectNum, self.friPer, 5)
end

function UIPetEquipPanel:loadEffect()

    local lW = self.friendlyBar:getContentSize().width
    local per = self.friendlyBar:getPercent()
    local curLw = lW*per/100
    self.loadingEffect:setPositionX(curLw)
end

function UIPetEquipPanel:getCurSelectNum()

    local curSelect, curFriendly = 0, 0
    for i,v in ipairs(self.equipData) do
        if v.isSelected == 1 then
            curSelect = curSelect + 1
            curFriendly = curFriendly + luaCfg:get_equipment_by(v.confData.id).petImpress
        end
    end
    return curSelect, curFriendly
end

function UIPetEquipPanel:isEnoughFri()
    return self.isEnoughFri 
end

function UIPetEquipPanel:reFresh(curPer)
    
    self.isEnoughFri = false
    local curSelectNum, curFriendlyTotal = self:getCurSelectNum()
    self.selectNum:setString(curSelectNum)
    self.curFrendlyNum:setString(curFriendlyTotal)

    self.levelUp:setVisible(false)
    self.maxBar:setVisible(false)
    self.normalBar:setVisible(false)
    local nextLv = self.data.serverData.lGrade+1
    if self.data.serverData.lGrade >= self.data.maxLv then
        self.maxBar:setString("MAX")
        self.maxBar:setVisible(true)
        self.friendlyBar:setPercent(100)
        self:loadEffect() 
    else
        curFriendlyTotal = curFriendlyTotal + self.data.serverData.lImpress
        local nextConfig = global.petData:getPetConfig(self.data.id, nextLv)
        if curFriendlyTotal > nextConfig.exp then
            self.levelUp:setVisible(true)
            self.levelUp:setString(luaCfg:get_local_string(10981))
            self:addPer(100, curFriendlyTotal)
            self.isEnoughFri = true 
        else
            self.normalBar:setVisible(true)
            local curPer = curFriendlyTotal/nextConfig.exp*100
            local curImpress = tonumber(self.friendCur:getString())
            if curImpress < curFriendlyTotal then
                self:addPer(curPer, curFriendlyTotal)
            else
                self:cutPer(curPer, curFriendlyTotal)
            end
        end
  
    end

end

function UIPetEquipPanel:cutPer(per, impress)

    self.model:setVisible(true)
    local tempPer = self.friendlyBarCur:getPercent()
    local cutPer = tempPer - per
    local curImpress = tonumber(self.friendCur:getString())
    local cutPress = curImpress - impress

    if self.scheduleListenerLoadCut then
        gscheduler.unscheduleGlobal(self.scheduleListenerLoadCut)
        self.scheduleListenerLoadCut = nil
    end

    self.scheduleListenerLoadCut = gscheduler.scheduleGlobal(function()

        tempPer = tempPer - 3
       if tempPer <= per then
            gscheduler.unscheduleGlobal(self.scheduleListenerLoadCut)
            self.friendlyBarCur:setPercent(per)
            self.friendCur:setString(impress)
            self.model:setVisible(false)
            return
        end

        self.friendlyBarCur:setPercent(tempPer)        
        curImpress = curImpress + cutPress/cutPer
        self.friendCur:setString(math.floor(curImpress))
       
    end, 1/60)
end

function UIPetEquipPanel:addPer(per, impress)

    self.model:setVisible(true)
    local tempPer = self.friendlyBarCur:getPercent()
    local addPer = per - tempPer
    local curImpress = tonumber(self.friendCur:getString())
    local addPress = impress - curImpress

    if self.scheduleListenerLoadAdd then
        gscheduler.unscheduleGlobal(self.scheduleListenerLoadAdd)
        self.scheduleListenerLoadAdd = nil
    end

    self.scheduleListenerLoadAdd = gscheduler.scheduleGlobal(function()

        tempPer = tempPer + 3
        if tempPer >= per then
            gscheduler.unscheduleGlobal(self.scheduleListenerLoadAdd)
            self.friendlyBarCur:setPercent(per)
            self.friendCur:setString(impress)
            self.model:setVisible(false)
            return
        end

        self.friendlyBarCur:setPercent(tempPer)        
        curImpress = curImpress + addPress/addPer
        self.friendCur:setString(math.floor(curImpress))
       
    end, 1/60)
end

function UIPetEquipPanel:refershSelect(lID)

    for i,v in ipairs(self.equipData) do
        if v.lID == lID then
            v.isSelected = v.isSelected == 0 and 1 or 0
        end
    end

    self.tableView:setData(self.equipData, true)
    self:reFresh()
end

function UIPetEquipPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPetEquipPanel")
end

function UIPetEquipPanel:feedHandler(sender, eventType)

    local getSelectEquip = function ()
        -- body
        local temp = {}
        for i,v in ipairs(self.equipData) do
            if v.isSelected == 1 then
                table.insert(temp, v.lID) -- 装备序号id
            end
        end
        return temp
    end
    
    if table.nums(getSelectEquip()) == 0 then
        return global.tipsMgr:showWarning("petEquipFeedNoChoice")
    end

    local resetOffset = function (tbOffset, minOffset)
        local curMinOffset = self.tableView:minContainerOffset().y
        if curMinOffset < 0 then
            if math.abs(tbOffset.y) < gdisplay.width/2 then
                self.tableView:scrollToBottom()
            else
                tbOffset.y = tbOffset.y - (math.abs(curMinOffset) - minOffset)
                self.tableView:setContentOffset(tbOffset)
            end
        end
    end

    global.petApi:actionPet(function (msg)
        -- body
        if not msg then return end
        self.isEnoughFri = false
        global.petData:updateGodAnimal(msg.tagGodAnimal or {})

        local tbOffset = self.tableView:getContentOffset() 
        local minOffset = math.abs(self.tableView:minContainerOffset().y) 

        self:setData(global.petData:getGodAnimalByType(self.data.id))
        resetOffset(tbOffset, minOffset)  -- 重置 

        gevent:call(global.gameEvent.EV_ON_PET_REFERSH)
        global.tipsMgr:showWarning("petPrompt01")
        gevent:call(gsound.EV_ON_PLAYSOUND,"pet_feelup")
        
    end, 2, self.data.id, 3, 0, 0, getSelectEquip())

end
--CALLBACKS_FUNCS_END

return UIPetEquipPanel

--endregion
