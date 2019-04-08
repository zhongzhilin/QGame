--

local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local LineViewMgr = class("LineViewMgr")

local g_worldview = nil

function LineViewMgr:ctor()
    
    g_worldview = global.g_worldview

    self.lineData = {}
    self.areaLineViewData = table.get2DimensionTable()
end

function LineViewMgr:addLine(line,isShow,troopId)

    print(">>>>>>>>>>function LineViewMgr:addLine(line,isShow,troopId)",troopId)

    --line 是城池点的记录
    local mapInfo = g_worldview.mapInfo
    local singleLineData = {line = line,isShow = isShow}
    self.lineData[troopId] = singleLineData --记录一个line的data

    for i = 1, #line - 1 do

        local i1,j1,bd1,isLink1 = mapInfo:decodeId(line[i])
        local i2,j2,bd2,isLink2 = mapInfo:decodeId(line[i + 1])

        local area = self.areaLineViewData[i2][j2]        --将图块view数据的
        --[[使用i2，j2的前提是必须确保连续俩个点，都以后面一个点的i，j为准，需要服务器确保]]--
        local viewData = {bd1 = bd1,bd2 = bd2,id = troopId}
        table.insert(area,viewData)       
    end

    if g_worldview.mapPanel and g_worldview.mapPanel.checkLine then
        g_worldview.mapPanel:checkLine()
    end

    local ret = {

        setVisible = function(table,isShow)
            
            singleLineData.isShow = isShow
            g_worldview.mapPanel:checkLine()
        end,

        isVisible = function()
           
           return singleLineData.isShow
        end
    }

    return ret
end

function LineViewMgr:cleanAll()

    g_worldview.worldCityMgr:cleanAllLine()

    for k,_ in pairs(self.lineData) do

        self:removeLine(k)
    end
end

function LineViewMgr:removeLine(troopId)

    print("remove lien",troopId)
   
    local mapInfo = g_worldview.mapInfo
    
    local singleLineData = self.lineData[troopId]

    if not singleLineData then return end       

    local line = singleLineData.line

    for i = 1, #line - 1 do

        local i1,j1,bd1,isLink1 = mapInfo:decodeId(line[i])
        local i2,j2,bd2,isLink2 = mapInfo:decodeId(line[i + 1])

        local area = self.areaLineViewData[i2][j2]

        for i = #area,1,-1 do

            local v = area[i]

            if v.id == troopId then

                table.remove(area,i)            
            end 
        end
    end

    self.lineData[troopId] = nil
    if g_worldview and not tolua.isnull(g_worldview.mapPanel) then
        g_worldview.mapPanel:checkLine()
    end
end

--将服务器下发的城池点转化成对应的坐标 
function LineViewMgr:decodeLine(lRes,isLine)
    
    local mapInfo = global.g_worldview.mapInfo
    local line = {}

    lRes = table.reverse(lRes)

    for i = 1, #lRes - 1 do

        local i1,j1,bd1,isLink1 = mapInfo:decodeId(lRes[i])
        local i2,j2,bd2,isLink2 = mapInfo:decodeId(lRes[i + 1])
        
        if isLink1 then
            i1 = i2
            j1 = j2
        end

        local mapPos1 = mapInfo:getMapPos(i1, j1)

        --野地资源据点队列路径直线处理
        local polylinePoints = {}
        if lWildKind and lWildKind > 0 then

            isWild = true
            -- log.debug("###############i1=%s, j1=%s,bd1=%s,isLink1=%s, i2=%s, j2=%s,bd2=%s,isLink2=%s",i1, j1,bd1,isLink1,i2, j2,bd2,isLink2)
            local mapPos1 = mapInfo:getMapPos(i1, j1)
            local mapPos2 = mapInfo:getMapPos(i2, j2)

            --先取wildData的数据，如果取不到，则认为不是野地据点，则去pointdata中取
            local tmxPos2 = mapInfo.wildData[bd2] or mapInfo.pointData[bd2]
            local tmxPos1 = mapInfo.wildData[bd1] or mapInfo.pointData[bd1]

            -- print("##############"..vardump(mapInfo.pointData[bd1]))
            table.insert(line,cc.p(tmxPos2.x + mapPos2.x,tmxPos2.y + mapPos2.y))
            table.insert(line,cc.p(tmxPos1.x + mapPos1.x,tmxPos1.y + mapPos1.y))

            -- dump(line,"line")

            local tempP = cc.pSub(line[2],line[1])
            local len = cc.pGetLength(tempP)
            local allLine = math.floor(len / 100)
            local resLine = {}

            for i = 0,allLine do
                
                local pen = i / allLine
                local penPos = cc.p(tempP.x * pen + line[1].x,tempP.y * pen + line[1].y)
                table.insert(resLine,penPos)
            end

            -- dump(resLine,"resLine")

            line = resLine
        else
            polylinePoints = mapInfo.wayData[bd1][bd2]

            for _,vv in ipairs(polylinePoints) do

                table.insert(line,cc.p(vv.x + mapPos1.x,vv.y + mapPos1.y))
            end    
        end
    end
    
    return line

end

function LineViewMgr:flushLineView(index)   --用于刷新

    if not index then

        return
    end

    local worldCityMgr = g_worldview.worldCityMgr

    local area = self.areaLineViewData[index.x][index.y]

    local areaIndex = worldCityMgr:getCityIndex(index)

    worldCityMgr:cleanAreaLine(areaIndex) --先清除掉
    for _,v in ipairs(area) do

        local troopLine = self.lineData[v.id]
        if troopLine and troopLine.isShow then

            worldCityMgr:setDrawLine(areaIndex,v.bd1,v.bd2)
        end                
    end    
end

return LineViewMgr