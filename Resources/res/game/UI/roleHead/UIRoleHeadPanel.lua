--region UIRoleHeadPanel.lua
--Author : yyt
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRoleHeadNode = require("game.UI.roleHead.UIRoleHeadNode")
--REQUIRE_CLASS_END

local UIRoleHeadPanel  = class("UIRoleHeadPanel", function() return gdisplay.newWidget() end )

function UIRoleHeadPanel:ctor()
    self:CreateUI()
end

function UIRoleHeadPanel:CreateUI()
    local root = resMgr:createWidget("rolehead/select_role_bg")
    self:initUI(root)
end

function UIRoleHeadPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rolehead/select_role_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.Node_Head = self.root.Node_Head_export
    self.headFream = self.root.headFream_export
    self.dia_icon = self.root.btn_sdefine.dia_icon_export
    self.dia_num = self.root.btn_sdefine.dia_num_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.FileNode_1 = self.root.ScrollView_1_export.FileNode_1_export
    self.FileNode_1 = UIRoleHeadNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.FileNode_1_export)
    self.FileNode_2 = self.root.ScrollView_1_export.FileNode_2_export
    self.FileNode_2 = UIRoleHeadNode.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.ScrollView_1_export.FileNode_2_export)
    self.FileNode_3 = self.root.ScrollView_1_export.FileNode_3_export
    self.FileNode_3 = UIRoleHeadNode.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.ScrollView_1_export.FileNode_3_export)
    self.FileNode_4 = self.root.ScrollView_1_export.FileNode_4_export
    self.FileNode_4 = UIRoleHeadNode.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.ScrollView_1_export.FileNode_4_export)
    self.FileNode_5 = self.root.ScrollView_1_export.FileNode_5_export
    self.FileNode_5 = UIRoleHeadNode.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.ScrollView_1_export.FileNode_5_export)
    self.topLayout = self.root.topLayout_export
    self.lord_red_point = self.root.Node_10.Button_2.lord_red_point_export

    uiMgr:addWidgetTouchHandler(self.root.btn_sdefine, function(sender, eventType) self:onSdefinePortrait(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_10.Button_2, function(sender, eventType) self:OnSelectHeadFrame(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_10.Button_1, function(sender, eventType) self:changeToTask(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.ScrollView_1:addEventListener(function()
        self.isStartMove = true
    end) 

    self.root.Node_10.Button_2:setZoomScale(0)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRoleHeadPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIRoleHeadPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end


    -- 退出的时候更新头像信息
    if global.headData:getCurHead() and self.curHead.id ~= global.headData:getCurHead().id and not global.headData:isSdefineHead() then 
        global.loginApi:updateUserInfo(global.headData:getCurHead().id, function(msg)
        end)
    end

end

local beganPos = cc.p(0,0)
local isMoved = false
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIRoleHeadPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    if CCHgame.setNoTouchMove then
        CCHgame:setNoTouchMove(self.ScrollView_1, true)
    end
    return true
end
function UIRoleHeadPanel:onTouchMoved(touch, event)
    isMoved = true
    if self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        CCHgame:setNoTouchMove(self.ScrollView_1, false)
    else
        CCHgame:setNoTouchMove(self.ScrollView_1, true)
    end
end

-- 手势误差处理
function UIRoleHeadPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIRoleHeadPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIRoleHeadPanel:onEnter()

    self.isPageMove = false
    self:registerMove()
    self.curHead = global.headData:getCurHead()
    
    self:addEventListener(global.gameEvent.EV_ON_USER_FLUSHUSEMSG, function ()
        self:flushHeadIcon()
    end) 

       -- 头像 消息更新
    self:addEventListener(global.gameEvent.EV_ON_HEAMFREAM_UPDATE,function()
        self:reFreshHeadFrame()
    end)

    self:addEventListener(global.gameEvent.EV_ON_LOGIC_NOTIFY_RED_POINT,function()
        self:updateLordRedPoint()
    end)

    self:updateLordRedPoint()
end



function UIRoleHeadPanel:updateLordRedPoint()

    self.lord_red_point:setVisible(false)

    if global.userData:getHeadFrameRed() > 0 then

        self.lord_red_point:setVisible(true)
    end 
end 



function UIRoleHeadPanel:flushHeadIcon()

    -- 领主头像
    local head = global.headData:getCurHead()
    global.tools:setCircleAvatar(self.Node_Head, head)

    for _,v in pairs(self.itemTable) do
        local curData = global.headData:getCurHeadStateById(v.data.id,true)

        if global.headData:isSdefineHead() then
            v.head_select:setVisible(false)
        else
            v.head_select:setVisible(curData.state == 1)
        end
        global.colorUtils.turnGray(v.Button_1, curData.useState == 0)
    end

    local isFree = global.headData:isSdefineCanfree()
    self.root.btn_sdefine.text_free_mlan_7:setVisible(isFree)
    self.dia_num:setVisible(not isFree)
    self.dia_icon:setVisible(not isFree)
end


function UIRoleHeadPanel:reFreshHeadFrame()

    -- self.headFream:setSpriteFrame(global.userheadframedata:getCrutFrame().pic)
    global.panelMgr:setTextureFor(self.headFream,global.userheadframedata:getCrutFrame().pic)
end 

local titleId = {
    [1] = 10251, -- 普通
    [2] = 10252, -- 士兵
    [3] = 10950, -- 传说
    [4] = 10253, -- 史诗
    [5] = 10433, -- 稀有
}

function UIRoleHeadPanel:setData()

    self:reFreshHeadFrame()

    self.itemTable = {}
    
    local scroH = 0
    local data =  global.headData:getAllHead() 

    local titleH =  self.FileNode_1.titleBg:getContentSize().height
    local itemBgW = self.FileNode_1.bg:getContentSize().width
    local posY = self.FileNode_1:getPositionY()
    for i=1,5 do
        self["FileNode_"..i]:setData(data[i])     
        self["FileNode_"..i].title:setString(global.luaCfg:get_local_string(titleId[i]))
        local cellH = self:getCellHeight(data[i])
        self["FileNode_"..i].bg:setContentSize(cc.size(itemBgW , cellH))
        self["FileNode_"..i]:setPositionY(posY - scroH)
        scroH = scroH + self["FileNode_"..i].bg:getContentSize().height + titleH
    end
    self:initScroll(scroH)

    self:flushHeadIcon()

    local cost = global.luaCfg:get_config_by(1).sdefine_head_cost
    self.dia_num:setString(cost)
    local propData = global.propData
    propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, cost, self.dia_num)
end

function UIRoleHeadPanel:initScroll(scroH)

    local contentSize = gdisplay.height -  self.topLayout:getContentSize().height 
    local containerSize = scroH
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, contentSize))
    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    self.ScrollView_1:setPositionY(0)

    local titleH =  self.FileNode_1.titleBg:getContentSize().height
    local posY, scroH = containerSize, 0
    for i=1,5 do
        self["FileNode_"..i]:setPositionY(posY - scroH)
        scroH = scroH + self["FileNode_"..i].bg:getContentSize().height + titleH
    end

    self.ScrollView_1:jumpToTop()
end

function UIRoleHeadPanel:getCellHeight(itemTable)
    
    local cellH = 0 
    local itemNum = table.nums(itemTable) 
    cellNum = math.ceil(itemNum/5)
    cellH = cellNum*122 + (cellNum+1)*15
    return cellH
end

function UIRoleHeadPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIRoleHeadPanel")  
end

function UIRoleHeadPanel:OnSelectHeadFrame(sender, eventType)
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_flip")
    global.panelMgr:openPanel("UISelectHeadFramePanel")

end

function UIRoleHeadPanel:changeToTask(sender, eventType)

end

function UIRoleHeadPanel:onSdefinePortrait(sender, eventType)
    local cost = global.luaCfg:get_config_by(1).sdefine_head_cost
    if not global.headData:isSdefineCanfree() and not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,cost) then
        return
    end
    global.panelMgr:openPanel("UISdefineHeadPanel")
end
--CALLBACKS_FUNCS_END

return UIRoleHeadPanel

--endregion
