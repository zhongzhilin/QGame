--region BuildListCell.lua
--Author : wuwx
--Date   : 2016/07/29
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local panelMgr = global.panelMgr

local BuildListCell  = class("BuildListCell", function() return cc.TableViewCell:create() end )
local BuildListItem = require("game.UI.city.widget.BuildListItem")

function BuildListCell:ctor()
    self:CreateUI()
end

function BuildListCell:CreateUI()
    self.item = BuildListItem.new()    
    self.item:CreateUI()
    self:addChild(self.item)
end

function BuildListCell:onClick()
    if self.data.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
        self:build()
    elseif self.data.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.UNOPEN then
        self:build()
    elseif self.data.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED then
    end
end

function BuildListCell:setData(data)
    self.listData = data
    self.data = global.cityData:getBuildByType(data.id)
    self:updateUI()
end

function BuildListCell:updateUI()
    self.item:setData(self.listData,self.data)
end

function BuildListCell:build()
    local cityView = global.g_cityView
    cityView:getOperateMgr():openBuildPanel(self.data)
end

function BuildListCell:getItem()
    return self.item
end


function BuildListCell:getData()
    return self.listData
end


return BuildListCell

--endregion