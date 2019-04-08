--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local _M = {}

local CURRLANGUAGE_KEY = "current_language_config"

function _M:setCurrentLanguage(lan)
    self.currentLan_ = lan

    cc.UserDefault:getInstance():setStringForKey(CURRLANGUAGE_KEY, self.currentLan_)
end

function _M:isCN()
    local cur = self:getCurrentLanguage()
    return cur == "cn"
end

function _M:getCurrentLanguage()
    local lan = self.currentLan_ or cc.UserDefault:getInstance():getStringForKey(CURRLANGUAGE_KEY)
    if lan == "" then
        local t_lan = gdevice.language
        global.luaCfg.languages__ = require("conf.languages")
        local lans = global.luaCfg:languages()
        for i,v in pairs(lans) do
            if v.symbol == t_lan then
                if v.open == 1 then
                    lan = t_lan
                else
                    lan = "cn"
                end
                break
            end
        end
        if lan == "" then
            lan = "cn"
        end
    end

    return lan
end

global.languageData = _M

--endregion
