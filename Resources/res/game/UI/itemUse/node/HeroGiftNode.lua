local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local HeroGiftNode = class("HeroGiftNode", function() return gdisplay.newWidget() end )

function HeroGiftNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function HeroGiftNode:onEnter() 
    
    self.lockRestTime = 0
end

function HeroGiftNode:initUI(callFunc)

    self.unLockQueue = callFunc
    self.panel.queueUnlock_node:setVisible(true)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(luaCfg:get_local_string(10347))
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)

end

function HeroGiftNode:setItemData(data)


    local spaceStr = self.panel.spaceNum:getString()

    if data.itemId == 6 then

        global.panelMgr:setTextureFor(self.panel.icon,"icon/item/hero_item_1.png")

        self.panel.slider:setVisible(true)  

        self.panel.speedTime_node:setVisible(true)

        local queueData = luaCfg:get_item_impression_by(6)

        local diamonm  = tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

        local maxCount =math.floor(diamonm / queueData.num)

        self.panel.sliderControl:setMaxCount(maxCount)

        if maxCount <= 0  then        
            self.panel.sliderControl:reSetMaxCount(0)
        end

        self.panel.itemDes:setString("testsetawt ")
        
        self.panel.mojing_node:setVisible(false)

        self.panel.need:setString("2000")
    else

        -- 说服英雄所需要的好感度
        local preImpress = 0 
   
        preImpress  = global.luaCfg:get_hero_property_by(self.panel.buildingId).impress - global.heroData:getHeroImpress(self.panel.buildingId)

        local needCount =math.ceil( preImpress / global.funcGame:getItemImpress(data.itemId))

        local itemCount = normalItemData:getItemById(data.itemId).count
        if itemCount <= 0  then
            self.panel:itemCountNotEnough(spaceStr, data.itemName)
            self.panel.speedUseText:setString(string.format(luaCfg:get_local_string(10339),global.funcGame:getItemImpress(data.itemId)))
            self.panel.speedTime:setString("")
        else

            local maxCount = 0
            if itemCount >= needCount then 
                if needCount == 0 then needCount =1 end -- 触发满了之后 招募。
                maxCount = needCount
            else 
                maxCount = itemCount
            end
            
            self.panel.btnUse:setEnabled(true)
            self.panel.sliderControl:setMaxCount(maxCount)
            if maxCount == 1 then
                self.panel.sliderControl:reSetMaxCount(1)
            end
            self.panel.speedUseText:setString(string.format(luaCfg:get_local_string(10339),global.funcGame:getItemImpress(data.itemId)))
            self.panel.speedTime:setString("")
        end
    end
end

function HeroGiftNode:sendGift()
    
    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
    local number = tonumber(self.panel.cur:getString())
    local itemId = item.data.itemId

    global.commonApi:heroAction(self.panel.buildingId, 2, 4, itemId, number, function(msg)

        if  msg.tgHero then 

            global.panelMgr:getPanel('UIHeroPanel').heroCome:addGiftEffect()

            global.persuadePanelItemId  = 6
            global.persuadePaneState =  0 
            global.persuadePanelCall = nil 

            local preImpress = 0 

            if global.heroData:getHeroDataById(self.panel.buildingId).serverData then 

                 preImpress =  global.heroData:getHeroDataById(self.panel.buildingId).serverData.lImpress or 0 
            end 
            
            local confData = luaCfg:get_hero_property_by(self.panel.buildingId)
            local heroName = confData.name      


            local addImpress = msg.tgHero[1].lImpress - preImpress


            local impressisFull  = function () 

                local royalImpress  = global.heroData:getHeroRoyalImpress(self.panel.buildingId)
                local impressData = luaCfg:get_hero_property_by(self.panel.buildingId)

                return (royalImpress + msg.tgHero[1].lImpress ) >= impressData.impress
            end

            if msg.tgHero[1].lState == 0 then --0表示成功

                global.panelMgr:openPanel("UIGotHeroPanel"):setData(confData)
             
            else

                if impressisFull()  then -- 判断是否可以直接招募

                    global.tipsMgr:showWarning("HeroImpressMax")

                else 

                    if addImpress  < 1  then 

                         global.persuadePaneState = -1 
                    end 

                    if global.heroData:isFull() and addImpress < 1  then

                        global.tipsMgr:showWarning("HeroPersuadeLimit")

                    else
                        global.tipsMgr:showWarning("PersuadeFailed",heroName,addImpress) 
                    end
                end 
              
            end

            global.heroData:updateVipHero(msg.tgHero[1]) -- 更新数据  和 刷 新 界面

            global.panelMgr:closePanel("UISpeedPanel")
        end 
    end)
end

return HeroGiftNode
    