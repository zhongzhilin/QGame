--region UIDeviceNumPanel.lua
--Author : yyt
--Date   : 2016/10/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame
local userData = global.userData
local propData = global.propData
local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIDeviceNumPanel  = class("UIDeviceNumPanel", function() return gdisplay.newWidget() end )

function UIDeviceNumPanel:ctor()
    self:CreateUI()
end

function UIDeviceNumPanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_second_build")
    self:initUI(root)
end

function UIDeviceNumPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_second_build")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.fac_name = self.root.Node_export.title.fac_name_export
    self.portrait_view = self.root.Node_export.portrait_view_export
    self.portrait_node = self.root.Node_export.portrait_view_export.portrait_node_export
    self.popu_num = self.root.Node_export.popu_num_export
    self.soldier_des = self.root.Node_export.soldier_des_export
    self.gold_num = self.root.Node_export.gold_num_export
    self.wood_num = self.root.Node_export.wood_num_export
    self.food_num = self.root.Node_export.food_num_export
    self.stone_num = self.root.Node_export.stone_num_export
    self.space_num = self.root.Node_export.space_num_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.btn_cost = self.root.Node_export.btn_cost_export
    self.num = self.root.Node_export.btn_cost_export.num_export
    self.btn_train = self.root.Node_export.btn_train_export
    self.time = self.root.Node_export.btn_train_export.time_export

    uiMgr:addWidgetTouchHandler(self.btn_cost, function(sender, eventType) self:onCostHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_train, function(sender, eventType) self:onBuildHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.sliderUpdate))

    self:initTouch()

    self.m_totalTime = 0
    self.m_totalSpace = 0
    self.m_totalRes = {}
end

function UIDeviceNumPanel:initTouch()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(function()
        -- body
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(function()
        -- body
        self:onCloseHandler()
    end, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.Node)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDeviceNumPanel:setData(data)
    self.data = data

    self.spaceTotalNum = 500
    self.popu_num:setString(self.spaceTotalNum)
    self.fac_name:setString(data.name)
    self.soldier_des:setString(data.name)

    self.m_singleCostPop = data.basePara1
    local maxNum = math.floor(self.spaceTotalNum/self.m_singleCostPop)
    if maxNum <= 0 then
        self.sliderControl:reSetMaxCount(0)
    else
        self.sliderControl:setMaxCount(maxNum)
    end

    self:sliderUpdate()
end

function UIDeviceNumPanel:setCallBack(callback)
    self.m_callback = callback
end

function UIDeviceNumPanel:sliderUpdate()
    
    local currNum = self.sliderControl:getContentCount()
    self.m_totalSpace = self.m_singleCostPop*currNum
    self.space_num:setString(self.m_totalSpace)

    for id,name in ipairs(WCONST.ITEM.NAME) do
        local textNode = self[name.."_num"]
        if textNode then
            textNode:setString(0)
            self.m_totalRes[id] = num
        end
    end

    local can = true
    for k,v in ipairs(self.data.perCost) do
        local id = v[1]
        local num = v[2]*currNum
        local name = WCONST.ITEM.NAME[id]
        if name then
            local textNode = self[name.."_num"]
            if propData:checkEnough(id, num) then
                textNode:setTextColor(gdisplay.COLOR_TEXT_BROWN)
            else
                textNode:setTextColor(gdisplay.COLOR_RED)
                can = false
            end
            textNode:setString(num)

            self.m_totalRes[id] = num
        end
    end
    if self.m_totalSpace <= self.spaceTotalNum then
        self.space_num:setTextColor(gdisplay.COLOR_TEXT_BROWN)
    else
        self.space_num:setTextColor(gdisplay.COLOR_RED)
        can = false
    end
    if currNum <= 0 then
        can = false
    end

    self.m_totalTime = self.data.perTime*currNum
    local timeData = funcGame.formatTimeToHMS(self.m_totalTime)
    self.time:setString(timeData)
    self.num:setString(funcGame.getDiamondCount(self.m_totalTime))

    self.btn_cost:setEnabled(can)
    self.btn_train:setEnabled(can)  

end

function UIDeviceNumPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDeviceNumPanel")
end

function UIDeviceNumPanel:onCostHandler(sender, eventType)
    -- global.tipsMgr:showWarning("秒cd功能暂未开放")
    if self.m_totalSpace <= 0 then
        global.tipsMgr:showWarning("UIDeviceNumPanel")
        return
    end

    local diamondNum = tonumber(self.num:getString())
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, diamondNum) then
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end

    --　特效播放监听
    -- self:playAnimation()
    self:onCloseHandler()

    local data = {
        populationCost = self.m_totalSpace,
        resCost = self.m_totalRes,
        count = self.sliderControl:getContentCount(),
        lType = 1
    }
    self.m_callback(data)
end

function UIDeviceNumPanel:onBuildHandler(sender, eventType)
    
    if self.spaceTotalNum <= 0 then
        global.tipsMgr:showWarning("目前已没有城防空间!")
        return
    end
    self:onCloseHandler()

    local data = {
        populationCost = self.spaceTotalNum,
        resCost = self.m_totalRes,
        count = self.sliderControl:getContentCount(),
        lType = 0
    }
    self.m_callback(data)
end
--CALLBACKS_FUNCS_END

return UIDeviceNumPanel

--endregion
