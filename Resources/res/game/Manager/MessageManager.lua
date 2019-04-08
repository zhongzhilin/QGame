local MessageManager = {}

local luaCfg = global.luaCfg
local panelMgr = global.panelMgr

function MessageManager:showMessage(msgId, callBackCbs, ...)
    local messageCfg = luaCfg:get_message_by(msgId, ...)
    assert(messageCfg, string.format("not found msgid<%d>, msgId", msgId))
    
    local text = messageCfg.content
    local args = {...}
    local count = #args
    if count > 0 then
        text = string.format(text, ...)
    end

    local data = {}
    data.title = messageCfg.title
    data.content = text

    data.confirm = {}
    data.confirm.handler = callBackCbs.confirmHandler
    data.cancel = {}
    data.cancel.handler = callBackCbs.cancelHandler

    panelMgr:openPanel("UISystemMessagePanel"):setData(data)
end

function MessageManager:showCostItemMessage(i_data,callBackCbs)
    local data = {}
    data.title = nil
    data.content = nil
    --costRes = {id = 1001,num = 10}
    data.costRes = i_data.costRes
    --buyItems = {{id = 1001,num = 10}}
    data.buyItems = i_data.buyItems

    data.confirm = {}
    data.confirm.handler = callBackCbs.confirmHandler
    data.cancel = {}
    data.cancel.handler = callBackCbs.cancelHandler

    panelMgr:openPanel("UIMoneyToItemExchangeTips"):setData(data)
end


global.messageMgr = MessageManager