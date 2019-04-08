--

local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local WorldCityMgr = class("WorldCityMgr")
local UIWorldCity = require("game.UI.world.widget.UIWorldCity")
local UIWorldWildRes = require("game.UI.world.widget.UIWorldWildRes")
local UIWorldWildObj = require("game.UI.world.widget.UIWorldWildObj")
local areaMapCache = {}
local roadNode = nil
local lineNode = {}
local roadNodeList = {}
local WCONST = WCONST
local leagueBoundryNode = {}

local g_worldview = nil

WorldCityMgr.CONFIG = {
    
    ROOT_MAP_COUNT = 3,
    TMX_COUNT = 9,
    WORLD_WIDTH = 3,
    WORLD_HEIGHT = 3,
    TMX_WIDTH = 2048,
    TMX_FILE_PATH = "map/map%02d.tmx",
    WORLD_BG_FILE_PATH = "map/root%d.jpg",
    RODE_BG_FILE_PATH = "map/x_%d.png",
    RODE_BG_CSD_FORMAT = "world/road/map_%03d",
    RODE_BG_CSD_PATH = "world/road/map_001",
    RODE_BG_CSD_PATH2 = "world/road/map_002"
}

function WorldCityMgr:ctor()
    
    uiMgr = global.uiMgr
    g_worldview = global.g_worldview

    self.wildObjCache = {}
    self.wildResCache = {}
    self.cityCache = {}
    self.pointCache = {}
    -- self.areaMapCache = {}
    self.areaData = {}
    --table.get2DimensionTable()

    self:initAreaMapCache()
end

function WorldCityMgr:getPoint(pointtype,vatarType,isEmpty)
    
    local minimap = g_worldview.worldPanel.miniMap

    local point = nil

    if #self.pointCache > 0 then

        point = self.pointCache[1]
        table.remove(self.pointCache,1)
    else

        point = cc.Sprite:create()
        point:retain()
    end 

    point:setSpriteFrame(minimap:getSpriteFrameByType(pointtype).minimap)
    point:setColor(minimap:getMapColorByAvatar(vatarType,isEmpty))

    return point 
end

function WorldCityMgr:removePoint(point)

    if not point then return end

    point:removeFromParent()
    table.insert(self.pointCache,point)
end

function WorldCityMgr:cleanCache()
   
    -- print("cleanCache")

    for _,v in ipairs(self.wildObjCache) do
        v:cleanup()
        v:release()
    end

    for _,v in ipairs(self.wildResCache) do

        v:release()
    end

    for _,v in ipairs(self.cityCache) do

        v:release()
    end

    for _,v in ipairs(self.pointCache) do

        v:release()
    end


    if not global.isMemEnough then
        
        for i,v in pairs(areaMapCache) do

            if not v:getParent() then

                print("find on have no parent 1",i)
                
                -- v:release()        
                global.scMgr:CurScene():addChild(v)
                v:release()
            else

                print("find on have no parent 2",i)

                v:release()
            end       
        end
        
        areaMapCache = {}

        for _,vv in pairs(leagueBoundryNode) do
            for i_name,v in pairs(vv) do
                local existparent = v.node:getParent()
                if not v.node:getParent() then
                    global.scMgr:CurScene():addChild(v.node)
                    v.node:release()
                else
                    v.node:release()
                end
            end
        end
        leagueBoundryNode={}
    end
end

function WorldCityMgr:cleanNoParentAreas()

    for _,v in pairs(areaMapCache) do
        
        if not v:getParent() then

            print("find on have no parent")
            
            -- v:release()        
            global.scMgr:CurScene():addChild(v)
            v:release()
        else

            v:release()
        end
    end

    if roadNode then -- protect         
        if not roadNode:getParent() then
            -- roadNode:release()
            -- roadNode:release()        
            global.scMgr:CurScene():addChild(roadNode)
            roadNode:release()
        else
            roadNode:release()
        end
    end 

    roadNode = nil

    areaMapCache = {}
end

--获取野地野怪据点
function WorldCityMgr:getWildObj(worldmap)
    
    local wild = nil
    if #self.wildObjCache > 0 then

        local idx = nil
        if worldmap then
            for i,v in pairs(self.wildObjCache) do
                if v:getWorldMap() == worldmap then
                    wild = v
                    idx = i
                    table.remove(self.wildObjCache,idx)
                    break
                end
            end
        end
        if not wild then
            wild = UIWorldWildObj.new()
            wild:retain()
        end

    else
        wild = UIWorldWildObj.new()
        wild:retain()
    end


    -- print("已经用完了，new了一个新的UIWorldWildObj")
    return wild
end

function WorldCityMgr:removeWildObj(wild)
    wild:removeFromParent(false)
    table.insert(self.wildObjCache,wild)
end

--获取野地资源据点
function WorldCityMgr:getWildRes()
    
    if #self.wildResCache > 0 then

        local wild = self.wildResCache[1]

        table.remove(self.wildResCache,1)
        
        return wild
    end

    local wild = UIWorldWildRes.new()
    wild:retain()


    -- print("已经用完了，new了一个新的UIWorldWildRes")
    return wild
end

function WorldCityMgr:removeWildRes(wild)
    
    self:removePoint(wild:getPointSprite())
    wild:removeFromParent()
    table.insert(self.wildResCache,wild)
end

function WorldCityMgr:getCity()
    
    if #self.cityCache > 0 then

        local city = self.cityCache[1]

        table.remove(self.cityCache,1)
        
        return city
    end

    local city = UIWorldCity.new()
    city:retain()

    -- print("已经用完了，new了一个新的city")

    return city
end

function WorldCityMgr:removeCity(city)

    self:removePoint(city:getPointSprite())

    city:removeFromParent()
    table.insert(self.cityCache,city)
end

function WorldCityMgr:removeCityWithNoParent( city )
    
    self:removePoint(city:getPointSprite())
    table.insert(self.cityCache,city)
end

function WorldCityMgr:removeWildObjWithNoParent( city )

    table.insert(self.wildObjCache,city)
end

function WorldCityMgr:removeWildResWithNoParent( city )
    
    self:removePoint(city:getPointSprite())

    table.insert(self.wildResCache,city)
end

function WorldCityMgr:getAreaMap(i,j,minI,minJ)

    -- print(i,j,minI,minJ,'get area map')

    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH - 1

    local index = self:getCityIndex(cc.p(i, j))

    local preMap = areaMapCache[index] or self:createMap(index)

    local landId = g_worldview.areaDataMgr:getContentAreaId() or 1
    local map_region = global.luaCfg:get_map_region_by(landId)

    preMap.sea:setVisible(false)

    if WCONST.WORLD_CFG.IS_3D then
        preMap.root:setVisible(true)
    end
    
    preMap.bg:setVisible(true)

    for i = 0,3 do

        preMap["root"..i]:setVisible(false)
        preMap["edge"..(i + 1)]:setVisible(false)
    end

    local changeView = function(root,index)
        
        if landId == 5 then
            return
        end

        local childs = root:getChildren()
        for _,v in ipairs(childs) do
            v:setSpriteFrame("mapunit/edge" .. index .. ".png")
        end
    end

    local isSea = false
    if i < map_region.minX or j < map_region.minY or i > map_region.maxX or j > map_region.maxY then
            
        preMap.bg:setVisible(false)                
        preMap.sea:setVisible(true)
        preMap.root:setVisible(false)
        isSea = true
    end

    if minI == map_region.minX  then
        preMap.root1:setVisible(true)
        changeView(preMap.root1,1)
    end

    if minI == map_region.maxX then
        preMap.root3:setVisible(true)
        changeView(preMap.root3,1)
    end

    if minJ == map_region.minY then
        preMap.root0:setVisible(true)
        changeView(preMap.root0,1)
    end

    if minJ == map_region.maxY then
        preMap.root2:setVisible(true)
        changeView(preMap.root2,1)
    end

    if minI == map_region.minX and minJ == map_region.minY then            
        preMap.edge4:setVisible(true)        
    end

    if minI == map_region.minX and minJ == map_region.maxY then            
        preMap.edge1:setVisible(true)        
    end

    if minI == map_region.maxX and minJ == map_region.minY then            
        preMap.edge3:setVisible(true)
    end

    if minI == map_region.maxX and minJ == map_region.maxY then            
        preMap.edge2:setVisible(true)
    end

    if not global.guideMgr:isPlaying() then
        
        local map_lv = luaCfg:map_lv()
        for _,v in ipairs(map_lv) do

            if v.landID == landId and v.lv > 1 then

                local lv = v.lv

                -- for i = 1,4 do
                --     preMap['edge' .. i]:setVisible(false)        
                -- end

                local isOut = false
                if i < v.minX or j < v.minY or i > v.maxX or j > v.maxY then
                
                    isOut = true
                end

                if not isOut then
                    if minI == v.minX  then
                        preMap.root1:setVisible(true)
                        changeView(preMap.root1,lv)
                    end

                    if minI == v.maxX then
                        preMap.root3:setVisible(true)
                        changeView(preMap.root3,lv)
                    end

                    if minJ == v.minY then
                       preMap.root0:setVisible(true)
                       changeView(preMap.root0,lv)
                    end

                    if minJ == v.maxY then
                       preMap.root2:setVisible(true)
                       changeView(preMap.root2,lv)
                    end
                end            
            end
        end
    end  

    return preMap
end

function WorldCityMgr:getCityIndex(index)   --通过块的id，获取块的index
    
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH

    if index.x < 0 then

        index.x = index.x + map_width
    end

    if index.y < 0 then

        index.y = index.y + map_width
    end

    if index.x > map_width - 1 then

        index.x = index.x - map_width
    end

    if index.y > map_width - 1 then

        index.y = index.y - map_width
    end

    if index.x < 0 or index.y < 0 or index.x > map_width - 1 or index.y > map_width - 1 then
            
        return -1
    end

    if not index.y or not index.x then
        print(debug.traceback(),">>>check out the auto choose soldier bug")
    end

    return self.areaData[index.y][index.x]
end

function WorldCityMgr:getRoadNode()
    
    return roadNode
end

function WorldCityMgr:initAreaMapCache() --初始化地图集
    
    
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    
    if not roadNode then
        roadNode = cc.Node:create()
        roadNode:retain()
    end    
    -- self.roadNode:retain()
    
    for i = 0,map_width - 1 do

        local t = {}

        for j = 0,map_width - 1 do
            
            local index = self:getIndexByIAndJ(i % 3,j % 3)
            t[j] = index + 1
        end

        self.areaData[i] = t
    end

    local map_data = luaCfg:map_data()
    for _,v in pairs(map_data) do

        self.areaData[v.Y][v.X] = v.data
    end

end

local map_bgs = {}
function WorldCityMgr:showByLv( lv )
    global.m_world_show_lv = lv
    local showLv = global.m_world_show_lv or 0
    for k,map in pairs(map_bgs) do
        local bg = map.bg
        -- if showLv <= 0 then
        --     -- bg.root:setVisible(true)
        --     bg.tree:setVisible(true)
        --     if bg.city then     bg.city:setVisible(true) end
        --     if bg.Node_1 then   bg.Node_1:setVisible(true) end
        --     if bg.lizi then     bg.lizi:setVisible(true) end
        --     if bg.wild then     bg.wild:setVisible(true) end
        --     bg:setVisible(true)
        --     map:setVisible(true)
        -- -- elseif showLv == 1 then
        -- --     -- bg.root:setVisible(false)
        -- -- elseif showLv == 2 then
        -- --     -- bg.root:setVisible(false)
        -- --     bg.tree:setVisible(false)
        -- -- elseif showLv == 3 then
        -- --     -- bg.root:setVisible(false)
        -- --     bg.tree:setVisible(false)
        -- --     if bg.city then     bg.city:setVisible(false) end 
        -- -- elseif showLv == 4 then
        -- --     -- bg.root:setVisible(false)
        -- --     bg.tree:setVisible(false)
        -- --     if bg.city then     bg.city:setVisible(false) end
        -- --     if bg.Node_1 then   bg.Node_1:setVisible(false) end
        -- -- elseif showLv == 5 then
        -- --     -- 减少了5000个节点
        -- --     -- bg.root:setVisible(false)
        -- --     bg.tree:setVisible(false)
        -- --     if bg.city then     bg.city:setVisible(false) end
        -- --     if bg.Node_1 then   bg.Node_1:setVisible(false) end
        -- --     if bg.lizi then     bg.lizi:setVisible(false) end
        -- -- elseif showLv == 6 then
        -- --     map:setVisible(false)
        -- -- elseif showLv == 7 then
        -- --     -- bg.root:setVisible(false)
        -- --     bg.tree:setVisible(false)
        -- --     if bg.city then     bg.city:setVisible(false) end
        -- --     if bg.Node_1 then   bg.Node_1:setVisible(false) end
        -- --     if bg.lizi then     bg.lizi:setVisible(false) end
        -- --     if bg.wild then     bg.wild:setVisible(false) end
        -- --     bg:setVisible(false) 
        -- else
        --     if bg.lizi then     bg.lizi:setVisible(false) end
        --     bg.tree:setVisible(false)
        -- end

        if bg and not tolua.isnull(bg.lizi) then     bg.lizi:removeFromParent() end
    end
end

function WorldCityMgr:createMap( index )
    
    local width = WorldCityMgr.CONFIG.TMX_WIDTH

    local mapName = string.format(WorldCityMgr.CONFIG.TMX_FILE_PATH,index)
    local map = cc.TMXTiledMap:create(mapName)
    map:setTag(index)        

    local bg = resMgr:createWidget(string.format(WorldCityMgr.CONFIG.RODE_BG_CSD_FORMAT,index))
    bg:setPosition(cc.p(width / 2,width / 2))        
    bg:setLocalZOrder(-2)
    map:addChild(bg)

    map.bg = bg
    table.insert(map_bgs,map)

    uiMgr:configUITree(bg)

    if WCONST.WORLD_CFG.IS_3D then

        local rootFile = "map/file/root1.tmx"
        if luaCfg:get_map_res_by(index).res == 1 then
            rootFile = "map/file/root2.tmx"
        end

        local t3dt = cc.TMXTiledMap:create(rootFile)
        t3dt:setPosition(cc.p(width / 2,width / 2))        
        t3dt:setLocalZOrder(-3)
        t3dt:setAnchorPoint(cc.p(0.5,0.5))
        t3dt:setRotation(-45)
        t3dt:setScale(1450 / 2000)
        map.root = t3dt
        map:addChild(t3dt)
    end

    local t3dt = cc.TMXTiledMap:create("map/file/ocean1.tmx")
    t3dt:setPosition(cc.p(width / 2,width / 2))        
    t3dt:setLocalZOrder(1)
    t3dt:setAnchorPoint(cc.p(0.5,0.5))
    t3dt:setRotation(-45)
    t3dt:setScale(1450 / 1448)    
    map:addChild(t3dt)
    map.sea = t3dt

    local rootFile = "world/road/map_root"
    if luaCfg:get_map_res_by(index).res == 1 then
        rootFile = "world/road/map_root1"
    end

    local root = resMgr:createWidget(rootFile)
    root:setPosition(cc.p(width / 2,width / 2))
    root:setLocalZOrder(-1)
    map:addChild(root)

    local road = roadNodeList[index]

    uiMgr:configUITree(root)

    map.root0 = root.root0
    map.root1 = root.root1
    map.root2 = root.root2
    map.root3 = root.root3
    map.edge1 = root.edge1
    map.edge2 = root.edge2
    map.edge3 = root.edge3
    map.edge4 = root.edge4

    -- map.Panel_1 = root.Panel_1
    -- map.Panel_1:setVisible(false)

    if device.platform == "windows" and false then
    
        local countText = ccui.Text:create()
        countText:setString(index)
        countText:setScale(10)
        countText:setPosition(width / 2,width / 2)
        map:addChild(countText)

        map:setScale(2040 / 2048)
    end    

    map:retain()

    -- self:initMapLine(road,index)

    areaMapCache[index] = map

    local tempSetPosition = map.setPosition
    map.setPosition = function(node,pos)
        
        -- print(">>>>>>>>> map set postion")
        road:setPosition(pos)
        road:setVisible(true)
        tempSetPosition(node,pos)
    end

    local tempRemoveFromParent = map.removeFromParent
    map.removeFromParent = function(node)
        
        -- print(">>>>>>>>> map removeFromParent()")
        road:setVisible(false)
        tempRemoveFromParent(node)
    end

    return map
end

function WorldCityMgr:cleanAreaLine(index)

    for p1,v in pairs(lineNode[index]) do

        for p2,line in pairs(v) do

            if type(line) == "userdata" then
                
                line:setVisible(false)
            end
            
        end
    end
end



function WorldCityMgr:loadRoad()

    local all = luaCfg:get_map_cfg_by(1).number
    for i=1,all do

        lineNode[i] = table.get2DimensionTable()
       
        local road = cc.Node:create()
        roadNode:addChild(road)
        
        self:initMapLine(road,i)
        
        roadNodeList[i] = road
    end
end

function WorldCityMgr:loadUseful()
    
    for index = 1,9 do --检索需要创建的地图

        if not areaMapCache[index] then
            self:createMap(index)
        end        
    end
    -- self:createLeagueBoundryEffect()
end

function WorldCityMgr:cleanAllLine()

    if roadNode then
        local roadChilds = roadNode:getChildren()
        for _,v in ipairs(roadChilds) do

            local draws = v:getChildren()
            for _,drawChild in ipairs(draws) do

                if drawChild:isVisible() then

                    drawChild:setVisible(false)     
                end            
            end        
        end
    end    
end

function WorldCityMgr:setDrawLine(index,p1,p2)

    local p1Index = math.min(p1,p2)
    local p2Index = math.max(p1,p2)

    local drawNode = lineNode[index][p1Index][p2Index]    
    
    if type(drawNode) == "userdata" then
    
        drawNode:setVisible(true)
    end    
end

function WorldCityMgr:initMapLine(map,index)
    
    local wayData = {} 
    if g_worldview.mapInfo then 
       wayData =g_worldview.mapInfo:getIndexWayInfo(index)
    end 
    for p1,p1v in pairs(wayData) do

        for p2,p2v in pairs(p1v) do        

            local p1Index = math.min(p1,p2)
            local p2Index = math.max(p1,p2)
            lineNode[index][p1Index][p2Index] = self:drawLine(p2v,map)            
        end
    end
end

function WorldCityMgr:drawLine(line,map)

    local draw = cc.DrawNode:create()
    draw:setAnchorPoint(cc.p(0,0))
    draw:setPosition(cc.p(0,0))
    map:addChild(draw)

    draw:setVisible(false)

    local polylinePoints = line

    local prePoint = polylinePoints[1]
    local LINE_LEN = 20
    
    local preCutLine = 0
    for i,pv in ipairs(polylinePoints) do
                  
        local tempP = cc.pSub(prePoint,pv)
        local len = cc.pGetLength(tempP)
        local allLine = len / LINE_LEN

        local floorAllLine = math.floor(allLine) 

        for i = 0,floorAllLine do

            local endPos
            local endPos2
            
            -- print("i",i,"allLen",allLine)

            if i == floorAllLine then

                endPos = cc.pMul(tempP,(i / allLine))
                
                if i / allLine + 6 / len > 1 then

                    endPos2 = cc.pMul(tempP,1)
                else
                
                    endPos2 = cc.pMul(tempP,i / allLine + (6 / len))
                end

                
            else

                endPos = cc.pMul(tempP,i / allLine)
                endPos2 = cc.pMul(tempP,i / allLine + (6 / len))
            end                    

            draw:drawSegment(cc.pSub(prePoint,endPos), cc.pSub(prePoint,endPos2), 2, {r = 1,g = 243 / 255,b = 45 / 255, a = 1}) 
        end

        preCutLine = allLine - floorAllLine

        prePoint = pv
    end

    return draw
end

function WorldCityMgr:getIndexByIAndJ(i,j)
    
    return ((j % 3) + (i % 3) * 3)
end

function WorldCityMgr:getMapPos(i,j)

    local width = WorldCityMgr.CONFIG.TMX_WIDTH

    local mapH = WorldCityMgr.CONFIG.WORLD_HEIGHT

    return cc.p(i * width / 2 + j * width / 2,width / 2 * j + (mapH - i) * width / 2 - width / 2)
end

function WorldCityMgr:hideAllLeagueBoundryEffect()
    leagueBoundryNode = leagueBoundryNode or {}
    -- dump(leagueBoundryNode,"fdsafdsafasdfasfsdas")
    for fileName,vv in pairs(leagueBoundryNode) do
        for i_name,v in pairs(vv) do
            local existparent = v.node:getParent()
            if v.node:getParent() then
                v.node:setVisible(false)
            end
        end
    end
end

function WorldCityMgr:getLeagueBoundryNode(fileName,lastFileName)
    if lastFileName and leagueBoundryNode[lastFileName] then
        for i_name,v in pairs(leagueBoundryNode[lastFileName]) do
            local existparent = v.node:getParent()
            if v.node:getParent() then
                v.node:setVisible(false)
            end
        end
    end
    if not leagueBoundryNode[fileName] then
        leagueBoundryNode[fileName] = self:createNodeByCsd(fileName)
    end
    return leagueBoundryNode[fileName]
end

function WorldCityMgr:createNodeByCsd(fileName)
    local csd_root = resMgr:createWidget(fileName)
    childs = csd_root:getChildren()
    local data = {}
    for i,v in ipairs(childs) do
        local scaleX = v:getScaleX()
        local scaleY = v:getScaleY()
        local posX,posY = v:getPosition()
        local skY = v:getRotationSkewY()
        local ap = v:getAnchorPoint()
        local name = v:getName()
        local node = gdisplay.newSprite(filename, x, y)
        node:setSpriteFrame(v:getSpriteFrame())
        node:setScaleX(scaleX)
        node:setScaleY(1)
        node:setRotationSkewY(skY)
        node:setAnchorPoint(ap)
        -- node:setOpacity(0)
        node:setColor(v:getColor())
        node:setBlendFunc(v:getBlendFunc())
        local newnode = gdisplay.newNode()
        newnode.node = node
        newnode:addChild(node)
        newnode:retain()
        data[name] = {node=newnode,px=posX,py=posY,sy=scaleY*1.5}
    end
    return data
end

function WorldCityMgr:updateNodePos(data,centrePos,parent)
    local i = 0
    for i_name,v in pairs(data) do
        local pos = cc.p(centrePos.x+v.px,centrePos.y+v.py)
        v.node:setVisible(true)
        v.node:setPosition(pos)
        local existparent = v.node:getParent()
        if not existparent and parent then
            parent:addChild(v.node)
            i= i+1
            self:moveGo(v,i)
        end
    end
end

function WorldCityMgr:moveGo(data,i)
    local actionT = {}
    local perS = 1/60
    local node = data.node
    local child = node.node
    local scaleX = child:getScaleX()
    local rand = math.random(0,10)
    table.insert(actionT,cc.DelayTime:create(rand*perS))
    table.insert(actionT,cc.Spawn:create(cc.ScaleTo:create(perS*50, scaleX,0.8*data.sy),cc.FadeIn:create(perS*50)))
    table.insert(actionT,cc.DelayTime:create(perS*40))
    table.insert(actionT,cc.Spawn:create(cc.ScaleTo:create(perS*85, scaleX,data.sy),cc.FadeOut:create(perS*85)))
    table.insert(actionT,cc.ScaleTo:create(perS, scaleX,1))
    child:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT)))
end

return WorldCityMgr