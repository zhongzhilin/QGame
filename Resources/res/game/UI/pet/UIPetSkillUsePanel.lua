--region UIPetSkillUsePanel.lua
--Author : yyt
--Date   : 2017/12/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIPetSkillUsePanel  = class("UIPetSkillUsePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIPetSkillUseCell = require("game.UI.pet.UIPetSkillUseCell")

function UIPetSkillUsePanel:ctor()
    self:CreateUI()
end

function UIPetSkillUsePanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_skill_use")
    self:initUI(root)
end

function UIPetSkillUsePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_skill_use")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.select1 = self.root.Node_export.skill_button1.select1_export
    self.red_bg = self.root.Node_export.skill_button1.select1_export.red_bg_export
    self.select2 = self.root.Node_export.skill_button2.select2_export
    self.red_bg = self.root.Node_export.skill_button2.select2_export.red_bg_export
    self.closeBtn = self.root.Node_export.closeBtn_export
    self.closeBtn = CloseBtn.new()
    uiMgr:configNestClass(self.closeBtn, self.root.Node_export.closeBtn_export)
    self.topNode = self.root.Node_export.topNode_export
    self.botNode = self.root.Node_export.botNode_export
    self.tbNode = self.root.Node_export.tbNode_export
    self.tbSize = self.root.Node_export.tbSize_export
    self.cellSize = self.root.Node_export.cellSize_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:closeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.skill_button1, function(sender, eventType) self:skill1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.skill_button2, function(sender, eventType) self:skill2Handler(sender, eventType) end)
--EXPORT_NODE_END
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPetSkillUseCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(3)
    self.tbNode:addChild(self.tableView)

    self.closeBtn:setData(function()
        self:closeHandler()
    end)

    self.Node.skill_button1:setZoomScale(0)
    self.Node.skill_button2:setZoomScale(0)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

    global.skillUsePanel = self

    self.Node.skill_button1:setVisible(false)
    self.Node.skill_button2:setPositionX(gdisplay.width/2)
    self.Node.skill_button2:setTouchEnabled(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetSkillUsePanel:onEnter()
    
    self.isPageMove = false
    self:registerMove()
    
    self:addEventListener(global.gameEvent.EV_ON_PET_SKILL, function (event, isNoReset)
        if self.setData then
            self:setData(isNoReset)
        end
    end)

    self:setData()
    self:initPetSKill()

end

function UIPetSkillUsePanel:initPetSKill()
    
    local curFightPet = global.petData:getGodAnimalByFighting()
    global.petApi:getSkill(function (msg)
        if not msg then return end
        if not msg.tagGodAnimalSkill then return end
        global.petData:setGodSkillByType(curFightPet.type, msg.tagGodAnimalSkill)
        if self.setData then 
            self:setData()
        end 
    end, curFightPet.type, 0)
end

function UIPetSkillUsePanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPetSkillUsePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.curSelectIndex = nil
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIPetSkillUsePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIPetSkillUsePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPetSkillUsePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIPetSkillUsePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPetSkillUsePanel:setData(isNoReset)

    self:onSkillTabChange(self.curSelectIndex or 2, isNoReset)
end

function UIPetSkillUsePanel:onSkillTabChange(index, isNoReset)

    -- 领主技能尚未开放
    if index == 1 then
        return global.tipsMgr:showWarning("FuncNotFinish")
    end

    for i=1,2 do
        self["select"..i]:setVisible(false) -- index == i)
    end

    if index == 1 then     -- 领主技能
        self.tableView:setData({}, isNoReset)
    elseif index == 2 then -- 神兽技能
        local curFightPet = global.petData:getGodAnimalByFighting()
        if curFightPet then
            self.tableView:setData(global.petData:getGodSkillByTriType(curFightPet.type, 1), isNoReset)
            global.panelMgr:setTextureFor(self.Node.skill_button2.icon, curFightPet.skillIcon)
            self.Node.skill_button2.ActiveSkill:setString(global.luaCfg:get_local_string(11085, curFightPet.name))
        end
    end

    self.curSelectIndex = index
end

function UIPetSkillUsePanel:closeHandler(sender, eventType)
    global.panelMgr:closePanel("UIPetSkillUsePanel")
end

function UIPetSkillUsePanel:skill1Handler(sender, eventType)
    self:onSkillTabChange(1)
end

function UIPetSkillUsePanel:skill2Handler(sender, eventType)
    self:onSkillTabChange(2)
end

function UIPetSkillUsePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.curSelectIndex = nil
end
--CALLBACKS_FUNCS_END

return UIPetSkillUsePanel

--endregion
