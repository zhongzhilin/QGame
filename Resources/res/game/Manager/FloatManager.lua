
local define = global.define

local luaCfg = global.luaCfg

local panelMgr = nil

local cast = tolua.cast

local _Manager = {
    
    list = {}
}

-- start up
-------------------------------------------------------
function _Manager:startup()
    panelMgr = global.panelMgr

    self:reset()
end

-- shut down
-------------------------------------------------------
function _Manager:shutdown()
    panelMgr = nil

    self:reset()
end

-- reset
-------------------------------------------------------
function _Manager:reset()
    for _, container in pairs(self.list) do
        self:clearContainerFloatText(container)
    end

    self.list = {}
end

function _Manager:clearContainerFloatText(container)
    if container == nil then
        return
    end

    -- data list
    container.floatDataList = {}

    -- item list
    local itemList = container.floatItemList or {}
    for i=#itemList, 1, -1 do
        local item = itemList[i]
        item:stopAllActions()
        self:removeItemFromContainer(item, container)
    end
    container.floatItemList = {}
end

function _Manager:runCommonFloatText(container, position, text, color, scale)

    self:runFloatText(container, position, text, color, scale)
end

function _Manager:runBattleFloatText(position, text, color)
    local battleScene = global.scMgr:getBattleScene()
    if battleScene == nil then
        return
    end

    local container = battleScene:getBattleField()
    if container == nil then
        return
    end
    
    self:runFloatText(container, position, text, color, scale, delayTime)
end

function _Manager:runCampaignFloatText(position, text, color)
    local container = panelMgr:getPanel("UICampaignPanel")

    self:runFloatText(container, position, text, color)
end

function _Manager:runItemFloatText(container, position, tid, value, delayTime)
    
    local text = value
    local color = self:getFloatTextColor(tid)
    local scale = 1

    self:runFloatText(container, position, text, color, scale, delayTime)
end

-- run hero float text
------------------------------------------------------
function _Manager:runHeroGrowFloatText(text, delayTime)
    local panel = panelMgr:getPanel("UIHeroInfoPanel")
    if panel == nil then
        return
    end
    
    local avatarContainer = panel:getAvatarContainer()
    if avatarContainer == nil then
        return
    end

    local worldPosition = avatarContainer:getWorldPosition()
    local position = cc.p(worldPosition.x, worldPosition.y + 30)

    local color = define.COLOR_FLOAT_TEXT_AVATAR
    local scale = 0.8

    self:runFloatText(panel, position, text, color, scale, delayTime)
end

function _Manager:runHeroFloatText(container, position, text, delayTime)
    local color = define.COLOR_FLOAT_TEXT_AVATAR
    local scale = 0.8

    self:runFloatText(container, position, text, color, scale, delayTime)
end

-- run building float text
------------------------------------------------------
function _Manager:runBuildingFloatText(bid, tid, text)
    local panel = panelMgr:getPanel("UIMainCity")
    if panel == nil then
        return
    end
    
    local container = panel:getScrollViewContainer()
    if container == nil then
        return
    end
    
    local buildingView = panel:getBuildingViewByID(bid)
    if buildingView == nil then
        return
    end

    local px, py = buildingView:getPosition()
    local position = cc.p(px, py + 30)

    local color = self:getFloatTextColor(tid)

    self:runFloatText(container, position, text, color)
end

function _Manager:runMapFloatText(position, tid, text, delayTime)
    local panel = panelMgr:getPanel("PVPMapPanel")
    if panel == nil then
        return
    end

    local container = panel:getMapAreaNode()
    if container == nil then
        return
    end

    local color = self:getFloatTextColor(tid)
    local scale = 1

    self:runFloatText(container, position, text, color, scale, delayTime)
end

-- run float text
------------------------------------------------------
function _Manager:runFloatText(container, position, text, color, scale, delayTime, 
                                                        fadeInMove, fadeInTime, 
                                                        normalMove, normalTime, 
                                                        fadeOutMove, fadeOutTime)
    -- check float data list
    if container.floatDataList == nil then
        container.floatDataList = {}
    end

    local data = {}
    data.container = container
    data.position = position
    data.text = text
    data.color = color
    data.scale = scale or 1
    data.delayTime = delayTime or 0
    data.fadeInMove = fadeInMove or cc.p(0, 30)
    data.fadeInTime = fadeInTime or 0.2
    data.normalMove = normalMove or cc.p(0, 10)
    data.normalTime = normalTime or 0.2
    data.fadeOutMove = fadeOutMove or cc.p(0, 10)
    data.fadeOutTime = fadeOutTime or 0.2

    table.insert(container.floatDataList, data)

    local onLoopHandler = function()
        local count = #container.floatDataList
        if count == 0 then
            container:stopAction(container.floatAction)
            container.floatAction = nil
            return
        end

        local data = table.remove(container.floatDataList, 1)
        local label = self:generateFloatText(data.text, data.color, data.scale)

        self:controlFloatText(container, label, data.position, data.delayTime,
                                                data.fadeInMove, data.fadeInTime, 
                                                data.normalMove, data.normalTime,
                                                data.fadeOutMove, data.fadeOutTime)
    end

    if not container.floatAction then
        local interval = 1 / 10
        local array = CCArray:create()
        array:addObject(CCDelayTime:create(interval))
        array:addObject(CCCallFunc:create(onLoopHandler))

        container.floatAction = CCRepeatForever:create(CCSequence:create(array))
        container:runAction(container.floatAction)
    end

    -- list
    local index = table.indexOf(self.list, container)
    if index == -1 then
        table.insert(self.list, container)
    end
end

function _Manager:controlFloatText(container, label, position, delayTime, 
                                                    fadeInMove, fadeInTime, 
                                                    normalMove, normalTime, 
                                                    fadeOutMove, fadeOutTime)

    -- check float item list
    if container.floatItemList == nil then
        container.floatItemList = {}
    end

    local renderer = label.renderer
    if renderer == nil then
        return
    end

    self:addItemToContainer(label, container)
    
    local onCallBackHandler = function()
        renderer:stopAllActions()
        self:removeItemFromContainer(label, container)
    end

    -- set position
    label:setPosition(position)

    -- delay
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(delayTime))

    -- move and fade in 
    local move = CCMoveTo:create(fadeInTime, fadeInMove)
    local fade = CCFadeIn:create(fadeInTime)
    array:addObject(CCSpawn:createWithTwoActions(move, fade))

    -- move
    local px = fadeInMove.x + normalMove.x
    local py = fadeInMove.y + normalMove.y
    local move = CCMoveTo:create(normalTime, cc.p(px, py))
    array:addObject(move)

    -- move and fade out 
    local px = fadeInMove.x + normalMove.x + fadeOutMove.x
    local py = fadeInMove.y + normalMove.y + fadeOutMove.y
    local move = CCMoveTo:create(fadeOutTime, cc.p(px, py))
    local fade = CCFadeOut:create(fadeOutTime)
    array:addObject(CCSpawn:createWithTwoActions(move, fade))

    -- call back
    array:addObject(CCCallFunc:create(onCallBackHandler))
    
    -- run
    local action = CCSequence:create(array)
    renderer:runAction(action)
end

function _Manager:generateFloatText(text, color, scale)
    local label = global.uiMgr:createLabel()
    label:setFontSize(28)
    label:setOpacity(0)
    label:setText(text)
    label:setColor(color)
    label:setScale(scale)
    
    label.renderer = cast(label:getVirtualRenderer(), "CCLabelTTF")
    label.renderer:enableStroke(cc.c3b(68,34,7), 2)

    return label
end

function _Manager:getFloatTextColor(tid)
    local color = define.COLOR_WHITE
    if tid == HQCONST.TID_GOLD then
        color = define.COLOR_FLOAT_TEXT_GOLD
    elseif tid == HQCONST.TID_ORE then
        color = define.COLOR_FLOAT_TEXT_ORE
    elseif tid == HQCONST.TID_POINT then
        color = define.COLOR_FLOAT_TEXT_POINT
    end
    return color
end

function _Manager:addItemToContainer(item, container)
    local index = table.indexOf(container.floatItemList, item)
    if index == -1 then
        table.insert(container.floatItemList, item)
    end

    if global.uiMgr:isWidget(container) then
        if global.uiMgr:isWidget(item) then
            container:addChild(item, 999)
        else
            container:addNode(item, 999)
        end
    else
        container:addChild(item, 999)
    end
end

function _Manager:removeItemFromContainer(item, container)
    local index = table.indexOf(container.floatItemList, item)
    if index ~= -1 then
        table.remove(container.floatItemList, index)
    end

    if global.uiMgr:isWidget(container) then
        if global.uiMgr:isWidget(item) then
            container:removeChild(item, true)
        else
            container:removeNode(item)
        end
    else
        container:removeChild(item, true)
    end
end

global.floatMgr = _Manager