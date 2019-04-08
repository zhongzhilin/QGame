--region PetMgr.lua
--Author : yyt

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData

local PetMgr  = class("PetMgr", function() return gdisplay.newWidget() end )
local UIPetTime = require("game.UI.pet.UIPetTime")

function PetMgr:ctor()
    self.cityView = global.g_cityView
end

function PetMgr:onEnter()

    -- 解除封印
    self:addEventListener(global.gameEvent.EV_ON_PET_UNLOCK, function ()
        if self.createPet then
            self:createPet()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_PET_REFERSH, function (event, friNum)
        if self.createPet then
            self:createPet(friNum)
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.createPet then
            self:createPet()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.createPet then
            self:createPet()
        end
    end)

	self:createPet()
end

function PetMgr:createPet(friNum)

	if self.m_pet then
		self.m_pet:removeFromParent()
		self.m_pet = nil
	end

    local fightPet = global.petData:getGodAnimalByFighting()
    self.fightPet = fightPet
	if fightPet then

        local isFy = fightPet.serverData.lState == 2 or fightPet.serverData.lState == 3
        if isFy then
        else
            local petConfig = global.petData:getPetConfig(fightPet.type, fightPet.serverData.lGrade)
    		local node = resMgr:createCsbAction(petConfig.Animation, "animation0" , true)
            node:setScale(fightPet.scale1[petConfig.growingPhase])
    		local posNode = self.cityView:getScrollViewLayer("pet_pos")
    		local x, y = posNode:getPosition()
    		node:setPosition(cc.p(x-10, y+15))
    		uiMgr:configUITree(node)
    		self.cityView:getScrollViewLayer("pet"):addChild(node, 99998)
            self.m_pet = node

            -- 内城好感cd特效播放
            if friNum and friNum > 0 then
                self:playEffect(friNum)
            end

        end

        self:createTime(self.fightPet)
	end
end

-- 好感增加effect
function PetMgr:playEffect(friNum)
    -- body
    if not tolua.isnull(self.effectAction) then
        self.effectAction:removeFromParent()
    end
    gevent:call(gsound.EV_ON_PLAYSOUND,"pet_interactive")
    local addAction, nodeTimeLine = resMgr:createCsbAction("pet/petFriend_effect","animation0",false,true)
    addAction:setPosition(self.m_pet:getPosition())            
    self.cityView:getScrollViewLayer("pet"):addChild(addAction, 9999999)
    uiMgr:configUITree(addAction)    
    addAction.effect.addEffect:setVisible(false)
    addAction.effect.addEffect1:setVisible(true)
    addAction.effect.addEffect1:setOpacity(0)
    addAction.effect.addEffect1.addEffectNum1:setString(friNum) 
    self.effectAction = addAction
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function ()
        gevent:call(gsound.EV_ON_PLAYSOUND,"pet_feelup")
    end)))
end

-- 2 封印中 3 可解封
function PetMgr:createTime(data)

    if self.item then
        self.item:removeFromParent()
        self.item = nil
    end

    if self.fyDown then
        self.fyDown:removeFromParent()
        self.fyDown = nil
    end

    if self.fyUp then
        self.fyUp:removeFromParent()
        self.fyUp = nil
    end

    local item = UIPetTime.new()
    item:setData(data)
    local posNode = self.cityView:getScrollViewLayer("pet_pos")
    local x, y = posNode:getPosition()
    item:setPosition(cc.p(x-115, y+210))
    self.cityView:getScrollViewLayer("pet"):addChild(item, 99999)
    self.item = item

    local isFy = data.serverData.lState == 2 or data.serverData.lState == 3
    if isFy  then    
        -- up
        local nodeUp = resMgr:createCsbAction("effect/fengyin_up", "animation0" , true)
        local posNode = self.cityView:getScrollViewLayer("pet_pos")
        local x, y = posNode:getPosition()
        nodeUp:setPosition(cc.p(x-10, y+30))
        uiMgr:configUITree(nodeUp)
        self.cityView:getScrollViewLayer("pet"):addChild(nodeUp, 99999)
        self.fyUp = nodeUp

        -- down
        local nodeDown = resMgr:createCsbAction("effect/fengyin_down", "animation0" , true)
        local posNode = self.cityView:getScrollViewLayer("pet_pos")
        local x, y = posNode:getPosition()
        nodeDown:setPosition(cc.p(x-5, y+10))
        uiMgr:configUITree(nodeDown)
        self.cityView:getScrollViewLayer("pet"):addChild(nodeDown, 99997)
        self.fyDown = nodeDown

    end

end

-- 怪物是否存在
function PetMgr:isExitBoss()
    return self.m_pet ~= nil
end

function PetMgr:onTouchBegan(touch, event)
    return true
end

function PetMgr:onTouchMoved(touch, event)
end

local last = ""
function PetMgr:onTouchEnded(touch, event)

	local pos = touch:getLocation()
    if self:checkTouched(pos) then
        -- gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_"..self.surfaceData.id)
        local music = "pte_dianji_"..self.fightPet.type
        if last ~= "" then 
            gsound.stopEffect(last)
        end 
        last = music 
        gevent:call(gsound.EV_ON_PLAYSOUND,music)
        self.cityView:getTouchMgr():setNoTouchBuild()
        if self.fightPet.serverData and self.fightPet.serverData.lState == 2 then -- 封印状态
            global.tipsMgr:showWarning("petSeal")
        elseif self.fightPet.serverData and self.fightPet.serverData.lState == 3 then -- 可解封状态

            global.petApi:actionPet(function (msg)

                self:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), cc.CallFunc:create(function ()
                    global.petData:updateGodAnimal(msg.tagGodAnimal or {})
                    gevent:call(global.gameEvent.EV_ON_PET_UNLOCK)
                end)))

                -- 播放解封特效
                gevent:call(gsound.EV_ON_PLAYSOUND,"pet_seal")
                local nodeOpen = resMgr:createCsbAction("effect/fenyin_over", "animation0" , false, true)
                local posNode = self.cityView:getScrollViewLayer("pet_pos")
                local x, y = posNode:getPosition()
                nodeOpen:setPosition(cc.p(x-12, y+25))
                uiMgr:configUITree(nodeOpen)
                self.cityView:getScrollViewLayer("pet"):addChild(nodeOpen, 9999999)

            end, 4, self.fightPet.type)

        else
    	   global.panelMgr:openPanel("UIPetInfoPanel"):setData(self.fightPet)
        end
    end
end

function PetMgr:checkTouched(touchPos)
   	
    local scrollPos = self.cityView:getScrollViewLayer("pet"):convertToNodeSpace(touchPos)   

    local rectSp = nil
    if self.fyUp then
        rectSp = self.fyUp.rectLayout
    elseif self.m_pet then
        rectSp = self.m_pet.rectLayout
    end
    if not rectSp then return false end

    local isIn = self:checkRectContainsPoint(self:getTouchRect(rectSp), scrollPos)
    if isIn then
        return true
    else
    	return false
    end
end

function PetMgr:getTouchRect(rectSp)

    local rect = rectSp:getBoundingBox()
    local pos = cc.p(rectSp:getParent():getPosition())
    rect.x = pos.x+rect.x
    rect.y = pos.y+rect.y
    return rect
end

function PetMgr:checkRectContainsPoint(i_rect,pos)
    local isIn = false
    if i_rect.x == nil then
        --i_rect 包含多个rect
        for i,rect in pairs(i_rect) do
            if cc.rectContainsPoint(rect, pos) then
                isIn= true
                break
            end
        end
    else
        isIn = cc.rectContainsPoint(i_rect, pos)
    end
    return isIn
end

return PetMgr