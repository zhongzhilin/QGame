---@classdef GameApp
local GameApp = {} 

local app_cfg = require "app_cfg"

function GameApp:init()
    self.packageRoot = "game"
    self.scaleFactor = 1.0
    self.designSize = {width=720, height=1280}   --设计分辨率
    
    self.mdisplayfps = false
    
    self.mfps = 1.0/60.0
end

function GameApp:startup()
    self:init()
    self:initDisplay()
    
    math.randomseed(os.time())
    math.random()
    global.netRpc:Init()

    self:startLoadConfigTable()
    if not global.SKIP_LOGO then
        global.scMgr:replaceScene("LogoScene")
    end
end

function GameApp:initDisplay()
    -- 2014.4 分辨率数据 http://mta.qq.com/mta/operation/?p=279
    -- 20.0% 800*480        1.667
    -- 16.0% 1280*720       1.778
    -- 14.9% 960*640        1.500 
    -- 12.4% 960*540        1.778
    -- 8.45% 854*480        1.771
    -- 8.36% 1136*640       1.775
    -- 6.79% 1920*1080      1.778
    -- 1024*768     1.333
    -- 2048*1536    1.333
    
    gdisplay.initResolution(self.designSize.width, self.designSize.height)
    --gdisplay.showInfo()
    self.scaleFactor = gdisplay.contentScaleFactor
    
    cc.Director:getInstance():setDisplayStats(self.mdisplayfps)
    cc.Director:getInstance():setAnimationInterval(self.mfps)
end

function GameApp:exit()
    global.funcGame.allExit()
    os.exit()
end

function GameApp:bootSuccess()
    self.loginScene = global.scMgr:newScene("LoginScene")
    global.scMgr:SetCurScene(self.loginScene)
    global.scMgr:SetCurSceneName("LoginScene")
    cc.Director:getInstance():replaceScene(self.loginScene)
    -- GLFCreateDebugPanel(self.loginScene, false)
    log.debug("=============> replaceScene(self.loginScene)")
end


function GameApp:startLoadConfigTable()
    require("game.Data.LanguageData")
    global.luaCfg:load()

    local configtable = {
        "drop",
        "buildings_info",
        "equipment",
        "build_lvup_ui",
        "wild_res",
        "main_task",
        "ui_language_string",
        "pet_skill",
        "localization",
        "errorcode",
        "science_lvup",
        "wild_picture",
        "common_task",
        "triggers_id",
        "rand_name",
        "random_shop",
        "daily_task",
        "email",
        "sounds",
        "hero_property__land_all",
        "hero_property",
        "data_type",
        "target_condition",
        "buildings_pos" ,

        "shop" ,
        "random_hero_rule" ,
        "code" ,
        "pet_interactive" ,
        "turntable_hero_reward" ,
        "union_task_type" ,
        "official_post" ,
        "loading_res" ,
        "union_function_btn" ,
        "pet_type" ,
        "point_reward" ,
        "skill" ,
        "guide_res" ,
        "exploit_algorithm" ,
        "developer" ,
        "pet_activation" ,
        "transfer_target" ,
        "wild_cfg" ,
        "city_max" ,
        "vip_func" ,
        "map_info" ,
        "war_mail" ,
        "world_seek" ,
        "ad_state" ,
        "activity_list" ,
        "combat_up" ,
        "buildings_resource" ,
        "res_cost" ,
        "world_miracle_name" ,
        "hero_arena" ,
        "troops_msg" ,
        "richText" ,
        "random_shop_money" ,
        "science_type" ,
        "world_res" ,
        "map_unlock" ,
        "wild_monstertype" ,
        "diamond_bank" ,
        "recharge_list" ,
        "history_rank_reward" ,
        "gift" ,
        "troops_list" ,
        "all_miracle_name" ,
        "union_donate_type" ,
        "push_type" ,
        "pet_feed" ,
        "soldier_pro_tips" ,
        "village_max" ,
        "remind" ,
        "race" ,
        "lord_exp" ,
        "union_position_btn" ,
        "activity" ,
        "refresh" ,
        "union_build_type" ,
        "role_frame" ,
        "quality_color" ,
        "map_region" ,
        "buildings_lvup" ,
        "hero_strengthen" ,
        "picture" ,
        "world_miracle" ,
        "forge_equip" ,
        "fund_type" ,
        "temple_activity" ,
        "faq_language" ,
        "equip_resolve" ,
        "btn" ,
        "seven_day" ,
        "wild_max" ,
        "worldboss" ,
        "item" ,
        "pet" ,
        "change_item" ,
        "camp_lvup" ,
        "guide_hospital" ,
        "union_create" ,
        "free_chest" ,
        "common_task_title" ,
        "union_build_effect" ,
        "map_ran" ,
        "lord_lvup" ,
        "turntable_day_consume" ,
        "worldbosscount" ,
        "recharge" ,
        "cost_rise" ,
        "activity_time_regular" ,
        "battle_base_time" ,
        "public_notice" ,
        "world_surface" ,
        "soldier_skill" ,
        "turntable_day_reward" ,
        "hero_calg_rank" ,
        "update" ,
        "world_btn" ,
        "hero_icon" ,
        "hero_item_get" ,
        "legend_hero_act_2" ,
        "buff_source" ,
        "mapunit" ,
        "world_buff" ,
        "citybuff" ,
        "get_resource" ,
        "legend_hero_act" ,
        "daily_day" ,
        "chest_pos" ,
        "hero_hp" ,
        "soldier_lvup" ,
        "world_city_image" ,
        "soldier_train" ,
        "turntable_hero_cfg" ,
        "union_languages" ,
        "effect_res" ,
        "map_data" ,
        "map_cfg" ,
        "equip_strengthen" ,
        "rolehead" ,
        "daily_point" ,
        "hero_unlock" ,
        "troops_info" ,
        "probability" ,
        "world_color" ,
        "buildings_ui" ,
        "world_type" ,
        "stickers_color" ,
        "recharge_sym" ,
        "union_flag" ,
        "lord_equip" ,
        "wild_property" ,
        "city_effect" ,
        "loading_tips" ,
        "weather" ,
        "rank_reward" ,
        "union_task" ,
        "message" ,
        "serverlist" ,
        "hero_get" ,
        "equipment_suit" ,
        "buildings_manpower" ,
        "city_lvup" ,
        "languages" ,
        "world_camp" ,
        "hero_impression" ,
        "transfer_random" ,
        "introduction" ,
        "union_class_btn" ,
        "union_build_levle" ,
        "daily_reward" ,
        "res_icon" ,
        "push_message" ,
        "city_surface" ,
        "common_res" ,
        "hero_arena_reward" ,
        "garrison_pro" ,
        "type" ,
        "hero_persuade" ,
        "city_btn" ,
        "dialogue" ,
        "daily_quality_reward" ,
        "hero_exp" ,
        "hero_equipment" ,
        "activity_rank" ,
        "rob_value" ,
        "fund" ,
        "wild_monster" ,
        "account_list" ,
        "vip_effect" ,
        "union_shop" ,
        "battle_injuries" ,
        "exploit_lv" ,
        "leisureList" ,
        "miracle_upgrade" ,
        "day_salary" ,
        "register_reward" ,
        "wild_chest" ,
        "turntable_list" ,
        "science" ,
        "buildings_list" ,
        "social_invite" ,
        "buildings_scout_mail" ,
        "daily_rank_reward" ,
        "def_device" ,
        "guide" ,
        "union_build_effect__land_all" ,
        "map_lv" ,
        "map_color" ,
        "rank" ,
        "crystal_time" ,
        "hero_grow" ,
        "troop_max" ,
        "data_pandect" ,
        "pet_property" ,
        "buildings_wall" ,
        "hero_exp_get" ,
        "build_queue" ,
        "hero_limit" ,
        "divine" ,
        "guide_stage" ,
        "turntable_pay_reward" ,
        "city_res" ,
        "map_unlock_list" ,
        "config" ,
        "hero_garrison" ,
        "item_impression" ,
        "forge_suit" ,
        "soldier_property" ,
        "hero_strengthen_lv" ,
        "daily_refresh" ,
        "miracle_reward" ,
        "guide_world_info" ,
        "type_icon" ,
        "point_rule" ,
        "npc" ,
        "troop_num" ,
        "troops_state" ,
        "union_trigger" ,
        "chat_dialogue" ,
        "union_btn" ,
        "guide_server" ,
        "achievement" ,
        "icon" ,
    }

    global.loadingDesignTimer = gscheduler.scheduleGlobal(function()
        if #configtable > 0 then
            global.luaCfg:wwx_sd_getFileModal(configtable[1])
            table.remove(configtable,1)
        end
        if global.loadingDesignTimer and #configtable <= 0 then
            gscheduler.unscheduleGlobal(global.loadingDesignTimer)
            global.loadingDesignTimer = nil
        end
    end,0.05)
end 

return GameApp

