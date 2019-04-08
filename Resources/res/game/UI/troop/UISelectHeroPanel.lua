--region UISelectHeroPanel.lua
--Author : yyt
--Date   : 2016/09/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIHeroListItem = require("game.UI.hero.UIHeroListItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISelectHeroPanel  = class("UISelectHeroPanel", function() return gdisplay.newWidget() end )

function UISelectHeroPanel:ctor()
    self:CreateUI()
end

function UISelectHeroPanel:CreateUI()
    local root = resMgr:createWidget("troop/hero_choose")
    self:initUI(root)
end

function UISelectHeroPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/hero_choose")
    

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.layout_list = self.root.Node_export.layout_list_export
    self.title = self.root.Node_export.list_bg.title_mlan_10_export
    self.number_parent = self.root.Node_export.list_bg.number_parent_export
    self.number_1 = self.root.Node_export.list_bg.number_parent_export.number_1_export
    self.number_2 = self.root.Node_export.list_bg.number_parent_export.number_2_export
    self.item_layout = self.root.Node_export.list_bg.item_layout_export
    self.ScrollHero = self.root.Node_export.list_bg.ScrollHero_export
    self.btn_left = self.root.Node_export.btn_left_export
    self.btn_right = self.root.Node_export.btn_right_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.list_bg.confirmBtn, function(sender, eventType) self:confimHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_left, function(sender, eventType) self:left_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_right, function(sender, eventType) self:right_click(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)

    self.itemSwitch = {}

end

function UISelectHeroPanel:onEnter()

    self.ScrollHero:addEventListener(function(arg1,arg2,arg3)
        local innerW = self.ScrollHero:getInnerContainerSize().width
        local conW = self.ScrollHero:getContentSize().width
        local sW = self.item_layout:getContentSize().width
        if arg2 then
            if self.recruitHeroNum <= 3 then
                return
            end
            local x = self.ScrollHero:getInnerContainerPosition().x
            local scroX =  math.abs(x)
            if scroX >= 0  and scroX <= sW/3 then
                self.btn_left:setEnabled(false)
                self.btn_right:setEnabled(true)
            elseif scroX > sW/3 and scroX<=(innerW - conW) - sW/3 then

                self.btn_left:setEnabled(true)
                self.btn_right:setEnabled(true)
            elseif scroX>(innerW - conW) - sW/3  and scroX <= (innerW - conW) then
      
                self.btn_left:setEnabled(true)
                self.btn_right:setEnabled(false)
            end

            if x >= 0 then
                 self.btn_left:setEnabled(false)
            end
        end
    end)

   self:registerMove()
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

----------------  滑动监听 --------------------------

function UISelectHeroPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
local beganPos = cc.p(0,0)
local isMoved = false
function UISelectHeroPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    if CCHgame.setNoTouchMove then
        CCHgame:setNoTouchMove(self.ScrollHero, true)
    end
    return true
end
function UISelectHeroPanel:onTouchMoved(touch, event)

    isMoved = true
    if self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        CCHgame:setNoTouchMove(self.ScrollHero, false)
    else
        CCHgame:setNoTouchMove(self.ScrollHero, true)
    end
end

function UISelectHeroPanel:onTouchEnded(touch, event)

    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isMove = true 
    else
        self.isMove = false
    end
end

function UISelectHeroPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

----------------  滑动监听 --------------------------

function UISelectHeroPanel:setData( _lastHeroId , _curHeroId , isHideNumber , sendData )

    self.curHeroData = {}
    self.isClick = false
    self:stopAllActions()
    self.ScrollHero:jumpToLeft()

    self.number_parent:setVisible(false)

    self.title:setString(luaCfg:get_local_string(10349))

    self.SELECT_FIRST = true
    self.curHeroTag = 0
     
    self.recruitHeroNum = 0
    self.itemSwitch = {}
    self.ScrollHero:removeAllChildren()

    local  recruitHero = sendData or global.heroData:getActiveHero(_lastHeroId)
   
    -- dump(recruitHero,">>>>>>>>>>>>>>>recruitHero")

    table.sort(recruitHero , function ( a,  b) 
        if a.serverData and b.serverData then 
            return a.serverData.lPower > b.serverData.lPower           
        end 
    end)


    local i = 1
    local sW = self.item_layout:getContentSize().width
    for _,v in pairs(recruitHero) do
        
        local item = UIHeroListItem.new()
        item:setPosition(cc.p(sW*(i-1) , 0))
        item:setData(v)
        item.btnBg:setTag(1090 + i)
        
        if _curHeroId == v.heroId then
            item.select_bg:setVisible(true)
            self.SELECT_FIRST = false
            self.curHeroTag = 1090 + i  ---1
        end
        
        table.insert(self.itemSwitch, item)
        item:setCallBackFunc(handler(self, self.heroItemCallBack), self.itemSwitch, true)
        self.ScrollHero:addChild(item)
        i = i + 1
    end
    
    self.recruitHeroNum = #recruitHero
    self.ScrollHero:setInnerContainerSize(cc.size((#recruitHero)*sW, self.ScrollHero:getContentSize().heigh))

    
    self.number_1:setString(#recruitHero)
    self.number_2:setString(global.heroData:getMaxHeroNum())

    if #recruitHero <= 3 then
        self.btn_left:setEnabled(false)
        self.btn_right:setEnabled(false)
    else
        self.btn_left:setEnabled(false)
        self.btn_right:setEnabled(true)
    end

    if self.curHeroTag > 0 then
        local idx = self.curHeroTag - 1090
        local idxPer = idx/self.recruitHeroNum*100
        if idx <=4 then 
            idxPer = 0
        elseif idx >=(self.recruitHeroNum-4) then 
            idxPer = 100
        end
        self.ScrollHero:jumpToPercentHorizontal(idxPer)
    end
    
end

function UISelectHeroPanel:setTarget(target)
    
    self.target = target
end

function UISelectHeroPanel:setExitCall(exitCall)

    self.exitCall = exitCall
end

function UISelectHeroPanel:heroItemCallBack(data)
    -- self.target:setHeroIcon(data)
    self.curHeroData = data 
    self.isClick = true
end

function UISelectHeroPanel:onExit()
    self.isMove = false
end

function UISelectHeroPanel:left_click(sender, eventType)

    local container = self.ScrollHero:getInnerContainer()
    local  isEnoughOneItem, scroX, sW = self:checkEnoughOneItem(0)
    if isEnoughOneItem > 1 then
        local moveAction = cc.MoveTo:create(0.3, cc.p(scroX+sW, self.ScrollHero:getInnerContainerPosition().y))
        container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
        self.btn_right:setEnabled(true)

    else
        self.ScrollHero:scrollToPercentHorizontal(0, 1, true)
        self.btn_left:setEnabled(false)
    end
end

function UISelectHeroPanel:right_click(sender, eventType)

    local container = self.ScrollHero:getInnerContainer()
    local  isEnoughOneItem, scroX, sW  =  self:checkEnoughOneItem(1)
    if isEnoughOneItem > 1 then
        local moveAction = cc.MoveTo:create(0.3, cc.p(scroX-sW, self.ScrollHero:getInnerContainerPosition().y))
       container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
       self.btn_left:setEnabled(true)
    else
        self.ScrollHero:scrollToPercentHorizontal(100, 1, true)
        self.btn_right:setEnabled(false)
    end
end

function UISelectHeroPanel:checkEnoughOneItem( _dirction )
    
    local isEnoughOneItem = 0
    local sW = self.item_layout:getContentSize().width
    local scroWidth = self.ScrollHero:getContentSize().width
    local totalWidth =  self.recruitHeroNum*sW
    local scroX =  self.ScrollHero:getInnerContainerPosition().x

    if _dirction == 0 then
        isEnoughOneItem = math.floor(math.abs(scroX)/180)
    else
        isEnoughOneItem = math.floor((totalWidth - math.abs(scroX) - scroWidth)/180)
    end
    return isEnoughOneItem, scroX, sW
end

function UISelectHeroPanel:exit(sender, eventType)
    global.panelMgr:closePanel("UISelectHeroPanel")
end

function UISelectHeroPanel:confimHandler(sender, eventType)

    global.panelMgr:closePanel("UISelectHeroPanel")
    if self.isClick then
        self.target:setHeroIcon(self.curHeroData)
    end
    if self.exitCall then self.exitCall() end
end
--CALLBACKS_FUNCS_END

return UISelectHeroPanel

--endregion
