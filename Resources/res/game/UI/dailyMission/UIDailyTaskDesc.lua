--region UIDailyTaskDesc.lua
--Author : untory
--Date   : 2016/08/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local dailyTaskData = global.dailyTaskData
local luaCfg = global.luaCfg
local UITableView = require("game.UI.common.UITableView")
local UITaskDescGiftCell = require("game.UI.mission.UITaskDescGiftCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDailyTaskDesc  = class("UIDailyTaskDesc", function() return gdisplay.newWidget() end )

function UIDailyTaskDesc:ctor()
    self:CreateUI()
end

function UIDailyTaskDesc:CreateUI()
    local root = resMgr:createWidget("task/task_daily_desc")
    self:initUI(root)
end

function UIDailyTaskDesc:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "task/task_daily_desc")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.title = self.root.Node_export.title_export
    self.moreDesc = self.root.Node_export.moreDesc_export
    self.progress_text = self.root.Node_export.progress_text_export
    self.score = self.root.Node_export.score_export
    self.quality = self.root.Node_export.quality_export
    self.Button_1 = self.root.Node_export.Button_1_export
    self.Text_5 = self.root.Node_export.Button_1_export.Text_5_mlan_6_export
    self.tbsize = self.root.Node_export.tbsize_export
    self.itsize = self.root.Node_export.tbsize_export.itsize_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:jump_call(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UITaskDescGiftCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tableView:setPosition(self.tbsize:getPosition())
    self.tbsize:getParent():addChild(self.tableView)

end

local picBg = {
    [1] = "ui_button/btn_equip_grey.png",
    [2] = "ui_button/btn_reward.png",
}
 
function UIDailyTaskDesc:setData(data, confirmCall)

    self.data = data
    self.confirmCall = confirmCall
    local taskData = luaCfg:get_daily_task_by(data.id)

    self.taskBuildType = taskData.taskTarget
    self.taskGPSType = taskData.location

    self.moreDesc:setString(taskData.description)
    -- self.desc:setString(taskData.taskDescription)
    self.title:setString(taskData.taskName)


    self.progress_text:setString(string.format(luaCfg:get_local_string(10002),data.progress,taskData.taskRound))
    self.score:setString(string.format(luaCfg:get_local_string(10003),data.progress* taskData.integral,taskData.taskRound * taskData.integral))

    local dropData = luaCfg:get_drop_by(taskData.reward)
    self.quality:setString(string.format(luaCfg:get_local_string(10004),luaCfg:get_local_string(10005 + taskData.quality)))

    self.tableView:setData(dropData.dropItem)

    self.Button_1:setVisible(true)
    self.Button_1:loadTextures(picBg[1],picBg[1],picBg[1],ccui.TextureResType.plistType)
    self.Text_5:setString(luaCfg:get_local_string(10014))

    if data.state == WDEFINE.DAILY_TASK.TASK_STATE.GETD then
        self.Button_1:setVisible(false)
    elseif data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
        self.Button_1:loadTextures(picBg[2],picBg[2],picBg[2],ccui.TextureResType.plistType)
        self.Text_5:setString(luaCfg:get_local_string(10013))
    end

    -- 使用魔晶、升级资源任务不需要前往
    if self.taskGPSType == 0 and data.state ~= WDEFINE.DAILY_TASK.TASK_STATE.DONE then
        self.Button_1:setVisible(false)
    end


    -- for i = 1,4 do

    --     if i < allCount then
        
    --         local drop = dropItems[i]
    --         local id = drop[1]
    --         local num = drop[2]

    --         local itemData = luaCfg:get_item_by(id)

    --         self["pic"..i]:setVisible(true)
    --         self["Text_"..i]:setVisible(true)

    --         self["pic"..i]:loadTexture(itemData.itemIcon,ccui.TextureResType.plistType)
    --         self["Text_"..i]:setString(itemData.itemName .. " " .. num)
    --     else

    --         self["pic"..i]:setVisible(false)
    --         self["Text_"..i]:setVisible(false)

    --     end
    -- end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDailyTaskDesc:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIDailyTaskDesc")
end

function UIDailyTaskDesc:jump_call(sender, eventType)

    if self.data.state == WDEFINE.DAILY_TASK.TASK_STATE.DONE then
        global.panelMgr:closePanel("UIDailyTaskDesc")
        if self.confirmCall then
            self.confirmCall()
        end
        return
    end 

    global.funcGame.handleQuickTask(self.taskGPSType,self.taskBuildType,self.data.taskTargetlevel)

    global.panelMgr:closePanel("UIDailyTaskDesc")
    global.panelMgr:closePanel("UIDailyTaskPanel")
end
--CALLBACKS_FUNCS_END

return UIDailyTaskDesc

--endregion
