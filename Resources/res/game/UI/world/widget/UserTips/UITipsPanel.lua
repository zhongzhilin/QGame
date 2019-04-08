--region UITipsPanel.lua
--Author : untory
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITableView = require("game.UI.common.UITableView")
local UITipsItemCell = require("game.UI.world.widget.UserTips.UITipsItemCell")

local UITipsPanel  = class("UITipsPanel", function() return gdisplay.newWidget() end )

function UITipsPanel:ctor()
    self:CreateUI()
end

function UITipsPanel:CreateUI()
    local root = resMgr:createWidget("world/info/stickers_bj")
    self:initUI(root)
end

function UITipsPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/stickers_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.text = self.root.Node_export.Node_5.create_0.text_mlan_6_export
    self.tbsize = self.root.Node_export.tbsize_export
    self.itsize = self.root.Node_export.itsize_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create, function(sender, eventType) self:addTips(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create_0, function(sender, eventType) self:delHandler(sender, eventType) end)
--EXPORT_NODE_END
    
    self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UITipsItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setPosition(self.tbsize:getPosition())
        :setColumn(1)

    self.tbsize:getParent():addChild(self.tableView)
end

function UITipsPanel:setData(data)

    -- data = {
    --     tagStickers = {[1] = {
    --         lColor = 2,
    --         lFlag = 0,
    --         lID = 21,
    --         lSendID = 6000106,
    --         lTime = 1483603054,
    --         szContent = "测试",
    --         szSendName = "神将霍索恩",
    --     },
    --     [2] = {
    --         lColor = 2,
    --         lFlag = 1,
    --         lID = 20,
    --         lSendID = 6000106,
    --         lTime = 1483603022,
    --         szContent = "测试",
    --         szSendName = "神将霍索恩",
    --     },
    --     [3] = {
    --         lColor = 7,
    --         lFlag = 0,
    --         lID = 19,
    --         lSendID = 6000106,
    --         lTime = 1483543258,
    --         szContent = "的嗯",
    --         szSendName = "神将霍索恩",
    --     },
    --     [4] = {
    --         lColor = 11,
    --         lFlag = 0,
    --         lID = 18,
    --         lSendID = 6000106,
    --         lTime = 1483543077,
    --         szContent = "颜色测试",
    --         szSendName = "神将霍索恩",
    --     },
    --     [5] = {
    --         lColor = 2,
    --         lFlag = 0,
    --         lID = 17,
    --         lSendID = 6000106,
    --         lTime = 1483543052,
    --         szContent = "颜色测试",
    --         szSendName = "神将霍索恩",
    --     },
    --     [6] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 16,
    --         lSendID = 6000106,
    --         lTime = 1483542283,
    --         szContent = "时间测试",
    --         szSendName = "神将霍索恩",
    --     },
    --     [7] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 15,
    --         lSendID = 6000106,
    --         lTime = 1483538015,
    --         szContent = "排名第一",
    --         szSendName = "神将霍索恩",
    --     },
    --     [8] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 14,
    --         lSendID = 6000106,
    --         lTime = 1483528386,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [9] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 13,
    --         lSendID = 6000106,
    --         lTime = 1483528386,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [10] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 12,
    --         lSendID = 6000106,
    --         lTime = 1483528385,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [11] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 11,
    --         lSendID = 6000106,
    --         lTime = 1483528385,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [12] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 10,
    --         lSendID = 6000106,
    --         lTime = 1483528385,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [13] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 9,
    --         lSendID = 6000106,
    --         lTime = 1483528385,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [14] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 8,
    --         lSendID = 6000106,
    --         lTime = 1483528384,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [15] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 7,
    --         lSendID = 6000106,
    --         lTime = 1483528384,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [16] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 6,
    --         lSendID = 6000106,
    --         lTime = 1483528384,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [17] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 5,
    --         lSendID = 6000106,
    --         lTime = 1483528379,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [18] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 4,
    --         lSendID = 6000106,
    --         lTime = 1483528378,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [19] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 3,
    --         lSendID = 6000106,
    --         lTime = 1483528378,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },
    --     [20] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 2,
    --         lSendID = 6000106,
    --         lTime = 1483528377,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },  ·····
    --     [21] = {
    --         lColor = 1,
    --         lFlag = 0,
    --         lID = 1,
    --         lSendID = 6000106,
    --         lTime = 1483408376,
    --         szContent = "测试贴条",
    --         szSendName = "神将霍索恩",
    --     },}
    -- }

    data.tagStickers = data.tagStickers or {}

    self.data = clone(data)

    self:checkSwitch(data.lSwitch)
    self:checkTimeList(data.tagStickers)
    self.tableView:setData(data.tagStickers)
end

function UITipsPanel:checkSwitch(lSwitch)
    
    self.data.lSwitch = lSwitch

    if lSwitch == 0 then

        self.text:setString(luaCfg:get_local_string(10279))
        gevent:call(global.gameEvent.EV_ON_OPEN_TIPS_PANEL)
    else

        self.text:setString(luaCfg:get_local_string(10280))
    end
end

function UITipsPanel:checkTimeList(data)
    
    local contentTime = global.funcGame._toFormatTime(global.dataMgr:getServerTime()) --1483528378
    local preCutDay = -1
    local count = 0

    local worldPanel = global.g_worldview.worldPanel
    local chooseCityId = worldPanel.chooseCityId
    local mainCityId = worldPanel.mainId
    local userName = worldPanel.chooseCityName
    local isOwn = false

    if chooseCityId == mainCityId then

        userName = luaCfg:get_local_string(10265)  --"你"    
        isOwn = true
    end


    for i,v in ipairs(data) do
        
        count = count + 1
        if not v.isTitle then
        
            local time = global.funcGame._toFormatTime(v.lTime)
            local cutDay = contentTime.day - time.day

            if cutDay > preCutDay then
              
                count = 0

                preCutDay = cutDay

                local titleData = {}
                titleData.isTitle = true
                
                if cutDay == 0 then

                    titleData.tileStr = luaCfg:get_local_string(10267)
                elseif cutDay == 1 then

                    titleData.tileStr = luaCfg:get_local_string(10268)
                elseif cutDay == 2 then

                    titleData.tileStr = luaCfg:get_local_string(10269)
                else

                    local timeData = global.funcGame.formatTimeToTime(v.lTime)

                    titleData.tileStr = string.format(luaCfg:get_local_string(10270),timeData.month,timeData.day)
                end

                table.insert(data,i,titleData)

            end

            v.isShowBar = (count % 2) ~= 0
            v.userName = userName
            v.isOwn = isOwn
        end        
    end
end

function UITipsPanel:onEnter()
    
    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:checkTime() 
    end, 5)
end

function UITipsPanel:onExit()
    
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function UITipsPanel:checkTime()
    
    global.worldApi:queryTips(global.g_worldview.worldPanel.chooseCityId, 1, 0, function(msg)
       
        msg.tagStickers = msg.tagStickers or {}

        if self.data and self.data.tagStickers and msg.tagStickers and #msg.tagStickers > 0 then
    
            if #self.data.tagStickers == 0 then
                self:flushContent() 
            elseif msg.tagStickers[1] and self.data.tagStickers[1] and msg.tagStickers[1].lID ~= self.data.tagStickers[1].lID then
                self:flushContent() 
            end
        end    
    end)    
end

function UITipsPanel:flushContent() 
    
    global.worldApi:queryTips(global.g_worldview.worldPanel.chooseCityId, 50, 0, function(msg)
       
        self:setData(msg) 
    end)    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITipsPanel:onCloseHanler(sender, eventType)

    global.panelMgr:closePanelForBtn("UITipsPanel")
end

function UITipsPanel:delHandler(sender, eventType)

    local isOn = 0
    if self.data.lSwitch == 0 then isOn = 1 end

    global.worldApi:openTipsCloseTips(global.g_worldview.worldPanel.chooseCityId, isOn, function(msg)

        if isOn ~= 0 then

            global.tipsMgr:showWarning("Stickersopen")
        else

            global.tipsMgr:showWarning("StickersClose")
        end

       self:checkSwitch(isOn)
    end)    
end

function UITipsPanel:addTips(sender, eventType)

    if self.data.lSwitch == 1 then

        global.tipsMgr:showWarning("195")
        return
    end

    local panel = global.panelMgr:openPanel("UITipsWritePanel")
end
--CALLBACKS_FUNCS_END

return UITipsPanel

--endregion
