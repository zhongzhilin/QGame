--region UISetSoundPanel.lua
--Author : untory
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetSwitch = require("game.UI.set.UISetSwitch")
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UISetSoundPanel  = class("UISetSoundPanel", function() return gdisplay.newWidget() end )

function UISetSoundPanel:ctor()
    self:CreateUI()
end

function UISetSoundPanel:CreateUI()
    local root = resMgr:createWidget("settings/settings_sound")
    self:initUI(root)
end

function UISetSoundPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/settings_sound")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.music_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.music_switch, self.root.music_switch)
    self.sound_switch = UISetSwitch.new()
    uiMgr:configNestClass(self.sound_switch, self.root.sound_switch)
    self.FileNode_1 = UISetTIme.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.music_switch:addEventListener(function(isOpen)
        
        if isOpen then

            gsound.enableSounds()
        else

            gsound.disableSounds()
        end
    end)

    self.sound_switch:addEventListener(function(isOpen)
        
        if isOpen then

            gsound.enableEffects()
        else

            gsound.disableEffects()
        end
    end)

    self.music_switch:setSelect(gsound.isSoundOpen())
    self.sound_switch:setSelect(gsound.isEffectOpen())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISetSoundPanel:exit_call(sender,e)
    
    global.panelMgr:closePanelForBtn("UISetSoundPanel")
end

--CALLBACKS_FUNCS_END

return UISetSoundPanel

--endregion
