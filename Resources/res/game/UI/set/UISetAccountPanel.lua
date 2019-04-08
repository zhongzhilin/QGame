--region UISetAccountPanel.lua
--Author : yyt
--Date   : 2017/04/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
local UISetAccountNode = require("game.UI.set.UISetAccountNode")
--REQUIRE_CLASS_END

local UISetAccountPanel  = class("UISetAccountPanel", function() return gdisplay.newWidget() end )

function UISetAccountPanel:ctor()
    self:CreateUI()
end

function UISetAccountPanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_account")
    self:initUI(root)
end

function UISetAccountPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_account")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.TimeNode = UISetTIme.new()
    uiMgr:configNestClass(self.TimeNode, self.root.TimeNode)
    self.accNode1 = self.root.accNode1_export
    self.accNode2 = self.root.accNode2_export
    self.userInfo = self.root.userInfo_export
    self.userInfo = UISetAccountNode.new()
    uiMgr:configNestClass(self.userInfo, self.root.userInfo_export)
    self.suggest = self.root.suggest_mlan_18_export

    uiMgr:addWidgetTouchHandler(self.root.changeAccountBtn, function(sender, eventType) self:changeAccount(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.newGameBtn, function(sender, eventType) self:newGame(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.blindBtn, function(sender, eventType) self:bindAccount(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGI
function UISetAccountPanel:onEnter()
    self:setData()
end

function UISetAccountPanel:setData()

   self.userInfo:setData()

   local list = global.loginData:getAccountList()
   self.list = list

   local isBinding = 0
   for i=1,2 do
        if list[i] then
            self["accNode"..i].Node.channelName:setString(list[i].account_name)
            if list[i].switch == 1 then
                -- 未綁定
                self["accNode"..i].Node.state:setString(luaCfg:get_local_string(10495))
            else
                -- 已綁定
                local id, name = global.sdkBridge:getChannelInfo(list[i].id)
                if id ~= "" then
                    self["accNode"..i].Node.state:setString(name)
                else
                    self["accNode"..i].Node.state:setString(luaCfg:get_local_string(10500))
                end
                isBinding = 1
            end
        end
   end
   self.isBinding = isBinding
   self.suggest:setVisible(isBinding == 0)

end

function UISetAccountPanel:changeAccount(sender, eventType)
    
    global.panelMgr:openPanel("UIChangeAccountPanel"):setData(self.list, true)
end

function UISetAccountPanel:newGame(sender, eventType)

    local resetCall = function ()
           
        global.sdkBridge:startNewGame(function() 

            global.sdkBridge:deleteChannelInfo()
            global.sdkBridge:setLoginBind(false)
            global.funcGame.RestartGame()   
            gumengSdk.profileSignOff()
        end)
        
    end
    
    -- 如果当前已经绑定账号
    if self.isBinding > 0 then 
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData(10492, function()
            resetCall()
        end)
    else
        self:confirmFunc(10491, 10490, function ()
            resetCall()
        end)
    end

end

function UISetAccountPanel:confirmFunc(errcode1, errcode2, callBack)

    local confirm = function ()
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData(errcode2, function()
            callBack()
        end)
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")                
    panel:setData(errcode1, function()
        confirm()
    end)

end

function UISetAccountPanel:bindAccount(sender, eventType)

   global.panelMgr:openPanel("UIChangeAccountPanel"):setData(self.list)
end

function UISetAccountPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UISetAccountPanel")  
end
--CALLBACKS_FUNCS_END

return UISetAccountPanel

--endregion
