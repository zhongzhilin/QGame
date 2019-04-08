--region UIEquipStrongPanel.lua
--Author : Administrator
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRateNode = require("game.UI.equip.widget.UIRateNode")
local UIBalanceNode = require("game.UI.equip.widget.UIBalanceNode")
local UIStrongNode = require("game.UI.equip.widget.UIStrongNode")
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UIEquipStrongPanel  = class("UIEquipStrongPanel", function() return gdisplay.newWidget() end )

function UIEquipStrongPanel:ctor()
    self:CreateUI()
end

function UIEquipStrongPanel:CreateUI()
    local root = resMgr:createWidget("equip/equip_strengthen_bg")
    self:initUI(root)
end

function UIEquipStrongPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_strengthen_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.ps_node = self.root.ScrollView_1_export.ps_node_export
    self.fireNode = self.root.ScrollView_1_export.top_bg.equip_bg_img.Image_5.fireNode_export
    self.fireState1 = self.root.ScrollView_1_export.top_bg.equip_bg_img.Image_5.fireNode_export.fireState1_export
    local fireState1_TimeLine = resMgr:createTimeline("effect/equip_str_fire")
    fireState1_TimeLine:play("animation0", true)
    self.root.ScrollView_1_export.top_bg.equip_bg_img.Image_5.fireNode_export.fireState1_export:runAction(fireState1_TimeLine)
    self.equip_name = self.root.ScrollView_1_export.top_bg.equip_name_export
    self.top_plus_icon = self.root.ScrollView_1_export.top_bg.top_plus_icon_export
    self.topLevel = self.root.ScrollView_1_export.top_bg.top_plus_icon_export.topLevel_export
    self.add_btn = self.root.ScrollView_1_export.top_bg.add_btn_export
    self.equipIcon = self.root.ScrollView_1_export.top_bg.equipIcon_export
    self.rate_parent = self.root.ScrollView_1_export.top_bg.rate_parent_export
    self.rate_node1 = UIRateNode.new()
    uiMgr:configNestClass(self.rate_node1, self.root.ScrollView_1_export.top_bg.Image_2.rate_node1)
    self.balance_node1 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node1, self.root.ScrollView_1_export.top_bg.Image_3.balance_node1)
    self.balance_node2 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node2, self.root.ScrollView_1_export.top_bg.Image_3_0.balance_node2)
    self.balance_node3 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node3, self.root.ScrollView_1_export.top_bg.Image_3_1.balance_node3)
    self.balance_node4 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node4, self.root.ScrollView_1_export.top_bg.Image_3_2.balance_node4)
    self.balance_parent = self.root.ScrollView_1_export.top_bg.balance_parent_export
    self.strong_node1 = UIStrongNode.new()
    uiMgr:configNestClass(self.strong_node1, self.root.ScrollView_1_export.top_bg.Image_4.strong_node1)
    self.effectNode = self.root.ScrollView_1_export.top_bg.effectNode_export
    self.hava = self.root.ScrollView_1_export.manpower_bg1.hava_export
    self.strengthen_now_lv = self.root.ScrollView_1_export.manpower_bg1.hava_export.strengthen_now_lv_export
    self.strengthen_next_lv = self.root.ScrollView_1_export.manpower_bg1.hava_export.strengthen_next_lv_export
    self.m_combat = self.root.ScrollView_1_export.manpower_bg1.hava_export.m_combat_mlan_5_export
    self.combat_now = self.root.ScrollView_1_export.manpower_bg1.hava_export.combat_now_export
    self.combat_next = self.root.ScrollView_1_export.manpower_bg1.hava_export.combat_next_export
    self.combat1 = self.root.ScrollView_1_export.manpower_bg1.hava_export.combat1_mlan_5_export
    self.succes_pro = self.root.ScrollView_1_export.manpower_bg1.hava_export.succes_pro_mlan_16.succes_pro_export
    self.failed_not_down = self.root.ScrollView_1_export.manpower_bg1.hava_export.failed_not_down_mlan_16.failed_not_down_export
    self.strengthen_btn = self.root.ScrollView_1_export.manpower_bg1.hava_export.strengthen_btn_export
    self.coin_icon = self.root.ScrollView_1_export.manpower_bg1.hava_export.strengthen_btn_export.coin_icon_export
    self.coin_num = self.root.ScrollView_1_export.manpower_bg1.hava_export.strengthen_btn_export.coin_num_export
    self.empty = self.root.ScrollView_1_export.manpower_bg1.empty_export
    self.full = self.root.ScrollView_1_export.manpower_bg1.full_export
    self.full_lcom = self.root.ScrollView_1_export.manpower_bg1.full_export.combat_mlan_10.full_lcom_export
    self.full_level = self.root.ScrollView_1_export.manpower_bg1.full_export.full_level_export
    self.full_attr = self.root.ScrollView_1_export.manpower_bg1.full_export.full_attr_export
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.FileNode_1)
    self.bot_bt = self.root.bot_bt_export

    uiMgr:addWidgetTouchHandler(self.add_btn, function(sender, eventType) self:choose_equip_call(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.equipIcon, function(sender, eventType) self:choose_equip_call(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.manpower_bg1.hava_export.strengthen_info_btn, function(sender, eventType) self:info_call(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.strengthen_btn, function(sender, eventType) self:api_call(sender, eventType) end, true)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self:adapt()

    self.add_btn:setSwallowTouches(false)
    self.equipIcon:setSwallowTouches(false)
    self.strengthen_btn:setSwallowTouches(false)
    self.hava.strengthen_info_btn:setSwallowTouches(false)

end

function UIEquipStrongPanel:adapt()

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

function UIEquipStrongPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIEquipStrongPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIEquipStrongPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIEquipStrongPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIEquipStrongPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIEquipStrongPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end


function UIEquipStrongPanel:onEnter()

    self.isPageMove = false
    self:registerMove()
    
    self:setEquipData(nil)

    for i = 1,4 do

        self["balance_node"..i]:setIndex(i)
    end

    self.nodeTimeLine = resMgr:createTimeline("equip/equip_strengthen_bg")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)

    self.nodeTimeLine:play("animation3",false)

    local fireState1_TimeLine = resMgr:createTimeline("effect/equip_str_fire")
    fireState1_TimeLine:play("animation0", true)
    self.fireNode.fireState1_export:stopAllActions()
    self.fireNode.fireState1_export:runAction(fireState1_TimeLine)

    self.FileNode_1:setData(8)

    --  购买礼包后刷新
    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        if self.setEquipData then
            self:setEquipData(self.equipData, true)  
        end 
    end)

end

function UIEquipStrongPanel:playStrongAction(data)
    
    data = data or {}
    local tmpData = clone(self.equipData)

    if not tmpData then 
        return 
    end 

    if not self.model then
        self.model , self.listener = uiMgr:addSceneModel()
    end
    local isSuccess = false
    local animationStr = "animation1"
    if data.lStronglv and data.lStronglv > tmpData.lStronglv then
        isSuccess = true
        animationStr = "animation0"
        

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipStron_1")
    else

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipStron_2")
    end

    self.nodeTimeLine:play(animationStr,false)
    self.nodeTimeLine:setLastFrameCallFunc(function()
  
    end)

    self.nodeTimeLine:setFrameEventCallFunc(function(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "resCall" then

            global.panelMgr:openPanel("UIStrongResPanel"):setData(tmpData,data.lStronglv)
            self:removeListener()     
            if not tolua.isnull(self.model) and self.model then       
                self.model:removeFromParent()
            end 
            self:setEquipData(data)
        end
    end)
end

function UIEquipStrongPanel:playChooseAction()
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipStrongItem")

    self.nodeTimeLine:play("animation2",false)
    self.nodeTimeLine:setLastFrameCallFunc(function()
  
    end)    
end

function UIEquipStrongPanel:setEquipData(equipData, isNoPlayAction)

    local buildData = global.cityData:getTopLevelBuild(20)
    local buildAddRate = 0
    local buildAddBalance = 0

    if buildData then

        local lvData = global.cityData:getBuildingDataByLvAndId(buildData.id,buildData.serverData.lGrade)
        --dataType severPara1 --extraDataType extraPara
        local keys = {{"dataType","severPara1"},{"extraDataType","extraPara"}}
        for _,ks in ipairs(keys) do

            local dataType = lvData[ks[1]]
            local res = lvData[ks[2]]

            if dataType == 3073 then

                buildAddRate = buildAddRate + res
            elseif dataType == 3074 then

                buildAddBalance = buildAddBalance + res
            end
        end
    end

    self.buildAddBalance = buildAddBalance
    self.buildAddRate = buildAddRate

    self.equipData = equipData

    self.empty:setVisible(false)
    self.hava:setVisible(false)
    self.full:setVisible(false)

    if equipData == nil then

        self.equipIcon:setVisible(false)
        self.add_btn:setVisible(true)
        self.strong_node1:setData(nil)
        self.rate_node1:setRate(-2)
        for i = 1,4 do

            self["balance_node"..i]:setBalance(-2)
        end
        self.empty:setVisible(true)
        self.equip_name:setString("")
        self.top_plus_icon:setVisible(false)

    else

        if not isNoPlayAction then
            self:playChooseAction()
        end

        if equipData.lStronglv >= #luaCfg:equip_strengthen() then
   
            self.full:setVisible(true)     
            self.full_level:setString(equipData.lStronglv)
            self.full_lcom:setString(equipData.lCombat)

            for i = 1,4 do

                self.full_attr["atts_"..i]:setVisible(false)
            end

            local count = 0
            for i = 1,4 do
                
                local curPro = equipData.tgAttr[i]
                local node = self.full_attr["atts_"..i]
                if curPro ~= 0 then

                    count = count + 1
                    node:setVisible(true)
                    node.pro:setString(luaCfg:get_local_string(WCONST.BASE_PROPERTY[i].LOCAL_STR))
                    node.pro.pro_num:setString(curPro)     

                    global.tools:adjustNodePosForFather(node.pro.pro_num:getParent(),node.pro.pro_num,20)
                end
            end
        else

            self.hava:setVisible(true)
            local buffPro = luaCfg:get_equip_strengthen_by(equipData.lStronglv + 1)
            
            self.strengthen_now_lv:setString(equipData.lStronglv)
            self.strengthen_next_lv:setString(equipData.lStronglv + 1)

            self.combat_now:setString(equipData.lCombat)
            self.combat_next:setString(global.equipData:colNextStrongCombat(equipData))

            -- self.succes_pro:setString(buffPro.pro .. "%")
            -- self.failed_not_down:setString(buffPro.notDownPro .. "%")

            self.coin_num:setString(buffPro.coin)

            self.strong_node1:setData(buffPro)

            -- self.rate_node1:setRate(-1)
            -- for i = 1,4 do

            --     self["balance_node"..i]:setBalance(-1)
            -- end

            self.buffPro = buffPro

            self:checkOldItem()
            self:flushAdd()
            -- self.strengthen_btn:setEnabled(self.strong_node1:isFull() and global.propData:checkGoldEnough(buffPro.coin))


            local btnRes = self.strong_node1:isFull() and global.propData:checkGoldEnough(buffPro.coin)
            global.colorUtils.turnGray(self.strengthen_btn,not btnRes)

        end

        self.add_btn:setVisible(false)
        self.equipIcon:setVisible(true)

        -- self.equipIcon:loadTextureNormal(equipData.confData.icon, ccui.TextureResType.plistType)
        -- self.equipIcon:loadTexturePressed(equipData.confData.icon, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.equipIcon,equipData.confData.icon)

        self.top_plus_icon:setVisible(equipData.lStronglv ~= 0)
        self.equip_name:setTextColor(cc.c3b(unpack(luaCfg:get_quality_color_by(equipData.confData.quality).rgb)))
        self.equip_name:setString(equipData.confData.name)
        self.topLevel:setString(equipData.lStronglv)
        self.top_plus_icon:setPositionX(self.equip_name:getContentSize().width / 2 + self.equip_name:getPositionX())        
    end

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.failed_not_down:getParent(),self.failed_not_down)
    global.tools:adjustNodePosForFather(self.succes_pro:getParent(),self.succes_pro)
    global.tools:adjustNodePos(self.m_combat, self.combat_now)
    global.tools:adjustNodePos(self.combat1, self.combat_next)
    
end

function UIEquipStrongPanel:checkOldItem()
    local buffPro = self.buffPro
    local rateValue = buffPro.pro + self.buildAddRate
    local balanceValue = buffPro.notDownPro + self.buildAddBalance
    local normalItemData = global.normalItemData

    if rateValue >= 100 then

        self.rate_node1:setRate(-2)
    else

        local id = self.rate_node1:getId()
        if id > 0 then

            if normalItemData:getItemById(id).count > 0 then
                self.rate_node1:setRate(id)
            else
                self.rate_node1:setRate(-1)    
            end            
        else

            self.rate_node1:setRate(-1)
        end        
    end

    local alreadyChoose = {}
    for i = 1,4 do

        local node = self["balance_node"..i]
        if balanceValue >= 100 then

            node:setBalance(-2)
        else

            local id = node:getId()            

            if id > 0 then

                alreadyChoose[id] = alreadyChoose[id] or 0

                if normalItemData:getItemById(id).count - alreadyChoose[id] > 0 then
                    
                    local itemData = luaCfg:get_item_by(id)
                    balanceValue = balanceValue + itemData.typePara1
                    alreadyChoose[id] = alreadyChoose[id] + 1

                    node:setBalance(id)
                else

                    node:setBalance(-1)
                end                
            else

                node:setBalance(-1)
            end
        end
    end
end

function UIEquipStrongPanel:flushAdd()
    
    local rateValue,balanceValue = self:colItemAdd()
    local buffPro = self.buffPro
    rateValue = rateValue + buffPro.pro + self.buildAddRate
    balanceValue = balanceValue + buffPro.notDownPro + self.buildAddBalance

    if rateValue >= 100 then
        if self.rate_node1:getId() == -1 then
        
           self.rate_node1:setRate(-2) 
        end
        rateValue = 100
    end

    for i = 1,4 do

        local node = self["balance_node"..i]
        local balanceId = node:getId()
        if balanceId == -1 and balanceValue >=100 then
            
            node:setBalance(-2)
        end

        if balanceId == -2 and balanceValue <100 then
            
            node:setBalance(-1)
        end
    end

    if balanceValue >= 100 then
    
        balanceValue = 100  
    end    

    self.succes_pro:setString(rateValue .. "%")
    self.failed_not_down:setString(balanceValue .. "%")
end

function UIEquipStrongPanel:colItemAdd()
    
    local rateValue = 0
    local balanceValue = 0
    local rateId = self.rate_node1:getId()
    if rateId > 0 then
        
        local rateItemData = luaCfg:get_item_by(rateId)
        rateValue = rateItemData.typePara1
    end

    for i = 1,4 do

        local balanceId = self["balance_node"..i]:getId()
        if balanceId > 0 then

            local itemData = luaCfg:get_item_by(balanceId)
            balanceValue = balanceValue + itemData.typePara1     
        end
    end

    return rateValue,balanceValue
end

function UIEquipStrongPanel:chooseRate(itemId)
    
    self.rate_node1:setRate(itemId)
    self:flushAdd()
end

function UIEquipStrongPanel:chooseBalance(itemId,index)
    
    local lessCount = global.normalItemData:getItemById(itemId).count
    for i = 1,4 do
        local banlance = self["balance_node"..i]
        local id = banlance:getId()
        
        if id == itemId then
            lessCount = lessCount - 1
        end
    end

    if lessCount == 0 then

        global.tipsMgr:showWarning("ItemNotEnough")
        return
    end

    self["balance_node"..index]:setBalance(itemId)
    self:flushAdd()
end

function UIEquipStrongPanel:cancelBalance(state,index)
    self["balance_node"..index]:setBalance(state)
    self:flushAdd()
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIEquipStrongPanel:choose_equip_call(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        global.panelMgr:openPanel("UIEquipPanel"):setDataRaw(function()
            
            return global.equipData:getStrongEquipsForUI()
        end):setEquipInfo(false, 10425,false,function(data)

            self:setEquipData(data)
            global.panelMgr:closePanelForBtn("UIEquipPanel")
        end) 
    end
end

function UIEquipStrongPanel:exit_call()

    self:removeListener()
    global.panelMgr:closePanelForBtn("UIEquipStrongPanel")
end

function UIEquipStrongPanel:removeListener()

    if self.listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
        self.listene = nil
    end
end 


function UIEquipStrongPanel:api_call(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end
    
        if not self.strong_node1:isFull() then

            global.tipsMgr:showWarning("nostrong")
            return
        end

        if not global.propData:checkGoldEnough(self.buffPro.coin) then

            global.tipsMgr:showWarning("ItemUseCoin")
            return
        end

        local equipId = self.equipData.lID
        local rate = nil
        local banlances = {}

        local rateId = self.rate_node1:getId()
        if rateId > 0 then
            
            rate = {lID = rateId,lCount = 1}
        end

        for i = 1,4 do

            local balanceId = self["balance_node"..i]:getId()
            if balanceId > 0 then

                table.insert(banlances,{lID = balanceId,lCount = 1})
            end
        end

        global.uiMgr:addSceneModel(2)

        global.itemApi:equipStrong(equipId,banlances,rate,function(msg)

            if self.playStrongAction and global.panelMgr:isPanelOpened("UIEquipStrongPanel") then 
                self:playStrongAction(msg.tgInfo)
            end 

            global.equipData:equipNotify({lReason = 0,tagEquip = msg.tgInfo})        

            gevent:call(global.gameEvent.EV_ON_UI_EQUIP_FLUSH)
            gevent:call(global.gameEvent.EV_ON_UI_HERO_FLUSH) 
        end)

    end
end

function UIEquipStrongPanel:info_call(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if self.isPageMove then 
            return
        end

        global.panelMgr:openPanel("UIStrongInfoPanel"):setData(self.equipData)
    end
end
--CALLBACKS_FUNCS_END

return UIEquipStrongPanel

--endregion
