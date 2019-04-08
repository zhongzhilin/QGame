--region UIGMBattle.lua
--Author : Administrator
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGMBattle  = class("UIGMBattle", function() return gdisplay.newWidget() end )

function UIGMBattle:ctor()
    self:CreateUI()
end

function UIGMBattle:CreateUI()
    local root = resMgr:createWidget("battle/BattleNode")
    self:initUI(root)
end

function UIGMBattle:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "battle/BattleNode")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ListView = self.root.beijing.ListView_export
    self.trap_dis_num = self.root.beijing.ListView_export.Image_8_0_0.trap_dis_num_export
    self.torret_dis_num = self.root.beijing.ListView_export.Image_8_0_0.torret_dis_num_export
    self.wall_dis_num = self.root.beijing.ListView_export.Image_8_0_0.wall_dis_num_export
    self.round_num = self.root.beijing.ListView_export.Image_8_0_0.round_num_export
    self.def_death_pro = self.root.beijing.ListView_export.Image_8_0.def_death_pro.def_death_pro_export
    self.atk_death_pro = self.root.beijing.ListView_export.Image_8_0.atk_death_pro.atk_death_pro_export
    self.def_result = self.root.beijing.ListView_export.Image_8_0.def_0.def_result_export
    self.atk_result = self.root.beijing.ListView_export.Image_8_0.atk_0.atk_result_export
    self.battle_time = self.root.beijing.ListView_export.Image_8_0.battle_time.battle_time_export
    self.esc = self.root.esc_export

    uiMgr:addWidgetTouchHandler(self.esc, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIGMBattle:onEnter()
	
	global.worldApi:gmBattle(function(data)
		
		-- data = {
		--     lRate         = 75,
		--     lWin          = 1,
		--     lcostSoldier  = 0,
		--     lcostfirmness = 0,
		--     lcostlow      = 0,
		--     tgAtkTroop = {
		--         [1] = {
		--             lPurpose       = 1,
		--             lTroopid       = 571,
		--             tgLosSoldier = {
		--                 [1] = {
		--                     lCount = 61,
		--                     lID    = 1011,
		--                 },
		--             },
		--             tgSoldier = {
		--                 [1] = {
		--                     lCount = 718,
		--                     lID    = 1011,
		--                 },
		--             },
		--             tgWoundSoldier = {
		--                 [1] = {
		--                     lCount = 0,
		--                     lID    = 1011,
		--                 },
		--             },
		--         },
		--     },
		--     tgDefTroop = {
		--         [1] = {
		--             lPurpose       = 0,
		--             lTroopid       = 572,
		--             tgLosSoldier = {
		--                 [1] = {
		--                     lCount = 231,
		--                     lID    = 1011,
		--                 },
		--             },
		--             tgSoldier = {
		--                 [1] = {
		--                     lCount = 231,
		--                     lID    = 1011,
		--                 },
		--             },
		--             tgWoundSoldier = {
		--                 [1] = {
		--                     lCount = 173,
		--                     lID    = 1011,
		--                 },
		--             },
		--         },
		--     },
		--     tgFightOne = {
		--         [1] = {
		--             lCosDamage = 10,
		--             lCount     = 10,
		--             lSoldierid = 1031,
		--             lTrapid    = 71,
		--             lTroopid   = 1,
		--             llosCount  = 10,
		--         },
		--     },
		--     tgFightSec = {
		--         [1] = {
		--             lDamage = 1,
		--             lPower  = 10,
		--             lcount  = 10,
		--             lid     = 1031,
		--         },
		--     },
		--     tgRoundData = {
		--         [1] = {
		--             lAtkCount     = 718,
		--             lAtkDamage    = 57440,
		--             lAtkLeftCount = 659,
		--             lAtkLosCount  = 59,
		--             lAtkSoldierid = 1011,
		--             lAtkTroopid   = 571,
		--             lDefCount     = 231,
		--             lDefDamage    = 11550,
		--             lDefLeftCount = 20,
		--             lDefLosCount  = 211,
		--             lDefSoldierid = 1011,
		--             lDefTroopid   = 572,
		--             lRound        = 0,
		--         },
		--         [2] = {
		--             lAtkCount     = 659,
		--             lAtkDamage    = 52720,
		--             lAtkLeftCount = 658,
		--             lAtkLosCount  = 1,
		--             lAtkSoldierid = 1011,
		--             lAtkTroopid   = 571,
		--             lDefCount     = 20,
		--             lDefDamage    = 1000,
		--             lDefLeftCount = 1,
		--             lDefLosCount  = 19,
		--             lDefSoldierid = 1011,
		--             lDefTroopid   = 572,
		--             lRound        = 1,
		--         },
		--         [3] = {
		--             lAtkCount     = 658,
		--             lAtkDamage    = 52640,
		--             lAtkLeftCount = 657,
		--             lAtkLosCount  = 1,
		--             lAtkSoldierid = 1011,
		--             lAtkTroopid   = 571,
		--             lDefCount     = 1,
		--             lDefDamage    = 50,
		--             lDefLeftCount = 0,
		--             lDefLosCount  = 1,
		--             lDefSoldierid = 1011,
		--             lDefTroopid   = 572,
		--             lRound        = 2,
		--         },
		--     },
		-- }

		-- dump(data)

		if data.lWin == 0 then return end

		data.tgDefTroop = data.tgDefTroop or {}
		data.tgRoundData = data.tgRoundData or {}
		data.tgRoundDataThird = data.tgRoundDataThird or {}
		data.tgFightSec = data.tgFightSec or {}

		self.wall_dis_num:setString(data.lcostfirmness)
		self.torret_dis_num:setString(data.lcostlow)
		self.trap_dis_num:setString(data.lcostSoldier)


		self.ListView:insertCustomItem(require("game.UI.world.widget.GM.UIBattleItem1").new(data),1)
		self.ListView:insertCustomItem(require("game.UI.world.widget.GM.UIBattleItem2").new(data),4)
		self.ListView:insertCustomItem(require("game.UI.world.widget.GM.UIBattleItem3").new(data),6)
		self.ListView:insertCustomItem(require("game.UI.world.widget.GM.UIBattleItem4").new(data),8)
		self.ListView:insertCustomItem(require("game.UI.world.widget.GM.UIBattleItem5").new(data),11)
		
		if data.lWin == 1 then
			self.atk_result:setString("获胜")
			self.def_result:setString("失败")
		else
			self.atk_result:setString("失败")
			self.def_result:setString("获胜")
		end
	
		self.atk_death_pro:setString(data.lRate .. "%")
		self.def_death_pro:setString(data.lRate .. "%")
		local cutTime = data.lreadytime
		local hour = math.floor(cutTime / 3600) 
	    cutTime = cutTime  % 3600
	    local min = math.floor(cutTime / 60)
	    cutTime = cutTime % 60
	    local sec = math.floor(cutTime)
		self.battle_time:setString(string.format("%s:%s:%s",hour,min,sec))
	end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGMBattle:exit_call(sender, eventType)

	global.panelMgr:destroyPanel("UIGMBattle")
end
--CALLBACKS_FUNCS_END

return UIGMBattle

--endregion
