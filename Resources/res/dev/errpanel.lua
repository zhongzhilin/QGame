----------------------------------------------------------------------------------
-- LUA ERRO Panel
local ErrorPanel  = class("ErrorPanel", 
    function() return gdisplay.newColorLayer(cc.c4b(0, 0, 0, 255)) end)

ErrorPanel.inst = nil
ErrorPanel.cfg = {
    smain = {w = 860, h = 540},
    slabel = {w = 820, h = 500},
}

function ErrorPanel:ctor()
    self:setContentSize({ width = ErrorPanel.cfg.smain.w, height = ErrorPanel.cfg.smain.h })
    self:setTouchEnabled(true)
    
    local labelOutput = cc.Label:createWithTTF("", 
                                     "fonts/normal.ttf", 18,
                                     { width = ErrorPanel.cfg.slabel.w, height = ErrorPanel.cfg.slabel.h },
                                     cc.TEXT_ALIGNMENT_LEFT,
                                     cc.VERTICAL_TEXT_ALIGNMENT_TOP)

    labelOutput:setPosition(ErrorPanel.cfg.slabel.w/2 + 20, ErrorPanel.cfg.slabel.h/2-15)
    self:addChild(labelOutput)

    self.labelOut = labelOutput

    local function err_close(tag, sender)
        if ErrorPanel.inst ~= nil then
            ErrorPanel.inst:setVisible(false)
        end
    end

    local menu = cc.Menu:create()
    cc.MenuItemFont:setFontSize(25)
    cc.MenuItemFont:setFontName("Arial")
    local item = cc.MenuItemFont:create(global.luaCfg:get_local_string(10901))
    item:setColor(gdisplay.COLOR_RED)
    item:registerScriptTapHandler(err_close)
    menu:addChild(item)
    menu:setPosition((gdisplay.width-ErrorPanel.cfg.smain.w)/2 + ErrorPanel.cfg.smain.w/2 -100, 
                         (gdisplay.height - ErrorPanel.cfg.smain.h)/2 + ErrorPanel.cfg.smain.h - 70 )

    self:addChild(menu, 255)
end

function ErrorPanel:show()
    self:setVisible(true)
end

function GLFShowLuaError(txt)
    ErrorPanel.inst = ErrorPanel.new()
    global.scMgr:CurScene():addChild(ErrorPanel.inst, 999)
    ErrorPanel.inst.labelOut:setString(txt)
    ErrorPanel.inst:setPosition(cc.p((gdisplay.width - ErrorPanel.cfg.smain.w)/2, (gdisplay.height - ErrorPanel.cfg.smain.h)/2 ))
end

function GLFCreateDebugPanel(parent, visible)
    local serData = global.ServerData:getServerDataBy()
    if not serData then 
        serData = global.ServerData:getFirstSvrData()
    end

    if not serData or (serData.check and serData.check ~= "0") or (not serData.dop and _CPP_RELEASE == 1 and _DEBUG_SERVER ~= 999) then 
        return
    end
    local debugPanel = gDebugPanel
    --if gdevice.platform == "windows" or GLFGetChanID() ~= WPBCONST.EN_CHAN_MI then
    -- if debugPanel and (gdevice.platform == "windows" or (global.funcGame and global.funcGame.IsDebugUser()) ) then
    if debugPanel and debugPanel.createPanel then
        debugPanel.createPanel(parent, visible)
    end
    -- end
end