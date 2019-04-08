
--region UIAttackBoard.lua
--Author : Administrator
--Date   : 2016/10/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIIntroducePanel = require("game.UI.commonUI.UIIntroducePanel")
local UIAttackBoard  = class("UIAttackBoard", function() return gdisplay.newWidget() end )

function UIAttackBoard:ctor()
    
    self:CreateUI()
end

function UIAttackBoard:CreateUI()
    local root = resMgr:createWidget("world/btn_attack")
    self:initUI(root)
end

function UIAttackBoard:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/btn_attack")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.attack_new_cb2 = self.root.attack_new_cb2_export
    self.Text_cb2 = self.root.attack_new_cb2_export.Text_cb2_mlan_7_export
    self.attack_new_cb1 = self.root.attack_new_cb1_export
    self.Text_cb1 = self.root.attack_new_cb1_export.Text_cb1_mlan_7_export

    uiMgr:addWidgetTouchHandler(self.root.btn01, function(sender, eventType) self:attack_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn02, function(sender, eventType) self:attack_stay_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn03, function(sender, eventType) self:attack_city_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn04, function(sender, eventType) self:lueduo_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.btn05, function(sender, eventType) self:zhencha_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.intro_btn, function(sender, eventType) self:onHelpHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_new_cb2, function(sender, eventType) self:checkSelect2(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.attack_new_cb1, function(sender, eventType) self:checkSelect1(sender, eventType) end)
--EXPORT_NODE_END

    self.originPosX = self.root.Node_1.Image_2:getPositionX()
    
    global.g_worldview.worldPanel.lForce = 0
    self.attack_new_cb1:setEnabled(false)
    self.attack_new_cb2:setEnabled(true)
    self.attack_new_cb1.icon:loadTexture('ui_surface_icon/attack_new_icon3.png',ccui.TextureResType.plistType)
    self.attack_new_cb2.icon:loadTexture('ui_surface_icon/attack_new_icon2.png',ccui.TextureResType.plistType)
    self.Text_cb1:setTextColor(cc.c3b(255,226,165))
    self.Text_cb2:setTextColor(cc.c3b(214,165,108))

    self.attack_new_cb1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)    
    self.attack_new_cb2:setZoomScale(WCONST.BUTTON_SCALE.SMALL)    
    -- self:checkSelect1()

    -- self.attack_mode_cb2:addEventListener(function(cb,state)
        
    --     self:checkSelect(2)
    -- end)

    -- self.attack_mode_cb1:addEventListener(function(cb,state)
        
    --     self:checkSelect(1)                     
    -- end)

    -- global.colorUtils.turnGray(self.root.btn01,true)
    -- self.root.btn05:setBright(false)
    -- self.root.btn04:setBright(true)

end

function UIAttackBoard:onEnter()
    
    self.mainCityLv = global.cityData:getTopLevelBuild(1).serverData.lGrade

    self:check_attack_call(self.root.btn01)
    self:check_attack_city(self.root.btn03)
    self:check_lueduo(self.root.btn04)
    self:check_stay(self.root.btn02)
    self:check_zhencha(self.root.btn05)   

    gevent:call(global.gameEvent.EV_ON_GUIDE_FIRST_ATTACT_BOARD)
end

function UIAttackBoard:onExit()
    self.combat = 0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIAttackBoard:showWenhao()
    
    
end

function UIAttackBoard:isForce()
    
    return global.g_worldview.worldPanel.lForce == 1
end

function UIAttackBoard:callFightCall(cb)
    
    return function()
       
        global.worldApi:callFight(self.city:getUserId(), function(msg)
                    
            cb()
            global.g_worldview.mapPanel:closeChoose()
        end)
    end
end

function UIAttackBoard:callFightAndDeProtectCall(cb)
    
    return function()
       
        global.worldApi:callFight(self.city:getUserId(), function(msg)
                    
            global.worldApi:removeProtection(function(msg)
            
                cb()
                global.g_worldview.mapPanel:closeChoose()
            end)                    
        end)        
    end
end

function UIAttackBoard:callDeProtectCall(cb)
    
    return function()
       
        global.worldApi:removeProtection(function(msg)
                    
            cb()
            global.g_worldview.mapPanel:closeChoose()
        end)
    end
end

function UIAttackBoard:check_attack_call(sender, eventType)
    
    -- local openCall = function()
    
    --     global.g_worldview.worldPanel.attackMode = 2        
    --     global.panelMgr:openPanel("UITroopPanel")
    -- end

    global.colorUtils.turnGray(sender,false)

    local isProtect = self:isSelfProtect()

    if self.m_isWild and not self:isOccupire() then isProtect = false end

    if self:getAvatarType() == 0 then

        -- if not isProtect then

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("DeclareWar", self:callFightCall(openCall),self.city:getName())
        -- else

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("ProtectWar", self:callFightAndDeProtectCall(openCall),self.city:getName())
        -- end        
    else
    
        if not self:isForce() then

            if self:isFirend() then
            
                global.colorUtils.turnGray(sender,true)
                -- global.tipsMgr:showWarning("FriendCantAtk")
            else

                -- if isProtect then

                --     local panel = global.panelMgr:openPanel("UIPromptPanel")
                --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                -- else

                --     openCall()
                -- end                
            end            
        else

            -- if isProtect then

            --     local panel = global.panelMgr:openPanel("UIPromptPanel")
            --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
            -- else

            --     openCall()
            -- end            
        end         
    end   
end

function UIAttackBoard:checkEnergy()

    if self.needPower > global.userData:getCurHp() then
        return false
    else
        return true
    end
end

function UIAttackBoard:getCurCityType()

    if self.city.isCity then        -- uiworldcity 
        
        if self.city:isPlayer() then      -- 城堡
            return 2
        elseif self.city:isVillage() then -- 小村庄
            return 6
        elseif self.city:isMagic() then   -- 奇迹
            return 3
        elseif self.city:isTown() then    -- 联盟村庄
            return 4
        end

    elseif self.city.isWildRes then -- uiworldwildres

        if self.city:isMiracle() then     -- 神殿
            return 5
        else
            return 1
        end
    end

    return 0
end

function UIAttackBoard:attack_call(sender, eventType)
    
    local afterCheckOccupyCall = function()
        
        local openCall = function()
            
            if not self.checkEnergy then return end -- protect
            if not self:checkEnergy() then
                global.panelMgr:openPanel("UIBuyEnergyPanel"):setData(handler(self, self.checkEnergy), true)
                return
            end

            global.troopData:setAttackType(self:getCurCityType())
            global.troopData:setTargetData(2)    
            global.troopData:setTargetCombat(self.combat) 
            global.panelMgr:openPanel("UITroopPanel")
        end

        if not self.isSelfProtect then return end
        local isProtect = self:isSelfProtect()

        -- 如果是一个尚未被人占领的野地，则不提示破罩
        if self.m_isWild and not self:isOccupire() then
            isProtect = false
        end

        if self:getAvatarType() == 0 then

            if not isProtect then

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("DeclareWar", self:callFightCall(openCall),self.city:getBeFightName())
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("ProtectWar", self:callFightAndDeProtectCall(openCall),self.city:getName())

            end        
        else
        
            if not self:isForce() then

                if self:isFirend() then
                
                    global.tipsMgr:showWarning("FriendCantAtk")
                else

                    if isProtect then

                        local panel = global.panelMgr:openPanel("UIPromptPanel")
                        panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                    else

                        openCall()
                    end                
                end            
            else

                if isProtect then

                    local panel = global.panelMgr:openPanel("UIPromptPanel")
                    panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                else

                    openCall()
                end            
            end         
        end   
    end    

    if self.city.isWildRes or true then

        global.worldApi:checkOccupy(self.city,function(msg)
   
            if msg.lStatus == 0 then

                afterCheckOccupyCall()
            else
               
                local panel = global.panelMgr:openPanel("UIPromptPanel")
                if self.city and self.city.isPlayer and self.city:isPlayer() then

                    panel:setData("MaxOccupyNew",  afterCheckOccupyCall,global.funcGame:getNextCityMaxChange())
                else

                    panel:setData("MaxOccupy",  afterCheckOccupyCall)
                    panel:setCancelLabel(10948):setCancelCall(function()
                        global.panelMgr:openPanel("UIPandectPanel"):initData(4)
                    end)
                end  
            end
        end)
    else

        afterCheckOccupyCall()
    end    
end

function UIAttackBoard:isSelfProtect()
    
    return false
    -- return global.g_worldview.worldPanel:isMainCityProtect()
end

function UIAttackBoard:isFirend()
   
   return  self:getAvatarType() == 2 or self:getAvatarType() == 3 or self:getAvatarType() == 1
end

function UIAttackBoard:isOccupire()
    
    return self.city:isOccupire()
end

function UIAttackBoard:check_attack_city(sender)
    
    -- local openCall = function()
        
    --     global.g_worldview.worldPanel.attackMode = 1        
    --     global.panelMgr:openPanel("UITroopPanel")
    -- end

    local isProtect = self:isSelfProtect()
    global.colorUtils.turnGray(sender,false)

    self.mainCityLv = self.mainCityLv or 0
    if self.mainCityLv < luaCfg:get_config_by(1).siegeLv then
        global.colorUtils.turnGray(sender,true)
        return
    end

    if self:getAvatarType() == 0 then

        -- if not isProtect then

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("DeclareWar", self:callFightCall(openCall),self.city:getName())
        -- else

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("ProtectWar", self:callFightAndDeProtectCall(openCall),self.city:getName())
        -- end        
    else
    
        if not self:isForce() then

            if self:isFirend() then
            
                global.colorUtils.turnGray(sender,true)
            else

                -- if isProtect then

                --     local panel = global.panelMgr:openPanel("UIPromptPanel")
                --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                -- else

                --     openCall()
                -- end                
            end            
        else

            -- if isProtect then

            --     local panel = global.panelMgr:openPanel("UIPromptPanel")
            --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
            -- else

            --     openCall()
            -- end            
        end         
    end   
end

function UIAttackBoard:attack_city_call(sender, eventType)

    self.mainCityLv = self.mainCityLv or 0

    if self.mainCityLv < luaCfg:get_config_by(1).siegeLv then
        
        global.tipsMgr:showWarning("UnlockAction",luaCfg:get_config_by(1).siegeLv)
        return
    end


    self.afterCheckOccupyCall = function()

        local openCall = function()
            
            if not self.checkEnergy then return end -- 网络返回 防止 nil  

            if not self:checkEnergy() then
                global.panelMgr:openPanel("UIBuyEnergyPanel"):setData(handler(self, self.checkEnergy), true)
                return
            end

            global.troopData:setAttackType(self:getCurCityType())
            global.troopData:setTargetData(1)   
            global.troopData:setTargetCombat(self.combat) 
            global.panelMgr:openPanel("UITroopPanel")
        end

        if not self.isSelfProtect  then 
            -- protect 
            return 
        end 

        local isProtect = self:isSelfProtect()

        if self:getAvatarType() == 0 then

            if not isProtect then

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("DeclareWar", self:callFightCall(openCall),self.city:getBeFightName())
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("ProtectWar", self:callFightAndDeProtectCall(openCall),self.city:getName())
            end        
        else
        
            if not self:isForce() then

                if self:isFirend() then
                
                    global.tipsMgr:showWarning("FriendCantAtk")
                else

                    if isProtect then

                        local panel = global.panelMgr:openPanel("UIPromptPanel")
                        panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                    else

                        openCall()
                    end                
                end            
            else

                if isProtect then

                    local panel = global.panelMgr:openPanel("UIPromptPanel")
                    panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                else

                    openCall()
                end            
            end         
        end     
    end

    global.worldApi:checkOccupy(self.city,function(msg)
   
        if not self.afterCheckOccupyCall then -- 防止方法为 nil 

            print("UIAttackBoard >>>>>>>>>self.afterCheckOccupyCall method nil ")  
            return 
        end 
        
        if msg.lStatus == 0 then

            self.afterCheckOccupyCall()
        else

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            
            if self.city and self.city.isPlayer and self.city:isPlayer() then

                panel:setData("MaxOccupyNew",  self.afterCheckOccupyCall,global.funcGame:getNextCityMaxChange())
            else

                panel:setData("MaxOccupy",  self.afterCheckOccupyCall)
                panel:setCancelLabel(10948):setCancelCall(function()

                    if self.city and self.city.isMagic and self.city:isMagic() then
                        global.panelMgr:openPanel("UIUnionMiraclePanel")
                    else
                        global.panelMgr:openPanel("UIPandectPanel"):initData(4)
                    end                    
                end)
            end            
        end
    end)

    --  self.afterCheckOccupyCall()
end

function UIAttackBoard:check_lueduo(sender)
    
    
    global.colorUtils.turnGray(sender,false)
    
    print(self.mainCityLv,luaCfg:get_config_by(1).RaidLv)
    if self.mainCityLv < luaCfg:get_config_by(1).RaidLv then
        global.colorUtils.turnGray(sender,true)
        return
    end

    if self.m_isWild then

        global.colorUtils.turnGray(sender,true)
        return
    end

    -- local openCall = function()
    
    --     global.g_worldview.worldPanel.attackMode = 6
    --     global.panelMgr:openPanel("UITroopPanel")
    -- end
    
    local isProtect = self:isSelfProtect()
    
    if self.city:isEmpty() then

        if self.city:isMagic() then


            global.colorUtils.turnGray(sender,true)

            -- global.tipsMgr:showWarning("190") --   
        elseif self.city:isTown() then

            global.colorUtils.turnGray(sender,true)
            -- global.tipsMgr:showWarning("189") --   
        else

            global.colorUtils.turnGray(sender,true)
            -- global.tipsMgr:showWarning("51") --    
        end
        
        return
    elseif self:getAvatarType() == 0 then

        -- if not isProtect then

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("DeclareWar", self:callFightCall(openCall),self.city:getName())
        -- else

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("ProtectWar", self:callFightAndDeProtectCall(openCall),self.city:getName())
        -- end  
    elseif self.city and self.city:isOwner() then     
        global.colorUtils.turnGray(sender,true)
    else
    
        if not self:isForce() then

            if self:isFirend() then
        
                global.colorUtils.turnGray(sender,true)    
                -- global.tipsMgr:showWarning("FriendCantAtk")
            else

                -- if isProtect then

                --     local panel = global.panelMgr:openPanel("UIPromptPanel")
                --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                -- else

                --     openCall()
                -- end                
            end            
        else

            -- if isProtect then

            --     local panel = global.panelMgr:openPanel("UIPromptPanel")
            --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
            -- else

            --     openCall()
            -- end            
        end         
    end   
end

function UIAttackBoard:lueduo_call(sender, eventType)

    if not self.city then 
        return 
    end 

    
    global.g_worldview.worldPanel.attackMode = 6
    
    if self.mainCityLv < luaCfg:get_config_by(1).RaidLv then
        
        global.tipsMgr:showWarning("UnlockAction",luaCfg:get_config_by(1).RaidLv)
        return
    end

    if self.m_isWild then

        if self.city:isMiracle() then
            global.tipsMgr:showWarning("Temple02")
        else
            global.tipsMgr:showWarning("WildPlunder")
        end        
        return
    elseif self.city and self.city:isOwner() then
        return global.tipsMgr:showWarning("OwnCantRob")
    end



    local openCall = function()
    
        local endCheckCall = function()
            if self.getCurCityType then
                global.troopData:setAttackType(self:getCurCityType())
            end
            global.troopData:setTargetData(6)   
            global.troopData:setTargetCombat(self.combat) 
            global.panelMgr:openPanel("UITroopPanel")
        end        

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("RobTips", endCheckCall)
    end
    
    local endCall = function()
        
        if not self.isSelfProtect then return end
        local isProtect = self:isSelfProtect()
    
        if self.city:isEmpty() then

            if self.city:isMagic() then

                global.tipsMgr:showWarning("190") --   
            elseif self.city:isTown() then

                global.tipsMgr:showWarning("189") --   
            else

                global.tipsMgr:showWarning("51") --    
            end
            
            return
        elseif self:getAvatarType() == 0 then

            if not isProtect then

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("DeclareWar", self:callFightCall(openCall),self.city:getBeFightName())
            else

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("ProtectWar", self:callFightAndDeProtectCall(openCall),self.city:getName())
            end        
        else
        
            if not self:isForce() then

                if self:isFirend() then
                
                    global.tipsMgr:showWarning("FriendCantAtk")
                else

                    if isProtect then

                        local panel = global.panelMgr:openPanel("UIPromptPanel")
                        panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                    else

                        openCall()
                    end                
                end            
            else

                if isProtect then

                    local panel = global.panelMgr:openPanel("UIPromptPanel")
                    panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
                else

                    openCall()
                end            
            end  
        end   
    end

    local checkLevelCall = function()
        
        local otherLv = 0
        if self.city then
            otherLv = self.city:getCastleLv()
        end
        local res = global.cityData:getTopLevelBuild(1)
        if res == nil then return false end
        local selfLv = res.serverData.lGrade

        -- print(selfLv,"selfLv",otherLv,"otherLv",luaCfg:get_config_by(1).oneRobTimes,"luaCfg:get_config_by(1).oneRobTimes")

        local cutLv = selfLv - otherLv
        if cutLv >= luaCfg:get_config_by(1).oneRobTimes  and self.city and  (not self.city:isEmpty()) then

            -- print(">>>need show rob tips")
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("robResReduce", endCall,self:checkLueduoScale(cutLv) .. "%%")
        else

            endCall()
        end
    end

    if self.city.isCity and self.city:isPlayer() then
            
        global.worldApi:checkRobCount(self.city:getId(),function(msg)
            
            msg = msg or {}
            msg.lRobCount = msg.lRobCount or 0
            if msg.lRobCount >= 3 then

                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("robNoRes", checkLevelCall)
            else
                checkLevelCall()
            end
        end)
    else        
        checkLevelCall()
    end
end 

function UIAttackBoard:checkLueduoScale(cutLv)
    
    for _,v in pairs(luaCfg:rob_value()) do

        if cutLv >= v.minLv and cutLv <= v.maxLv then

            return v.scale
        end
    end

    return 100
end

function UIAttackBoard:check_stay(sender)
    -- global.g_worldview.worldPanel.attackMode = 4

    -- local openCall = function( )
            
    --     global.panelMgr:openPanel("UITroopPanel")
    -- end


    global.colorUtils.turnGray(sender,false)    

    if self.mainCityLv < luaCfg:get_config_by(1).garrisonLv then
        global.colorUtils.turnGray(sender,true)
        return
    end

    if self.m_isWild then
        local resCity = global.g_worldview.worldPanel:getWorldMapPanel():getWildResById(global.g_worldview.worldPanel.chooseCityId)
        if resCity and resCity.canStay and not resCity:canStay(true) then 
            global.colorUtils.turnGray(sender,false)   
            return  
        end
    
        -- openCall()
        return
    end    

    if self:getAvatarType() == 0 then

        if self.city:getIsWarnning() then


            global.colorUtils.turnGray(sender,true)    
            -- global.tipsMgr:showWarning("NeutralCantGarrison")
        elseif self.city:isEmpty() and self.city:isMagic() then


            global.colorUtils.turnGray(sender,true)    
            -- global.tipsMgr:showWarning("OppMirCantGarrison")
        else

            -- openCall()
        end
    elseif self:getAvatarType() == 4 then

        if not self.city:isEmpty() then


            global.colorUtils.turnGray(sender,true)    
            -- global.tipsMgr:showWarning("OpposeCantGarrison")
        else

            if self.city:isMagic() then


                global.colorUtils.turnGray(sender,true)    
                -- global.tipsMgr:showWarning("OppMirCantGarrison")
            else

                -- openCall()
            end
        end        
    end

    if self.city.isCity and self.city:isOccupire() and not self.city:be_self_occupy()  and not self:isForce() and self.city:isTrueFirend() then

        global.colorUtils.turnGray(sender,true)
    end
end

function UIAttackBoard:attack_stay_call(sender, eventType)
    
    global.troopData:setAttackType(self:getCurCityType())
    global.troopData:setTargetData(4)   

    local openCall = function( )
            

        if self.city.isCity and self.city:isOccupire() and not self.city:be_self_occupy()  and not self:isForce() and self.city:isTrueFirend() then

            global.tipsMgr:showWarning("GarrisonTips")
            return
        end

        global.panelMgr:openPanel("UITroopPanel")
    end


    if self.mainCityLv < luaCfg:get_config_by(1).garrisonLv then
        
        global.tipsMgr:showWarning("UnlockAction",luaCfg:get_config_by(1).garrisonLv)
        return
    end

    if self.m_isWild then
        local resCity = global.g_worldview.worldPanel:getWorldMapPanel():getWildResById(global.g_worldview.worldPanel.chooseCityId)
        if resCity and resCity.canStay and not resCity:canStay() then return end
    
        openCall()
        return
    end

    if self:getAvatarType() == 0 then

        if self.city:getIsWarnning() then

            global.tipsMgr:showWarning("NeutralCantGarrison")
        elseif self.city:isEmpty() and self.city:isMagic() then

            global.tipsMgr:showWarning("OppMirCantGarrison")
        else

            openCall()
        end
    elseif self:getAvatarType() == 4 then

        if not self.city:isEmpty() then

            global.tipsMgr:showWarning("OpposeCantGarrison")
        else

            if self.city:isMagic() then

                global.tipsMgr:showWarning("OppMirCantGarrison")
            else

                openCall()
            end
        end    
    else

        openCall()
    end

    
end

function UIAttackBoard:onHelpHandler(sender, eventType)

    
    local panel = global.panelMgr:openPanel("UIIntroducePanel")
    panel:setData(luaCfg:get_introduction_by(5))
end

function UIAttackBoard:checkSelect(changeIndex)
    
    if changeIndex == 1 then
        self.attack_mode_cb2:setSelected(not self.attack_mode_cb1:isSelected())
    elseif changeIndex == 2 then
        self.attack_mode_cb1:setSelected(not self.attack_mode_cb2:isSelected())
    end

    if self.attack_mode_cb1:isSelected() then
        global.g_worldview.worldPanel.lForce = 1
    else
        global.g_worldview.worldPanel.lForce = 0
    end

    self:onEnter()
end

function UIAttackBoard:call_cb1(sender, eventType)

    -- global.g_worldview.worldPanel.lForce = 1

    -- -- self.attack_mode_cb2:setVisible(false)
    -- self.attack_mode_cb2:setSelected(false)
    -- self.attack_mode_cb1:setSelected(true)

    -- self:onEnter()
end

function UIAttackBoard:call_cb2(sender, eventType)

    -- global.g_worldview.worldPanel.lForce = 0

    -- self.attack_mode_cb2:setSelected(true)
    -- self.attack_mode_cb1:setSelected(false)

    -- self:onEnter()
end

function UIAttackBoard:check_zhencha(sender, eventType)

    --  local openCall = function()
    
    --     global.g_worldview.worldPanel.attackMode = 3      
    --     global.panelMgr:openPanel("UITroopPanel")
    -- end
    

    global.colorUtils.turnGray(sender,false)    


    if self.mainCityLv < luaCfg:get_config_by(1).scoutLv then
        global.colorUtils.turnGray(sender,true)
        return
    end

    local isProtect = self:isSelfProtect()
    
    if self.city and self.city:isOwner() then

        global.colorUtils.turnGray(sender,true)
        -- global.tipsMgr:showWarning("CantSpyOnSelf")
    elseif self.city.isWildRes and not self.city:isOccupire() then
        
        global.colorUtils.turnGray(sender,true)

        -- if isProtect then

        --     local panel = global.panelMgr:openPanel("UIPromptPanel")
        --     panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
        -- else

        --     openCall()
        -- end    
    end       
end

function UIAttackBoard:setTargetCombat(combat)
    
    self.combat = combat        
end

function UIAttackBoard:zhencha_call(sender, eventType)

    
    if self.mainCityLv < luaCfg:get_config_by(1).scoutLv then
        
        global.tipsMgr:showWarning("UnlockAction",luaCfg:get_config_by(1).scoutLv)
        return
    end

     local openCall = function()
        
        global.troopData:setAttackType(self:getCurCityType())
        global.troopData:setTargetData(3)   
        global.panelMgr:openPanel("UITroopPanel")
    end
    
    local isProtect = self:isSelfProtect()
    
    if self.city and self.city:isOwner() then

        global.tipsMgr:showWarning("CantSpyOnSelf")
    elseif self.city.isWildRes and not self.city:isOccupire() then

        global.tipsMgr:showWarning("WonderSeeNo")
    else
        if isProtect then

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("ProtectMarch", self:callDeProtectCall(openCall))
        else

            openCall()
        end    
    end       
end

function UIAttackBoard:checkSelect1(sender, eventType)
    self.attack_new_cb1:setEnabled(false)
    self.attack_new_cb2:setEnabled(true)    
    
    self.attack_new_cb1.icon:loadTexture('ui_surface_icon/attack_new_icon3.png',ccui.TextureResType.plistType)
    self.attack_new_cb2.icon:loadTexture('ui_surface_icon/attack_new_icon2.png',ccui.TextureResType.plistType)

    self.Text_cb1:setTextColor(cc.c3b(255,226,165))
    self.Text_cb2:setTextColor(cc.c3b(214,165,108))

    global.g_worldview.worldPanel.lForce = 0
    
    self:onEnter()
end

function UIAttackBoard:checkSelect2(sender, eventType)
    self.attack_new_cb1:setEnabled(true)
    self.attack_new_cb2:setEnabled(false)

    self.attack_new_cb1.icon:loadTexture('ui_surface_icon/attack_new_icon4.png',ccui.TextureResType.plistType)
    self.attack_new_cb2.icon:loadTexture('ui_surface_icon/attack_new_icon1.png',ccui.TextureResType.plistType)

    self.Text_cb1:setTextColor(cc.c3b(255,226,165))
    self.Text_cb2:setTextColor(cc.c3b(214,165,108))
    global.g_worldview.worldPanel.lForce = 1
    
    self:onEnter()
end
--CALLBACKS_FUNCS_END

--攻击资源据点时，军事行动的尖角位置调整
function UIAttackBoard:changeSharpPos(isRestore,isNotWild)
    if isRestore then
        if self.touchEventListener then
            cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
            self.touchEventListener = nil
        end
        self.root.Node_1.Image_2:setPositionX(self.originPosX)
        self.root.Node_1.Image_2:setFlippedX(false)
        self.m_isWild = false
    else
        self:initTouch()
        self.root.Node_1.Image_2:setPositionX(190)
        -- self.root.Node_1.Image_2:setFlippedX(true)
        self.m_isWild = true

        if isNotWild then self.m_isWild = false end
    end
end

function UIAttackBoard:setCity( city , needPower )
    
    self.city = city
    self.needPower = needPower or 0
end

function UIAttackBoard:getAvatarType()
    
    return self.city:getAvatarType()
end

function UIAttackBoard:initTouch()
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end

    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(true)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        -- body
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        self:onCloseHandler()
    end, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.root.Node_1)
end

function UIAttackBoard:onCloseHandler()
    self:close()
end

function UIAttackBoard:close()
    self:changeSharpPos(true)
    self:removeFromParent()
end

return UIAttackBoard

--endregion
