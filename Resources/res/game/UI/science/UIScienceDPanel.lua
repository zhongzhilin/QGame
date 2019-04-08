--region UIScienceDPanel.lua
--Author : yyt
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local techData = global.techData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIScienceDPanel  = class("UIScienceDPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIScienceDCell = require("game.UI.science.UIScienceDCell")

function UIScienceDPanel:ctor()
    self:CreateUI()
end

function UIScienceDPanel:CreateUI()
    local root = resMgr:createWidget("science/science_tree_bg")
    self:initUI(root)
end

function UIScienceDPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/science_tree_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.table_node = self.root.table_node_export
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_16_export
    self.topNode = self.root.topNode_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.bottomNode = self.root.bottomNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIScienceDCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)
    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)

end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIScienceDPanel:tableMove()
   
    self.isStartMove = true
end

function UIScienceDPanel:onEnter()   
    
    self.tableView:setData({})
    self.isStartMove = false
    self:addEventListener(global.gameEvent.EV_ON_UI_TECH_FLUSH, function()
        self:setData(self.lType, true)
    end)
    
end

function UIScienceDPanel:setData(lType, noRest)
    
    self.lType = lType

    if self.lType  then 

        self.panel_name:setString(luaCfg:get_local_string(10433+lType))
        local data = techData:setLineData(techData:getTechByType(lType), lType)

        if  global.techData:isFirstInit(lType) == 0 then
            data = global.techData:initEffectFlag(data, lType)
        end

        self.data = data
        self:setCondition(data, noRest)
    end 
    
end

function UIScienceDPanel:setCondition(data, noRest)
    
    local condit = {}
    for _,v in pairs(data) do
        table.insert(condit, v.edification)
    end

    local initCondit = function (dit, msg)
        msg = msg or {}
        for _,v in pairs(msg) do
            if v.lID == dit then
                return v
            end
        end
        return nil
    end

    -- 切入后台显示默认
    for _,v in pairs(data) do
        v.conditState = {}
        v.conditState.lMax = 1
        v.conditState.lCur = 0
    end 

    local dealCall = function (data)      
        if not tolua.isnull(self.tableView) then
            self.tableView:setData(data, noRest)
        end
        global.techData:refershEffectData(data, self.lType)
        global.techData:setFirstInit(self.lType)
    end

    global.techApi:conditSucc(condit, function (msg)
        for _,v in pairs(data) do
            v.conditState = initCondit(v.edification, msg.tgInfo) 
        end 
        dealCall(data)
    end)

end

function UIScienceDPanel:getTechById(techId)
    
    for _,v in pairs(self.data) do
        if v.id == techId then
            return v
        end
    end
end

function UIScienceDPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIScienceDPanel")  

    local scePanel = global.panelMgr:getPanel("UISciencePanel")
    scePanel:playAudio()
end

--CALLBACKS_FUNCS_END

return UIScienceDPanel

--endregion
