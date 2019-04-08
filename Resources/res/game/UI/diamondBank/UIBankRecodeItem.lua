--region UIBankRecodeItem.lua
--Author : yyt
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBankRecodeItem  = class("UIBankRecodeItem", function() return gdisplay.newWidget() end )

function UIBankRecodeItem:ctor()
    self:CreateUI()
end

function UIBankRecodeItem:CreateUI()
    local root = resMgr:createWidget("diamond_bank/diamond_record_node")
    self:initUI(root)
end

function UIBankRecodeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "diamond_bank/diamond_record_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.get_time = self.root.get_time_export
    self.final_num = self.root.final_num_export
    self.now_num = self.root.now_num_export
    self.rate = self.root.rate_export
    self.time = self.root.time_export
    self.get_dia_btn = self.root.get_dia_btn_export

    uiMgr:addWidgetTouchHandler(self.get_dia_btn, function(sender, eventType) self:getHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIBankRecodeItem:setData(data)

    self.data = data
    local bankConfig = global.luaCfg:get_diamond_bank_by(data.lType)
    self.bankConfig = bankConfig
    if not bankConfig then return end
    self.time:setString(global.luaCfg:get_local_string(10772, bankConfig.day))
    self.rate:setString(data.lRate .. "%")
    self.now_num:setString(data.lValue)
    self.final_num:setString(math.floor(data.lValue*(1+data.lRate/100)))
    self:refersh()
end

function UIBankRecodeItem:refersh()
    self.get_dia_btn:setVisible(false)
    self.get_time:setVisible(false)
    if self.data.lEndTime < global.dataMgr:getServerTime() then
        self.get_dia_btn:setVisible(true)
    else
        self.get_time:setVisible(true)
        self:cutTime()
    end
end

function UIBankRecodeItem:cutTime()

    self.lEndTime = self.data.lEndTime
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIBankRecodeItem:countDownHandler(dt)
    if not self.lEndTime then return end
    if self.lEndTime <= 0 then
        self.get_time:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lEndTime - curr
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        self:refersh()
        return
    end

    local dayNum = math.floor(rest/(24*3600))
    local str = ""
    if dayNum > 0 then
        str = string.format(global.luaCfg:get_local_string(10675),dayNum ,global.funcGame.formatTimeToHMS(rest-dayNum*24*3600)) 
    else
        str = global.funcGame.formatTimeToHMS(rest)
    end
    self.get_time:setString(str)
end

function UIBankRecodeItem:getHandler(sender, eventType)
    
    global.itemApi:bankAction(function (msg)
        -- body
        global.tipsMgr:showWarning("GetdiamondBank")
        gevent:call(global.gameEvent.EV_ON_BANK_RECODE)
        
    end, 1, self.bankConfig.type, 2, 0, self.data.lID)
end

function UIBankRecodeItem:onExit()
    
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end
--CALLBACKS_FUNCS_END

return UIBankRecodeItem

--endregion
