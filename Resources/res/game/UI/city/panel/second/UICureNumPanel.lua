--region UICureNumPanel.lua
--Author : wuwx
--Date   : 2016/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local CountSliderControl = require("game.UI.common.UICountSliderControl")

local UICureNumPanel  = class("UICureNumPanel", function() return gdisplay.newWidget() end )

function UICureNumPanel:ctor()
    self:CreateUI()
end

function UICureNumPanel:CreateUI()
    local root = resMgr:createWidget("hospital/heal_sec_bg")
    self:initUI(root)
end

function UICureNumPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/heal_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.portrait_node = self.root.Node_export.icon_bg.portrait_node_export
    self.soldier_name = self.root.Node_export.soldier_name_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.cur)
    self.dia_icon = self.root.Node_export.dia_heal_btn.dia_icon_export
    self.dia_num = self.root.Node_export.dia_heal_btn.dia_num_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.dia_heal_btn, function(sender, eventType) self:onCureHandler(sender, eventType) end)
--EXPORT_NODE_END
    self:initTouch()

    self.Node.cur = self.cur
    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    self.sliderControl = CountSliderControl.new(self.Node, handler(self,self.numChange) , true)
end

function UICureNumPanel:initTouch()
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

function UICureNumPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UICureNumPanel")
end

function UICureNumPanel:onEnter()
    self:addEventListener(global.gameEvent.EV_ON_SOLDIER_CURE_BUFF,function ()
        -- body
        if self.numChange then
            self:numChange(self.sliderControl:getContentCount())
        end
    end)
end

function UICureNumPanel:setData(data,callback)
    self.data = data 
    self.m_overCall = callback

    local soldierProData = luaCfg:get_soldier_property_by(data.lID)

    local str = global.luaCfg:get_local_string(10866 , soldierProData.name)

    self.soldier_name:setString(str.."?")

    self.healCost = soldierProData.healCost

    self.sliderControl:setMaxCount(data.num)

    local soldierData = luaCfg:get_soldier_train_by(data.lID)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)
end

function UICureNumPanel:numChange(contentNum)
    local num = math.ceil(self.healCost*contentNum)
    local propData = global.propData
    -- buff加成
    local cureBuff = global.panelMgr:getPanel("UIHpPanel"):getCureBuff()
    num = num - math.floor(num*cureBuff/100)
    self.dia_num:setString(num)
    propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, num, self.dia_num)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICureNumPanel:onCureHandler(sender, eventType)
    local lType = 0 --单体治疗
    local lSID = self.data.lID
    local lCount = self.sliderControl:getContentCount()

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,tonumber(self.dia_num:getString())) then
        global.cityApi:healSoldier(function(msg)
            -- body
            --扣除资源消耗
            if tolua.isnull(self) then return end  
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
            local soldierProData = luaCfg:get_soldier_property_by(self.data.lID)
            global.tipsMgr:showWarning(luaCfg:get_local_string(10224,soldierProData.name,lCount))
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click_13")--音效添加（张亮）
            self:onCloseHandler()
            if self.m_overCall then self.m_overCall() end
        end, lType, lSID, lCount)
    end
end
--CALLBACKS_FUNCS_END

return UICureNumPanel

--endregion
