--- @classdef LogicPushPkg
local LogicPushPkg = {
    
}

local global = global

-- MLogout
function LogicPushPkg:MLogout(msg, head)
    log.debug("client logout:%s", msg.reason)
    local function onButtonClicked(event)
        global.funcGame.RestartGame()
    end
    local reason = global.luaCfg:get_local_string(10859)
    global.netRpc:KickOut()
    gdevice.showAlert(global.luaCfg:get_local_string(10860), reason, {"YES"}, onButtonClicked)
end

-- MError
function LogicPushPkg:MError(msg, head)
    local err = msg.errcode or HQCODE.ERR
    log.debug("!!!fatal error!!!:%s", err)
    --TODO
    local function onButtonClicked(event)
    end
    gdevice.showAlert("ERROR", "ERROR:" ..  err, {"YES"}, onButtonClicked)
    gscheduler.performWithDelayGlobal(function() global.netRpc:Close()  end, 0.1)
end

return LogicPushPkg

