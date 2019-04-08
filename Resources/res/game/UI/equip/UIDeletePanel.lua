--region UIDeletePanel.lua
--Author : Administrator
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIChooseEquip = require("game.UI.equip.widget.UIChooseEquip")
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
local UIItemDescriptionNode = require("game.UI.common.UIItemDescriptionNode")
--REQUIRE_CLASS_END

local UIDeletePanel  = class("UIDeletePanel", function() return gdisplay.newWidget() end )

function UIDeletePanel:ctor()
    self:CreateUI()
end

function UIDeletePanel:CreateUI()
    local root = resMgr:createWidget("equip/equip_resolve_bg")
    self:initUI(root)
end

function UIDeletePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_resolve_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.fireNode = self.root.ScrollView_1_export.top_bg.equip_bg_img.Image_21.fireNode_export
    self.choose_1 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_1, self.root.ScrollView_1_export.top_bg.Image_22.choose_1)
    self.choose_2 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_2, self.root.ScrollView_1_export.top_bg.Image_23.choose_2)
    self.choose_3 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_3, self.root.ScrollView_1_export.top_bg.Image_24.choose_3)
    self.choose_4 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_4, self.root.ScrollView_1_export.top_bg.Image_25.choose_4)
    self.choose_5 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_5, self.root.ScrollView_1_export.top_bg.Image_26.choose_5)
    self.choose_6 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_6, self.root.ScrollView_1_export.top_bg.Image_27.choose_6)
    self.auto_text = self.root.ScrollView_1_export.auto_btn.auto_text_export
    self.resolve_btn = self.root.ScrollView_1_export.manpower_bg1.resolve_btn_export
    self.coin_icon = self.root.ScrollView_1_export.manpower_bg1.resolve_btn_export.coin_icon_export
    self.coin_num = self.root.ScrollView_1_export.manpower_bg1.resolve_btn_export.coin_num_export
    self.gift_1 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_1, self.root.ScrollView_1_export.manpower_bg1.Node_1.gift_1)
    self.gift_2 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_2, self.root.ScrollView_1_export.manpower_bg1.Node_1.gift_2)
    self.gift_3 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_3, self.root.ScrollView_1_export.manpower_bg1.Node_1.gift_3)
    self.gift_4 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_4, self.root.ScrollView_1_export.manpower_bg1.Node_1.gift_4)
    self.gift_5 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_5, self.root.ScrollView_1_export.manpower_bg1.Node_1.gift_5)
    self.TipLayout = self.root.ScrollView_1_export.TipLayout_export
    self.TipLayout = UIItemDescriptionNode.new()
    uiMgr:configNestClass(self.TipLayout, self.root.ScrollView_1_export.TipLayout_export)
    self.tips_node = self.root.ScrollView_1_export.tips_node_export
    self.bot_bg = self.root.bot_bg_export

    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.auto_btn, function(sender, eventType) self:auto_choose(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.resolve_btn, function(sender, eventType) self:api_call(sender, eventType) end , true)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self:adapt()

    -- for i =1,5 do
    --     local item = self["gift_"..i]
    --     -- item:showName()
    --     -- global.tipsMgr:registerLongPress(item, item.quit, self.TipLayout,
    --     --     handler(item, item.initTextTips),  handler(item, item.longPressDeal))
    -- end
end


function UIDeletePanel:adapt()

    local sHeight =(gdisplay.height - 75)
    local defY = self.ScrollView_1:getContentSize().height
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    local minsize= cc.size(gdisplay.width, defY)
    if sHeight < defY then 

    else
        self.ScrollView_1:setTouchEnabled(false)
        self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.ScrollView_1:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

end 

function UIDeletePanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIDeletePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
    self.deleting = nil
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIDeletePanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIDeletePanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIDeletePanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIDeletePanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end



function UIDeletePanel:chooseEquip(data,index)
    
    self["choose_"..index]:setData(data)
    self:flushEquip()
end

function UIDeletePanel:flushEquip()
    --[1] = { id=1,  maxLv=15,  resolveItem={{12301,100}},  minNum=1,  maxNum=2,  },
    local maybelist = {}
    local equip_res = luaCfg:equip_resolve()
    local coin = 0
    local alreadyCount = 0


    local checkType =function (item ,reslove_item )

        if item.itemType == 2000 and reslove_item.equipType == 2  then 

            return true 
        elseif item.itemType ~= 2000 and reslove_item.equipType ==1 then 

            return true 
        end 

        return false 
    end 

    for i = 1,6 do

        local data = self["choose_"..i]:getData()
        if data then

            local level = data.confData.lv
            local quality = data.confData.quality
            local preLevel = 0
            local preQuality = 0
            alreadyCount = alreadyCount + 1

            for _,v in ipairs(equip_res) do

                local resolveItem = v.resolveItem

                if preQuality ~= v.quality then
                    preLevel = 0
                end

                if quality == v.quality and level > preLevel and level <= v.maxLv and checkType(data.confData ,v) then

                    for _,ri in ipairs(resolveItem) do
                        
                        maybelist[ri[1]] = true
                    end                 

                    coin = coin + v.coin

                    break
                end

                if checkType(data.confData ,v) then 
                    preLevel = v.maxLv
                end 
            end
        end
    end

    if alreadyCount >= 6 then
    
        self.auto_text:setString(luaCfg:get_local_string(10451))
    else

        self.auto_text:setString(luaCfg:get_local_string(10450))
    end

    self.alreadyCount = alreadyCount

    for i = 1,5 do

        self["gift_"..i]:setVisible(false)
        self["gift_"..i]:clearTips()
    end

    local res = {}
    for k,v in pairs(maybelist) do
    
        table.insert(res,{id = k})
        
    end

    table.sortBySortList(res,{{"id","min"}})

    for count,v in ipairs(res) do
        self["gift_"..count]:setVisible(true)
        self["gift_"..count]:setId(v.id) 
        self["gift_"..count]:registerTips(self)
    end

    self.coin_num:setString(coin)

    self.resolve_btn:setEnabled(coin ~= 0 and global.propData:checkGoldEnough(coin))
end

function UIDeletePanel:onEnter()
    
    self.deleting = nil
    self.isPageMove = false
    self:registerMove()

    self:cleanAll()

    self.nodeTimeLine = resMgr:createTimeline("equip/equip_resolve_bg")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)

    self.nodeTimeLine:play("animation1",false)

    local fireState1_TimeLine = resMgr:createTimeline("effect/equip_res_fire")
    fireState1_TimeLine:play("animation0", true)
    self.fireNode:stopAllActions()
    self.fireNode:runAction(fireState1_TimeLine)

    self.TipLayout:setVisible(false)
end

function UIDeletePanel:cleanAll()
    
    for i = 1,6 do

        self["choose_"..i]:setData(nil)
        self["choose_"..i]:setIndex(i)
    end


    for i = 1,5 do

        self["gift_"..i]:setVisible(false)
        self["gift_"..i]:clearTips()
    end

    self:flushEquip()
end

function UIDeletePanel:setItems(data)
    for i =1,5 do

        self["gift_"..i]:setVisible(false)
        self["gift_"..i]:clearTips()

    end

    for i,v in ipairs(data) do

        local node = self["gift_"..i]
        node:setVisible(true)
        node:setId(v.lID,v.lCount)
        node:clearTips()
        node:registerTips(self)
    end
end

function UIDeletePanel:playAction(data)
    
    self.model,self.listener = uiMgr:addSceneModel()

    local panelData = {}
    for _,v in ipairs(data.tgItems) do
        table.insert(panelData,{[1] = v.lID,[2] = v.lCount})
    end

    self.nodeTimeLine:play("animation0",false)
    self.nodeTimeLine:setLastFrameCallFunc(function()
        
    end)

    self.nodeTimeLine:setFrameEventCallFunc(function(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "resCall" then
            self:removeListener()
            self.model:removeFromParent()
            self:cleanAll()
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(panelData)
            self.deleting = nil
        end
    end)
end

function UIDeletePanel:getPutDatas(data)
      
    local res ={}  
    for i = 1,6 do

        local data = self["choose_"..i]:getData()
        if data then

            table.insert(res,data)
        end
    end

    return res
end

function UIDeletePanel:filterData(tbdata)
    
    local putDatas = self:getPutDatas()
    for _,v in ipairs(putDatas) do

        local id = v.lID
        for i,tbv in ipairs(tbdata) do

            if tbv.lID == id then

                table.remove(tbdata,i)
                break
            end
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDeletePanel:exit_call()
    self:removeListener()
    global.panelMgr:closePanelForBtn("UIDeletePanel")
end


function UIDeletePanel:removeListener()

    if self.listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
        self.listene = nil
    end
end 

function UIDeletePanel:auto_choose(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        if self.alreadyCount >= 6 then

            self:cleanAll()
        else

            local dumpList = global.equipData:getDumpList()
            self:filterData(dumpList)

            if #dumpList == 0 then
                global.tipsMgr:showWarning("NoEquipResolve")
                return
            end

            for i = 1,6 do

                local data = self["choose_"..i]:getData()
                if not data then

                    local top = dumpList[1]
                    table.remove(dumpList,1)

                    self["choose_"..i]:setData(top)
                end
            end
        end
        
        self:flushEquip()

    end

end

function UIDeletePanel:checkQuality()

    local qualityMax = global.luaCfg:get_config_by(1).resolveQuality        
    local lvMax = global.luaCfg:get_config_by(1).resolveStrengthen

    for i = 1,6 do

        local data = self["choose_"..i]:getData()
        if data then

            local dataLv = data.lStronglv
            local dataQuality = data.confData.quality

            if dataQuality >= qualityMax or dataLv >= lvMax then

                return true
            end
        end
    end   

    return false
end

function UIDeletePanel:api_call(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then

        if self.isPageMove then 
            return
        end

        if self.deleting then return end
        self.deleting = true

        local true_api_call = function()
            
            local res ={}  
            for i = 1,6 do

                local data = self["choose_"..i]:getData()
                if data then

                    table.insert(res,data.lID)
                end
            end   

            global.itemApi:deleteEquip(res,function(msg)
                
                gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipSplitGo")
                self:playAction(msg)
                
            end)    
        end    

        if self:checkQuality() then

            local panel = global.panelMgr:openPanel("UIPromptPanel")     
            
            panel:setData("HighQuailtyResolve", function()

                true_api_call()               
            end)        
            panel:setCancelCall(function()
                self.deleting = false
            end)
            panel:setModalEnable(false)
        else

            true_api_call()
        end

    end
end
--CALLBACKS_FUNCS_END

return UIDeletePanel

--endregion
