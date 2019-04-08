local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UITurntableFirItemCell  = class("UITurntableFirItemCell", function() return cc.TableViewCell:create() end )
local UITurntableFirItem = require("game.UI.turnable.UITurntableFirItem")

function UITurntableFirItemCell:ctor()
    self:CreateUI()
end

function UITurntableFirItemCell:CreateUI()

    self.item = UITurntableFirItem.new() 
    self:addChild(self.item)
end

local panel = {
	[1] =   "UITurntableFullPanel",  
	[2] =   "UITurntableHeroPanel", 
	[3] =   "UITurntableHalfPanel",
} 

function UITurntableFirItemCell:onClick()
    if self.data.id == 2 and not global.cityData:isBuildingExisted(15) then
        global.tipsMgr:showWarning("NewGuide02")
        return
    end

    if self.data.id == 2 then
        local targetId = luaCfg:get_turntable_hero_cfg_by(1).open_lv
        local isUnlock = global.funcGame:checkTarget(targetId)
        if not isUnlock then
            local triggerData = luaCfg:get_target_condition_by(targetId)
            global.tipsMgr:showWarning(luaCfg:get_local_string(11141,triggerData.condition))
            return
        end 
    end

	global.panelMgr:openPanel(panel[self.data.id])

end

function UITurntableFirItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UITurntableFirItemCell:updateUI()
    self.item:setData(self.data)
end

return UITurntableFirItemCell