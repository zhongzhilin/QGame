--region BossMgr.lua
--Author : yyt

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData

local BossMgr  = class("BossMgr", function() return gdisplay.newWidget() end )

function BossMgr:ctor()
    self.cityView = global.g_cityView
end

function BossMgr:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_REFERSHITEM, function (event, msg)
        self:createBoss()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_FLUSH, function ()
        self:createBoss()
    end) 

    self:addEventListener(global.gameEvent.EV_ON_UI_BOSS_MISS, function ()
        if self.m_monster then
            self.m_monster:removeFromParent()
            self.m_monster = nil
        end

        if self.m_monsterEff then
            self.m_monsterEff:removeFromParent()
            self.m_monsterEff = nil
        end
        
    end)

	self:createBoss()
end

function BossMgr:createBoss()
	
	local curFightId = 0
	self.fightBoss = global.bossData:getFightBoss()
	if self.fightBoss then
		curFightId = self.fightBoss.id
	end

	if self.m_monster then
		self.m_monster:removeFromParent()
		self.m_monster = nil
	end

    if self.m_monsterEff then
        self.m_monsterEff:removeFromParent()
        self.m_monsterEff = nil
    end

	if curFightId > 0 then

		local gateData = luaCfg:get_gateboss_by(curFightId)
		local wildData = luaCfg:get_wild_monster_by(gateData.monsterID)
		local surfaceData = luaCfg:get_world_surface_by(wildData.file)
        self.surfaceData = surfaceData
		local node = resMgr:createCsbAction(surfaceData.worldmap, "animation0" , true)
		local posNode = self.cityView:getScrollViewLayer("boss_pos")
		local x, y = posNode:getPosition()
		node:setPosition(cc.p(x, y))
		uiMgr:configUITree(node)
		self.cityView:getScrollViewLayer("buildings"):addChild(node, 99998)
        self.m_monster = node

        -- 特效
        local nodeEff = resMgr:createCsbAction("effect/boss_at_city", "animation0" , true)
        local posNode = self.cityView:getScrollViewLayer("boss_pos")
        local x, y = posNode:getPosition()
        nodeEff:setPosition(cc.p(x, y))
        self.cityView:getScrollViewLayer("buildings"):addChild(nodeEff, 99999)
		self.m_monsterEff = nodeEff
	end

end

-- 怪物是否存在
function BossMgr:isExitBoss()
    return self.m_monster ~= nil
end

function BossMgr:onTouchBegan(touch, event)
    return true
end

function BossMgr:onTouchMoved(touch, event)
end

function BossMgr:onTouchEnded(touch, event)

	local pos = touch:getLocation()
    if self:checkTouched(pos) then
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_wild_"..self.surfaceData.id)
        self.cityView:getTouchMgr():setNoTouchBuild()
    	global.panelMgr:openPanel("UIBosMonstPanel"):setData(self.fightBoss)
    end
end

function BossMgr:checkTouched(touchPos)
   	
   	if not self.m_monster then return end
    local scrollPos = self.cityView:getScrollViewLayer("buildings"):convertToNodeSpace(touchPos)   
    local isIn = self:checkRectContainsPoint(self:getTouchRect(), scrollPos)
    if isIn then
        return true
    else
    	return false
    end
end

function BossMgr:getTouchRect()

	local rectSp = self.m_monster.size_export
    local rect = rectSp:getBoundingBox()
    local pos = cc.p(rectSp:getParent():getPosition())
    rect.x = pos.x+rect.x
    rect.y = pos.y+rect.y
    return rect
end

function BossMgr:checkRectContainsPoint(i_rect,pos)
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

return BossMgr