--region UILogin.lua
--Author : yyt
--Date   : 2016/08/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local loginData = global.loginData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UILogin  = class("UILogin", function() return gdisplay.newWidget() end )

function UILogin:ctor()
    self:CreateUI()
end

function UILogin:CreateUI()
    local root = resMgr:createWidget("login/login_1st")
    self:initUI(root)
end

function UILogin:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/login_1st")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.account_id = UIInputBox.new()
    uiMgr:configNestClass(self.account_id, self.root.account_id)
    self.server = self.root.server_export
    self.version_num = self.root.version_num_export
    self.active_tf = UIInputBox.new()
    uiMgr:configNestClass(self.active_tf, self.root.active_tf)

    uiMgr:addWidgetTouchHandler(self.root.server_btn, function(sender, eventType) self:changeServer(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.login_btn, function(sender, eventType) self:loginGame(sender, eventType) end)
--EXPORT_NODE_END

    self.tb_ServerList = global.ServerData:getSeverList()

    local nodeTimeLine = resMgr:createTimeline("login/login_1st")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

function UILogin:onEnter()
    
    local defaultAccount = cc.UserDefault:getInstance():getStringForKey("account")
    if defaultAccount ~= "" then
        self.account_id:setString(defaultAccount)
    end

    local defaultSelectSeverId = tonumber(cc.UserDefault:getInstance():getStringForKey("selectSever"))
    local svrData = global.ServerData:getServerDataBy(defaultSelectSeverId)
    if defaultSelectSeverId then
        loginData:setCurServerId(defaultSelectSeverId)
        self.server:setString(svrData.name)
    else
        self.server:setString(svrData.name)
    end

    self.version_num:setString(GLFGetAppVerStr())

    gsound.playBgm("loading_bg")
    gevent:call(gsound.EV_ON_PLAYSOUND,"loading_battle")


    print("#####---->"..string.utf8len("哇哦发aa哈哈3_"))

    -- self.account_id:setString("yq9")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UILogin:changeServerData(svrData)
    self.server:setString(svrData.name)
    cc.UserDefault:getInstance():setStringForKey("selectSever", svrData.id)-- 字符串  
    cc.UserDefault:getInstance():flush()
    loginData:setCurServerId(svrData.id)
end

function UILogin:changeServer(sender, eventType)
    local serverlListPanel = global.panelMgr:openPanel("UIServerList")
    serverlListPanel:setData(self.tb_ServerList)
end

function UILogin:onExit()
    gsound.stopEffect("loading_battle")
end

function UILogin:loginGame(sender, eventType)
    --激活码
    local i_code = self.active_tf:getString()
    if i_code == "" then
    else
        global.loginData:setActiveCode(i_code)
    end

    local  account_str = self.account_id:getString()
    
    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_login_1")
    -- local  account_str = "YT611"
    --YT611
    if  account_str ~= "" then
        cc.UserDefault:getInstance():setStringForKey("account", account_str)-- 字符串  
        cc.UserDefault:getInstance():flush()
        global.userData:setAccount(account_str)
        
        local loginProc = require "game.Login.LoginProc"
        loginProc.loginServerQuick()


    else           
        global.tipsMgr:showWarning("AccountEmpty")
    end
end
--CALLBACKS_FUNCS_END

return UILogin

--endregion
