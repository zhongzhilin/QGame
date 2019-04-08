--region UIPetFriendlyPanel.lua
--Author : yyt
--Date   : 2017/12/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetFriendlyPanel  = class("UIPetFriendlyPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIPetFriendlyCell = require("game.UI.pet.UIPetFriendlyCell")

function UIPetFriendlyPanel:ctor()
    self:CreateUI()
end

function UIPetFriendlyPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_fourth")
    self:initUI(root)
end

function UIPetFriendlyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_fourth")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.tit = self.root.title_export.tit_fnt_mlan_12_export
    self.friendly_bg = self.root.friendly_bg_export
    self.loadBg = self.root.friendly_bg_export.loadBg_export
    self.friendlyBar = self.root.friendly_bg_export.loadBg_export.friendlyBar_export
    self.loadingEffect = self.root.friendly_bg_export.loadBg_export.loadingEffect_export
    self.frendNum = self.root.friendly_bg_export.loadBg_export.frendNum_export
    self.table_node = self.root.table_node_export
    self.topNode = self.root.topNode_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPetFriendlyCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)
    
    global.petFriPanel = self

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetFriendlyPanel:onEnter()
    self.isPageMove = false
    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_PET_REFERSH, function ()
        -- body
        if self.setData then
            self:setData(global.petData:getGodAnimalByType(self.data.id))
        end
    end)
end

function UIPetFriendlyPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPetFriendlyPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIPetFriendlyPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIPetFriendlyPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPetFriendlyPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIPetFriendlyPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPetFriendlyPanel:setData(data)
    
    self.data = data
    local resFeed = luaCfg:pet_feed()
    self.tableView:setData(resFeed)

    local nextLv = data.serverData.lGrade+1
    if data.serverData.lGrade >= data.maxLv then
        self.frendNum:setString("MAX")
        self.friendlyBar:setPercent(100)
    else
        local nextConfig = global.petData:getPetConfig(data.id, nextLv)
        self.frendNum:setString(data.serverData.lImpress .. "/" .. nextConfig.exp)
        self.friendlyBar:setPercent(data.serverData.lImpress/nextConfig.exp*100)
    end

    local lW = self.friendlyBar:getContentSize().width
    local per = self.friendlyBar:getPercent()
    local curLw = lW*per/100
    self.loadingEffect:setPositionX(curLw)

    -- self.NodeStar:setData(data.serverData.lGrade)
    -- local petConfig = global.petData:getPetConfig(data.type, data.serverData.lGrade)
    -- if petConfig then
    --     self.root:removeChildByTag(010203)
    --     local node = resMgr:createCsbAction(petConfig.Animation, "animation0" , true)
    --     node:setPosition(self.petPos:getPosition())
    --     -- node:setScale(1.5)
    --     node:setTag(010203)
    --     self.root:addChild(node)
    -- end
end


function UIPetFriendlyPanel:onExit()
end

function UIPetFriendlyPanel:infoHandler(sender, eventType)
    local data = luaCfg:get_introduction_by(31)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIPetFriendlyPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPetFriendlyPanel")
end
--CALLBACKS_FUNCS_END

return UIPetFriendlyPanel

--endregion
