--region UIBagUseSingle.lua
--Author : Administrator
--Date   : 2016/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local dataMgr = global.dataMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBagUseSingle  = class("UIBagUseSingle", function() return gdisplay.newWidget() end )

function UIBagUseSingle:ctor()
    self:CreateUI()
end

function UIBagUseSingle:CreateUI()
    local root = resMgr:createWidget("bag/bag_use1")
    self:initUI(root)
end

function UIBagUseSingle:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_use1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.title.name_export
    self.descText = self.root.Node_export.descText_export
    self.icon_bg = self.root.Node_export.icon_bg_export
    self.icon = self.root.Node_export.icon_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4_0, function(sender, eventType) self:use_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIBagUseSingle:setData( data , callBack, exitCall)

    self.callBack = callBack
    self.exitCall = exitCall
    self.data = data
    local itemData = luaCfg:get_item_by(data.id)
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
    self.name:setString(itemData.itemName)
    self.descText:setString(string.format(luaCfg:get_local_string(itemData.useDescId),itemData.itemName))

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


-- t] - "<var>" = {
-- [LUA-print] -     "count" = 100
-- [LUA-print] -     "id"    = 30301
-- [LUA-print] -     "sort"  = 122

function UIBagUseSingle:exit_call(sender, eventType)
    
    if self.exitCall then self.exitCall() end
    global.panelMgr:closePanelForBtn("UIBagUseSingle")
end


function UIBagUseSingle:used_tips(msg) -- 鐗规畩閬撳叿浣跨敤鍚庣殑tips 鎻愮ず 
    if msg.lID == 10601 then -- 闋樹富缍撻
        global.tipsMgr:showWarning("lord_exp_gain",msg.tgItem[1].lCount)
        return false 
    end 
    return true 
end

 function UIBagUseSingle:CheckCityBuff(call)

   local citybuff  = global.buffData:getBuffs()
   local buff = global.luaCfg:citybuff()

   local buff_type_arr = {}
   local buff_arr  = {}

   for _ ,v in pairs(buff) do 
        table.insert(buff_arr ,v.datatype)
   end 

   for _ ,v in pairs(citybuff) do 

        if global.EasyDev:CheckContrains(buff_arr , v.lID) then 

            table.insert(buff_type_arr , v.lID)

        end 
   end 

    if global.EasyDev:CheckContrains(buff_type_arr , global.luaCfg:get_item_by(self.data.id).typePara3) then 

        local panel = global.panelMgr:openPanel("UIPromptPanel")

        panel:setData("gain01",function() if call then call() end  end)

        return true  
    end 

   return false 
end 

function UIBagUseSingle:use_call(sender, eventType)

    global.panelMgr:closePanel("UIBagUseSingle")


    if self:checkMoveCity() then return end  

    local useCall = function()
    
        if not self.data then return end
        global.itemApi:itemUse(self.data.id, 1, 0, 0, function(msg) 

            if self.callBack then 
                self.callBack(msg)
                return
            end


            if self.used_tips and self:used_tips(msg) == false then 
                return 
            end 

            if not self.data then return end 

            local itemData = luaCfg:get_item_by(self.data.id)

            if itemData.itemType == 140 then 
                
                return self:playHeroEffect(itemData)                
            end 

            local window = itemData.window

            local data = {} --msg.tgItem--global.normalItemData:useItem(self.data.id, num)        
            for _,v in ipairs(msg.tgItem or {}) do

                table.insert(data,{[1] = v.lID,[2] = v.lCount})            
            end

            local tipStr = ""
            if data then tipStr = global.taskData.getGiftInfoBySort(data) end

            if self.itemUseDone then
                self:itemUseDone( msg , itemData )
            end

            if window == 0 then

                return

            elseif  window == 1 then        
                
                global.tipsMgr:showTaskTips(tipStr)
            elseif  window == 2 then

                global.panelMgr:openPanel("UIItemRewardPanel"):setData(data)--:setData(self.data)
            elseif window == 3 then

                local id = itemData.typePara1

                local soldierData = luaCfg:get_soldier_property_by(id)
                global.tipsMgr:showTaskTips(luaCfg:get_local_string(10206,soldierData.name,1))
            elseif window == 4 then
                
                global.tipsMgr:showTaskTips(itemData.useDes)
            end            
        end)  
    end

    if self:checkProtect(useCall) then return end
    if self:checkHeroGift(useCall) then return end
    if self:CheckCityBuff(useCall) then  return end    

    useCall()
end

function UIBagUseSingle:playHeroEffect( data)

    local config = global.luaCfg:get_hero_property_by(data.typePara1)
    if config then 
        global.panelMgr:openPanel("UIGotHeroPanel"):setData(config)
    end 
end

function UIBagUseSingle:itemUseDone( msg , itemData )
    
    local itemData = luaCfg:get_item_by(self.data.id)

    if itemData.itemType == 121 then

        global.worldApi:ignoreAttackEffect()
    elseif itemData.itemType == 125 then
        
        global.troopData:setNewMonsterId(msg.lParam)
        global.funcGame:gpsWorldCity(msg.lParam,2)
    end
end

function UIBagUseSingle:checkHeroGift(useCall)

    local itemData = luaCfg:get_item_by(self.data.id)

    if itemData.itemType == 140 then
        if global.heroData:isGotHero(itemData.typePara1) then
            global.tipsMgr:showWarning("HeroBeGet")
            return true
        end
    end
    
end

function UIBagUseSingle:checkProtect(useCall)
    
    local itemData = luaCfg:get_item_by(self.data.id)
    if itemData.itemType == 121 then
    
        global.worldApi:checkMainCityProtect(function(isProtect)
            
            if isProtect then

                local panel = global.panelMgr:openPanel("UIPromptPanel")                
                panel:setData("ProtectCover", function()
                        
                    global.worldApi:removeProtection(function(msg)
                            
                        useCall() 
                    end)
                end)
            else

                useCall()
            end
        end)
        return true
    else

        return false
    end
end


function UIBagUseSingle:checkMoveCity()

    if self.data.id == 11601 then               
        
        local moveCityCall = function ()
            
            global.worldApi:moveCity(0, function(msg)
                
                -- dump(msg)

                if global.scMgr:isWorldScene() then

                    global.g_worldview.worldPanel:setMainCityData(msg.lCitys,true)
                    
                    global.panelMgr:closePanel("UIBagPanel")
                else

                    global.panelMgr:closePanel("UIBagPanel")
                    global.scMgr:gotoWorldSceneWithAnimation()
                end        
            end)
        end        

        if global.cityData:getMainCityLevel() < 2 then

            global.tipsMgr:showWarning('NewGuide01')
            return true
        end

        local checkMoveCityCall = function()
            self:checkMoveCity()
        end
        if global.userData:checkCD(27,"MovedToCity02",checkMoveCityCall) then

            return true
        else

            global.worldApi:checkMainCityProtect(function(isProtect,protectType)
            
                local tmpCall = function()
                    
                    if isProtect then

                        if protectType == 1 then

                            local panel = global.panelMgr:openPanel("UIPromptPanel")        
                            panel:setData("MovedToCity01", function()
                                    
                                global.worldApi:removeProtection(moveCityCall)
                            end)
                        else

                            local panel = global.panelMgr:openPanel("UIPromptPanel")        
                            panel:setData("MovedToCity03", function()
                                    
                                global.worldApi:removeProtection(moveCityCall)
                            end,global.luaCfg:get_config_by(1).protectCD / 60)
                        end                        
                    else

                        local panel = global.panelMgr:openPanel("UIPromptPanel")        
                        panel:setData("MovedToCity01", moveCityCall)
                    end
                end

                if global.troopData:isEveryTroopIsInsideCity() then

                    tmpCall()
                else

                    local panel = global.panelMgr:openPanel("UIPromptPanel")        
                    panel:setData("CityMoveTroopsNo", function()
                            
                        tmpCall()
                    end)
                end
            end)            
        end

        return true
    end

    return false
end

--CALLBACKS_FUNCS_END

return UIBagUseSingle

--endregion
