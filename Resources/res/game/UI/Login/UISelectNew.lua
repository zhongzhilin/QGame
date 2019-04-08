--region UISelectNew.lua
--Author : untory
--Date   : 2016/12/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UISelectNew  = class("UISelectNew", function() return gdisplay.newWidget() end )

function UISelectNew:ctor()
    self:CreateUI()
end

function UISelectNew:CreateUI()
    local root = resMgr:createWidget("login/race_select")
    self:initUI(root)
end

function UISelectNew:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/race_select")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ScrollView = self.root.ScrollView_export
    self.text1 = self.root.ScrollView_export.Node_1.text1_mlan_15_export
    self.race_def = self.root.ScrollView_export.Node_1.race_def_export
    self.race_atk = self.root.ScrollView_export.Node_1.race_atk_export
    self.racebtn3 = self.root.ScrollView_export.Node_1.racebtn3_export
    self.racebtn1 = self.root.ScrollView_export.Node_1.racebtn1_export
    self.racebtn2 = self.root.ScrollView_export.Node_1.racebtn2_export
    self.racebtn4 = self.root.ScrollView_export.Node_1.racebtn4_export
    self.racebtn5 = self.root.ScrollView_export.Node_1.racebtn5_export
    self.racebtn6 = self.root.ScrollView_export.Node_1.racebtn6_export
    self.racebtn7 = self.root.ScrollView_export.Node_1.racebtn7_export
    self.racebtn8 = self.root.ScrollView_export.Node_1.racebtn8_export
    self.racebtn9 = self.root.ScrollView_export.Node_1.racebtn9_export
    self.race_name = self.root.ScrollView_export.Node_1.race_name_export
    self.race_des = self.root.ScrollView_export.Node_1.race_des_export
    self.portrait_control = self.root.ScrollView_export.Node_1.portrait_control_export
    self.portrait_view1 = self.root.ScrollView_export.Node_1.portrait_view1_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view1_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view1_export.shadow_export
    self.portrait_view2 = self.root.ScrollView_export.Node_1.portrait_view2_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view2_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view2_export.shadow_export
    self.portrait_view3 = self.root.ScrollView_export.Node_1.portrait_view3_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view3_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view3_export.shadow_export
    self.portrait_view4 = self.root.ScrollView_export.Node_1.portrait_view4_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view4_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view4_export.shadow_export
    self.portrait_view5 = self.root.ScrollView_export.Node_1.portrait_view5_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view5_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view5_export.shadow_export
    self.portrait_view6 = self.root.ScrollView_export.Node_1.portrait_view6_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view6_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view6_export.shadow_export
    self.portrait_view7 = self.root.ScrollView_export.Node_1.portrait_view7_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view7_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view7_export.shadow_export
    self.portrait_view8 = self.root.ScrollView_export.Node_1.portrait_view8_export
    self.portrait_node = self.root.ScrollView_export.Node_1.portrait_view8_export.portrait_node_export
    self.shadow = self.root.ScrollView_export.Node_1.portrait_view8_export.shadow_export
    self.node_curr_race = self.root.ScrollView_export.Node_1.node_curr_race_export
    self.close_noe = self.root.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.close_noe_export)
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.start_btn, function(sender, eventType) self:start_game(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.start1_btn, function(sender, eventType) self:start1_game(sender, eventType) end)
--EXPORT_NODE_END
    
    self.close_noe:setVisible(false)
    self.node_curr_race:setVisible(false)
    self.root.start1_btn:setVisible(false)
    uiMgr:addWidgetTouchHandler(self.close_noe, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local races = global.luaCfg:race()

    for i,v in ipairs(races) do

        local btn = self["racebtn"..i]
        local name = btn["race"..i.."_mlan_5"]
        name.originColor = name:getTextColor()
        name.blackColor = cc.c3b(71,71,71)
        self:setRaceNameColor(name,not(v.state == 1))
        -- btn:setEnabled(v.state == 1)
        btn.isCanEdit = (v.state ~= 1)
        btn:setOpacity(0)
        btn:setCascadeOpacityEnabled(false)
        global.colorUtils.turnGray(btn,v.state ~= 1)
        -- btn:setSwallowTouches(false)
        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType) 
            
            if sender.isCanEdit then
                global.tipsMgr:showWarning('cannoteditnotopenrole')
                return
            end

            gsound.stopEffect("city_click")
            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_race")
            self:select_btn(sender,i,v) 
        end)
    end

    self.soldiers = {}
    self.dt = cc.p(0,0)
    for i = 1,8 do

        local view = self["portrait_view"..i]
        view.portrait_node_export:setScale(0.7)
        self.soldiers[i] = view

        local xpen = 4.5 - i

        view:setPositionX(xpen * 62 + 360)
    end

    self:select_btn(self.racebtn3,3,races[3])

    self:initTouch()

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
            
        self:checkSide()
    end, 0)

    self:checkSide(true)

    self:dealMove(cc.p(0,0))

    -- self:setRandName()

    self.isMove = false

end

function UISelectNew:exit_call(sender, eventType)
    global.panelMgr:destroyPanel("UISelectNew")  
end

function UISelectNew:onEnter()
    
    global.isCreating = nil
    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        if self.checkDiamondEnough then
            local m_cost = global.luaCfg:get_config_by(1).TransferCost
            self:checkDiamondEnough(m_cost)
        end
    end)
end

function UISelectNew:checkDiamondEnough(m_cost)

    self.m_enough = global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,m_cost)
    if not self.m_enough then
        self.root.start1_btn.mojing:setTextColor(gdisplay.COLOR_RED)
        global.colorUtils.turnGray(self.root.start1_btn.node_gray,true)
    else
        self.root.start1_btn.mojing:setTextColor(cc.c3b(255, 184, 34))
        global.colorUtils.turnGray(self.root.start1_btn.node_gray,false)
    end
end

function UISelectNew:setData()
    self.root.start_btn:setVisible(false)
    self.close_noe:setVisible(true)
    self.node_curr_race:setVisible(true)
    self.root.start1_btn:setVisible(true)
    self.text1:setString(global.luaCfg:get_local_string(10983))

    local m_cost = global.luaCfg:get_config_by(1).TransferCost
    self.root.start1_btn.mojing:setString(m_cost)
    self:checkDiamondEnough(m_cost)

    local dy = 131
    local currRace = global.userData:getRace()
    local pos = cc.p(self["racebtn"..currRace]:getPosition())
    self.node_curr_race:setPosition(cc.p(pos.x,pos.y+dy))
end

local UIISoldierTipsControl = require("game.UI.common.UIISoldierTipsControl")
function UISelectNew:addtips(icon,soldier_train)
    if icon.m_TipsControl then
        icon.m_TipsControl:ClearEventListener()
    end
    icon.m_TipsControl = UIISoldierTipsControl.new()
    icon.m_TipsControl:setdata(icon ,soldier_train,self.tips_node)
end

function UISelectNew:setRaceNameColor(name,isBlack)
    if name and name.blackColor then
        if isBlack then
            name:setTextColor(name.blackColor)
        else
            name:setTextColor(name.originColor)
        end
    end
end

function UISelectNew:select_btn(btn,race,v)
    
    self.race_id = race
    self.race_name:setString(v.name)
    self.race_des:setString(v.des)

    if tolua.isnull(self.preFlag) then
        self.preFlag = resMgr:createCsbAction("effect/race_pick", "start", false, false,nil,function()

            self.preFlag.timeLine:play("loop",true)
            self.preFlag.timeLine:setLastFrameCallFunc(function()                
                end)        
        end)    
        self.ScrollView.Node_1:addChild(self.preFlag)
    end
    self.preFlag:setPosition(btn:getPosition())


    local tools = global.tools
    local soldier_train = luaCfg:soldier_train()
    local count = 0
    for i,k in pairs(soldier_train) do

        if k.race == race and k.type >= 1 and k.type <= 4 then
          
            count = count + 1            
            if count <= 8 then
                
                local node = self.soldiers[count].portrait_node_export
                tools:setSoldierAvatar(node,k)

                self:addtips(self.soldiers[count],k)      
            end              
        end
    end

    
end

function UISelectNew:initTouch( )
    
    local  listener = cc.EventListenerTouchOneByOne:create()
    
    local touchNode = cc.Node:create()
    self:addChild(touchNode)

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self.touchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self.touchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self,self.touchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
end

function UISelectNew:onExit()
    
    global.isCreating = nil
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    for i,v in pairs(self.soldiers) do
        if v.m_TipsControl then 
            v.m_TipsControl:ClearEventListener()
        end 
    end
end

function UISelectNew:checkSide(isInit)
    
    if not self.isMove then

        self.dt.x = self.dt.x * 0.95
        self:dealMove(self.dt,isInit)
    end
end

function UISelectNew:touchBegan(touch,event)

    self.isMove = true
    self.dt = cc.p(0,0)
    return true
end

function UISelectNew:touchMoved(touch,event)
    
    local up = 30
    local btn = 30

    local nodePos = self.portrait_control:convertTouchToNodeSpace(touch)
    if nodePos.x < 0 or nodePos.y < 0 or nodePos.x > self.portrait_control:getContentSize().width or nodePos.y > self.portrait_control:getContentSize().height then

        return
    end

    local dt = touch:getDelta()
    self.dt = dt
    self:dealMove(dt)
end

function UISelectNew:dealMove(dt,isInit)
    local min = 998
    local minTag = nil
    for _,v in ipairs(self.soldiers) do

        local cx = v:getPositionX() + dt.x
        if cx < 117 then
            
            cx = 614 - (117 - cx)
        end
        
        if cx > 614 then

            cx = 117 + (cx - 614)
        end

        local xpen = math.abs(cx - 360) / (360 - 122)
        v:setPositionY((xpen * xpen * 3 + 2 * xpen) * 5)
        v:setPositionX(cx)
        v:setLocalZOrder(-v:getPositionY())
        v.shadow_export:setVisible(true)

        if v:getPositionY() < min then

            min = v:getPositionY()
            minTag = v
        end
    end

    if self.lastMiniTag ~= minTag and not isInit then
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_slide")
    end

    minTag.shadow_export:setVisible(false)
    self.lastMiniTag = minTag
end

function UISelectNew:touchEnded(touch,event)
   
    local nodePos = self.portrait_control:convertTouchToNodeSpace(touch)
    if nodePos.x < 0 or nodePos.y < 0 or nodePos.x > self.portrait_control:getContentSize().width or nodePos.y > self.portrait_control:getContentSize().height then

        self.dt = cc.p(0,0)
    end

    self.isMove = false 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISelectNew:setCallBack(call)
    
    self.callback = call
end

function UISelectNew:setRandName()
    global.loginApi:getRandName(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            self.name = msg.szRandName
        end
    end)
end

function UISelectNew:start_game(sender, eventType)
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_login_2")
    global.userData:setUserName(self.name)

    if global.isCreating then return end
    global.isCreating = true

    global.loginApi:createRole(self.race_id, function(ret,msg)
        -- body
        if self.callback then 
            self.callback(msg)
        end 
    end)
end

function UISelectNew:start1_game(sender, eventType)
    -- 魔晶
    if not self.m_enough then
        global.tipsMgr:showWarning("ItemUseDiamond")
        return 
    end
    if global.userData:getRace() == self.race_id then
        return global.tipsMgr:showWarning("Transfer01")
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("Transfer02", function ()
        global.loginApi:turnRole(self.race_id, function(ret,msg)
            -- body
            if self.callback then 
                self.callback(msg)
            end 
        end)
    end,self.race_name:getString())
end
--CALLBACKS_FUNCS_END

return UISelectNew

--endregion
