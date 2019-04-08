--region UISpeedPanel.lua
--Author : yyt
--Date   : 2016/08/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local dailyTaskData = global.dailyTaskData
local luaCfg = global.luaCfg
local funcGame = global.funcGame
local propData = global.propData
local tipsMgr = global.tipsMgr
local normalItemData = global.normalItemData

local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UISpeedPanel  = class("UISpeedPanel", function() return gdisplay.newWidget() end )
local UIUseItem = require("game.UI.itemUse.UIUseItem")
local UIPromptPanel = require("game.UI.itemUse.UIPromptPanel")
local ItemQueueNode = require("game.UI.itemUse.node.ItemQueueNode")
local ItemQueueClear = require("game.UI.itemUse.node.ItemQueueClear")
local QueueUnlockNode = require("game.UI.itemUse.node.QueueUnlockNode")
local SoldierSpeedNode = require("game.UI.itemUse.node.SoldierSpeedNode")
local HeroGiftNode = require("game.UI.itemUse.node.HeroGiftNode")
local ResSpeedNode = require("game.UI.itemUse.node.ResSpeedNode")
local HeroExpNode = require("game.UI.itemUse.node.HeroExpNode")
local BuffAddNode = require("game.UI.itemUse.node.BuffAddNode")
local EquipRate = require("game.UI.itemUse.node.EquipRate")
local EquipBalance = require("game.UI.itemUse.node.EquipBalance")
local VIPAddPointNode = require("game.UI.itemUse.node.VIPAddPointNode")
local HeroAgeNode = require("game.UI.itemUse.node.HeroAgeNode")
local LordExpNode = require("game.UI.itemUse.node.LordExpNode")
local LordHPNode = require("game.UI.itemUse.node.LordHPNode")
local SoldierSourceNode = require("game.UI.itemUse.node.SoldierSourceNode")
local HeroExp = require("game.UI.itemUse.node.HeroExp")
local PetUseItemNode = require("game.UI.itemUse.node.PetUseItemNode")

function UISpeedPanel:ctor()
    self:CreateUI()
end

function UISpeedPanel:CreateUI()
    local root = resMgr:createWidget("bag/item_use1")
    self:initUI(root)
end

function UISpeedPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/item_use1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.txt_Title = self.root.Node_export.bg_export.txt_Title_export
    self.restTime_node = self.root.Node_export.bg_export.restTime_node_export
    self.text = self.root.Node_export.bg_export.restTime_node_export.text_mlan_12_export
    self.leftTime = self.root.Node_export.bg_export.restTime_node_export.leftTime_export
    self.usePanel = self.root.Node_export.Node_1.usePanel_export
    self.icon = self.root.Node_export.Node_1.usePanel_export.icon_export
    self.itemDes = self.root.Node_export.Node_1.usePanel_export.itemDes_export
    self.slider = self.root.Node_export.Node_1.usePanel_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.Node_1.usePanel_export.slider_export.cur)
    self.speedTime_node = self.root.Node_export.Node_1.usePanel_export.speedTime_node_export
    self.speedUseText = self.root.Node_export.Node_1.usePanel_export.speedTime_node_export.speedUseText_mlan_5_export
    self.speedTime = self.root.Node_export.Node_1.usePanel_export.speedTime_node_export.speedTime_export
    self.mojing_node = self.root.Node_export.Node_1.usePanel_export.mojing_node_export
    self.textHead = self.root.Node_export.Node_1.usePanel_export.mojing_node_export.textHead_mlan_4_export
    self.need = self.root.Node_export.Node_1.usePanel_export.mojing_node_export.need_export
    self.textEnd = self.root.Node_export.Node_1.usePanel_export.mojing_node_export.textEnd_export
    self.LabelLen = self.root.Node_export.Node_1.usePanel_export.mojing_node_export.LabelLen_export
    self.btnUse = self.root.Node_export.Node_1.usePanel_export.btnUse_export
    self.btnAddItem = self.root.Node_export.Node_1.usePanel_export.btnAddItem_export
    self.bt_select_all = self.root.Node_export.Node_1.usePanel_export.bt_select_all_export
    self.itemPanel = self.root.Node_export.Node_1.itemPanel_export
    self.timeline_node = self.root.Node_export.Node_1.itemPanel_export.timeline_node_export
    self.LoadingBar = self.root.Node_export.Node_1.itemPanel_export.timeline_node_export.LoadingBar_export
    self.txt_leftTime = self.root.Node_export.Node_1.itemPanel_export.timeline_node_export.txt_leftTime_export
    self.queueUnlock_node = self.root.Node_export.Node_1.itemPanel_export.queueUnlock_node_export
    self.Panel_2 = self.root.Node_export.Node_1.itemPanel_export.Panel_2_export
    self.scrollviewPanel = self.root.Node_export.Node_1.itemPanel_export.scrollviewPanel_export
    self.leftBtn = self.root.Node_export.Node_1.itemPanel_export.leftBtn_export
    self.rightBtn = self.root.Node_export.Node_1.itemPanel_export.rightBtn_export
    self.spaceNum = self.root.Node_export.Node_1.spaceNum_export
    self.topModel = self.root.topModel_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnUse, function(sender, eventType) self:useItem_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnAddItem, function(sender, eventType) self:addItem_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.bt_select_all, function(sender, eventType) self:select_all(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:left_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:right_click(sender, eventType) end)
--EXPORT_NODE_END
    
    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider, handler(self,  self.changCountCallBack) , true) 
    self.textLeftTimeMlan = self.timeline_node.txt_leftTime_mlan_7

    self.scrollviewPanelNode = cc.Node:create()
    self.scrollviewPanel:addChild(self.scrollviewPanelNode)

    self.itemSwitch = {}
    self.curItemTag = 0
    self.itemNum = 0
  
    self:initEventListener()
    self:registerTouchListener()
   
    -- 道具类型
    self.TYPE_QUEUE_SPEED       = 0         --队列加速
    self.TYPE_RES_SPEED         = 1         --资源加速
    self.TYPE_QUEUE_UNLOCK      = 2         --队列解锁
    self.TYPE_SOLDIER_TRAIN     = 3         --训练士兵加速
    self.TYPE_WALK_SPEED        = 4         --行军加速
    self.TYPE_HERO_GIFT         = 5         --行军加速
    self.TYPE_HERO_EXP          = 6         --英雄经验
    self.TYPE_TECH_SPEED        = 7         --科技加速
    self.TYPE_BUFF_ADD          = 8         --增益
    self.TYPE_EQUIP_BALANCE     = 9         --强化保底
    self.TYPE_EQUIP_RATE        = 10        --强化概率
    self.TYP_VIPAddPoint        = 11        --VIP激活
    self.TYP_VIPActivation      = 12        --VIP点数
    self.TYPE_HERO_AGE          = 13        --英雄寿命
    self.TYPE_LORD_EXP          = 14        --领主exp
    self.TYPE_LORD_HP           = 15        --领主HP
    self.TYPE_SOLDIER_SOURCE    = 16        --增加兵源
    self.TYPE_HERO_EXP_BATCH    = 17        --英雄经验
    self.TYPE_PET_ITEM          = 18        --神兽道具喂养

    self.itemTypeList = {
        [0]  = {itemId={102, 6, 109, 210}, titleId=10028, },     
        [1]  = {itemId={6, 103, }, titleId=10037, },     
        [2]  = {itemId={13311, 118, }, titleId=10029, idIdx = {1} },--idIdx = {1}表示第一个参数是item id 不是类型-》针对第三队列周卡特殊处理
        [3]  = {itemId={102, 6, 108, }, titleId=10028, },     
        [4]  = {itemId={112, },    titleId=10028, }, 
        [5]  = {itemId={138},    titleId=10338, }, 
        [6]  = {itemId={128},    titleId=10414, }, 
        [7]  = {itemId={102, 6, 111, }, titleId=10417, },
        [8]  = {itemId={300,121}, titleId=10414, },        
        [9]  = {itemId={204,}, titleId=10430, },
        [10]  = {itemId={205,}, titleId=10431, },
        [11]  = {itemId={206}, titleId=20703, },
        [12]  = {itemId={207}, titleId=20703, },
        [13]  = {itemId={131}, titleId=10466, },
        [14]  = {itemId={106}, titleId=10689, },
        [15]  = {itemId={132}, titleId=10695, },
        [16]  = {itemId={134}, titleId=10904, },
        [17]  = {itemId={135}, titleId=10987, },
        [18]  = {itemId={136}, titleId=11104, },
    }

   global.speedPanel = self
end

function UISpeedPanel:onEnter()

    self.ContinuousClick  = true
    self.btnUse:setEnabled(true)
    self.firstTag = 0              
    self.isMove = false
    self.leftBtn:setEnabled(false)
    self.rightBtn:setEnabled(true)
    self.isFirstClick = true

    self.scrollviewPanel:jumpToLeft()
end

function UISpeedPanel:setData(callFunc, queueId, lType, buildingId)

    self.lType = lType
    self.topModel:setVisible(false)
    self.buildingId = buildingId
    if lType == self.TYPE_BUFF_ADD then
        self.buffdata = queueId
    else 
        self.buffdata = nil 
    end  

    self.actionType = lType
    self:setItemUI(lType)

    if self.itemNode then
        self.itemNode:removeFromParent()
        self.itemNode = nil
    end

    if lType == self.TYPE_QUEUE_SPEED then

        self.itemNode = ItemQueueNode.new(queueId, callFunc)
        self:addChild(self.itemNode)
        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:clearQueue()
        end

    elseif lType == self.TYPE_SOLDIER_TRAIN or lType == self.TYPE_TECH_SPEED then

        -- self:addEventListener(global.gameEvent.EV_ON_UI_TECH_FLUSH,function() --
        --     if lType == self.TYPE_TECH_SPEED  then
        --         self.itemNode:initUI(callFunc)
        --     end 
        -- end)
      
        self.itemNode = ItemQueueClear.new( lType, queueId, callFunc)
        self:addChild(self.itemNode)
        self.setItemDataCall = function(data)

            if tolua.isnull(self.itemNode) then 
                return 
            end 

            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:clearQueue()
        end
      
    elseif lType == self.TYPE_RES_SPEED then

        self.itemNode = ResSpeedNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:resAccelerate()
        end

    elseif lType == self.TYPE_QUEUE_UNLOCK then

        self.itemNode = QueueUnlockNode.new(callFunc,queueId)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:unLockThreeQueue()
        end

    elseif lType == self.TYPE_WALK_SPEED then

        self.itemNode = SoldierSpeedNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:troopAccelerate()
        end

    elseif lType == self.TYPE_HERO_GIFT then

        self.itemNode = HeroGiftNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end

    elseif lType == self.TYPE_BUFF_ADD then

        self.itemNode = BuffAddNode.new(callFunc)
        self:addChild(self.itemNode)
        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
           self.itemNode:troopAccelerate()
        end     
    -- VIP
    elseif  lType == self.TYP_VIPAddPoint  or  lType == self.TYP_VIPActivation then 

        self.itemNode = VIPAddPointNode.new(callFunc)
        self:addChild(self.itemNode)
        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
          self.itemClickCall = function()
          self.itemNode:troopAccelerate()
        end  

    elseif lType == self.TYPE_HERO_EXP then

        self.itemNode = HeroExpNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end

    elseif lType == self.TYPE_EQUIP_BALANCE then

        self.itemNode = EquipBalance.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end

    elseif lType == self.TYPE_HERO_AGE then

        self.itemNode = HeroAgeNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end

    elseif lType == self.TYPE_EQUIP_RATE then

        self.itemNode = EquipRate.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end
    elseif lType == self.TYPE_LORD_EXP then

        self.itemNode = LordExpNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end

    elseif lType == self.TYPE_LORD_HP then

        self.itemNode = LordHPNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:sendGift()
        end

    elseif lType == self.TYPE_HERO_EXP_BATCH then --澡堂

        self.itemNode = HeroExp.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:start()
        end

    elseif lType == self.TYPE_SOLDIER_SOURCE then

        self.itemNode = SoldierSourceNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:useSourceCard()
        end
    elseif lType == self.TYPE_PET_ITEM then

        self.itemNode = PetUseItemNode.new(callFunc)
        self:addChild(self.itemNode)

        self.setItemDataCall = function(data)
            self.itemNode:setItemData(data)
        end 
        self.itemClickCall = function()
            self.itemNode:upPetImpress()
        end

    end

    self:onEnterState()

end

function UISpeedPanel:onEnterState()

    local selectTag = self.isFirstSelectTag or (10050+1005)
    local firstItem = self.scrollviewPanel:getChildByTag(selectTag)
    if not tolua.isnull(firstItem) and firstItem.item_click then

        firstItem:item_click(firstItem.bg, -100)
        local idx = selectTag-11055+1
        local idxPer = idx/(#self.itemData)*100
        if idx <=3 then 
            idxPer = 0
        elseif idx >=(#self.itemData-3) then 
            idxPer = 100
        end
        self.scrollviewPanel:jumpToPercentHorizontal(idxPer)
    end

end

function UISpeedPanel:reFreshNumber(count)
    local item  = self.scrollviewPanel:getChildByTag(self.curItemTag+1005)
    item.num:setString(global.normalItemData:getItemById(item.data.itemId).count)
end 

function UISpeedPanel:setItemUI( lType )

    local exteaParm = 0
    local buildingData = luaCfg:get_buildings_pos_by(self.buildingId) 
    if buildingData and lType == 1 then
        exteaParm = buildingData.buildingType 
    end

    self.itemData = {}
    local item = self.itemTypeList[lType].itemId
    local idIdxs = self.itemTypeList[lType].idIdx

    for _i,itemType in pairs(item) do 
        if itemType then
            local isId = false
            if idIdxs then
                isId = (idIdxs[_i] == 1)
            end
            local data = global.speedData:getItemByType(itemType, exteaParm, isId)
            if self.buffdata then
                for i=1, #data do 
                    if not (data[i].typePara3 ==self.buffdata.datatype) then 
                        data[i] =nil 
                    end 
                end 
            end  
            global.speedData:insertData(self.itemData, data) 
        end
    end
    table.sort( self.itemData, function(t1, t2) 

        local normalCall = function () 
            local s1, s2 = t1.itemType, t2.itemType
            local para1,para2 = t1.typePara1, t2.typePara1
            if s1 == 210 then
                para1 = para1*10
            end
            if s2 == 210 then
                para2 = para2*10
            end
            return para1 < para2 
        end

        if t1.itemType == 102  and t2.itemType == 102  then 

            return normalCall()
            
        elseif t1.itemType == 102 then 

            return false 

        elseif t2.itemType == 102 then 

            return true 
        end 

        return normalCall()

    end)

    self:CheckItem(lType)

    -- 标题
    local titleId = self.itemTypeList[lType].titleId
    self.txt_Title:setString(luaCfg:get_local_string(titleId))

    self:initItemScro()
    self:initNodeState()

end

function UISpeedPanel:CheckItem(lType)

    -- if lType == 5 then 
    --     -- local check = function(heroId)
    --     --     for i = #self.itemData, 1, -1 do
    --     --         if self.itemData[i].itemType == 123 and self.itemData[i].typePara1 ~= heroId then
    --     --             table.remove(self.itemData, i)
    --     --         end 
    --     --     end 
    --     -- end

    --     -- local heroId= self.buildingId
    --     -- check(heroId)

    --     if #self.itemData > 0 then  -- 御令 放在第一个位置
    --         local temp = self.itemData[1]
    --         self.itemData[1] = self.itemData[#self.itemData]
    --         self.itemData[#self.itemData] = temp 
    --         self.itemData[1] = clone(self.itemData[1])

    --         if global.normalItemData:getItemById( self.itemData[1].itemId).count > 0 and self.itemData[1].itemType == 123 then 
                    
    --             if global.heroData:CheckRedPoint(self.buildingId) then 
    --                 self.itemData[1].red = true 
    --             end   
    --         end 
    --     end
    -- end

    if lType == self.TYPE_HERO_GIFT then
        table.sort(self.itemData , function (A , B) return A.itemId < B.itemId end )
    end

    if lType == self.TYPE_HERO_EXP_BATCH then 
        table.sort(self.itemData , function (A , B) return A.itemId < B.itemId end )
    end 

end 

function UISpeedPanel:initNodeState()
    
    self.timeline_node:setVisible(true)
    self.restTime_node:setVisible(true)
    self.queueUnlock_node:setVisible(true)
    self.speedTime_node:setVisible(false)
end

function UISpeedPanel:initItemScro()
   
    self.itemSwitch = {}
    self.scrollviewPanel:removeAllChildren()

    self.isFirstSelectTag = nil
    local xW = self.Panel_2:getContentSize().width
    local i = 0
    for _,v in pairs(self.itemData) do
        
        local item = UIUseItem.new()
        local itemWidth = item.selectBg:getContentSize().width
        if #self.itemData == 2 then
            item:setPosition(cc.p(90 + xW*i, -8))
        else
            item:setPosition(cc.p(xW*i , -8))
        end
        item:setData(v)
        table.insert(self.itemSwitch, item)
        item:setNumVisible(v.itemId ~= 13311)
        item.bg:setTag(10050+i)
        item:setTag(item.bg:getTag()+1005)
        if v.itemId ~= 6 then
            local count = global.normalItemData:getItemById(v.itemId).count
            if count > 0 and not self.isFirstSelectTag then
                self.isFirstSelectTag = item:getTag()
            end
        end
        self.scrollviewPanel:addChild(item)
        i = i + 1
        self.scrollviewPanel:setInnerContainerSize(cc.size(i*xW + 5, self.scrollviewPanel:getContentSize().heigh))

        if i == 1 and self.actionType == self.TYPE_HERO_GIFT then

            -- item:setIcon("icon/item/hero_item_1.png")
        end
    end

    self.itemNum = #self.itemData
    if self.itemNum <= 3 then        
        self.leftBtn:setEnabled(false)
        self.rightBtn:setEnabled(false)
    end
end

function UISpeedPanel:setItemData( data )

    data = data or  self.data
    self.data = data
    self.btnUse:setEnabled(true)
    self.bt_select_all:setVisible(false)
    -- self.usePanel.iconBg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",data.quality))
    -- self.icon:setSpriteFrame(data.itemIcon)
    global.panelMgr:setTextureFor(self.icon,data.itemIcon)
    global.panelMgr:setTextureFor(self.usePanel.iconBg,string.format("icon/item/item_bg_0%d.png",data.quality))
    self.itemDes:setString(data.itemDes)
    
    --  魔晶使用
    if data.itemId == 6 then
        self.slider:setVisible(false)
        self.speedTime_node:setVisible(false)
        self.mojing_node:setVisible(true)
        self.btnUse:setEnabled(true)
        self.setItemDataCall(data)
        self:checkDiamondEnough(tonumber(self.need:getString()))          
    else
        self.slider:setVisible(true)
        self.speedTime_node:setVisible(true)
        self.mojing_node:setVisible(false)
        self.setItemDataCall(data)
    end
    global.tools:adjustNodePos(self.textHead, self.need)

    if not self.btnUsePoint then 
        self.btnUsePoint ={} 
        self.btnUsePoint.x ,self.btnUsePoint.y = self.btnUse:getPosition()
    end 

    self.btnUse:setPosition(cc.p(self.btnUsePoint.x,self.btnUsePoint.y))

    if global.ShopData:checkInShop(data.itemId) then  -- 

        self.btnAddItem:setVisible(true)

        self.bt_select_all:setVisible(false)

    else 
        
        self.btnAddItem:setVisible(false)

        if global.ShopData:checkCanUseAll(data.itemId) and data.itemId ~=6   then  

            self.bt_select_all:setVisible(true)

            self.bt_select_all:setEnabled(global.ShopData:getItemNumber(data.itemId) > 0 )

        else 

            local cx= self.usePanel:getContentSize().width/2
            self.btnUse:setPosition(cc.p(cx,self.btnUse:getPositionY()))
        end 

    end 

end


function UISpeedPanel:setLineBreak(textSp, str)

    textSp:setTextAreaSize(cc.size(textSp:getContentSize().width,0))
    textSp:setString(str)
    local label = textSp:getVirtualRenderer()
    local desSize = label:getContentSize()
    textSp:setContentSize(desSize)
end

function UISpeedPanel:initEventListener()
    
    self.scrollviewPanel:addEventListener(function(arg1,arg2,arg3)
        local innerW = self.scrollviewPanel:getInnerContainerSize().width
        local conW = self.scrollviewPanel:getContentSize().width
        local sW = self.Panel_2:getContentSize().width

        if arg2 then
            if self.itemNum <= 3 then
                return
            end
            local x = self.scrollviewPanel:getInnerContainerPosition().x
            local scroX =  math.abs(x)

            if scroX >= 0  and scroX <= sW/3 then
                self.leftBtn:setEnabled(false)
                self.rightBtn:setEnabled(true)
            elseif scroX > sW/3 and scroX<=(innerW - conW) - sW/3 then
                self.leftBtn:setEnabled(true)
                self.rightBtn:setEnabled(true)
            elseif scroX>(innerW - conW) - sW/3  and scroX <= (innerW - conW) then
                self.leftBtn:setEnabled(true)
                self.rightBtn:setEnabled(false)
            end
            if x >= 0 then
                 self.leftBtn:setEnabled(false)
            end   
        end
    end)
end

function UISpeedPanel:registerTouchListener()
    
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    local contentMove = 0
    local  listener = cc.EventListenerTouchOneByOne:create()
    local function touchBegan(touch, event)
       contentMove = 0
       return true
    end

    local function touchMoved(touch, event)
       local diff = touch:getDelta()
       contentMove = contentMove + math.abs(diff.x)
    end

    local function touchEnded(touch, event)
        if contentMove > 20 then
            self.isMove = true
        else
            self.isMove = false
        end
    end
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
end

function UISpeedPanel:checkDiamondEnough(num)
    if not propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.need:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.need:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UISpeedPanel:itemCountNotEnough(spaceStr, itemName)

    -- print(">>1")
    self.btnUse:setEnabled(false)
    self.sliderControl:reSetMaxCount(0)
    self.cur:setString(0)
    self.speedTime:setString("00:00:00") 
    global.tools:adjustNodePos(self.speedUseText, self.speedTime)                      
end

function UISpeedPanel:getSpaceStr()
    
    local spaceStr = ""
    local spStr = luaCfg:get_local_string(10621) .. self.need:getString()
    self.LabelLen:setString(spStr)
    local wMax = self.LabelLen:getContentSize().width

    for i=1,100 do
        
        spaceStr = spaceStr .. " "
        self.LabelLen:setString(spaceStr)
        local len = self.LabelLen:getContentSize().width 
        if len >= wMax then break end
    end
    return spaceStr.." "
end

function UISpeedPanel:changCountCallBack()
    if self.data == nil  then return end

    local item = self.scrollviewPanel:getChildByTag(self.curItemTag+1005)
    if not item then return end
    local curCount = self.sliderControl:getContentCount()

    print(curCount,"curCount//////////////////////")

    if curCount <= 0 and item.data.itemId ~= 6 then        
        -- print(">>2")
        -- print(debug.traceback())
        self.btnUse:setEnabled(false)
    end
    
    if self.actionType == 5 then
        self.speedUseText:setString(string.format(luaCfg:get_local_string(10339),global.funcGame:getItemImpress(item.data.itemId) * curCount))
        self.speedTime:setString("")
    elseif self.actionType == 6 then
        self.speedUseText:setString(string.format(luaCfg:get_local_string(10412),luaCfg:get_item_by(item.data.itemId).typePara1 * curCount))
        self.speedTime:setString("")
    elseif self.actionType == 13 then
        self.speedUseText:setString(string.format(luaCfg:get_local_string(10466).."%s",luaCfg:get_item_by(item.data.itemId).typePara1 * curCount))
        self.speedTime:setString("")
    elseif self.actionType ==  self.TYP_VIPAddPoint then 
        --self.speedUseText:setString(tonumber(luaCfg:get_localization_by(10461).value)*curCount)
        -- self.speedTime:setString(tonumber(self.data.typePara1)*curCount)
        self.speedUseText:setString(luaCfg:get_localization_by(10459).value..':'..tonumber(self.data.typePara1)*curCount)
        self.speedTime:setString("")
    elseif self.actionType == 14 then
        self.speedUseText:setString(string.format(luaCfg:get_local_string(10691),luaCfg:get_item_by(item.data.itemId).typePara1 * curCount))
        self.speedTime:setString("")
    elseif self.actionType == self.TYPE_LORD_HP then
        self.speedUseText:setString(string.format(luaCfg:get_local_string(10697),luaCfg:get_item_by(item.data.itemId).typePara1 * curCount))
        self.speedTime:setString("")
    elseif  self.actionType ==self.TYP_VIPActivation then 
        self.speedTime:setString("")
        self.speedUseText:setString(luaCfg:get_localization_by(10460).value..':'..funcGame.formatTimeToHMS((tonumber(self.data.typePara1)*curCount*60)))
    elseif self.actionType == self.TYPE_SOLDIER_SOURCE then
        self.speedUseText:setString(string.format(luaCfg:get_local_string(10906),luaCfg:get_item_by(item.data.itemId).typePara1 * curCount))
        self.speedTime:setString("")
    elseif self.actionType == self.TYPE_PET_ITEM then
        self.speedUseText:setString(luaCfg:get_local_string(11106, luaCfg:get_item_by(item.data.itemId).typePara1 * curCount))
        self.speedTime:setString("")
    else
        self.speedTime:setString(funcGame.formatTimeToHMS(curCount*self.data.typePara1*60))
        global.tools:adjustNodePos(self.speedUseText, self.speedTime)
    end      
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISpeedPanel:left_click(sender, eventType)
    
    local container = self.scrollviewPanel:getInnerContainer()
    local  isEnoughOneItem, scroX, sW = self:checkEnoughOneItem(0)
    if isEnoughOneItem > 1 then
        local moveAction = cc.MoveTo:create(0.3, cc.p(scroX+sW, self.scrollviewPanel:getInnerContainerPosition().y))
        container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
        self.rightBtn:setEnabled(true)

    else
        self.scrollviewPanel:scrollToPercentHorizontal(0, 1, true)
        self.leftBtn:setEnabled(false)
    end
end

function UISpeedPanel:right_click(sender, eventType)
    
    local container = self.scrollviewPanel:getInnerContainer()
    local  isEnoughOneItem, scroX, sW  =  self:checkEnoughOneItem(1)
    if isEnoughOneItem > 1 then
        local moveAction = cc.MoveTo:create(0.3, cc.p(scroX-sW, self.scrollviewPanel:getInnerContainerPosition().y))
       container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
       self.leftBtn:setEnabled(true)

    else
        self.scrollviewPanel:scrollToPercentHorizontal(100, 1, true)
        self.rightBtn:setEnabled(false)
    end
end

function UISpeedPanel:checkEnoughOneItem( _dirction )
    
    local isEnoughOneItem = 0
    local sW = self.Panel_2:getContentSize().width
    local scroWidth = self.scrollviewPanel:getContentSize().width
    local totalWidth =  self.itemNum*sW
    local scroX =  self.scrollviewPanel:getInnerContainerPosition().x

    if _dirction == 0 then
        isEnoughOneItem = math.floor(math.abs(scroX)/180)
    else
        isEnoughOneItem = math.floor((totalWidth - math.abs(scroX) - scroWidth)/180)
    end
    return isEnoughOneItem, scroX, sW
end

function UISpeedPanel:addItem_click(sender, eventType)
    global.ShopData:buyShop(self.data.itemId, function () 
        if self.reFresh then
            self:reFresh() 
        end
    end)
end
 

function UISpeedPanel:reFresh()
    self:setItemData()
    self:reFreshNumber()
end 


function UISpeedPanel:exit(sender, eventType)
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    gsound.stopEffect("city_click")
    global.panelMgr:closePanel("UISpeedPanel")
    self.topModel:setVisible(false)
end

function UISpeedPanel:useItem_click(sender, eventType)
    
    -- 防止连续点击问题
    if not self.ContinuousClick and self.lType == self.TYPE_RES_SPEED then
        return 
    end
    self.ContinuousClick = false

    if self.TYPE_BUFF_ADD then 
    else  
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_item")
    end 
    
    -- 每次使用判断魔晶数量，不足，弹出提示
    local item = self.scrollviewPanel:getChildByTag(self.curItemTag+1005)
    if  item.data.itemId == 6 then
        local needNum =  tonumber(self.need:getString())
        if not self:checkDiamondEnough(needNum) then
            global.panelMgr:openPanel("UIRechargePanel"):setCallBack(function ()
                self:checkDiamondEnough(needNum)
            end)
            return
        end
    end
    self.topModel:setVisible(true) 

    self.itemClickCall()

end

function UISpeedPanel:select_all(sender, eventType)
    self.sliderControl:chooseAll()
end

function UISpeedPanel:onExit()
    self.ContinuousClick = true
end 

--CALLBACKS_FUNCS_END

return UISpeedPanel

--endregion
