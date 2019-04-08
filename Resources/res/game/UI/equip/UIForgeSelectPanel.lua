--region UIForgeSelectPanel.lua
--Author : yyt
--Date   : 2017/07/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIForgeSelectPanel  = class("UIForgeSelectPanel", function() return gdisplay.newWidget() end )
local TabControl = require("game.UI.common.UITabControl")
local UITableView = require("game.UI.common.UITableView")
local UIForgeSelectCell = require("game.UI.equip.UIForgeSelectCell")

function UIForgeSelectPanel:ctor()
    self:CreateUI()
end

function UIForgeSelectPanel:CreateUI()
    local root = resMgr:createWidget("equip/forge_2nd_bg")
    self:initUI(root)
end

function UIForgeSelectPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/forge_2nd_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.controlNode = self.root.controlNode_export
    self.point3 = self.root.controlNode_export.Button_3.point3_export
    self.point2 = self.root.controlNode_export.Button_2.point2_export
    self.point1 = self.root.controlNode_export.Button_1.point1_export
    self.suit_name = self.root.suit_name_export
    self.get_pro = self.root.get_pro_export
    self.node_tableView = self.root.node_tableView_export
    self.topNode = self.root.topNode_export
    self.bottomNode = self.root.bottomNode_export
    self.tbSize = self.root.tbSize_export
    self.itemLayout = self.root.itemLayout_export
    self.topNode1 = self.root.topNode1_export
    self.tbSize1 = self.root.tbSize1_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tabControl = TabControl.new(self.controlNode, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIForgeSelectCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    self.tableView1 = UITableView.new()
        :setSize(self.tbSize1:getContentSize(), self.topNode1, self.bottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIForgeSelectCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView1)

    self.imgLine = self.root.Image_26_0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIForgeSelectPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIForgeSelectPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.tabControl:setSelectedIdx(1)
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIForgeSelectPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIForgeSelectPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIForgeSelectPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIForgeSelectPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIForgeSelectPanel:onEnter()
    self.isPageMove = false
    self:registerMove()


    self:addEventListener(global.gameEvent.EV_ON_EQUIP_FORGIN_POINT, function ()  
        if self.checkPoint then
            self:checkPoint()   
        end   
    end)
end

function UIForgeSelectPanel:checkPoint()
    for i=1,3 do
        local suitId = self.data["suit"..i.."Id"]
        self["point"..i]:setVisible(global.equipData:checkSuitCanForge(suitId))
    end
end

function UIForgeSelectPanel:setData(data)
    
    self.data = data
    if data.suitType == 1 then
        self:setHeroEquip()
    else
        self:setLordEquip()
    end
end

function UIForgeSelectPanel:setHeroEquip()

    self.tableView1:setVisible(false)
    self.tableView:setVisible(true)
    self.controlNode:setVisible(true)
    self.suit_name:setPositionY(gdisplay.height - 180)
    self.get_pro:setPositionY(gdisplay.height - 206)
    self.imgLine:setPositionY(gdisplay.height - 330)

    self:onTabButtonChanged(1)
    self:checkPoint()

end

function UIForgeSelectPanel:setLordEquip()

    self.tableView:setVisible(false)
    self.tableView1:setVisible(true)
    self.controlNode:setVisible(false)
    self.suit_name:setPositionY(gdisplay.height - 120)
    self.get_pro:setPositionY(gdisplay.height - 166)
    self.imgLine:setPositionY(gdisplay.height - 280)

    local suitData = luaCfg:get_equipment_suit_by(self.data.lordId) or {}
    self.tableView1:setData(suitData.equipment or {}) 
    self:cellAnimation(true)

    self.suit_name:setString(suitData.suitName)
    self:setPro(suitData)

end

-- 1 攻击 2 防御 3 内政
function UIForgeSelectPanel:onTabButtonChanged(index)

    local suitId = self.data["suit".. index .."Id"] or 0
    self.suitId = suitId
    local suitData = luaCfg:get_equipment_suit_by(suitId) or {}
    self.tableView:setData(suitData.equipment or {}) 
    self:cellAnimation()

    self.suit_name:setString(suitData.suitName)
    self:setPro(suitData)
end

function UIForgeSelectPanel:setPro(suitData)
    -- body

    local data = global.equipData:getEquipById(self.suitId)
    local gotCount = 0
    for index,v in ipairs(suitData.equipment) do
        gotCount = gotCount + 1
    end

    local gotProStr = ""
    for i = 1,6 do

        local suitPros = suitData["pro"..i]
        if type(suitPros) == "table" then

            local str = luaCfg:get_local_string(10387,i,"")
            if gotCount >= i then
                gotProStr = gotProStr .. str 
            else
                gotProStr = gotProStr 
            end

            for _,suitPro in ipairs(suitPros) do             
                local leagueCfg = luaCfg:get_data_type_by(suitPro[1])
                local leaguecount = suitPro[2]
                local str = string.format(" %s+%s%s%s",leagueCfg.paraName,leaguecount,leagueCfg.str,leagueCfg.extra)                   
                if gotCount >= i then
                    gotProStr = gotProStr .. str .. "\n" 
                else
                    gotProStr = gotProStr .. "\n" 
                end
            end             
        end         
    end
    self.get_pro:setString(gotProStr)

end

-- cell 出现动画
function UIForgeSelectPanel:cellAnimation(isLord)

    global.uiMgr:addSceneModel(0.5)
    
    local allCell = {}
    if isLord then
        allCell = self.tableView1:getCells()
    else
        allCell = self.tableView:getCells()
    end
    table.sort( allCell, function(a,b)
        -- bod
        return a:getPositionY()>b:getPositionY()
    end )
    local speed = 5000
    for i = 1, #allCell do
        local target = allCell[i]
        if target:getIdx() >= 0 then

            local overCall = function ()
                gsound.stopEffect("city_click")
                gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
            end

            local opacity = 0
            local dt = 0.1*i
            local dy = -dt*speed
            if dy >= -gdisplay.height then
                dy = -gdisplay.height
            end
            local dp = cc.p(0,dy)
            local speedType = nil
            if i >= #allCell then
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            else
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            end
        end
    end
end

function UIForgeSelectPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIForgeSelectPanel")
end

--CALLBACKS_FUNCS_END

return UIForgeSelectPanel

--endregion
