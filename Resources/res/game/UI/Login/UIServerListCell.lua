local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userDat

local UIServerListCell  = class("UIServerListCell", function() return cc.TableViewCell:create() end )
local UIServerListItem = require("game.UI.Login.UIServerListItem")
local UILogin = require("game.UI.Login.UILogin")

function UIServerListCell:ctor()
    
    self:CreateUI()
end

function UIServerListCell:CreateUI()

    self.item = UIServerListItem.new() 
    self:addChild(self.item)
end

function UIServerListCell:onClick()

    if self.data.state == 0 then
        global.tipsMgr:showWarning("ServerClosed")
    else 
        local login = global.panelMgr:getPanel("UILogin")
        login:changeServerData(self.data)
        global.panelMgr:closePanelForBtn("UIServerList")
    end
end

function UIServerListCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIServerListCell:updateUI()
    self.item:setData(self.data)
end

return UIServerListCell