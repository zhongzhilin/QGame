--region UIRecruitNumPanel.lua
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

local UIRecruitNumPanel  = class("UIRecruitNumPanel", function() return gdisplay.newWidget() end )

function UIRecruitNumPanel:ctor()
    self:CreateUI()
end

function UIRecruitNumPanel:CreateUI()
    local root = resMgr:createWidget("hospital/recruit_sec_bg")
    self:initUI(root)
end

function UIRecruitNumPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/recruit_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.portrait_node = self.root.Node_export.icon_bg.portrait_node_export
    self.manpower_icon = self.root.Node_export.manpower_icon_export
    self.cost = self.root.Node_export.cost_export
    self.fuhao = self.root.Node_export.fuhao_export
    self.now = self.root.Node_export.now_export
    self.soldier_name = self.root.Node_export.soldier_name_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.cur)
    self.dia_icon = self.root.Node_export.dia_recruit_btn.dia_icon_export
    self.dia_num = self.root.Node_export.dia_recruit_btn.dia_num_export
    self.gold_num = self.root.Node_export.coin_recruit_btn.gold_num_export
    self.coin_icon = self.root.Node_export.coin_recruit_btn.coin_icon_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.dia_recruit_btn, function(sender, eventType) self:onRecruitRmbHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.coin_recruit_btn, function(sender, eventType) self:onRecruitGoldHandler(sender, eventType) end)
--EXPORT_NODE_END
    self:initTouch()

    self.Node.cur = self.cur
    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    self.sliderControl = CountSliderControl.new(self.Node, handler(self,self.numChange) , true)
end

function UIRecruitNumPanel:initTouch()
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

function UIRecruitNumPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIRecruitNumPanel")
end

function UIRecruitNumPanel:setData(data,callback)
    self.data = data 
    self.m_overCall = callback

    local soldierProData = luaCfg:get_soldier_property_by(data.lID)

    local str = global.luaCfg:get_local_string(10865 , soldierProData.name)
    self.soldier_name:setString(str.."?")

    self.recruitCoin = soldierProData.recruitCoin
    self.recruitDiamond = soldierProData.recruitDiamond
    self.populationCost = soldierProData.perPop

    self.sliderControl:setMaxCount(data.num)

    local soldierData = luaCfg:get_soldier_train_by(data.lID)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)

    self.now:setString(global.userData:getUsefulPopulation())
end

function UIRecruitNumPanel:numChange(contentNum)
    local num = self.recruitDiamond*contentNum
    local propData = global.propData
    self.dia_num:setString(math.ceil(num))
    propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, num, self.dia_num)

    local num = self.recruitCoin*contentNum
    self.gold_num:setString(num)
    propData:checkEnoughWithColor(WCONST.ITEM.TID.GOLD, num, self.gold_num)

    local num = self.populationCost*contentNum
    self.cost:setString(num)
    local userData = global.userData
    userData:checkPopuhWithColor(tonumber(num),self.cost)

    global.tools:adjustNodePos(self.cost,self.manpower_icon)
    global.tools:adjustNodePos(self.gold_num,self.coin_icon)
    global.tools:adjustNodePos(self.dia_num,self.dia_icon)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIRecruitNumPanel:onRecruitRmbHandler(sender, eventType)
    local lType = 4 --单体招募消耗钻石
    local lSID = self.data.lID
    local lCount = self.sliderControl:getContentCount()

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,tonumber(self.dia_num:getString())) then
        global.cityApi:healSoldier(function(msg)
            -- body
            global.soldierData:addSoldiersBy(msg.tgSoldiers)

            local soldierProData = luaCfg:get_soldier_property_by(self.data.lID)

            global.tipsMgr:showWarning(luaCfg:get_local_string(10225,soldierProData.name,lCount))
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click_13")--音效添加（张亮）
            self:onCloseHandler()
            if self.m_overCall then self.m_overCall() end
        end, lType, lSID, lCount)
    end
end

function UIRecruitNumPanel:onRecruitGoldHandler(sender, eventType)
    local lType = 3 --单体招募消耗金币
    local lSID = self.data.lID
    local lCount = self.sliderControl:getContentCount()

    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.GOLD,tonumber(self.gold_num:getString())) then
        global.cityApi:healSoldier(function(msg)
            -- body
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
            if self.data then 
                local soldierProData = luaCfg:get_soldier_property_by(self.data.lID)
                global.tipsMgr:showWarning(luaCfg:get_local_string(10225,soldierProData.name,lCount))
            end
            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click_13")--音效添加（张亮）
            self:onCloseHandler()
            if self.m_overCall then self.m_overCall() end
        end, lType, lSID, lCount)
    end
end
--CALLBACKS_FUNCS_END

return UIRecruitNumPanel

--endregion
