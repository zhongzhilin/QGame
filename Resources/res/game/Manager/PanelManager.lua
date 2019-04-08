
local PanelManager = {
    packageRoot = "game",   
}

local scMgr = global.scMgr
local gameEvent = global.gameEvent

local LAYER = 
{
    LAYER_SCENE = 1,
    LAYER_MENU = 2,
    LAYER_PANEL_DOWN = 3,
    LAYER_PANEL = 4,
    LAYER_TOPBAR = 5,
    LAYER_GUIDE = 31,
    
    LAYER_SUPER = 32,
    LAYER_MESSAGE_BOX = 11,
    LAYER_TIPS = 30,    
    LAYER_SYSTEM = 40,
}
PanelManager.LAYER = LAYER
local OPEN_WIDGET_CACHE = true
local _panel = {}
local _panelStack = {}

local _panelPath = {
    --QGame Panel
    -------------------------------------------------------------------------------------
    ConnectingPanel = {
        layer = LAYER.LAYER_SUPER,    
        path = "game.UI.common.ConnectingPanel",    
    },

    UISystemConfirm = {
        layer = LAYER.LAYER_SYSTEM,    
        path = "game.Login.UILoginConfirm",
    },
    
    UISystemMessagePanel = {
        layer = LAYER.LAYER_SYSTEM,    
        path = "game.UI.common.UISystemMessagePanel",
    },

    UITipsWarning = {
        layer = LAYER.LAYER_TIPS,    
        path = "game.UI.common.UITipsWarning",
    },

    UIWorldUnlock = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.world.widget.UIWorldUnlock",
    },

    UIItemRewardPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.common.UIItemRewardPanel"
    },

    UIMaintancePanel = {
        layer = LAYER.LAYER_SYSTEM,
        path = "game.UI.common.UIMaintancePanel"
    },

    --login 
    
    UIInputAccountPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.Login.UIInputAccountPanel",
        unload = "loading/loading.plist"
    },

    LoadingPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.Login.LoadingPanel",
    },

    UIMergeSRolePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.Login.UIMergeSRolePanel",
    },

    UIEditActiveCodePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.Login.UIEditActiveCodePanel",
    },

    --mainscene
    UICityPanel = {
        layer = LAYER.LAYER_PANEL_DOWN,  
        path = "game.UI.city.UICityPanel",
        unload = "chat_channel.plist",
    },
    --mainscene
    --训练
    TrainCard = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.widget.TrainCard",
    },
    TrainSoldierCard = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.widget.TrainSoldierCard",
    },
    TrainPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.TrainPanel",
        isFull = true,
        unload = "camp.plist"
    },

    UIOccupyPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.world.occupyList.UIOccupyPanel",
        isFull = true,
    },


    UIHeroStarUp = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.hero.UIHeroStarUp",    
    },
    
    UIMiracleStarUp = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.world.widget.UIMiracleStarUp",    
    },
    
    TrainNumPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.TrainNumPanel",
    },
    
    UIOfficalPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.offical.UIOfficalPanel",
        isFull = true,
    },

    UIOfficalInfoPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.offical.UIOfficalInfoPanel",
    },

    TrainSoldierDetail = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.TrainSoldierDetail",
        isFull = true,
    },

    TrainUpSoldierDetail = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.TrainUpSoldierDetail",
        isFull = true,
    },

    UIChangeNamePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.UIChangeNamePanel",
    },

    --伤兵营
    UIHpPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.UIHpPanel",
        isFull = true,
    },
    UIRecruitNumPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.second.UIRecruitNumPanel",
    },

    UIHeroComePool = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.hero.UIHeroComePool",
    },

    UICureNumPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.second.UICureNumPanel",
    },
    UIAllRecruitSurePanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.second.UIAllRecruitSurePanel",
    },
    UIAllCureSurePanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.panel.second.UIAllCureSurePanel",
    },

    --建造
    BuildPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.widget.BuildPanel",
    },

    UISetPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UISetPanel",
        isFull = true,
    },

    UISetSoundPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UISetSoundPanel",
        isFull = true,
    },

    UISetPerformancePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UISetPerformancePanel",
        isFull = true,
    },
    
    UpgradePanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.widget.UpgradePanel",
    },

    UIUpdateConfrimPanel = {

        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.common.UIUpdateConfrimPanel",
    },

    UIPaltUpdateConfrimPanel = {

        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.common.UIPaltUpdateConfrimPanel",
    },

    UIHeroGarrisionPanel = {
        layer = LAYER.LAYER_PANEL,  
        path = "game.UI.city.widget.UIHeroGarrisionPanel",
    },

    UIGuidePanel = {
        layer = LAYER.LAYER_GUIDE,  
        path = "game.UI.common.UIGuidePanel",
    },

    UIDescGuidePanel = {
        layer = LAYER.LAYER_GUIDE,  
        path = "game.UI.world.widget.UIDescGuidePanel",
    },

    UIGuideRectPanel = {
        layer = LAYER.LAYER_GUIDE,  
        path = "game.UI.common.UIGuideRectPanel",
    },
    
    TaskPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mission.TaskPanel",
        isFull = true,
        unload = "task.plist",
    },

    UITaskDescPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mission.UITaskDescPanel",
        isFull = true,
    },

    UITaskTips = {

        layer = LAYER.LAYER_SUPER,
        path = "game.UI.mission.UITaskTips",
    },

    --每日任务
    UIDailyTaskPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.dailyMission.UIDailyTaskPanel",
        isFull = true,
    },

    UIDailyTaskDesc = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.dailyMission.UIDailyTaskDesc",
    },

    UIDailyTaskRewardPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.dailyMission.UIDailyTaskRewardPanel",
    },    

    --背包
    UIBagPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.UIBagPanel",
        isFull = true,
    },

     --vip
    UIvipPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.vip.UIvipPanel",
        isFull = true,
        unload = "resource.plist",
    },

  --UIServerSwitchPanel
    UIServerSwitchPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.set.UIServerSwitchPanel",
        isFull = true,
    },

    UISwitchServerTipsPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.set.UISwitchServerTipsPanel",
    },

    UIGMGetItemPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.UIGMGetItemPanel",
    },

    UIGMColStrong = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.UIGMColStrong",
    },

    UIBagUse = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.use.UIBagUse",
    },

    UIBagSell = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.use.UIBagSell",
    },

    UIBagUseSingle = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.use.UIBagUseSingle",
    },

    --邮件
    UIMailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIMailPanel",
        isFull = true,
        unload = "mail.plist",
    },

    UIMailAllRewardPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIMailAllRewardPanel",
    },

    UIMailListPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIMailListPanel",
    },

    UIMailDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIMailDetailPanel",
    },

    UIUnionAdPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.UIUnionAdPanel",
    },

    UIMailBattlePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIMailBattlePanel",
    },

    UICreateCityPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.land.UICreateCityPanel"
    },

    UIPassDoorPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.land.UIPassDoorPanel"
    },

    UIPassDoorRandomPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.land.UIPassDoorRandomPanel"
    },

    UIHeroLvUp = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIHeroLvUp"
    },

    UIBattleNonePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIBattleNonePanel",
        isFull = true,
    },


    UIMailWritePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mail.UIMailWritePanel",
        isFull = true,
    },

    --  登录
    UILogin = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.Login.UILogin"
    },

    UIServerList = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.Login.UIServerList"
    },

    UISelectUnion = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.Login.UISelectUnion"
    },

    UIGotHeroPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIGotHeroPanel",
    },

    -- 加速使用道具
    UISpeedPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.itemUse.UISpeedPanel"
    },

    UIUseItemPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.itemUse.UIUseItemPanel"
    },

    UIPromptPanel = {

        layer = LAYER.LAYER_TIPS,
        path = "game.UI.itemUse.UIPromptPanel"
    },
    
    UIPromptUpgradePanel = {

        layer = LAYER.LAYER_TIPS,
        path = "game.UI.itemUse.UIPromptUpgradePanel"
    },

    UIMoJUsePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.itemUse.UIMoJUsePanel"
    },

    UIStayDialog = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIStayDialog"
    },

    --world
    UIWorldPanel = {

        layer = LAYER.LAYER_PANEL_DOWN,
        path = "game.UI.world.UIWorldPanel",
        unload = "chat_channel.plist",
    },

    UINPCPanel = {

        layer = LAYER.LAYER_GUIDE,
        path = "game.UI.world.widget.UINPCPanel"
    },
    
    UIGuideBGPanel = {

        layer = LAYER.LAYER_GUIDE,
        path = "game.UI.world.widget.UIGuideBGPanel"
    },

    UISkipGuidePanel = {

        layer = 32,
        path = "game.UI.world.widget.UISkipGuidePanel"
    },

    UISecondWorldPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.UISecondWorldPanel",
    },

    UIPKInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.UIPKInfoPanel",
        isFull = true,
    },

    UICastleInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UICastleInfoPanel",
        isFull = true,
    },

    UIWorldMapInfo = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIWorldMapInfo"
    },

    UIVillageInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIVillageInfoPanel"
    },

    UISearchPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UISearchPanel"
    },

    UICollectListPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UICollectListPanel",
        isFull = true,
    },

    UICollectPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UICollectPanel"
    },

    UIPassTroopPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.troop.UIPassTroopPanel",
        isFull = true,
    },

    UIChooseLand = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.land.UIChooseLand",
        unload = "choose_land.plist",
    },

    --world：野地
    UIWildResOwnerPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIWildResOwnerPanel"
    },

     UIWolrdWildNewPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIWolrdWildNewPanel"
    },
    
    UIGarrisonPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIGarrisonPanel",
        isFull = true,
    },

    UIWildResInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIWildResInfoPanel"
    },

    UIWildMonsterPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIWildMonsterPanel"
    },

    UIWildSoldierPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIWildSoldierPanel"
    },

    --hero
    UIHeroPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIHeroPanel",
        isFull = true,
        unload = "hero.plist",
    },

    --hero
    UIShareHero = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIShareHero",
        isFull = true,
        unload = "hero.plist",
    },

    UIDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIDetailPanel",
        isFull = true,
        unload = "hero.plist",
    },

    UIPersuadePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIStrongPersuadePanel",
        isFull = true,
    },
    -- 新建部队
    UITroopPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.troop.UITroopPanel",
        isFull = true,
    },

     UISoldierRelation = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.troop.UISoldierRelation",
    },

    UITroopDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.troop.UITroopDetailPanel",
        isFull = true,
        unload = "new_troop.plist",
    },

    UITroopCombinDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.troop.UITroopCombinDetailPanel",
    }, 

    UISelectHeroPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.troop.UISelectHeroPanel"
    },

    UITroopMsgPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.troop.UITroopMsgPanel"
    },

    -- 领主详细信息
    UILordPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.lord.UILordPanel",
        isFull = true,
        unload = "lord_info.plist",
    },

    UILordLvUpPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.lord.UILordLvUpPanel"
    },

    UIBuyEnergyPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.lord.UIBuyEnergyPanel"
    },

    UIWallNumPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.wall.UIWallNumPanel",
        isFull = true,
        unload = "city_defense.plist",
    },

    UISharePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.commonUI.UISharePanel",
    },

    UIRecoverWallPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.wall.UIRecoverWallPanel"
    },

    UIDeviceDetailTPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.wall.UIDeviceDetailTPanel",
        isFull = true,
    },

    --城防空间
    UIWallSpacePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.wall.UIWallSpacePanel",
        isFull = true,
        unload = "city_defense.plist",
    },


    -- 建筑详情详细界面
    UICityDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.city.detail.UICityDetailPanel",
        isFull = true,
    },

    -- 内城建筑信息详情一级界面
    UIDetailFirstPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.city.detail.UIDetailFirstPanel"
    },

    -- 战斗力详细界面
    UICombatPowerPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.combatPower.UICombatPowerPanel"
    },

    -- 道具购买界面
    UIItemBuyPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.itemUse.UIItemBuyPanel"
    },

    -- 道具使用界面
    UIItemUsePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.itemUse.UIItemUsePanel"
    },

    -- 资源界面
    UIResPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.resource.UIResPanel",
        isFull = true,
    },

    UIResGetPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.resource.UIResGetPanel",
        isFull = true,
    },

    UIResInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.resource.UIResInfoPanel",
        isFull = true,
        unload = "resource.plist",
    },

    -- 介绍界面
    UIIntroducePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.commonUI.UIIntroducePanel",
    },

    UIQuestionPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.commonUI.UIQuestionPanel",
    },

    UIQuestionBgPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.commonUI.UIQuestionBgPanel",
    },

    -- 联盟
    UIUnionPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.UIUnionPanel",
        isFull = true,
    },

    UIUnionSearchPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.UIUnionPanel",
        isFull = true,
    },
    --邀请入盟
    UIUnionAskPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionAskPanel",
        isFull = true,
    },
    UIUnionAskSearchPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionAskPanel",
        isFull = true,
    },
    UIUnionAskDetailPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionAskDetailPanel",
    },
    UICreateUnionPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UICreateUnionPanel",
    },
    UIJoinUnionPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIJoinUnionPanel"
    },
    UIHadUnionPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.UIHadUnionPanel",
        isFull = true,
        unload = "union.plist",
    },
    UIUnionMgrPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionMgrPanel",
        isFull = true,
    },
    UIUnionMemDetails = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionMemDetails"
    },
    --联盟留言
    UIUMsgPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUMsgPanel",
        isFull = true,
    },
    UIUnionEditGG = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionEditGG"
    },
    UIUnionEditXY = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionEditXY"
    },
    UIUnionPubRecruit = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionPubRecruit"
    },

    --修改联盟语言
    UIUnionEditLan = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionEditLan"
    },
    --修改联盟权限
    UIUEditPower = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUEditPower",
        isFull = true,
    },
    UIUnionMemberPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionMemberPanel",
        isFull = true,
    },
    
    UIUnionAppointedPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionAppointedPanel",
        isFull = true,
    },
    --修改联盟招募模式
    UIUnionJoinCondition = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionJoinCondition"
    },
    --修改联盟简称和名称
    UIUnionModifyName = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionModifyName"
    },
    --修改联盟旗帜
    UIUnionModifyFlag = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionModifyFlag"
    },
    --查看联盟奇迹点
    UIUnionMiraclePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionMiraclePanel",
        isFull = true,
    },
    -- 联盟动态
    UIUnionDynamicPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.dynamic.UIUnionDynamicPanel",
        isFull = true,
    },
    --联盟外交
    UIUnionForeignPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.foreign.UIUnionForeignPanel",
        isFull = true,
    },
    UIUnionForeignChoicePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.foreign.UIUnionForeignChoicePanel"
    },
    UIUnionForeignHandlePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.foreign.UIUnionForeignHandlePanel"
    },
    --联盟战争
    UIUWarListPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.war.UIUWarListPanel",
        isFull = true,
    },
    UIUWarRecordsPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.war.UIUWarRecordsPanel"
    },
    UIUWarAtkChoicePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.war.UIUWarAtkChoicePanel"
    },
    UIUWarDefChoicePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.war.UIUWarDefChoicePanel"
    },
    --联盟捐献
    UIUDonatePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.donate.UIUDonatePanel",
        isFull = true,
    },
    UIUDonateRankPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.donate.UIUDonateRankPanel",
        isFull = true,
    },
    UIUDonateUsePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.donate.UIUDonateUsePanel"
    },
    --联盟任务
    UIUTaskPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.task.UIUTaskPanel",
        isFull = true,
    },
    --联盟村庄
    UIUnionVillagePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.village.UIUnionVillagePanel",
        isFull = true,
    },

    UIUTaskRewardPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.task.UIUTaskRewardPanel",
    },

    --联盟建设
    UIUBuildPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.build.UIUBuildPanel",
        isFull = true,
    },
    UIUBuildInfo = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.build.UIUBuildInfo",
    },
    --联盟商店
    UIUShopPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.shop.UIUShopPanel",
        isFull = true,
    },
    UIUShopBuyPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.shop.UIUShopBuyPanel"
    },
    UIUShopRecordPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.shop.UIUShopRecordPanel"
    },

    UIGMBattle = {

        layer  = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.GM.UIGMBattle",
        isFull = true,
    },

    UIGMBattlePanel = {

        layer  = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.GM.UIGMBattlePanel"
    },

    -- 兵源
    UISoldierSourcePanel = {

        layer  = LAYER.LAYER_PANEL,
        path = "game.UI.city.panel.UISoldierSourcePanel",
        isFull = true,
        unload = "manpower.plist"
    },

    UISelectNew = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.Login.UISelectNew",
        unload = "login_0.plist",
    },

    UIWildTown = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIWildTown"
    },

    UIMagicTown = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIMagicTown"
    },
    
    UIMagicOwnPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIMagicOwnPanel"
    },
    
    UIMagicRewardPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.wild.UIMagicRewardPanel"
    },

    UISkillPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.skill.UISkillPanel",
    },
    
    UIAttackEffect = {
        layer = LAYER.LAYER_SUPER,
        path = "game.UI.world.UIAttackEffect"
    },

    --邀请入盟
    UIWorldInvitePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.league.UIWorldInvitePanel",
        isFull = true,
    },
    UIWorldInviteSearchPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.league.UIWorldInvitePanel",
        isFull = true,
    },
    UIWorldInviteDetailPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.league.UIWorldInviteDetailPanel",
    },

    UIGMGetEquipPanel = {

        layer = LAYER.LAYER_SUPER,
        path = "game.UI.bag.UIGMGetEquipPanel"
    },

    UIEquipPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIEquipPanel",
        isFull = true,
    },

    UIEquipForgePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIEquipForgePanel",
        isFull = true,
        unload = "equip.plist",
    },

    UIForgeSuccess = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIForgeSuccess",
    },

    UIForgeSelectPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIForgeSelectPanel",
        isFull = true,
        unload = "equip.plist",
    },

    UIWorldSearchPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIWorldSearchPanel"
    },

    UIForgeInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIForgeInfoPanel",
        isFull = true,
        unload = "equip.plist",
    },

    UIStrongInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIStrongInfoPanel"
    },

    UIStrongResPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIStrongResPanel"
    },

    UIEquipPutDown = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIEquipPutDown"
    },

    UIEquipStrongPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIEquipStrongPanel",
        isFull = true,
        unload = "equip.plist",
    },

    UIDeletePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIDeletePanel",
        isFull = true,
        unload = "equip.plist",
    },

    UINewWorldMap = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.UINewWorldMap",
        isFull = true,
    },
    
    UISeeking = {

        layer = LAYER.LAYER_SUPER,
        path = "game.UI.world.widget.UISeeking"
    },
    
    FireFinish = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.commonUI.widget.FireFinish"
    },

    -- chat
    UIChatPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chat.UIChatPanel",
        isFull = true,
        unload = "chat_channel.plist",
    },

    UIChatPrivatePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chat.UIChatPrivatePanel"
    },

    UIChatUserInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chat.UIChatUserInfoPanel"
    },

    UIShieldUserPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.set.UIShieldUserPanel",
        isFull = true,
    },

    UIChatGiftPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chat.UIChatGiftPanel",
    },

    UIGiftListPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chat.UIGiftListPanel",
    },

    -- roleHead
    UIRoleHeadPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.roleHead.UIRoleHeadPanel",
        isFull = true,
    },
    -- roleHead
    UISdefineHeadPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.roleHead.UISdefineHeadPanel",
    },

     UITipsWritePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UserTips.UITipsWritePanel"
    },

    UITipsPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UserTips.UITipsPanel"
    },

    -- chest
    UIChestPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chest.UIChestPanel"
    },

    -- rank
    UIRankPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.rank.UIRankPanel",
        isFull = true,
    },

    UIRankInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.rank.UIRankInfoPanel",
        isFull = true,
        unload = "rank.plist",
    },

    -- register
    UIRegisterPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.register.UIRegisterPanel"
    },

    -- achievement
    UIAchievePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.achieve.UIAchievePanel",
        isFull = true,
    },

    -- salary
    UISalaryPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.salary.UISalaryPanel",
        isFull = true,
        unload = "salary.plist",
    },

    -- salary
    UIKingBattlePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.UIKingBattlePanel",
        isFull = true,        
    },

    UIMiracleDoorPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIMiracleDoorPanel",        
    },

    UIMiracleDoorAfterOwnPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIMiracleDoorAfterOwnPanel",        
    },
    
    UIMiracleDoorInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIMiracleDoorInfoPanel",        
    },
    
    UIMiracleDoorHistoryPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIMiracleDoorHistoryPanel",        
    },

    UIMiracleDoorRewardPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIMiracleDoorRewardPanel",        
    },
    -- science
    UISciencePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.science.UISciencePanel",
        isFull = true,
        unload = "science.plist",
    },

    UIScienceDPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.science.UIScienceDPanel",
        isFull = true,
    },

    UITechDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.science.tech.UITechDetailPanel"
    },

    UITechInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.science.tech.UITechInfoPanel"
    },

    UITechNowPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.science.tech.UITechNowPanel"
    },

    UITechMaxLvPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.science.tech.UITechMaxLvPanel"
    },
    
    -- divine
    UIDeveloperPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.set.UIDeveloperPanel"
    },

    UIComInfo = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIComInfo",
    },

    UICityBufferPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.citybuffer.UICityBufferPanel",
        isFull = true,
        unload = "divine.plist",
    },

    UIDivinePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.divine.UIDivinePanel",
        isFull = true,
        unload = "divine.plist",
    },

    UIDivineInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.divine.UIDivineInfoPanel"
    },
    
    UIGiftCodePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.set.UIGiftCodePanel"
    },


    UIBuyShopPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.bag.UIBuyShopPanel"
    },
    
    -- boss
    UIBossPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.boss.UIBossPanel",
        isFull = true,--标记是否隐藏面板后面的场景，减少节点数
        unload = "dragon_pit.plist",
    },

    UIWorldBossPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIWorldBossPanel",
    },

    UIBosMonstPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.boss.UIBosMonstPanel"
    },

    UIMysteriousPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mysterious.UIMysteriousPanel",
        isFull = true,
        unload = "random_shop.plist",
    },

    UIBuySteriousPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.mysterious.UIBuySteriousPanel"
    },

    UIPayPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pay.UIPayPanel"
    },

    -- recharge
    UIRechargePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.recharge.UIRechargePanel",
        isFull = true,
    },

    UIRechargePanelDaily = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.recharge.UIRechargePanel",
        isFull = true,
    },
    

    UIGiftPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.gift.UIGIftPanel",
        isFull = true,
    },


    -- monthCard
    UIMonthCardPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.monthCard.UIMonthCardPanel",
        unload = "month_card_new.plist",
        isFull = true,
    },

    UISetLanguagePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UISetLanguagePanel",
        isFull = true,
    },

    UIPushMessgePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UIPushMessgePanel",
        isFull = true,
    },

    -- account
    UISetAccountPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UISetAccountPanel",
        isFull = true,
    },

    UIChangeAccountPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.set.UIChangeAccountPanel",
        isFull = true,
    },

    UILoginConfirm = {
        layer = LAYER.LAYER_MESSAGE_BOX,    
        path = "game.Login.UILoginConfirm",
    },

     UIActivityPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityPanel",
        isFull = true,
        unload = "activity.plist",
    },

    UIActivityDetailPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityDetailPanel",
    },

    UIActivityHeroUpPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityHeroUpPanel",
        unload = "hero.plist",
    },
    UIActivityNewHeroUpPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityNewHeroUpPanel",
        unload = "hero.plist",
    },
    
    UINormalRewardPanel = {
        layer = LAYER.LAYER_PANEL,    
    path = "game.UI.activity.Panel.UINormalRewardPanel",
    },

    UIActivityPointPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityPointPanel",
    },

    UIRankAndPointPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIRankAndPointPanel",
        isFull = true,
        unload = "resource.plist",
    },

    UIActivityRankPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityRankPanel",
    },

    UIActivityRankPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityRankPanel",
    },

    UIActivityRulePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.Panel.UIActivityRulePanel",
    },

    -- 累计充值活动
    UIAccRechargePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.activity.accRecharge.UIAccRechargePanel",
        unload = "recharge_activity.plist",
    },
    -- 首冲活动
    UIFirRechargePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.firRecharge.UIFirRechargePanel",
        isFull = true,
        unload = "first_recharge.plist",
    },

    UIReceivePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.commonUI.UIReceivePanel",
    },

    -- leisure
    UILeisurePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.leisure.UILeisurePanel",
    },

     UIADGiftPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.advertisementItem.UIADGiftPanel",
        isFull = true,
    },
    
    UIStorePanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.store.UIStorePanel",
        isFull = true,
    },

    UIHeroNoOrder = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.hero.UIHeroNoOrder",
    },
    
    UIRePlayerPanel = {
        layer = LAYER.LAYER_PANEL,    
        path = "game.UI.replay.view.UIRePlayerPanel",
        isFull = true,
    },
     UIMonthCardInfoPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.monthCard.UIMonthCardInfoPanel",
    },
    
    UIChestBuyPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.chest.UIChestBuyPanel",
    },

    -- Diplomatic
    UIDiplomaticPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.diplomatic.UIDiplomaticPanel",
        isFull = true,
    },
    UIApprovePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.diplomatic.UIApprovePanel",
        isFull = true,
    },
    
    UISelectHeadFramePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.roleHead.UISelectHeadFramePanel",
        isFull = true,
    },

    UIDissMissSoldierPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.city.panel.second.UIDissMissSoldierPanel",
    },

    UIUnLockFunPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.commonUI.UIUnLockFunPanel",
    },

    UIPandectPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pandect.UIPandectPanel",
	   isFull = true,
    },

    UIPandectInfoPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pandect.UIPandectInfoPanel",
    },

    UIFriendPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.friend.UIFriendPanel",
        isFull = true,
    },
    
    UISelectSkinPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.skin.UISelectSkinPanel",
    },

    UILevelUpRewordPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.Panel.UILevelUpRewordPanel",
    },

    UISevenDays = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.sevendays.UISevenDays",
        isFull = true,
    },

    UICityGarrisonPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.castleGarrison.UICityGarrisonPanel",
        isFull = true,
    },

    UIGarrisonSelectPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.castleGarrison.UIGarrisonSelectPanel",
    },

    UIBattleErrorcode = {

        layer = LAYER.LAYER_TIPS,
        path = "game.UI.commonUI.UIBattleErrorcode",
    },

    UIBattleErrorcodeNo = {

        layer = LAYER.LAYER_TIPS,
        path = "game.UI.commonUI.UIBattleErrorcodeNo",
    },
    
    UIRoyalDeletePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.equip.UIRoyalDeletePanel",
        isFull = true,
    },

    UIGetChannelPanel = {

        layer = LAYER.LAYER_SUPER,
        path = "game.UI.commonUI.UIGetChannelPanel",
    },

    UIUnionMailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.UIUnionMailPanel",
        isFull = true,
    },

    UIKillPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.killactivity.UIKillPanel",
    },

    UIExpActivityPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.expactivity.UIExpActivityPanel",
    },

    UIPlunderPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.plunderactivity.UIPlunderPanel",
    },

    UIUpPowerPanel = {

        layer = LAYER.LAYER_SUPER,
        path = "game.UI.commonUI.UIUpPowerPanel",
    },

    UIAchieveRewardPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.achieve.UIAchieveRewardPanel",
    },


    UIActivityPackagePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.recharge.UIActivityPackagePanel",
        isFull = true,
    },

    UIDiamondBankPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.diamondBank.UIDiamondBankPanel",
        isFull = true,
    },

    UIDiamondSave = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.diamondBank.UIDiamondSave",
    },

    UIBankRecodePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.diamondBank.UIBankRecodePanel",
        isFull = true,
    },
    
    UIFundPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.fund.UIFundPanel",
        isFull = true,
    },

    UIBuySoldierSource = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.city.panel.UIBuySoldierSource",
    },
    
    UISevenDayRechargePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.fund.UISevenDayRechargePanel",
        isFull = true,
    },

    -- 轮盘活动
    UITurntableHalfPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntableHalfPanel",
        unload = "turnable.plist",
        isFull = true,
    },
    UITurntableRewardPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntableRewardPanel",
    },
    UITurntableFullPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntableFullPanel",
        unload = "turnable.plist",
        isFull = true,
    },
    UITurntableHeroPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntableHeroPanel",
        unload = "turnable.plist",
        isFull = true,
    },

    UITurntableHeroRewardPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntableHeroRewardPanel",
    },
        
    UITurntablePool = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntablePool",
    },

    UIExploitPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.exploit.UIExploitPanel",
        isFull = true,
    },

    UIExploitListPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.exploit.UIExploitListPanel",
        isFull = true,
    },

    UIExploitUsePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.exploit.UIExploitUsePanel",
    },
    UIChangeShopPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.changeshop.UIChangeShopPanel",
        isFull = true,
    },

    UITurntableEnterPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.turnable.UITurntableEnterPanel",
        isFull = true,
    },


    UIBuyHeroPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.hero.UIBuyHeroPanel",
        isFull = true,
    },

    UIPetPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetPanel",
        isFull = true,
        unload = "pet.plist",
    },

    UIPetActivatPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetActivatPanel",
    },

    UIPetDetailPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetDetailPanel",
    },

    UIPetSkillPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetSkillPanel",
        isFull = true,
    },

    UIPetInfoPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetInfoPanel",
        isFull = true,
        unload = "pet.plist",
    },

    UIPetEquipPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetEquipPanel",
        isFull = true,
    },

    UIPetFriendlyPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetFriendlyPanel",
        isFull = true,
    },

    UIPetResetPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetResetPanel",
    },

    UIPetGetPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetGetPanel",
        unload = "pet.plist",
    },

    UIPetSkillUsePanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetSkillUsePanel",
        unload = "pet.plist",
    },

    UIPetLvUp = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIPetLvUp",
    },


    UIFeedResPanel = {

        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pet.UIFeedResPanel",
    },


    UIUnionHelpPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.help.UIUnionHelpPanel",
        isFull = true,
    },


    UIHeroExpListPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.exp.UIHeroExpListPanel",
        isFull = true,
        unload = "hero_exp.plist",
    },

    UIHeroExpPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.union.second.exp.UIHeroExpPanel",
        isFull = true,
        unload = "hero_exp.plist",
    },

    UIActivityBossPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.boss.UIActivityBossPanel",
        unload = "activity.plist",
    },

    UIUnionOccupationPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.union.UIUnionOccupationPanel",
    },
    
   UIActivityInfoPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.activity.Panel.UIActivityInfoPanel",
    },

    UIBossBuy = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UIBossBuy",
    },

    UICommonUseDiamond = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UICommonUseDiamond",
    },

    UITpSpend = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.world.widget.UITpSpend",
    },

    UIPKPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pk.UIPKPanel",
        unload = "arena_ui.plist",
        isFull = true,
    },

    UIPKRePlayPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pk.player.UIPKRePlayPanel",
        isFull = true,
    },

    UIPKRecordPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pk.UIPKRecordPanel",
        isFull = true,
    },

    UIPKResultPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pk.player.UIPKResultPanel",
    },

    UIPKChoosePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pk.UIPKChoosePanel",
    },

    UIBossEnergyPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.boss.UIBossEnergyPanel",
    },

    UIPKRewordPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.pk.UIPKRewordPanel",
    },

    UIGrowingPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.growing.UIGrowingPanel",
    },

    UISwitchPanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.set.UISwitchPanel",
        isFull = true,
    },

    UIInvitePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.invite.UIInvitePanel",
    },

    UITransferPanel = {
        isFull = true,
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.transfer.UITransferPanel",
    },

    UICustomNoticePanel = {
        layer = LAYER.LAYER_PANEL,
        path = "game.UI.common.UICustomNoticePanel",
    },
}

-- 面板弹框特性黑名单
------------------------------------
local OPEN_ACTION_BLACK_LIST = {
}

-- 二级模态界面动画黑名单
local MODEL_ACTION_BLACK_LIST = {
    "UILogin",
    "UISelectNew",
    "UIInputAccountPanel",
    "UICityPanel",
    "UIWorldPanel",
    "ConnectingPanel",
    "UISystemMessagePanel",
    "UITipsWarning",
    "TrainCard",
    "TrainSoldierCard",
    "UpgradePanel",
    "UIHeroGarrisionPanel",
    "UISetPanel",
    "BuildPanel",
    "UITaskTips",
    "UIMailPanel",
    "UIMailListPanel",
    "UIMailDetailPanel",
    "UIMailBattlePanel",
    "UISelectUnion",
    "UIUseItemPanel",
    "UIUseItemPanel",
    "UINPCPanel",
    "UIGuideBGPanel",
    "UISecondWorldPanel",
    "UISecondWorldPanel",
    "UIDetailFirstPanel",
    "UIUnionSearchPanel",
    "UIUnionForeignHandlePanel",
    "UIUWarRecordsPanel",
    "UIAttackEffect",
    "UIEquipPutDown",
    "UISeeking",
    "UIDeveloperPanel",
    "UIBattleErrorcode",
    "UIBattleErrorcodeNo",
    "UIGetChannelPanel",
    "UIUpPowerPanel",
}

local allPlists = {}
function PanelManager:getloadBigMemoPlists()
    for i,v in pairs(_panelPath) do
        if v.unload then
            allPlists[v.unload] = true
        end
    end
    return allPlists
end

function PanelManager:createPanel(name)
    local node = _panel[name]
    local path = _panelPath[name]
    if node == nil then
        if path ~= nil then
            local panel = require("res." .. path.path)
            node = panel.new()
            if OPEN_WIDGET_CACHE then
                node:retain()
            end    
            node:setNodeEventEnabled(true)
            node:setName(name)
            _panel[name] = node
        else
            log.debug("!ERROR can not found panel : %s", name)
        end
    end
    return node
end

function PanelManager:destroyPanel(name)
    local node = self:closePanel(name)
    if node then
        if OPEN_WIDGET_CACHE then
            node:release()
        end     
        _panel[name] = nil
    end
end

function PanelManager:destroyAllPanel()
    for k,v in pairs(_panel) do
        if v:getParent() then        
            v:removeFromParent(true)
        else
            --v:onExit()
        end
        
        if OPEN_WIDGET_CACHE then
            v:release()
        end
        _panel[k] = nil        
    end
    _panel = {}
    _panelStack = {}
end

--销毁面板世界面板
function PanelManager:destroyAllWorldPanel()
    local isRemove = false
    local removeList = {}
    for i = 1, #_panelStack do
        local name = _panelStack[#_panelStack - i + 1]
        if name == "UIWorldPanel" then
            table.insert(removeList,name)
            isRemove = true
            break
        else
            table.insert(removeList,name)
        end
    end

    if isRemove then
        for i,name in ipairs(removeList) do
            self:destroyPanel(name,true)
        end
    end
end

--销毁面板世界面板
function PanelManager:destroyAllCityPanel()
    local isRemove = false
    local removeList = {}
    for i = 1, #_panelStack do
        local name = _panelStack[#_panelStack - i + 1]
        if name == "UICityPanel" then
            isRemove = true
            break
        else
            table.insert(removeList,name)
        end
    end

    if isRemove then
        for i,name in ipairs(removeList) do
            self:destroyPanel(name,true)
        end
    end
end
function PanelManager:destroyAllCachePanel()
    for k,v in pairs(_panel) do
        if v:getParent() then

        else
            if OPEN_WIDGET_CACHE then
                v:release()
            end     
            _panel[k] = nil
        end      
    end
end

local openIngPanel = { --正在打开的面板
}
--callBackFunc ,关闭面板name时调用
function PanelManager:openPanel(name, callFunc, isSkipLoad)
    print("---------openPanel name=",name)

    local panelConfig = _panelPath[name]

    openIngPanel[name] = true 

    if panelConfig and panelConfig.unload and (not isSkipLoad) then
        -- gdisplay.removeSpriteFrames(_panelPath[name].unload, string.gsub(_panelPath[name].unload,".plist",".png"))
        gdisplay.loadSpriteFrames(_panelPath[name].unload)
    end
    
    if name ~= "ConnectingPanel" then
        self.nowCreatingName = name
    end

    local node = self:createPanel(name)
    if node and not tolua.isnull(node) then
        node.onExitCallFunc = callFunc
        if node:getParent() then            
            node:getParent():removeChild(node, true)
            self:removeStack(name)
        end
        if tolua.isnull(node) then return end
        node:setVisible(true)
        
        self:addStack(name)
        scMgr:CurScene():addChild(node, _panelPath[name].layer)

        -- 二级模态界面打开动画
        if not panelConfig.isFull and self:needModelAction(name) then 
            global.sactionMgr:openModelAction(node)
        end
    end
    gevent:call(gameEvent.EV_ON_PANEL_OPEN, name)
    -- 打开面板检测联盟tips
    local isRoot = global.panelMgr:isRootPanel()
    if not isRoot then
        gevent:call(global.gameEvent.EV_ON_UNIONHINT, true)
    end
    return node
end

function PanelManager:runOpenAction(node)
    local widget = global.uiMgr:getWidget(node, "Image_Panel")
    if widget == nil then
        widget = global.uiMgr:getWidget(node, "Image_Widget")
    end
    if widget == nil then
        widget = global.uiMgr:getWidget(node, "Image_Main")
    end

    if widget then
        local onCallFunc = function()
            gevent:call(gameEvent.OPEN_PANEL_ACTION_COMPLETED)
            global.guideMgr:activateStep(GUIDE_CONST.ON_PANEL_OPENED, node:getName())
        end

        local array = cc.Array:create()
        array:addObject(cc.EaseElasticOut:create(cc.ScaleTo:create(0.21, 1, 1), 0.09))
        array:addObject(cc.CallFunc:create(onCallFunc))
        local action = cc.Sequence:create(array)
        widget:setScale(0.6)
        widget:runAction(action)
    end
end

function PanelManager:needOpenAction(name)
    for k, v in pairs(OPEN_ACTION_BLACK_LIST) do
        if v == name then
            return false
        end
    end
    return true
end

function PanelManager:needModelAction(name)
    for k, v in pairs(MODEL_ACTION_BLACK_LIST) do
        if v == name then
            return false
        end
    end
    return true
end

--获取面板文件的句柄
function PanelManager:getPanelFileHandler(name)
    local panel = _panel[name]
    if panel ~= nil then
        return panel
    else
        return nil
    end
end

function PanelManager:getPanel(name)
    local node = _panel[name]
    if not node then
        node = self:createPanel(name)
        -- global.scMgr:CurScene():addChild(node)
    end
    return node
end

function PanelManager:isPanelOpened(name)
    local node = _panel[name]
    if node and node:getParent() then
        return true
    else
        return false
    end
end

function PanelManager:isPanelExist(name)

    local node = _panel[name]
    if node then
        return true
    else
        return false
    end
end

function PanelManager:isPanelOpenIng(name) --面板是否正在打开

    return openIngPanel[name]
end

function PanelManager:closePanelForBtn(name  , isSkipAction, isSkipLoad)

    local node = _panel[name]
    if node and not tolua.isnull(node) and node:getParent() then    
        -- 二级模态界面关闭动画
        if not _panelPath[name].isFull and self:needModelAction(name) then 
        else
            gsound.stopEffect("city_click")
            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
        end
    else
        gsound.stopEffect("city_click")
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    end

    self:closePanel(name , isSkipAction, nil, isSkipLoad)  
    
end

function PanelManager:checkUnload(panelName)
        
    if not _panelPath[panelName] then return end

    local unloadName = _panelPath[panelName].unload    

    local isExist = false
    for i = 1, #_panelStack do
        local name = _panelStack[#_panelStack - i + 1]

        if name ~= panelName then

            if _panelPath[name].unload == unloadName then
                isExist = true
                break
            end
        end    
    end

    if not isExist and unloadName and not global.isMemEnough then
        gdisplay.removeSpriteFrames(unloadName, string.gsub(unloadName,".plist",".png"))
        print('start unload ' .. unloadName)
    end
end

function PanelManager:closePanel(name,isSkipAction, isNoCloseSound, isSkipLoad)

    print('panelMgr close panel',name)

    openIngPanel[name] = false 

    local node = _panel[name]
    if node and not tolua.isnull(node) and node:getParent() then   

        local exitCall = function ()

            local lastTopName = self:getTopPanelName()
            node:getParent():removeChild(node, true)
            self:removeStack(name)

             if node._panelModal and not tolua.isnull(node._panelModal) then
               node._panelModal:removeFromParent() 
            end
            
            --node:onExit()
    --        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
            if node.onExitCallFunc then
                node.onExitCallFunc()
                node.onExitCallFunc = nil
            end

            if node.onDefineExit then
                node.onDefineExit(node)
            end

            if not isSkipLoad then
                self:checkUnload(name)
            end

            -- if _panelPath[name] and _panelPath[name].unload then
            --     gdisplay.removeSpriteFrames(_panelPath[name].unload, string.gsub(_panelPath[name].unload,".plist",".png"))
            -- end

            if lastTopName == name then --顶层界面发生变化才需要发消息
                gevent:call(gameEvent.EV_ON_PANEL_CLOSE, name)
            end

            -- if global.scMgr:isMainScene() and self:getTopPanelName() == "UICityPanel" then
            --     self:getPanel("UICityPanel"):setVisible(true)
            -- end
        end

        -- 二级模态界面关闭动画
        if not _panelPath[name].isFull and self:needModelAction(name) and not isSkipAction then 
            global.sactionMgr:closeModelAction(node, exitCall, isNoCloseSound)
        else
            exitCall()
        end

    end

    if not OPEN_WIDGET_CACHE then
        _panel[name] = nil
    end

    return node
end

--关闭除了cityPanel以及worldPanel等为底的panel
function PanelManager:closePanelExecptDown()
    
    -- dump(_panelStack,"check self _panelStack")

    -- 从顶层panel开始关闭
    -- for i=#_panelStack,1,-1 do
    --     local name = _panelStack[i]
    --     local path = _panelPath[name]
    --     if path.layer ~= LAYER.LAYER_PANEL_DOWN then
    --         self:closePanel(name)
    --     end     
    -- end

    dump(_panelStack,'...panel stack')

    local removeList = {}
    for i = 1, #_panelStack do
        local name = _panelStack[#_panelStack - i + 1]
        local path = _panelPath[name]

        if path.layer ~= LAYER.LAYER_PANEL_DOWN then
            table.insert(removeList,name)
        end   
    end

    if #removeList>0 then
        for i,name in ipairs(removeList) do
            self:closePanel(name)
        end
    end

    -- for _,name in ipairs(_panelStack) do

    --     local path = _panelPath[name]
    --     if path.layer ~= LAYER.LAYER_PANEL_DOWN then

    --         self:closePanel(name)
    --     end
    -- end
end

function PanelManager:addPanel(node)
    scMgr:CurScene():addChild(node)
end

function PanelManager:getStack()
    return _panelStack
end

function PanelManager:addStack(name)    
    local panelLayer = _panelPath[name].layer
    if panelLayer and panelLayer < LAYER.LAYER_TOPBAR and panelLayer ~= LAYER.LAYER_MENU then
        local insertIndex = #_panelStack + 1
        for k,v in ipairs(_panelStack) do
            local vLayer = _panelPath[v].layer
            if panelLayer < vLayer then
                insertIndex = k
                break
            end
        end

        table.insert(_panelStack, insertIndex, name)

        if _panelPath[name].isFull then
            for i = 1, insertIndex - 1 do
                local node = self:getPanel(_panelStack[i])
                node:setVisible(false)
            end
        end
    end
end

function PanelManager:removeStack(name)
    local removeIndex = #_panelStack
    if _panelStack[#_panelStack] ~= name then
        removeIndex = nil
        for k, v in ipairs(_panelStack) do
            if v == name then
                removeIndex = k
                break
            end
        end
    end

    if removeIndex then
        table.remove(_panelStack, removeIndex)

        if _panelPath[name].isFull then
            for i = 1, #_panelStack do
                local name = _panelStack[#_panelStack - i + 1]
                local node = self:getPanel(name)
                node:setVisible(true)
                if _panelPath[name].isFull then
                    break
                end
            end
        end
    end
end

--关闭所有已经开启的联盟相关界面面板
function PanelManager:closeAllUnionPanel()
    local removeList = {}
    for i = 1, #_panelStack do
        local name = _panelStack[#_panelStack - i + 1]

        if string.find(_panelPath[name].path,"game.UI.union") then
            table.insert(removeList,name)
        end
    end

    if #removeList>0 then
        for i,name in ipairs(removeList) do
            self:closePanel(name)
        end
    end
end


--关闭面板直到出现世界面板
function PanelManager:closePanelShowWorld()
    local isRemove = false
    local removeList = {}
    for i = 1, #_panelStack do
        local name = _panelStack[#_panelStack - i + 1]
        if name == "UIWorldPanel" then
            isRemove = true
            break
        else
            table.insert(removeList,name)
        end
    end

    if isRemove then
        for i,name in ipairs(removeList) do
            self:closePanel(name,true)
        end
    end
end

function PanelManager:closeTopPanel(isSkipAction)
    self:closePanel(self:getTopPanelName(), isSkipAction)
end

function PanelManager:closePanelForAndroidBack()
    
    --如果正在联网，则不处理这个事件
    if global.isConnecting then
        return
    end

    if global.panelMgr:isPanelOpened("UIPromptPanel") then
        -- 关闭弹窗
        return global.panelMgr:closePanel("UIPromptPanel")
    end
    if _panelStack and #_panelStack <= 1 then
        global.sdkBridge:exitQuickSdk()
    else
        local tp = self:getTopPanel()
        if tp.onCloseHandler then
            tp:onCloseHandler()
        elseif tp.exitCall then
            tp:exitCall()
        elseif tp.exit_call then
            tp:exit_call()
        elseif tp.btn_exit then
            tp:btn_exit()
        else
            self:closeTopPanel()
        end
    end
end

--是否处于cityPanle或者worldPanel
function PanelManager:isRootPanel()
        
    local topPanel = self:getTopPanelName()
    return topPanel == "UICityPanel" or topPanel == "UIWorldPanel" or topPanel == "BuildPanel"
end

-- 会吧tips panel加入判断
function PanelManager:isPanelTop(panelName)
    
    if _panelPath[panelName].layer == LAYER.LAYER_TIPS then
        return self:isPanelOpened(panelName)
    else
        return self:getTopPanelName() == panelName
    end
end

function PanelManager:getTopTopPanelName()
    log.debug("=========> getTopPanelName %s", vardump(_panelStack))
    if #_panelStack > 1 then
        return _panelStack[#_panelStack-1]
    else
        return nil
    end
end

function PanelManager:getIndexPanelName(index)
    index =index -1 
    if #_panelStack > 1 and index > 0   then
        return _panelStack[#_panelStack-index]
    else
        return nil
    end
end


function PanelManager:getTopPanelName()
    log.debug("=========> getTopPanelName %s", vardump(_panelStack))
    return _panelStack[#_panelStack]
end

function PanelManager:getTopPanel()

    print(self:getTopPanelName())
    return self:getPanel(self:getTopPanelName())
end

function PanelManager:setScrollEnabled(enabled)

    if self:isPanelExist("UIMainCity") then
        local panel = self:getPanel("UIMainCity")
        panel.mScrollView:setScrollEnabled(enabled)
    end

    if self:isPanelExist("SelectHeroPanel") then
        local panel = self:getPanel("SelectHeroPanel")
        local scrollView = panel:getScrollView()
        scrollView:setScrollEnabled(enabled)
    end

    if self:isPanelExist("UIHeroListPanel") then
        local panel = self:getPanel("UIHeroListPanel")
        panel.mTableView:setScrollEnabled(enabled)
    end

    if self:isPanelExist("UIHeroUpgradePanel") then
        local panel = self:getPanel("UIHeroUpgradePanel")
        panel.mTableView:setScrollEnabled(enabled)
    end

end

function PanelManager:removeWidget(widget)
    local name = widget:getName()
    self:closePanel(name)
end

function PanelManager:addWidgetToSuper(widget)
    scMgr:CurScene():addChild(widget, LAYER.LAYER_SUPER)
end

function PanelManager:addWidgetToTopbar(widget)
    scMgr:CurScene():addChild(widget, LAYER.LAYER_TOPBAR)
end

function PanelManager:addWidgetToGuide(widget)
    scMgr:CurScene():addChild(widget, LAYER.LAYER_GUIDE)
end

function PanelManager:addWidgetToPanelDown(widget)
    scMgr:CurScene():addChild(widget, LAYER.LAYER_PANEL_DOWN)
end

function PanelManager:trimScrollView(i_scrollView,i_topPanel)
    if not i_scrollView then return end

    local height = gdisplay.height-i_topPanel:getContentSize().height
    i_scrollView:setContentSize(cc.size(gdisplay.width,height))
end

-- single icon handler------------->
local fileUtils = cc.FileUtils:getInstance()
local records = {}
function PanelManager:setTextureForAsync(node,imagePath,noRemove,callFunc)
    -- print(debug.traceback())
    -- print(noRemove)
    -- node:setVisible(false)
    self:setTextureFor(node,imagePath,noRemove,callFunc,true)
end
function PanelManager:setTextureFor(node,imagePath,noRemove,callFunc,isAsync)
    -- print(debug.traceback())
    -- print(noRemove)
    -- node:setVisible(false)
    if not fileUtils:isFileExist(imagePath) then
        if _CPP_RELEASE == 1 then
            return 
        else
            imagePath = imagePath or ""
            return global.tipsMgr:showWarning("no icon->"..imagePath)
        end
    end
    if noRemove == nil then
        noRemove = true
    else
        noRemove = noRemove
    end
    -- local noRemove = global.funcGame:isOutofMemMB(WDEFINE.FREE_ANDROID_RES_LIMIT_MEM)
    local call = function()
        -- body
        if not node or tolua.isnull(node) then
            records[imagePath] = nil
            gdisplay.removeImage(imagePath)
        else
            -- node:setVisible(true)
            if tolua.type(node) == "cc.Sprite" then
                node:setTexture(imagePath)
            elseif tolua.type(node) == "ccui.Button" then
                node:loadTextureNormal(imagePath)
                node:loadTexturePressed(imagePath)
            elseif tolua.type(node) == "ccui.Scale9Sprite" then
            elseif tolua.type(node) == "ccui.ImageView" then
                node:loadTexture(imagePath,ccui.TextureResType.localType)
            else
            end
            if not noRemove then
                -- gdisplay.removeImage(imagePath)
                records[imagePath] = true
            else
                records[imagePath] = true
            end
            if callFunc then callFunc() end
        end
    end
    if isAsync then
        gdisplay.addImageAsync(imagePath, call)
    else
        call()
    end
end

function PanelManager:clearRecords()
    -- dump(records)
    -- print(debug.traceback())
    if not records then
        return
    end
    if table.nums(records) > 0 then
        dump(records)
    end
    for k,v in pairs(records) do
        gdisplay.removeImage(k)
    end
    records = {}
end

local queue_add = {}
local is_loading = false
function PanelManager:setTextureForAsyncByQueue(node,imagePath,noRemove)
    table.insert(queue_add,{nd=node,img=imagePath,nr=noRemove})

    local updateCall = nil
    updateCall = function()
        -- body
        if not node or tolua.isnull(node) then
            return
        end
        if queue_add and #queue_add <= 0 then
            return
        end
        is_loading = true
        local imagePath = queue_add[1].img
        local node = queue_add[1].nd
        local noRemove = queue_add[1].nr
        gdisplay.addImageAsync(imagePath, function()
            -- body
            if not node or tolua.isnull(node) then
                table.remove(queue_add,1)
                return updateCall()
            end
            if tolua.type(node) == "cc.Sprite" then
                node:setTexture(imagePath)
            elseif tolua.type(node) == "ccui.Button" then
                node:loadTextureNormal(imagePath)
                node:loadTexturePressed(imagePath)
            elseif tolua.type(node) == "ccui.Scale9Sprite" then
            elseif tolua.type(node) == "ccui.ImageView" then
                node:loadTexture(imagePath,ccui.TextureResType.localType)
            else
            end
            if not noRemove then
                gdisplay.removeImage(imagePath)
            end
            table.remove(queue_add,1)
            is_loading = false
            updateCall()
        end)
    end
    if is_loading then
    else
        updateCall()
    end
end

function PanelManager:clearTextureAsyncQueue()
    queue_add = {}
end

global.panelMgr = PanelManager