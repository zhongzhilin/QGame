--region Persuade.lua
--Author : untory
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local luaCfg  = global.luaCfg

local Persuade  = class("Persuade", function() return gdisplay.newWidget() end )

function Persuade:ctor()
    self:CreateUI()
end

function Persuade:CreateUI()
    local root = resMgr:createWidget("hero/hero_barrack_time")
    self:initUI(root)
end

function Persuade:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_barrack_time")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero = self.root.hero_export
    self.hero_icon = self.root.hero_export.hero_icon_export
    self.load = self.root.Panel_1.load_export
    self.loading_effect = self.root.Panel_1.loading_effect_export
    self.time = self.root.time_export

--EXPORT_NODE_END
    self.barW = self.load:getContentSize().width
end

function Persuade:updateInfo(data , persuadeData)

    self.load:setPercent(data.percent)

    self.time:setString(data.time)

    self.loading_effect:setPositionX(self.barW*data.percent/100)

    if persuadeData then 

        -- for _ ,v  in  pairs( global.heroData:getGotHeroData() ) do 
            -- if v.heroId ==   persuadeData.lBindID  then 
            --       self.hero:setVisible(false)    
            --       return            
            -- end 
        -- end 

        local roldHeadData = luaCfg:rolehead()

        local head_data = nil

        for _ ,v in pairs(roldHeadData) do 
            if v.triggerId == persuadeData.lBindID then 
                head_data = v 
            end 
        end 


        if not self.head_data_path  or  self.head_data_path ~=head_data.path then  -- 设置一次头像

            global.panelMgr:setTextureFor(self.hero_icon,head_data.path)
        end 

        self.head_data_path  = head_data.path 

    end 

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return Persuade

--endregion
