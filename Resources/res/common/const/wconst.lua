-- cs公用常量定义

require "common"

WCONST = {
    -- 属性列表对应的下标  粮， 金，木，石，铁，钻
    PROP_INDEX = {
        
        FOOD            = 1,     --粮食
        GOLD            = 2,     --金币
        DIAMOND         = 5,     --钻石
        WOOD            = 3,     --木材
        STONE           = 4,     --石头    
        SOLDIER         = 10,     --兵源
    },

    ITEM = {
        -- 特殊物品ID
        TID = {
            FOOD            = 1,     --食物
            GOLD            = 2,     --金币
            DIAMOND         = 6,     --钻石
            WOOD            = 3,     --木材
            EXP             = 5,     --经验
            STONE           = 4,     --石头
            EXPLOIT         = 9,     --军功
            SOLDIER         = 10,     --兵源
        },

        NAME = {
            [1] = "food",       --食物
            [2] = "gold",       --金币
            [6] = "diamond",    --钻石
            [3] = "wood",       --木材
            [5] = "exp",        --经验
            [4] = "stone",      --石头
        },


        -- -- 种类
        -- KIND = {
        --     PROP            = 1,    --属性
        --     GOODS           = 2,    --道具
        --     EQUIP           = 3,    --装备
        -- },
    },

    BUTTON_SCALE={
        SMALL = 0.03,
        MID = 0.04,
    },

    --联盟关系
    UNION_RELATION={
        NEUTRAL = 0,--中立
        MINE    = 1,--自己
        SAME    = 2,--同盟
        FRIEND  = 3,--友好
        HOSTILE = 4,--敌对
    },

    BASE_PROPERTY = {
        [1] = {
            KEY =  "attack",
            LOCAL_STR = 10124,
        },
        [2] = {
            KEY =  "defense",
            LOCAL_STR = 10127,
        },
        [3] = {
            KEY =  "interior",
            LOCAL_STR = 10385,
        },
        [4] = {
            KEY =  "commander",
            LOCAL_STR = 10386,
        },
    },

    WORLD_CFG = {

        CITY_TYPE = {

            EMPTY_CITY = 0,
            OWN_CITY = 1,
            ENEMY_CITY = 2,
            WILD_RES = 11,
            WILD_OBJ = 12,
        },

        INFO = {

            TMX_WIDTH = 2048,
            MAP_WIDTH = 81,
        },

        IS_3D = true,

        MIN_SCALE = 0.65,
        CUR_SCALE = 1,
    },

    LONG_TIPS_PANEL = {
        WILD_OBJ        = "game.UI.common.UIWildTipsNode2",
        WILD_RES        = "game.UI.common.UIWildTipsNode3",
        ITEM_DESC       = "game.UI.common.UIItemDescMode2"
    },
}

WCONST = nodefault(WCONST)
WCONST = readonly(WCONST)
