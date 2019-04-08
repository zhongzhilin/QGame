local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UISelectSkinlItemCell  = class("UISelectSkinlItemCell", function() return cc.TableViewCell:create() end )
local UISelectSkinlItem = require("game.UI.world.skin.UISelectSkinlItem")

function UISelectSkinlItemCell:ctor()
    self:CreateUI()
end

function UISelectSkinlItemCell:CreateUI()

    self.item = UISelectSkinlItem.new() 
    self:addChild(self.item)
end

function UISelectSkinlItemCell:onClick()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_List")
	 global.userCastleSkinData:setClickSkinNoUpdateUI(self.data.id)
	 gevent:call(global.gameEvent.EV_ON_CASTLE_SKILL_CLICK,self.data.id)
end

function UISelectSkinlItemCell:setData(data)
    self.data = data
    self:updateUI()
end

function UISelectSkinlItemCell:updateUI()
    self.item:setData(self.data)
end

return UISelectSkinlItemCell