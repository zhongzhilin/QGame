local _M = {
	
--开场动画
	{
		name = "OP.OPstart",
		key = 101,

	},

--引导建造伐木场

	{
		target = {114},--结果：伐木场1级
		name = "guide.part.part01",
		key = 201,
	},

--引导任务领奖    

	{		
		target = {115},--结果：当前任务：建造兵营，未完成
		name = "guide.part.part02a",
		key = 301,
	},


	--引导任务建筑

	{
		target = {116},--结果：兵营1级
		name = "guide.part.part02b",
		key = 302,
		startName = "guide.part.patch.patch01",
	},


--引导建造农田
	{

		target = {117},--结果：农田1级
		name = "guide.part.part04",
		key = 501,
	},

--引导训练士兵	

	{
		target = {118},--结果：有300个兵待收获  ★★★★★★★未实现，等涛涛支持★★★★★★★
		name = "guide.part.part05",
		key = 601,
	},

--引导训练士兵	

	{
		target = {119},--条件：有300个兵了
		name = "guide.part.part05b",
		key = 602,
		startName = "guide.part.part05c",
	},


--引导任务领奖励+升级


	{
		target = {120},--结果：建造1个农田的任务可领奖
		name = "guide.part.part06",
		key = 701,
	},


--引导进入大地图----- 


	{

		target = {121},--条件：已经创建了城堡
		name = "guide.part.part07b",
		key = 800,	
	},

	{
		target = {122},--条件：拥有1只部队 ★★★★★★★未实现，等涛涛支持★★★★★★★
		name = "guide.part.part07a",
		key = 803,
		startName = "guide.part.patch.patch02",
	},


--大地图相关引导预留 901和 guide.part.part08

--引导升级城堡
	
	{
		target = {123},--条件：城堡达到2级
		name = "guide.part.part09",
		key = 1001,
	},


--队列引导
	
	{
		name = "guide.part.part21",
		key = 1002,
	},


--引导收取资源


	{
		name = "guide.part.part10",
		key = 1101,
		startName = "guide.part.patch.patch07",
	},



-------------------------------删除这段引导


-- --引导升级伐木场
-- 	{
-- 		target = {124},--结果：伐木场2级
-- 		name = "guide.part.part11",
-- 		key = 1102,
-- 	},


-- --引导升级农田
-- 	{
-- 		target = {125},--结果：农田2级
-- 		name = "guide.part.part12",
-- 		key = 1103,
-- 	},	


-- --引导建造校场
-- 	{
-- 		target = {126},--结果：校场1级
-- 		name = "guide.part.part13",
-- 		key = 1201,
-- 	},	



-------------------------------删除这段引导




--引导建造酒馆
	{
		target = {127},--结果：酒馆1级
		name = "guide.part.part14",
		key = 1301,
	},	


--引导招募英雄  已改为：引导结识史诗英雄
	{
		target = {145},--结识任意英雄
		name = "guide.part.part15",
		key = 1401,
		startName = "guide.part.patch.patch06",
	},	


--引导史诗说服招募成功
	{
		target = {144},--拥有尼姆英雄
		name = "guide.part.part15b",
		key = 1402,
		startName = "guide.part.patch.patch05",
	},	







---引导英雄装备

	{
		name = "guide.part.part20",
		key = 1411,
	},	


--引导第二次进入大地图、迁城
	{
		name = "guide.part.part19a",
		key = 1501,
	},	


--引导第二次进入大地图、迁城
	{
		name = "guide.part.part19b",
		key = 1502,
		startName = "guide.part.patch.patch03",
	},	




--引导刷出资源野地，打野地（已改成打小村庄）
	{
		name = "guide.part.part16",
		key = 1602,
		startName = "guide.part.patch.patch04",
	},	




-- --引导签到  --暂时删除
-- 	{
-- 		name = "guide.part.part17",
-- 		key = 1801,
-- 	},	



--引导每日任务+每日任务宝箱
	{
		name = "guide.part.part18",
		key = 1901,
	},	



}

return _M