--region CitySoldierMgr.lua
--Author : yyt

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData

local CitySoldierMgr  = class("CitySoldierMgr", function() return gdisplay.newWidget() end )

function CitySoldierMgr:ctor()
    self.cityView = global.g_cityView
end

function CitySoldierMgr:onEnter()


    print("############ CitySoldierMgr:onEnter() ########## >>>>>>>>>>>>>>>>>>>>>>> ")

    --  初始化校场部队士兵  
    self:createSoldier()

    self:addEventListener(global.gameEvent.EV_ON_CITY_SOLDIERS_REFRESH, function ()
        self:refershSoldier()
    end) 

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH, function ()
        self:refershSoldier()
    end) 

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()

        -- local allNode = self.cityView:getScrollViewLayer("buildings"):getChildren()
        -- for _,v in pairs(allNode) do
            
        --     if v:getTag() == 010 then
        --         v:removeFromParent()
        --     end
        -- end
        self:refershSoldier()
        -- self:refershSoldier()
        
        -- if self.isPlay then 
        --     self.isPlay = false
        -- end

    end) 

end

function CitySoldierMgr:onExit()
    global.troopData:removeAllTroop()
end

function CitySoldierMgr:initSoldierPara()
    
    self.troopId = 1
    self.isSorldierBorder = false
    self.isTroopBorder = false
    self.isMaxNum = true
    self.soldierId = 0
    self.lineContainer = 0
    self.lastLineType = 0
    self.isPlay = false
    self.soldierType = {}
end

function CitySoldierMgr:createSoldier()

    self:initSoldierPara()

    local troopNum = global.troopData:getCityTroopNum()
    local soldierNum = global.troopData:getCitySoldierNum()
    self.offsetX, self.offsetY = 0, 0
    
    -- 初始化比例显示兵数量
    -- soldierNum = self:proRataSoldier()
    self.soldierType = clone(global.troopData:getSoldierType())
    

    if troopNum > 20 then troopNum = 20 end -- 控制部队数量
    self:checkLine(troopNum, soldierNum, 1, 0)

end

-- 按比例显示兵种
-- 1:10 比例显示 
-- function CitySoldierMgr:proRataSoldier()
--     -- body
--     local rata = {10, 10, 10, 10}

--     local soldierNum = 0
--     local srcSoldier = clone(global.troopData:getSoldierType())
--     for i,v in ipairs(srcSoldier) do       
--         if rata[i] then
--             v.num = math.floor(v.num/rata[i])
--             if v.num < rata[i] and v.num > 0 then
--                 v.num = 1
--             end
--         end
--         soldierNum = soldierNum + v.num
--         table.insert(self.soldierType, v)
--     end
--     return soldierNum
--  end 

function CitySoldierMgr:checkLine( troopNum, soldierNum, line, lineContainer )

    local lineNumTroop = global.troopData.lineNum[1]
    local lineNumSoldier1 = global.troopData.lineNum[2]
    local lineNumSoldier2 = global.troopData.lineNum[3]

    local setX, setY = global.troopData.offsetPos[1].x, global.troopData.offsetPos[1].y
    local setX1, setY1 = global.troopData.offsetPos[2].x,  global.troopData.offsetPos[2].y

    if troopNum > 0 then
        
        if line > 4 then
            lineNumTroop[line] = lineNumTroop[4]
        end

        local putCount = 0
        if troopNum >= lineNumTroop[line] then
            putCount = lineNumTroop[line]
        else
            putCount = troopNum
        end 

        for i=1, putCount do
            
            self:createTroopNode( self.troopId, self.offsetX, self.offsetY, setX*(i-1), setY*(i-1) )
            self.troopId = self.troopId + 1
        end
        self.offsetX = self.offsetX + global.troopData.offset[1].x
        self.offsetY = self.offsetY + global.troopData.offset[1].y

        troopNum = troopNum - putCount
    else

        if soldierNum > 0 then

            local _type, num = 0, 0
            local pic = ""
            
            for _,v in pairs(self.soldierType) do
                
                if v.num > 0 then
                    _type = v.type
                    num = v.num
                    pic = v.pic
                    break 
                end
            end
            local lineNum, offsetId, id = 0, 0, 1

            local tempType = 0
            if not self.isMaxNum then 
                tempType = self.lastLineType 
            else
                tempType = _type
            end
            if tempType == 3 then
                offsetId = 3
                lineNum = lineNumSoldier1[line]
                if line > 4 then lineNum = lineNumSoldier1[4] end
            else
                offsetId = 2
                lineNum = lineNumSoldier2[line]
                if line > 4 then lineNum = lineNumSoldier2[4] end
            end

            self.isMaxNum = true
            if lineContainer == 0 then 
                lineContainer = lineNum 
                id = 1
            else
                id = lineNum - lineContainer + 1
            end

            local putCount = 0
            if num >= lineContainer then
                putCount = lineContainer
            else
                putCount = num
                self.lastLineType = _type
                self.isMaxNum = false
            end 
          
            for i=id, putCount+id-1 do
                self:createSoldierNode( self.troopId, self.offsetX, self.offsetY, setX1*(i-1), setY1*(i-1) , pic)
                self.troopId = self.troopId + 1
            end
            if self.isMaxNum then
                self.offsetX = self.offsetX + global.troopData.offset[offsetId].x
                self.offsetY = self.offsetY + global.troopData.offset[offsetId].y
            end
            self:updateNum(_type, num - putCount)
            soldierNum = soldierNum - putCount

            self.lineContainer = lineContainer - putCount
        end
    end

    if (soldierNum > 0 or troopNum > 0) and (not self.isSorldierBorder) then
        if self.lineContainer == 0 then
            line = line + 1
        end
        self:checkLine(troopNum, soldierNum, line, self.lineContainer)
    end
end

function CitySoldierMgr:createTroopNode( troopId, offsetX, offsetY, setX, setY )

    local borderL =  global.troopData.borderPos[1]  
    local borderX, borderY = borderL[1], borderL[2]  --左上角顶点

    borderX = borderX + offsetX
    borderY = borderY - offsetY
    local posX = borderX + setX
    local posY = borderY + setY

    local  troopNode =  resMgr:createWidget("city/small_soldier_leader")
    troopNode:setPosition(cc.p(posX, posY))
    uiMgr:configUITree(troopNode)
    troopNode:setTag(010)

    -- 旗帜动画
    local animationName = "animation/flag_" .. global.userData:getRace()    
    local flag = resMgr:createWidget(animationName)
    uiMgr:configUITree(flag)
    local flag_TimeLine = resMgr:createTimeline(animationName)
    flag_TimeLine:play("animation0", true)
    flag:runAction(flag_TimeLine)
    troopNode.flag_export:setVisible(false)
    flag:setPosition(troopNode.flag_export:getPosition())
    flag:setScale(0.5)
    flag.flagSp:setVisible(true)
    troopNode:addChild(flag)


    self.cityView:getScrollViewLayer("buildings"):addChild(troopNode)

    local  troopSp, timeLine = resMgr:createCsbAction("animation/city_army_hero","animation0",false) 
    troopSp:setPosition(troopNode.Node_1:getPosition())
    
    troopSp:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(30), cc.CallFunc:create(function ()
            timeLine:gotoFrameAndPlay(0,false)
    end),  cc.CallFunc:create(function ()
        timeLine:setLastFrameCallFunc(function()
            timeLine:pause()
        end)
    end) ))) 

    troopNode:addChild(troopSp)
    global.troopData:addTroopSoldier( "animation/city_army_hero" , timeLine ,troopNode, false )

    local raceId = global.userData:getRace()

end

function CitySoldierMgr:createSoldierNode( troopId, offsetX, offsetY, setX, setY, soldierCsb ) 

    local borderL =  global.troopData.borderPos[1]  
    local borderR =  global.troopData.borderPos[4]  
    local borderX, borderY = borderL[1],  borderL[2]  --左上角顶点
    local borderRX =  borderR[1]                      --右下角顶点

    borderX = borderX + offsetX
    borderY = borderY - offsetY

    local posX = borderX + setX
    local posY = borderY + setY

    if setX == 0 and posX > borderRX then -- 到达边界
        self.isSorldierBorder = true
        return
    end

    if not self.isSorldierBorder then
        local  soldierNode, timeLine =  resMgr:createCsbAction(soldierCsb,"animation0",false)
        soldierNode:setPosition(cc.p(posX, posY))
        soldierNode:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(30), cc.CallFunc:create(function ()
           
            timeLine:gotoFrameAndPlay(0,false)
        end),  cc.CallFunc:create(function ()
            timeLine:setLastFrameCallFunc(function()
                timeLine:pause()
            end)
        end) )))  
        
        soldierNode:setTag(010)
        self.cityView:getScrollViewLayer("buildings"):addChild(soldierNode)
        global.troopData:addTroopSoldier( soldierCsb , timeLine , soldierNode, false )
    end 
end

function CitySoldierMgr:updateNum( _type, num )
    
    for _,v in pairs(self.soldierType) do
        if v.type == _type  then
            v.num = num
        end
    end
end

function CitySoldierMgr:refershSoldier()

    global.troopData:removeAllTroop()
    self:createSoldier()
end

-- 士兵点击事件
function CitySoldierMgr:onTouchBegan(touch, event)

    return true
end

function CitySoldierMgr:onTouchMoved(touch, event)
end

function CitySoldierMgr:onTouchEnded(touch, event)

    -- 连续点击
    if self.isPlay then return  end

    local soldierData = global.troopData:getTroopSoldier()
    -- 循环动画播放
    for _,v in pairs(soldierData) do
        if v.timeLine:isPlaying()  then
            return
        end
    end

    local troopCsb = "animation/city_army_hero"
    local pos = touch:getLocation()
    if self:checkTouched(pos) then
        print(" --------- 选中了士兵：---------- ") 

        local soundKey = "city_soldiers"
        gevent:call(gsound.EV_ON_PLAYSOUND,soundKey)
        
        for _,v in pairs(soldierData) do

            local nodeTimeLine = resMgr:createTimeline(v.soldierCsb)
            nodeTimeLine:play("animation0", false)
            v.soldierNode:runAction(nodeTimeLine)

            local nodeTimeLine1 = resMgr:createTimeline("effect/army_click_effect")
            nodeTimeLine1:play("animation0", false)
            v.soldierNode:runAction(nodeTimeLine1)

            if v.soldierCsb == troopCsb then
                local addAction = resMgr:createCsbAction("effect/army_click_effect","animation0",false,true)
                addAction:setPosition(cc.p(v.soldierNode:getPosition()))            
                self.cityView:getScrollViewLayer("effect"):addChild(addAction, 997)
            end

            self.isPlay = true
        end

        self:runAction(cc.Sequence:create(cc.DelayTime:create(90/60), cc.CallFunc:create(function ()
            self.isPlay = false
        end)))
        return
    end
end

function CitySoldierMgr:checkTouched(touchPos)
   
    local scrollPos = self.cityView:getScrollViewLayer("buildings"):convertToNodeSpace(touchPos)
    local soldierData = global.troopData:getTroopSoldier()
    for _,v in pairs(soldierData) do
        
        local isIn = self:checkRectContainsPoint(self:getTouchRect(v.soldierNode.bodyRect), scrollPos)
        if isIn then
            return true
        end
    end
    return false
end

function CitySoldierMgr:getTouchRect(rectSp)
    local rect = rectSp:getBoundingBox()
    local pos = cc.p(rectSp:getParent():getPosition())
    rect.x = pos.x+rect.x
    rect.y = pos.y+rect.y
    return rect
end

function CitySoldierMgr:checkRectContainsPoint(i_rect,pos)
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

return CitySoldierMgr

--endregion
