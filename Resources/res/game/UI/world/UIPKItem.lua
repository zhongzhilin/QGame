--region UIPKItem.lua
--Author : yyt
--Date   : 2016/11/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPKItem  = class("UIPKItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIPKItem:ctor()
    
    self:CreateUI()
end

function UIPKItem:CreateUI()
    local root = resMgr:createWidget("world/info/city_pk_info")
    self:initUI(root)
end

function UIPKItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/city_pk_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.lord_name = self.root.lord_name_export
    self.troop_name = self.root.troop_name_export
    self.troop_scale = self.root.troop_scale_export
    self.union = self.root.union_export
    self.joinTime = self.root.joinTime_export
    self.cityState = self.root.cityState_export
    self.textContent = self.root.textContent_export
    self.buffIcon = self.root.buffIcon_export
    self.touch = self.root.touch_export

--EXPORT_NODE_END
    self.infoPanel = global.panelMgr:getPanel("UIPKInfoPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPKItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end 
end

function UIPKItem:setData(data)

    if data == nil then return end
    self.data = data

    -- 领主名
    if data.ltroopid == 0 then

        local szName = self.infoPanel:getAllName()
        local lWildKind = self.infoPanel:getWildKind()
        local isWildOrRes = (lWildKind == 1 or lWildKind == 2) -- 野地、野怪
        local isWorldBoss = self.infoPanel:getWorldBoss()      -- 世界boss
        if isWorldBoss then
            local rwData = global.mailData:getDataByType(9, tonumber(self.infoPanel.sznameId))
            self.lord_name:setString(rwData.name)
        elseif isWildOrRes then
            self.lord_name:setString(self:checkStr(szName))
        else
            local szDataName = self.infoPanel:getSzName()
            local sData = luaCfg:get_all_miracle_name_by(tonumber(szDataName))
            if sData then
                self.lord_name:setString(self:checkStr(sData.name))
            else
                self.lord_name:setString(self:checkStr(szName))
            end
        end
    else
        self.lord_name:setString(self:checkStr(data.szownername)) 
    end

    -- 部队名
    if data.sztroopname and data.sztroopname ~= "" then     

        if data.ltroopid == 0 then
            self.troop_name:setString(self:getMiracleTroopName(tonumber(data.sztroopname))) 
        else
            self.troop_name:setString(data.sztroopname)
        end
    else
        self.troop_name:setString(luaCfg:get_local_string(10161))
    end

    -- 部队规模
    if data.ltroopsize > 0 then
        self.troop_scale:setString(data.ltroopsize)
    else
        self.troop_scale:setString("-")
    end

    -- 联盟简称
    self.union:setString(global.unionData:getUnionShortName(self:checkStr(data.szallyname)))
    self:checkCityState(data)

    -- 加入时间
    if data.ljointime > 0 then
        local tBegan = funcGame.formatTimeToTime(data.ljointime)
        self.joinTime:setString(luaCfg:get_local_string( 10017 , tBegan.hour, tBegan.minute, tBegan.second )) 
    end

    local tempdata ={information={}, tips_type="UIBuffDes",} 
    tempdata.itemAdd = self:getBuffAddByFrom(7)
    tempdata.divineAdd = self:getBuffAddByFrom(5)
    local isExitBuff = tempdata.itemAdd[2] ~= 0 or tempdata.divineAdd[2] ~= 0
    self.buffIcon:setVisible(isExitBuff)
    if isExitBuff then
        -- tips
        if not self.m_TipsControl  then 
            self.m_TipsControl = UIItemTipsControl.new()
            local mailPanel = global.panelMgr:getPanel("UIPKInfoPanel")
            self.m_TipsControl:setdata(self.touch, tempdata, mailPanel.tips_node)
        else 
            self.m_TipsControl:updateData(tempdata)
        end
    else
        if self.m_TipsControl then 
            self.m_TipsControl:ClearEventListener()
            self.m_TipsControl  = nil 
        end
    end

end

function UIPKItem:getBuffAddByFrom(lFrom)

    local tagbuffEffectFight = self.data.tagbuffEffectFight or {}
    for k,v in pairs(tagbuffEffectFight) do
        if v.lFrom == lFrom then
            local temp = {}
            table.insert(temp, v.lBuffId)
            table.insert(temp, v.lBuffValue)
            return temp
        end
    end
    return {0, 0}
end

-- 获取奇迹部队名称
function UIPKItem:getMiracleTroopName(lType)
    
    local miracleData = luaCfg:miracle_reward()
    for _,v in pairs(miracleData) do
        if v.type == lType then
            return v.troopName
        end
    end
    return luaCfg:get_local_string(lType) or ""
end

function UIPKItem:checkCityState(data)

    local state = data.lpurpose
    local str = ""
    local textColor = cc.c3b(255, 226, 165)

    if data.type == 0 then
        if state == 1 then
            str = luaCfg:get_local_string(10125)
            textColor = cc.c3b(36, 108, 198)
        elseif state == 2 then
            str = luaCfg:get_local_string(10124)
            textColor = cc.c3b(180, 29, 11)
        elseif state == 6 then
            str = luaCfg:get_local_string(10126) 
            textColor = cc.c3b(255, 255, 255)
        elseif state == 7 then  
            str = luaCfg:get_local_string(10210)  
            textColor = cc.c3b(255, 120, 54)    
        end
    else
        if state == 6 then
            str = luaCfg:get_local_string(10132)
        elseif state == 10 or state == 5 then
            str = luaCfg:get_local_string(10131)        
        end
    end
    self.cityState:setString(self:checkStr(str))
    self.cityState:setTextColor(textColor)
end

function UIPKItem:checkStr(strName)
    if strName and strName ~= "" then
        return strName
    else
        return "-"
    end
end

--CALLBACKS_FUNCS_END

return UIPKItem

--endregion
