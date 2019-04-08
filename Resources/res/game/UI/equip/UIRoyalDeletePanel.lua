--region UIRoyalDeletePanel.lua
--Author : anlitop
--Date   : 2017/09/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIChooseEquip = require("game.UI.equip.widget.UIChooseEquip")
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
local UIItemDescriptionNode = require("game.UI.common.UIItemDescriptionNode")
--REQUIRE_CLASS_END

local UIRoyalDeletePanel  = class("UIRoyalDeletePanel", function() return gdisplay.newWidget() end )

function UIRoyalDeletePanel:ctor()
    self:CreateUI()
end

function UIRoyalDeletePanel:CreateUI()
    local root = resMgr:createWidget("bag/item_resolve_bg")
    self:initUI(root)
end

function UIRoyalDeletePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/item_resolve_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.fireNode = self.root.top_bg.equip_bg_img.Image_21.fireNode_export
    self.choose_1 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_1, self.root.top_bg.Image_22.choose_1)
    self.choose_2 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_2, self.root.top_bg.Image_23.choose_2)
    self.choose_3 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_3, self.root.top_bg.Image_24.choose_3)
    self.choose_4 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_4, self.root.top_bg.Image_25.choose_4)
    self.choose_5 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_5, self.root.top_bg.Image_26.choose_5)
    self.choose_6 = UIChooseEquip.new()
    uiMgr:configNestClass(self.choose_6, self.root.top_bg.Image_27.choose_6)
    self.title = self.root.title_export
    self.resolve_btn = self.root.manpower_bg1.resolve_btn_export
    self.gift_1 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_1, self.root.manpower_bg1.Node_1.gift_1)
    self.gift_2 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_2, self.root.manpower_bg1.Node_1.gift_2)
    self.gift_3 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_3, self.root.manpower_bg1.Node_1.gift_3)
    self.gift_4 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_4, self.root.manpower_bg1.Node_1.gift_4)
    self.gift_5 = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_5, self.root.manpower_bg1.Node_1.gift_5)
    self.TipLayout = self.root.TipLayout_export
    self.TipLayout = UIItemDescriptionNode.new()
    uiMgr:configNestClass(self.TipLayout, self.root.TipLayout_export)
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.resolve_btn, function(sender, eventType) self:api_call(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


local luaCfg  = global.luaCfg

function UIRoyalDeletePanel:chooseEquip(data,index)
    
    self["choose_"..index]:setRoyalDeleteData(data)
    self:flushEquip()
end

function UIRoyalDeletePanel:flushEquip()

    local res ={}  
    for i = 1,6 do
        local data = self["choose_"..i]:getData()
        if data then
            table.insert(res,data.lID)
        end
    end

    if #res <=0 then 
        self:setItems({})
        self.resolve_btn:setEnabled(false)
        return
    end 

    self.resolve_btn:setEnabled(true)

    local item = global.luaCfg:get_item_by(res[1])

    local drop = global.luaCfg:get_drop_by(item.typePara2).dropItem

    local drop_arr   = {} 

    for _ ,v in pairs(drop ) do 

        local temp = {} 
        temp.lID= v[1]
        temp.lCount = v[2]*#res
        table.insert(drop_arr ,temp)
    end 

    self:setItems(drop_arr)
end

function UIRoyalDeletePanel:onEnter()
    
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

--  "count" = 100
-- [LUA-print] -     "id"    = 12306
-- [LUA-print] -     "sort"  = 66

function UIRoyalDeletePanel:setData(data)

    self.data =  data 

    local max_number = 6 

    local count =  global.normalItemData:getItemById( self.data.id).count

    if max_number > count then 
        max_number =  count
    end 

    for i =1 , 6 do 

        if i > max_number then 

            self:chooseEquip( nil , i)

        else 
            self:chooseEquip( self.data.id  , i)
        end 
    end 
end 


function UIRoyalDeletePanel:cleanAll()
    
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

function UIRoyalDeletePanel:setItems(data)
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

function UIRoyalDeletePanel:playAction(data)
    
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

            self:setData(self.data)
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(panelData)
        end
    end)
end

function UIRoyalDeletePanel:getPutDatas(data)
      
    local res ={}  
    for i = 1,6 do

        local data = self["choose_"..i]:getData()
        if data then

            table.insert(res,data)
        end
    end

    return res
end

function UIRoyalDeletePanel:filterData(tbdata)
    
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

function UIRoyalDeletePanel:exit_call()
    self:removeListener()
    global.panelMgr:closePanelForBtn("UIRoyalDeletePanel")
end


function UIRoyalDeletePanel:removeListener()

    if self.listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
        self.listene = nil
    end
end 

function UIRoyalDeletePanel:auto_choose(sender, eventType)

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

function UIRoyalDeletePanel:checkQuality()

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

function UIRoyalDeletePanel:api_call(sender, eventType)

    local true_api_call = function()
        
        local res ={}  
        for i = 1,6 do

            local data = self["choose_"..i]:getData()
            if data then
                table.insert(res,data.lID)
            end
        end 

        global.itemApi:itemUse(res[1],#res, 0 , 0,   function(msg)

            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipSplitGo")
            
            local item = global.luaCfg:get_item_by(res[1])
            local drop = global.luaCfg:get_drop_by(item.typePara2).dropItem
            local drop_arr   = {} 
            for _ ,v in pairs(drop) do 
                local temp = {} 
                temp.lID= v[1]
                temp.lCount = v[2]*#res
                table.insert(drop_arr ,temp)
            end 
            self:playAction({tgItems=drop_arr})
        end)    
    end    

    if  false then

        local panel = global.panelMgr:openPanel("UIPromptPanel")            
        panel:setData("HighQuailtyResolve", function()

            true_api_call()               
        end)        
    else

        true_api_call()
    end
end

function UIRoyalDeletePanel:onExit()

    for i = 1,6 do

        self["choose_"..i].data = nil
    end  

end 

 
--CALLBACKS_FUNCS_END

return UIRoyalDeletePanel

--endregion
