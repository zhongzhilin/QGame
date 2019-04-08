--region UIHeroPanel.lua
--Author : yyt
--Date   : 2016/09/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local equipData = global.equipData
local TabControl = require("game.UI.common.UITabControl")
local UIHeroItem = require("game.UI.hero.UIHeroItem")
local UICommonHeroItem = require("game.UI.hero.UICommonHeroItem")
local UIHeroListItem = require("game.UI.hero.UIHeroListItem")
local CCSScrollView = require("game.UI.common.CCSScrollView")
local UIEquipInfo = require("game.UI.equip.UIEquipInfo")
local TextScrollControl = require("game.UI.common.UITextScrollControl")
local gameEvent = global.gameEvent
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroExpItem = require("game.UI.hero.UIHeroExpItem")
local UISkillItem = require("game.UI.hero.skill.UISkillItem")
local UIHeroNewNode = require("game.UI.hero.UIHeroNewNode")
local UIHeroNode4 = require("game.UI.hero.UIHeroNode4")
--REQUIRE_CLASS_END

local UIHeroPanel  = class("UIHeroPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIHeroItemCell = require("game.UI.hero.UIHeroItemCell")
local UIHeroGirdItemCell = require("game.UI.hero.UIHeroGirdItemCell")
local UICommonHeroItemCell = require("game.UI.hero.UICommonHeroItemCell")
local UIChatTableView = require("game.UI.chat.UIChatTableView")

function UIHeroPanel:ctor()
    self:CreateUI()
end

function UIHeroPanel:CreateUI()
    local root = resMgr:createWidget("hero/hero_bg")
    self:initUI(root)
end

function UIHeroPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.layout_title = self.root.layout_title_export
    self.Node1 = self.root.Node1_export
    self.node1_parent = self.root.Node1_export.node1_parent_export
    self.ScrollView_1 = self.root.Node1_export.node1_parent_export.ScrollView_1_export
    self.txt_power = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.txt_power_export
    self.hero_name = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_name_export
    self.hero_Lv = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Lv_mlan_8.hero_Lv_export
    self.hero_type = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_type_mlan_8.hero_type_export
    self.hero_grow = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_grow_mlan_8.hero_grow_export
    self.hero_attack = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_attack_mlan_4.hero_attack_export
    self.attack_buff = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_attack_mlan_4.attack_buff_export
    self.hero_defense = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_defense_mlan_4.hero_defense_export
    self.defense_buff = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_defense_mlan_4.defense_buff_export
    self.hero_interior = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_interior_mlan_4.hero_interior_export
    self.interior_buff = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_interior_mlan_4.interior_buff_export
    self.hero_commander = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_mlan_5.hero_commander_export
    self.commander_buff = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_mlan_5.commander_buff_export
    self.hero_Commander = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.details_node.hero_Commander_type_mlan_5.hero_Commander_export
    self.hero_icon = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.hero_icon_export
    self.expNode = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.expNode_export
    self.expNode = UIHeroExpItem.new()
    uiMgr:configNestClass(self.expNode, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.expNode_export)
    self.Skill_node = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export
    self.skill_0 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_0, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_0)
    self.skill_1 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_1, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_1)
    self.skill_2 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_2, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_2)
    self.skill_3 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_3, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_3)
    self.skill_4 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_4, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_4)
    self.skill_5 = UISkillItem.new()
    uiMgr:configNestClass(self.skill_5, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.Skill_node_export.skill_5)
    self.FileNode_1 = UIHeroNewNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.FileNode_1)
    self.xing1 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.xing1_export
    self.xing2 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.xing2_export
    self.xing3 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.xing3_export
    self.xing4 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.xing4_export
    self.xing5 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.xing5_export
    self.xing6 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.xing6_export
    self.right = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.right_export
    self.left = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.details_bg_node.left_export
    self.equipment_bg1 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg1_export
    self.icon1 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg1_export.iconParent.icon1_export
    self.strog = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg1_export.strog_export
    self.equipment_bg2 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg2_export
    self.icon2 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg2_export.iconParent.icon2_export
    self.strog = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg2_export.strog_export
    self.equipment_bg3 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg3_export
    self.icon3 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg3_export.iconParent.icon3_export
    self.strog = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg3_export.strog_export
    self.equipment_bg4 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg4_export
    self.icon4 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg4_export.iconParent.icon4_export
    self.strog = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg4_export.strog_export
    self.equipment_bg5 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg5_export
    self.icon5 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg5_export.iconParent.icon5_export
    self.strog = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg5_export.strog_export
    self.equipment_bg6 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg6_export
    self.icon6 = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg6_export.iconParent.icon6_export
    self.strog = self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.equipment_node.equipment_background.equipment_bg6_export.strog_export
    self.layout_list = self.root.Node1_export.node1_parent_export.hero_list_node.layout_list_export
    self.number_1 = self.root.Node1_export.node1_parent_export.hero_list_node.list_bg.number_1_export
    self.number_2 = self.root.Node1_export.node1_parent_export.hero_list_node.list_bg.number_2_export
    self.item_layout = self.root.Node1_export.node1_parent_export.hero_list_node.list_bg.item_layout_export
    self.ScrollHero = self.root.Node1_export.node1_parent_export.hero_list_node.list_bg.ScrollHero_export
    self.btn_left = self.root.Node1_export.node1_parent_export.hero_list_node.btn_left_export
    self.btn_right = self.root.Node1_export.node1_parent_export.hero_list_node.btn_right_export
    self.Node2 = self.root.Node2_export
    self.recruit_bg = self.root.Node2_export.recruit_bg_export
    self.hero_type_group = self.root.Node2_export.recruit_bg_export.hero_type_group_export
    self.ing = self.root.Node2_export.recruit_bg_export.ing_export
    self.ing_par = self.root.Node2_export.recruit_bg_export.ing_par_mlan_12_export
    self.percentage = self.root.Node2_export.recruit_bg_export.percentage_export
    self.Scrollview_2 = self.root.Node2_export.Scrollview_2_export
    self.tb_add = self.root.tb_add_export
    self.Node4 = self.root.Node4_export
    self.heroCome = self.root.Node4_export.heroCome_export
    self.heroCome = UIHeroNode4.new()
    uiMgr:configNestClass(self.heroCome, self.root.Node4_export.heroCome_export)
    self.Node3 = self.root.Node3_export
    self.Scrollview_3 = self.root.Node3_export.Scrollview_3_export
    self.node3_bottom = self.root.Node3_export.node3_bottom_export
    self.But2spReadState = self.root.Node3_export.node3_bottom_export.But2.But2spReadState_export
    self.But5spReadState = self.root.Node3_export.node3_bottom_export.But3.But5spReadState_export
    self.no_hero = self.root.no_hero_export
    self.intro_btn = self.root.intro_btn_export
    self.tb_content = self.root.tb_content_export
    self.tb_top_node = self.root.tb_top_node_export
    self.tb_bottom_node = self.root.tb_bottom_node_export
    self.tb_item_content = self.root.tb_item_content_export
    self.But4spReadState = self.root.big_title_node2.Button_4.But4spReadState_export
    self.But3spReadState = self.root.big_title_node2.Button_2.But3spReadState_export
    self.hero_title = self.root.hero_title_fnt_mlan_12_export
    self.gird_item = self.root.gird_item_export
    self.tb_gird_bottom = self.root.tb_gird_bottom_export
    self.tb_top_node_for_node3 = self.root.tb_top_node_for_node3_export
    self.tb_top_node_for_node2 = self.root.tb_top_node_for_node2_export

    uiMgr:addWidgetTouchHandler(self.root.Node1_export.node1_parent_export.ScrollView_1_export.Slide_panel.share_btn, function(sender, eventType) self:shareHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_left, function(sender, eventType) self:left_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_right, function(sender, eventType) self:right_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node3_export.node3_bottom_export.But1, function(sender, eventType) self:node2Btn1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node3_export.node3_bottom_export.But2, function(sender, eventType) self:node2Btn2(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node3_export.node3_bottom_export.But3, function(sender, eventType) self:node2Btn3(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node3_export.node3_bottom_export.But4, function(sender, eventType) self:node2Btn4(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END

    -- self.isNode1Out = true

    --滚动字 张亮
    uiMgr:initScrollText(self.hero_Commander)
    
    for i=1,6 do
        uiMgr:addWidgetTouchHandler(self["icon"..i], function(sender, eventType) self:equipItem_click(i,sender) end)        
    end

    for i=1,6 do
        self["icon"..i]:setSwallowTouches(false)        

        local light = resMgr:createWidget("effect/equip_ad_lv")        
        light:setPosition(cc.p(90,90))
        self["icon"..i]:addChild(light)
        self['light'..i] = light
    end    

    -- self.ScrollView_2 = self.Node2.ScrollView_2
    self.heroItem_layout = self.Node2.Panel_2  

    self.ScrollView_3 = self.Node3.ScrollView_3
    self.normalHero_layout = self.Node3.item_layout
    
    local sHeight = gdisplay.height - self.layout_title:getContentSize().height
    local sizeHeight = sHeight - self.layout_list:getContentSize().height
    
    self.scrollviewPanelNode = cc.Node:create()
    self.ScrollView_1:addChild(self.scrollviewPanelNode)
    if sizeHeight > 900 then
        self.ScrollView_1:setContentSize(cc.size(gdisplay.width, 900))
        self.ScrollView_1:setBounceEnabled(false)
    else
        self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sizeHeight))
        self.ScrollView_1:setBounceEnabled(true)
    end    
    self.ScrollView_1:setPositionY(sHeight)

    -- self.titleNode = self.root.big_title_node.common_title
    -- uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.titleNode2 = self.root.big_title_node2.common_title
    uiMgr:addWidgetTouchHandler(self.titleNode2.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    -- self.tabControl = TabControl.new(self.root.big_title_node, handler(self, self.onTabButtonChanged), 1,
    --     cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))
    self.tabControl2 = TabControl.new(self.root.big_title_node2, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.nodeSwitch = {self.Node1, self.Node2, self.Node3,self.Node4}
    self.itemSwitch = {}

    self.recruitHeroNum = 0

    self.ScrollHero:addEventListener(function(arg1,arg2,arg3)
        
        local innerW = self.ScrollHero:getInnerContainerSize().width
        local conW = self.ScrollHero:getContentSize().width
        local sW = self.item_layout:getContentSize().width

        if arg2 then
            if self.recruitHeroNum <= 3 then
                return
            end

            local x = self.ScrollHero:getInnerContainerPosition().x
            local scroX =  math.abs(x)


            if scroX >= 0  and scroX <= sW/3 then

                self.btn_left:setEnabled(false)
                self.btn_right:setEnabled(true)
            elseif scroX > sW/3 and scroX<=(innerW - conW) - sW/3 then

                self.btn_left:setEnabled(true)
                self.btn_right:setEnabled(true)
            elseif scroX>(innerW - conW) - sW/3  and scroX <= (innerW - conW) then
      
                self.btn_left:setEnabled(true)
                self.btn_right:setEnabled(false)
            end

            if x >= 0 then
                 self.btn_left:setEnabled(false)
            end
            
        end
    end)

    self.tableView = UIChatTableView.new()
        :setSize(self.tb_content:getContentSize(), self.tb_top_node, self.tb_bottom_node)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIHeroItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    
    self.tableview_gird = UITableView.new()
        :setSize(self.tb_content:getContentSize(), self.tb_top_node_for_node2, self.tb_gird_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.gird_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIHeroGirdItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(4)
    self.Scrollview_2:addChild(self.tableview_gird)

    self.tableview_3 = UITableView.new()
        :setSize(self.tb_content:getContentSize(), self.tb_top_node_for_node3, self.tb_bottom_node)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.normalHero_layout:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UICommonHeroItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(1)
    self.Scrollview_3:addChild(self.tableview_3)

    self.no_hero:setTouchEnabled(false)

    self.root.big_title_node2.Button_2:setSwallowTouches(true)
    self.root.big_title_node2.Button_3:setSwallowTouches(true)


    -- self.bot_bg:setSwallowTouches(true)

    -- self.ScrollHero:setPositionY(gdisplay.height - 150)
    -- self.ScrollHero:setContentSize(cc.size(190,gdisplay.height - 160))

    self.Scrollview_3:setPositionY(-self.Node3:getPositionY())
    self.recruit_bg:setPositionY(gdisplay.height - 160)
    self.node3_bottom:setPositionY(1280 - gdisplay.height)


    self.tabControlForHero = TabControl.new(self.hero_type_group, handler(self, self.onTabButtonChangedOnHero), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.Node3.Sprite_31:setPositionY(1280-gdisplay.height)


    -- self:adapt()

    self.orginPosX = self.hero_attack:getParent():getPositionX()

end


function UIHeroPanel:adapt()

    local ps = self.heroCome.root.Image_149:convertToWorldSpace((cc.p(0,0)))
    local size = self.heroCome.root.Image_149:getContentSize()
    local old_y = self.heroCome.root.Image_149:getPositionY()
    if ps.y > 0 then 
        self.heroCome.root.Image_149:setContentSize(cc.size(size.width , size.height+ ps.y))
        self.heroCome.root.Image_149:setPositionY(old_y- ps.y)
    else 

    end 

end 


function UIHeroPanel:setMode2()

    self.mode = 2

    self.root.big_title_node2.Button_2:setVisible(true)
    self.root.big_title_node2.Button_3:setVisible(true)
    self.no_hero:setVisible(false)

    self.tableView:setVisible(true)

    self:cleanNode()

    self.tabControl2:setSelectedIdx(2)
    self:onTabButtonChanged(2)

    self.root.big_title_node2:setVisible(true)
    -- self.root.big_title_node:setVisible(false)    

end


function  UIHeroPanel:adjusUI()


    if # global.heroData:getGotHeroData() > 0  then 


        self.root.big_title_node2.Button_2:setVisible(true)
        self.root.big_title_node2.Button_3:setVisible(true)

        self.no_hero:setVisible(false)

    else 


        self.root.big_title_node2.Button_2:setVisible(false)
        self.root.big_title_node2.Button_3:setVisible(false)

        self.no_hero:setVisible(true)
    end 


    if self.contentIndex  == 1 then 

        self.tableView:setVisible(false)
    else 

        self.tableView:setVisible(true)
    end 


end 

function UIHeroPanel:setMode3()

    if true then 

        self:setMode2()

        return 
    end 

    self.mode = 3

    self.root.big_title_node2.Button_2:setVisible(false)
    self.root.big_title_node2.Button_3:setVisible(false)

    self:cleanNode()

    self.tabControl2:setSelectedIdx(2)
    self:onTabButtonChanged(2)

    self.root.big_title_node2:setVisible(true)
    -- self.root.big_title_node:setVisible(false)

    self.hero_title:setString(luaCfg:get_local_string(10359))

    self.Node3.hero_title_bg_1:setVisible(true)
end

function UIHeroPanel:setMode4()

    -- if true then 
    --     self:setMode2()
    --     return 
    -- end 
    
    self.mode = 4

    self.root.big_title_node2.Button_2:setVisible(false)
    self.root.big_title_node2.Button_3:setVisible(false)

    self:cleanNode()

    self.tabControl2:setSelectedIdx(3)
    self:onTabButtonChanged(3)

    self.root.big_title_node2:setVisible(true)
    -- self.root.big_title_node:setVisible(false)

    self.hero_title:setString(luaCfg:get_local_string(10361))

    self.Node3.hero_title_bg_1:setVisible(true)
end

function UIHeroPanel:setMode1()
    
    self.mode = 1

    self.root.big_title_node2.Button_2:setVisible(true)
    self.root.big_title_node2.Button_3:setVisible(true)
    self.no_hero:setVisible(false)

    self.root.big_title_node2:setVisible(true)
    -- self.root.big_title_node:setVisible(false)
    
    self.hero_title:setString(luaCfg:get_local_string(10361))

    self.Node3.hero_title_bg_1:setVisible(true)

    self.tabControl2:setSelectedIdx(1)
    self:onTabButtonChanged(1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroPanel:checkRecuritRedPoint()
    self.But2spReadState:setVisible(global.userData:getFreeLotteryCount() <= 0)
    -- self.But5spReadState:setVisible(global.userData:getDyFreeLotteryCount() <= 0)
    self.But4spReadState:setVisible(global.userData:getFreeLotteryCount() <= 0 ) -- or global.userData:getDyFreeLotteryCount() <= 0)
    global.funcGame:checkAnyHeroCanBeContion(function(isShow)
        if global.userData:getFreeLotteryCount() > 0 then -- and global.userData:getDyFreeLotteryCount() > 0 then
            self.But4spReadState:setVisible(isShow)
        end 
    end, true)
end

function UIHeroPanel:checkCanPersuadePoint()

    self.But3spReadState:setVisible(false)
    local knowHeroData = global.heroData:getHeroDataInCome() or {}
    local serverData = knowHeroData.serverData

    if serverData then
        local contentTime = global.dataMgr:getServerTime()
        local persuadeTime = global.heroData:getPersuadeTime()
        local m_restTime = persuadeTime - contentTime
        if persuadeTime == 0 then
            m_restTime = 0
        end
        if m_restTime == 0 then
            self.But3spReadState:setVisible(true)
        end
    end
end

function UIHeroPanel:onEnter()
    
    self:checkRecuritRedPoint()
    self:addEventListener(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES , function () 
        if self.checkRecuritRedPoint then
            self:checkRecuritRedPoint()
        end        
    end)
    self:addEventListener(global.gameEvent.EV_ON_HERO_FREE , function () 
        if self.checkRecuritRedPoint then
            self:checkRecuritRedPoint()
        end        
    end)

    self:checkCanPersuadePoint()
    global.netRpc:addHeartCall(function ()
        if self.checkCanPersuadePoint then
            self:checkCanPersuadePoint()
        end
    end , self)

    self.chooseHeroData = nil
    self.chooseHeroData_clone = nil
        
    self:cleanNode()

    self:addEventListener(gameEvent.EV_ON_UI_HERO_FLUSH,function()


        if self.contentIndex then 
            
            if self.contentIndex  == 2 then 
                self.old = true  --table view 停留在原位置
            else 
                self.old = false 
            end 

            self:onTabButtonChanged(self.contentIndex,true)
        end 
    end)

    -- local nodeTimeLine = resMgr:createTimeline("hero/Interface_node_2")    
    -- self.Node2:stopAllActions()
    -- self.Node2:runAction(nodeTimeLine)

    -- nodeTimeLine:play("animation0",true)

    self:cleanEffect()

    global.gmApi:effectBuffer({{lType = 13 , lBind = nil }},function(msg)
        if msg  and msg.tgEffect and msg.tgEffect[1] and msg.tgEffect[1].tgEffect and msg.tgEffect[1].tgEffect[1] and msg.tgEffect[1].tgEffect[1].lVal then 
            global.heroData:setBuffAddNum(msg.tgEffect[1].tgEffect[1].lVal )
            self.number_2:setString(global.heroData:getMaxHeroNum())
        end
    end)

    -- 注册滑动监听
    self:registerMove()

end



----------------  滑动监听 --------------------------

function UIHeroPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
local beganPos = cc.p(0,0)
local isMoved = false
function UIHeroPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    if CCHgame.setNoTouchMove then
        CCHgame:setNoTouchMove(self.ScrollHero, true)
    end
    return true
end
function UIHeroPanel:onTouchMoved(touch, event)

    isMoved = true
    if self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        CCHgame:setNoTouchMove(self.ScrollHero, false)
    else
        CCHgame:setNoTouchMove(self.ScrollHero, true)
    end
end

function UIHeroPanel:onTouchEnded(touch, event)

    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isMove = true 
    else
        self.isMove = false
    end
end

function UIHeroPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

----------------  滑动监听 --------------------------





function UIHeroPanel:cleanNode()
   
    for i = 1,3 do
        self["isNodeInit"..i] = false
    end 
end

function UIHeroPanel:cleanEffect()
    
    for i = 1,6 do

        self["equipment_bg"..i]:removeChildByTag(98)
    end

    for i = 1,4 do

        local key = WCONST.BASE_PROPERTY[i].KEY
        local parentText = self[key.."_buff"]  

        parentText:getParent():removeChildByTag(98) 
    end
end

function UIHeroPanel:initNode1()
    self.recruitHeroNum = 0
    self.itemSwitch = {}
    self.ScrollHero:removeAllChildren()

    local  recruitHero = global.heroData:getGotHeroData()

    print(self.mode , "self.mode")
    print( self.tabControl2:getSelectedIdx() , " self.tabControl2:getSelectedIdx()")

    print(#recruitHero,"recruitHero.////////////")


    if #recruitHero == 0 then  --鍒囨崲鍒�2涔熷崱妯″紡

        -- if self.root.big_title_node2:isVisible() == false then

            self.tabControl2:setSelectedIdx(2)
            self:onTabButtonChanged(2)
            self.root.big_title_node2:setVisible(true)
            -- self.root.big_title_node:setVisible(false)
        -- end

        return 
    else

    end

    table.sort(recruitHero , function (a , b ) 
        return a.serverData.lPower > b.serverData.lPower
    end) 
    
    local i = 1
    local sW = self.item_layout:getContentSize().width
    for _,v in pairs(recruitHero) do
        
        local item = UIHeroListItem.new()
        item:setPosition(cc.p((sW*0.8+4)*(i-1), 32))
        item:setData(v)
        item:flushResPoint(v)
        item.btnBg:setTag(1090 + i)
        item:setScale(0.8)
        table.insert(self.itemSwitch, item)
        item:setCallBackFunc(handler(self, self.heroItemCallBack), self.itemSwitch, false)
        self.ScrollHero:addChild(item)
        i = i + 1
    end
    
    self.recruitHeroNum = #recruitHero
    self.ScrollHero:setInnerContainerSize(cc.size((#recruitHero)*(sW*0.8+4), self.ScrollHero:getContentSize().heigh))
    
    self.number_1:setString(#recruitHero)
    self.number_2:setString(global.heroData:getMaxHeroNum())

    if #recruitHero <= 3 then
        self.btn_left:setEnabled(false)
        self.btn_right:setEnabled(false)
    else
        self.btn_left:setEnabled(false)
        self.btn_right:setEnabled(true)
    end

    -- --  榛樿宸叉嫑鍕熻嫳闆�
    -- if #self.itemSwitch > 0 then
        
    -- end

    local selectHeroId = 0
    local curStep = global.guideMgr:getCurStep() or 0
    if global.guideMgr:isPlaying() and curStep == 915 then
        selectHeroId = 8111
    end

    if #recruitHero > 0 then

        if self.chooseHeroData == nil and selectHeroId == 0 then
            
            self:setHeroDetail(recruitHero[1])   
            self.itemSwitch[1].select_bg:setVisible(true)
        else

            local heroId = selectHeroId ~= 0 and selectHeroId or self.chooseHeroData.heroId 
            for i,v in ipairs(recruitHero) do
                
                if v.heroId == heroId then

                    self:setHeroDetail(v)           
                    self.itemSwitch[i].select_bg:setVisible(true)

                    local idx = i
                    local idxPer = idx/self.recruitHeroNum*100
                    if idx <=5 then 
                        idxPer = 0
                    elseif idx >=(self.recruitHeroNum-5) then 
                        idxPer = 100
                    end
                    self.ScrollHero:jumpToPercentHorizontal(idxPer)

                end
            end        
        end        
    end
end

function UIHeroPanel:onExit()
    self.isMove = false
    self.old = false 
    -- self.isNode1Out = true
    self:cleanTimer()

    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end

    global.netRpc:delHeartCall(self)

end

function UIHeroPanel:showEquipEffect(data,tmpHeroData,newHeroData,isRemove)
    
    if not isRemove then
        
        local effect = resMgr:createCsbAction("effect/equipment_light", "animation0", false, true)
        effect:setPosition(cc.p(176 / 2,176 / 2))
        effect:setScale(1 / 0.6)
        effect:setTag(98)
        self["equipment_bg"..data.confData.type]:addChild(effect)

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipHero")
    end    

    for i = 1,4 do

        local key = WCONST.BASE_PROPERTY[i].KEY
        local text = ccui.Text:create()        
        text:setTag(98)
        local parentText = self[key.."_buff"]        
        local cutNum = tmpHeroData.serverData.lextra[i] - newHeroData.lextra[i]

        if cutNum ~= 0 then
            
            if isRemove then
            
                text:setString(string.format("-%s",cutNum))        
                text:setTextColor(cc.c3b(180,29,11))
            else
                
                cutNum = -cutNum
                text:setString(string.format("+%s",cutNum))        
                text:setTextColor(parentText:getTextColor())
            end        
           
            text:setAnchorPoint(cc.p(0,0.5))
            text:setPositionY(parentText:getPositionY() + 4)
            text:setPositionX(5 + parentText:getPositionX() + #("+"..newHeroData.lextra[i]) / 2 * 20)        
            text:setFontSize(20)
            parentText:getParent():addChild(text)
            parentText:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1.05),cc.DelayTime:create(0.1),cc.ScaleTo:create(0.3,0.9),cc.ScaleTo:create(0.3,1)))
            text:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseInOut:create(cc.MoveBy:create(1.5,cc.p(0,20)),5),cc.RemoveSelf:create()))
            text:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.FadeOut:create(0.75)))
        end        
    end    

    --text,from,to,time,formatCall,callFunc,updateCall
    -- TextScrollControl.startScroll(self.txt_power,newHeroData.lPower,1)
end

function UIHeroPanel:heroItemCallBack(data)
    self:setHeroDetail(data) 
end

function UIHeroPanel:setHeroDetail( data )
    
    -- dump(data,'.....data')

    self.isCanSuitFirst = false

    -- print("ui hero panel set hero detail panel",debug.traceback())

    self.chooseHeroData = data    

    self.hero_name:setString(data.name)
    self.hero_type:setString(data.type)
    self.hero_grow:setString(data.grow1)     
    -- self.hero_icon:setSpriteFrame(data.nameIcon)  
    global.panelMgr:setTextureFor(self.hero_icon,data.nameIcon) 

    -- self.icon:setPositionX(self.hero_name:getContentSize().width + self.hero_name:getPositionX() + 2) 
    -- self.txt_power:setPositionX(self.hero_name:getContentSize().width + self.hero_name:getPositionX() + 47) 

    local serverData = data.serverData

    if self.chooseHeroData_clone and data.heroId == self.chooseHeroData_clone.heroId then        
        TextScrollControl.startScroll(self.txt_power,data.serverData.lPower,1)
    else        
        TextScrollControl.stopScroll(self.txt_power)
        self.txt_power:setString(serverData.lPower)
    end    
    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)
      

    -- self.txt_power:setString(serverData.lPower)    
    self.hero_Lv:setString(serverData.lGrade) 
    -- self.hero_HP:setString(serverData.lCurHP .. "/" .. data.hp) 
    -- self.strengthBuy:setEnabled(not (serverData.lCurHP >= data.hp))
   
    -- if serverData.lCurHP >= data.hp then self.strengthBuy:setTag(1) else self.strengthBuy:setTag(0) end
    -- self.strengthBuy:setPositionX(self.hero_HP:getContentSize().width + 134)

    self.expNode:setData(serverData)

    local hero_strengthen = luaCfg:get_hero_strengthen_by(data.heroId)
    local max = hero_strengthen.maxStep
    self.curXing = nil
    for i = 1,6 do
        local star = self['xing' .. i] 
        star:setVisible(i <= max)
        global.colorUtils.turnGray(star, i > serverData.lStar )
        if i == serverData.lStar + 1 then
            self.curXing = star
        end
    end
    self.hero_grow:setString(hero_strengthen['step' .. serverData.lStar])        

    self.FileNode_1:setData(data)

    -- self.hero_exp1:setString(serverData.lCurEXP) 

    -- if serverData.lGrade >= global.heroData:getHeroMaxLevel() then

    --     self.hero_exp2:setString(luaCfg:get_local_string(10336)) 
    -- else.

        
    --     self.hero_exp2:setString(luaCfg:get_hero_exp_by(serverData.lGrade).exp)    
    -- end

    
    for i = 1,4 do

        local key = WCONST.BASE_PROPERTY[i].KEY
        local base = data[key]
        self["hero_"..key]:setString(serverData.lbase[i])
        self[key.."_buff"]:setString(string.format("+%s",serverData.lextra[i]))

        if serverData.lextra[i] == 0 then

            self[key.."_buff"]:setVisible(false)  
        else  
            self[key.."_buff"]:setVisible(true)  
        end

        if i == 4 then

            self.hero_Commander:setString(global.heroData:getCommanderStr(data))
            -- self["hero_"..key]:setPositionX(self.hero_Commander:getContentSize().width + 12)
        end

        self[key.."_buff"]:setPosition(cc.p(5 +self["hero_"..key]:getContentSize().width + self["hero_"..key]:getPositionX() + self[key.."_buff"]:getContentSize().width / 2,11))        
  

    

    end

    -- self.hero_attack:setString(serverData.) 
    -- self.hero_defense:setString(serverData.lbase[2]) 
    -- self.hero_interior:setString(serverData.lbase[3]) 
    -- self.hero_Commander:setString(serverData.lbase[4])    

    for i = 0,5 do

        self["skill_" .. i]:setData(i + 1,data)
    end
    -- for _,v in pairs(serverData.lSkill) do
    --     local skill = luaCfg:get_hero_skill_by(v)
    --     if skill then
    --         self["Skill_"..i]:setSpriteFrame(skill.icon)
    --         i = i + 1
    --     end
    -- end
    -- for k=(#data.skill+1), 6 do
    --     self["Skill_"..k]:setVisible(false)
    -- end

    local equips = equipData:getHeroEquips(self.chooseHeroData.heroId)
    for i,v in ipairs(equips) do

        local bg = self["equipment_bg"..i]
        local icon = self["icon"..i]
        local light = self['light'..i]
        local strongText = bg.strog_export
        icon:getParent():stopAllActions()
        icon:getParent():setOpacity(255)

        bg.up_point:setVisible(false)

        if v ~= -1 then

            local eData = equipData:getEquipById(v)
            local confData = eData.confData--luaCfg:get_equipment_by(eData.lGID)

            strongText:setString(":" .. eData.lStronglv)    
            strongText:setVisible(eData.lStronglv > 0)

            local isBetter = equipData:isHaveBetterOneCanSuit(self.chooseHeroData,eData.lCombat,i)
            if isBetter then

                bg.up_point:setVisible(true)
            end

            bg["Sprite_"..i]:setVisible(false)
            -- bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",confData.quality))
            global.panelMgr:setTextureFor(bg,string.format("icon/item/item_bg_0%d.png",confData.quality))
            -- icon:loadTextureNormal(confData.icon, ccui.TextureResType.plistType)
            -- icon:loadTexturePressed(confData.icon, ccui.TextureResType.plistType)
            global.panelMgr:setTextureFor(icon,confData.icon)
            icon:setVisible(true)

            global.funcGame:initEquipLight(light,eData.lStronglv)
        else            
            light:setVisible(false)
            strongText:setVisible(false)

            bg:setSpriteFrame("ui_surface_icon/hero_equipment_bg.png")
            bg["Sprite_"..i]:setVisible(true)
            local state = equipData:getHeroEquipState(self.chooseHeroData,i)
            icon:setVisible(true)            

            --查询是否有可以装备的道具 0->没有对应装备 1->有装备但是不能装备 2->有可以装备的装备
            if state == 0 then

                icon:setVisible(false)
            elseif state == 1 then

                icon:getParent():runAction(cc.RepeatForever:create(cc.Sequence:create(cc.EaseInOut:create(cc.Sequence:create(cc.FadeTo:create(1, 30),cc.FadeTo:create(1, 255)),1),cc.DelayTime:create(0))))
                icon:loadTextureNormal("ui_button/add_yellow_btn.png", ccui.TextureResType.plistType)
                icon:loadTexturePressed("ui_button/add_yellow_btn.png", ccui.TextureResType.plistType)
            elseif state == 2 then

                if i == 1 then
                    self.isCanSuitFirst = true
                end

                icon:getParent():runAction(cc.RepeatForever:create(cc.Sequence:create(cc.EaseInOut:create(cc.Sequence:create(cc.FadeTo:create(1, 30),cc.FadeTo:create(1, 255)),1),cc.DelayTime:create(0))))
                -- icon:getParent():runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(0.5, 50),cc.DelayTime:create(1),cc.FadeTo:create(0.5, 255),cc.DelayTime:create(1))))
                icon:loadTextureNormal("ui_button/add_green_btn.png", ccui.TextureResType.plistType)
                icon:loadTexturePressed("ui_button/add_green_btn.png", ccui.TextureResType.plistType)
            end
        end
    end

    self.chooseHeroData_clone = clone(data)


    -- 文本跟随处理
    global.tools:adjustNodePosForFather(self.hero_Commander:getScrollText():getParent(),self.hero_Commander:getParent(),0,self.orginPosX)
    global.tools:adjustNodePosForFather(self.hero_Lv:getParent(),self.hero_Lv,0,self.orginPosX)
    global.tools:adjustNodePosForFather(self.hero_type:getParent(),self.hero_type,0,self.orginPosX)
    global.tools:adjustNodePosForFather(self.hero_grow:getParent(),self.hero_grow,0,self.orginPosX)

    for i = 1,4 do
        local gap = 0
        local key = WCONST.BASE_PROPERTY[i].KEY
        if serverData.lextra[i] ~= 0 then
            gap = self[key.."_buff"]:getContentSize().width + 10
        end 
        global.tools:adjustNodePosForFather(self["hero_"..key]:getParent(), self["hero_"..key], gap, self.orginPosX)
        self[key.."_buff"]:setPosition(cc.p(5 +self["hero_"..key]:getContentSize().width + self["hero_"..key]:getPositionX() + self[key.."_buff"]:getContentSize().width / 2,11))        
    end


end

function UIHeroPanel:sortVipHero(data)

    local temp_all =  {}
    local acquire = {}   -- 已经获得的英雄 
    local UNacquire = {} -- 还未获得英雄

    for _ ,v in pairs(data) do 

        if v.serverData and  v.serverData.lState ~= nil and v.serverData.lState ~= - 1 then 

            table.insert(acquire , v )
        else 

            table.insert(UNacquire , v )
        end 
    end

    table.sort(acquire , function(A , B ) return A.order < B.order  end )
    table.sort(UNacquire , function(A , B ) return A.order < B.order  end )


    -- dump(acquire , "acquire hero >>>>>>>> ")

    for _ ,v in  pairs(acquire) do 
        table.insert(temp_all , v )
    end 

    for _ ,v in  pairs(UNacquire) do 
        table.insert(temp_all , v )
    end

    return temp_all
end

function UIHeroPanel:initNode2()

    -- local heroProperty = luaCfg:hero_property()
    
    -- dump(heroProperty,'heroProperty')

    -- local tempData = heroProperty
    -- for _,v in pairs(heroProperty) do
    --     table.insert(tempData,v)
    -- end

    -- dump(tempData,'tempData')

    -- table.sortBySortList(tempData,{{'order','min'}})

    self:onTabButtonChangedOnHero(1)

    self.tabControlForHero:setSelectedIdx(1)
end

-- function UIHeroPanel:initNode2()    

--     -- print("换装备 //////////////////？？？")

--     -- self.ScrollView_2:removeAllChildren()

--     -- local all_hero = { }

--     -- for _ ,v in pairs(global.heroData:getVipHeroData() ) do 
--     --     table.insert(all_hero , v )
--     -- end 
--     -- for _ ,v in pairs(global.heroData:getNormalHeroData() ) do 
--     --     -- table.insert(all_hero , v )
--     -- end 

--     -- local pX, pY = self.heroItem_layout:getPosition()
--     -- local pW = self.heroItem_layout:getContentSize().width
--     -- local pH = self.heroItem_layout:getContentSize().height

--     -- local sHeight = gdisplay.height - self.layout_title:getContentSize().height
--     -- local contentSize = 0
--     -- local containerSize = pH*(math.ceil(#all_hero/3))

--     -- if self.mode == 3 then        
--     --     pY = pY + 75
--     --     contentSize = sHeight + 75        
--     -- else
--     --     contentSize = sHeight
--     -- end
--     -- if contentSize > containerSize then
--     --     containerSize = contentSize
--     -- end
    
--     -- self.ScrollView_2:setContentSize(cc.size(gdisplay.width, contentSize))
--     -- self.ScrollView_2:setInnerContainerSize(cc.size(gdisplay.width,containerSize))

--     -- local y = containerSize - pH 

--     -- self:setTableViewData(all_hero)

--     -- --倒计时
--     -- local PersuadeData =  global.heroData:getPersuadeData()

--     -- if PersuadeData and PersuadeData.lStartTime then 

--     --     self.time:setVisible(true)
--     --     self.persuade:setVisible(false)

--     --     if self.m_countDownTimer then
--     --     else
--     --         self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.cutTimeHandler), 1)
--     --     end
        
--     --     self:cutTimeHandler()
--     -- else 

--     --     self:cleanTimer()
--     --     self.time:setVisible(false)
--     --     self.persuade:setVisible(true)
--     -- end 

-- end


function UIHeroPanel:setTableViewData(data)

    local y = self.tableView:getContentOffset().y


    local inited = (self.tableView.__tableData and table.nums(self.tableView.__tableData)  > 0 )

    self.tableView:setData({})

    local temp_all =  {}
    local acquire = {}   -- 已经获得的英雄 
    local UNacquire = {} -- 还未获得英雄

    for _ ,v in pairs(data) do 

        if v.serverData and v.serverData.lState ~= - 1 then 

            table.insert(acquire , v )
        else 

            table.insert(UNacquire , v )
        end 
    end

    table.sort(acquire , function(A , B ) return A.order < B.order  end )
    table.sort(UNacquire , function(A , B ) return A.order < B.order  end )


    for index ,v in pairs(acquire) do -- 标记倒数 三 个 隐藏  chain

        if index > #acquire -3   then 

            v.hidechain = true 
        else 

            v.hidechain=  false 
        end  
    end 

    for index ,v in pairs(UNacquire) do  -- 标记倒数 三 个 隐藏  chain
        
        if index > #UNacquire - 3   then 

            v.hidechain = true 
        else 
            
            v.hidechain=  false 
        end  
    end 

    local number = math.ceil( #acquire / 3 )  --已经获得英雄 层级数量
    
    for  i = 1,  number * 3  -  #acquire  do 

        table.insert(acquire , {fake = true })
    end


    for  i = 1,   math.ceil( #UNacquire / 3 ) * 3  - #UNacquire  do 

        table.insert(UNacquire , {fake = true })
    end 


    local allHeroData= {}

    for index ,v in  pairs(acquire) do 
        table.insert(temp_all , v )
    end 

    for index ,v in  pairs(UNacquire) do 
        table.insert(temp_all , v )
    end


    local grouping = {}

    for index  ,v in pairs(temp_all) do 

        table.insert(grouping , v)

        if  index % 3 == 0 then 

            table.insert(allHeroData , grouping)

            grouping =  {} 
        end  

    end 

    for index ,v in pairs(allHeroData) do 

        v.cellW = self.tb_item_content:getContentSize().width
        v.cellH = self.tb_item_content:getContentSize().height

        if index == number +  1  and number ~=0  then 
             v.cellH =  v.cellH  + 30 
        end

        if number == 0  and index ==1 then  -- 如果没有已获得的 hero  则  第一个 item  顶部显示 横幅
            v.topbanner = true 

            v.cellH =  v.cellH  +  50
        end 

        if index == number  and index~=#allHeroData then 

            v.bottombanner = true  -- 显示以招募英雄 横幅  
        end  

    end

    self.tableView:setData(allHeroData)

    if  self.old and #acquire > 0  and inited then  --简单处理一下 最后一个英雄解散之后  tableview 留在不正常位置。 

        self.tableView:setContentOffset(cc.p(0,y))
    end 

    self.old = false 

    self.heroData  = allHeroData

end 


function UIHeroPanel:GpsHero(heroId)

    if not self.heroData  then return end 

    local index = 1 

    for k ,v in pairs(self.heroData) do 
        for i= 1 , 3  do 
            if v[i] and  heroId == v[i].heroId then 
                index = k 
            end 
        end 
    end

    self.tableView:jumpToCellYByIdx(#self.heroData - index + 1 , true )


    for k , v in pairs(self.tableView:getCells()) do 
        for i= 1 , 3  do 
            if v.tv_target and v.tv_target.item and v.tv_target.item.data  and v.tv_target.item.data[i] and  v.tv_target.item.data[i].heroId == heroId  then 

               local world_y =  v.tv_target.item:convertToWorldSpace((cc.p(0,0))).y 
             
                local yy = gdisplay.height / 2 - world_y - self.tableView.__cellSize.height/2  +self.tableView:getContentOffset().y
                if yy  > 0 then 
                    yy = 0 
                end 

                if yy < -(self.tableView:getContentSize().height - self:Test()) then 
                    yy=  -(self.tableView:getContentSize().height - self:Test())
                end 

                self.tableView:setContentOffset(cc.p(0, yy- 30 ))
            end 
        end
    end 
end 

function UIHeroPanel:Test()

    return self.tb_top_node:getPositionY() -  self.tb_bottom_node:getPositionY()      
end 

function UIHeroPanel:cutTimeHandler()

    if  not  global.heroData:getPersuadeData() or  not  global.heroData:getPersuadeData().lStartTime then 
        self:cleanTimer()
        return 
    end 

    local curTime = global.dataMgr:getServerTime()

    local time =  global.heroData:getPersuadeData().lStartTime +  global.heroData:getPersuadeData().lTotleTime - curTime

    if  time > 1 then 

        self.overtime_text:setString(global.funcGame.formatTimeToHMS(time))

    end 
    global.tools:adjustNodePosForFather(self.overtime_text:getParent(),self.overtime_text)
end

function UIHeroPanel:cleanTimer()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end

end 

function UIHeroPanel:initNode4(isCallByEvent)
    local knowHeroData = global.heroData:getHeroDataInCome()
    -- dump(knowHeroData,'knowHeroData')
    self.heroCome:setData(knowHeroData)

    gevent:call(global.gameEvent.GOTOHEROMODE4)
end

function UIHeroPanel:initNode3(isCallByEvent)

    -- self.ScrollView_3:removeAllChildren()
    -- local normalHeroData = {}
    local normalHeroData = global.heroData:getAllCanContionHero()

    local targetIds = {}
    for i,v in ipairs(normalHeroData) do
        table.insert(targetIds,v.condition)
    end

    global.techApi:conditSucc(targetIds, function (msg)        

        for i,v in ipairs(msg.tgInfo) do            
            normalHeroData[i].isGetTarget = {lCur = v.lCur,lMax = v.lMax} -- (v.lCur / v.lMax)            
        end        

        if not tolua.isnull(self.tableview_3) then
            self.tableview_3:setData(normalHeroData,isCallByEvent == true)
        end
    end)

    -- local pos_4 = nil

    -- if global.heroData:isCanBuy() then
    --     pos_4 = {139,286,433,581}
    -- else
    --     pos_4 = {-1,169,361,548}
    -- end

    -- for index,posX in ipairs(pos_4) do
    --     local child = self.node3_bottom['But' .. index]
    --     child:setVisible(posX ~= -1 and index ~= 1)
    --     child:setPositionX(posX)  
    -- end

    -- local i = 0
    -- local pH = self.normalHero_layout:getContentSize().height

    -- local sHeight = gdisplay.height - self.layout_title:getContentSize().height
    -- local contentSize = gdisplay.height - 307
    -- local containerSize = (#normalHeroData)*pH

    -- if contentSize > containerSize then
    --     containerSize = contentSize
    -- end

    -- self.ScrollView_3:setContentSize(cc.size(gdisplay.width, contentSize))
    -- self.ScrollView_3:setInnerContainerSize(cc.size(gdisplay.width,  containerSize))
    -- local pY = containerSize - pH
    
    -- for k,v in pairs(normalHeroData) do
    --     local heroItem =  UICommonHeroItem.new()
    --     heroItem:setPosition(cc.p(0, pY-pH*i))
    --     heroItem:setAnchorPoint(cc.p(0, 0))
    --     heroItem:setData(v)
    --     self.ScrollView_3:addChild(heroItem)
    --     i = i+1
    -- end


end

function UIHeroPanel:onTabButtonChangedOnHero(index)
    

    local tempData = nil
    
    if index == 1 then
        tempData = global.heroData:getAllHero()
    elseif index == 2 then
        tempData = global.heroData:getAllNormalHero()
    elseif index == 3 then
        tempData = global.heroData:getAllEpicHero()
    elseif index == 4 then
        tempData = global.heroData:getAllBigEpicHero()
    end
    
    local counts = #tempData

    local count1 = 0
    for _,data in ipairs(tempData) do
        if data.state == 1 or data.state == 3 or data.state == 4 then
            count1 = count1 + 1
        end
    end

    self.percentage:setString(count1 .. '/' .. counts)
    self.ing:setString(string.format('%.2f%%',count1 / counts * 100))
    self.ing_par:setPositionX(384 - self.ing:getContentSize().width)
    self.tableview_gird:setData(tempData)
end

function UIHeroPanel:onTabButtonChanged(index,isCallByEvent)

    if not index then return end 
    self.contentIndex = index
    if index == 3 then 
        global.funcGame:cleanContionTag()
        gevent:call(global.gameEvent.EV_ON_HERO_FREE)
    end

    if index == 1 then

        -- if (not (isCallByEvent == true)) and self.isNode1Out then
        --     self.isNode1Out = true
        --     self.incall:runAction(cc.RotateTo:create(0,0))
        --     self.node1_parent:setPositionX(-190)
        --     self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(0,0)),2))
        --     self.left_modal:runAction(cc.FadeIn:create(0.35))
        --     self.left_modal:setTouchEnabled(true)
        -- end        

        global.delayCallFunc(function()
            gevent:call(global.gameEvent.EV_ON_GUIDE_HERO_PANEL_2)
        end,nil,0)
    end

    for k,v in ipairs(self.nodeSwitch) do
        if k == index then
            v:setVisible(true)
            if self["ScrollView_"..index] then
                self["ScrollView_"..index]:jumpToTop() 
            end 
        else
            v:setVisible(false)
        end        
    end
    
    self["initNode"..index](self, isCallByEvent)
    self["isNodeInit"..index] = true

    self:adjusUI()
end

function UIHeroPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIHeroPanel")  
end


function UIHeroPanel:left_click(sender, eventType)
   
    local container = self.ScrollHero:getInnerContainer()
    local  isEnoughOneItem, scroX, sW = self:checkEnoughOneItem(0)
    if isEnoughOneItem > 1 then
        local moveAction = cc.MoveTo:create(0.3, cc.p(scroX+sW, self.ScrollHero:getInnerContainerPosition().y))
        container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
        self.btn_right:setEnabled(true)

    else
        self.ScrollHero:scrollToPercentHorizontal(0, 1, true)
        self.btn_left:setEnabled(false)
    end
end

function UIHeroPanel:right_click(sender, eventType)

    local container = self.ScrollHero:getInnerContainer()
    local  isEnoughOneItem, scroX, sW  =  self:checkEnoughOneItem(1)
    if isEnoughOneItem > 1 then
        local moveAction = cc.MoveTo:create(0.3, cc.p(scroX-sW, self.ScrollHero:getInnerContainerPosition().y))
       container:runAction(cc.Spawn:create(cc.EaseSineOut:create(moveAction)))
       self.btn_left:setEnabled(true)

    else
        self.ScrollHero:scrollToPercentHorizontal(100, 1, true)
        self.btn_right:setEnabled(false)
    end

end

function UIHeroPanel:checkEnoughOneItem( _dirction )
    
    local isEnoughOneItem = 0
    local sW = self.item_layout:getContentSize().width
    local scroWidth = self.ScrollHero:getContentSize().width
    local totalWidth =  self.recruitHeroNum*sW
    local scroX =  self.ScrollHero:getInnerContainerPosition().x

    if _dirction == 0 then
        isEnoughOneItem = math.floor(math.abs(scroX)/180)
    else
        isEnoughOneItem = math.floor((totalWidth - math.abs(scroX) - scroWidth)/180)
    end
    return isEnoughOneItem, scroX, sW
end

function UIHeroPanel:equipItem_click(index,icon)
    
    if self.isMove then return end
    
    local heroId = self.chooseHeroData.heroId
    local tmpHeroData = self.chooseHeroData

    local equipId = equipData:getHeroEquipByIndex(self.chooseHeroData.heroId,index)
    if equipId == -1 then

        global.panelMgr:openPanel("UIEquipPanel"):setData(index,self.chooseHeroData.heroId)
            :setEquipInfo(true, 10392,false,function(data)
                
                global.itemApi:swapEquip(0,data.lID,heroId,index,function(msg)
            
                    global.panelMgr:getPanel("UIHeroPanel"):showEquipEffect(data,tmpHeroData,msg.tgHero[1])
                    global.panelMgr:closePanel("UIEquipPanel")
                    global.heroData:updateVipHero(msg.tgHero[1])            
                end)
        end) 
    else
   
        global.panelMgr:openPanel("UIEquipPutDown"):setData(equipData:getEquipById(equipId))
            :setEquipInfo(true,10393,true,function(data)
            
                if global.equipData:isEquipLimit() then
                    
                    global.tipsMgr:showWarning("equipFull")
                else
                    global.itemApi:swapEquip(1,data.lID,heroId,index,function(msg)
                        if msg and msg.tgHero and msg.tgHero[1] then
                            gevent:call(gsound.EV_ON_PLAYSOUND,"patch_new_1")
                            global.panelMgr:getPanel("UIHeroPanel"):showEquipEffect(data,tmpHeroData,msg.tgHero[1],true)
                            global.panelMgr:closePanel("UIEquipPutDown")
                            global.heroData:updateVipHero(msg.tgHero[1])         
                        end   
                    end)
                end            
            end)
    end    
end

function UIHeroPanel:skillItem_click(sender, eventType)
    
    if self.isMove then return end
    global.tipsMgr:showWarning("HeroSkill")
end


function UIHeroPanel:giveUpHero(sender, eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("LayoffHero", function()
       
        local heroID = self.chooseHeroData.heroId
        global.commonApi:heroAction(heroID, 4, 0, 0, 0, function(msg)
        
            self.chooseHeroData = nil
            global.heroData:updateVipHero({lID = heroID,lState = -2})
        end) 
    end)    
end

function UIHeroPanel:showEffectForStarUp(openSkillIndex)
    
    global.uiMgr:addSceneModel(1.5)

    local csb = resMgr:createCsbAction('effect/hero_sj_star', 'animation0',false,true)        
    csb:setPosition(self.curXing:convertToWorldSpace(cc.p(24,24)))  
    global.scMgr:CurScene():addChild(csb,30)

    if openSkillIndex ~= -1 then

        local skill = self['skill_' .. openSkillIndex - 1]

        self:runAction(cc.Sequence:create(cc.DelayTime:create(1 / 60),cc.CallFunc:create(function()
            global.colorUtils.turnGray(skill,true)
        end),cc.DelayTime:create(0.65),cc.CallFunc:create(function()
            global.colorUtils.turnGray(skill,false)
            csb = resMgr:createCsbAction('effect/hero_sj_skill', 'animation0',false,true)        
            csb:setPosition(skill:convertToWorldSpace(cc.p(0,0)))  
            global.scMgr:CurScene():addChild(csb,30)
        end)))        
    end    
end

function UIHeroPanel:addEnergy_click(sender, eventType)

    if sender:getTag() == 1 then
        global.tipsMgr:showWarning("FullHp")
    return
    end

    local heroID = self.chooseHeroData.heroId
    local panel = global.panelMgr:openPanel("UISpeedPanel")
    panel:setData(nil, 0, panel.TYPE_HERO_AGE, heroID)
end

function UIHeroPanel:infoCall(sender, eventType)
    
    local data = luaCfg:get_introduction_by(17)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIHeroPanel:shareHandler(sender, eventType)

    local shareData = {}
    shareData.serverData =clone(self.chooseHeroData.serverData)

    shareData.serverData.lbase = nil

    local itemCount = self.FileNode_1:getCurCount()

    dump(self.chooseHeroData)

    local equips = equipData:getHeroEquips(self.chooseHeroData.heroId)
    local equipData = {}

    for index,v in ipairs(equips) do
        if v ~= -1 then
            local eData = global.equipData:getEquipById(v)   
            equipData[index] = {}
            table.insert(equipData[index], eData.lGID)      
            table.insert(equipData[index], eData.lStronglv)  
        end
    end

    shareData.equipData = equipData
    shareData.itemCount = itemCount

    -- dump(shareData,"shareData")

    local tagSpl = {}
    tagSpl.lKey = 4
    tagSpl.lValue = 0
    tagSpl.szParam = ""    
    tagSpl.szInfo = vardump(shareData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.szInfo = string.gsub(tagSpl.szInfo,' ','')
    tagSpl.lTime = 0    

    local heroId = self.chooseHeroData.heroId

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl , function () 

        if not global.ActivityData:getActivityById(72001) then return end 

        local activity_data =  global.ActivityData:getActivityById(72001).serverdata

        if activity_data and activity_data.lStatus  and activity_data.lStatus == 1  then 

            global.PushInfoAPI:sendClientLanguage(heroId , function (msg) 

                    dump(msg  ,"response msg")

            end , 2 )   
        end 

    end)  

end

function UIHeroPanel:in_call(sender, eventType)
    
    -- if self.isNode1Out then
    --     self.isNode1Out = false
    --     self.node1_parent:stopAllActions()
    --     self.incall:runAction(cc.RotateTo:create(0.35,180))
    --     self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(-188,0)),2))
    --     self.left_modal:setTouchEnabled(false)
    --     self.left_modal:runAction(cc.FadeOut:create(0.35))
    -- else
    --     self.isNode1Out = true
    --     self.node1_parent:stopAllActions()
    --     self.incall:runAction(cc.RotateTo:create(0.35,0))        
    --     self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(0,0)),2))
    --     self.left_modal:setTouchEnabled(true)
    --     self.left_modal:runAction(cc.FadeIn:create(0.35))
    -- end    
end

function UIHeroPanel:quick_in_call(sender, eventType)

    self.isNode1Out = false
    self.node1_parent:stopAllActions()
    self.incall:runAction(cc.RotateTo:create(0.35,180))
    self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(-188,0)),2))
    self.left_modal:setTouchEnabled(false)
    self.left_modal:runAction(cc.FadeOut:create(0.35))
end

function UIHeroPanel:node2Btn1(sender, eventType)

    if _NO_RECHARGE then 
        return global.tipsMgr:showWarning("FuncNotFinish")
    end 
    
    global.panelMgr:openPanel('UIBuyHeroPanel'):gps()
end

function UIHeroPanel:node2Btn2(sender, eventType)
    
    local targetId = luaCfg:get_turntable_hero_cfg_by(1).open_lv
    local isUnlock = global.funcGame:checkTarget(targetId)
    if not isUnlock then
        local triggerData = luaCfg:get_target_condition_by(targetId)
        local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
        global.tipsMgr:showWarning(luaCfg:get_local_string(11141,triggerData.condition))
        return
    end
    global.panelMgr:openPanel('UITurntableHeroPanel')
end

function UIHeroPanel:node2Btn3(sender, eventType)
    global.panelMgr:openPanel('UITurntableHalfPanel')
end

function UIHeroPanel:node2Btn4(sender, eventType)
    global.panelMgr:openPanel("UIChangeShopPanel")
end

function UIHeroPanel:start1_game(sender, eventType)

end

function UIHeroPanel:onClickTaskHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIHeroPanel

--endregion
