--region UISelectUnion.lua
--Author : yyt
--Date   : 2016/08/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UISelectUnion  = class("UISelectUnion", function() return gdisplay.newWidget() end )

function UISelectUnion:ctor()
    self:CreateUI()
end

function UISelectUnion:CreateUI()
    local root = resMgr:createWidget("login/race_one_2rd")
    self:initUI(root)
end

function UISelectUnion:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/race_one_2rd")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ScrollView = self.root.ScrollView_export
    self.racebtn1 = self.root.ScrollView_export.racebtn1_export
    self.Sprite_1 = self.root.ScrollView_export.racebtn1_export.Sprite_1_export
    self.Sprite_1_1 = self.root.ScrollView_export.racebtn1_export.Sprite_1_1_export
    self.racebtn2 = self.root.ScrollView_export.racebtn2_export
    self.Sprite_2 = self.root.ScrollView_export.racebtn2_export.Sprite_2_export
    self.Sprite_2_1 = self.root.ScrollView_export.racebtn2_export.Sprite_2_1_export
    self.racebtn3 = self.root.ScrollView_export.racebtn3_export
    self.Sprite_3 = self.root.ScrollView_export.racebtn3_export.Sprite_3_export
    self.Sprite_3_1 = self.root.ScrollView_export.racebtn3_export.Sprite_3_1_export
    self.racebtn4 = self.root.ScrollView_export.racebtn4_export
    self.Sprite_4 = self.root.ScrollView_export.racebtn4_export.Sprite_4_export
    self.Sprite_4_1 = self.root.ScrollView_export.racebtn4_export.Sprite_4_1_export
    self.racebtn5 = self.root.ScrollView_export.racebtn5_export
    self.Sprite_5 = self.root.ScrollView_export.racebtn5_export.Sprite_5_export
    self.Sprite_5_1 = self.root.ScrollView_export.racebtn5_export.Sprite_5_1_export
    self.racebtn6 = self.root.ScrollView_export.racebtn6_export
    self.Sprite_6 = self.root.ScrollView_export.racebtn6_export.Sprite_6_export
    self.Sprite_6_1 = self.root.ScrollView_export.racebtn6_export.Sprite_6_1_export
    self.racebtn7 = self.root.ScrollView_export.racebtn7_export
    self.Sprite_7 = self.root.ScrollView_export.racebtn7_export.Sprite_7_export
    self.Sprite_7_1 = self.root.ScrollView_export.racebtn7_export.Sprite_7_1_export
    self.racebtn8 = self.root.ScrollView_export.racebtn8_export
    self.Sprite_8 = self.root.ScrollView_export.racebtn8_export.Sprite_8_export
    self.Sprite_8_1 = self.root.ScrollView_export.racebtn8_export.Sprite_8_1_export
    self.racebtn9 = self.root.ScrollView_export.racebtn9_export
    self.Sprite_9 = self.root.ScrollView_export.racebtn9_export.Sprite_9_export
    self.Sprite_9_1 = self.root.ScrollView_export.racebtn9_export.Sprite_9_1_export
    self.race_atk = self.root.ScrollView_export.race_atk_export
    self.race_def = self.root.ScrollView_export.race_def_export
    self.race_res = self.root.ScrollView_export.race_res_export
    self.name = self.root.name_export
    self.name = UIInputBox.new()
    uiMgr:configNestClass(self.name, self.root.name_export)

    uiMgr:addWidgetTouchHandler(self.root.random_btn, function(sender, eventType) self:random_name(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.start_btn, function(sender, eventType) self:start_game(sender, eventType) end)
--EXPORT_NODE_END

    self.buttonSwitch = {}
    self.blackLayout = {}
    self.selected = {}

    local races = global.luaCfg:race()
    for i,v in ipairs(races) do
        self.buttonSwitch[i] = self["racebtn"..i]
        self.buttonSwitch[i]:setLocalZOrder(i)
        self.blackLayout[i] = self["Sprite_"..i]
        self.selected[i] = self["Sprite_"..i.."_1"]
        self.selected[i]:setVisible(false)
        uiMgr:addWidgetTouchHandler(self.buttonSwitch[i], function(sender, eventType) self:select_btn(sender, eventType) end)
        self.buttonSwitch[i]:setTag(1000+i)
        self.buttonSwitch[i]:setEnabled(v.state == 1)
        self.blackLayout[i]:setVisible(not (v.state == 1))

        self.race_atk:setLocalZOrder(1000+1)
        self.race_def:setLocalZOrder(1000+1)
        self.race_res:setLocalZOrder(1000+1)
    end

    self.ScrollView:setScrollBarEnabled(false)
end

function UISelectUnion:onEnter()
    
    self.m_raceId = 1
    self.selected[self.m_raceId]:setVisible(true)
    self:setRandName()
end

function UISelectUnion:setCallBack(callback)
    self.callback = callback
end

function UISelectUnion:setRandName()
    global.loginApi:getRandName(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            self.name:setString(msg.szRandName)
        end
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UISelectUnion:select_btn(sender, eventType)
    for k,v in pairs(self.buttonSwitch) do
        if v:getTag() == sender:getTag()  then
            -- v:setBrightStyle(1)
            self.selected[k]:setVisible(true)
            sender:setLocalZOrder(1000)
            self.m_raceId = k
        else
            -- v:setBrightStyle(0)
            self.selected[k]:setVisible(false)
            sender:setLocalZOrder(k)
        end
    end    
end

function UISelectUnion:random_name(sender, eventType)
    self:setRandName()
end

function UISelectUnion:start_game(sender, eventType)
    global.userData:setUserName(self.name:getString())

    global.loginApi:createRole(self.m_raceId, function(ret,msg)
        -- body
        global.panelMgr:closePanelForBtn("UISelectUnion")
        self.callback(msg)
    end)
end
--CALLBACKS_FUNCS_END

return UISelectUnion

--endregion
