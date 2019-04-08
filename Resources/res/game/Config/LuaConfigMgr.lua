
local cfg = require "asset.conf.config_loader"
local global = global

---@classdef LuaConfigMgr 
local LuaConfigMgr = cfg

-- 是否已经加载
LuaConfigMgr.mload_flag__ = false

-- 关卡数据索引
LuaConfigMgr.stagelist_data__ = {maps ={}, stages={}}
LuaConfigMgr.stage_data__ = {}
LuaConfigMgr.stage_ai__ = {}

--属性显示attribute
LuaConfigMgr.attribute_list_ = {}

function LuaConfigMgr:load()
    if self.mload_flag__ == true then
        log.error("call lua config load again.")
        return
    end
    
    self:Init()
    -- -- TODO check
    
    self:localUILanguageCfg()
    -- self:loadExtendCfg()
    -- self:loadIconResModule()
    self.mload_flag__ = true
end

function LuaConfigMgr:reload()

end

function LuaConfigMgr:loadIconResModule()
    require("game.Config.IconRes")
end

function LuaConfigMgr:loadExtendCfg()
    self.equipCfg = require("game.Config.EquipCfg") 
    self:initEquipmentItemId()
    self.heroSkillLearnCfg = require("game.Config.HeroSkillLearnCfg")
    self.heroSkillLearnCfg:initSkillLearn()
    self.heroSkillCfg = require("game.Config.HeroSkillCfg")
    self.heroSkillCfg:initSkill()
    self.dialogCfg = require("game.Config.DialogCfg")
end

function LuaConfigMgr:localUILanguageCfg()
    self.ui_language_cfg__ = require("asset.config.ui_language_cfg") 
end

function LuaConfigMgr:get_ui_language_cfg_by_module(fileName)
    return self.ui_language_cfg__[fileName]
end

function LuaConfigMgr:get_ui_language_cfg(fileName, nodeName)
    return self.ui_language_cfg__[fileName] and self.ui_language_cfg__[fileName][nodeName]
end

function LuaConfigMgr:get_paramvalue_by(id)
    local param = self:get_param_by(id)
    assert(param[param.valuetp], string.format("错误， 未定义的param<%d>", id))
    return param[param.valuetp]
end

function LuaConfigMgr:get_translate_string(value, ...)
    
    local text = ""
    if type(value) == "number" then
        local object = self:get_localization_by(value)
        if object then
            text = tostring(object.value)
        else
            text = tostring(value)
        end
    elseif type(value) == "string" then
        text = value
    end

    local values = {...}
    if type(text) == "string" then
        text = string.gsub(text,"#1#","\n")        
        
        for index,value in ipairs(values) do
            text = string.gsub(text,"{" .. index .. "}",value)
        end
    end

    print(text,"text,,,,,,,")

    return text
end

function LuaConfigMgr:get_local_string(value, ...)
    local text = ""
    if type(value) == "number" then
        local object = self:get_localization_by(value)
        if object then
            text = tostring(object.value)
        else
            text = tostring(value)
        end
    elseif type(value) == "string" then
        text = value
    end


    if type(text) == "string" then
        text = string.gsub(text,"#1#","\n")
        local num = 0
        for _ in string.gmatch(text, "%%s") do
            num = num + 1
        end

        local args = {...}
        local count = #args
        if count > 0 then
            if count < num then
                for i=1, num do
                    if args[i] == nil then
                        args[i] = "%s"
                    end
                end
                log.debug("[Warning] string.format's args(%s) less than %%s(%s) !", count, num)
            end
            return string.format(text, unpack(args))
        end
    end

    return text
end


function LuaConfigMgr:gift()
    self:wwx_sd_getFileModal("gift")
    
    local data = self.gift__:getdata() 
    local countryCode,paySymbol = global.sdkBridge:getPayCountryInfo()
    if not countryCode then
    else
        for k,v in pairs(data) do
            local rechargeItem = self:get_recharge_by(v.period)
            if rechargeItem and rechargeItem[countryCode] then
                local sym = self:get_recharge_sym_by(countryCode)
                v.unit = sym.sym or paySymbol or "$"
                v.price = tonumber(string.format("%.2f",v.price/v.cost*rechargeItem[countryCode]))
                v.cost = rechargeItem[countryCode]
                v.range = v.range or 0 
            end
        end
    end
    return data
end

function LuaConfigMgr:get_gift_by(id)
    self:wwx_sd_getFileModal("gift")

    local v = self.gift__:get(id) or {}
    local countryCode,paySymbol = global.sdkBridge:getPayCountryInfo()
    if not countryCode then
    else
        local rechargeItem = self:get_recharge_by(v.period)
        if rechargeItem and rechargeItem[countryCode] then
            local sym = self:get_recharge_sym_by(countryCode)
            v.unit = sym.sym or paySymbol or "$"
            v.price = tonumber(string.format("%.2f",v.price/v.cost*rechargeItem[countryCode]))
            v.cost = rechargeItem[countryCode]
            v.range = v.range or 0 
        end
    end
    return v
end

function LuaConfigMgr:get_equipment_by(id)
    self:wwx_sd_getFileModal("equipment")
    local v = self.equipment__:get(id)
    if not v then 
        v = self:get_lord_equip_by(id)
    end 
    return v
end

function LuaConfigMgr:get_local_item_by(id)
    self:wwx_sd_getFileModal("item")
    local v = clone(self.item__:get(id))
    if not v then 
        v = clone(self:get_equipment_by(id))
        if not v then
            log.error("id----------->="..id)
        end
        v.itemIcon = v.icon
        v.itemName = v.name
    end 
    return v
end

function LuaConfigMgr:overwrite_land_function()
    for funcitonName,v in pairs(LuaConfigMgr) do
        if type(v) == 'function' then
            if string.find(funcitonName,'__land_all') then                
                local aimFunctionName = string.gsub(funcitonName, "__land_all", "") 
                if LuaConfigMgr[aimFunctionName] then
                    local functionBack = LuaConfigMgr[aimFunctionName]
                    LuaConfigMgr[aimFunctionName] = function(...)
                        if global.userData:isOpenFullMap() then
                            return v(...)
                        else
                            return functionBack(...)
                        end
                    end
                end
            end
        end
    end
end

LuaConfigMgr:overwrite_land_function()

global.luaCfg = LuaConfigMgr
