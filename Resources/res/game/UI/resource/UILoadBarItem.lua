--region UILoadBarItem.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local resData = global.resData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILoadBarItem  = class("UILoadBarItem", function() return gdisplay.newWidget() end )

function UILoadBarItem:ctor()
    self:CreateUI()
end

function UILoadBarItem:CreateUI()
    local root = resMgr:createWidget("resource/res_part_loadingbar_node")
    self:initUI(root)
end

function UILoadBarItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_part_loadingbar_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.loadingbar = self.root.loadingbar_export
    self.part_name = self.root.part_name_export
    self.res_speed = self.root.res_speed_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UILoadBarItem:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_UI_CITY_FEATURE, function()
            
        local addValue = resData:getCityAddByType(self.data.resId)   
        if addValue > 0 then
            self.loadingbar:setPercent(100)
            self.res_speed:setString(global.funcGame:_formatBigNumber(addValue , 1 )..global.luaCfg:get_local_string(10076))
        end
        
    end)
end

function UILoadBarItem:setData(data, resId, baseRes)

    self.data = data
    self.data.resId = resId
    self.baseRes = baseRes
    self.part_name:setString(luaCfg:get_local_string(data.localId))
    local hourStr = global.luaCfg:get_local_string(10076)
    local curPer, maxAdd = 0, 0
    if data.id == 1 then
        maxAdd = self:getWildAdd()
        if maxAdd > 0 then curPer = 100 end
    elseif data.id == 2 then
        curPer, maxAdd = self:getServerData(2)
    elseif data.id == 3 then
        curPer, maxAdd = self:getCityAdd()
    elseif data.id == 4 then
        curPer, maxAdd = self:getServerData(4)
    elseif data.id == 5 then
        curPer, maxAdd = self:getServerData(5)
    elseif data.id == 6 then
        curPer, maxAdd = self:getServerData(6)
    elseif data.id == 7 then
        curPer, maxAdd = self:getServerData(7)
    elseif data.id == 8 then
        curPer, maxAdd = self:getServerData(8)
    elseif data.id == 9 then 
        curPer, maxAdd = self:getServerData(9)
    elseif data.id == 10 then
        curPer, maxAdd = self:getPetAdd()
    end 
    
    self.loadingbar:setPercent(curPer)
    self.res_speed:setString(global.funcGame:_formatBigNumber(maxAdd , 1 )..hourStr)
end

-- 神兽加成
function UILoadBarItem:getPetAdd()

    local addVal = resData:getPetAdd(self.data.resId)
    if addVal > 0 then
        return 100, addVal
    end
    return 0, 0
end

--　占领野地
function UILoadBarItem:getWildAdd()
    local infoPanel = global.panelMgr:getPanel("UIResInfoPanel")
    return resData:getWildBaseNum( infoPanel.curResId )
end

--　城池特色
function UILoadBarItem:getCityAdd()
    local per = 0
    local addValue = resData:getCityAddByType(self.data.resId)
    if addValue > 0 then
        per = 100
    end
    return per, addValue
end

-- 获取各类型加成
function UILoadBarItem:getServerData(index)
    
    local curPer, maxAdd = 0 , 0 
    local heroAdd, techAdd, divAdd, cityBuff, itemAdd, vipAdd ,lordBuff= resData:getServerBuff(self.data.resId)

    if index == 2 then
        maxAdd = vipAdd
    elseif index == 6 then
        maxAdd = techAdd
    elseif index == 7 then
        maxAdd = cityBuff
    elseif index == 8 then
        maxAdd = divAdd
    elseif index == 5 then
        maxAdd = heroAdd
    elseif index == 4 then
        maxAdd = itemAdd
    elseif index == 9 then 
        maxAdd = lordBuff
    end 

    if maxAdd > 0 then
        curPer = 100
    end

    return curPer, maxAdd

end

--CALLBACKS_FUNCS_END

return UILoadBarItem

--endregion
