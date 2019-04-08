--region UIBattleBoss.lua
--Author : yyt
--Date   : 2018/01/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBattleBoss  = class("UIBattleBoss", function() return gdisplay.newWidget() end )

function UIBattleBoss:ctor()
    self:CreateUI()
end

function UIBattleBoss:CreateUI()
    local root = resMgr:createWidget("mail/mail_world_boss")
    self:initUI(root)
end

function UIBattleBoss:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_world_boss")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.text1 = self.root.text1_export
    self.name = self.root.name_export
    self.troopScrollView = self.root.troopScrollView_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBattleBoss:setData(data)
    -- body
    local battlePanel = global.panelMgr:getPanel("UIMailBattlePanel")
    local fightData = battlePanel.data.tgFightReport
    if fightData then
        local bossId = tonumber(fightData.szDefName)
        local bossConfig = global.luaCfg:get_worldboss_by(bossId)
        self.name:setString(bossConfig.name)
        global.panelMgr:setTextureFor(self.icon, bossConfig.mailicon)
        uiMgr:setRichText(self, "text1", 50295, {hp=data.tgSoldiers[1].lKilled})
    end 
end

--CALLBACKS_FUNCS_END

return UIBattleBoss

--endregion
