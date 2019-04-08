-- author : wuwx
local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local FlogMgr = class("FlogMgr")

function FlogMgr:ctor()

    self.allRenderCity = {}

    --一次性处理的区域
    self.size = cc.size(gdisplay.width*2,gdisplay.height*2)
end

function FlogMgr:init()
end

function FlogMgr:onEnter()
end

function FlogMgr:onExit()
    if self.m_schedule then
        gscheduler.scheduleGlobal(self.m_schedule)
        self.m_schedule = nil
    end
end

function FlogMgr:createFlog(worldPanel)
    if self.isInit then return end
    self.isInit = true
    local worldPanel = global.g_worldview.worldPanel or worldPanel
    local flog = cc.LayerColor:create(cc.c4b(0, 0, 0, 255*0.4))
    -- local containerSize = worldPanel:getWorldScrollView():getContainer():getContentSize()
    local containerSize = cc.size(2048*99,2048*99)
    -- local a = global.g_worldview.const:convertScreenPos2Map(cc.p(0,0))
    -- dump(a)
    flog:setPosition(cc.p(-containerSize.width*0.5,-containerSize.height*0.5))
    flog:setContentSize(containerSize)
    worldPanel:addWidgetToMapPanel(flog)

    self.m_viewNode = cc.Node:create()
    self.m_viewNode:setVisible(false)
    global.scMgr:CurScene():addChild(self.m_viewNode,999)

    -- self.m_schedule = gscheduler.performWithDelayGlobal(handler(self,self.update), 3)
end

function FlogMgr:update()
    self:createMulCityView()
    self:renderCurrScreenCityView()
end


function FlogMgr:createMulCityView()
    if self.m_viewNode then
        self.m_viewNode:removeAllChildren()
    end
    local citys = global.g_worldview.worldPanel:getWorldMapPanel():getAllCitys()
    for i,city in pairs(citys) do
        if city:isOwner() then
            self:createSCityView(500,city)
        end
    end
end

function FlogMgr:createSCityView(radius,city)
    radius = radius or 284
    local pos = city:getNewScreenPos()
    if not self:checkViewInScreen(radius,pos) then return end
    city:setRadius(radius)
    -- dump(pos)
    local s = cc.Sprite:createWithSpriteFrameName("ui_surface_icon/guide_region.png")
    self.m_viewNode:addChild(s)
    s:setBlendFunc(cc.blendFunc(gl.ONE,gl.ONE))

    local circleSize = s:getContentSize()
    local scale = math.max(radius/circleSize.width,radius/circleSize.height)
    s:setScale(scale)
    s:setPosition(pos)
    -- city:addChild(s)
    return s
end

function FlogMgr:renderCurrScreenCityView()
    if not self.m_viewNode then return end
    self.m_viewNode:setVisible(true)
    local renderTexture = cc.RenderTexture:create(gdisplay.width,gdisplay.height,2)
    renderTexture:beginWithClear(0,0,0,0)
    self.m_viewNode:visit()
    renderTexture:endToLua()
    self.m_index = self.m_index or 0
    self.m_index = self.m_index+1
    -- renderTexture:saveToFile("test77777"..self.m_index..".png", cc.IMAGE_FORMAT_PNG, true);

    local sprite = renderTexture:getSprite()

    -- local worldPos = global.g_worldview.worldPanel:getWorldMapPanel():getScreenZeroToMapPos()
    local worldConst = global.g_worldview.const
    local worldPos = worldConst:convertScreenPos2Map(cc.p(0,0))
    -- print("##############worldPos")
    -- dump(worldPos)

    local newSprite = nil
    if self.m_screenPic then
        newSprite = self.m_screenPic
        newSprite:setSpriteFrame(sprite:getSpriteFrame())
    else
        newSprite = cc.Sprite:createWithSpriteFrame(sprite:getSpriteFrame())
        newSprite:setFlippedY(true)
        global.g_worldview.worldPanel:addWidgetToMapPanel(newSprite,1000)
    end
    newSprite:setBlendFunc(cc.blendFunc(gl.DST_COLOR,gl.ONE))
    -- self:getScrollViewLayer("effect"):addChild(newSprite,3)
    newSprite:setPosition(cc.p(worldPos.x+gdisplay.width*0.5,worldPos.y+gdisplay.height*0.5))
    self.m_screenPic = newSprite
    -- global.g_worldview.worldPanel:addChild(newSprite,100)
    -- self.m_viewNode:removeFromParent()
    self.m_viewNode:setVisible(false)
end

function FlogMgr:checkViewInScreen(radius,screenPos)
    local isIn = true
    local lx = screenPos.x-radius*0.5
    local ly = screenPos.y-radius*0.5
    local rx = screenPos.y+radius*0.5
    local ry = screenPos.y+radius*0.5

    if lx >= gdisplay.width then return false end
    if ly >= gdisplay.height then return false end
    if rx <= 0 then return false end
    if rx <= 0 then return false end
    return isIn
 end

--点击城池创建可见视野范围
function FlogMgr:createVisiViewBound(city)
    local radius = city:getRadius()
    -- local pos = city:getNewScreenPos()
    if radius <= 0 then return end
    -- dump(pos)
    local s = city:getChildByName("visible_view_bound_sprite")
    if s and not tolua.isnull(s) then
    else
        s = cc.Sprite:createWithSpriteFrameName("mapunit/vision_01.png")
        s:setName("visible_view_bound_sprite")
        city:addChild(s)
    end
    -- s:setBlendFunc(cc.blendFunc(gl.ONE,gl.ONE))

    local circleSize = s:getContentSize()
    local scale = math.max(radius/circleSize.width,radius/circleSize.height)
    s:setScale(scale)
    -- s:setPosition(cc.p(-circleSize.width*0.5,-circleSize.height*0.5))
    -- city:addChild(s)
    return s
end

--
function FlogMgr:removeVisiViewBound(city)
    local s = city:getChildByName("visible_view_bound_sprite")
    if s and not tolua.isnull(s) then
        s:removeFromParent()
    end
end

return FlogMgr