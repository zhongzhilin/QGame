--region UINewWorldMap.lua
--Author : untory
--Date   : 2017/01/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local CCSScrollView = require("game.UI.common.CCSScrollView")
local luaCfg = global.luaCfg
local WCONST = WCONST
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UINewWorldMap  = class("UINewWorldMap", function() return gdisplay.newWidget() end )

local g_worldview = nil

function UINewWorldMap:ctor()
    self:CreateUI()
    g_worldview = global.g_worldview
end

function UINewWorldMap:CreateUI()
    local root = resMgr:createWidget("world/world_big")
    self:initUI(root)
end

function UINewWorldMap:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_big")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.parent = self.root.parent_export
    self.ScrollView = self.root.parent_export.ScrollView_export
    self.name = self.root.btn1.name_export
    self.add = self.root.add_export
    self.qiji_btn = self.root.qiji_btn_export
    self.union_btn = self.root.union_btn_export
    self.shili_btn = self.root.shili_btn_export
    self.zhanling_btn = self.root.zhanling_btn_export
    self.union_vag_btn = self.root.union_vag_btn_export
    self.qiji_name_btn = self.root.qiji_name_btn_export
    self.btn_state = self.root.btn_state_export
    self.icon = self.root.btn_state_export.icon_export
    self.incall = self.root.Node_1.incall_export
    self.btn_king = self.root.btn_king_export
    self.king = self.root.btn_king_export.king_export
    self.txt_king_export = self.root.btn_king_export.txt_king_export_mlan_5

    uiMgr:addWidgetTouchHandler(self.root.btn1, function(sender, eventType) self:back_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.qiji_btn, function(sender, eventType) self:qiji_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.union_btn, function(sender, eventType) self:union_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.shili_btn, function(sender, eventType) self:shili_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.zhanling_btn, function(sender, eventType) self:showInfo(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.union_vag_btn, function(sender, eventType) self:union_vag_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.qiji_name_btn, function(sender, eventType) self:showName(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_state, function(sender, eventType) self:changeToLineMap(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.incall, function(sender, eventType) self:in_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_king, function(sender, eventType) self:kingHandler(sender, eventType) end)
--EXPORT_NODE_END

    -- self.root.Image:setPositionY(gdisplay.height / 2)

    self.incall:setLocalZOrder(99)
    self.incall:getParent():setLocalZOrder(99)-- self.out:setLocalZOrder(99)
    self.incall:setSwallowTouches(true)
    -- self.out:setSwallowTouches(true)
    self.zhanling_btn:setLocalZOrder(99)
    self.zhanling_btn:setSwallowTouches(true)
    self.root.btn1:setSwallowTouches(true)
    self.root.btn1:setLocalZOrder(99)

    self.isNode1Out = true
    self.node1_parent = self.incall:getParent()

    self.union_btn:setLocalZOrder(10)
    self.shili_btn:setLocalZOrder(10)
    self.qiji_btn:setLocalZOrder(10)  
    self.btn_king:setLocalZOrder(10)
    self.union_vag_btn:setLocalZOrder(10)    
    self.btn_state:setLocalZOrder(10241024)

    self.m_scrollView = CCSScrollView.new()
    self.panelSize = self.ScrollView:getInnerContainerSize()
    self.mapNode = self.m_scrollView:initWithUIScrollView(self.ScrollView,"world/world_big_node")        

    for i = 1,4 do
        uiMgr:configUILanguage(self.mapNode.Node_3["range" .. i .. "_name_export"], "world/map_range_name" .. i)        
    end    

    uiMgr:addWidgetTouchHandler(self.mapNode.king_btn, function(sender, eventType) self:enterBossMap(sender, eventType) end)
    self.mapNode.king_btn:setSwallowTouches(false)

    for i = 1,4 do
        uiMgr:addWidgetTouchHandler(self.mapNode['boss0' .. i], function(sender, eventType) self:chooseBoss(i) end)
        self.mapNode['boss0' .. i]:setSwallowTouches(false)
        self.mapNode['boss0' .. i]:setVisible(i == 1 or global.userData:isOpenFullMap())
    end

    self.effectNode = cc.Node:create()
    self.mapNode.container_node_export:addChild(self.effectNode) 

    self.effectNode:setPosition(cc.p(1886,1183))

    local minScale = gdisplay.height / self.panelSize.height

    self.m_scrollView:setMinScale(minScale)
    self.m_scrollView:setMaxScale(1.2)

    self.m_scrollView:setZoomScale(0.9)

    global.panelMgr:setTextureFor(self.mapNode.container_node_export.map_002_01_1,"world/map/map_01_01.jpg")
    global.panelMgr:setTextureFor(self.mapNode.container_node_export.map_002_02_2,"world/map/map_01_02.jpg")
    global.panelMgr:setTextureFor(self.mapNode.container_node_export.map_002_03_3,"world/map/map_01_03.jpg")
    global.panelMgr:setTextureFor(self.mapNode.container_node_export.map_002_04_4,"world/map/map_01_04.jpg")
    
    self.mapNode.Node_3:setLocalZOrder(1)

    self:translateNode()

    self.unionNode = cc.Node:create()
    self.pointPanel:addChild(self.unionNode)

    self.commonNode = cc.Node:create()
    self.pointPanel:addChild(self.commonNode)    

    self.miracleNode = cc.Node:create()
    self.pointPanel:addChild(self.miracleNode)

    self.superFightNode = cc.Node:create()
    self.pointPanel:addChild(self.superFightNode)

    self.superFightNode:setLocalZOrder(1024)

    self.m_scrollView:setViewDidScroll(function()
        
        -- dump(self.m_scrollView:getContentOffset())
    end)

    self:initTouch()

    self:qiji_call(self.qiji_btn,nil)

    if global.unionData:isHadPower(18) then
        self:union_call(self.union_btn,nil)
    end    

    self.isDraw = false

    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function(  )
        
        if not global.g_worldview.isInit then return end

        global.worldApi:mapMiracle(handler(self,self.createMiracle))    
        uiMgr:addWidgetTouchHandler(self.root.btn1, function(sender, eventType) self:back_call(sender, eventType) end)
    end)))

    self:union_vag_call(self.union_vag_btn,nil)
    -- self:shili_call(self.shili_btn,nil)

    self.qiji_name_btn.switch:setVisible(true)
    self.qiji_name_btn:setLocalZOrder(100)
    self.qiji_name_btn:setSwallowTouches(true)

    self.add:setContentSize(cc.size(78,670))
    self.add:setPositionY(685)
    self.add:setOpacity(0)

    local btns = {'union_vag_btn','qiji_btn','union_btn','qiji_name_btn','zhanling_btn','shili_btn'}
    for index,v in ipairs(btns) do
        self[v]:setVisible(false)
    end

    if not global.userData:isOpenFullMap() then
        self:flushWorldSurface()
    else
        
        self.mapNode.map_cloud_export:setVisible(false)
    end    
end

function UINewWorldMap:flushWorldSurface()
    local bossActivityId = global.ActivityData:getWorldBossActivity()
    local activitys = {[25001] = 1,[26001] = 2,[27001] = 3,[28001] = 4}
    local bossId = activitys[bossActivityId]
    local btn = self.mapNode['boss01']

    btn:loadTextureNormal("ui_surface_icon/world_boss_mini_icon".. bossId ..".png",ccui.TextureResType.plistType)
    btn:loadTexturePressed("ui_surface_icon/world_boss_mini_icon".. bossId ..".png",ccui.TextureResType.plistType) 
end

function UINewWorldMap:onExit()
    
    self.m_scrollView:setTouchEnabled(false)
    self.isNode1Out = true
    self.isChoosed = false
end

function UINewWorldMap:getMapColorByAvatar( avatarType )
    
    --0 中立 1 自己 2 同盟 3 联盟 4 敌对
    if avatarType == 0 then --中立

        return cc.c3b(255,243,45)
    elseif avatarType == 1 then --

        return cc.c3b(4,194,255)
    elseif avatarType == 2 then --

        return cc.c3b(20,198,10)
    elseif avatarType == 3 then --

        return cc.c3b(20,198,10)
    elseif avatarType == 4 then --

        return cc.c3b(192,10,10)
    else
        
        if self:isEmpty() then
            return cc.c3b(255,243,255)
        else
            return cc.c3b(255,243,45)
        end        
        -- return cc.c3b(255,255,255)
    end
end

function UINewWorldMap:onEnter()
   
    self.isNode1Out = true
    self.incall:runAction(cc.RotateTo:create(0,0))
    self.node1_parent:setPositionX(0)
    -- self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(75,1279)),0))

    uiMgr:addSceneModel(0.5) 
    
    self.m_scrollView:setTouchEnabled(true)

    local nodeTimeLine = resMgr:createTimeline("world/map_spot")    
    nodeTimeLine:play("animation0", true)
    self.currentPos:runAction(nodeTimeLine)


    self.m_scrollView:stopAllActions()
    self.m_scrollView:setScale(1)

    self:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function()
        self:scrollToPoint(true)

        self.m_scrollView:setScale(5)
        self.m_scrollView:runAction(cc.ScaleTo:create(0.5,1))
    end)))
    
    self.isHavaScroll = false

    if self.mainCity then 

        self.mainCity:setPosition(self:checkSide(self:convertBigPos(g_worldview.worldPanel.mainCityPos)))
    end

    global.worldApi:getUnioInfo(handler(self,self.createUnion))
    global.worldApi:getSuperFightInfo(handler(self,self.createSuperFight))

    -- self.m_scrollView:setScale(5)
    -- self.m_scrollView:runAction(cc.ScaleTo:create(0.5,1))

    -- 每次进入重置0帧
    local timeLine = resMgr:createTimeline("world/world_big")    
    self.root:runAction(timeLine)
    timeLine:gotoFrameAndPause(0)

    self.effectNode:removeAllChildren()

    local fire = resMgr:createCsbAction("effect/world_middle", "animation0", true, false)
    self.effectNode:addChild(fire)

    self.isShowName = false 
end

function UINewWorldMap:translateNode()
    
    self.pointPanel = self.mapNode.pointPanel
    self.mapNode:setLocalZOrder(10)
    self.currentPos = self.pointPanel.currentPos_export
end

function UINewWorldMap:checkOffset(pos)

    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    local size = self.pointPanel:getContentSize()
    pos.x = pos.x - size.width / 2
    pos.y = pos.y - size.height / 2

    local xPen = (pos.x / size.width) * 2048 * map_width * -1
    local yPen = (pos.y / size.height) * 2048 * map_width * -1

    local scrollview = global.panelMgr:getPanel("UIWorldPanel").m_scrollView
    return scrollview:checkOffsetIsCanJump(cc.p(xPen,yPen))
end

function UINewWorldMap:choosePos(pos, isSpecial)

    if isSpecial then
        pos = self:checkSide(pos,nil,true)
    end
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    local size = self.pointPanel:getContentSize()
    pos.x = pos.x - size.width / 2
    pos.y = pos.y - size.height / 2

    local xPen = (pos.x / size.width) * 2048 * map_width * -1
    local yPen = (pos.y / size.height) * 2048 * map_width * -1

    global.panelMgr:destroyPanel("UINewWorldMap")
    local scrollview = global.panelMgr:getPanel("UIWorldPanel").m_scrollView
    scrollview:setOffset(cc.p(xPen,yPen))
end

function UINewWorldMap:touchBegan(touch, event)

    self.moveDt = 0
    return true
end

function UINewWorldMap:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UINewWorldMap:scrollToPoint(isNeedAcction)

    if not isNeedAcction then

        if self.isHavaScroll then

            return
        else

            self.isHavaScroll = true 
        end
    end 

    local pos = self.currentPos:convertToWorldSpace(cc.p(0,0))
    local zoomScale = self.m_scrollView:getZoomScale()
    pos.x = pos.x-- / zoomScale
    pos.y = pos.y-- / zoomScale

    -- dump(pos,">>>>>>>>>>>check poo")

    local contentOffset = self.m_scrollView:getContentOffset()
    contentOffset.x = contentOffset.x - (pos.x - gdisplay.width / 2)
    contentOffset.y = contentOffset.y - (pos.y - gdisplay.height / 2)


    if contentOffset.x > 0 then

        contentOffset.x = 0
    end

    if contentOffset.y > 0 then

        contentOffset.y = 0
    end

    if contentOffset.x < -self.panelSize.width * zoomScale + gdisplay.width then
        contentOffset.x = -self.panelSize.width * zoomScale + gdisplay.width
    end

    if contentOffset.y < -self.panelSize.height * zoomScale + gdisplay.height then
        contentOffset.y = -self.panelSize.height * zoomScale + gdisplay.height
    end    

    self.m_scrollView:setContentOffset(contentOffset, not isNeedAcction)

    -- dump(pos,">>>>>>>current pos is")
end

function UINewWorldMap:touchMoved(touch, event)

    self.moveDt = self.moveDt + cc.pGetLength(touch:getDelta())
end

function UINewWorldMap:createSuperFight(msg)
    
    local points = msg.tgFight or {}

    for i,p in ipairs(points) do
        -- local s = cc.Sprite:createWithSpriteFrameName(typeIcon[p.ltype])
        
        local s = ccui.Button:create("ui_surface_icon/map_big17.png","ui_surface_icon/map_big17.png",nil,ccui.TextureResType.plistType)
        if not tolua.isnull(self.superFightNode) then
            self.superFightNode:addChild(s)
        end
        s:setSwallowTouches(false)
        s:setAnchorPoint(cc.p(0.5,0))
        s:setLocalZOrder(-p.lposy)        
        local pos = cc.p(0, 0) 
        if self.convertBigPos then
            pos = self:convertBigPos(cc.p(p.lposx,p.lposy))
        end
        s:setPosition(self:checkSide(pos))
        uiMgr:addWidgetTouchHandler(s, function(sender, eventType) 
            if self.onBigWorldPos then
                self:onBigWorldPos(cc.p(sender:getPosition()))
            end
        end)       
    end
end

function UINewWorldMap:createUnion(msg)
    
    local points = msg.tgPos or {}
    if tolua.isnull(self.unionNode) then return end
    
    local children = self.unionNode:getChildren()
    for _,v in ipairs(children) do

        local isCreate = false
        for _,p in ipairs(points) do

            if v:getTag() == p.lid then
            
                isCreate = true
                break
            end
        end

        if isCreate == false then

            v:removeFromParent()
        end
    end

    local mainId = global.userData:getWorldCityID()

    for i,p in ipairs(points) do
        -- local s = cc.Sprite:createWithSpriteFrameName(typeIcon[p.ltype])
        
        if p.lid ~= mainId then
        
            local child = self.unionNode:getChildByTag(p.lid) 
            if child == nil then

                local s = nil

                if p.lAllyRank ~= 5 then
                    s = ccui.Button:create("ui_surface_icon/map_big03.png","ui_surface_icon/map_big03.png",nil,ccui.TextureResType.plistType)
                else
                    s = ccui.Button:create("ui_surface_icon/map_big03boss.png","ui_surface_icon/map_big03boss.png",nil,ccui.TextureResType.plistType)
                end
                
                self.unionNode:addChild(s)
                s:setSwallowTouches(false)
                s:setAnchorPoint(cc.p(0.5,0))
                s:setTag(p.lid)
                s:setLocalZOrder(-p.lposy)
                local pos = self:convertBigPos(cc.p(p.lposx,p.lposy))
                s:setPosition(self:checkSide(pos))
                uiMgr:addWidgetTouchHandler(s, function(sender, eventType) 
                    self:onBigWorldPos(cc.p(sender:getPosition()))
                end)
            else

                local pos = self:convertBigPos(cc.p(p.lposx,p.lposy))
                child:setPosition(self:checkSide(pos))
                child:setLocalZOrder(-pos.y)
                uiMgr:addWidgetTouchHandler(child, function(sender, eventType) 
                    self:onBigWorldPos(cc.p(sender:getPosition()))
                end)
            end
        end        
    end
end

function UINewWorldMap:printMap(points)
    
    local str = ""
    for i,p in ipairs(points) do

        if p.ltype < 50 or p.ltype == 500 then
        
            local pos = self:convertBigPos(cc.p(p.lposx,p.lposy))
            str = str .. string.format("<object id=\"%s\" x=\"%s\" y=\"%s\"/>\n",i,pos.x,1850-pos.y)
        end        
    end

    print(str)
end

local tempPos = cc.p(0,0)
function UINewWorldMap:createMiracle(msg)

    -- dump(msg)
    tempPos = cc.p(0,0)
    local luaCfg = global.luaCfg
    local worldSurface = luaCfg:world_surface()

    local points = msg.tgMiracle or {}
    local typeIcon = {}

    for k,v in pairs(worldSurface) do
        typeIcon[v.type] = v.bigmap
    end

    self.miracleData = {}

    local cityPos = g_worldview.worldPanel.mainCityPos or {}  --protect 
    table.insert(points,{

            lid = 0,
            lposx = cityPos.x,
            lposy = cityPos.y,
            ltype = 51,
        })


    -- self:printMap(points)

    for i,p in ipairs(points) do
        
        local isNeedHide = false
        if p.ltype >= 31 and p.ltype <= 35 then

            if not (global.debugData and global.debugData.isOpenRandom)then
              
                isNeedHide = true  
            end
        end

        isNeedHide = isNeedHide or p.ltype == 600

        if not isNeedHide then
            
            local btnIcon = typeIcon[p.ltype]
            local truePos = cc.p(p.lposx,p.lposy)
            local landId = global.g_worldview.const:convertPix2LandId(cc.p(-p.lposx,-p.lposy))
            local pos = cc.p(0, 0)
            if self.convertBigPos then
                pos = self:convertBigPos(truePos)
            end
            
            local s = nil

            if p.ltype == 500 then                
                local world_miracle_name = luaCfg:get_world_miracle_name_by(landId)
                btnIcon = world_miracle_name.icon
                s = ccui.Button:create(btnIcon,btnIcon,nil,ccui.TextureResType.plistType)        
            
                local widget = resMgr:createWidget("world/map_miracle_name")
                uiMgr:configUITree(widget)
                s:addChild(widget)

                widget.name_export:setString(world_miracle_name.name)

                if p.szOwnerName then

                    widget.name_export.owenr_name_export:setString(((p.szallyFlag ~= '') and ('【' .. p.szallyFlag .. '】') or '') .. p.szOwnerName)
                    if self.getMapColorByAvatar then
                        widget.name_export.owenr_name_export:setColor(self:getMapColorByAvatar(p.lAvatar))
                    end
                else
                    if self.getMapColorByAvatar then
                        widget.name_export.owenr_name_export:setColor(self:getMapColorByAvatar(0))
                    end
                    widget.name_export.owenr_name_export:setString(luaCfg:get_local_string(10818))
                end                
            else
                s = ccui.Button:create(btnIcon,btnIcon,nil,ccui.TextureResType.plistType)        
            end

            s:setSwallowTouches(false)
            s:setAnchorPoint(cc.p(0.5,0.5))
            s:setPosition(self:checkSide(pos))
            s:setTag(p.ltype)
            

            uiMgr:addWidgetTouchHandler(s, function(sender, eventType) 
                if self.moveDt > 20 then 
                        gsound.stopEffect("city_click")
                        return 
                end
                if sender:getTag() == 51 then
                    self:onBigWorldPos(tempPos)
                else
                    self:onBigWorldPos(cc.p(sender:getPosition()))
                end
            end)

            if p.ltype == 51 then
                tempPos = pos
                self.mainCity = s            
            end

            s.data = p

            if p.ltype < 50 or p.ltype == 500 or p.ltype > 800 then
                if not tolua.isnull(self.miracleNode) then
                    self.miracleNode:addChild(s)
                end
            else
                if not tolua.isnull(self.commonNode) then
                    self.commonNode:addChild(s)
                end
            end                 

            if p.ltype == 500 then            

                self.miracleData[landId] = p
            end
        end        
    end

    if self.initAllySort then
        self:initAllySort()    
    end

    if cc.UserDefault:getInstance():getBoolForKey("isopenshili",true) and self.shili_call then
        self:shili_call(self.shili_btn,nil)
    end
end

function UINewWorldMap:initAllySort()
    
    local allyCache = {}
    local allyTime = {}
    local allyScore = {}
    local childs = self.miracleNode:getChildren()
    self.allyData = {}    

    for i,v in ipairs(childs) do        

        if v.data.lAllyID then

            local id = v.data.lAllyID
            if id ~= 0 then
            
                allyCache[id] = allyCache[id] or 0            
                allyCache[id] = allyCache[id] + 1          
    
                allyTime[id] = allyTime[id] or 0
                if v.data.lOccupyTime > allyTime[id] then

                    allyTime[id] = v.data.lOccupyTime
                end

                allyScore[id] = allyScore[id] or 0
                allyScore[id] = allyScore[id] + (v.data.ltype - 10)

                self.allyData[id] = v.data
            end            
        end        
    end

    self.tmpAllyCache = {}
    for k,v in pairs(allyCache) do

        table.insert(self.tmpAllyCache,{score = allyScore[k],id = k,count = v,time = allyTime[k]})
    end

    table.sortBySortList(self.tmpAllyCache,{{"count","max"},{"score","max"},{"time","min"}})

    -- table.sort(self.tmpAllyCache,function(a,b)
        
    --     if a.count == b.count then

    --         return a.time < b.time
    --     end

    --     return a.count > b.count
    -- end)    

    -- dump(self.tmpAllyCache)

    for i,v in ipairs(childs) do        
        
        if v.data.ltype ~= 500 then
            if v.data.lAllyID then

                local id = v.data.lAllyID
                local sort = self:getAllySort(id)
                if sort <= 10 then

                    v:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(sort).color)))
                else

                    v:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(11).color)))
                end
            else

                v:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(12).color)))
            end
        end 
    end
end

function UINewWorldMap:getAllyInfoBySort(sort)
    
    self.tmpAllyCache = self.tmpAllyCache or {}
    local data = self.tmpAllyCache[sort]    

    if data == nil then

        return nil
    else

        return {count = data.count,name = string.format("【%s】%s",self.allyData[data.id].szallyFlag,self.allyData[data.id].szAllyName)}
    end    
end

function UINewWorldMap:getAllyInfoByMiracleType(mType)

    if not self.miracleData then return end
    dump(self.miracleData,"self.miracleData")
    return self.miracleData[mType]
end

function UINewWorldMap:getAllySort(id)
    
    if id == 0 then return 11 end

    for i,v in ipairs(self.tmpAllyCache) do

        if v.id == id then

            return i
        end
    end
end

function UINewWorldMap:testDraw()
    
    local childs = self.miracleNode:getChildren()

    local resData = {}
    local lineWidth = 240
    local points = {}    

    for i,v in ipairs(childs) do        

        if v.data.lAllyID then

            table.insert(resData,i)
        end
        
        v:setTag(i)        
        table.insert(points,v)
    end

    local draw1 = cc.DrawNode:create()
    draw1:setAnchorPoint(cc.p(0,0))
    draw1:setPosition(cc.p(0,0))
    self.pointPanel:addChild(draw1,998)

    self.drawNode = draw1
    self.drawNode:setVisible(false)

    local allyLineCache = {}

    local map = cc.TMXTiledMap:create("map/file/newWorldMap2.tmx")
    local data = map:getObjectGroup("data")
    local wayData = data:getObjects()
    local lineCache = {}

    local tmpPoints = {}
    for _,j in ipairs(resData) do
        
        local node = self.miracleNode:getChildByTag(j)
        local point3 = cc.p(self.miracleNode:getChildByTag(j):getPosition())
        table.insert(tmpPoints,point3)
    end

    local abs = function(a)
        
        if a < 0 then 
            return -a
        else
            return a
        end
    end 

    local isPointEquie = function(p1,p2)    --判断俩个点是否相等
        
        -- return p1.x == p2.x and p1.y == p2.y
        return (abs(p1.x - p2.x) < 10 and abs(p1.y - p2.y) < 10)
    end  
    
    -- local isPointEquie_tmp = function(p1,p2)    --判断俩个点是否相等
        
    --     return (abs(p1.x - p2.x) < 10 and abs(p1.y - p2.y) < 10)
    -- end

    local convertToSamePoint = function(point)
        
        for _,v in ipairs(tmpPoints) do

            if isPointEquie(v,point) then

                return clone(v)
            end
        end

        return point
    end

    for i,v in ipairs(wayData) do        

        local startPos = cc.p(v.polylinePoints[1].x + v.x,(v.y - v.polylinePoints[1].y))
        local endPos = cc.p(v.polylinePoints[2].x + v.x,(v.y - v.polylinePoints[2].y))
        -- draw1:drawSegment(startPos,endPos, 3, {r = 0,g = 1,b = 0, a = 0.2}) 

        table.insert(lineCache,{[1] = convertToSamePoint(startPos),[2] = convertToSamePoint(endPos)})
    end

    

    for _,j in ipairs(resData) do
        
        local node = self.miracleNode:getChildByTag(j)
        local point3 = cc.p(self.miracleNode:getChildByTag(j):getPosition())
        local line = {}
        
        for _,i in ipairs(lineCache) do
            
            if isPointEquie(point3,i[1]) then
               
                table.insert(line,i[2])
            end

            if isPointEquie(point3,i[2]) then
               
                table.insert(line,i[1])
            end
        end

        local sortFun = function(pos1,pos2)
            
            local ang1 = cc.pToAngleSelf(cc.pSub(point3,pos1))
            local ang2 = cc.pToAngleSelf(cc.pSub(point3,pos2))

            return ang1 > ang2
        end

        table.sort(line,sortFun)

        if #line ~= 1 then

            local centerPoss = {}

            local lineCount = #line

            for i = 1,lineCount do
                
                local nextIndex = i + 1

                local pos1 = line[i]
                
                if i == lineCount then

                    nextIndex = 1
                end

                local pos2 = line[nextIndex]
            
                local centerPos = cc.p((pos1.x + pos2.x + point3.x) / 3,(pos1.y + pos2.y + point3.y) / 3)
                
                table.insert(centerPoss,centerPos)
            end     --放置三角形中心

            for i = 1,lineCount do

                line[i] = cc.p((line[i].x + point3.x) / 2,(line[i].y + point3.y) / 2)
            end     --放置边的中点
            
            for _,v in ipairs(centerPoss) do

                table.insert(line,v)
            end

            table.sort(line,sortFun)
        end
    
        local colors = {
            {r = 38 / 255,g = 202/ 255,b = 101/ 255, a = 0.35},
            {r = 255/ 255,g = 255/ 255,b = 114/ 255, a = 0.35},
            {r = 255/ 255,g = 143/ 255,b = 84/ 255, a = 0.35},
            {r = 255/ 255,g = 56/ 255,b = 19/ 255, a = 0.35},
            {r = 18/ 255,g = 208/ 255,b = 255/ 255, a = 0.35}
        }

        local allySort = self:getAllySort(node.data.lAllyID)        
        local allyId = node.data.lAllyID
        allyLineCache[allyId] = allyLineCache[allyId] or {}

        if allySort <= 10 then
        
            local colorData = luaCfg:get_map_color_by(allySort).color
            local color = {r = colorData[1] / 255,g = colorData[2] / 255,b = colorData[3] / 255,a = 0.25}

            lineCount = #line

            for i = 1,lineCount do

                local nextIndex = i + 1
                local pos1 = line[i]            
                if i == lineCount then

                    nextIndex = 1
                end
                local pos2 = line[nextIndex]

                draw1:drawTriangle(point3,pos1,pos2,color)                 
        
                table.insert(allyLineCache[allyId],{[1] = pos1,[2] = pos2})
            end

            -- draw1:drawPolygon(line,#line,color,2,{r = 0,g = 0,b = 0,a = 0.1})
        end                
    end

    local alreadyDrawLineCache = nil
    local finalLineCache = {}

    local checkIsAlreadyDraw = function(startPos,endPos)

        for _,v in ipairs(alreadyDrawLineCache) do

            if (isPointEquie(v[1],startPos) and isPointEquie(v[2],endPos)) or isPointEquie(v[2],startPos) and isPointEquie(v[1],endPos) then

                return true
            end
        end

        return false
    end

    for _,v in pairs(allyLineCache) do        

        alreadyDrawLineCache = {}
        local needDrawCache = {}

        for _,vv in ipairs(v) do

            if not checkIsAlreadyDraw(vv[1],vv[2]) then
                
                table.insert(needDrawCache,{[1] = clone(vv[1]),[2] = clone(vv[2])})                
                table.insert(alreadyDrawLineCache,{[1] = clone(vv[1]),[2] = clone(vv[2])})
            else

                for i,v in ipairs(needDrawCache) do

                    if (isPointEquie(v[1],vv[1]) and isPointEquie(v[2],vv[2])) or isPointEquie(v[2],vv[1]) and isPointEquie(v[1],vv[2]) then

                        table.remove(needDrawCache,i)                    
                    end        
                end
            end            
        end

        for _,vv in ipairs(needDrawCache) do
                        
            table.insert(finalLineCache,{[1] = clone(vv[1]),[2] = clone(vv[2])}) 
        end
    end


    alreadyDrawLineCache = {}
    for _,vv in ipairs(finalLineCache) do

        if not checkIsAlreadyDraw(vv[1],vv[2]) then
               
            draw1:drawSegment(vv[1],vv[2],2,{r = 37 / 255,g = 52 / 255,b = 0,a = 0.20})       
            table.insert(alreadyDrawLineCache,{[1] = clone(vv[1]),[2] = clone(vv[2])})        
        end         
    end
end

function UINewWorldMap:onBigWorldPos(pos)


    if self.isChoosed then
        return
    end

    if self.moveDt > 20 then return end

    if not self:checkOffset(clone(pos)) then return end

    self.isChoosed = true

    self.currentPos:setPosition(self:checkSide(pos))

    self.m_scrollView:stopAllActions()
    self.m_scrollView:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.ScaleTo:create(0.5,5),cc.CallFunc:create(function()
        self:choosePos(pos)
    end)))

    self:scrollToPoint()
end

function UINewWorldMap:touchEnded(touch, event)

    local pos = touch:getLocation()

    local call = function()

        if self.isChoosed then
            return
        end

        if not self.moveDt then return end

        if self.moveDt > 20 then return end

        pos = self.pointPanel:convertToNodeSpace(pos)

        if not self:checkOffset(clone(pos)) then return end
        
        self.isChoosed = true

        self.currentPos:setPosition(self:checkSide(pos, true))

        self:scrollToPoint()

        self.m_scrollView:stopAllActions()
        self.m_scrollView:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.ScaleTo:create(0.5,5),cc.CallFunc:create(function()
            self:choosePos(pos, true)
        end)))  
    end

    
    global.delayCallFunc(function()
        call()
    end,nil,0)
end

function UINewWorldMap:initTouch()

    local  listener = cc.EventListenerTouchOneByOne:create()

    local touchNode = cc.Node:create()
    touchNode:setLocalZOrder(9)
    self.root:addChild(touchNode)

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self.touchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self.touchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self,self.touchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
    
end

function UINewWorldMap:setCurrentPos(pos)
    
    local pos = self:convertBigPos(pos) 
    print(" ///////////////////////////// UINewWorldMap ///////////////////////////")
    print(" --- posX:" .. pos.x)   
    print(" --- posY:" .. pos.y)  
    self.currentPos:setPosition(self:checkSide(pos))    
end

function UINewWorldMap:checkSide(pos, isSelected, isSpecial)

    local pos = clone(pos)
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH
    local size = self.pointPanel:getContentSize()
    local px = pos.x - size.width / 2
    local py = pos.y - size.height / 2

    local xPen = (px / size.width) * 2048 * map_width * -1
    local yPen = (py / size.height) * 2048 * map_width * -1

    local scrollview = global.panelMgr:getPanel("UIWorldPanel").m_scrollView
    local i,j = g_worldview.const:convertPix2MapIndex(cc.p(xPen, yPen))
    local areaId = global.g_worldview.areaDataMgr:checkArea(i,j) 
    if areaId and areaId == 1 then        

        local maxX, maxY = 1460, 857
        if pos.x >= maxX then            
            if isSpecial then
                pos = cc.p(1597,834) 
            else
                pos.x = maxX
            end
        -- else
        --     local offsetX = 30
        --     if isSelected then             
        --     elseif isSpecial then
        --         pos.x = pos.x + offsetX
        --     else
        --         pos.x = pos.x - offsetX
        --     end
        end

    end
    return pos
end

function UINewWorldMap:convertBigPos(pos)
    
    local map_width = WCONST.WORLD_CFG.INFO.MAP_WIDTH

    local size = self.pointPanel:getContentSize()

    local xPen = (pos.x / (2048 * map_width)) * size.width
    local yPen = (pos.y / (2048 * map_width)) * size.height

    xPen = xPen + size.width / 2
    yPen = yPen + size.height / 2

    return cc.p(xPen,yPen)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UINewWorldMap:back_call(sender, eventType)

    global.panelMgr:destroyPanel("UINewWorldMap")
end

function UINewWorldMap:exit_call(sender, eventType)

    
end

function UINewWorldMap:chooseBoss(bossId)    
    local bossIds = {160229999,580169999,250649999,640559999}
    local pos = global.g_worldview.const:convertCityId2Pix(bossIds[bossId],true)
    self:onBigWorldPos(self:convertBigPos(pos))
end

function UINewWorldMap:out_call(sender, eventType)

    self.moveDt = 21  -- 防止 点击按钮时 会定位到其他地方

    -- if eventType == ccui.TouchEventType.began then 

    --     local nodeTimeLine = resMgr:createTimeline("world/world_big")
    --     nodeTimeLine:setLastFrameCallFunc(function()

    --     end)
    --     nodeTimeLine:play("animation1", false)
    --     self.root:runAction(nodeTimeLine)

    -- end 
    
end

function UINewWorldMap:in_call(sender, eventType)

    self.moveDt  = 21  -- 防止 点击按钮时 会定位到其他地方
    
    if self.isNode1Out then
        self.isNode1Out = false
        self.node1_parent:stopAllActions()
        self.incall:runAction(cc.RotateTo:create(0.35,180))
        self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(-150,self.node1_parent:getPositionY())),2))
        -- self.left_modal:setTouchEnabled(false)
        -- self.left_modal:runAction(cc.FadeOut:create(0.35))
    else
        self.isNode1Out = true
        self.node1_parent:stopAllActions()
        self.incall:runAction(cc.RotateTo:create(0.35,0))        
        self.node1_parent:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(0,self.node1_parent:getPositionY())),2))
        -- self.left_modal:setTouchEnabled(true)
        -- self.left_modal:runAction(cc.FadeIn:create(0.35))
    end

    -- if eventType == ccui.TouchEventType.began then 

    --     local nodeTimeLine = resMgr:createTimeline("world/world_big")
    --     nodeTimeLine:setLastFrameCallFunc(function()
    --     end)
    --     nodeTimeLine:play("animation0", false)
    --     self.root:runAction(nodeTimeLine)
        
    -- end 

end

function UINewWorldMap:qiji_call(sender, eventType)

    sender.switch:setVisible(not sender.switch:isVisible())
    self.miracleNode:setVisible(not sender.switch:isVisible())
end

function UINewWorldMap:union_vag_call(sender, eventType)
    
    sender.switch:setVisible(not sender.switch:isVisible())
    self.mapNode.range1_export:setVisible(not sender.switch:isVisible())
    self.mapNode.range2_export:setVisible(not sender.switch:isVisible())
    self.mapNode.range3_export:setVisible(not sender.switch:isVisible())
    self.mapNode.range4_export:setVisible(not sender.switch:isVisible())

    self.mapNode.Node_3:setVisible(not sender.switch:isVisible())

    if not sender.switch:isVisible() then
        
        for i=1,4 do
            local timeLine = resMgr:createTimeline("world/map_range_name" .. i)
            timeLine:play("animation0", false)
            self.mapNode.Node_3["range" .. i .. "_name_export"]:runAction(timeLine)          
        end        
    end

    if not sender.switch:isVisible() then
        if not self.shili_btn.switch:isVisible() then
            self.drawNode:setVisible(false)
        end
    else
        if not self.shili_btn.switch:isVisible() then
            self.drawNode:setVisible(true)
        end
    end
end

function UINewWorldMap:shili_call(sender, eventType)    

    if not self.isDraw then

        self.isDraw = true
        self:testDraw() 
    end
    
    sender.switch:setVisible(not sender.switch:isVisible())
    cc.UserDefault:getInstance():setBoolForKey("isopenshili",not sender.switch:isVisible())
    self.drawNode:setVisible(not sender.switch:isVisible())


    if not sender.switch:isVisible() then
        if not self.union_vag_btn.switch:isVisible() then
            
            self.mapNode.Node_3:setVisible(false)
            self.mapNode.range1_export:setVisible(false)
            self.mapNode.range2_export:setVisible(false)
            self.mapNode.range3_export:setVisible(false)
            self.mapNode.range4_export:setVisible(false)    
        end
    else
        if not self.union_vag_btn.switch:isVisible() then
            
            self.mapNode.Node_3:setVisible(true)
            self.mapNode.range1_export:setVisible(true)
            self.mapNode.range2_export:setVisible(true)
            self.mapNode.range3_export:setVisible(true)
            self.mapNode.range4_export:setVisible(true)
        
            for i=1,4 do
                local timeLine = resMgr:createTimeline("world/map_range_name" .. i)
                timeLine:play("animation0", false)
                self.mapNode.Node_3["range" .. i .. "_name_export"]:runAction(timeLine)          
            end    
        end
    end
end

function UINewWorldMap:union_call(sender, eventType)

    if global.unionData:isMineUnion(0) then
    
        global.tipsMgr:showWarning("UnionMap01")
        return
    end

    if not global.unionData:isHadPower(18) then

        global.tipsMgr:showWarning("UnionMapXY01")
        return
    end

    sender.switch:setVisible(not sender.switch:isVisible())
    self.unionNode:setVisible(not sender.switch:isVisible())
end

function UINewWorldMap:showInfo(sender, eventType)

    global.panelMgr:openPanel("UIWorldMapInfo"):setData()
end


function UINewWorldMap:enterBossMap(sender,eventType)

    if self.moveDt > 20 then  --
        gsound.stopEffect("city_click")
        return
    end

    
    -- print(">>>enter world map")
    self:onBigWorldPos(cc.p(1600,1052))
end


function UINewWorldMap:showName(sender, eventType)

    if self.isShowName then 

        self.isShowName = false 
    else 
        self.isShowName = true 
    end 

    local addWidget = function (point, state)

        local world_miracle_name = luaCfg:get_all_miracle_name_by(point.data.lid)

        if not world_miracle_name then 
            return 
        end 


        local widget = resMgr:createWidget("world/map_miracle_name")
        uiMgr:configUITree(widget)
        point:addChild(widget)
        widget.name_export.owenr_name_export:setVisible(false)
        point.name_widget = widget
        if world_miracle_name then 
            widget.name_export:setString(world_miracle_name.name)
            
            if point.data.ltype > 800 then
                widget.name_export:setPositionX(30)
                widget.name_export:setPositionY(70)
            else
                widget.name_export:setPositionX(18)
                widget.name_export:setPositionY(50)
            end

            widget.name_export:setVisible(state)

            if point.data.ltype == 14 then 
                widget.name_export:setPositionX(35)
                widget.name_export:setPositionY(78)
            end 
        end

    end 

    local set = function (state)
        local childs = self.miracleNode:getChildren()
        for i,v in ipairs(childs) do        

        -- print(v.data.lid,'point.data.lid')
            if v.data.ltype < 50 or v.data.ltype > 800 then
                if v.name_widget then 
                    v.name_widget.name_export:setVisible(state)
                else 

        -- print(v.data.lid,'point.data.lid1aaadsss222222')
                    addWidget(v,  state)
                end  
            end 
        end        
    end 

    set(self.isShowName)

    self.qiji_name_btn.switch:setVisible(not self.isShowName)

end


function UINewWorldMap:changeToLineMap(sender, eventType)

    local btns = {'union_vag_btn','qiji_btn','union_btn','qiji_name_btn','zhanling_btn','shili_btn'}
    for index,v in ipairs(btns) do

        self[v]:stopAllActions()
        self.add:stopAllActions()

        if self.isOut then
            self.add:runAction(cc.FadeOut:create(0.5))
            self[v]:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.MoveTo:create(0.2,cc.p(665,53))),cc.Hide:create()))            
        else
            self.add:runAction(cc.FadeIn:create(0.5))            
            self[v]:runAction(cc.Sequence:create(cc.DelayTime:create(0.035 * index),cc.Show:create(),cc.EaseBackOut:create(cc.MoveTo:create(0.2,cc.p(665,95 * index + 66)))))            
        end        
    end

    self.isOut = not self.isOut 
end

function UINewWorldMap:kingHandler(sender, eventType)

    global.panelMgr:openPanel('UIOfficalPanel'):setData()
end
--CALLBACKS_FUNCS_END

return UINewWorldMap

--end
