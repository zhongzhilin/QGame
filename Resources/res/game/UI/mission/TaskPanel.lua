--region TaskPanel.lua
--Author : untory
--Date   : 2016/08/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
local MainTaskItem = require("game.UI.mission.MainTaskItem")
local UITaskTab = require("game.UI.mission.UITaskTab")
--REQUIRE_CLASS_END

local TaskPanel  = class("TaskPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local NormalTaskItem = require("game.UI.mission.NormalTaskItem")
local NormalTaskItemCell = require("game.UI.mission.NormalTaskItemCell")
local UIAdvertisementItem = require("game.UI.advertisementItem.UIAdvertisementItem")

TaskPanel.normalTasks = {}

function TaskPanel:ctor()
    self:CreateUI()
end

function TaskPanel:CreateUI()
    local root = resMgr:createWidget("task/task_bg")
    self:initUI(root)
end

function TaskPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN 
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.common_task = self.root.common_task_export
    self.common_task_panel = self.root.common_task_export.common_task_panel_export
    self.top_node = self.root.top_node_export
    self.FileNode_4 = MainTaskItem.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.Node_26.FileNode_4)
    self.reward_drop = self.root.reward_drop_export
    self.bottomNode = self.root.bottomNode_export
    self.paging = self.root.paging_export
    self.paging = UITaskTab.new()
    uiMgr:configNestClass(self.paging, self.root.paging_export)

    uiMgr:addWidgetTouchHandler(self.root.Image_4.Button_1, function(sender, eventType) self:btn_exit(sender, eventType) end)
--EXPORT_NODE_END

  	self.tableView = UITableView.new()
        :setSize(self.common_task:getContentSize(),self.top_node,self.bottomNode)
        :setCellSize(self.common_task_panel:getContentSize())
        :setCellTemplate(NormalTaskItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self:addChild(self.tableView)

    local guideData = global.guideData
    guideData:addTargetList(self.__cname, "arrive_btn", self.FileNode_4.arrive_btn)
    guideData:addTargetList(self.__cname, "Button_1", self.root.Image_4.Button_1)
end

------

function TaskPanel:onEnter()

    local data = global.taskData:getNormalTasks()

    local compare = function(a, b)
        
        if a.state == b.state then
           
            return a.id < b.id 
        else

            return a.state > b.state
        end
    end

    table.sort(data, compare)
    
    self.tableView:setData(self:setItemId(data) , true )
    self.FileNode_4:setData(global.taskData:getMainTask())
    self.FileNode_1:setData(4,false,nil)
    self.tableView:jumpToCellYByIdx(#self.tableView:getData() , true)
    self.paging:setIndex(1)
end

function TaskPanel:setItemId(data)
    for i,v in ipairs(data) do
        v.sortId = i
    end
    return data
end

function TaskPanel:playGetGift(mainTaskData)
    -- body
    self.FileNode_4:playGetGift(mainTaskData)
end

function TaskPanel:playGiftEffect( taskId , isnormal )
   
    local data = nil 
    if isnormal then
    
        data = luaCfg:get_common_task_by(taskId)
    else

        data = luaCfg:get_main_task_by(taskId)
    end
    if not data then return end
    
    local dropId = data.reward
    local dropData = luaCfg:get_drop_by(dropId)
    
    local itemId = -1
    local min = -1
    for _,v in ipairs(dropData.dropItem) do
    
        print(v[2],min,"check list")
        if v[2] > min and v[1] < 5 and v[1] >= 1 then

            min = v[2]
            itemId = v[1]
        end
    end

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_reward_"..itemId)
    if itemId == 2 then

        global.tipsMgr:showEffectTips("effect/effect_task_reward_coin","animation0",0.3)
    elseif itemId == 3 then

        global.tipsMgr:showEffectTips("effect/effect_task_reward_wood","animation0",0.3)
    elseif itemId == 1 then

        global.tipsMgr:showEffectTips("effect/effect_task_reward_food","animation0",0.3)
    elseif itemId == 4 then

        global.tipsMgr:showEffectTips("effect/effect_task_reward_stone","animation0",0.3)
    end

    uiMgr:addSceneModel(21 / 60)
end

function TaskPanel:flushView()
    -- body
    
    local data = global.taskData:getNormalTasks()

    local compare = function(a, b)
        
        if a.state == b.state then
           
            return a.id < b.id 
        else

            return a.state > b.state
        end
    end

    table.sort(data, compare)
   
    self.tableView:setData(self:setItemId(data))
    self.FileNode_4:setData(global.taskData:getMainTask())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function TaskPanel:btn_exit(sender, eventType)
    -- self:removeFromParent()
    global.panelMgr:closePanelForBtn("TaskPanel")
end

function TaskPanel:setPageViewCurrentPageIndex(index)
    self.FileNode_1:setPageViewCurrentPageIndex(index)
end

function TaskPanel:getPageViewCurrentPageIndex()
   return self.FileNode_1:getPageViewCurrentPageIndex()
end 

function TaskPanel:changeToACM(sender, eventType)

    local panel  =   global.panelMgr:openPanel("UIAchievePanel")
    panel:showTab()
    global.panelMgr:closePanel("TaskPanel")
end

function TaskPanel:changeToDaily(sender, eventType)

    local opLv = global.luaCfg:get_config_by(1).dailyTaskLv
    if global.funcGame:checkBuildLv(1, opLv) then
        local panel  =  global.panelMgr:openPanel("UIDailyTaskPanel")
        panel:showTab()
        panel:setData()    
        global.panelMgr:closePanel("TaskPanel")
    end
end
--CALLBACKS_FUNCS_END

return TaskPanel

--endregion
