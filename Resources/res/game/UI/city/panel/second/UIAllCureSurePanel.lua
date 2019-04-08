--region UIAllCureSurePanel.lua
--Author : wuwx
--Date   : 2016/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAllCureSurePanel  = class("UIAllCureSurePanel", function() return gdisplay.newWidget() end )

function UIAllCureSurePanel:ctor()
    self:CreateUI()
end

function UIAllCureSurePanel:CreateUI()
    local root = resMgr:createWidget("hospital/all_heal_sec_bg")
    self:initUI(root)
end

function UIAllCureSurePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/all_heal_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.dia_num = self.root.Node_export.dia_heal_btn.dia_num_export
    self.free_btn = self.root.Node_export.free_btn_export
    self.free_btn_text = self.root.Node_export.free_btn_export.free_btn_text_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.dia_heal_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end)
--EXPORT_NODE_END
    self:initTouch()
    self.free_btn_text:setString(gls(10390))
end

function UIAllCureSurePanel:initTouch()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        -- body
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        self:onCloseHandler()
    end, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.touch)
end

function UIAllCureSurePanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIAllCureSurePanel")
end

function UIAllCureSurePanel:onEnter()
    self:addEventListener(global.gameEvent.EV_ON_SOLDIER_CURE_BUFF,function ()
        -- body
        if self.setData then
            self:setData(self.data, self.m_overCall)
        end
    end)

    self.free_btn:setVisible(false)
end

function UIAllCureSurePanel:setData(data,callback)
    self.data = data 
    self.m_overCall = callback

    self.healTotalCost = 0

    for i,v in pairs(data) do
        local soldierProData = luaCfg:get_soldier_property_by(v.lID)
        self.healTotalCost = self.healTotalCost+soldierProData.healCost*v.num
    end
    local baseCost = math.ceil(self.healTotalCost)
    -- buff加成
    local cureBuff = global.panelMgr:getPanel("UIHpPanel"):getCureBuff()
    baseCost = baseCost - math.floor(baseCost*cureBuff/100)
    self.dia_num:setString(baseCost)
    
    local propData = global.propData
    propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, self.healTotalCost, self.dia_num)

    -- [LUA-print] true        global.guideMgr:isPlaying()
    -- [LUA-print]  ==========> curStep:1001
    -- [LUA-print]  ==========> stepGuide:10006

    print(global.guideMgr:isPlaying() ,"global.guideMgr:isPlaying()")
    if(global.guideMgr:isPlaying()) then 
        local curStep = global.userData:getGuideStep()
        local stepGuide = global.guideMgr:getCurStep()
        print(curStep , "curStep")
        print(stepGuide , "stepGuide")
        if stepGuide == 10006 then 
            self.free_btn:setVisible(true)
        end 
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAllCureSurePanel:onCureHandler(sender, eventType)

    local lType = 2 --魔金全部治疗
    local request = function (type_)
         global.cityApi:healSoldier(function(msg)
            -- body
            --扣除资源消耗
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
            global.tipsMgr:showWarning(luaCfg:get_local_string(10222))
            if self.onCloseHandler then 
                self:onCloseHandler()
            end 
            if self.m_overCall then self.m_overCall() end
        end, type_)
    end 

    if sender and sender == self.free_btn then 
        lType = 1 
        request(lType)
    else 
        if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,tonumber(self.healTotalCost)) then
            request(lType)
        end
    end 

end
--CALLBACKS_FUNCS_END

return UIAllCureSurePanel

--endregion
