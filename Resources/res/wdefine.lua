--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

WDEFINE = 
{
    CITY = {
        BUILD_STATE =
        {
            BLANK = 0,--空地+未建造
            UNOPEN = 1,--未开放
            BUILDED = 2--已建造
        },
	BUILDING_TYPE = 
        {
            CAMP = 2,--兵营
            HORSE = 5,--马厩
            TARGET = 6,--靶场
            MAGIC = 7,--法师营
            TANK = 8,--战车工坊
            FARM = 3,--农田
            LOGGING = 9, --伐木场
            STONE = 10, --石
            GOLD = 11, --金
            WALL = 14, --城墙
            SPY = 12, --侦察营
            RACE = 16, --家族建筑
        }
    },

    DAILY_TASK = {

        TASK_STATE = {

            DONE = 0,
            WORKING = 1,
            GETD = 2,
            LOCK = 3,
        }
    },
}

WDEFINE.NET = {
    RESTART_DELAY   = 5,
    CLOSE_DELAY     = 5,
}

-- 内城滚动速度
WDEFINE.SCROLL_SLOW_DT = 0.6

-- 安卓低于100m要释放资源
WDEFINE.FREE_ANDROID_RES_LIMIT_MEM_LV1 = 41
WDEFINE.FREE_ANDROID_RES_LIMIT_MEM_LV2 = 100

-- 登陆平台
WDEFINE.CHANNEL = {
    VISITOR    = 0,
    FACEBOOK   = 1,
    GOOGLE     = 2,
    GAMECENTER = 3,
}

WDEFINE.CHANNELKEY = {
    [WDEFINE.CHANNEL.FACEBOOK]  = "facebook",
    [WDEFINE.CHANNEL.GOOGLE]    = "google",
    [WDEFINE.CHANNEL.GAMECENTER]= "gamecenter",
}

WDEFINE.BINDKEY = {
    [WDEFINE.CHANNEL.FACEBOOK]  = "fbbind",
    [WDEFINE.CHANNEL.GOOGLE]    = "glbind",
    [WDEFINE.CHANNEL.GAMECENTER]= "gcbind",
}

--本地数据存储
WDEFINE.USERDEFAULT = 
{
    GUIDE_STEP = "GUIDE_STEP",
    OPEN_GUIDE = "OPENGUIDE",--开关引导
    UNION_MESSAGE_READ_ID = "UNION_MESSAGE_READ_ID",--联盟留言已读的id
    UNION_DYNAMIC_READ_ID = "UNION_DYNAMIC_READ_ID",--联盟动态已读的id
}

--引导点击目标集合key
WDEFINE.GUIDE_TARGET_KEY = 
{
    BUILDINGS = "buildings",
    OPERATE = "operate",
    UI = "ui",
    BUILDLIST = "buildlist",
}

WDEFINE.SOLDIER_PROPERTY = 
{
    "atk",
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
    "dPower",
    "speed",
    "capacity",
    "perPop",
    "perRes",
    "combat",
}

WDEFINE.CHAT = 
{
--表情面板输入的类型
    CUSTOM_TYPE = 
    {
        T_ICON = 1,
        T_HISTORY = 2,
        T_ITEM = 3,
        T_SLAVE = 4,
    },
--文本显示类型
    C_TYPE = 
    {
        I_TEXT = 1,
        I_ICON = 2,
        I_ITEM = 3,
        I_SLAVE = 4,
        I_TEAM = 5,
    },
    CHAT_FLAG = 
    {
        COLOR_R = "#R",
        COLOR_G = "#G",
        COLOR_B = "#B",
        COLOR_K = "#K",
        COLOR_Y = "#Y",
        COLOR_W = "#W",
        COLOR_COLOR = "#c",
        COLOR_NORMAL = "#n",
        NEWLINE = "#r",
        WORD_JING = "##",
        CUSTOM_ICON = "#1",
        CUSTOM_ITEM = "#I",
        CUSTOM_SLAVE = "#S",
        TEAM = "#T",
    },
    PARAM_ID = 
    {
        ALL_CHAT_NUM_MAX = 16,
        CHANNEL_CHAT_NUM_MAX = 20,
        VOICE_TIME_MIN = 21,
        ITEM_NUM_MAX = 22,
        SLAVE_NUM_MAX = 23,
        VOICE_CASHE_MAX = 34,
    }
}

--endregion
