--create by wuwx
--note:this class which is the set of actionAPI

local luaCfg = global.luaCfg
local panelMgr = global.panelMgr


local _Manager = {}

--move
--node:parent of all items
--node.inAction = {{target=target,dp=cc.p(600,0)},{target=target,dp=cc.p(-600,0)}}
--node.outAction = {{target=target,dp=cc.p(600,0)},{target=target,dp=cc.p(-600,0)}}
-- self.inActions = {
--     {target = self.m_titlePanel:getChildByName("node_title"),dp = cc.p(0,600)},
--     {target = self.m_titlePanel:getChildByName("image_2"),dp = cc.p(0,0), opacity = 0},
--     {target = self.m_leftPanel, dp = cc.p(-600,0)},
--     {target = self.m_rightPanel,dp = cc.p(600,0)},
-- }
function _Manager:dynamicMoveIn(node,callback)
    local actionTargets = node.inActions
    if not node.isDoing then
    	print("dynamicMoveIn:node.isDoing=false")
        node.isDoing = true 
        local overCall = function() 
            node.isDoing = false 
            if callback then callback() end
            print("callback")
        end
        for i = 1, #actionTargets do
            local targetItem = actionTargets[i]
            local target = targetItem.target
            local dp = targetItem.dp
            local opacity = targetItem.opacity
            local dt = targetItem.dt
            local speedType = targetItem.speedType
            if i >= #actionTargets then
                self:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            else
                self:moveInFromAnyOrient(target,dp,opacity,dt,speedType)
            end
        end
        if not actionTargets or #actionTargets <= 0 then
            overCall()
        end
    end
end


function _Manager:dynamicMoveOut(node,callback)
    local actionTargets = node.outActions
    if not node.isDoing then
    	print("dynamicMoveOut:node.isDoing=false")
        node.isDoing = true 
        local overCall = function() 
            node.isDoing = false 
            if callback then callback() end
        end
        for i = 1, #actionTargets do
            local targetItem = actionTargets[i]
            local dp = targetItem.dp
            local target = targetItem.target
            local opacity = targetItem.opacity
            local dt = targetItem.dt
            local speedType = targetItem.speedType
            if i >= #actionTargets then
                self:moveOutFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            else
                self:moveOutFromAnyOrient(target,dp,opacity,dt,speedType)
            end
        end
        if not actionTargets or #actionTargets <= 0 then
        	overCall()
        end
    end 
end

--从任何方位移入item
function _Manager:moveInFromAnyOrient(target,dp,opacity,dt,speedType,func)
    if not target or not target:isVisible() then return end
    target:stopAllActions()
    local initDt = dt or 0.2
    local initdp = dp or cc.p(600, 0)
    local startOpacity = opacity
    local originVisi = target:isVisible()

    target:setVisible(false)
    local originPos = cc.p(target:getPosition())
    local initPos = cc.p(originPos.x+initdp.x, originPos.y+initdp.y)
    local dt = initDt
    local ationT = {
        cc.Place:create(originPos),
        cc.Show:create(),
    }
    if startOpacity then
        target:setOpacity(startOpacity)

        if speedType == "cc.EaseBackOut" then
            table.insert(ationT,cc.Spawn:create(cc.EaseBackOut:create(cc.MoveTo:create(dt, initPos)),cc.FadeIn:create(dt)))
        else
            table.insert(ationT,cc.Spawn:create(cc.MoveTo:create(dt, initPos),cc.FadeIn:create(dt)))
        end
    else
        if speedType == "cc.EaseBackOut" then
            table.insert(ationT,cc.EaseBackOut:create(cc.MoveTo:create(dt, initPos)))
        else
            table.insert(ationT,cc.MoveTo:create(dt, initPos))
        end
    end
    table.insert(ationT,cc.CallFunc:create(function() 
        if func then func() end
    end))
    target:runAction(cc.Sequence:create(ationT))
end

--从任何方位移出item
function _Manager:moveOutFromAnyOrient(target,dp,opacity,dt,speedType,func)
    if not target then return end
    target:stopAllActions()
    local initDt = dt or 0.2
    local initdp = dp or cc.p(600, 0)
    local startOpacity = opacity

    target:setVisible(false)
    local originPos = cc.p(target:getPosition())
    local initPos = cc.p(originPos.x+initdp.x, originPos.y+initdp.y)
    local dt = initDt

    local ationT = {
        cc.Place:create(originPos),
        cc.Show:create(),
    }
    if startOpacity then
        target:setOpacity(startOpacity)

        if speedType == "cc.EaseBackIn" then
            table.insert(ationT,cc.Spawn:create(cc.EaseBackIn:create(cc.MoveTo:create(dt, initPos)),cc.FadeOut:create(dt)))
        else
            table.insert(ationT,cc.Spawn:create(cc.MoveTo:create(dt, initPos),cc.FadeOut:create(dt)))
        end
    else
        if speedType == "cc.EaseBackIn" then
            table.insert(ationT,cc.EaseBackIn:create(cc.MoveTo:create(dt, initPos)))
        else
            table.insert(ationT,cc.MoveTo:create(dt, initPos))
        end
    end
    table.insert(ationT,cc.CallFunc:create(function() 
        if func then func() end
    end))
    target:runAction(cc.Sequence:create(ationT))
end

-- 面板切换动画
function _Manager:openPanelForAction(curPanelName, nextPanelName,time)
    


    time = time or 0.2
    global.uiMgr:addSceneModel(time+0.5)

    local curPanel = global.panelMgr:getPanel(curPanelName)
    local nextPanel = global.panelMgr:getPanel(nextPanelName)

    if (not curPanel) or (not nextPanel) then 
        -- protect 
        return 
    end 

    nextPanel:stopAllActions()
    curPanel:stopAllActions()

    
    if curPanel:getActionByTag(1024) then        
        return
    end

    local function CallBack()
        global.panelMgr:openPanel(nextPanelName)
        nextPanel:setPosition(cc.p(gdisplay.width, 0))
    end
    local function CallBack1()
        nextPanel:runAction(cc.MoveTo:create(time, cc.p(0, 0)))
    end

    local _curPanelMove = cc.MoveBy:create(time, cc.p(-gdisplay.width, 0))
    local _panelAction = cc.Spawn:create(_curPanelMove, cc.CallFunc:create(CallBack1))

    local spa =  cc.Sequence:create(cc.CallFunc:create(CallBack), _panelAction,_curPanelMove:reverse())
    spa:setTag(1024)
    curPanel:runAction(spa)
end

function _Manager:closePanelForAction(curPanelName, nextPanelName)

    -- print("closePanelForAction in start curPanelName:",curPanelName,"nextPanelName:",nextPanelName,debug.traceback())


    local curPanel = global.panelMgr:getPanel(curPanelName)
    local nextPanel = global.panelMgr:getPanel(nextPanelName)

    nextPanel:stopAllActions()
    curPanel:stopAllActions()

    if curPanel:getActionByTag(1024) then        
        return
    end

    local len = (gdisplay.width - curPanel:getPositionX()) 
    local time = len / gdisplay.width * 0.1
    global.uiMgr:addSceneModel(time+0.5)

    local function CallBack()
        -- if nextPanel:getPositionX() == 0 then
            -- nextPanel:setPosition(cc.p(-gdisplay.width, 0))
        -- end
    end
    local function CallBack1()

        nextPanel:runAction(cc.MoveTo:create(time, cc.p(0, 0)))
    end
    local function CallBack2()
        curPanel:setPosition(cc.p(0, 0))
        global.panelMgr:closePanel(curPanelName)
    end 
    
    local _curPanelMove = cc.MoveTo:create(time, cc.p(gdisplay.width, 0))
    local moveAction = cc.Spawn:create(_curPanelMove, cc.CallFunc:create(CallBack1))
    local seq =  cc.Sequence:create(cc.CallFunc:create(CallBack), moveAction,cc.CallFunc:create(CallBack2))
    seq:setTag(1024)
    curPanel:runAction(seq)

end

-- 二级模态界面打开动画
function _Manager:openModelAction(panelWidget)
    
    print("===> openModelAction node name: "..panelWidget:getName())
    if panelWidget.Node then

        global.uiMgr:addSceneModel(0.25)

        local rootNode = panelWidget.Node
        local orginScale = rootNode.orginScale or 1 
        rootNode:setScale(orginScale - 0.15)
        rootNode:setAnchorPoint(cc.p(0.5, 0.5)) 

        local action1 = cc.EaseBackIn:create(cc.ScaleTo:create(0.1, orginScale+0.2))
        local action2 = cc.EaseBackOut:create(cc.ScaleTo:create(0.2, orginScale))
        local action = cc.Spawn:create(action1, action2)
        rootNode:runAction(cc.Sequence:create(action, cc.CallFunc:create(function ()
            gevent:call(global.gameEvent.EV_ON_OPENPANEL_ACTIONOVER, panelWidget:getName())
        end)))
    
    end

end

function _Manager:closeModelAction(panelWidget, exitCall, isNoCloseSound)

    print("===> closeModelAction node name: "..panelWidget:getName())
    local panelName = panelWidget:getName()
    if panelWidget.Node then

        global.uiMgr:addSceneModel(0.25)
        local rootNode = panelWidget.Node
        rootNode:setScale(1)
        rootNode:setAnchorPoint(cc.p(0.5, 0.5))

        local actionList = {
            cc.ScaleTo:create(0.1, 1.05),
            cc.ScaleTo:create(0.1, 0.95),
            cc.DelayTime:create(0),
            cc.CallFunc:create(function ()
                exitCall()
            end),
        }
        rootNode:runAction(cc.Sequence:create(actionList))

    else
        exitCall()
    end
end

global.sactionMgr = _Manager