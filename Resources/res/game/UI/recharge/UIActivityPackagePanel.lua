--region UIActivityPackagePanel.lua
--Author : anlitop
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIRechargeList = require("game.UI.recharge.UIRechargeList")
--REQUIRE_CLASS_END

local UIActivityPackagePanel  = class("UIActivityPackagePanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIActivityPackageItemCell = require("game.UI.recharge.UIActivityPackageItemCell")

function UIActivityPackagePanel:ctor()
    self:CreateUI()
end

function UIActivityPackagePanel:CreateUI()
    local root = resMgr:createWidget("recharge/activity_package")
    self:initUI(root)
end

function UIActivityPackagePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/activity_package")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title_node = self.root.title_node_export
    self.FileNode_2 = UIRechargeList.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.FileNode_2)
    self.no = self.root.no_mlan_10_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.table_node = self.root.table_node_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType)  

        global.panelMgr:closePanel("UIActivityPackagePanel")

    end)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.FileNode_2)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIActivityPackageItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
    
function UIActivityPackagePanel:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_UI_ADUPDATE, function ()
        self.old = true 
        self:setData()
        self.old = false  
    end)

    self:setData()
end 


function UIActivityPackagePanel:setData()


    self.no:setVisible(not global.advertisementData:isHaveAvailableAD())

    local temp = {} 
    local  checkContain = function (ad)
        for _, v in pairs(temp) do 
            if v.id == ad.id then 
                return false 
            end 
        end
        return true  
    end
    for _ ,v  in pairs(global.advertisementData:getAllAD()) do 
        if v.isvalid then 
            for _ , vv in ipairs(v.data) do
                if checkContain(vv) then 
                    table.insert(temp ,vv)
                end 
            end 
        end 
    end
    
    table.sort(temp ,function(A ,B) return A.range < B.range end )


    self.tableView:setData(temp)
end 




--CALLBACKS_FUNCS_END

return UIActivityPackagePanel

--endregion
