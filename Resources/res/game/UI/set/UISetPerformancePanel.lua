--region UISetPerformancePanel.lua
--Author : wuwx
--Date   : 2017/03/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetSwitch = require("game.UI.set.UISetSwitch")
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UISetPerformancePanel  = class("UISetPerformancePanel", function() return gdisplay.newWidget() end )

function UISetPerformancePanel:ctor()
    self:CreateUI()
end

function UISetPerformancePanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_performance")
    self:initUI(root)
end

function UISetPerformancePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_performance")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.music_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.music_switch, self.root.music_switch)
    self.FileNode_1 = UISetTIme.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.fps_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.fps_switch, self.root.fps_switch)
    self.close_building_effect = self.root.close_building_effect_mlan_8_export
    self.close_building_effect_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.close_building_effect_switch, self.root.close_building_effect_switch)
    self.remove_res_building = self.root.remove_res_building_mlan_8_export
    self.remove_res_building_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.remove_res_building_switch, self.root.remove_res_building_switch)
    self.close_fight_effect_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.close_fight_effect_switch, self.root.close_fight_effect_switch)
    self.picture_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.picture_switch, self.root.picture_switch)
    self.performance_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.performance_switch, self.root.performance_switch)

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.close_building_effect_switch:removeFromParent()
    self.close_building_effect:removeFromParent()
    self.remove_res_building_switch:removeFromParent()
    self.remove_res_building:removeFromParent()

    --开关内城环境特效
    local isOpen = cc.UserDefault:getInstance():getBoolForKey("setting_performance_env_effect",true)
    self.music_switch:setSelect(isOpen)

    self.music_switch:addEventListener(function(i_isOpen)
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData("NeedRestart", function()
            cc.UserDefault:getInstance():setBoolForKey("setting_performance_env_effect",i_isOpen)
            global.funcGame.RestartGame()
        end)
        panel:setPanelExitCallFun(function()
            self.music_switch:setSelect(not i_isOpen,nil,true)
        end)
    end)

    local isOpenFightEffect = cc.UserDefault:getInstance():getBoolForKey("isOpenFightEffect",true)
    self.close_fight_effect_switch:setSelect(isOpenFightEffect)

    self.close_fight_effect_switch:addEventListener(function(i_isOpen)
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData("NeedRestart", function()
            cc.UserDefault:getInstance():setBoolForKey("isOpenFightEffect",i_isOpen)
            global.funcGame.RestartGame()
        end)
        panel:setPanelExitCallFun(function()
            self.close_fight_effect_switch:setSelect(not i_isOpen,nil,true)
        end)
    end)


    --切换fps30和fps60--》省电模式
    local isOpen = cc.UserDefault:getInstance():getBoolForKey("setting_fps",false)
    self.fps_switch:setSelect(isOpen)

    self.fps_switch:addEventListener(function(i_isOpen)

        cc.UserDefault:getInstance():setBoolForKey("setting_fps",i_isOpen)
        if i_isOpen then
            cc.Director:getInstance():setAnimationInterval(1/30)
        else
            cc.Director:getInstance():setAnimationInterval(1/60)
        end
    end)

    local isLowQuality = cc.UserDefault:getInstance():getBoolForKey("isLowQuality",false)
    self.picture_switch:setSelect(not isLowQuality)
    self.picture_switch:setCloseOpenLan(10730, 10729);

    self.picture_switch:addEventListener(function(i_isOpen)
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData("NeedRestart", function()
            cc.UserDefault:getInstance():setBoolForKey("isLowQuality",not i_isOpen)
            global.funcGame.RestartGame()
        end)
        panel:setPanelExitCallFun(function()
            self.picture_switch:setSelect(not i_isOpen,nil,true)
        end)
    end)

    local islowFpsPhone = cc.UserDefault:getInstance():getBoolForKey("islowFpsPhone",false)
    self.performance_switch:setSelect(not islowFpsPhone)
    self.performance_switch:setCloseOpenLan(10730, 10729);

    self.performance_switch:addEventListener(function(i_isOpen)
        local panel = global.panelMgr:openPanel("UIPromptPanel")                
        panel:setData("NeedRestart", function()
            cc.UserDefault:getInstance():setBoolForKey("islowFpsPhone",not i_isOpen)
            global.funcGame.RestartGame()
        end)
        panel:setPanelExitCallFun(function()
            self.performance_switch:setSelect(not i_isOpen,nil,true)
        end)
    end)

    -- --开关内城建筑特效
    -- local isOpen = cc.UserDefault:getInstance():getBoolForKey("setting_close_building_effect",true)
    -- self.close_building_effect_switch:setSelect(isOpen)
    -- self.close_building_effect_switch:addEventListener(function(i_isOpen)
    --     local panel = global.panelMgr:openPanel("UIPromptPanel")                
    --     panel:setData("NeedRestart", function()
    --         cc.UserDefault:getInstance():setBoolForKey("setting_close_building_effect",i_isOpen)
    --         global.funcGame.RestartGame()
    --     end)
    --     panel:setCancelCall(function()
    --         self.close_building_effect_switch:setSelect(not i_isOpen,nil,true)
    --     end)
    -- end)

    -- --开关内城资源建筑特效
    -- local isOpen = cc.UserDefault:getInstance():getBoolForKey("setting_remove_res_building_effect",true)
    -- self.remove_res_building_switch:setSelect(isOpen)
    -- self.remove_res_building_switch:addEventListener(function(i_isOpen)
    --     -- global.tipsMgr:showWarning("FuncNotFinish")
    --     local panel = global.panelMgr:openPanel("UIPromptPanel")                
    --     panel:setData("NeedRestart", function()
    --         cc.UserDefault:getInstance():setBoolForKey("setting_remove_res_building_effect",i_isOpen)
    --         global.funcGame.RestartGame()
    --     end)
    --     panel:setCancelCall(function()
    --         self.remove_res_building_switch:setSelect(not i_isOpen,nil,true)
    --     end)
    -- end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UISetPerformancePanel:exit_call(sender,e)
    
    global.panelMgr:closePanelForBtn("UISetPerformancePanel")
end

--CALLBACKS_FUNCS_END

return UISetPerformancePanel

--endregion
