--region UIMagicOwnPro.lua
--Author : untory
--Date   : 2016/12/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
local UICommonStars = require("game.UI.world.widget.UICommonStars")
--REQUIRE_CLASS_END

local UIMagicOwnPro  = class("UIMagicOwnPro", function() return gdisplay.newWidget() end )

function UIMagicOwnPro:ctor()
    
end

function UIMagicOwnPro:CreateUI()
    local root = resMgr:createWidget("wild/wild_miracle_occupy")
    self:initUI(root)
end

function UIMagicOwnPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_miracle_occupy")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.flag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.flag, self.root.Node_1.flag)
    self.stars = UICommonStars.new()
    uiMgr:configNestClass(self.stars, self.root.Node_1.stars)
    self.lord = self.root.Node_1.lord_mlan_6.lord_export
    self.league = self.root.Node_1.league_mlan_6.league_export
    self.league_boss = self.root.Node_1.league_boss_mlan_3.league_boss_export
    self.reward2 = self.root.Node_1.reward_mlan_8.reward2_export
    self.reward1 = self.root.Node_1.reward_mlan_8.reward1_export
    self.buff_desc = self.root.set_buff_view.buff_desc_export
    self.buff1 = self.root.set_buff_view.buff1_export
    self.buff2 = self.root.set_buff_view.buff2_export
    self.buff3 = self.root.set_buff_view.buff3_export
    self.buff4 = self.root.set_buff_view.buff4_export
    self.loadingbar_bg = self.root.set_buff_view.castle_num_mlan_5.loadingbar_bg_export
    self.loading = self.root.set_buff_view.castle_num_mlan_5.loadingbar_bg_export.loading_export
    self.hp = self.root.set_buff_view.castle_num_mlan_5.loadingbar_bg_export.hp_export
    self.star_up = self.root.star_up_export

    uiMgr:addWidgetTouchHandler(self.star_up, function(sender, eventType) self:star_up_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIMagicOwnPro:getRewardData(magicType)
    
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do

        if v.type == magicType then

            return v
        end
    end
end

function UIMagicOwnPro:getRewardPlus(miracleType,star)
    
    local rewards = luaCfg:miracle_upgrade()
    for  _,v in ipairs(rewards) do
        if v.type == miracleType and star == v.lv then
            return v
        end
    end

    return false
end

function UIMagicOwnPro:upStar()
    self.star = self.star + 1

    local rewardData = self:getRewardPlus(self.data.lType, self.star)
    self.stars:setData( self.star)

    for i=1,4 do
        self["buff"..i]:setVisible(false)
    end
    for i,v in ipairs(self.miracleRewardData.buff) do        
        self["buff"..i]:setVisible(true)
        self["buff"..i]:setString(global.buffData:getBuffStrBy({lID=v[1],lValue= math.ceil(v[2] * rewardData.upPro / 100)}))
    end

    self.star_up:setVisible(self.star < 10)
    self.plus = rewardData.upPro / 100
end

function UIMagicOwnPro:getPlus()
    return self.plus
end

function UIMagicOwnPro:setData(cfgData,data,city)

    local cfgData = self:getRewardData(data.lType)
    self.city = city
    if not cfgData then 
         -- protect 
        return 
    end 

    cfgData.lv = cfgData.lv or 0    

    local miracleRewardData = luaCfg:miracle_reward()
    for i,v in pairs(miracleRewardData) do
        if v.type == self.city:getType() then
            miracleRewardData = v
        end
    end
    self.buff_desc:setString(luaCfg:get_local_string(11037,miracleRewardData.member))
    
    self.miracleRewardData = miracleRewardData

    local star = city.data.sData.tagWildInfo.lCityLv
    self.star = star
    local rewardData = self:getRewardPlus(data.lType,star)
    self.stars:setData(star)

    for i=1,4 do
        self["buff"..i]:setVisible(false)
    end
    for i,v in ipairs(miracleRewardData.buff) do
        self["buff"..i]:setVisible(true)
        self["buff"..i]:setString(global.buffData:getBuffStrBy({lID=v[1],lValue= math.ceil(v[2] * rewardData.upPro / 100)}))
    end
    local member = self.city:getAllyCastleNum()
    self.loading:setPercent(member/miracleRewardData.member*100)
    self.hp:setString(string.format("%s/%s",member,miracleRewardData.member))
    self.plus = rewardData.upPro / 100

    local league1 = cfgData.league1
    local league1Cfg = luaCfg:get_data_type_by(league1[1])
    local league1count = league1[2]

    -- self.reward1:setString(string.format("%s:+%s%s",league1Cfg.paraName,league1count,league1Cfg.extra))
    self.reward1:setString(string.format("%s+%s%s",league1Cfg.paraName,league1count,league1Cfg.str))

    local league2 = cfgData.league2
    local league2Cfg = luaCfg:get_data_type_by(league2[1])
    local league2count = league2[2]

    -- self.reward2:setString(string.format("%s:+%s%s",league2Cfg.paraName,league2count,league2Cfg.extra))
    self.reward2:setString(string.format("%s+%s%s",league2Cfg.paraName,league2count,league2Cfg.str))
    
    self.lord:setString(data.szOccupyName)
    self.league:setString(global.unionData:getUnionShortName(data.szAllyName))
    self.league_boss:setString(data.szAllyLeader)
    -- self.league_num:setString(data.lAllyMember)
    -- self.lv:setString(data.lAllyLv)

    --设置旗帜
    self.flag:setData(data.lAllyTotem)

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.lord:getParent(),self.lord)
    global.tools:adjustNodePosForFather(self.league:getParent(),self.league)
    global.tools:adjustNodePosForFather(self.league_boss:getParent(),self.league_boss)
    global.tools:adjustNodePosForFather(self.reward1:getParent(),self.reward1)
    global.tools:adjustNodePosForFather(self.reward2:getParent(),self.reward2)

    -- global.tools:adjustNodePosForFather(self.star1:getParent(),self.star1)
    -- global.tools:adjustNodePos(self.star1,self.star2)
    -- global.tools:adjustNodePos(self.star2,self.star3)
    -- global.tools:adjustNodePos(self.star3,self.star4)

    self.data = data

    self.allyId = self.city.data.sData.tagCityOwner.lAllyID
    self.star_up:setVisible(global.unionData:isMineUnion(self.allyId) and star < 10)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN



function UIMagicOwnPro:star_up_call(sender, eventType)

    if not global.unionData:isLeader() then
        global.tipsMgr:showWarning('onlyLeaderUpgrade')
        return
    end

    global.panelMgr:openPanel('UIMiracleStarUp'):setData(self.miracleRewardData,self.data,self.star)
end
--CALLBACKS_FUNCS_END

return UIMagicOwnPro

--endregion
