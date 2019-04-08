--region UIChooseLand.lua
--Author : untory
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UICreateCityPoint = require("game.UI.world.widget.land.UICreateCityPoint")
--REQUIRE_CLASS_END

local UIChooseLand  = class("UIChooseLand", function() return gdisplay.newWidget() end )

function UIChooseLand:ctor()
    self:CreateUI()
end

function UIChooseLand:CreateUI()
    local root = resMgr:createWidget("world/mainland/fly_mainland")
    self:initUI(root)
end

function UIChooseLand:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/fly_mainland")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.light_4 = self.root.Node_export.light_4_export
    self.light_4 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_4, self.root.Node_export.light_4_export)
    self.light_3 = self.root.Node_export.light_3_export
    self.light_3 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_3, self.root.Node_export.light_3_export)
    self.light_2 = self.root.Node_export.light_2_export
    self.light_2 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_2, self.root.Node_export.light_2_export)
    self.light_1 = self.root.Node_export.light_1_export
    self.light_1 = UICreateCityPoint.new()
    uiMgr:configNestClass(self.light_1, self.root.Node_export.light_1_export)
    self.checkCol_4 = self.root.Node_export.checkCol_4_export
    self.checkCol_3 = self.root.Node_export.checkCol_3_export
    self.checkCol_2 = self.root.Node_export.checkCol_2_export
    self.checkCol_1 = self.root.Node_export.checkCol_1_export
    self.name = self.root.Node_export.name_mlan_12_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
    local map_data = luaCfg:map_region()
    for i = 1,4 do

        self["light_"..i]:setData(map_data[i])
        self["checkCol_"..i]:setVisible(false)
    end

    self:initTouch()
end

function UIChooseLand:touchBegan(touch, event)
    
    for i = 1,4 do

        local clickableSprite = self["checkCol_"..i]    
        local openglLocation = touch:getLocation()
        
        -- clickableSprite:setVisible(false)

        clickableSprite:setVisible(false)

        CCHgame:isSpriteTouchByPix(function()
            
            clickableSprite:setVisible(true)
            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_ChooseMainland")
        end,openglLocation,clickableSprite)
    end    

    return true
end

function UIChooseLand:touchMoved(touch, event)
    
end

function UIChooseLand:touchEnded(touch, event)
    
    for i = 1,4 do

        local clickableSprite = self["checkCol_"..i]    
        local openglLocation = touch:getLocation()
        
        -- clickableSprite:setVisible(false)

        clickableSprite:setVisible(false)

        CCHgame:isSpriteTouchByPix(function()
            
            if self.isChoose == false then                

                if global.g_worldview.areaDataMgr.areaId == i then

                    global.tipsMgr:showWarning("PortMainland")
                else

                    global.panelMgr:closePanelForBtn("UIChooseLand")
                    global.panelMgr:openPanel("UIPassTroopPanel"):setLandIndex(i)

                    self.isChoose = true
                end                
            end
        end,openglLocation,clickableSprite)
    end    
end

function UIChooseLand:onEnter()
    
    self.isChoose = false
end

function UIChooseLand:initTouch()
    
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
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIChooseLand:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIChooseLand")
end
--CALLBACKS_FUNCS_END

return UIChooseLand

--endregion
