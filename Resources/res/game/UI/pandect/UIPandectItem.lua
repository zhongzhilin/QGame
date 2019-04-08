--region UIPandectItem.lua
--Author : yyt
--Date   : 2017/08/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPandectItem  = class("UIPandectItem", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIPandectInfo = require("game.UI.pandect.UIPandectInfo")
local UICityNode = require("game.UI.pandect.occupy.UICityNode")
local UIMiracleNode = require("game.UI.pandect.occupy.UIMiracleNode")
local UIWildNode = require("game.UI.pandect.occupy.UIWildNode")
local UIVillageNode = require("game.UI.pandect.occupy.UIVillageNode")
local UIEmptyNode = require("game.UI.pandect.occupy.UIEmptyNode")

function UIPandectItem:ctor()
    self:CreateUI()
end

function UIPandectItem:CreateUI()
    local root = resMgr:createWidget("common/pandect_node")
    self:initUI(root)
end

function UIPandectItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.cellBg = self.root.Node_1.cellBg_export
    self.titleNode = self.root.Node_1.titleNode_export
    self.title = self.root.Node_1.titleNode_export.title_export
    self.itemNode = self.root.itemNode_export
    self.cellSize1 = self.root.cellSize1_export
    self.cellSize2 = self.root.cellSize2_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPandectItem:setData(data)
    self.data = data
    local itemH = self.cellSize2:getContentSize().height
    if data.cType == 0 then
        itemH = self.cellSize1:getContentSize().height
    end
    local bgH = data.cellH - 60
    self.titleNode:setPositionY(bgH)
    self.cellBg:setPositionY(bgH-self.cellBg:getContentSize().height)

    local notEmptyNum, totalNum = 0, #data.cdata
    self.itemNode:removeAllChildren()
    for i=1,totalNum  do
  
        local item = nil
        if data.cdata[i].isEmptyItem then
            item = UIEmptyNode.new()
        else
            notEmptyNum = notEmptyNum + 1
            if data.cType == 0 then
                item = UIPandectInfo.new()
            elseif data.cType == 1 then
                item = UIWildNode.new()            
            elseif data.cType == 2 then
                item = UIVillageNode.new()
            elseif data.cType == 3 then
                item = UICityNode.new()
            elseif data.cType == 4 then
                item = UIMiracleNode.new()
            end
        end
        item:setPosition(0, (#data.cdata-i)*itemH)
        item:setData(data.cdata[i])
        self.itemNode:addChild(item)
    end

    if data.cType == 0 then
        self.title:setString(data.cdata[1].kindName)
    elseif data.cType == 1 then
        self.title:setString(luaCfg:get_local_string(10822, notEmptyNum, totalNum))
    elseif data.cType == 2 then
        self.title:setString(luaCfg:get_local_string(10801, notEmptyNum, totalNum))
    elseif data.cType == 3 then
        self.title:setString(luaCfg:get_local_string(10802, notEmptyNum, totalNum))
    elseif data.cType == 4 then
        self.title:setString(luaCfg:get_local_string(10803))
    end

end

--CALLBACKS_FUNCS_END

return UIPandectItem

--endregion
