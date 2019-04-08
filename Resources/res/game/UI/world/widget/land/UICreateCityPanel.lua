--region UICreateCityPanel.lua
--Author : untory
--Date   : 2017/01/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UICreateCityPoint = require("game.UI.world.widget.land.UICreateCityPoint")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UICreateCityPanel  = class("UICreateCityPanel", function() return gdisplay.newWidget() end )

function UICreateCityPanel:ctor()
    -- self:CreateUI()
    self:autoCreate()
end

function UICreateCityPanel:CreateUI()
    local root = resMgr:createWidget("world/mainland/world_city_create")
    self:initUI(root)
end

function UICreateCityPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/world_city_create")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.surt = self.root.Node_export.surt_export
    self.tf_Input = self.root.Node_export.name.tf_Input_export
    self.tf_Input = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Input, self.root.Node_export.name.tf_Input_export)
    self.light_1 = self.root.Node_export.light_1_export
    self.light_1 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_1, self.root.Node_export.light_1_export)
    self.light_2 = self.root.Node_export.light_2_export
    self.light_2 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_2, self.root.Node_export.light_2_export)
    self.light_3 = self.root.Node_export.light_3_export
    self.light_3 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_3, self.root.Node_export.light_3_export)
    self.light_4 = self.root.Node_export.light_4_export
    self.light_4 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_4, self.root.Node_export.light_4_export)
    self.checkCol_4 = self.root.Node_export.checkCol_4_export
    self.checkCol_3 = self.root.Node_export.checkCol_3_export
    self.checkCol_2 = self.root.Node_export.checkCol_2_export
    self.checkCol_1 = self.root.Node_export.checkCol_1_export
    self.changeName = self.root.Node_export.changeName_export
    self.guide = self.root.guide_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.surt, function(sender, eventType) self:sure_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.changeName, function(sender, eventType) self:changeName_call(sender, eventType) end)
--EXPORT_NODE_END

    local map_data = luaCfg:map_region()
    for i = 1,4 do

        self["light_"..i]:setData(map_data[i])
    end

    self:initTouch()
    -- self:chooseIndex(math.random(1,4))
    self:chooseIndex(math.random(1,4))
    -- self.changeName:setVisible(false)
    self:changeName_call()

    -- 改为点大地图按钮直接创建城堡，不需要手动输入名字和选择大陆
    self:setVisible(false)
    self:autoCreate()
end

function UICreateCityPanel:autoCreate()
    global.worldApi:createMapUser('auto-create', 1,function(msg)
        
        if global.guideMgr:isPlaying() then
            global.guideMgr:getHandler():autoSignGuide({isWait = true})
        end            

        global.userData:setWorldCityID(-1)
        global.userData:setUserName(msg.lCityName)
        global.panelMgr:closePanel("UICreateCityPanel")

        global.scMgr:gotoWorldSceneWithAnimation()            
    end)
end

function UICreateCityPanel:touchBegan(touch, event)
    
    return true
end

function UICreateCityPanel:touchMoved(touch, event)
    
end

function UICreateCityPanel:touchEnded(touch, event)
    
    for i = 1,4 do

        local clickableSprite = self["checkCol_"..i]    
        local openglLocation = touch:getLocation()
        
        -- clickableSprite:setVisible(false)

        CCHgame:isSpriteTouchByPix(function()
            if self.chooseIndex then -- protect 
                self:chooseIndex(i)
            end 
            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_ChooseMainland")
        end,openglLocation,clickableSprite)
    end    
end

function UICreateCityPanel:play()
    -- body

    self.root:stopAllActions()

    local nodeTimeLine = resMgr:createTimeline("world/mainland/world_city_create")
    -- nodeTimeLine:setLastFrameCallFunc(function()

    --     if msg == nil then return end
        
    -- end)
    nodeTimeLine:play("animation0", false)
    self.root:runAction(nodeTimeLine)
end

function UICreateCityPanel:chooseIndex(index)
    
    self.index = index

    for i = 1,4 do

        local clickableSprite = self["checkCol_"..i]    
        clickableSprite:setVisible(i == index)

    end
end

function UICreateCityPanel:initTouch()
    

    local  listener = cc.EventListenerTouchOneByOne:create()

    local touchNode = cc.Node:create()
    touchNode:setLocalZOrder(998)
    self:addChild(touchNode)

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self.touchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self.touchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self,self.touchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
    
end

function UICreateCityPanel:onEnter()

    -- 暂时屏蔽临时
    if true then return end

    self.guide:setVisible(false)
    for i = 1,4 do

        local clickableSprite = self["checkCol_"..i]    
        clickableSprite:stopAllActions()
        clickableSprite:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    end

    global.worldApi:queryLandsCanBeChoose(function(msg)
        
        msg.tagValidArea = msg.tagValidArea or {}

        local isCanBeChoose = false
        for _,v in ipairs(msg.tagValidArea) do

            if v == self.index then
                isCanBeChoose = true  
            end
        end

        if not isCanBeChoose and #msg.tagValidArea > 0 and self.chooseIndex then

            self:chooseIndex(msg.tagValidArea[math.random(1,#msg.tagValidArea)])
        end
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICreateCityPanel:rewardHandler(sender, eventType)

end

function UICreateCityPanel:sure_call(sender, eventType)

    local str = self.tf_Input:getString()    

    if self:checkNameStr(str) then
        
        global.worldApi:createMapUser(self.tf_Input:getString(), self.index,function(msg)
        
            if global.guideMgr:isPlaying() then
                global.guideMgr:getHandler():autoSignGuide({isWait = true})
            end            

            if tolua.isnull(self.tf_Input) then return end 
            global.userData:setWorldCityID(-1)
            global.userData:setUserName(self.tf_Input:getString())
            global.panelMgr:closePanel("UICreateCityPanel")

            global.scMgr:gotoWorldSceneWithAnimation()            
        end)
    end    
end

function UICreateCityPanel:exit_call(sender, eventType)

    global.panelMgr:closePanel("UICreateCityPanel")
end


function UICreateCityPanel:checkNameStr(str)

    if str == "" then
            
        global.tipsMgr:showWarningTime("CantEmpty")
        return false
    end
    
    local errcode, spaceNum = 0, 0
    local list = string.utf8ToList(str)
    for i=1,#list do
        
        if list[1] == " "  then
            errcode = -1
        end

        if list[i] == " " then
            spaceNum = spaceNum + 1
        end

        if list[#list] == " "  then
            errcode = 1
        end 
    end

    -- 不能全部为空格
    if spaceNum == #list then
        global.tipsMgr:showWarningTime("CantSpaceAll")
        return false
    end

    -- 首尾不能为空
    if errcode ~= 0 then
        global.tipsMgr:showWarningTime("CantSpace")
        return false
    end

    if string.isEmoji(str) then
        global.tipsMgr:showWarning("13")
        return false
    end

    return true
end

function UICreateCityPanel:changeName_call(sender, eventType)
    
    if sender then 

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_RandomName")
        self:play() 
    end

    global.loginApi:getRandName(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            local firstStr = luaCfg:get_rand_name_by(msg.lFirstName).text
            local secStr = luaCfg:get_rand_name_by(msg.lSecondName).text
            local addStr = ""
            if msg.lAddName then
                addStr = luaCfg:get_rand_name_by(msg.lAddName).text
            end
            -- local strName = string.format("%s %s %s",firstStr,secStr,addStr)
            -- if global.languageData:isCN() then
            --     strName = string.format("%s%s%s",firstStr,secStr,addStr)
            -- end
            local strName = string.format("%s%s%s",firstStr,secStr,addStr)
            if not tolua.isnull(self.tf_Input) then 
                self.tf_Input:setString(strName)
            end 
        end
    end)
end
--CALLBACKS_FUNCS_END

return UICreateCityPanel

--endregion
