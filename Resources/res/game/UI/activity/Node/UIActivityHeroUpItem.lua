--region UIActivityHeroUpItem.lua
--Author : yyt
--Date   : 2018/02/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroStarList = require("game.UI.hero.UIHeroStarList")
--REQUIRE_CLASS_END

local UIActivityHeroUpItem  = class("UIActivityHeroUpItem", function() return gdisplay.newWidget() end )

local item = require("game.UI.activity.Node.UIIconNode")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local UITableView =  require("game.UI.common.UITableView")

function UIActivityHeroUpItem:ctor()
    self:CreateUI()
end

function UIActivityHeroUpItem:CreateUI()
    local root = resMgr:createWidget("activity/upgradeHero_activity_node")
    self:initUI(root)
end

function UIActivityHeroUpItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/upgradeHero_activity_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.scrollView = self.root.bg_export.reward_bg.scrollView_export
    self.prossNode = self.root.bg_export.prossNode_export
    self.current = self.root.bg_export.prossNode_export.current_export
    self.target = self.root.bg_export.prossNode_export.target_export
    self.now = self.root.bg_export.prossNode_export.now_mlan_8_export
    self.target_text = self.root.bg_export.target_text_export
    self.table_add = self.root.table_add_export
    self.node_killed = self.root.node_killed_export
    self.table_item = self.root.table_item_export
    self.table_contont = self.root.table_contont_export
    self.hero_icon = self.root.heroItemNode.hero_icon_export
    self.FileNode_1 = UIHeroStarList.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.heroItemNode.FileNode_1)
    self.left = self.root.heroItemNode.left_export
    self.right = self.root.heroItemNode.right_export
    self.hero_name = self.root.heroItemNode.hero_name_export
    self.hero_type = self.root.heroItemNode.hero_type_export
    self.receive = self.root.receive_export
    self.grayBg = self.root.receive_export.grayBg_export

    uiMgr:addWidgetTouchHandler(self.receive, function(sender, eventType) self:receiveHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.table_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.table_add:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
local color ={
    red = cc.c3b(180, 29, 11), 
    back = cc.c3b(0, 0, 0),
}

function UIActivityHeroUpItem:setData(data)

    if global.UIActivityHeroUpPanelCell then 
        global.UIActivityHeroUpPanelCell[data.id] = self
    end 
    
    self.data = data
    local isFinish = data.class == 5 and global.ActivityData:getActHeroUpgrade(data.id) == 1
    self.node_killed:setVisible(isFinish)
    -- self.prossNode:setVisible(data.curHeroClass ~= nil)
    --if data.curHeroClass then -- 拥有当前英雄
        if isFinish then 
            self.current:setString(data.curHeroClass or 0)        
            self.current:setTextColor(color.back)
        else
            self.current:setString(data.curHeroClass or 0)        
            self.current:setTextColor(color.red)
        end 
        self.target:setString("/"..data.class)
    --end
    self.target_text:setString(global.luaCfg:get_local_string(11114, data.class))
    self.target:setPositionX(self.current:getPositionX()+self.current:getContentSize().width)


    self.isCanGet = false
    self.receive:setVisible(not isFinish)
    global.colorUtils.turnGray(self.grayBg, true)
    local curPro = tonumber(self.current:getString())
    local tarPro = data.class
    if (not isFinish) and curPro >= tarPro then
        self.receive:setVisible(true)
        global.colorUtils.turnGray(self.grayBg, false)
        self.isCanGet = true
    end

    local temp = {} 
    for index ,v in pairs(global.luaCfg:get_drop_by(data.reward).dropItem) do 
        local tData = {} 
        tData.tips_panel = data.tips_panel
        tData.data = global.luaCfg:get_local_item_by(v[1])
        tData.isshownumber =  true
        tData.number = v[2]
        table.insert(temp, clone(tData))
    end

    table.sort(temp, function(A ,B) return A.data.quality >  B.data.quality end)
    for _ ,v in pairs(temp) do 
        v.scale = 1.285
    end 
    self.tableView:setData(temp)

    local curHeroData = global.heroData:getHeroPropertyById(data.heroId)
    curHeroData.lStar = data.class 
    self:initHeroItem(curHeroData)
end

function UIActivityHeroUpItem:initHeroItem(data)

    global.panelMgr:setTextureFor(self.hero_icon, data.nameIcon)
    self.hero_name:setString(data.name)
    self.FileNode_1:setData(data.heroId, data.lStar) 
    self.hero_type:loadTexture(data.typeIcon, ccui.TextureResType.plistType)
    global.heroData:setHeroIconBg(data.heroId, self.left, self.right)

end


function UIActivityHeroUpItem:setTBTouchEable(state)

    if state then 
        if not self.tableView:isTouchEnabled()  then 
            self.tableView:setTouchEnabled(true)
        end
    else 
        self.tableView:setTouchEnabled(false)
    end 
end 

function UIActivityHeroUpItem:onExit()

    if global.UIActivityHeroUpPanelCell then 
        global.UIActivityHeroUpPanelCell[self.data.id] = nil
    end 
end 


function UIActivityHeroUpItem:receiveHandler(sender, eventType)

    if not self.isCanGet then
        return global.tipsMgr:showWarning("cantGetReward")
    end

    local activityId = 30001
    global.ActivityAPI:getActivityReward(function (msg)
        -- body
        if not self.setData then return end
        global.ActivityData:updataActHeroById(self.data.id, 1)
        self:setData(self.data)

        msg.tgItem = msg.tgItem or {}
        local data = {}
        for i,v in ipairs(msg.tgItem) do
            local temp = {} 
            table.insert(temp, v.lID)
            table.insert(temp, v.lCount)
            table.insert(data, temp)
        end
        global.panelMgr:openPanel("UIItemRewardPanel"):setData(data, true) 
        global.panelMgr:getPanel("UIActivityHeroUpPanel"):reFresh()

    end, activityId, self.data.id)

end
--CALLBACKS_FUNCS_END

return UIActivityHeroUpItem

--endregion
