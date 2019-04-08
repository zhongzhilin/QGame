--region UIAllRecruitSurePanel.lua
--Author : wuwx
--Date   : 2016/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAllRecruitSurePanel  = class("UIAllRecruitSurePanel", function() return gdisplay.newWidget() end )

function UIAllRecruitSurePanel:ctor()
    self:CreateUI()
end

function UIAllRecruitSurePanel:CreateUI()
    local root = resMgr:createWidget("hospital/all_recruit_sec_bg")
    self:initUI(root)
end

function UIAllRecruitSurePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hospital/all_recruit_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.gold_num = self.root.Node_export.coin_recruit_btn.gold_num_export
    self.coin_icon = self.root.Node_export.coin_recruit_btn.coin_icon_export
    self.dia_icon = self.root.Node_export.dia_recruit_btn.dia_icon_export
    self.dia_num = self.root.Node_export.dia_recruit_btn.dia_num_export
    self.now = self.root.Node_export.now_export
    self.fuhao = self.root.Node_export.fuhao_export
    self.cost = self.root.Node_export.cost_export
    self.manpower_icon = self.root.Node_export.manpower_icon_export

    uiMgr:addWidgetTouchHandler(self.root.Node_export.coin_recruit_btn, function(sender, eventType) self:onRecruitGoldHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.dia_recruit_btn, function(sender, eventType) self:onRecruitRmbHandler(sender, eventType) end)
--EXPORT_NODE_END
    self:initTouch()
end

function UIAllRecruitSurePanel:initTouch()
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

function UIAllRecruitSurePanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIAllRecruitSurePanel")
end

function UIAllRecruitSurePanel:setData(data,callback)
    self.data = data 
    self.m_overCall = callback
    local userData = global.userData

    self.healTotalGoldCost = 0
    self.healTotalRMBCost = 0
    self.populationTotalCost = 0

    for i,v in pairs(data) do
        local soldierProData = luaCfg:get_soldier_property_by(v.lID)
        self.healTotalGoldCost = self.healTotalGoldCost+soldierProData.recruitCoin*v.num
        self.healTotalRMBCost = self.healTotalRMBCost+soldierProData.recruitDiamond*v.num
        self.populationTotalCost = self.populationTotalCost+soldierProData.perPop*v.num
    end
    self.gold_num:setString(self.healTotalGoldCost)
    self.dia_num:setString(math.ceil(self.healTotalRMBCost))
    self.cost:setString(self.populationTotalCost)
    self.now:setString(userData:getUsefulPopulation())

    local propData = global.propData
    propData:checkEnoughWithColor(WCONST.ITEM.TID.GOLD, self.healTotalGoldCost, self.gold_num)
    propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, self.healTotalRMBCost, self.dia_num)

    userData:checkPopuhWithColor(tonumber(self.populationTotalCost),self.cost)

    global.tools:adjustNodePos(self.cost,self.manpower_icon)
    global.tools:adjustNodePos(self.coin_icon,self.gold_num)
    global.tools:adjustNodePos(self.dia_num,self.dia_icon)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIAllRecruitSurePanel:onRecruitGoldHandler(sender, eventType)
    local lType = 5 --全体招募金币
    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.GOLD,tonumber(self.healTotalGoldCost)) then
        global.cityApi:healSoldier(function(msg)
            -- body
            --扣除资源消耗
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
            global.tipsMgr:showWarning(luaCfg:get_local_string(10223))

             gevent:call(gsound.EV_ON_PLAYSOUND,"city_click_13")--音效添加（张亮）
             if self.onCloseHandler then 
                self:onCloseHandler()
             end 
            if self.m_overCall then self.m_overCall() end
        end, lType)
    end
end

function UIAllRecruitSurePanel:onRecruitRmbHandler(sender, eventType)
    local lType = 6 --全体招募魔金
    if global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,tonumber(self.healTotalRMBCost)) then
        global.cityApi:healSoldier(function(msg)
            -- body
            --扣除资源消耗
            global.soldierData:addSoldiersBy(msg.tgSoldiers)
            global.tipsMgr:showWarning(luaCfg:get_local_string(10223))

            gevent:call(gsound.EV_ON_PLAYSOUND,"city_click_13")--音效添加（张亮）
            if self.onCloseHandler then 
                self:onCloseHandler()
            end 
            if self.m_overCall then self.m_overCall() end
        end, lType)
    end
end
--CALLBACKS_FUNCS_END

return UIAllRecruitSurePanel

--endregion
