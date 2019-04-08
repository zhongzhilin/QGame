--region UIMagicTownPro.lua
--Author : untory
--Date   : 2016/12/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UICommonStars = require("game.UI.world.widget.UICommonStars")
--REQUIRE_CLASS_END

local UIMagicTownPro  = class("UIMagicTownPro", function() return gdisplay.newWidget() end )

function UIMagicTownPro:ctor()
    
end

function UIMagicTownPro:CreateUI()
    local root = resMgr:createWidget("wild/wild_miracle_currency")
    self:initUI(root)
end

function UIMagicTownPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_miracle_currency")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.loadingbar_bg = self.root.Node_1.hp_mlan_8.loadingbar_bg_export
    self.loading = self.root.Node_1.hp_mlan_8.loadingbar_bg_export.loading_export
    self.lord = self.root.Node_1.hp_mlan_8.loadingbar_bg_export.lord_export
    self.tips = self.root.Node_1.hp_mlan_8.loadingbar_bg_export.lord_export.tips_export
    self.hp = self.root.Node_1.hp_mlan_8.loadingbar_bg_export.hp_export
    self.recover = self.root.Node_1.recover_mlan_10_export
    self.rest_time = self.root.Node_1.recover_mlan_10_export.rest_time_export
    self.stars = UICommonStars.new()
    uiMgr:configNestClass(self.stars, self.root.Node_1.stars)
    self.type_icon = self.root.Node_1.type_bj.type_icon_export
    self.buff1 = self.root.Node_1.set_buff_view.buff1_export
    self.buff2 = self.root.Node_1.set_buff_view.buff2_export
    self.buff3 = self.root.Node_1.set_buff_view.buff3_export
    self.buff4 = self.root.Node_1.set_buff_view.buff4_export
    self.buff_desc = self.root.Node_1.set_buff_view.buff_desc_export
    self.loadingbar_bg = self.root.Node_1.set_buff_view.castle_num_mlan_5.loadingbar_bg_export
    self.memberloading = self.root.Node_1.set_buff_view.castle_num_mlan_5.loadingbar_bg_export.memberloading_export
    self.memberinfo = self.root.Node_1.set_buff_view.castle_num_mlan_5.loadingbar_bg_export.memberinfo_export

--EXPORT_NODE_END
end

function UIMagicTownPro:getRewardData(magicType)
    
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do

        if v.type == magicType then

            return v
        end
    end
end
function UIMagicTownPro:getRewardPlus(miracleType,star)
    
    local rewards = luaCfg:miracle_upgrade()
    for  _,v in ipairs(rewards) do
        if v.type == miracleType and star == v.lv then
            return v
        end
    end

    return false
end

function UIMagicTownPro:setData( cfgData , data ,surfaceData,city )    

    -- dump(cfgData)
    self.city = city
    self.cfgData = cfgData
    dump(self.city.data)
    cfgData.lv = cfgData.lv or 0
    -- for i = 1,4 do
    --     self["star"..i]:setVisible(i <= cfgData.lv)
    -- end

    local star = 0 
    if city.data.sData.tagWildInfo and city.data.sData.tagWildInfo.lCityLv then 
        star = city.data.sData.tagWildInfo.lCityLv 
    end 

    self.star = star
    self.stars:setData(star)
    local rewardData = self:getRewardPlus(self.city:getType(),star)
    -- self.lv:setString(cfgData.name)
    local miracleRewardData = luaCfg:miracle_reward()
    for i,v in pairs(miracleRewardData) do
        if v.type == self.city:getType() then
            miracleRewardData = v
        end
    end
    self.buff_desc:setString(luaCfg:get_local_string(11037,miracleRewardData.member,str))

    for i=1,4 do
        self["buff"..i]:setVisible(false)
    end
    for i,v in ipairs(miracleRewardData.buff or {} ) do
        self["buff"..i]:setVisible(true)
        self["buff"..i]:setString(global.buffData:getBuffStrBy({lID=v[1],lValue= math.ceil(v[2] * rewardData.upPro / 100)}))
    end
   

    self.memberloading:setPercent(0)
    self.memberinfo:setString(string.format("%s/%s",0,miracleRewardData.member))

    if cfgData.hp then
        self.hp:setString(string.format("%s/%s",data.lCurHp,cfgData.hp))

        local pen = data.lCurHp / cfgData.hp * 100
        self.loading:setPercent(pen)
        self.tips:setPositionX(data.lCurHp / cfgData.hp * 392)
    end
    -- self.recover:setString(string.format(luaCfg:get_local_string(10844),cfgData.hpRecover))
    -- self.type_icon:setSpriteFrame(surfaceData.worldmap)
    global.panelMgr:setTextureFor(self.type_icon,surfaceData.worldmap)
    self.type_icon:setScale(surfaceData.iconSize)

    --润稿翻译处理 张亮
    -- global.tools:adjustNodePosForFather(self.lv:getParent(),self.lv)
    -- global.tools:adjustNodePosForFather(self.hp:getParent(),self.hp)
    global.tools:adjustNodePosForFather(self.rest_time:getParent(),self.rest_time)

    -- global.tools:adjustNodePosForFather(self.star1:getParent(),self.star1)
    -- global.tools:adjustNodePos(self.star1,self.star2)
    -- global.tools:adjustNodePos(self.star2,self.star3)
    -- global.tools:adjustNodePos(self.star3,self.star4)


    if not data.lflushtime then
        self.rest_time:setString("00:00")
    else
        self:startCheckTime()
        self.flushEndTime = data.lflushtime
        self:checkTime()
    end


end

function UIMagicTownPro:onExit()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end

function UIMagicTownPro:checkTime()
    
    local contentTime = self.flushEndTime - global.dataMgr:getServerTime()
    if contentTime < 0 then contentTime = 0 end

    if contentTime == 0 then

        self.rest_time:setString("00:00")
        return
    end

    local str = global.funcGame.formatTimeToMS(contentTime)
    self.rest_time:setString(str)
end

function UIMagicTownPro:startCheckTime()
    
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        if self.checkTime then 
            self:checkTime()
        end 
    end, 1) 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMagicTownPro

--endregion
