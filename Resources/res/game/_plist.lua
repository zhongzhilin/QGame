
-- 文件加载列表
-- 以 / 结尾的表示目录，其它为文件

local _List = {
    --global    
    'Event.GameEvent', 
    'Event.StateEvent', 
    'Event.StateMachine', 
    'Functions',
    'FunctionsForTime',
    'Rpc.NetTcp',
    'Rpc.NetRpc',
    
    --ConfigManager
    'Config.LuaConfigMgr',
        
    --SysManager
    'Manager.SceneManager',
    'Manager.PanelManager',
    'Manager.ScheduleManager',
    'Manager.TimeManager',
    'Manager.ResManager',   
    'Manager.UIManager',    
    'Manager.MessageManager',
    'Manager.SActionManager',
    'Manager.TipsManager', 
    'Manager.GuideMgr',
    'UI.common.Tools',

    --Data   
    'Data.LoginData',
    'Data.UserData',
    'Data.PropData',
    'Data.LanguageData',
    'Data.CityData',
    'Data.TaskData',
    'Data.DailyTaskData',
    'Data.NormalItemData',
    'Data.MailData',
    'Data.SpeedData',
    'Data.TroopData',
    'Data.SoldierData',
    'Data.GuideData',
    'Data.BuffData',
    'Data.ResData',
    'Data.UnionData',
    'Data.RefershData',
    'Data.CollectData',
    'Data.HeroData',
    'Data.HeadData',
    'Data.ChatData',
    'Data.OccupyData',
    'Data.EquipData',
    'Data.RankData',
    'Data.TechData',
    'Data.AchieveData',
    'Data.BossData',
    'Data.RechargeData',
    'Data.VipBuffEffectData',
    'Data.MySteriousData',
    'Data.ClientStatusData',
    'Data.PushConfigData',
    'Data.EasyDevUtilData',
    'Data.AdvertisementData',
    'Data.ActivityData',
    'Data.LeisureData',
    'Data.ShopData' ,
    'Data.SoldierBufferData' , 
    'Data.UserHeadFrameData' , 
    'Data.UserCastleSkinData' , 
    'Data.PetData',
    'Data.FinishData',
    --DataManager under Data
    'Data.DataManager',  

    --Api
    'Rpc.LogicRequest',
    'Rpc.LogicNotify', 

    'Api.GMAPI',
    'Api.CommonAPI',
    'Api.LoginAPI',
    'Api.CityAPI',
    'Api.TaskAPI',
    'Api.ItemAPI',
    'Api.WorldAPI',
    'Api.UnionAPI',
    'Api.MailAPI',
    'Api.ChatAPI',
    'Api.TechAPI',
    'Api.CityBuffAPI',
    'Api.GiftGodeAPI',
    'Api.ShopActionAPI',
    'Api.MysteriousShopAip',
    'Api.RechargeAPI',
    'Api.PushInfoAPI',
    'Api.SimpleHttpAPI',
    'Api.BossChestAPI',
    'Api.ActivityAPI',
    'Api.SalaryAPI',
    'Api.PetAPI',
    -- 在进入时发送http协议
    'Data.ServerData',

    --ModuleManage

    'world'
}

return _List