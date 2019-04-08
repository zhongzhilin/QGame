--
-- Author: Your Name
-- Date: 2017-06-22 20:52:47
--
-- 阶段数：section
-- 回合数：round
-- 战斗类型：	fight _type (1.城池战斗 2.打野地 3.打野怪 5.怪物营地 6.小村庄 7.奇迹战斗)
-- 初始战力：	攻击方power|防御方power
-- 攻击方：	部队ID+英雄ID+英雄等级+领主名字+指令+士兵ID-士兵数量+士兵ID-士兵数量...	|
-- 			部队ID+英雄ID+英雄等级+领主名字+指令+士兵ID-士兵数量+士兵ID-士兵数量...
-- 防御方：	队伍类型（1.英雄部队 2.城堡  3.PVE）+部队ID+英雄ID+英雄等级+领主名字+指令+士兵ID-士兵数量+士兵ID-士兵数量...	|
-- 			队伍类型（1.英雄部队 2.城堡  3.PVE）+领主名字+城墙-耐久度+箭塔ID-箭塔数量+陷阱ID-陷阱数量		|
-- 			队伍类型（1.英雄部队 2.城堡  3.PVE）+野地ID或者怪物ID或者营地ID或者奇迹ID+士兵ID-士兵数量+士兵ID-士兵数量... 		|
-- 			队伍类型（1.英雄部队 2.城堡  3.PVE）+营地ID或者奇迹ID+箭塔ID-箭塔数量+陷阱ID-陷阱数量

-- 战斗信息：
-- 	队伍类型（1.英雄部队 2.城堡  3.PVE）|阶段数+回合数|部队ID+士兵ID+损失兵数|部队ID+士兵ID+损失兵数   - 
-- 	队伍类型（1.英雄部队 2.城堡  3.PVE）|阶段数+回合数|部队ID+士兵ID+损失兵数|城防ID（70.城墙 71.箭塔 72.陷阱）+耐久度或者损失城防数
	
-- 战斗结果：result   1,攻击方胜利        2,防御方胜利

-- 	required int32		lSection	= 1;//阶段数
-- 	required int32		lRound	= 2;//总回合数
-- 	required int32		lFightType	= 3;//战斗类型
-- 	required string		lInitPower	= 4;//初始战力
-- 	required string		lAtkInfo	= 5;//攻击方初始信息
-- 	required string		lDefInfo	= 6;//防御方初始信息
-- 	required string		lPkInfo	= 7;//战斗信息
-- 	required int32		lResult	= 8;//战斗结果  1.攻击方胜利  2.防御方胜利		

--  t] - "战争数据/////////////////" = {
-- [LUA-print] -     "lAtkInfo"   = "69608+0+0+QAQ002+6+31-11750|69607+0+0+QAQ002+2+1011-1563"
-- [LUA-print] -     "lDefInfo"   = "1+69609+0+0+QAQ001+10+31-58|2+QAQ001+70-4875"
-- [LUA-print] -     "lFightType" = 1
-- [LUA-print] -     "lInitPower" = "36813|174"
-- [LUA-print] -     "lPkInfo"    = "1|2+1|69607+1011+46|69609+31+57-1|2+2|69608+31+1|69609+31+1"
-- [LUA-print] -     "lResult"    = 1
-- [LUA-print] -     "lRound"     = 2
-- [LUA-print] -     "lSection"   = 2
-- [LUA-print] - }

local decode = class("decode")
local hero  =require("game.UI.replay.mode.hero")
local soldier  =require("game.UI.replay.mode.soldier")
local troop  =require("game.UI.replay.mode.troop")
local war  =require("game.UI.replay.mode.war")
local citywall  =require("game.UI.replay.mode.citywall")
local castle  =require("game.UI.replay.mode.castle")
local archertower  =require("game.UI.replay.mode.archertower")
local pitfall  =require("game.UI.replay.mode.pitfall")
local campsite  =require("game.UI.replay.mode.campsite")
local hamlet  =require("game.UI.replay.mode.hamlet")
local miracle  =require("game.UI.replay.mode.miracle")
local monster  =require("game.UI.replay.mode.monster")
local wasteland  =require("game.UI.replay.mode.wasteland")

-- pve 
function decode:start(msg)

 	self.war_type = msg.lFightType

	local war = war.new()

	local attack = self:baseActck(msg.lAtkInfo)
	war:setAttacker(attack)

	dump(attack ,"/////////攻击方数据解析/////////")

	local def_arr = self:def(msg.lDefInfo)

	dump(def_arr ,"/////////防守方数据解析/////////")

	return war 
end 

-- nt] - "战争数据/////////////////" = {
-- [LUA-print] -     "lAtkInfo"   = "69608+0+0+QAQ002+6+31-11750|69607+0+0+QAQ002+2+1011-1563"
-- [LUA-print] -     "lDefInfo"   = "1+69609+0+0+QAQ001+10+31-58|2+QAQ001+70-4875"
-- [LUA-print] -     "lFightType" = 1
-- [LUA-print] -     "lInitPower" = "36813|174"
-- [LUA-print] -     "lPkInfo"    = "1|2+1|69607+1011+46|69609+31+57-1|2+2|69608+31+1|69609+31+1"
-- [LUA-print] -     "lResult"    = 1
-- [LUA-print] -     "lRound"     = 2
-- [LUA-print] -     "lSection"   = 2
-- [LUA-print] - }

function decode:link()

end 

function decode:def1()

	

end 
-- -------------------pve 
function decode:def(str)
	-- fight _type (1.城池战斗 2.打野地 3.打野怪 5.怪物营地 6.小村庄 7.奇迹战斗)
-- lDefInfo"   = "3+4010123+21081-118+21091-112|3+4010123+21082-124+21092-107"
-- 防御方：	队伍类型（1.英雄部队）+部队ID+英雄ID+英雄等级+领主名字+指令+士兵ID-士兵数量+士兵ID-士兵数量...	|
-- 			队伍类型（ 2.城堡 ）+领主名字+城墙-耐久度+箭塔ID-箭塔数量+陷阱ID-陷阱数量		|

-- 			队伍类型（ 3.PVE）+野地ID或者怪物ID或者营地ID或者奇迹ID+士兵ID-士兵数量+士兵ID-士兵数量... 		|
					--.营地奇迹城防）+营地ID或者奇迹ID+箭塔ID-箭塔数量+陷阱ID-陷阱数量
-- 防御方 分 pve   pvp 

	local  def_arr = {}

	if self.war_type  == 5 then 
	
		self:defcampsite(str, def_arr)

	elseif self.war_type  == 7 then 

		self:dfemiracle(str, def_arr)
	else 

		print("90/////////")
		if string.find(str,"|") then  
			for _ ,v in pairs(self:strSplit(str , "|"))  do 
			print("93/////////")
				 self:baseDef(v , def_arr)
			end 
		else -- 只有一个防御部队
			self:baseDef(str, def_arr)
		end

	end 

	return def_arr 
end 


function decode:baseDef(str , def_arr) 

	local info = self:strSplit(str , "+")

	if info[1] == 1 then 

		self:defHero(info ,def_arr)

	elseif  info[1] == 2 then 

		self:defcastle(info ,def_arr)

	elseif info[1] == 3 then 	

		-- fight _type (1.城池战斗 2.打野地 3.打野怪 5.怪物营地 6.小村庄 7.奇迹战斗)

		if  self.war_type == 2  then  -- 防御野地
			
			self:defWasteland(info, def_arr)

		elseif self.war_type == 3 then   -- 防御野怪

			self:defMonster(info, def_arr)

		end 
		-- elseif self.war_type ==  4  then  --
		-- elseif self.war_type ==  5 then  -- 防御营地
		-- 	-
		-- elseif self.war_type ==  6 then -- 防御小村庄 
		-- 	-- self:defhamlet(info, defhero_arr)
		-- elseif self.war_type ==  7 then  -- 防御奇迹
		-- 	-- 
		-- end 
	end
end 

-- 队伍类型（ 3.PVE）+野地ID或者怪物ID或者营地ID或者奇迹ID+士兵ID-士兵数量+士兵ID-士兵数量... 		|
-- 		--.营地奇迹城防）+营地ID或者奇迹ID+箭塔ID-箭塔数量+陷阱ID-陷阱数量



function decode:defcampsite(str, defhero_arr)

	local cp = campsite.new()
	local troop = troop.new()
	local soldier_arr = {}

	local info = self:strSplit(str , "|")

	cp:setImageId(info[1][2])

	for i=3 , #info[1]  do  --解析 士兵
		local  sd =  soldier.new()
		local  solder_data = self:strSplit(inf[i] , "-")
		sd:setImageId(solder_data[1])
		sd:setCount(solder_data[2])
		table.insert(soldier_arr , sd)
	end 
	
	local at = archertower.new()
	local pf= pitfall.new()

	local at_data = self:strSplit(inf[2][3] , "-")

	at:setImageId(at_data[1])
	at:setCount(at_data[2])


	local pf_data = self:strSplit(inf[2][4] , "-")

	pf:setImageId(pf_data[1])
	pf:setCount(pf_data[2])


	table.insert(soldier_arr , at)
	table.insert(soldier_arr , pf)

	troop:setsoldier(soldier_arr)

	cp:setTroop(troop)


	table.insert(defhero_arr,cp)
end 

function decode:defhamlet(info, defhero_arr)
	local hm = hamlet.new()
	local troop = troop.new()
	local soldier_arr = {}



	troop:setsoldier(soldier_arr)
	hm:setTroop(troop)
	table.insert(defhero_arr,hm)
end 

function decode:dfemiracle(info, defhero_arr)

	local mc = miracle.new()

	local troop = troop.new()

	local soldier_arr = {}

	local info = self:strSplit(str , "|")

	mc:setImageId(info[1][2])

	for i=3 , #info[1]  do  --解析 士兵
		local  sd =  soldier.new()
		local  solder_data = self:strSplit(inf[i] , "-")
		sd:setImageId(solder_data[1])
		sd:setCount(solder_data[2])
		table.insert(soldier_arr , sd)
	end 
	
	local at = archertower.new()
	local pf= pitfall.new()

	local at_data = self:strSplit(inf[2][3] , "-")

	at:setImageId(at_data[1])
	at:setCount(at_data[2])


	local pf_data = self:strSplit(inf[2][4] , "-")

	pf:setImageId(pf_data[1])
	pf:setCount(pf_data[2])


	table.insert(soldier_arr , at)
	table.insert(soldier_arr , pf)

	troop:setsoldier(soldier_arr)

	mc:setTroop(troop)


	table.insert(defhero_arr,mc)
end 


function decode:defMonster(info, defhero_arr)

	local mt = monster.new()
	local troop = troop.new()

	--类型+野怪ID+士兵ID-士兵数量+士兵ID-士兵数量... 	|
	mt:setImageId(info[2])

	local soldier_arr = {}

	for i =3 , #info  do 
		local  sd  = soldier.new()
		local info =  self:strSplit(info[i] , "-")
		sd:setImageId(info[1])
		sd:setImageId(info[2])

		table.insert(soldier_arr , sd )
	end 

	troop:setsoldier(soldier_arr)

	mt:setTroop(troop)

	table.insert(defhero_arr,mt)
end 


function decode:defWasteland(info, defhero_arr)

	--类型+野地ID+士兵ID-士兵数量+士兵ID-士兵数量... 	|

	local ws = wasteland.new()
	local troop = troop.new()


	ws:setImageId(info[2])

	local soldier_arr = {} 

	for i =3 , #info  do 
		local  sd  = soldier.new()
		local info =  self:strSplit(info[i] , "-")
		sd:setImageId(info[1])
		sd:setImageId(info[2])

		table.insert(soldier_arr , sd )
	end 

	troop:setsoldier(soldier_arr)
	ws:setTroop(troop)

	table.insert(defhero_arr,ws)
end 


function decode:baseActck(str)

	local attack_data = {}

	if string.find(str,"|") then  
		for _ ,v in pairs(self:strSplit(str , "|"))  do 
			 self:actck(v , attack_data)
		end 

	else -- 只有一攻击部队
		self:actck(str, attack_data)
	end

	return attack_data

end


function decode:defcastle(info , defhero_arr) -- 解析防御城堡

	-- 队伍类型（ 2.城堡 ）+领主名字+城墙-耐久度+箭塔ID-箭塔数量+陷阱ID-陷阱数量		|

	local castle = castle.new()
	local troop = troop.new()


	castle:setLeaderName(info[2])

	local cw = citywall.new()
	local citywall_data = self:strSplit(info[3], "-")	
	cw:setCityImageId(citywall_data[1])
	cw:setDurability(citywall_data[2])


	local at = archertower.new()
	local at_data = self:strSplit(info[4], "-")	
	at:setCityImageId(at_data[1])
	at:setCount(at_data[2])


	local pf = pitfall.new()
	local pf_data = self:strSplit(info[5], "-")	
	pf:setCityImageId(pf_data[1])
	pf:setCount(pf_data[2])

	local soldier_arr = {at , pf}

	troop:setsoldier(soldier_arr)

	castle:setTroop(troop)

	table.insert(defhero_arr,castle)

end 



function decode:defHero(info , defhero_arr)
	
	-- 防御方：	队伍类型（1.英雄部队）+部队ID+英雄ID+英雄等级+领主名字+指令+士兵ID-士兵数量+士兵ID-士兵数量...	|



	local hero = hero.new()

	local troop = troop.new()


	troop:setId(info[2])

	hero:setId(info[2])

	hero:setImageId(info[3])

	hero:setLv(info[4])	

	hero:setLeaderName(info[5])

	hero:setCommand(info[6])


	local test = function (str , soldier_arr)

		local soldier_data = soldier.new ()

		local info = self:strSplit(str , "-")

		soldier_data:setImageId(info[1])

		soldier_data:setCount(info[2])

		table.insert(soldier_arr ,soldier_data)
	end 

	local soldier_arr = {}

	for i = 7, #info do
		test(info[i] , soldier_arr)
	end 

	troop:setsoldier(soldier_arr)

	hero:setTroop(troop)


	dump(hero , "////////////////////fuck----------")


	table.insert(defhero_arr,hero)
end 

function decode:actck(str , attack_arr)
	
	-- 部队ID+英雄ID+英雄等级+领主名字+指令+士兵ID-士兵数量+士兵ID-士兵数量...
 	-- "lAtkInfo"   = "69606+0+0+TEST+2+8011-10+8041-4+8061-7+8021-5+8032-3+8031-12+31-4311"
	-- 攻击方解析

	local hero = hero.new()

	local troop = troop.new()

	local info = self:strSplit(str , "+")

	troop:setId(info[1])

	hero:setId(info[1])

	hero:setImageId(info[2])

	hero:setLv(info[3])	



	hero:setLeaderName(info[4])

	hero:setCommand(info[5])


	local test = function (str , soldier_arr)

		local soldier_data = soldier.new ()

		local info = self:strSplit(str , "-")

		soldier_data:setImageId(info[1])

		soldier_data:setCount(info[2])

		table.insert(soldier_arr ,soldier_data)
	end 

	local soldier_arr = {}

	for i = 6, #info do
		test(info[i] , soldier_arr)
	end 

	troop:setsoldier(soldier_arr)

	hero:setTroop(troop)


	table.insert(attack_arr,hero)
end 

function decode:strSplit(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

return decode

