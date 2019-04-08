local _M = {
	
--开场动画
	{
		name = "OP.OPstart",
		key = 101,
	},


--进内城NPC对话

	{
		name = "NewGuide.part.part01",
		key = 201,
	},

--建造伐木场
	{
		target = {114},--结果：伐木场1级
		name = "NewGuide.part.part02",
		key = 301,
		startName = "NewGuide.part.patch.patch02",
	},

--收取伐木场资源

	{
		name = "NewGuide.part.part03",
		key = 401,
		startName = "NewGuide.part.patch.patch03",
	},

--主线任务，领取伐木场奖励

	{		
		target = {115},--结果：当前任务：建造兵营，未完成
		name = "NewGuide.part.part04",
		key = 451,
	},

--引导建造兵营

	{
		target = {116},--结果：兵营1级
		name = "NewGuide.part.part05",
		key = 501,
	},

--训练300士兵

	{
		target = {118},
		name = "NewGuide.part.part06",
		key = 601,
		startName = "NewGuide.part.patch.patch06",
	},

--收取300士兵

	{
		target = {119},--条件：有300个兵了
		name = "NewGuide.part.part07",
		key = 701,
		startName = "NewGuide.part.patch.patch07",
	},

--引导点击支线任务按钮，领取训练300士兵的支线任务

	{
		name = "NewGuide.part.part08",
		key = 711,
	},


--点击“前往”按钮建造农田

	{
		name = "NewGuide.part.part09",
		key = 721,
		startName = "NewGuide.part.patch.patch09",
	},

--主线任务按钮上领取奖励 + 领主升级 + 国王出来说两句【进入自由阶段】

	{		
		target = {240},--结果：当前任务：建造兵营，未完成  应该需要有个领取任务后置条件
		name = "NewGuide.part.part10",
		key = 731,
	},


--【自由活动时间】

--城堡2级，触发创建城堡


	{
		cutTarget = {123}, -- 城堡2级
		target = {121},--条件：已经创建了城堡
		name = "NewGuide.part.part11",
		key = 800,	
		startName = "NewGuide.part.patch.patch11",
	},


--迁城引导



--引导第二次进入大地图、迁城
	{
		cutTarget = {123}, -- 城堡2级
		name = "NewGuide.part.part12",
		key = 801,
		startName = "NewGuide.part.patch.patch12",
	},	



--奥博尔投靠 + 编辑部队 +  


	{
		cutTarget = {123}, -- 城堡2级
		target = {122},--条件：拥有1只部队 
		name = "NewGuide.part.part13",
		key = 900,
		startName = "NewGuide.part.patch.patch13",
	},

--出征 + 攻打冰熊 + 引导进内城【进入自由阶段】

	{
		cutTarget = {123}, -- 城堡2级
		name = "NewGuide.part.part13a",
		key = 901,
		startName = "NewGuide.part.patch.patch13a",
	},


-- --神兽引导
-- 	{
-- 		cutTarget = {123}, -- 城堡2级
-- 		name = "NewGuide.part.part13b",
-- 		key = 902,
-- 	},

--【自由活动时间】


--建造酒馆，触发说服理查引导


	{
		cutTarget = {7}, -- 酒馆1级
		target = {145},--结识任意英雄
		name = "NewGuide.part.part14",
		key = 905,
		startName = "NewGuide.part.patch.patch14",
	},	



	{
		cutTarget = {7}, -- 酒馆1级
		target = {284},--拥有10个达尼尔碎片
		name = "NewGuide.part.part14a",
		key = 910,
		startName = "NewGuide.part.patch.patch14a",
	},	




	{
		cutTarget = {7,303}, -- 酒馆1级,达尼尔仍然是1阶
		name = "NewGuide.part.part14b",
		key = 915,
	},	








--屏幕闪红，后续引导……

	{
		cutTarget = {7,108}, -- 酒馆1级,是否有100规模以上
		name = "NewGuide.part.part15",
		key = 1001,

	},	




}

return _M