--region UISoldiersLine.lua
--Author : Administrator
--Date   : 2016/11/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local UISoldier = require("game.UI.world.widget.UISoldier")
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldiersLine  = class("UISoldiersLine", function() return gdisplay.newWidget() end )

--0 中立 1 自己 2 同盟 3 联盟 4 敌对
local type_list = {

    [0] = 5,
    [1] = 3,
    [2] = 4,
    [3] = 4,
    [4] = 5,
}

local def_file_list = {

    [0] = "animation/fybd_allface_y",
    [1] = "animation/fybd_allface",
    [2] = "animation/fybd_allface_g",
    [3] = "animation/fybd_allface_g",
    [4] = "animation/fybd_allface_r",
}

local att_file_list = {

    [0] = "animation/sibing_allface_y",
    [1] = "animation/sibing_allface",
    [2] = "animation/sibing_allface_g",
    [3] = "animation/sibing_allface_g",
    [4] = "animation/sibing_allface_r",
}

setmetatable(type_list, {__index = function()

    return 4
end})

function UISoldiersLine:getLevel(  )
    
    return 1
end

function UISoldiersLine:ctor(isMonster)
    
    self:CreateUI(isMonster)
    self.g_worldview = global.g_worldview
end

function UISoldiersLine:CreateUI(isMonster)    
    if isMonster then
        self.path = "animation/bdg_line"
    else
        self.path = "animation/soldiers_line"
    end

    local root = resMgr:createWidget(self.path)
    self:initUI(root,isMonster)
end

function UISoldiersLine:initUI(root,isMonster)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, self.path)

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.lineNode = self.root.lineNode_export
    self.FileNode_1 = self.root.lineNode_export.FileNode_1_export
    self.target = self.root.target_export
    self.name = self.root.Node.name_export
    self.hero_face = self.root.Node.hero_face_export

--EXPORT_NODE_END

    
    -- self.root.Node.nonono:setScale(2)
    self.root.Node:setScale(1.5)

    self.FileNode_2 = self.root.lineNode_export.FileNode_2
    self.FileNode_3 = self.root.lineNode_export.FileNode_3
    self.FileNode_4 = self.root.lineNode_export.FileNode_4
    self.FileNode_5 = self.root.lineNode_export.FileNode_5
    self.FileNode_6 = self.root.lineNode_export.FileNode_6
    self.FileNode_7 = self.root.lineNode_export.FileNode_7
    self.FileNode_8 = self.root.lineNode_export.FileNode_8
    
    local children = self.lineNode:getChildren() 
    for _,child in ipairs(children) do

        child:setLocalZOrder(-child:getPositionY())        
    end

    self.nodeTimeLine = resMgr:createTimeline(self.path)
    -- self.nodeTimeLine:gotoFrameAndPlay(10)
    self.root:runAction(self.nodeTimeLine)

    self:setScale(0.6)

    self.isHaveGO = false
    self.isSoldier = true
    self.worldPanel = global.g_worldview.worldPanel
    self.target:setVisible(false)
end

function UISoldiersLine:checkSide(ang,speed)
    
    local sideIndex = 1

    speed = speed or 1
    needChangeAng = 0

    if ang < 0 then ang = ang + 360 end    

    if ang > 22.5 and ang < 67.5 then sideIndex = 1 needChangeAng = 67.5 - ang end
    if ang > 67.5 and ang < 112.5 then sideIndex = 2 needChangeAng = 112.5 - ang end
    if ang > 112.5 and ang < 157.5 then sideIndex = 3 needChangeAng = 157.5 - ang end
    if ang > 157.5 and ang < 202.5 then sideIndex = 4 needChangeAng = 202.5 - ang end 
    if ang > 202.5 and ang < 247.5 then sideIndex = 5 needChangeAng = 247.5 - ang end
    if ang > 247.5 and ang < 292.5 then sideIndex = 6 needChangeAng = 292.5 - ang end
    if ang > 292.5 and ang < 337.5 then sideIndex = 7 needChangeAng = 337.5 - ang end
    if (ang > 337.5 and ang < 360) or (ang > 0 and ang < 22.5) then sideIndex = 8 eedChangeAng = 360 - ang end

    local frameIndex = sideIndex * 10    
    
    local children = self.lineNode:getChildren()
    for _,child in ipairs(children) do

        child.prePos = cc.p(child:getPosition())        
    end

    local targetPos = cc.p(self.target:getPosition())

    self.nodeTimeLine:gotoFrameAndPause(frameIndex)

    local afterPos = cc.p(self.target:getPosition())
    self.target:stopAllActions()
    self.target:setPosition(targetPos)    
    self.target:runAction(cc.MoveTo:create(0.3,afterPos))
    

    local children = self.lineNode:getChildren()

    table.sort(children,function(a,b)
        
        return a:getTag() < b:getTag()
    end)
   

    local soldierSpeed = speed
    local dt = 0.6 / soldierSpeed * 0.06
    local moveDt = 0.6 / soldierSpeed * 0.3

    for i,child in ipairs(children) do

        if child.side then

            -- child.side:setRotation(-needChangeAng * 2)

            if not self.isHaveGO then

                child.side:checkSide(sideIndex,child == self.FileNode_1)
                
            else

                local contentPos = cc.p(child:getPosition())        
                child:setLocalZOrder(-child:getPositionY())
                child:setPosition(child.prePos)
                child:stopActionByTag(1024)
                local moveTo = cc.Sequence:create(cc.DelayTime:create(dt * i),cc.CallFunc:create(function()
                    child.side:checkSide(sideIndex)
                end),cc.MoveTo:create(moveDt,contentPos))
                moveTo:setTag(1024)
                child:runAction(moveTo)
            end
        end        
    end

    self.isHaveGO = true

     -- print(self.FileNode_1:getPositionY())
end

function UISoldiersLine:getType()
    
    local type1 = type_list[self.data.lAvator]
    
    -- print(type1,"type1")

    return  type1
end

function UISoldiersLine:onExit()
    
    if self.bindChoose then

        global.g_worldview.mapPanel:closeChoose(true)
    end

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end

function UISoldiersLine:onEnter()
    
    -- self.scheduleListenerId = gscheduler.scheduleGlobal(function()

    --     self:checkRemove()
    -- end, 1)       
end

function UISoldiersLine:checkRemove()

    local i,j = self.g_worldview.const:convertPix2MapIndex(cc.p(self:getPosition()))
    if not self.g_worldview.areaDataMgr:isIndexInScreen(i,j) then

        self.g_worldview.attackMgr:removeTroop(self:getId())

        if self.scheduleListenerId then

            gscheduler.unscheduleGlobal(self.scheduleListenerId)
            self.scheduleListenerId = nil
        end
    end
end

function UISoldiersLine:closeChooseOpenAction()
    if self.bindChoose then

        self.bindChoose:noOpenAction()

    end    
end

function UISoldiersLine:setData(data)
    
    self.data = data

    local all = data.isMonster and 8 or 7

    if data.lWildKind == 1 and data.lDstType ~= 12 and data.lSrcType ~= 12 and data.lDstType ~= 14 and data.lSrcType ~= 14 then
        all = 1
    end

    local heroId = 0
    if self.data.lHeroID then heroId = self.data.lHeroID[1] end
    local heroData = luaCfg:get_hero_property_by(heroId)

    for i = 1,all do
    
        local sold = UISoldier.new()       
        if data.isMonster then
            sold:initUI('animation/bdg_guai')
        elseif data.lWildKind == 1 and data.lDstType ~= 12 and data.lSrcType ~= 12 and data.lDstType ~= 14 and data.lSrcType ~= 14 then
            sold:initUI('animation/caiji_budui')
        else

            local csbType = att_file_list[self.data.lAvator]
            if heroData and heroData.secType == 2 then
                csbType = def_file_list[self.data.lAvator]
            end
            sold:initUI(csbType)
        end

        self["FileNode_"..i]:addChild(sold)
        self["FileNode_"..i].side = sold
    end

    if not (data.isMonster or (data.lWildKind == 1 and data.lDstType ~= 12 and data.lSrcType ~= 12 and data.lDstType ~= 14 and data.lSrcType ~= 14 )) then
        self.FileNode_1.side:createFlag(self.data.lKind)
    end
    
    self.name:setString(self.data.szUserName)
    self.name:setTextColor(self:getColorByAvatar(self.data.lAvator))
        
    
    
    if not heroData then
    
        self.hero_face:setVisible(false)
    else
    
        -- self.hero_face:setSpriteFrame(heroData.nameIcon)
        global.panelMgr:setTextureFor(self.hero_face,heroData.nameIcon)
        self.hero_face:setVisible(true)
    end  
end

function UISoldiersLine:beChoose(choose,isHideSound)
   
    self.target:setVisible(true)
    self.bindChoose = choose
    global.g_worldview.worldPanel:gpsSoldier(self:getId()) 

    if not isHideSound then
        gevent:call(gsound.EV_ON_PLAYSOUND,"world_action")--音效添加（张亮）
    end 
    
    if self.isNeedCare == false then

        self.line:setVisible(not self.line:isVisible())

        if not tolua.isnull(self.targetSprite) then
            self.targetSprite:setVisible(self.line:isVisible())
        end
    else

        self.line:setVisible(true)
    end
end

function UISoldiersLine:getLineIsShow()
    
    return self.line:isVisible()
end

local function isINF(value)
  return value == math.huge or value == -math.huge or value ~= value
end

function UISoldiersLine:afterMove()

    if self == self.worldPanel.gpsTarget then

        local nextPos = cc.p(self:getPosition())
        if not(isINF(nextPos.x) or isINF(nextPos.y)) then
            self.worldPanel.m_scrollView:setOffset(cc.p(nextPos.x * -1,nextPos.y * -1))
        end        
    end

    if self.bindChoose then

        self.bindChoose:setPosition(self:getPosition())
    end
end


function UISoldiersLine:getColorByAvatar( avatarType )
    
    --0 中立 1 自己 2 同盟 3 联盟 4 敌对
    if avatarType == 0 then --中立

        return cc.c3b(255,213,45)
    elseif avatarType == 1 then --

        return cc.c3b(14,201,255)
    elseif avatarType == 2 then --

        return cc.c3b(55,255,17)
    elseif avatarType == 3 then --

        return cc.c3b(55,255,17)
    elseif avatarType == 4 then --

        return cc.c3b(255,30,7)
    else
        
        return cc.c3b(255,255,255)
    end
end

function UISoldiersLine:setIsNeedCare(isNeedCare)
    
    -- print("self.isNeedCare = isNeedCare",isNeedCare)
    self.isNeedCare = isNeedCare
end

function UISoldiersLine:beUnChoose()

    -- print(debug.traceback())

    if tolua.isnull(self) then return end

    self.target:setVisible(false)
    self.bindChoose = nil

    -- if not tolua.isnull(self.line) then 
    --     self.line:setVisible(self.isNeedCare)
    -- end
   
    -- if not tolua.isnull(self.targetSprite) then 
    --     self.targetSprite:setVisible(self.isNeedCare)
    -- end
end

function UISoldiersLine:getId()
    
    return self:getTag()
end

function UISoldiersLine:isState1()
    
    return self.data.lState == 1
end

function UISoldiersLine:setRadius(r)
    self.m_radius = r or 0
end

function UISoldiersLine:getRadius(r)
    return self.m_radius or 0
end

function UISoldiersLine:getRect()
    
    return cc.rect(- 100,- 100,200,200)
end

function UISoldiersLine:getTouchRect(panelX,panelY)
    
    local pos = cc.p(self:getPositionX(),self:getPositionY())

    return cc.rect(- 100,- 100,200,200)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISoldiersLine

--endregion
