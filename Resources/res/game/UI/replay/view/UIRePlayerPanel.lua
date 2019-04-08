--region UIRePlayerPanel.lua
--Author : anlitop
--Date   : 2017/06/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END
local UIwin = require("game.UI.replay.view.UIwin")
local UIfail = require("game.UI.replay.view.UIfail")
local pvpMainControl  =require("game.UI.replay.control.pvpMainControl")

local Player  =require("game.UI.replay.excute.Player")
local eventControl  =require("game.UI.replay.excute.eventControl")


local localFileManger  =require("game.UI.replay.excute.localFileManger")

local UIRePlayerPanel  = class("UIRePlayerPanel", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")


function UIRePlayerPanel:ctor()
    self:CreateUI()
end 

function UIRePlayerPanel:CreateUI()
    local root = resMgr:createWidget("player/player_bj")
    self:initUI(root)
end

function UIRePlayerPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/player_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.silder_ps = self.root.ScrollView_1.silder_ps_export
    self.result_ps = self.root.ScrollView_1.result_ps_export
    self.top_bg = self.root.ScrollView_1.node.up.top_bg_export
    self.top_troop_bg = self.root.ScrollView_1.node.up.top_troop_bg_export
    self.bot_bg = self.root.ScrollView_1.node.dowm.bot_bg_export
    self.bot_troop_bg = self.root.ScrollView_1.node.dowm.bot_troop_bg_export
    self.pk = self.root.ScrollView_1.node.pk_export
    self.top_ps = self.root.ScrollView_1.node.top_ps_export
    self.bottom_ps = self.root.ScrollView_1.node.bottom_ps_export
    self.center_ps = self.root.ScrollView_1.node.center_ps_export
    self.top_black_mode = self.root.ScrollView_1.top_black_mode_export
    self.top_result_ps = self.root.ScrollView_1.top_result_ps_export
    self.ps_node = self.root.ScrollView_1.ps_node_export
    self.bottom_black_mode = self.root.ScrollView_1.bottom_black_mode_export
    self.bottom_result_ps = self.root.ScrollView_1.bottom_result_ps_export
    self.mode = self.root.mode_export
    self.layout = self.root.layout_export
    self.close_node = self.root.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.close_node_export)

    uiMgr:addWidgetTouchHandler(self.mode, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
        
    self.close_node:setData(function()
        self:exitPanel()   
    end)
    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)

    self.ScrollView = self.root.ScrollView_1 

    self:adapt()
end


function UIRePlayerPanel:adapt()

    local sHeight = gdisplay.height
    local defY = self.ScrollView:getContentSize().height
    self.ScrollView:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 


    else
        self.ScrollView:setTouchEnabled(false)

        self.ScrollView:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.ScrollView:getContentSize().height /2 - self.ps_node:getPositionY()
        for _ ,v in pairs(self.ScrollView:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end

        -- local height  = self.bot_bg:convertToWorldSpace((cc.p(0,0))).y

        local height  = self.ScrollView:getContentSize().height / 2 - 330

        if self.top_bg:getContentSize().height < height then 

            self.top_bg:setContentSize(cc.size(self.top_bg:getContentSize().width , height+3))
            self.top_black_mode:setContentSize(self.top_bg:getContentSize())
        end 

        if self.bot_bg:getContentSize().height < height then 

            self.bot_bg:setContentSize(cc.size(self.bot_bg:getContentSize().width , height))
            self.bottom_black_mode:setContentSize(self.bot_bg:getContentSize())

        end 

        local height  = self.ScrollView:getContentSize().height /2 - self.layout:getContentSize().height
        if self.bot_troop_bg:getContentSize().height < height then 
            self.bot_troop_bg:setContentSize(cc.size(self.bot_troop_bg:getContentSize().width , height))
        end 
        if self.top_troop_bg:getContentSize().height < height then 
            self.top_troop_bg:setContentSize(cc.size(self.top_troop_bg:getContentSize().width , height))
        end 

        -- self.close_node:setPosition(cc.size(gdisplay.width*95/100, gdisplay.height * 98 /100))

    end 
end 

function UIRePlayerPanel:exitPanel()
     Player.getInstance():stop()
    global.panelMgr:closePanel("UIRePlayerPanel")
end 

function UIRePlayerPanel:onEnter()
    self.mode:setTouchEnabled(false)
    self.top_black_mode:setVisible(false)
    self.bottom_black_mode:setVisible(false)
    self.ScrollView:jumpToTop()

    -- global.colorUtils.turnGray(self.Sprite, true)
    -- self.Sprite:setVisible(false)
    -- gscheduler.performWithDelayGlobal(function()
    --     print("播放了////////")
    --     local nodeTimeLine =global.resMgr:createTimeline("player/player_bj")
    --     self.root:runAction(nodeTimeLine)
    --     nodeTimeLine:play("animation0",false)
    -- end, 3)

    -- gDebugPanel.onOffDump()
    
end 


function UIRePlayerPanel:initTouch()
    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)

end

function UIRePlayerPanel:onTouchBegan(touch, event)
    local beganPoint = touch:getLocation()
    self.begin_x = beganPoint.x 
    self.begin_y = beganPoint.y 
    return true
end 

function UIRePlayerPanel:onTouchEnded()
   self:hideTips()
end

function UIRePlayerPanel:onTouchCancel()
   self:hideTips()
end 

function UIRePlayerPanel:hideTips()
    for _ , v in pairs(self.tips_node:getChildren()) do 
        v:setVisible(false)
    end  
end 

function UIRePlayerPanel:onTouchMoved(touch, event)
    self.movetouch = touch:getLocation()
    local y =  math.abs((self.begin_y - self.movetouch.y)) > 15
    local x =  math.abs((self.begin_x - self.movetouch.x)) > 15
    if( y  or  x )then 
        self:hideTips()
    end 
end 

function UIRePlayerPanel:initListenner()

    self.listener = cc.EventListenerCustom:create("WARDATA_FILEWRITE_SUCCESS",function() 
        print("文件下载成功/////////////////////")
        self.localfile:get_local_data(tostring(self.war_id) ,self)

    end)
   self. listener1=  cc.EventListenerCustom:create("WARDATA_DOWNLORD_ERROR",function() 
        print("下载出错/////////////////////")
        global.tipsMgr:showWarning("download  error")

         self.localfile:deleteFileByWarId(self.war_id)
    end)

     self.listener2 =  cc.EventListenerCustom:create("WARDATA_DOWNLORD_SUCCESS",function() 
        print("数据下载成功////////////////////")
        self.localfile:downloradWarData(tostring(self.war_id) ,self)
    end)

    self.listener3=  cc.EventListenerCustom:create("WARDATA_DOWNLORDING",function(prent) 
        dump(tonumber(prent), "数据下载中。")
    end)



    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self)

    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener1,self)


    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener2,self)


    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener3,self)


end 


function UIRePlayerPanel:onExit()
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener1)
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener2)
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener3)

    self.victory_effect = nil 
    self.faile_effect =  nil 

    gscheduler.sharedScheduler:setTimeScale(1)
end 

function UIRePlayerPanel:initPlayer()


    self.player = Player.getInstance()
    self.player:prepare(self.war_data)

    local pvpMainControl  =  pvpMainControl.new()
    pvpMainControl:setData(self)

    local eventControl = eventControl.new()
    eventControl:setData(self)

    self.player:start()
end 


function UIRePlayerPanel:setData(data)

    --war_id = "1500389365004000"

    if not data then return end 

    self.war_data= global.netRpc:packBodyForOuter(data)
    
    self:initPlayer()

end 


function UIRePlayerPanel:downlordData(war_id)
        
    if war_id then 

        self:initListenner()

        self.war_id = war_id

        self.localfile = localFileManger.getInstance() 

        self.localfile:downloradWarData(tostring(self.war_id),self)

    end 
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRePlayerPanel:repaly_pause(sender, eventType)

end

function UIRePlayerPanel:start(sender, eventType)
    
end

function UIRePlayerPanel:goon(sender, eventType)
    -- self.test:resume()
    -- self.player:resume()
     self.player:resume()

end

function UIRePlayerPanel:puash(sender, eventType)
    -- self.player:pause()
    -- self.test:pause()

     self.player:pause()
end

function UIRePlayerPanel:cleanclick(sender, eventType)

    self.player:stop()
end


function UIRePlayerPanel:showResult(result)

    self.victory_effect = UIwin.new()
    self.faile_effect = UIfail.new()
    -- self:addChild(self.victory_effect)
    -- self:addChild( self.faile_effect)
    
    if result == 1 then 
        -- self.victory_effect:setPosition(self.top_result_ps:getPosition())
        self.top_result_ps:addChild(  self.victory_effect)
        self.bottom_result_ps:addChild(  self.faile_effect)
        -- self.faile_effect:setPosition(self.bottom_result_ps:getPosition())
    else 
        -- self.faile_effect:setPosition(self.top_result_ps:getPosition())
        -- self.victory_effect:setPosition(self.bottom_result_ps:getPosition())

        self.top_result_ps:addChild(  self.faile_effect)
        self.bottom_result_ps:addChild(  self.victory_effect)
    end 

    self.victory_effect:showAction()

    self.faile_effect:showAction()

    self.top_black_mode:setVisible(true)
    self.bottom_black_mode:setVisible(true)

    gscheduler.performWithDelayGlobal(function()
        self.mode:setTouchEnabled(true)
    end,0.3)
end


function UIRePlayerPanel:showTest()
    actionManger.getInstance():createTimeline(self.root ,"main" , true , true)
end 

function UIRePlayerPanel:exit_call(sender, eventType)
    self:exitPanel()
end
--CALLBACKS_FUNCS_END

return UIRePlayerPanel

--endregion
