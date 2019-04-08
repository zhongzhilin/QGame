--region UIPetSkillPanel.lua
--Author : yyt
--Date   : 2017/12/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetSkillPanel  = class("UIPetSkillPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIPetSkillCell = require("game.UI.pet.UIPetSkillCell")

function UIPetSkillPanel:ctor()
    self:CreateUI()
end

function UIPetSkillPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_third")
    self:initUI(root)
end

function UIPetSkillPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_third")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.select1 = self.root.up.skill_button1.select1_export
    self.red_bg = self.root.up.skill_button1.select1_export.red_bg_export
    self.select2 = self.root.up.skill_button2.select2_export
    self.red_bg = self.root.up.skill_button2.select2_export.red_bg_export
    self.skillpoint = self.root.up.skillpoint_export
    self.info_btn = self.root.up.Node_1.info_btn_export
    self.reset = self.root.bottom.reset_export
    self.diamond_num = self.root.bottom.reset_export.diamond_num_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.topNode = self.root.topNode_export
    self.botNode = self.root.botNode_export
    self.table_node = self.root.table_node_export

    uiMgr:addWidgetTouchHandler(self.root.up.skill_button1, function(sender, eventType) self:skill1Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.up.skill_button2, function(sender, eventType) self:skill2Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.info_btn, function(sender, eventType) self:infoHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.reset, function(sender, eventType) self:resetSkillHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPetSkillCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)

    self.root.up.skill_button1:setZoomScale(0)
    self.root.up.skill_button2:setZoomScale(0)
    
    global.skillPanel = self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetSkillPanel:onEnter()
    self.isPageMove = false
    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_PET_SKILL, function (event, isNoReset)
        -- body
        if self.setData then
            self:setData(global.petData:getGodAnimalByType(self.data.type), isNoReset)
        end
    end)
end

function UIPetSkillPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPetSkillPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.curSelectIndex = nil
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIPetSkillPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIPetSkillPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPetSkillPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIPetSkillPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPetSkillPanel:setData(data, isNoReset)

    self.data = data
    if self.data then 
        self.skillpoint:setString(data.serverData.lSkillPoint)
        local actPet = luaCfg:get_pet_activation_by(1)
        self.diamond_num:setString(actPet.magicCrystal)
        self:onSkillTabChange(self.curSelectIndex or 1, isNoReset)
        self:checkDiamondEnough(actPet.magicCrystal)
    end 
end

function UIPetSkillPanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamond_num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.diamond_num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UIPetSkillPanel:onSkillTabChange(index, isNoReset)

    for i=1,2 do
        self["select"..i]:setVisible(index == i)
    end
    self.tableView:setData(global.petData:getGodSkillByTriType(self.data.type, index), isNoReset)
    self.curSelectIndex = index
end

function UIPetSkillPanel:skill1Handler(sender, eventType)
    self:onSkillTabChange(1)
end

function UIPetSkillPanel:skill2Handler(sender, eventType)
    self:onSkillTabChange(2)
end

function UIPetSkillPanel:infoHandler(sender, eventType)
    local data = luaCfg:get_introduction_by(31)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIPetSkillPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPetSkillPanel")
end

function UIPetSkillPanel:resetSkillHandler(sender, eventType)

    if not self:checkDiamondEnough(tonumber(self.diamond_num:getString())) then
        global.panelMgr:openPanel("UIRechargePanel"):setCallBack(function ()
            self:checkDiamondEnough(tonumber(self.diamond_num:getString()))
        end)
        return 
    end

    global.panelMgr:openPanel("UIPetResetPanel"):setData(tonumber(self.diamond_num:getString()), function ()
        
        -- 重置神兽技能
        global.petApi:actionSkill(function (msg)

            global.petData:updateGodAnimal(msg.tagGodAnimal or {})
            global.petData:setGodSkillByType(self.data.type, nil)
            gevent:call(global.gameEvent.EV_ON_PET_SKILL)
            gevent:call(global.gameEvent.EV_ON_PET_REFERSH)
        end, self.data.type, 2)
    end)

end
--CALLBACKS_FUNCS_END

return UIPetSkillPanel

--endregion
