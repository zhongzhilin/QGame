--region UIEquipPanel.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local equipData = global.equipData
local gameEvent = global.gameEvent
local UIEquipTableView = require("game.UI.equip.UIEquipTableView")
local UIEquipItemCell = require("game.UI.equip.UIEquipItemCell")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipPanel  = class("UIEquipPanel", function() return gdisplay.newWidget() end )

function UIEquipPanel:ctor()

    self:CreateUI()
end

function UIEquipPanel:CreateUI()
    local root = resMgr:createWidget("equip/equipBj")
    self:initUI(root)
end

function UIEquipPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equipBj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.itsize = self.root.itsize_export
    self.tbsize = self.root.tbsize_export
    self.tbview_node = self.root.tbview_node_export
    self.title = self.root.title_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UIEquipTableView.new(1009)
        :setSize(self.tbsize:getContentSize(),self.top)
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIEquipItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)    

    self.tbview_node:addChild(self.tableView)    
end

function UIEquipPanel:flushInfoPanel()
    
    self.tableView:flush()
end

function UIEquipPanel:onExit()
    
    self.tableView:out()
    global.equipData:signMaxID()
end


function UIEquipPanel:reloadData()

    local tbdata = nil
    if self.rawCall then

        tbdata = self.rawCall()
    else
    
        tbdata = equipData:getFreeEquipsByIndex(self.index,self.heroId)
    end
    
    self.tableView.contentHeroId = self.heroId
    
    if self.filterCall then self.filterCall(tbdata) end

    self.tableView:setData(tbdata)
end

function UIEquipPanel:setData(index,heroId)
    
    self.index = index
    self.heroId = heroId
    self.rawCall = nil

    self:reloadData()
    self:addEventListener(gameEvent.EV_ON_UI_EQUIP_FLUSH,function()
        
        self:reloadData()    
    end)

    self.tableView.equipInfoData = nil
    self.filterCall = nil    

    return self
end

function UIEquipPanel:setDataRaw(rawCall)
    
    self.rawCall = rawCall

    self:reloadData()
    self:addEventListener(gameEvent.EV_ON_UI_EQUIP_FLUSH,function()
        
        self:reloadData()    
    end)

    self.tableView.equipInfoData = nil
    self.filterCall = nil
    self.index = -1
    self.heroId = -1

    return self
end

function UIEquipPanel:setFilterCall(filterCall)
    self.filterCall = filterCall
    self:reloadData()
end

function UIEquipPanel:setEquipInfo(isShowButton,str,isSinglePanel,callback)
    
    self.tableView.equipInfoData = {

        isShowButton = isShowButton,
        buttonStr = str,
        callback = callback,
        isSinglePanel = isSinglePanel,
    }

    return self
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIEquipPanel:exit_call(sender, eventType)

    global.panelMgr:closePanelForBtn("UIEquipPanel")
end

--CALLBACKS_FUNCS_END

return UIEquipPanel

--endregion
