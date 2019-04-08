--region UIDiamondBankPanel.lua
--Author : yyt
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UIDiamondBankPanel  = class("UIDiamondBankPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIDiamondBankCell = require("game.UI.diamondBank.UIDiamondBankCell")

function UIDiamondBankPanel:ctor()
    self:CreateUI()
end

function UIDiamondBankPanel:CreateUI()
    local root = resMgr:createWidget("diamond_bank/diamond_bank_bg")
    self:initUI(root)
end

function UIDiamondBankPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diamond_bank/diamond_bank_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_16_export
    self.topNode = self.root.topNode_export
    self.botNode = self.root.botNode_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.tbNode = self.root.tbNode_export
    self.FileNode_1 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.bottom_txt = self.root.bottom_txt_export
    self.red_point = self.root.red_point_export

    uiMgr:addWidgetTouchHandler(self.root.bottom_txt_export.Button_bank, function(sender, eventType) self:recordHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIDiamondBankCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(2)
    self.tbNode:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDiamondBankPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIDiamondBankPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIDiamondBankPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIDiamondBankPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIDiamondBankPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIDiamondBankPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIDiamondBankPanel:onEnter()
    
    self.isPageMove = false
    self:registerMove()
    self:setData()

    self.red_point:setVisible(global.propData:curBankCanGet())
    self:addEventListener(global.gameEvent.BANKUPDATE , function () 
        self.red_point:setVisible(global.propData:curBankCanGet())
    end)
end

function UIDiamondBankPanel:setData()
    local bankData = global.luaCfg:diamond_bank()
    self.tableView:setData(bankData)
end

function UIDiamondBankPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDiamondBankPanel")
end


function UIDiamondBankPanel:recordHandler(sender, eventType)
    global.panelMgr:openPanel("UIBankRecodePanel")
end
--CALLBACKS_FUNCS_END

return UIDiamondBankPanel

--endregion
