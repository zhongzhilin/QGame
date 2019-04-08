local resMgr = global.resMgr
local uiMgr = global.uiMgr
local dataMgr = global.dataMgr

local UIWorldScrollView = class("UIWorldScrollView", function() return cc.ScrollView:create() end )

local screen_width = gdisplay.width
local screen_height = gdisplay.height
local g_worldview = global.g_worldview
local WCONST = WCONST

function UIWorldScrollView:ctor()
    
    self:setDelegate()
    self:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)

    self:openRemoveUnusedTouches()

    self.mapNode = cc.Node:create()
    self.mapList = {}

    g_worldview = global.g_worldview

    self.preUpdateTime = 0
    self.topNode = nil
end

function UIWorldScrollView:initWithWorldSize(i_scrollview,mapPanel)
    
    local size = cc.size(0,0)
    local scrollSize = cc.size(0,0)
    if i_scrollview then
        size = i_scrollview:getContentSize()
    end

    self:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
    self:setTouchEnabled(true)
    self:setBounceable(false)
    size.height = size.height + 200
    self:setViewSize(size)

    local panel = ccui.Layout:create()
    panel:setContentSize(cc.size(g_worldview.worldCityMgr.CONFIG.WORLD_WIDTH * g_worldview.worldCityMgr.CONFIG.TMX_WIDTH,
        g_worldview.worldCityMgr.CONFIG.WORLD_HEIGHT * g_worldview.worldCityMgr.CONFIG.TMX_WIDTH))
    
    local mapH = g_worldview.worldCityMgr.CONFIG.WORLD_HEIGHT
    local mapW = g_worldview.worldCityMgr.CONFIG.WORLD_WIDTH

    panel:addChild(self.mapNode)
    mapPanel.mapNode = self.mapNode

    for i = 0,mapW - 1 do

        self.mapList[i] = {}
        for j = 0,mapH - 1 do
        
            local map = g_worldview.worldCityMgr:getAreaMap(i,j)
            self.mapNode:addChild(map)
            self.mapList[i][j] = map
        end
    end

    self:setContainer(panel)

    self:setMinScale(WCONST.WORLD_CFG.MIN_SCALE)
    self:setMaxScale(2)

    self.panel = panel

    self.topNode = mapPanel
    self.panel:addChild(mapPanel)

    -- self.topNode:setPosition(1000,1000)

    -- self:setScrollDeaccelRate(0.7)

    -- self.topNode:setVisible(false)

    i_scrollview:getParent():addChild(self)
    i_scrollview:removeFromParent()

    self:setContentOffsetWithNotCallBack(cc.p(-3072,-3072))

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
            
        self:checkNeedFlush()
    end, 0.5)
    -- self:setZoomScale(0.4, true)
end

function UIWorldScrollView:setViewDidScroll(call)
    self.m_callDidScroll = call
end

function UIWorldScrollView:setContentOffsetWithNotCallBack(pos)
    
    self.isNoCallBackOffset = true
    self:setContentOffset(pos)
    self.isNoCallBackOffset = false
end

function UIWorldScrollView:setCenterPos(minIndex)

    if minIndex.x == 0 and minIndex.y == 0 then
        return
    end

    local mapH = g_worldview.worldCityMgr.CONFIG.WORLD_HEIGHT
    local mapW = g_worldview.worldCityMgr.CONFIG.WORLD_WIDTH 
    local width = g_worldview.worldCityMgr.CONFIG.TMX_WIDTH

    local tmpList = clone(self.mapList)
    
    for i = 0,mapW - 1 do
        for j = 0,mapH - 1 do

            local _i = (i - minIndex.x) % 3
            local _j = (j - minIndex.y) % 3

            local index = ((_j % 3) + (_i % 3) * 3)
            
            self.mapList[_i][_j] = tmpList[i][j]
            self.mapList[_i][_j]:setPosition(g_worldview.worldCityMgr:getMapPos(_i, _j))
        end
    end
end

function UIWorldScrollView:setCenterIndex(index)
    
    local mapH = g_worldview.worldCityMgr.CONFIG.WORLD_HEIGHT
    local mapW = g_worldview.worldCityMgr.CONFIG.WORLD_WIDTH 
    local width = g_worldview.worldCityMgr.CONFIG.TMX_WIDTH

    local minIndex = {}
    for i = 0,mapW - 1 do
        for j = 0,mapH - 1 do        
        
            if self.mapList[i][j]:getTag() == index then

                minIndex.x = i - 1
                minIndex.y = j - 1
                self:setCenterPos(minIndex)
                return
            end
            -- print(self.mapList[i][j]:getTag())
        end
    end 
end

function UIWorldScrollView:doneOffset(offIndex)

    if offIndex.x == 0 and offIndex.y == 0 then
        -- print("ooffsetindex is 0 ")
        return
    end

    local off = self:getContentOffsetFixed()

    local scale = self:getZoomScaleFixed()

    off.x = off.x + offIndex.x * 1024 * scale + offIndex.y * 1024 * scale
    off.y = off.y + offIndex.y * 1024 * scale - offIndex.x * 1024 * scale


    local x,y = self.topNode:getPosition()
    x = x - (offIndex.x * 1024 + offIndex.y * 1024)
    y = y - (offIndex.y * 1024 - offIndex.x * 1024)

    self.topNode:setPosition(cc.p(x,y))
    self:setContentOffset(off, false)

    return isReset
end

function UIWorldScrollView:getZoomScaleFixed()
    local scale = self:getZoomScale()
    scale = global.tools:getPreciseDecimal(scale, 2)
    return scale
end

function UIWorldScrollView:getContentOffsetFixed()
    local offset = self:getContentOffset()
    offset.x = global.tools:getPreciseDecimal(offset.x, 2)
    offset.y = global.tools:getPreciseDecimal(offset.y, 2)
    return offset
end

function UIWorldScrollView:convertHighfloatToLow(vec2Point)
    local offset = {}
    offset.x = global.tools:getPreciseDecimal(vec2Point.x, 2)
    offset.y = global.tools:getPreciseDecimal(vec2Point.y, 2)
    return offset
end

function UIWorldScrollView:scrollViewDidScrollOver(arg)
    if self.index and self.m_isChangeIndex then
        self.m_isChangeIndex = false

        g_worldview.areaDataMgr:flushMap(x,y,call)
    end  
end 

function UIWorldScrollView:scrollViewDidScroll(arg1)

    if self.m_callDidScroll then self.m_callDidScroll(scrollview) end

    if self.isNoCallBackOffset then
        
        return
    else
        
    end

    local scale = self:getZoomScaleFixed()

    local x,y = self.topNode:getPosition()

    x = (x * scale + self:getContentOffsetFixed().x - screen_width / 2) * -1 / scale
    y = (y * scale + self:getContentOffsetFixed().y - screen_height / 2) * -1 / scale

    local function call()
    end

    self.topNode:flushPanel(x,y)
    self:checkIndex(x,y)
    self:checkOffsetMode2(self:getContentOffsetFixed())

    local contentTime = os.clock()
    if contentTime - self.preUpdateTime > 0.2 then

        self.isNeedFlush = false

        self.preUpdateTime = contentTime
        g_worldview.areaDataMgr:flushMap(x,y,call)    
    else
        
        self.isNeedFlush = true
        self.flushArg = {x,y,call}
    end

    
    -- global.g_worldview.flogMgr:update()
end

function UIWorldScrollView:checkNeedFlush()
    
    if self.isNeedFlush then

        self.isNeedFlush = false
        g_worldview.areaDataMgr:flushMap(unpack(self.flushArg))         
    end
end

function UIWorldScrollView:checkIndex(x,y)
    
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    local floatI = (x + y) / (2048) + map_width / 2
    local floatJ = (x - y) / (2048) + map_width / 2

    local floorI = math.floor(floatI)
    local floorJ = math.floor(floatJ)

    self.index = cc.p(floorI,floorJ)
end

function UIWorldScrollView:checkOffsetIsCanJump(off,isHideErrorcode)
    
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    
    local i,j = g_worldview.const:convertPix2MapIndex(off)


    if i < 0 or j < 0 or j > map_width - 1 or i > map_width - 1 then

        return false
    end

    local landId = global.g_worldview.areaDataMgr:checkIsOtherLand(i,j)
    if landId then
        if not isHideErrorcode then
            global.tipsMgr:showWarning('pleaseSetUpCity1')        
        end        
        return false
    end

    if landId == nil then return false end
    
    return true
end

function UIWorldScrollView:setOffset(off,isNotNeedFlush)

    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH

    local scale = self:getZoomScaleFixed()
    local off = clone(off)
    off.x = off.x * -1-- * scale
    off.y = off.y * -1-- * scale
    local tempX = off.x-- - 2048 * 40.5
    local tempY = off.y-- + 2048 * 40.5

    local i = (((tempX) + (tempY)) / (2048) + map_width / 2)
    local j = (((tempX) - (tempY)) / (2048) + map_width / 2)

    local moreI = i - math.floor(i) - 0.5
    local moreJ = j - math.floor(j) - 0.5

    i = math.floor(i)
    j = math.floor(j)


    if i < 0 or j < 0 or j > map_width - 1 or i > map_width - 1 then

        return false
    end

    local half_map_width = math.floor(map_width / 2)

    local posI = -((i - half_map_width) * 1024 + (j - half_map_width) * 1024) + 3072
    local posJ = -((i - half_map_width) * 1024 - (j - half_map_width) * 1024) + 3072

    self.topNode:setPosition(cc.p(posI,posJ))

    local index = ((i % 3) + (j % 3) * 3)

    -- self:setCenterIndex(index)

    if not self.preCenterIndex or (self.preCenterIndex.x ~= i or self.preCenterIndex.y ~= j) then
        self:changeIndex(cc.p(i,j),true)
    end
    self.preCenterIndex = cc.p(i,j)

    local p = {}
    p.x = 1024 * moreI + 1024 * moreJ * -1
    p.y = 1024 * moreI - 1024 * moreJ * -1

    if isNotNeedFlush then

        self:setContentOffsetWithNotCallBack(cc.p((-3072 - p.y) * scale+ gdisplay.width / 2,(-3072  - p.x) * scale+ gdisplay.height / 2))
    else
        
        self:setContentOffset(cc.p((-3072 - p.y) * scale+ gdisplay.width / 2,(-3072  - p.x) * scale+ gdisplay.height / 2))
    end

    return true
end

function UIWorldScrollView:checkOffset(off)

    local mapH = g_worldview.worldCityMgr.CONFIG.WORLD_HEIGHT
    local mapW = g_worldview.worldCityMgr.CONFIG.WORLD_WIDTH
    local width = g_worldview.worldCityMgr.CONFIG.TMX_WIDTH

    local centerPos = cc.p(screen_width / 2,screen_height / 2)

    local minIndex = nil
    local minLen = -1

    local scale = self:getZoomScaleFixed()

    for i = 0,mapW - 1 do
        for j = 0,mapH - 1 do
        
            local x = (self.mapList[i][j]:getPositionX()  + width / 2) * scale + off.x - centerPos.x
            local y = (self.mapList[i][j]:getPositionY()  + width / 2) * scale + off.y - centerPos.y

            local len = cc.pGetLength(cc.p(x,y))

            if len < minLen or minLen == -1 then

                minLen = len
                minIndex = cc.p(i - 1,j - 1)
            end
        end
    end

    -- log.debug("check offset")
    -- dump(minIndex)

    if minIndex ~= nil and not self.aaa then

        self:setCenterPos(minIndex)
        self:doneOffset(minIndex)
        return true
    end

    return false
end

function UIWorldScrollView:closeSchedule()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end

-- isBySkip 标记是否是通过setOffset调用的
function UIWorldScrollView:changeIndex(index,isBySkip)

    g_worldview.areaDataMgr:setContentIAndJ(index.x,index.y,isBySkip)

    local worldCityMgr = g_worldview.worldCityMgr

    -- for i = 0,2 do
    --     for j = 0,2 do

    --         self.mapList[i][j]:release()
    --     end
    -- end

    -- print(index.x,index.y)

    -- local index = worldCityMgr:getCityIndex(index)

    -- print(index)

    -- if true then return end

    local removeList = {}
    local addList = {}

    for i = 0,2 do
        for j = 0,2 do

            -- self.mapList[i][j]:removeFromParent()
            table.insert(removeList,self.mapList[i][j])
        end
    end

    for i = 0,2 do
        for j = 0,2 do

            local index2 = cc.p(i - 1 + index.x, j - 1 + index.y)
            local minIndex = clone(index2)
            if worldCityMgr:getCityIndex(minIndex) ~= -1 then

                local map = worldCityMgr:getAreaMap(index2.x,index2.y,minIndex.x,minIndex.y)          
                map:setPosition(worldCityMgr:getMapPos(j, i))

                map.index = index2
                
                self.mapList[i][j] = map

                local isInRemoveList = false
                for i,v in ipairs(removeList) do

                    if map == v then

                        table.remove(removeList,i)
                        isInRemoveList = true
                        break
                    end
                end

                if not isInRemoveList then table.insert(addList,map) end
            end
        end
    end

    for i,v in ipairs(removeList) do

        print(i,"remove",v)
        v:removeFromParent()
    end

    for i,v in ipairs(addList) do

        print(i,"add",v)
        self.mapNode:addChild(v)
    end
end

function UIWorldScrollView:checkOffsetMode2(off)
    
    local index = self.index

    if self.preCenterIndex == nil or (self.preCenterIndex.x ~= index.x or self.preCenterIndex.y ~= index.y) then

        if self.preCenterIndex then

            local minIndex = cc.p(index.y - self.preCenterIndex.y,index.x - self.preCenterIndex.x)
            self.preCenterIndex = index 

            self:doneOffset(minIndex)
            self:changeIndex(index)
        else

            self.preCenterIndex = index
        end
    end


    -- if minIndex ~= nil and not self.aaa then

    --     -- self:setCenterPos(minIndex)        
    --     return true
    -- end

    -- return false
end

function UIWorldScrollView:flushMap()
    

end

function UIWorldScrollView:checkCache(scrollView)
    
end

return UIWorldScrollView