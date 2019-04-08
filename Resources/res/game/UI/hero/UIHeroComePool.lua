--region UIHeroComePool.lua
--Author : Untory
--Date   : 2018/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UITableView = require("game.UI.common.UITableView")
local UIHeroGirdItemCell = require("game.UI.hero.UIHeroGirdItemCell")
local UIHeroComePool  = class("UIHeroComePool", function() return gdisplay.newWidget() end )

function UIHeroComePool:ctor()
    self:CreateUI()
end

function UIHeroComePool:CreateUI()
    local root = resMgr:createWidget("hero/hero_come_hero_list")
    self:initUI(root)
end

function UIHeroComePool:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_come_hero_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_export
    self.tbsize = self.root.Node_export.tbsize_export
    self.tbsizeTurn = self.root.Node_export.tbsizeTurn_export
    self.itsize = self.root.Node_export.itsize_export
    self.rank_bt = self.root.Node_export.rank_bt_export
    self.top_node = self.root.Node_export.top_node_export
    self.ing = self.root.Node_export.ing_export
    self.ing_par = self.root.Node_export.ing_par_mlan_8_export
    self.percentage = self.root.Node_export.percentage_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rank_bt, function(sender, eventType) self:rank_click(sender, eventType) end)
--EXPORT_NODE_END

    self.tableview = UITableView.new()
        :setSize(self.tbsize:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.itsize:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIHeroGirdItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(4)
    self.tbsize:addChild(self.tableview)

    self.tableviewTurn = UITableView.new()
        :setSize(self.tbsizeTurn:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.itsize:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIHeroGirdItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(4)
    self.tbsizeTurn:addChild(self.tableviewTurn)
end

function UIHeroComePool:onEnter()
    local barLevel = self:getBarLevel()
    local bar_unlock_data = luaCfg:hero_unlock()
    local heroData = global.heroData
    local resList = {}
    local alreadyGetCount = 0
    for _,v in ipairs(bar_unlock_data) do
        if #v.hero > 0 then
            local heroId = v.hero[1][1]
            local heroData = heroData:getHeroDataById(heroId)
            heroData.isWillCome = barLevel >= v.lv
            heroData.comeLv = v.lv
            
            if heroData.state == 1 or heroData.state == 3 or heroData.state == 4 then
                alreadyGetCount = alreadyGetCount + 1
            end

            table.insert(resList,heroData)
        end
    end

    self.percentage:setString(alreadyGetCount .. '/' .. #resList)
    self.ing:setString(string.format('%.2f%%',alreadyGetCount / #resList * 100))

    self.percentage:setVisible(true)
    self.ing_par:setVisible(true)
    self.ing:setVisible(true)
    self.txt_Title:setString(luaCfg:get_local_string(11168))
    
    self.tbsize:setVisible(true)
    self.tbsizeTurn:setVisible(false)
    self.tableview:setData(resList)
end

function UIHeroComePool:setTurnTableHalf()

    self.ing_par:setVisible(false)
    self.ing:setVisible(false)
    self.percentage:setVisible(false)
    self.txt_Title:setString(luaCfg:get_local_string(11169))

    local resList = {}
    local bar_unlock_data = luaCfg:turntable_hero_list()
    for _,v in ipairs(bar_unlock_data) do
        local heroConfig = clone(global.heroData:getHeroDataById(v.heroId)) -- clone(global.heroData:getHeroPropertyById(v.heroId))
        heroConfig.isTurnTableHalf = true 
        table.insert(resList, heroConfig)
    end
    self.tbsize:setVisible(false)
    self.tbsizeTurn:setVisible(true)
    self.tableviewTurn:setData(resList)

end

function UIHeroComePool:getBarLevel()
    local buildData = global.cityData:getTopLevelBuild(15)    
    if buildData then
        return buildData.serverData.lGrade
    end
    return 0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroComePool:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn('UIHeroComePool')
end

function UIHeroComePool:rank_click(sender, eventType)
    global.panelMgr:closePanelForBtn('UIHeroComePool')
end
--CALLBACKS_FUNCS_END

return UIHeroComePool

--endregion
