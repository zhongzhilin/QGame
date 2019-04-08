--region UIHeroNoOrder.lua
--Author : yyt
--Date   : 2017/06/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UINoOrderItem = require("game.UI.hero.UINoOrderItem")
--REQUIRE_CLASS_END
local UINoOrderItem = require("game.UI.hero.UINoOrderItem")
local UIHeroNoOrder  = class("UIHeroNoOrder", function() return gdisplay.newWidget() end )

function UIHeroNoOrder:ctor()
    self:CreateUI()
end


local UINoOrderItem = require("game.UI.hero.UINoOrderItem")

function UIHeroNoOrder:CreateUI()
    local root = resMgr:createWidget("hero/hero_get_item_bg")
    self:initUI(root)
end

function UIHeroNoOrder:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_get_item_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_mlan_12_export
    self.rightBtn = self.root.Node_export.rightBtn_export
    self.leftBtn = self.root.Node_export.leftBtn_export
    self.itemLayout = self.root.Node_export.itemLayout_export
    self.node_tableView = self.root.Node_export.node_tableView_export
    self.contentLayout = self.root.Node_export.contentLayout_export
    self.ScrollView = self.root.Node_export.ScrollView_export
    self.FileNode_1 = UINoOrderItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.ScrollView_export.FileNode_1)
    self.FileNode_1_0 = UINoOrderItem.new()
    uiMgr:configNestClass(self.FileNode_1_0, self.root.Node_export.ScrollView_export.FileNode_1_0)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:rightHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:leftHandler(sender, eventType) end)
--EXPORT_NODE_END

    local UITableView = require("game.UI.common.UITableView")
    local UIHeroNoOrderCell = require("game.UI.hero.UIHeroNoOrderCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize())
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIHeroNoOrderCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

    self.Node.info_mlan =self.Node.info_mlan_48
    self.posInfoY = self.Node.info_mlan:getPositionY()

    global.noOrderPanel = self

    self.title = self.txt_Title
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroNoOrder:tableMove()

    if table.nums(self.data) <= 3 then
        return
    end
    
    local offsetX = self.tableView:getContentOffset().x
    local itemW = self.itemLayout:getContentSize().width
    local minX = self.tableView:minContainerOffset().x

    if offsetX > -(itemW/2) then
        self.leftBtn:setEnabled(false)
        self.rightBtn:setEnabled(true)
    elseif offsetX < -(itemW/2) and offsetX > (minX+itemW/2) then
        self.leftBtn:setEnabled(true)
        self.rightBtn:setEnabled(true)
    elseif offsetX <= (minX+itemW/2) then
        self.leftBtn:setEnabled(true)
        self.rightBtn:setEnabled(false)
    end   
end

function UIHeroNoOrder:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIHeroNoOrder:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.enterWay = nil
    self.heroWay = nil 
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIHeroNoOrder:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIHeroNoOrder:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIHeroNoOrder:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIHeroNoOrder:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIHeroNoOrder:onEnter()

    self.isPageMove = false
    self:registerMove()

end

-- 进入方式 (锻造nil、 英雄nil、资源界面1)
function UIHeroNoOrder:setEnterWay(enterWay)
    self.enterWay = enterWay
end

function UIHeroNoOrder:setData(forgeData, parms)

    self.forgeData = forgeData

    self.title:setString(gls(11150))

    local data = {}
    if forgeData and not self.enterWay then --装备材料获取

        self.Node.info_mlan:setString(luaCfg:get_local_string(10748))
        data = forgeData

        table.sort(data , function(A , B ) return A < B  end )

        for key ,v in pairs(data) do 
            if  v == -1 then 
                data[key] = luaCfg:get_hero_item_get_by(28)
            end 
        end 

    elseif parms and not self.enterWay then

        self.Node.info_mlan:setString(luaCfg:get_local_string(10750))
        local itemChannel = global.heroData:getHeroPropertyById(parms) or {}
        for k,vv in pairs(itemChannel.itemGet) do
            if vv == 1 then
                for i,v in ipairs(itemChannel.gateBoss) do
                    
                    local bossData = luaCfg:get_gateboss_by(v)
                    local temp = {}
                    temp.id = v-10000
                    if bossData.Elite == 1 then
                        temp.type = luaCfg:get_local_string(10932, v)
                    else
                        temp.type = luaCfg:get_local_string(11046, bossData.lv)
                    end
                    local wild = luaCfg:get_wild_monster_by(bossData.monsterID)
                    local wildData = luaCfg:get_world_surface_by(wild.file)
                    temp.pic = wildData.uimap
                    temp.targetName = "UIBossPanel"
                    temp.building = 28
                    table.insert(data, temp)
                end
            else

                local heroGetData = luaCfg:get_hero_item_get_by(vv)
                if heroGetData.targetName == "activity" then
                    local isExitActivity = global.ActivityData:gotoActivityPanelById(heroGetData.building, true) 
                    if isExitActivity then
                        table.insert(data, heroGetData)
                    end
                else
                    table.insert(data, heroGetData)
                end

            end
        end
        if #data > 0 then
            table.sort(data, function (s1, s2)  return s1.id < s2.id end)
        end
    elseif self.enterWay and  self.enterWay == 1 then

        self.Node.info_mlan:setString(luaCfg:get_local_string(10963))
        local activityData = global.ActivityData:getActivityById(19001)
        for i,v in ipairs(luaCfg:get_resource()) do
            if v.id == 1 and activityData.serverdata ~= nil then
                table.insert(data, v)
            elseif v.id ~= 1 then
                table.insert(data, v)
            end
        end

        if #data > 0 then
            table.sort(data, function (s1, s2)  return s1.orderId < s2.orderId end)
        end
    end

    self:updateData(data)
end


function UIHeroNoOrder:setTitle(id)
    if type(id) =="string" then 
        self.Node.info_mlan:setString(id)
    else 
        self.Node.info_mlan:setString(luaCfg:get_local_string(id))
    end     
end 

function UIHeroNoOrder:updateData(data)

    self.data = data
    
    self.leftBtn:setEnabled(false)
    self.rightBtn:setEnabled(true)

    self.tableView:setData( {})

    self.ScrollView:removeAllChildren()

    self.ScrollView:setInnerContainerSize(self.ScrollView:getContentSize())

    self.ScrollView:setTouchEnabled(table.nums(data) < 3) 

    if table.nums(data) == 1 then 

        local item = UINoOrderItem.new()
        item:setPositionX(180)

        self.ScrollView:addChild(item)

        item:setData(data[1])

        self.rightBtn:setEnabled(false)

    elseif table.nums(data) == 2 then 

        local item = UINoOrderItem.new()
        local item1 = UINoOrderItem.new()

        item:setPositionX(85)
        item1:setPositionX(295)
        item:setData(data[1])
        item1:setData(data[2])

        self.ScrollView:addChild(item)
        self.ScrollView:addChild(item1)

        self.rightBtn:setEnabled(false)

    elseif table.nums(data) <= 3 then

        self.rightBtn:setEnabled(false)

        self.tableView:setData(data or {})
    else

        self.tableView:setData(data or {})
    end   


    self.Node.info_mlan:setPositionY(self.posInfoY + 25)


end


function UIHeroNoOrder:exitHandler(sender, eventType)
    global.panelMgr:closePanel("UIHeroNoOrder")
end

function UIHeroNoOrder:leftHandler(sender, eventType)

    local offset = self.tableView:getContentOffset()
    local itemW = self.itemLayout:getContentSize().width
    local maxX = self.tableView:maxContainerOffset().x
    local minX = self.tableView:minContainerOffset().x
    local moveX = offset.x + 3*itemW
    if moveX > maxX then
        moveX = maxX
    end
    global.uiMgr:addSceneModel(0.6)
    self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.5)  

end

function UIHeroNoOrder:rightHandler(sender, eventType)
    local offset = self.tableView:getContentOffset()
    local itemW = self.itemLayout:getContentSize().width
    local minX = self.tableView:minContainerOffset().x
    local moveX = offset.x - 3*itemW
    if moveX < minX then
        moveX = minX
    end
    global.uiMgr:addSceneModel(0.6)
    self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.5)
end
--CALLBACKS_FUNCS_END

return UIHeroNoOrder

--endregion
