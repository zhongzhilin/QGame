--region UIForgeInfoPanel.lua
--Author : yyt
--Date   : 2017/07/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBalanceNode = require("game.UI.equip.widget.UIBalanceNode")
--REQUIRE_CLASS_END

local UIForgeInfoPanel  = class("UIForgeInfoPanel", function() return gdisplay.newWidget() end )

function UIForgeInfoPanel:ctor()
    self:CreateUI()
end

function UIForgeInfoPanel:CreateUI()
    local root = resMgr:createWidget("equip/equip_forge_bg")
    self:initUI(root)
end

function UIForgeInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_forge_bg")

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
    self.equipIcon = self.root.ScrollView_1_export.top_bg.equipIcon_export
    self.rate_parent = self.root.ScrollView_1_export.top_bg.rate_parent_export
    self.balance_node6 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node6, self.root.ScrollView_1_export.top_bg.Image_2.balance_node6)
    self.balance_node5 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node5, self.root.ScrollView_1_export.top_bg.Image_3.balance_node5)
    self.balance_node4 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node4, self.root.ScrollView_1_export.top_bg.Image_3_0.balance_node4)
    self.balance_node3 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node3, self.root.ScrollView_1_export.top_bg.Image_3_1.balance_node3)
    self.balance_node2 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node2, self.root.ScrollView_1_export.top_bg.Image_3_2.balance_node2)
    self.balance_parent = self.root.ScrollView_1_export.top_bg.balance_parent_export
    self.balance_node1 = UIBalanceNode.new()
    uiMgr:configNestClass(self.balance_node1, self.root.ScrollView_1_export.top_bg.Image_4.balance_node1)
    self.effectNode = self.root.ScrollView_1_export.top_bg.effectNode_export
    self.wood_num = self.root.ScrollView_1_export.manpower_bg1.wood_num_export
    self.stone_num = self.root.ScrollView_1_export.manpower_bg1.stone_num_export
    self.forge_btn = self.root.ScrollView_1_export.manpower_bg1.forge_btn_export
    self.grayBg = self.root.ScrollView_1_export.manpower_bg1.forge_btn_export.grayBg_export

    uiMgr:addWidgetTouchHandler(self.equipIcon, function(sender, eventType) self:choose_equip_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.forge_btn, function(sender, eventType) self:forgeHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.equipIcon:setTouchEnabled(false)

    -- self.ScrollView_1:setTouchEnabled(true)
    -- local contentSize = self.ScrollView_1:getContentSize().height
    -- local sHeight = gdisplay.height - 75
    -- self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    -- if sHeight >= contentSize then
    --     self.ScrollView_1:setTouchEnabled(false)
    -- end
    

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGINs


function UIForgeInfoPanel:adapt()

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
function UIForgeInfoPanel:onEnter()

    self.nodeTimeLine = resMgr:createTimeline("equip/equip_forge_bg")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)

    self:playChooseAction()

    local fireState1_TimeLine = resMgr:createTimeline("effect/equip_str_fire")
    fireState1_TimeLine:play("animation0", true)
    self.fireNode.fireState1_export:stopAllActions()
    self.fireNode.fireState1_export:runAction(fireState1_TimeLine)
end

function UIForgeInfoPanel:setData(data)

    self.data = data -- 装备id
    self:setEquipData(data)

    self:addEventListener(global.gameEvent.EV_ON_ITEM_UPDATE, function() 
        if self.data then 
            self:setEquipData(self.data)
        end 
    end)
end

function UIForgeInfoPanel:setEquipData(data)

    self.isResEnougth = true
    self.isMaterialEnouth = true

    local equipData = luaCfg:get_equipment_by(data)
    local forgeEqip = luaCfg:get_forge_equip_by(data)
    self.forgeEqip = forgeEqip

    for i = 1,6 do
        self["balance_node"..i]:setVisible(false)
    end

    if equipData then

        self.equipIcon:setVisible(true)
        global.panelMgr:setTextureFor(self.equipIcon,equipData.icon)
        self.equip_name:setTextColor(cc.c3b(unpack(luaCfg:get_quality_color_by(equipData.quality).rgb)))
        self.equip_name:setString(equipData.name)
        self.wood_num:setString(forgeEqip.res1[2])
        self.stone_num:setString(forgeEqip.res2[2])

        -- 资源消耗是否充足
        local woodEnough =  global.cityData:checkResource(forgeEqip.res1)
        self.wood_num:setTextColor(gdisplay.COLOR_BLACK)
        if not woodEnough then
            self.wood_num:setTextColor(gdisplay.COLOR_RED)
        end
        local stoneEnough =  global.cityData:checkResource(forgeEqip.res2)
        self.stone_num:setTextColor(gdisplay.COLOR_BLACK)
        if not stoneEnough then
            self.stone_num:setTextColor(gdisplay.COLOR_RED)
        end
        self.isResEnougth = woodEnough and stoneEnough

        -- 材料是否足够
        local checkMaterialEnough = function (data)
            -- body
            local havCount = global.normalItemData:getItemById(data[1]).count
            if havCount >= data[2] then
                return true
            end
            return false
        end
        
        for i = 1,6 do
            local balanceData = forgeEqip["material"..i]
            if balanceData and balanceData[1] then
                self["balance_node"..i]:setVisible(true)
                self["balance_node"..i]:setBalance(balanceData[1], balanceData[2])
                self.isMaterialEnouth = self.isMaterialEnouth and checkMaterialEnough(balanceData)
            end    
        end
     
        local isCanForge = self.isMaterialEnouth and self.isResEnougth
        global.colorUtils.turnGray(self.grayBg, isCanForge == false)

    end

end

function UIForgeInfoPanel:playChooseAction()

    global.delayCallFunc(function ()
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipStrongItem")
    end, nil, 0.5)

    self.nodeTimeLine:play("animation2",false)  
end

function UIForgeInfoPanel:choose_equip_call(sender, eventType)
end

function UIForgeInfoPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIForgeInfoPanel")
end

function UIForgeInfoPanel:forgeHandler(sender, eventType)

    if not self.isMaterialEnouth then 
        global.tipsMgr:showWarning("NoForgeMaterial")
        return 
    end
    if not self.isResEnougth then 
        global.tipsMgr:showWarning("NoForgeResource")
        return 
    end

    global.itemApi:equipForge(self.forgeEqip.equipId,  function (msg)
        
        uiMgr:addSceneModel(3.5)
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipStron_1")
        self.nodeTimeLine:play("animation0",false)
        self.nodeTimeLine:setLastFrameCallFunc(function()
            global.panelMgr:openPanel("UIForgeSuccess"):setData(self.data)
            self:setData(self.data)
        end)

    end)
end
--CALLBACKS_FUNCS_END

return UIForgeInfoPanel

--endregion
