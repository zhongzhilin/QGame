--region UIGuideBGPanel.lua
--Author : untory
--Date   : 2017/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGuideBGPanel  = class("UIGuideBGPanel", function() return gdisplay.newWidget() end )

function UIGuideBGPanel:ctor()
    self:CreateUI()
end

function UIGuideBGPanel:CreateUI()
    local root = resMgr:createWidget("world/director/UIGuideBg")
    self:initUI(root)
end

function UIGuideBGPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/director/UIGuideBg")   

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.des = self.root.des_export
    self.title = self.root.title_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIGuideBGPanel:setData(data)
    
    -- local npcKey = global.panelMgr:getPanel("UINPCPanel"):getPreSoundKey()
    -- if npcKey then        
    --     gsound.stopEffect(npcKey)
    -- end

    local time = data.time or 5
    local desDelayTime = 1
    self.data = data
    self.isSkiped = false

    self.isCanTouch = false
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        self.isCanTouch = true
        
        if self.data.isFadeIn then
            self.root:stopAllActions()
            local timeline = resMgr:createTimeline("world/director/UIGuideBg")    
            self.root:runAction(timeline)   
            timeline:play("animation0",true) 
        end
    end)))

    if not data.isFadeIn then desDelayTime = 0 end

    if type(data.des) == "number" then

        self.des:setString("    " .. global.luaCfg:get_local_string(data.des))
    else
        
        self.des:setString(data.des)
    end     

    if type(data.title) == "number" then

        self.title:setString(global.luaCfg:get_local_string(data.title))
    else
        
        self.title:setString(data.title)
    end

    if data.isFadeIn then

        self.root:setOpacity(0)
        self.root:runAction(cc.FadeIn:create(1))
    else

        self.root:setOpacity(255)                
    end   

    self.title:setOpacity(0) 
    self.title:runAction(cc.Sequence:create(cc.DelayTime:create(desDelayTime),cc.FadeIn:create(1),cc.DelayTime:create(time),cc.FadeOut:create(1)))

    self.des:setOpacity(0)
    self.des:runAction(cc.Sequence:create(cc.DelayTime:create(desDelayTime),cc.FadeIn:create(1),cc.DelayTime:create(time),cc.FadeOut:create(1),cc.CallFunc:create(function()
    
        self.root:runAction(cc.Sequence:create(cc.FadeOut:create(1),cc.CallFunc:create(function()
            
            global.panelMgr:closePanel("UIGuideBGPanel")
        end)))    
        
        if not data.delay then
            global.guideMgr:dealScript()
        end        
    end))) 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGuideBGPanel:onCloseHandler(sender, eventType)

    if not self.isCanTouch then return end
    if not self.data.isFadeIn then return end

    if self.isSkiped then return end
    
    self.isSkiped = true

    global.guideMgr:stop()
    global.commonApi:setGuideStep(global.guideMgr:getCurStep(),function()
        
        -- global.guideMgr:cleanCache()
        -- global.guideMgr.isInScript = false

        global.scMgr:gotoMainSceneWithAnimation()    
        global.guideMgr:setTaskEvent(global.gameEvent.EV_ON_ENTER_MAIN_SCENE)
    end)
    
end
--CALLBACKS_FUNCS_END

return UIGuideBGPanel

--endregion
