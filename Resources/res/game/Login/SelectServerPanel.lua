local global = global
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent
local funcGame = global.funcGame
local pvpData = global.userData:GetPVPData()
local luaCfg = global.luaCfg

local LAST_ITEM_COUNT = 4

local ONE_ITEM_COUNT = 10

local tipMap = {
    [WPBCONST.EN_PLAT_DIR_ST_MAINTAIN]    = { text = global.luaCfg:get_local_string(10828), color = cc.c3b(134, 134, 134) },
    [WPBCONST.EN_PLAT_DIR_ST_NORMAL]     = { text = global.luaCfg:get_local_string(10829), color = cc.c3b(42, 224, 0) },
    [WPBCONST.EN_PLAT_DIR_ST_HOT]       = { text = global.luaCfg:get_local_string(10830), color = cc.c3b(224, 84, 0) },
}

local SelectServerBtnItem = require("game.Login.item.SelectServerBtnItem")
local SelectServerListItem = require("game.Login.item.SelectServerListItem")

local _M = {}
_M = class("SelectServerPanel", function() return gdisplay.newWidget() end )

function _M:ctor()

    self._widget = global.resMgr:createWidget("LoginSelectUI")
    self._widget:setSize(cc.size(gdisplay.size.width, gdisplay.size.height))    
    self:addChild(self._widget)    
    
    self.svrBtns = {}
    for i = 1, ONE_ITEM_COUNT do
        local svrBtnPos = ccui.Helper:seekWidgetByName(self._widget, "SeverBtnPos"..i)
        local btn = SelectServerBtnItem.new()
        btn:setTag(i)
        btn:setVisible(false)
        svrBtnPos:addChild(btn)
        self.svrBtns[i] = btn
    end

    self.svrList = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "AreaList"), "ListView")
    local function listViewEvent(sender, eventType)
        if eventType == ccs.ListViewEventType.LISTVIEW_ONSELECTEDITEM_START then
            log.debug("self.svrList select index %d", sender:getTag())
        end
    end
    self.svrList:addEventListenerListView(listViewEvent)

    self.lastSvrNode = ccui.Helper:seekWidgetByName(self._widget, "Panel_tuijian")
    self.lastSvrNode:setVisible(false)
    self.lastSvrNode:setTouchEnabled(false)
    self.lastSvrList = {}
    for i = 1, LAST_ITEM_COUNT do
        local item = ccui.Helper:seekWidgetByName(self.lastSvrNode, "Button_Server_" .. i)
        item:setVisible(false)
        item:setTouchEnabled(false)
        self.lastSvrList[i] = item
        item.svrNum = uiMgr:configLabel(item, "Label_qu_num")
        item.svrName = uiMgr:configLabel(item, "Label_qu_name")
        item.vipNum = uiMgr:configLabel(item, "Label_vip")
        item.userName = uiMgr:configLabel(item, "Label_playername")
        item.userLv = uiMgr:configLabel(item, "Label_level")
        item.vipNode = ccui.Helper:seekWidgetByName(item, "Image_vip")
    end

    self.backBtn = tolua.cast(ccui.Helper:seekWidgetByName(self._widget, "BackBtn"), "Button")
    self.backBtn:addTouchEventListener(ccs.TouchEventWrapper(function()
        if self.curSvr ~= nil then

            if self.callBack then
                self.callBack(self.curSvr, self.svrDatas)
            end
            
            global.scMgr:CurScene():GetWidget():setVisible(true)
            global.panelMgr:closePanel("SelectServerPanel")
        else
            global.tipsMgr:showWarning(global.luaCfg:get_local_string(10917))
        end
    end))

    self.selectSvrId = uiMgr:getLabel(self._widget, "SelectAreaId")
    self.selectSvrName = uiMgr:getLabel(self._widget, "SelectAreaName")
    self.selectSvrState = uiMgr:getLabel(self._widget, "SelectAreaState")

    self.selectListName = uiMgr:getLabel(self._widget, "SelectListName")
end

function _M:setData(svrDatas, curSvr)

    self.curSvr = curSvr
    self.curSvrData = nil
    self.selectItem = nil
    self.selectSvrBtn = nil
    self.svrDatas = svrDatas

    self.svrList:removeAllItems()

    local svrList = {}

    if svrDatas.zones and #svrDatas.zones > 0 then
        table.sort(svrDatas.zones, function(a, b)
            -- body
            return a.area < b.area
        end)
    end

    self.svrIdMap = {}

    for k, v in ipairs(svrDatas.zones or {}) do
        local data = funcGame.ConvertSvrData(v)
        svrList[#svrList + 1] = data

        self.svrIdMap[data.id] = data

        if self.curSvr and data.id == self.curSvr.id then
            self.curSvrData = data
        end
    end

    local i = 0
    local itemSvr = {}
    local allItem = {}
    local curSvrIndex = 1
    local curSvrBtnIndex = 1
    for k = 1, #svrList do
        if i >= ONE_ITEM_COUNT then
            table.insert(allItem, itemSvr)
            itemSvr = {}
            i = 0
        end
        i = i + 1
        local dd = svrList[k]
        itemSvr[i] = dd
        if curSvr and dd.id == curSvr.id then
            curSvrIndex = #allItem + 1
            curSvrBtnIndex = i
        end
    end

    if #itemSvr > 0 then
        table.insert(allItem, itemSvr)
    end

    curSvrIndex = #allItem - curSvrIndex + 1

    self.allSvrItem = {}
    for k = 1, #allItem do
        local temp = {}
        self.allSvrItem[#allItem - k + 1] = temp
        for j = 1, #allItem[k] do
            temp[#allItem[k] - j + 1] = allItem[k][j]
        end
    end

    self.allSvrListItem = {}

    local records = global.funcGame.GetLoginRecords()
    self.lastRecords = {}

    for k,v in pairs(records) do
        if self.svrIdMap[v.zoneid] then
            table.insert(self.lastRecords, v)
        end
    end
    
    local i = 0

    if #self.lastRecords > 0 then

        table.sort(self.lastRecords, function(a, b)
            return a.tmlogin > b.tmlogin
        end)

        local item = SelectServerListItem.new()
        self.svrList:pushBackCustomItem(item)
        item:setTag(i)
        item:setData({ index = i, title = luaCfg:get_local_string(10638), callBack = function(index)
            self:SelectIndex(index)
        end})
        self.allSvrListItem[i] = item
        item:UnSelect()
    end
    i = i + 1

    for k, v in ipairs(self.allSvrItem) do
        local item = SelectServerListItem.new()
        self.svrList:pushBackCustomItem(item)
        local startArea = v[#v]
        local endArea = v[1]
        local title = string.format(global.luaCfg:get_local_string(10918), startArea.area, endArea.area)
        item:setTag(i)
        item:setData({ index = i, title = title, callBack = function(index)
            self:SelectIndex(index)
        end})
        self.allSvrListItem[i] = item
        item:UnSelect()
        i = i + 1
    end

    for i = 1, LAST_ITEM_COUNT do
        self.lastSvrList[i]:setVisible(false)
        self.lastSvrList[i]:setTouchEnabled(false)
    end

    local records = global.funcGame.GetLoginRecords()
    if #records > 0 then
        curSvrIndex = 0
    end
    
    self:SelectIndex(curSvrIndex)
end

function _M:SelectIndex(index)
    if self.selectItem and self.selectItem:getTag() == index then
        return
    end

    if self.allSvrListItem[index] == nil then
        return
    end

    self:UnSelectItem()
    self:UnSelectSvr()

    self.selectItem = self.allSvrListItem[index]
    self.selectItem:Select()

    local svrs = self.allSvrItem[index] or {}
    for i = 1, ONE_ITEM_COUNT do
        self.svrBtns[i]:setVisible(i <= #svrs)
        self.svrBtns[i]:Disable()
        if i <= #svrs then
            local svrData = svrs[i]
            local data = {
                state = svrData.state,
                index = i,
                svrArea = svrData.area,
                svrId = svrData.id,
                svrName = svrData.name,
                tag = svrData.tag,
                callBack = function(btnIndex)
                    self:SelectSvr(btnIndex)
                    if self.callBack then
                        self.callBack(svrData, self.svrDatas)
                    end                   

                    gevent:call(global.gameEvent.EV_ON_TALKING_DATA_SELECT_SVR)
                    log.debug("===========> EV_ON_TALKING_DATA_SELECT_SVR")
                end,
            }
            self.svrBtns[i]:setData(data)
        end
    end

    if index == 0 then
        self.selectListName:setText(luaCfg:get_local_string(10638))
        self.lastSvrNode:setVisible(true)
        self.lastSvrNode:setTouchEnabled(true)

        local records = self.lastRecords

        -- records = {
        --     [1] = {
        --         charid = 522375397397002,
        --         level = 1,
        --         name = "",
        --         tmlogin = 1437656359,
        --         viplv = 0,
        --         zoneid = 7011,
        --     },
        -- },
        log.debug("===============> records %s", vardump(records))

        for i,v in ipairs(self.lastSvrList) do
            v:setVisible(i <= #records)
            v:setTouchEnabled(i <= #records)
            if i <= #records then
                recordData = records[i]
                recordData.viplv = recordData.viplv or 0
                local svrData = self.svrIdMap[recordData.zoneid]
                v.svrNum:setText(string.format("%s", svrData.area))
                v.svrName:setText(string.format("%s", svrData.name))
                v.vipNum:setText(string.format("%s", recordData.viplv or 0))
                v.vipNode:setVisible(recordData.viplv > 0)
                v.userName:setText(string.format("%s", recordData.name or ""))
                v.userLv:setText(string.format("%s", recordData.level or 1))
                v:addTouchEventListener(ccs.TouchEventWrapper(function()
                    -- body
                    if self.callBack then
                        self.callBack(svrData, self.svrDatas)
                    end

                    gevent:call(global.gameEvent.EV_ON_TALKING_DATA_SELECT_SVR)
                    log.debug("===========> EV_ON_TALKING_DATA_SELECT_SVR")
                end))
            end
        end
    else
        for i = 1, LAST_ITEM_COUNT do
            self.lastSvrList[i]:setVisible(false)
            self.lastSvrList[i]:setTouchEnabled(false)
        end
        local selectSvrs = self.allSvrItem[index]
        local itemName = string.format("%s - %s", selectSvrs[1].area, selectSvrs[#selectSvrs].area)
        self.selectListName:setText(itemName)
        self.lastSvrNode:setVisible(false)
        self.lastSvrNode:setTouchEnabled(false)
    end

    log.debug("===> btnSelectIndex %s", btnSelectIndex)
    if btnSelectIndex then
        self:SelectSvr(btnSelectIndex)
    end

    if self.curSvrData then
        self:SetLabelTextAndColor(self.selectSvrId, string.format(global.luaCfg:get_local_string(10919), self.curSvrData.area), tipMap[self.curSvrData.state].color)
        self:SetLabelTextAndColor(self.selectSvrName, self.curSvrData.name, tipMap[self.curSvrData.state].color)
        self:SetLabelTextAndColor(self.selectSvrState, tipMap[self.curSvrData.state].text, tipMap[self.curSvrData.state].color)
    else
        self.selectSvrId:setVisible(false)
        self.selectSvrName:setVisible(false)
        self.selectSvrState:setVisible(false)
    end
end

function _M:SelectSvr(index)
    if self.selectSvrBtn == self.svrBtns[index] then
        return
    end
    
    self:UnSelectSvr()

    self.selectSvrBtn = self.svrBtns[index]
    self.selectSvrBtn:Select()

end

function _M:SetLabelTextAndColor(label, text, color)
    -- body
    local render = tolua.cast(label:getVirtualRenderer(), "CCLabelTTF")
    render:setColor(color)
    label:setText(text)    
    label:setVisible(true)
end

function _M:UnSelectItem()
    if self.selectItem then
        self.selectItem:UnSelect()
        self.selectItem = nil
    end
end

function _M:UnSelectSvr()
    if self.selectSvrBtn then
        self.selectSvrBtn:UnSelect()
        self.selectSvrBtn = nil
    end
end

function _M:SetSelectCallBack(callBack)
    self.callBack = callBack
end

function _M:StartUpdateSvr()
    self:StopUpdateSvr()
    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        self:UpdateSvr()
    end, 10)
end

function _M:StopUpdateSvr()
    if self.scheduleListenerId then
        gscheduler.unscheduleGlobal(self.scheduleListenerId)
        self.scheduleListenerId = nil
    end
end

function _M:UpdateSvr()
    panelMgr:openPanel("ConnectingPanel")
    local callBack = function(ret, msg)
        -- body
        panelMgr:closePanel("ConnectingPanel")
        --log.debug("PlatCtrl.GetDir ret %s param %s", ret, vardump(msg or {}))
        if ret == HQCODE.OK and msg.pkg then
            msg = msg.pkg
            if msg.zones ~= nil and #msg.zones > 0 then
                for k, v in pairs(msg.zones) do
                    if self.curSvr ~= nil and v. id == self.curSvr.id then
                        self.curSvr = funcGame.ConvertSvrData(v)
                    end
                end
                self:setData(msg, self.curSvr)
            end
        end
    end

    global.gameReq:GetPlatInfo(callBack)
end

function _M:onEnter()
    self._widget:setVisible(true)
    self._widget:setTouchEnabled(true)
    if self.curSvrData and self.curSvrData.state == WPBCONST.EN_PLAT_DIR_ST_MAINTAIN then
        self:StartUpdateSvr()    
    end
    self:UpdateSvr()
end

function _M:onExit()
    self._widget:setVisible(false)
    self._widget:setTouchEnabled(false)
    self:StopUpdateSvr()
end

return _M