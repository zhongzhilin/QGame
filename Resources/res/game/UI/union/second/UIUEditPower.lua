--region UIUEditPower.lua
--Author : wuwx
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUEditPower  = class("UIUEditPower", function() return gdisplay.newWidget() end )

function UIUEditPower:ctor()
    self:CreateUI()
end

function UIUEditPower:CreateUI()
    local root = resMgr:createWidget("union/union_power_bj")
    self:initUI(root)
end

function UIUEditPower:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_power_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.bg = self.root.bg_export
    self.itemLayout = self.root.itemLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.node_tableView = self.root.node_tableView_export
    self.text_btnshow = self.root.btn.text_btnshow_mlan_5_export

    uiMgr:addWidgetTouchHandler(self.root.btn, function(sender, eventType) self:onSave(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UITableView = require("game.UI.common.UITableView")
    local UIUEditPowerCell = require("game.UI.union.list.UIUEditPowerCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUEditPowerCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    -- local height = self.line_top:getPositionY() - self.line_panel:getPositionY()
    -- self.line_panel:setContentSize(cc.size(self.contentLayout:getContentSize().width,height))

    self:adapt()
end


function UIUEditPower:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 


function UIUEditPower:onEnter()
    self:addEventListener(global.gameEvent.EV_ON_REFRESH_UNION_POWER, function(event)
        self:setData(true)
    end)

    self.m_model = 0
    self:setData()
end

local unionData = global.unionData
local dData = clone(global.luaCfg:union_power())
function UIUEditPower:setData(isRefresh)
    if not isRefresh then
        local data = {}
        for k,v in pairs(dData) do
            local sData = unionData:getPowerBy(v.id)
            local tData = v
            tData.sData = sData or {}

            if v.array == 0 then
                --认为不需要显示
            else
                table.insert(data,tData)
            end
        end
        table.sort(data,function(t1,t2)
            -- body
            return t1.array<t2.array
        end)
        self.tableView:setData(data)
        self.data = data
    else
        self.tableView:setData(self.data,true)
    end

    if self:isEditModel() then
        self.text_btnshow:setString(global.luaCfg:get_local_string(10395))
    else
        self.text_btnshow:setString(global.luaCfg:get_local_string(10394))
    end
end

function UIUEditPower:onExit()
    if self:isEditModel() then
        --如果在编辑模式退出返回备份数据
        unionData:resetPower(self.bakeData)
    end
end


function UIUEditPower:exit_call()
    global.panelMgr:closePanelForBtn("UIUEditPower")
end

--0：正常模式，1：编辑模式
function UIUEditPower:setModel(model)
    self.m_model = model
end

function UIUEditPower:isEditModel()
    return self.m_model == 1
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUEditPower:onSave(sender, eventType)
    if not global.unionData:isLeader() then
        return global.tipsMgr:showWarning("UnionPower01")
    end
    if not self:isEditModel() then
        print("############-->正常模式")
        self.bakeData = clone(unionData:getPower())
        self:setModel(1)
        self:setData(true)
    else
        print("############-->编辑模式")
        --编辑模式--》》保存
        
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setCancelCall(function()
            -- 取消回掉
            unionData:resetPower(self.bakeData)
            self:setModel(0)
            self:setData(true)
        end)
        panel:setData("Unionpower04", function()
            self:setModel(0)
            global.unionApi:setAllyRight(function()
                -- body
                global.tipsMgr:showWarning("Unionpower02")
            end,unionData:getPower())
        end)
    end
end
--CALLBACKS_FUNCS_END

return UIUEditPower

--endregion
