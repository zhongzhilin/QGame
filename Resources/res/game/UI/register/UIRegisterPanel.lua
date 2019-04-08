--region UIRegisterPanel.lua
--Author : yyt
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRegisterItem = require("game.UI.register.UIRegisterItem")
--REQUIRE_CLASS_END

local UIRegisterPanel  = class("UIRegisterPanel", function() return gdisplay.newWidget() end )
local UIRegisterItem = require("game.UI.register.UIRegisterItem")
local UIBagItem =  require("game.UI.bag.UIBagItem")

function UIRegisterPanel:ctor()
    self:CreateUI()
end

function UIRegisterPanel:CreateUI()
    local root = resMgr:createWidget("register/register_bg")
    self:initUI(root)
end

function UIRegisterPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "register/register_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.itemLayout = self.root.Node_export.itemLayout_export
    self.bg = self.root.Node_export.bg_export
    self.registerText = self.root.Node_export.bg_export.registerText_export
    self.getRewardBtn = self.root.Node_export.bg_export.getRewardBtn_export
    self.itemNode = self.root.Node_export.bg_export.itemNode_export
    self.FileNode_3 = UIRegisterItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.bg_export.itemNode_export.FileNode_3)
    self.TipLayout = self.root.Node_export.bg_export.TipLayout_export
    self.bgLayout = self.root.Node_export.bgLayout_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.bg_export.intro_btn, function(sender, eventType) self:info_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.getRewardBtn, function(sender, eventType) self:getRewardHandler(sender, eventType) end)
--EXPORT_NODE_END
   

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN 

function UIRegisterPanel:onEnter()

    -- 蜡烛特效
    local nodeTimeLine = resMgr:createTimeline("register/register_bg")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self.TipLayout:setVisible(false)

    -- 签到刷新
    self:addEventListener(global.gameEvent.EV_ON_DAILY_REGISTER,function ()
        self:refershData(global.dailyTaskData:getTagSignInfo())
    end) 

    global.advertisementData:setIsFirstOnEnter(false)
end

function UIRegisterPanel:refershData(data)
    
    self.data = data
    self:setRewardBtn(data)
    for i=1,7 do
        local rewardData = luaCfg:get_register_reward_by(data.lSignID)
        self.itemTable[i].sinTimes = data.lSignCnt
        self.itemTable[i]:setData(rewardData["item"..i], i)
    end
    self:refershGuideText()
end


function UIRegisterPanel:setData(data)

    self.itemPos = {}
    self.itemTable = {}
    self.itemNode:removeAllChildren()
    if not data then return end

    self.data = data
    self:setRewardBtn(data)
    self:initItem(data)
    self:refershGuideText()
end

function UIRegisterPanel:setRewardBtn( data )
    
    -- 0 同一天表示已经领取
    if global.dailyTaskData:getCurDay(data.lLastSign) == 0 then
        self.getRewardBtn:setEnabled(false)
        self.isGetReward = true
    else
        self.getRewardBtn:setEnabled(true)
        self.isGetReward = false
    end
end 

function UIRegisterPanel:initItem(data)

    local itemSize = self.itemLayout:getContentSize()
    local bgSize = self.bgLayout:getContentSize()

    local spaceW = 5
    local pX1 = (bgSize.width - itemSize.width*4 - 3*spaceW)/2
    local pX2 = (bgSize.width - itemSize.width*3 - 2*spaceW)/2

    local rewardData = luaCfg:get_register_reward_by(data.lSignID) 

    for i=1,7 do
                
        local item = UIRegisterItem.new()
        item.sinTimes = data.lSignCnt
        item:setData(rewardData["item"..i], i, self.tips_node)
        item:setPosition(cc.p( pX1 + (i-1)*(itemSize.width+spaceW), 0 ))
        if i > 4 then
            item:setPosition( cc.p(pX2 + (i-5)*(itemSize.width+spaceW), -itemSize.height))
        end

        local tb={}
        tb.key = i
        local x, y = item:getPosition()
        tb.x = x
        tb.y = y
        table.insert(self.itemPos, tb)
        table.insert(self.itemTable, item)
        self.itemNode:addChild(item)

    end

end

-- 引导文本
function UIRegisterPanel:refershGuideText()

    if self.data.lSignID == 1 then
        uiMgr:setRichText(self, "registerText", 50123, {num=self.data.lSignCnt})
    else
        uiMgr:setRichText(self, "registerText", 50122, {num=self.data.lSignCnt})
    end
end

function UIRegisterPanel:getRewardHandler(sender, eventType)
   
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_sign")

    global.taskApi:getRegisterDaily(function(msg)
        
        global.uiMgr:addSceneModel(2)
        self:itemAnmation(msg.tgSign)
        global.dailyTaskData:setTagSignInfo(msg.tgSign)
        self:refershData(msg.tgSign)
    end)

end

function UIRegisterPanel:itemAnmation(msg) 

    local registerData = luaCfg:get_register_reward_by(msg.lSignID) 
    local itemData = registerData["item"..msg.lSignCnt]

    local id = itemData[2]
    local count = itemData[3]

    local pos = cc.p(0, 0)
    for _,v in pairs(self.itemPos) do
        if v.key == msg.lSignCnt then
            pos.x = v.x + 30
            pos.y = v.y + 30
        end
    end

    local itemUI = UIBagItem.new()
    itemUI:setData({id = id,count = count})
    itemUI:setPosition(self.itemNode:convertToWorldSpace(cc.p(pos.x, pos.y)))
    itemUI:setScale(0)
    self:addChild(itemUI)

    itemUI:runAction(cc.Sequence:create(cc.CallFunc:create(function ()
            
        itemUI:runAction(cc.ScaleTo:create(0.3,1))
        itemUI:runAction(cc.EaseIn:create(cc.MoveBy:create(0.3,cc.p(50, 50)),2))        
        
        itemUI:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function ()
            itemUI:runAction(cc.ScaleTo:create(0.5,0))
            itemUI:runAction(cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(169,26)),cc.CallFunc:create(function ()
               
                gevent:call(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY, 0)

            end), cc.DelayTime:create(0.5), cc.CallFunc:create(function ()
                
                gevent:call(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY, 1)

                local item = luaCfg:get_item_by(id) or luaCfg:get_equipment_by(id)
                global.tipsMgr:showWarning(luaCfg:get_local_string(10354, item.itemName or item.name, count))

            end) , cc.RemoveSelf:create(), cc.DelayTime:create(0), cc.CallFunc:create(function ()
                
                self:exit()
            end)))
        end)))              
    end)))

end

function UIRegisterPanel:exit(sender, eventType)

    global.panelMgr:closePanelForBtn("UIRegisterPanel")  
end

function UIRegisterPanel:info_click(sender, eventType)

    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    if self.data.lSignID == 1 then -- 新号签到
        infoPanel:setData(luaCfg:get_introduction_by(20))
    else
        infoPanel:setData(luaCfg:get_introduction_by(9))
    end
end

--CALLBACKS_FUNCS_END

return UIRegisterPanel

--endregion
