--region UIRechargeList.lua
--Author : anlitop
--Date   : 2017/11/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRechargeList  = class("UIRechargeList", function() return gdisplay.newWidget() end )

local UIRechargeListCell = require("game.UI.recharge.UIRechargeListCell")
local UITableView = require("game.UI.common.UITableView")
local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")

function UIRechargeList:ctor()
    
end

function UIRechargeList:CreateUI()
    local root = resMgr:createWidget("recharge/recharge_list")
    self:initUI(root)
end

function UIRechargeList:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "recharge/recharge_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tb_add_node = self.root.tb_add_node_export
    self.tb_item_content = self.root.tb_item_content_export
    self.tb_content = self.root.tb_content_export
    self.mojing = self.root.mojing_export
    self.btn_rmb = self.root.mojing_export.btn_rmb_export
    self.rmb_num = self.root.mojing_export.btn_rmb_export.rmb_num_export

--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tb_content:getContentSize())
        :setCellSize(self.tb_item_content:getContentSize())
        :setCellTemplate(UIRechargeListCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.tb_add_node:addChild(self.tableView)


    self.tableView:registerScriptHandler(function () 

        if self.init_end  then 
             global.UIRechargeListOffset =  self.tableView:getContentOffset()
        end 

    end , cc.SCROLLVIEW_SCRIPT_SCROLL)

    self.ResSetControl = ResSetControl.new(self.root,self)

    self.mojing.btn_rmb_export:setEnabled(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
local panel = global.EasyDev.RECHARGE_PANEL

function UIRechargeList:onEnter()
    
    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    local nodeTimeLine = resMgr:createTimeline("recharge/recharge_list")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self.init_end  = false 

    local call = function (station) 
        local data = {}
        for _ ,v in pairs(global.luaCfg:recharge_list()) do 
            table.insert(data , v)  
        end 

        table.sort(data, function (A , B) return A.sort < B.sort end)

        self.tableView:setData(data , station)
    end 

    -- global.netRpc:delHeartCall(self)
    -- global.netRpc:addHeartCall( function () 
    --     local iscan , time = global.heroData:isCanBuy()
    --     if math.floor(time) ==  0 then 
    --         call(true)
    --     end
    -- end,self)
    
    call()

    if global.UIRechargeListOffset then 

        if global.UIRechargeListOffset.x > 0 then 

            self.tableView:setContentOffset(cc.p(global.UIRechargeListOffset.x, global.UIRechargeListOffset.y))

            -- global.uiMgr:addSceneModel(0.5)

            self.tableView:setContentOffsetInDuration(cc.p(0,global.UIRechargeListOffset.y), 0.3)

        elseif  global.UIRechargeListOffset.x < self.tableView:minContainerOffset().x then 

            self.tableView:setContentOffset(cc.p(global.UIRechargeListOffset.x, global.UIRechargeListOffset.y))

            self.tableView:setContentOffsetInDuration(cc.p(self.tableView:minContainerOffset().x ,global.UIRechargeListOffset.y), 0.3)
        else 
            self.tableView:setContentOffset(cc.p(global.UIRechargeListOffset.x, global.UIRechargeListOffset.y))
        end 
    else
        self:gps()
    end 

    self.init_end  = true
end 

function UIRechargeList:gps()

    local index = table.keyOfItem(global.EasyDev.RECHARGE_PANEL , global.panelMgr:getTopPanelName())

    if index then 
        self.tableView:jumpToCellByIdx(index -1 , true)    
    end 

     global.UIRechargeListOffset =  self.tableView:getContentOffset()
end 


function UIRechargeList:onExit()
    -- global.netRpc:delHeartCall(self)
end 


--CALLBACKS_FUNCS_END



return UIRechargeList

--endregion
