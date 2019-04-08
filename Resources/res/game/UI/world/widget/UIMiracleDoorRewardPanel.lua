--region UIMiracleDoorRewardPanel.lua
--Author : Untory
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIItemBaseIcon = require("game.UI.common.UIItemBaseIcon")
local UIWildSoldier = require("game.UI.world.widget.wild.UIWildSoldier")
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIMiracleDoorRewardPanel  = class("UIMiracleDoorRewardPanel", function() return gdisplay.newWidget() end )

function UIMiracleDoorRewardPanel:ctor()
    self:CreateUI()
end

function UIMiracleDoorRewardPanel:CreateUI()
    local root = resMgr:createWidget("wild/temple_reward_bg")
    self:initUI(root)
end

function UIMiracleDoorRewardPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_reward_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.Node = self.root.Node_export
    self.title = self.root.Node_export.title_export
    self.ScrollView_1 = self.root.Node_export.Node_1.Image_9.ScrollView_1_export
    self.info = self.root.Node_export.Node_1.Image_9.ScrollView_1_export.info_export
    self.buff_desc = self.root.Node_export.Node_1.Image_9.set_buff_view.buff_desc_export
    self.buff1 = self.root.Node_export.Node_1.Image_9.set_buff_view.buff1_export
    self.buff2 = self.root.Node_export.Node_1.Image_9.set_buff_view.buff2_export
    self.buff3 = self.root.Node_export.Node_1.Image_9.set_buff_view.buff3_export
    self.buff4 = self.root.Node_export.Node_1.Image_9.set_buff_view.buff4_export
    self.loadingbar_bg = self.root.Node_export.Node_1.Image_9.set_buff_view.castle_num_mlan_5.loadingbar_bg_export
    self.loading = self.root.Node_export.Node_1.Image_9.set_buff_view.castle_num_mlan_5.loadingbar_bg_export.loading_export
    self.hp = self.root.Node_export.Node_1.Image_9.set_buff_view.castle_num_mlan_5.loadingbar_bg_export.hp_export
    self.reward_buff = self.root.Node_export.recruit_title.reward_buff_export
    self.frame = self.root.Node_export.recruit_title.frame_export
    self.gift_icon = self.root.Node_export.recruit_title.frame_export.gift_icon_export
    self.gift_icon = UIItemBaseIcon.new()
    uiMgr:configNestClass(self.gift_icon, self.root.Node_export.recruit_title.frame_export.gift_icon_export)
    self.frame_icon = self.root.Node_export.recruit_title.frame_export.frame_icon_export
    self.frame_name = self.root.Node_export.recruit_title.frame_export.frame_name_export
    self.frame_desc = self.root.Node_export.recruit_title.frame_export.frame_desc_mlan_20_export
    self.first_reward_icon = self.root.Node_export.recruit_title.first_reward_icon_export
    self.first_name = self.root.Node_export.recruit_title.first_name_export
    self.first_reward = self.root.Node_export.recruit_title.first_reward_mlan_20_export
    self.forth_reward_card = self.root.Node_export.recruit_title_0.forth_reward_card_mlan_20_export
    self.reward_card = self.root.Node_export.recruit_title_0.reward_card_export
    self.a1 = UIWildSoldier.new()
    uiMgr:configNestClass(self.a1, self.root.Node_export.recruit_title_0.a1)
    self.forth_reward = self.root.Node_export.recruit_title_0.forth_reward_mlan_20_export
    self.reward4 = self.root.Node_export.recruit_title_0.reward4_export
    self.close_node = self.root.Node_export.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_export.close_node_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitclick(sender, eventType) end)
--EXPORT_NODE_END
    self.gift_icon:hideName()
    self.gift_icon:openLongTipsControl()
end

function UIMiracleDoorRewardPanel:getRewardData(magicType)
    
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do

        if v.type == magicType then

            return v
        end
    end
end


function UIMiracleDoorRewardPanel:setType(magicType,city)
    
    self.magicType = magicType
    self.city = city

    local cfgData = self:getRewardData(magicType) or {} 
    local league1 = cfgData.league1 or {} 
    local league1Cfg = luaCfg:get_data_type_by(league1[1])
    local league1count = league1[2]

    -- if cfgData.roleFrame == -1 then
    --     self.frame:setVisible(false) 
    -- else        
    --     local headData = luaCfg:get_role_frame_by(cfgData.roleFrame) or {}
    --     -- self.role_frame_icon:setSpriteFrame(headData.pic)
    --     global.panelMgr:setTextureFor(self.frame_icon, headData.pic or "icon/role_frame/role_frame_1.png")
       
    --     self.frame_name:setString(headData.name or "")
    --     self.frame:setVisible(true)
    -- end    
    
    if magicType > 800  then
        self.title:setString(luaCfg:get_local_string(11111))
        uiMgr:setRichText(self, "info",50320)

        local miracleData = global.luaCfg:get_all_miracle_name_by(self.city:getId())        
        local itemData = luaCfg:get_item_by(miracleData.reward[1][1]) 

        self.gift_icon:setVisible(true)
        self.gift_icon:setId(miracleData.reward[1][1],miracleData.reward[1][2])      

        -- global.panelMgr:setTextureFor(self.frame_icon, itemData.itemIcon)
        self.frame_icon:setVisible(false)

        self.frame_name:setString('x1/24h')
        self.frame_desc:setString(luaCfg:get_local_string(11116))
        -- self.frame:setVisible(true)
    else
        self.title:setString(luaCfg:get_local_string(11110))
        uiMgr:setRichText(self, "info",50136)

        local headData = luaCfg:get_role_frame_by(cfgData.roleFrame) or {}        
        global.panelMgr:setTextureFor(self.frame_icon, headData.pic or "icon/role_frame/role_frame_1.png")
        -- self.frame_icon:setScale(0.2)
        self.frame_icon:setVisible(true)

        self.gift_icon:setVisible(false)
        self.frame_name:setString(headData.name or "")
        self.frame_desc:setString(luaCfg:get_local_string(11115))
        -- self.frame:setVisible(true)
    end

    
    local size = self.info:getRichTextSize()
    self.ScrollView_1:setInnerContainerSize(cc.size(size.width,size.height))
    if size.height <  self.ScrollView_1:getContentSize().height then 
        self.info:setPositionY(self.ScrollView_1:getContentSize().height-15)
    else 
        self.info:setPositionY(size.height)
    end 
    self.ScrollView_1:jumpToTop()


    -- if cfgData and cfgData.defBuff then 
    --     uiMgr:setRichText(self, "reward_buff", 50137, {num = cfgData.defBuff[2] .. "%"})
    -- end 
    self.reward_buff:setVisible(false)
    -- uiMgr:setRichText(self, "card_reward", 50216, {num = cfgData.maxReward})

    self.first_name:setString(string.format("+%s/h",league1count))
    -- self.reward1:setString(string.format("%s: +%s%s",league1Cfg.paraName,league1count,league1Cfg.extra))

    local league2 = cfgData.league2 or {} 
    local league2Cfg = luaCfg:get_data_type_by(league2[1])
    local league2count = league2[2]

    -- self.reward2:setString(string.format("%s: +%s%s",league2Cfg.paraName,league2count,league2Cfg.extra))
    -- self.reward2:setString(string.format("%s+%s%s",league2Cfg.paraName,league2count,league2Cfg.str))
    self.reward4:setString(string.format("+%s/h",league2count))
    self.reward_card:setString(string.format("+%s/24h",cfgData.maxReward))

    local person = cfgData.person
    local itemData = luaCfg:get_item_by(person) or {}
    local soldierId = itemData.typePara1 or 0
    local soldierData = luaCfg:get_soldier_property_by(soldierId) or {} 

    self.a1:setDataNotWild(soldierId)
    self.a1:showName(false)

    self.buff_desc:setString(luaCfg:get_local_string(11037,cfgData.member,str))
    for i=1,4 do
        self["buff"..i]:setVisible(false)
    end
    for i,v in ipairs(cfgData.buff) do
        self["buff"..i]:setVisible(true)
        self["buff"..i]:setString(global.buffData:getBuffStrBy({lID=v[1],lValue=v[2]}))
    end
    local member = self.city:getAllyCastleNum()
    self.loading:setPercent(member/cfgData.member*100)
    self.hp:setString(string.format("%s/%s",member,cfgData.member))

    -- self.atk_num:setString(soldierData.atk)
    -- self.dPower_num:setString(soldierData.dPower)
    -- self.itfDef_num:setString(soldierData.iftDef)
    -- self.acrDef_num:setString(soldierData.acrDef)
    -- self.cvlDef_num:setString(soldierData.cvlDef)
    -- self.magDef_num:setString(soldierData.magDef)
    -- self.speed_num:setString(soldierData.speed)
    -- self.perPop_num:setString(soldierData.perPop)
    -- self.capacity_num:setString(soldierData.capacity)
    -- self.perRes_num:setString(soldierData.perRes)

    global.tools:adjustNodePos(self.first_name,self.first_reward)
    global.tools:adjustNodePos(self.frame_name,self.frame_desc)
    global.tools:adjustNodePos(self.reward_card,self.forth_reward_card)
    global.tools:adjustNodePos(self.reward4,self.forth_reward)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMiracleDoorRewardPanel:exitclick(sender, eventType)
    global.panelMgr:closePanelForBtn("UIMiracleDoorRewardPanel") 
end
--CALLBACKS_FUNCS_END

return UIMiracleDoorRewardPanel

--endregion
