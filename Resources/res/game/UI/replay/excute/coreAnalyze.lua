--region TabControl.lua
--Author : Song
--Date   : 2016/4/14

local coreAnalyze = class("coreAnalyze")

local hero  =require("game.UI.replay.mode.hero")
local soldier  =require("game.UI.replay.mode.hero")
local troop  =require("game.UI.replay.mode.troop")
local war  =require("game.UI.replay.mode.war")


local decode_  =require("game.UI.replay.excute.decode")

local fightDef = {attack = 1 , def = 2 } 

local FIGHTTYPE = {	CITY =1 , YEDI  = 2 , YEGUAI = 3 ,HERO = 4 ,  YINGDI =5 , XIAOCUNZHUANG = 6 , QIJI = 7  , SHANDIAN = 8  , WORLDBOSS =  9  ,
					
 		XIAOSHENDIAN = 18 , }

local SOLDIERTYPE  = {SOLDIER = 1 , JIANTA = 2 , XIANJING = 3 , CHENGQIANG =4 }


local SECTION = {
				PVP={	[1]=global.luaCfg:get_local_string(10731) ,
						[2]=global.luaCfg:get_local_string(10732) ,
						[3]=global.luaCfg:get_local_string(10733) ,
					},
				PVE={	
						[1]= global.luaCfg:get_local_string(10734) ,
						[2]= global.luaCfg:get_local_string(10735) ,
					}
				}



local  showSoldierNumber =  6



function coreAnalyze:set_war_data(war_data)

	self.war_data = war_data 
end 

function coreAnalyze:get_war_data()

	return self.war_data 
end 


function coreAnalyze:init(msg)  -- 传进来的是一场 war 数据

end 


function coreAnalyze:reStart()

	self:start(self.clone_SaveFight)
end


function coreAnalyze:skip(Percent , handlerEndCall) 

	local skip_round = math.floor(self:get_all_round() *  Percent/100)

	local crunt_round =  self:get_crunt_round()

	if skip_round <=0 then 
		skip_round = 1 
	end 

	if crunt_round == skip_round then handlerEndCall() return end 

	-- print(skip_round,"跳转 回合。。。。。。。。" ,crunt_round,"---------当前回合")	

	if crunt_round < skip_round then 

		for i= 1, skip_round - crunt_round  do 

			if i ==1 then 
				self.s = os.clock()
			end 
			if  i == skip_round - crunt_round -1  or  i == skip_round - crunt_round  then 
				self:decode_next()
			else 
				self:runData()
			end  

			if i ==skip_round - crunt_round then 

				print("消耗的时间===>>>>",os.clock()- self.s)
				handlerEndCall()
			end
		end 
	else
		 self:reStart()
		 self:skip(Percent , handlerEndCall)
	end 


end 


-- message TroopInfo
-- {
--     required int32      lTroopType      = 1; //部队类型  1:城池战  2.打野地 3.打野怪 4.英雄类型 5.怪物营地 6.小村庄 7.奇迹战斗
--     required int32      lTroopPower     = 2;//部队总战力
--     optional int32      lTroopID        = 3;//部队ID
--     optional string	lTroopName	    = 4;//部队名字
--     optional int32      lHeroID         = 5;//英雄ID
--     optional int32      lHeroLV         = 6;//英雄等级 
--     optional int32      lHeroAttr       = 7;//英雄统帅
--     repeated int32	tagEquip	    = 8;//英雄所有装备ID
--     optional string     lLeaderName     = 9;//领主名字
--     optional int32      lCommand        = 10;//指令      5.增援  6.集结 10.驻守
--     repeated SoldierInfo    tagSoldier  = 11;//士兵信息，根据soldierType判断
--     optional int32	lUid		    = 12;//用户ID
-- }


-- message SoldierInfo
-- {
--     required int32      soldierType         =1;// 士兵类型 1:士兵，2箭塔，3陷阱 4,城墙
--     required int32      soldierId       = 2;//士兵ID
--     optional int32      soldierLV       = 3;//士兵等级
--     required int32      lcount          = 4;//士兵数量
--     required int32      lIndex          = 5;//士兵索引
-- }


-- [3000013] = { id=3000013,  name="女巫的部队",  type=300,  level=1,  wartype=3,  energy=10,  typename="混合",  defensename=10190,  defensesoldier={},
--     defensesoldiernum={},  defensesoldiernumadd={},  attackname=0,  attacksoldier={23171,23141,23121,23081,23151},  attacksoldiernum={10,10,10,10,10},
--       attacksoldiernumadd={0,0,0,0,0},  drop={},  seeitem={},  exp=1000,  file=3201,  sort=3,  scale=0,  text=0,  size=1.5,  combat=0,  point=0,  effect=1,  normal=0,  weight=0,  name_en="",  typename_en="",  },



function coreAnalyze:MakeData(data) --模拟战斗

	local data = data.tagBody.tagSaveFightReplay 

	local soldier_count = global.luaCfg:get_wild_monster_by(3000013).attacksoldiernum[1]

	local monster_data = global.luaCfg:get_wild_monster_by(3000013)
	local monster =monster_data.attacksoldier

	local tagAtkTroopInfo = {
                 [1] = {
                     lCommand    = 2 , 
                     lLeaderName = monster_data.name, 
                     lTroopID    = -1, 
                     lTroopPower = data.lAtkInitPower, 
                     lHeroID	 =  10001 ,
                     lHeroLV	 = 10 ,
                     lTroopType  = 4 , 
                     lHeroStar	= 5 ,
                     tagEquip	 = {
                     	[1] = 7516041 , 
                     	[2] = 7716042 , 
                     	[3] = 7916043 , 
                     	[4] = 8516044 , 
                     	[5] = 8316045 , 
                     	[6] = 8116046 , 
                	 },
                     tagSoldier = {
                         [1] = {
                             lIndex      = 0,
                             lcount      = soldier_count,
                             soldierId   = monster[1],
                             soldierLV   = monster_data.level,
                             soldierType = 1,
                         },
                         
                         [2]={
                             lIndex      = 1,
                             lcount      = soldier_count,
                             soldierId   = monster[2],
                             soldierLV   = monster_data.level,
                             soldierType = 1,
                         } , 

                         [3]={
                             lIndex      = 2,
                             lcount      = soldier_count,
                             soldierId   = monster[3],
                             soldierLV   = monster_data.level,
                             soldierType = 1,
                         } , 


                         [4]={
                             lIndex      = 3,
                             lcount      = soldier_count,
                             soldierId   = monster[4],
                             soldierLV   = monster_data.level,
                             soldierType = 1,
                         } , 

                         [5]={
                             lIndex      = 4,
                             lcount      = soldier_count,
                             soldierId   = monster[5],
                             soldierLV   = monster_data.level,
                             soldierType = 1,
                         }, 
                     },
                },
    }

 	for _ ,v in pairs(data.lPkInfo) do 

 		if not  v.tagAtkSoldier[1].ltroopid then 

 			 v.tagAtkSoldier[1].ltroopid = tagAtkTroopInfo[1].lTroopID

 		end 
 	end 

 	data.tagAtkTroopInfo = tagAtkTroopInfo

end 


function coreAnalyze:setIsImitate(data)

	local flg = false 

	local data = data.tagBody.tagSaveFightReplay 

	if data.lRound > 0  and data.lPkInfo[1] and  data.lPkInfo[1].tagAtkSoldier[1]  then 

		 if not  data.lPkInfo[1].tagAtkSoldier[1].ltroopid  then 

		 	 flg =  true 
		 end 

	end  

	self.imitate = flg 
end 

function coreAnalyze:isImitate()

	return self.imitate
end 


function coreAnalyze:start(data)

	self.clone_SaveFight = clone(data)

	self:setIsImitate(data)

	if self:isImitate() then 

		self:MakeData(data)
	end 

	dump(data,"self.SaveFight  最原始数据//////")

	self.title  ={[1]= "城外冲突战" ,[2] = ""}

	self.result = ""

	self.attack_hero = nil 
	self.df_hero =nil 

	self.crunt_atack_hero = nil 
	self.crunt_df_hero = nil 

	self.crunt_attack_solder = {}
	self.crunt_def_solder = {}

	self.crunt_pk_soldier =nil 
	self.crunt_pk_right_solder ={}
	self.crunt_pk_left_solder ={}

	self.crunt_round = 0 
	self.all_round = 0

	self.war_result = 1
	self.war_type = 0
	self.lSection = 0

	self.crunt_pk_left_solder_hurt =  0
	self.crunt_pk_right_solder_hurt =  0


	self.oldBottomSoliderStation  = -1 

	self.oldTopSoliderStation  = -1 

	self.oldBottomHeroStation = -1 

	self.oldTopHeroStationn  =  -1 

	self.SaveFight = data.tagBody.tagSaveFightReplay

	print(self.SaveFight.lFightType ,"self.SaveFight.lFightType -->>")
	
	if self.SaveFight.lFightType  == FIGHTTYPE.SHANDIAN or  self.SaveFight.lFightType == FIGHTTYPE.XIAOSHENDIAN then  --神殿的类型 是 打野地的类型。
		self.SaveFight.lFightType  = FIGHTTYPE.YEDI
	end 


	self.lDefInitPower =clone(self.SaveFight.lDefInitPower)

	self.lAtkInitPower =clone( self.SaveFight.lAtkInitPower)

	self.war = self.SaveFight 

	if not self.SaveFight .tagAtkTroopInfo then 
		self.SaveFight .tagAtkTroopInfo={}
	end

	if not self.SaveFight.tagDefTroopInfo then 
		 self.SaveFight .tagDefTroopInfo={}
	end

	if not self.SaveFight.lPkInfo then 
		 self.SaveFight .lPkInfo={}
	end



	self:set_all_round(self.SaveFight.lRound)

	self:set_war_type(self.SaveFight.lFightType)

	-- self:set_lSection(self.SaveFight.lSection)

	self:set_war_result(self.SaveFight.lResult)



	self:set_attack_hero(self.SaveFight.tagAtkTroopInfo)  -- 设置攻击方英雄信息

	self:set_df_hero(self.SaveFight.tagDefTroopInfo)

	self:set_pkInfo(self.SaveFight.lPkInfo)

	self:set_lPveID(self.SaveFight.lPveID)



	-- dump(self:get_df_hero(),"设置id前")

	-- pve 
	if self:get_war_type() ~= FIGHTTYPE.CITY and self:get_war_type() ~= FIGHTTYPE.XIAOCUNZHUANG then   -- pve  野怪 没有 heroid
		for _ ,v in  pairs(self:get_df_hero()) do
			if v.lTroopType ~= FIGHTTYPE.HERO then 
				v.lHeroID = self:get_lPveID()
			end 
		end 
	end 

	-- dump(self:get_df_hero(),"设置id后")

	for _ ,v in pairs(self:get_df_hero()) do 

		v.war_type = self:get_war_type()
	end

	for _ ,v in pairs(self:get_attack_hero()) do 

		v.war_type = self:get_war_type()

	end 
 		
 	for _ ,v  in pairs(self:get_attack_hero()) do 

 		--设置部队id
		for _ ,vv  in pairs(v.tagSoldier or {}) do  -- or {} 容错处理
 			vv.lTroopID  = v.lTroopID
 			vv.lUid  = v.lUid
 		end 	

	 --设置保留原始城防值 
 		if v.lTroopID == 5 then 
 			for _ ,vv  in pairs(v.tagSoldier or {} ) do 
 				if vv.soldierId == 70 then 
 					vv.old_count = vv.lcount
 				end 
 			end 
 		end 
 	end

 	for _ ,v  in pairs(self:get_df_hero() or {}) do 

 		for _ ,vv  in pairs(v.tagSoldier or {} ) do 
 			vv.lTroopID  = v.lTroopID
 			vv.lUid  = v.lUid
 		end 	


 		if v.lTroopID == 5 then 
 			for _ ,vv  in pairs(v.tagSoldier or {}) do 
 				if vv.soldierId == 70 then 
 					vv.old_count = vv.lcount
 				end 
 			end 
 		end 
 	end

 	self:setAllStage(self.war.lSection)

	self.lastTitleStatus  =  0
	-- self:setIndex()
	global.SoldierBufferData:setReplayData(self.war.tagAllBuff or {} )

	self:setProgress()

	self:setChief()

	self:setOriginalAttackHero(self:get_attack_hero())
	
	self:setOriginalDefckHero(self:get_df_hero())

	self:decode_next()
end 

-- message AllBuff
-- {
-- 	repeated BuffCore	tagcommonBuff	= 1;
-- 	repeated BuffCore	tagHeroBuff	    = 2;
-- }

-- message SaveFightReplayReq
-- {
-- }
-- message SaveFightReplayResp
-- {
--     required int32      lSection        = 1;//阶段数
--     required int32      lRound          = 2;//总回合数
--     required int32      lFightType      = 3;//战斗类型  1:城池战  2.打野地 3.打野怪 5.怪物营地 6.小村庄 7.奇迹战斗
--     optional int32      lPveID          = 4;//PVE   （野地ID，怪物ID，营地ID，奇迹ID）
--     required int32      lAtkInitPower   = 5;//攻击方初始战力
--     required int32      lDefInitPower   = 6;//防御方初始战力
--     repeated TroopInfo  tagAtkTroopInfo = 7;//攻击方初始信息
--     repeated TroopInfo  tagDefTroopInfo = 8;//防御方初始信息
--     repeated PkInfo     lPkInfo         = 9;//战斗信息
--     required int32      lResult         = 10;//战斗结果  1.攻击方胜利  2.防御方胜利       
--     repeated AllBuff	tagAllBuff      = 11;//buff库
-- }


function coreAnalyze:setIndex()

	for _ ,v in pairs(self:get_df_hero()) do 

		for index  ,vv in  pairs(v.tagSoldier) do 

			vv.index = index
		end 
	end 

	for _ ,v in pairs(self:get_attack_hero() )do 
		
		for index  ,vv in pairs(v.tagSoldier) do 

			vv.index = index
		end 
	end 

end 


-- 默认是：上面是攻击方  左边是攻击方
-- 默认是：下面是攻击方	 右边是攻击方



--------------------- 攻击方  打 防守方                       防守方 -----攻击方

function coreAnalyze:decode_next()

	-- local  p1  = print 
	-- 	print=function()end 

	print("self:get_crunt_round()" , self:get_crunt_round() , "self:get_all_round() ",self:get_all_round() )

	self:set_last_attack_Hero()

	self:set_last_def_hero()

	if self:get_crunt_round() > self:get_all_round()  then 

		return 
	end

	if  self:get_all_round() <=0 then 

		return 
	end 


	self:set_crunt_round(self:get_crunt_round()+1)

	-- dump(self:get_crunt_round() , "当前 pk 回合")

	local crut_pk_info = self:get_pkInfo()[self:get_crunt_round()]

	if not crut_pk_info  then return end 

	self:set_cur_pk_info(crut_pk_info)

	dump(crut_pk_info , "当前pk 信息")

	local crunt_top_solder_station = nil 

	local  crunt_pk_left_solder  =  nil 

	local crunt_bottom_solder_station  = nil 

	local crunt_pk_right_solder = nil 

	local attack_effect_station = 1 


	local RightPKSoliderHur = nil

	local LeftPKSoliderHur = nil 


	local  crunt_attack_solder_type = self:checkSolidType(self:get_cur_pk_info().tagAtkSoldier[1]) 

	local  crunt_def_solder_type  	= self:checkSolidType(self:get_cur_pk_info().tagDefSoldier[1])


	print(crunt_attack_solder_type,"当前攻击者 所属联盟（攻击还是防御）")

	print(crunt_def_solder_type,"当前防御者 所属联盟（攻击还是防御）")


	self.isFanGong = crunt_attack_solder_type == fightDef.def


	print("当前攻击类型      crunt_attack_solder_type  ==  fightDef.attack   ----》 " ,  crunt_attack_solder_type  ==  fightDef.attack)

	if  crunt_attack_solder_type  ==  fightDef.attack  then 


		local attack_hero = self:findHeroByTroopId(self:get_cur_pk_info().tagAtkSoldier[1].ltroopid)

		self:set_crunt_atack_hero(attack_hero)

		dump(attack_hero , "top 英雄") -- 当前防守英雄数据


		local defHero = self:findHeroByTroopId(self:get_cur_pk_info().tagDefSoldier[1].ltroopid)

		dump(defHero , "bottom 方英雄")

		self:set_crunt_df_hero(defHero)

		local crunt_attack_solder =  self:get_crunt_atack_hero().tagSoldier

		self:set_crunt_attack_solder(crunt_attack_solder)

		dump(crunt_attack_solder , "top 士兵 ")

		local crunt_def_solder =  self:get_crunt_df_hero().tagSoldier or {} --protect 

		self:set_crunt_def_solder(crunt_def_solder)

		dump(crunt_def_solder , "bottom 士兵")


		crunt_top_solder_station = self:getCruntSelectSoliderStation(self:get_cur_pk_info().tagAtkSoldier[1].lIndex , fightDef.attack)  

		attack_effect_station = 1 


		RightPKSoliderHur = self:get_cur_pk_info().tagDefSoldier[1].lcount


		LeftPKSoliderHur= self:get_cur_pk_info().tagAtkSoldier[1].lcount


		crunt_bottom_solder_station = self:getCruntSelectSoliderStation(self:get_cur_pk_info().tagDefSoldier[1].lIndex , fightDef.def)  


		crunt_pk_left_solder= self:getCruntSelectSolider(self:get_cur_pk_info().tagAtkSoldier[1].lIndex , fightDef.attack)


		crunt_pk_right_solder= self:getCruntSelectSolider(self:get_cur_pk_info().tagDefSoldier[1].lIndex , fightDef.def)



	else   -- 反攻 


		print("当前为 反攻类型-----------------------------------")

		dump(self.SaveFight)

		local attack_hero = self:findHeroByTroopId(self:get_cur_pk_info().tagAtkSoldier[1].ltroopid)

		local defHero = self:findHeroByTroopId(self:get_cur_pk_info().tagDefSoldier[1].ltroopid)

		self:set_crunt_df_hero(attack_hero)

		self:set_crunt_atack_hero(defHero)

		dump(defHero , "top 英雄")

		dump(attack_hero , "bottom 方英雄") -- 当前防守英雄数据


		local crunt_attack_solder = self:get_crunt_atack_hero().tagSoldier or {} 

		self:set_crunt_attack_solder(crunt_attack_solder)

		dump(crunt_attack_solder , "top 士兵 ")  -- 界面显示 top 

		local crunt_def_solder = self:get_crunt_df_hero().tagSoldier

		self:set_crunt_def_solder(crunt_def_solder)

		dump(crunt_def_solder , "bottom 士兵")


		crunt_top_solder_station = self:getCruntSelectSoliderStation(self:get_cur_pk_info().tagDefSoldier[1].lIndex , fightDef.attack) 

		crunt_bottom_solder_station = self:getCruntSelectSoliderStation(self:get_cur_pk_info().tagAtkSoldier[1].lIndex, fightDef.def)  


		RightPKSoliderHur = self:get_cur_pk_info().tagAtkSoldier[1].lcount

		LeftPKSoliderHur= self:get_cur_pk_info().tagDefSoldier[1].lcount

		crunt_pk_left_solder= self:getCruntSelectSolider(self:get_cur_pk_info().tagDefSoldier[1].lIndex , fightDef.attack)

		crunt_pk_right_solder= self:getCruntSelectSolider(self:get_cur_pk_info().tagAtkSoldier[1].lIndex , fightDef.def)

		attack_effect_station = 2 


	end 


	self:set_cur_atk_capacity(self:get_crunt_atack_hero().lTroopPower)

	self:set_cur_df_capacity(self:get_crunt_df_hero().lTroopPower)




	self:set_crunt_pk_left_solder(crunt_pk_left_solder) 

	self:set_crunt_pk_right_solder(crunt_pk_right_solder)

	self:setAttackerStation(attack_effect_station)

	self:setRightPKSoliderHurt(RightPKSoliderHur)

	self:setLeftPKSoliderHurt(LeftPKSoliderHur)



	dump(crunt_pk_left_solder , "left pK 士兵 ")

	dump(crunt_pk_right_solder , "right pK士兵 ")

	dump(RightPKSoliderHur , "right pK 士兵伤害")

	dump(LeftPKSoliderHur , "left pK 士兵伤害")



	----------更新前-保留老的数据----------------

	self:set_old_crunt_attack_solder()

	self:set_old_crunt_def_solder()

	self:set_old_crunt_pk_left_solder()

	self:set_old_crunt_pk_right_solder()

	self:set_old_cur_atk_capacity()

	self:set_old_cur_df_capacity()

	self:setOldBottomHeroStation(self:getBottomHeroStation())

	self:setOldTopHeroStation(self:getTopHeroStation())

	self:setOldTopSoliderStation(self:getTopSoliderStation())

	self:setOldBottomSoliderStation(self:getBottomSoliderStation())

	self:setLastTitleStatus()

	self:setLastAttackComat(self:getCruntAttackComat())
	self:setLastDefComat(self:getCruntDefComat())

	--------------update ------------------clone(----------------)----


	self:setTopSoliderStation(crunt_top_solder_station)

	self:setBottomSoliderStation(crunt_bottom_solder_station)


	print(crunt_top_solder_station , " top 士兵位置")

	print(crunt_bottom_solder_station , " bottom 士兵位置")


	local cruntTopHeroStationn = self:findHeroStation(self:get_crunt_atack_hero())
	local cruntBottomHeroStation = self:findHeroStation(self:get_crunt_df_hero())
	print(cruntTopHeroStationn , "top 英雄位置")

	print(cruntBottomHeroStation , "bottom 英雄位置")


	print(attack_effect_station,"攻击位置")

	self:setBottomHeroStation(cruntBottomHeroStation)
	self:setTopHeroStation(cruntTopHeroStationn)



	self:updateComat(self:get_cur_pk_info().tagAtkSoldier[1])
	self:updateComat(self:get_cur_pk_info().tagDefSoldier[1])

	self:updateSoldierNum(self:get_cur_pk_info().tagDefSoldier[1])
	self:updateSoldierNum(self:get_cur_pk_info().tagAtkSoldier[1])

	
	self:setSection(self:get_cur_pk_info().lSection)


	if self:get_war_type() == FIGHTTYPE.CITY or  self:get_war_type() == FIGHTTYPE.QIJI or   self:get_war_type() == FIGHTTYPE.YINGDI then

		self:setTitle(SECTION.PVP[self:getSection()])

	else

		self:setTitle(SECTION.PVE[self:getSection()])

	end  


	dump(self:get_crunt_def_solder(),"更新后士兵信息。。。。。。。。。。。。")

	-- print = p1




end



function coreAnalyze:runData()
	 --1 士兵数量
	 --2 战斗力

 -- 	local  p1  = print 
	-- print=function()end 

	if self:get_crunt_round() > self:get_all_round()  then 
		return 
	end

	self:set_crunt_round(self:get_crunt_round()+1)

	local crut_pk_info = self:get_pkInfo()[self:get_crunt_round()]

	if not crut_pk_info  then return end

	self:set_cur_pk_info(crut_pk_info)

	self:updateComat(self:get_cur_pk_info().tagAtkSoldier[1])

	self:updateComat(self:get_cur_pk_info().tagDefSoldier[1])

	self:updateSoldierNum(self:get_cur_pk_info().tagDefSoldier[1])
	self:updateSoldierNum(self:get_cur_pk_info().tagAtkSoldier[1])

	-- print = p1 
end  


-----------------------------特效播放前的一些数据---------------------



function coreAnalyze:setChief()

	local setSoliderChief = function(hero) 
		if hero.lHeroAttr then 

			local pro = global.heroData:getHeroPropertyById(hero.lHeroID )
			local commanderType = pro.commanderType
			local secType = pro.secType

			for _ ,v in pairs(hero.tagSoldier or {}) do 

				local  soldier =  global.luaCfg:get_soldier_property_by(v.soldierId)

				if soldier.type == commanderType then

					if secType== 0 then 
						v.chief = true 
					elseif soldier.skill == secType   then 
						v.chief = true 
					end 
				end 

			end 

		end
	end


	for _ ,v in pairs(self:get_df_hero()) do 
		setSoliderChief(v)
	end


	for _ ,v in pairs(self:get_attack_hero())do 
		setSoliderChief(v)
	end

end 



function coreAnalyze:setOriginalAttackHero(hero)
	self.orginalAttackHero = clone(hero)
end 

function coreAnalyze:setOriginalDefckHero(hero)
	self.orginalAttackHero = clone(hero)
end 


function coreAnalyze:getOriginalAttackHero()

	return self.orginalAttackHero 
end 

function coreAnalyze:gtOriginalDefckHero()

	return self.orginalAttackHero 
end


function coreAnalyze:CheckisFanGong()
	
	return self.isFanGong	
end 


function coreAnalyze:getAllSoldierID()

	local id = {}

	for _ ,v in pairs(self:get_df_hero()) do 
		for _ , vv in pairs(v.tagSoldier or {}) do 
			if not global.EasyDev:CheckContrains(id , vv.soldierId) then  
				table.insert(id , vv.soldierId)
			end 
		end 
	end

	for _ ,v in pairs(self:get_attack_hero())do 
		for _ , vv in pairs(v.tagSoldier or {} ) do 
			if not global.EasyDev:CheckContrains(id , vv.soldierId) then 
				table.insert(id , vv.soldierId)
			end 
		end 
	end

	for index ,v in pairs(id) do 
		if v == 71 or v == 72 then 
			id[index] =  -99
		end 
	end 

	return id 
end



function coreAnalyze:setProgress()


	if  self:get_all_round() <= 0 then

		-- self.progress ={[1]={progress =1 , ps =1}} 

		return 
	end 

	local test = {} 

	for i =1 , self:getAllStage()do 

		test[i]  =  - 1 
	end 

	local old = self:get_pkInfo()[1].lSection

	local test2 = function (v)

		for i =1 , self:getAllStage()  do 

			if test[i] == -1 then 

				local P = 0 

				if v.lRound ==1 then 
					p =  0 
				else 
					p = v.lRound
				end 

				test[tostring(v.lSection)] = {ps= p}

				test[i] = -2 

				break
			end 
		end
	end  

	test2( self:get_pkInfo()[1])

	for _ ,v in  pairs(self:get_pkInfo()) do

		if v.lSection ~= old then 
			test2( v )
			old = v.lSection
		end 
	end


	for i =1 , self:getAllStage()  do 
		test[i]  =   nil 
	end 


	for key , v   in pairs(test) do 

		local count = 0 

		for _ ,v in pairs(self:get_pkInfo()) do 

			if v.lSection  == tonumber(key) then 
				count  =count + 1 
			end 
		end

		-- 第一个进度条要 加 1 个回合 ， 最后一个要建一个回合
		if  self:getAllStage() > 1 then 
			
			if  tonumber(key) == self:get_pkInfo()[1].lSection then 

				v.progress = (count+1) / self:get_all_round()
			elseif tonumber(key) == self:get_pkInfo()[self:get_all_round()].lSection then 

				v.progress = (count- 1 ) / self:get_all_round()
			else

				v.progress = count  / self:get_all_round()
				
			end  

		else 

				v.progress = count  / self:get_all_round()
		end 

	end 

	self.progress = test

	-- dump(self:get_all_round() , "self get all round ")
	-- dump(self.progress , "testaetsg ")	
end


function coreAnalyze:getProgress()

	return self.progress
end 


function coreAnalyze:setAllStage(stage)
	-- self.stage = stage
	local count =0 
	local lSection = -1  

	local temp = {} 

	for _ ,v in pairs(self:get_pkInfo()) do 
		if v.lSection ~= lSection then 

			if not global.EasyDev:CheckContrains(temp , v.lSection) then 
				table.insert(temp  ,  v.lSection)
			end 
			count = count + 1 
			lSection=  v.lSection
		end 
	end
	self:setAllSection(temp)
	self.stage  = count



end 

function coreAnalyze:getAllSection()

	return self.allSection
end 

function coreAnalyze:setAllSection(allSection)

	self.allSection = allSection
end 

function coreAnalyze:getAllStage()

	return self.stage
end

function coreAnalyze:set_old_crunt_attack_solder()

	self.old_crunt_attack_solder  =clone(self:get_crunt_attack_solder())
end 


function coreAnalyze:set_old_crunt_def_solder()

  	self.old_crunt_def_solder = clone(self:get_crunt_def_solder())
end 


function coreAnalyze:get_old_crunt_attack_solder()

	return self.old_crunt_attack_solder 
end 


function coreAnalyze:get_old_crunt_def_solder()

	return self.old_crunt_def_solder 
end 

function coreAnalyze:set_old_crunt_pk_left_solder()

	self.old_crunt_pk_left_solder = clone(self:get_crunt_pk_left_solder())
end 

function coreAnalyze:get_old_crunt_pk_left_solder()

	return self.old_crunt_pk_left_solder 
end 


function coreAnalyze:set_old_crunt_pk_right_solder()

	self.old_crunt_pk_right_solder = clone(self:get_crunt_pk_right_solder())
end 

function coreAnalyze:get_old_crunt_pk_right_solder()

	return self.old_crunt_pk_right_solder 
end 


function coreAnalyze:set_old_cur_atk_capacity()
	self.old_cur_atk_capacity = clone(self:get_cur_atk_capacity())
end 

function coreAnalyze:get_old_cur_atk_capacity()

	return self.old_cur_atk_capacity 
end 

function coreAnalyze:set_old_cur_df_capacity()
	self.old_cur_df_capacity = clone(self:get_cur_df_capacity())
end 

function coreAnalyze:get_old_cur_df_capacity()

	return self.old_cur_df_capacity 
end 


---------------------------------------------------------

function  coreAnalyze:getTitleStatus()

	local  status = self.lastTitleStatus ~= self:getSection()

	return status 
end


function coreAnalyze:setLastTitleStatus()
	self.lastTitleStatus =  self:getSection()
end 


function coreAnalyze:setSection(Section)

	self.lSection = Section 
end


function coreAnalyze:getSection()

	return 	self.lSection 
end 

function coreAnalyze:updateSoldierNum(Solider)  -- Solider -- pk 信息

	local hero  = self:findHeroByTroopId(Solider.ltroopid)

	for _ ,v in pairs(hero.tagSoldier) do 

		if v.lIndex == Solider.lIndex  then 

			v.lcount = v.lcount - Solider.lcount
		end 
	end 

end


function coreAnalyze:getTopSoldierCount()
	
	return #(self:get_crunt_atack_hero().tagSoldier)
end 

function coreAnalyze:getBottomSoldierCount()

	return #(self:get_crunt_df_hero().tagSoldier)
end 


function coreAnalyze:updateComat(Soldier) --更新  部队 战斗力

	-- 1： 野怪  箭塔  城墙  陷阱  士兵

	dump(Soldier , "Soldier 模拟战斗")

	local hero  = self:findHeroByTroopId(Soldier.ltroopid)

	dump(hero , "hero 模拟战斗")

	local findSoldier = function(hero , Soldier) 

		for _ ,v in pairs(hero.tagSoldier or {} ) do 

			if v.lIndex == Soldier.lIndex then 

				return v 
			end 		
		end 
	end 

	local pk_Soldier = clone(Soldier)

	local Soldier = findSoldier(hero , Soldier)

	local pro =nil

	local war_type = self:get_war_type()

	local soldierType = Soldier.soldierType
	-- local lFightType = {city =1 , yedi  = 2 , yeguai = 3 , yingdi =5 , xiaocunzhuang = 6 , qiji = 7 }
	-- local SOLDIERTYPE  = {soldier = 1 , jianta = 2 , xianjing = 3 , chengqiang =4 } 

	print(war_type,"war_type ////////")

	if war_type  == FIGHTTYPE.CITY then 

		if soldierType == SOLDIERTYPE.SOLDIER then 

			pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)

		elseif soldierType == SOLDIERTYPE.JIANTA then 

			pro =  global.luaCfg:get_def_device_by(Soldier.soldierId)

		elseif  soldierType == SOLDIERTYPE.XIANJING then 

			pro =  global.luaCfg:get_def_device_by(Soldier.soldierId)

		elseif  soldierType == SOLDIERTYPE.CHENGQIANG then 

			pro =  {combat = 0 }
		end 

		if self:isImitate()  and ( not pro) then --战斗模拟 特殊处理

			pro =  global.luaCfg:get_wild_property_by(Soldier.soldierId)
		end 

	elseif war_type  == FIGHTTYPE.YEDI then 

		if self:checkHeroType(hero) == fightDef.attack then 
			pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)
		else 

			if  hero.lTroopType  == FIGHTTYPE.HERO then 
				
				pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)

			else 
				pro =  global.luaCfg:get_wild_property_by(Soldier.soldierId)
			end 
		end
	 
	elseif war_type  == FIGHTTYPE.YEGUAI   or war_type ==  FIGHTTYPE.WORLDBOSS then 

		if self:checkHeroType(hero) == fightDef.attack then 

			pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)

		else 

			pro =  global.luaCfg:get_wild_property_by(Soldier.soldierId)
		end 

	elseif war_type  == FIGHTTYPE.YINGDI then 

		if self:checkHeroType(hero) == fightDef.attack then 

			pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)
		else 
			if  hero.lTroopType  == FIGHTTYPE.HERO then 

				pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)
			else  

				if soldierType == SOLDIERTYPE.SOLDIER then 

					pro =  global.luaCfg:get_wild_property_by(Soldier.soldierId)

				elseif  soldierType == SOLDIERTYPE.JIANTA then 

					pro =  global.luaCfg:get_def_device_by(Soldier.soldierId)

				elseif  soldierType == SOLDIERTYPE.XIANJING then 

					pro =  global.luaCfg:get_def_device_by(Soldier.soldierId)

				elseif  soldierType == SOLDIERTYPE.CHENGQIANG then 

					pro =  {combat = 0 }
				end 
			end 
		end 

	elseif war_type  == FIGHTTYPE.XIAOCUNZHUANG then 

		pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)

	elseif war_type  == FIGHTTYPE.QIJI then 

		if self:checkHeroType(hero) == fightDef.attack then 

			pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)

		else 
			if  hero.lTroopType  == FIGHTTYPE.HERO then 
				pro =  global.luaCfg:get_soldier_property_by(Soldier.soldierId)
			else 
				if soldierType == SOLDIERTYPE.SOLDIER then 
					
					pro =  global.luaCfg:get_wild_property_by(Soldier.soldierId)
				elseif  soldierType == SOLDIERTYPE.JIANTA then 

					pro =  global.luaCfg:get_def_device_by(Soldier.soldierId)

				elseif  soldierType == SOLDIERTYPE.XIANJING then 

					pro =  global.luaCfg:get_def_device_by(Soldier.soldierId)

				elseif  soldierType == SOLDIERTYPE.CHENGQIANG then 

					pro =  {combat = 0 }
				end
			end 
		end 
	end   

	dump(Soldier , "查询的士兵")
	dump(hero , "查询到的英雄")
	dump(pro ,"查询到的属性。。。。")

	if not pro then 

		global.tipsMgr:showWarning("Soldier property  error")

		return 
	end 


	pro.changeTimes = pro.changeTimes or 0 

	if  self:checkHeroType(hero) == fightDef.attack  then 

		local consume  =  pro.combat * pk_Soldier.lcount * pro.changeTimes

		hero.lTroopPower = hero.lTroopPower - consume

		-- print("更新前---left-----",self:get_cur_atk_capacity())

		self:set_cur_atk_capacity(hero.lTroopPower)

		-- print("更新后---left-----",self:get_cur_atk_capacity())

		self:setCruntAttackComat(self:getCruntAttackComat() -consume) 

	elseif  self:checkHeroType(hero) == fightDef.def then 

	
		local consume  =  pro.combat * pk_Soldier.lcount * pro.changeTimes

		hero.lTroopPower = hero.lTroopPower - consume

		-- print("更新前---right-----",self:get_cur_df_capacity())

		self:set_cur_df_capacity(hero.lTroopPower)

		-- print("更新前---right-----",self:get_cur_df_capacity())

		self:setCruntDefComat(self:getCruntDefComat() -consume) 
	else 

		global.tipsMgr:showWarning("error code  589")
	end
end 



function  coreAnalyze:checkHeroType(hero)  -- 检测英雄  攻打方 还是  防御方


	for index ,v in pairs(self:get_attack_hero()) do 

		 if hero.lTroopID == v.lTroopID then 

			return fightDef.attack		 	
		 end 
	end 


	for index ,v in pairs(self:get_df_hero())do 

		if hero.lTroopID== v.lTroopID then 

			return fightDef.def			 	
		 end 
	end 

end 

function  coreAnalyze:checkSolidType(solider)  -- 检测 士兵 是  攻打方 还是  防御方


	-- dump(solider,"检查士兵。////////")
	-- dump(self:get_attack_hero()," 攻击方英雄")

	for index ,v in pairs(self:get_attack_hero()) do 

		 if solider.ltroopid == v.lTroopID then 

			return fightDef.attack		 	
		 end 
	end 

	-- dump(self:get_df_hero()," 防守方英雄")

	for index ,v in pairs(self:get_df_hero())do 

		if solider.ltroopid== v.lTroopID then 

			return fightDef.def			 	
		 end 
	end 

end 

function coreAnalyze:set_cur_pk_info(cur_pk_info)
	self.cur_pk_info =cur_pk_info
end


function coreAnalyze:get_cur_pk_info()
	return self.cur_pk_info
end


function coreAnalyze:getFightProgress()
	return (self:get_crunt_round()) / self:get_all_round() * 100	
end 

function coreAnalyze:getCruntSelectSolider(lIndex ,fighttype) -- 根据士兵ID  从正在 进攻方 或者防守方 的英雄中 查找士兵 


	if fighttype  ==  fightDef.attack then 

		local crunt_atack_hero = self:get_crunt_atack_hero()
		
		if not crunt_atack_hero  then return end 

		for index ,v in pairs (crunt_atack_hero.tagSoldier) do 

			 if v.lIndex== lIndex then 

				return v			 	
			 end 
		end 

	elseif fighttype  ==  fightDef.def  then 

		local crunt_def_hero = self:get_crunt_df_hero() 
		
		if crunt_def_hero and crunt_def_hero.tagSoldier then
			for index ,v in pairs(crunt_def_hero.tagSoldier)do 

				if v.lIndex ==lIndex then 

					return v			 	
				 end 
			end 
		end
	end

end 

function coreAnalyze:getCruntSelectSoliderStation(lIndex ,fighttype)

	if fighttype  ==  fightDef.attack then 

		local crunt_atack_hero = self:get_crunt_atack_hero()

			if not crunt_atack_hero  then return end 

		for index ,v in pairs (crunt_atack_hero.tagSoldier or {} ) do 

			 if v.lIndex ==lIndex then 

				return index
			 end 
		end 

	elseif fighttype  ==  fightDef.def  then 

		local crunt_def_hero = self:get_crunt_df_hero()

		if not crunt_def_hero  then return end 

		for index ,v in pairs(crunt_def_hero.tagSoldier or {} )do 

			if v.lIndex ==lIndex then 

				return index
			 end 
		end 
	end
end 
 
function coreAnalyze:findHeroStation(hero)
	if not hero then return end 

	if fighttype ==2 then 
		print("防御方--")
	else
		print("攻击方---")
	end 

	-- if fighttype  == fightDef.attack then 
		for index ,v in ipairs(self:get_attack_hero()) do 
			 if hero.lTroopID == v.lTroopID then 

				return index			 	
			 end 
		end 

	-- elseif fighttype  == fightDef.def then 

		for index ,v in pairs(self:get_df_hero())do 

			if hero.lTroopID == v.lTroopID then 
				return index			 	
			 end 
		end 
	-- end
end 


function coreAnalyze:findHeroByTroopId(troopid )

	print(troopid,"troopid")



	-- if fighttype  == fightDef.attack  then 
		for _ ,v in pairs(self:get_attack_hero()) do 
			 if v.lTroopID == troopid then 
			 	return v
			 end 
		end 

	-- elseif fighttype  == fightDef.def  then 
		for _ ,v in pairs(self:get_df_hero())do 
			 if v.lTroopID == troopid then 
			 	return v
			 end 
		end 
	-- end
end 

function coreAnalyze:setRightPKSoliderHurt(crunt_pk_right_solder_hurt)

	self.crunt_pk_right_solder_hurt = crunt_pk_right_solder_hurt
end 

function coreAnalyze:getRightPKSoliderHurt()

	return self.crunt_pk_right_solder_hurt
end 


function coreAnalyze:havaNextRound()

	print("当前回合",self:get_crunt_round())
	print("get_all_round",self:get_all_round())

	return  self:get_crunt_round() < self:get_all_round()
end 

function coreAnalyze:getLeftPKSoliderHurt()
	return  self.crunt_pk_left_solder_hurt
end

function coreAnalyze:setLeftPKSoliderHurt(crunt_pk_left_solder_hurt)
	  self.crunt_pk_left_solder_hurt =crunt_pk_left_solder_hurt
end 


function coreAnalyze:getBottomHeroStation()

	return  self.cruntBottomHeroStation

end 

function coreAnalyze:getTopHeroStation()

	return self.cruntTopHeroStationn
end 


function coreAnalyze:setBottomHeroStation(cruntBottomHeroStation)

 	self.cruntBottomHeroStation = cruntBottomHeroStation
end 

function coreAnalyze:setTopHeroStation(cruntTopHeroStationn)
 	
 	self.cruntTopHeroStationn = cruntTopHeroStationn
end 


function coreAnalyze:getOldBottomHeroStation()

	return  self.oldBottomHeroStation

end 

function coreAnalyze:getOldTopHeroStation()

	return self.oldTopHeroStationn
end 


function coreAnalyze:setOldBottomHeroStation(oldBottomHeroStation)

 	self.oldBottomHeroStation = oldBottomHeroStation
end 

function coreAnalyze:setOldTopHeroStation(oldTopHeroStationn)
 	
 	self.oldTopHeroStationn = oldTopHeroStationn
end 


function coreAnalyze:isNeedChooseTopHero()  --上个回合 与这个回合是否是同一个英雄

	return  not (self:getOldTopHeroStation() == self:getTopHeroStation())
end 

function coreAnalyze:isNeedChooseBottomHero()--上个回合 与这个回合是否是同一个英雄
	
	return  not (self:getOldBottomHeroStation() == self:getBottomHeroStation())
end


function coreAnalyze:isNeedChooseTopSolider()  --上个回合 与这个回合是否是同一个英雄

	if not self:isNeedChooseTopHero() then
		return  not (self:getOldBottomSoliderStation() == self:getBottomSoliderStation()) 
	end	

	return true 
end 

function coreAnalyze:isNeedChooseBottomSolider()--上个回合 与这个回合是否是同一个英雄
	
	if not self:isNeedChooseBottomHero() then
		return  not (self:getOldTopSoliderStation() == self:getTopSoliderStation()) 
	end

	return true 
end 

function coreAnalyze:getBottomSoliderStation()

 	return self.cruntBottomSoliderStation 
end 

function coreAnalyze:setBottomSoliderStation(cruntBottomSoliderStation)
 	self.cruntBottomSoliderStation = cruntBottomSoliderStation
end 

function coreAnalyze:getTopSoliderStation()

 	return self.cruntTopSoliderStation
end 

function coreAnalyze:setTopSoliderStation(cruntTopSoliderStation) 
	self.cruntTopSoliderStation = cruntTopSoliderStation
end


function coreAnalyze:getOldBottomSoliderStation()

 	return self.oldBottomSoliderStation 
end 

function coreAnalyze:setOldBottomSoliderStation(oldBottomSoliderStation)
 	self.oldBottomSoliderStation = oldBottomSoliderStation
end 

function coreAnalyze:getOldTopSoliderStation()

 	return self.oldTopSoliderStation
end 

function coreAnalyze:setOldTopSoliderStation(oldTopSoliderStation) 
	self.oldTopSoliderStation = oldTopSoliderStation
end 


function coreAnalyze:getLastAttackComat()

	return  self.lastlAtkInitPower
end

function coreAnalyze:getLastDefComat()
	
	return self.lastlDefInitPower
end 

function coreAnalyze:setLastAttackComat(lastlAtkInitPower)

	self.lastlAtkInitPower =lastlAtkInitPower
end

function coreAnalyze:setLastDefComat(lastlDefInitPower)

	self.lastlDefInitPower =lastlDefInitPower
end 


function coreAnalyze:getAttackerStation(attacker_Station) --获取 那边是攻击者 

	return self.attacker_Station 	
end 


function coreAnalyze:setAttackerStation(attacker_Station) --获取 那边是攻击者 
	self.attacker_Station = attacker_Station
end 


function coreAnalyze:strSplit(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


function coreAnalyze:set_lPveID(lPveID)
	self.lPveID  = lPveID
end


function coreAnalyze:get_lPveID()
	return self.lPveID
end 

function coreAnalyze:set_pkInfo(pkinfo)

	self.pkinfo = pkinfo 
end 


function coreAnalyze:get_pkInfo()

	return self.pkinfo
end 

 
function coreAnalyze:set_cur_atk_capacity(cur_atk_capacity)

	self.cur_atk_capacity = cur_atk_capacity
end 


function coreAnalyze:get_cur_atk_capacity()

	return self.cur_atk_capacity 
end 

 
function coreAnalyze:set_cur_df_capacity(cur_df_capacity)

	self.cur_df_capacity = cur_df_capacity
end 


function coreAnalyze:get_cur_df_capacity()

	return self.cur_df_capacity
end 

-- function coreAnalyze:set_lSection(lSection)

-- 	self.lSection = lSection
-- end 

-- function coreAnalyze:get_lSection()

-- 	return self.lSection 
-- end 


function coreAnalyze:set_war_type(war_type)
	 self.war_type = war_type
end 

function coreAnalyze:get_war_type()

	return  self.war_type 
end 

function coreAnalyze:set_all_round(all_round)
 	self.all_round = all_round
end 


function coreAnalyze:get_all_round()
	return self.all_round
end 

function coreAnalyze:set_war_result(war_result)
	
	 self.war_result  = war_result
end 

function coreAnalyze:get_war_result()

	return self.war_result 
end 

function coreAnalyze:set_crunt_round(crunt_round)
	self.crunt_round =  crunt_round
end 

function coreAnalyze:get_crunt_round()
	return self.crunt_round
end 


function coreAnalyze:set_crunt_attack_solder(crunt_attack_solder)
	self.crunt_attack_solder = crunt_attack_solder
end 

function coreAnalyze:get_crunt_attack_solder()


	return self.crunt_attack_solder
end

function coreAnalyze:set_crunt_def_solder(crunt_def_solder)
	self.crunt_def_solder = crunt_def_solder
end 

function coreAnalyze:get_crunt_def_solder()
	return self.crunt_def_solder
end 


function coreAnalyze:setTitle(title)

	self.title = title 
end 

function coreAnalyze:getTitle() 

	return self.title 
end

function coreAnalyze:set_crunt_pk_soldier(crunt_pk_soldier) 

	self.crunt_pk_soldier =crunt_pk_soldier
end

function coreAnalyze:get_crunt_pk_soldier() 

	return self.crunt_pk_soldier
end

function coreAnalyze:set_crunt_pk_right_solder(crunt_pk_right_solder) 

	self.crunt_pk_right_solder =crunt_pk_right_solder
end

function coreAnalyze:get_crunt_pk_right_solder() 

	return self.crunt_pk_right_solder 
end

function coreAnalyze:set_crunt_pk_left_solder(crunt_pk_left_solder) 

	self.crunt_pk_left_solder  = crunt_pk_left_solder
end

function coreAnalyze:get_crunt_pk_left_solder() 
	return self.crunt_pk_left_solder
end

function coreAnalyze:set_attack_hero(attack_hero) 
	  self.attack_hero = attack_hero
end

function coreAnalyze:get_attack_hero() 
	return self.attack_hero
end


function coreAnalyze:set_df_hero(df_hero) 

	self.df_hero = df_hero
end

function coreAnalyze:get_df_hero() 

	return self.df_hero
end

function coreAnalyze:set_result(result)

	self.result = result
end

function coreAnalyze:get_result()

	return self.result
end


function coreAnalyze:set_crunt_atack_hero(crunt_atack_hero)

	self.crunt_atack_hero =crunt_atack_hero
end


function coreAnalyze:get_crunt_atack_hero()
	return self.crunt_atack_hero 
end


function coreAnalyze:set_crunt_df_hero(crunt_df_hero)

	self.crunt_df_hero = crunt_df_hero
end

function coreAnalyze:get_crunt_df_hero()

	return self.crunt_df_hero or {} 
end


function coreAnalyze:set_last_attack_Hero()

	self.last_attack_hero =clone(self:get_attack_hero())
end 


function coreAnalyze:set_last_def_hero()

  	self.last_def_hero = clone(self:get_df_hero())
end 


function coreAnalyze:get_last_attack_Hero()

	return self.last_attack_hero 
end 


function coreAnalyze:get_last_def_hero()

	return self.last_def_hero 
end


function coreAnalyze:getOriginalAttackComat()

	return  self.lAtkInitPower
end

function coreAnalyze:getOriginalDefComat()

	return self.lDefInitPower
end 

function coreAnalyze:getCruntAttackComat()

	return  self.war.lAtkInitPower
end

function coreAnalyze:getCruntDefComat()
	
	return self.war.lDefInitPower
end 

function coreAnalyze:setCruntAttackComat(lAtkInitPower)

	self.war.lAtkInitPower =lAtkInitPower
end

function coreAnalyze:setCruntDefComat(lDefInitPower)

	self.war.lDefInitPower =lDefInitPower
end 




function coreAnalyze:isShowRestrain()
	
	local flg = false 

	local direction = 1  --  1 ， 左边  2 ， 右边 

	function getSoldier(solider_id)
		local solider = global.luaCfg:get_soldier_property_by(solider_id)
		if not solider then 
			solider = global.luaCfg:get_wild_property_by(solider_id)
		end 
		return solider
	end 

	if not self:CheckisFanGong() then 

		local attack_solider_id = self:get_crunt_pk_right_solder().soldierId
		local def_solider_id  = self:get_crunt_pk_left_solder().soldierId

		if getSoldier(attack_solider_id)   then 
			if getSoldier(def_solider_id) and  getSoldier(def_solider_id).skill ==  getSoldier(attack_solider_id).skill then 
				flg = true 

				if  getSoldier(def_solider_id).skill == 1 then 

					direction =  2 

				else 

					direction =  1 
				end  

			end 
		end 
	else

		local attack_solider_id = self:get_crunt_pk_left_solder().soldierId
		local def_solider_id  = self:get_crunt_pk_right_solder().soldierId

		if getSoldier(attack_solider_id)  then 
			if getSoldier(attack_solider_id) and getSoldier(def_solider_id) and getSoldier(def_solider_id).skill ==  getSoldier(attack_solider_id).skill then 
				flg = true 

				if  getSoldier(def_solider_id).skill == 1 then 

					direction =  1 

				else 

					direction =  2 
				end  

			end 
		end 
	end 

	return flg , direction
end 



return coreAnalyze

--endregion
