--region UIChangeAccountPanel.lua
--Author : yyt
--Date   : 2017/04/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UIChangeAccountPanel  = class("UIChangeAccountPanel", function() return gdisplay.newWidget() end )

function UIChangeAccountPanel:ctor()
    self:CreateUI()
end

function UIChangeAccountPanel:CreateUI()
    local root = resMgr:createWidget("settings/account_2nd")
    self:initUI(root)
end

function UIChangeAccountPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/account_2nd")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_export
    self.TimeNode = UISetTIme.new()
    uiMgr:configNestClass(self.TimeNode, self.root.TimeNode)
    self.icon1 = self.root.facebookBtn.icon1_export
    self.name1 = self.root.facebookBtn.name1_export
    self.icon2 = self.root.googleBtn.icon2_export
    self.name2 = self.root.googleBtn.name2_export

    uiMgr:addWidgetTouchHandler(self.root.facebookBtn, function(sender, eventType) self:fbHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.googleBtn, function(sender, eventType) self:googleHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIChangeAccountPanel:setData(data, isChange)

    self.data = data
    self.isChange = isChange
    if isChange then
        self.panel_name:setString(luaCfg:get_local_string(10501))
        self:referNameState1(data)
    else
        self.panel_name:setString(luaCfg:get_local_string(10502))
        self:referNameState2(data)
    end

end

function UIChangeAccountPanel:referNameState1(data)
    -- body
    for i=1,2 do
        if data[i] then
            self["name"..i]:setString(data[i].account_name)
            self["icon"..i]:loadTexture(data[i].icon, ccui.TextureResType.plistType)
        end
    end
end

function UIChangeAccountPanel:referNameState2(data)

    for i=1,2 do
        if data[i] then
            local id = 0
            if data[i].switch == 1 then
                id = 10856
            else
                id = 10857                        
            end
            local str = luaCfg:get_local_string(id)
            self["name"..i]:setString(str .. data[i].account_name)
            self["icon"..i]:loadTexture(data[i].icon, ccui.TextureResType.plistType)
        end
   end

end

function UIChangeAccountPanel:exit_call(sender, eventType)

    global.panelMgr:getPanel("UISetAccountPanel"):setData()
    global.panelMgr:closePanelForBtn("UIChangeAccountPanel")  
end

function UIChangeAccountPanel:fbHandler(sender, eventType)

    global.sdkBridge:setChannel(1)
    
    local finishCall = function (state)

        global.loginData:updateBindState(1)
        
        if self.setData then 
            self:setData(global.loginData:getAccountList(), self.isChange)
        end 

        if state == 1 then
            global.tipsMgr:showWarning("remove_bind_success")
        else
            global.tipsMgr:showWarning("bind_success")
        end
        gumengSdk.profileSignOff()
    end

    if self.isChange then

        local changeAccountCall = function ()
            
            global.panelMgr:closePanel("UIPromptPanel", true)
            global.sdkBridge:changeAccount(function (msg)
                global.funcGame.RestartGame()
            end)
        end

        if self.data[1].switch == 1 and self.data[2].switch == 1  then
            self:confirmFunc(10489, 10490, function ()
                changeAccountCall()
            end)
        else
            changeAccountCall()
        end     

    else

        if self.data[1].switch == 1 then
            global.sdkBridge:login(finishCall)        -- fb绑定
        else
            local panel = global.panelMgr:openPanel("UIPromptPanel")                
            panel:setData(10554, function()
                uiMgr:addSceneModel(2)
                global.sdkBridge:loginOut(finishCall) -- fb解绑
            end)
        end

    end
end

function UIChangeAccountPanel:googleHandler(sender, eventType)

    -- global.tipsMgr:showWarning("FuncNotFinish")

    local chanId = self.data[2].id

    global.sdkBridge:setChannel(chanId)

    local finishCall = function (state)
        
        global.loginData:updateBindState(chanId)
        if self.setData then 
            self:setData(global.loginData:getAccountList(), self.isChange)
        end 

        if state == 1 then
            global.tipsMgr:showWarning("remove_bind_success")
        else
           global.tipsMgr:showWarning("bind_success")
        end
        gumengSdk.profileSignOff()
    end

    if self.isChange then

        local changeAccountCall = function ()
            
            global.panelMgr:closePanel("UIPromptPanel", true)
            global.sdkBridge:changeAccount(function (msg)
                global.funcGame.RestartGame()
            end)
        end

        if self.data[1].switch == 1 and self.data[2].switch == 1  then
            self:confirmFunc(10489, 10490, function ()
                changeAccountCall()
            end)
        else
            changeAccountCall()
        end     

    else

        if self.data[2].switch == 1 then
            global.sdkBridge:login(finishCall)    -- google／gamecenter绑定
        else
            local panel = global.panelMgr:openPanel("UIPromptPanel")                
            panel:setData(10554, function()
                uiMgr:addSceneModel(2)
                global.sdkBridge:loginOut(finishCall) -- google／gamecenter解绑
            end)
        end

    end

   
end


function UIChangeAccountPanel:confirmFunc(errcode1, errcode2, callBack)

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
--CALLBACKS_FUNCS_END

return UIChangeAccountPanel

--endregion
