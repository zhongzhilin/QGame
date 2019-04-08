--region UIHeroExpListPanel.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeroExpListPanel  = class("UIHeroExpListPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIHeroExpListItemCell = require("game.UI.union.second.exp.UIHeroExpListItemCell")

function UIHeroExpListPanel:ctor()
    self:CreateUI()
end

function UIHeroExpListPanel:CreateUI()
    local root = resMgr:createWidget("hero_exp/hero_exp_union_bg")
    self:initUI(root)
end

function UIHeroExpListPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/hero_exp_union_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.tb_top = self.root.tb_top_export
    self.tips = self.root.tips_fnt_mlan_34_export
    self.tb_size = self.root.tb_size_export
    self.tb_item_size = self.root.tb_item_size_export
    self.tb_add = self.root.tb_add_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) 
        global.panelMgr:closePanel("UIHeroExpListPanel")
    end)

    self.tableView = UITableView.new()
        :setSize(self.tb_size:getContentSize(), self.tb_top)
        :setCellSize(self.tb_item_size:getContentSize())
        :setCellTemplate(UIHeroExpListItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroExpListPanel:onEnter()

    gdisplay.loadSpriteFrames("hero.plist")

    global.unionApi:updateHeroSpring(1)

    self.tips:setVisible(false)

    local updataCall = function ()
        self:setData(global.unionData:getActivitySpring())
    end 

    self:addEventListener(global.gameEvent.EV_ON_UNION_HEREXPUPDATE ,function ()
        updataCall()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UNION_HEREXPLOCALDATAUP ,function ()
        updataCall()
    end)
end

function UIHeroExpListPanel:setData(data)

    self.tips:setVisible(not data or table.nums(data) <= 0 )

    if not data then return end         

    self.data = data


    self.tableView:setData(self.data)
end 

function UIHeroExpListPanel:onExit()

end 

--CALLBACKS_FUNCS_END

return UIHeroExpListPanel

--endregion
