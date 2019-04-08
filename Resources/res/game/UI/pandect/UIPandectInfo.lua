--region UIPandectInfo.lua
--Author : yyt
--Date   : 2017/08/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPandectInfo  = class("UIPandectInfo", function() return gdisplay.newWidget() end )

function UIPandectInfo:ctor()
    self:CreateUI()
end

function UIPandectInfo:CreateUI()
    local root = resMgr:createWidget("common/pandect_num_node")
    self:initUI(root)
end

function UIPandectInfo:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_num_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.info_btn = self.root.Node_4.Node_1.info_btn_export
    self.num = self.root.Node_4.num_export
    self.type = self.root.Node_4.type_export

    uiMgr:addWidgetTouchHandler(self.info_btn, function(sender, eventType) self:infoHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.info_btn:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPandectInfo:setData(data)
    
    self.data = data
    local val = data.serVal or 0
    if data.data_type > 0 then
        local dataType = global.luaCfg:get_data_type_by(data.data_type)
        self.num:setString(val .. dataType.extra)
    else
        if data.onlyId == 1203  then
            if val == 0 then
                self.num:setString(val .. "%")
            else
                self.num:setString(string.format("%0.2f", val) .. "%")
            end
        else
            self.num:setString(val)
        end
    end
    self.type:setString(data.dataName)
    self.info_btn:setVisible(data.tips == 1)

    self:refershInfoPanel()

end

function UIPandectInfo:refershInfoPanel()
    -- body
    if global.panelMgr:getTopPanelName() == "UIPandectInfoPanel" then
        local titleStr = self.type:getString() .. " " .. self.num:getString()
        local sourceData = self:getSourceData()

        local infoPanel = global.panelMgr:getPanel("UIPandectInfoPanel")
        local infoCata = infoPanel:getInfoData()
        if infoCata.data_type == self.data.data_type then
            infoPanel:setData(sourceData, {titleStr=titleStr, infoCata=self.data})
        end
    end
end

-- 种族特殊buff处理
function UIPandectInfo:checkRaceBuff(target, lFrom)

    if lFrom ~= 11 then return true end
    for k,v in pairs(target) do
        local race = math.floor(v/1000)
        if global.userData:getRace() == race then
            return true
        end
    end
    return false
end

function UIPandectInfo:getSourceData()
    -- body
    self.data.serBuffFrom = self.data.serBuffFrom or {}
    local getBuffVal = function (lFromId)
        for i,v in ipairs(self.data.serBuffFrom) do
            if v.lFrom == lFromId then
                return v.lValue
            end
        end
        return 0
    end

    local dataP = global.luaCfg:get_data_pandect_by(1101)
    local maxSourceNum = dataP.maxSource

    local data = {}
    for i=0,maxSourceNum do
        local curFrom = self.data["source"..i]
        local curTarget = self.data["source" .. i .. "target"]
        local baseFrom= self.data["source".. i .. "txt"]
        local baseCan = baseFrom and baseFrom ~= ""
        local curCan  = curFrom and curFrom == 1
        if (baseCan or curCan) and self:checkRaceBuff(curTarget, i) then
            local temp = {}
            temp.lFrom = i
            temp.lValue= getBuffVal(i)
            table.insert(data, temp)
        end
    end

    -- 叠乘方式备注
    if self.data.multiply == 1 then
        table.insert(data, {lFrom=999, lValue=0})
    end
    return data
end

function UIPandectInfo:infoHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPandectPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        local titleStr = self.type:getString() .. " " .. self.num:getString()
        local sourceData = self:getSourceData()
        global.panelMgr:openPanel("UIPandectInfoPanel"):setData(sourceData, {titleStr=titleStr, infoCata=self.data})
    end

end
--CALLBACKS_FUNCS_END

return UIPandectInfo

--endregion
