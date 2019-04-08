local global = global
local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr

local _Manager = {}

local platform = cc.Application:getInstance():getTargetPlatform()
function _Manager:isMobile()
    return (self:isIos() or self:isAndroid())
end
function _Manager:isIos()
    return gdevice.platform == "ios"
end
function _Manager:isAndroid()
    return gdevice.platform == "android"
end
function _Manager:isWindows()
    return gdevice.platform == "windows"
end

--- nNum 源数字
--- n 小数位数
function _Manager:getPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum
    end
    n = n or 0
    n = math.floor(n)
    if n < 0 then
        n = 0
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal)
    local nRet = nTemp / nDecimal
    return nRet
end
--获取对应纹理的裁剪区域内的纹理
--order = 1,头像
--order = 2,半身像
function _Manager:setSoldierPicRect(i_node,soldierData,order)

    if not soldierData then 
        print("tools soldierData nil")
        return 
    end

    local id = soldierData.id


    -- print("############ setSoldierPicRect: "..(id*10+order))
    local clipData = luaCfg:get_picture_by(id*10+order)
    if not clipData then
        clipData = luaCfg:get_wild_picture_by(id*10+order)
    end

  --  dump(clipData,"clipData....................")

    if not clipData then return   end 


    if id==3 then 
     --   dump(clipData,"城墙信息")
    end 

    local scale = clipData.scale/100
    -- if not  gdisplay.newSpriteFrame(clipData.name) then  return end 
    local frameSize = {width = clipData.scaleY,height = clipData.scaleY} --gdisplay.newSpriteFrame(clipData.name):getOriginalSize()
    local rect = cc.rect(0,0,0,0)
    rect.width = math.abs(clipData.x2 - clipData.x1)
    rect.height = math.abs(clipData.y2 - clipData.y1)
    rect.x = clipData.x1
    rect.y = frameSize.height+clipData.y2
    local size = cc.size(rect.width,rect.height)
    -- 战报特殊处理
    if order == 4 then
        size = cc.size(59,82)
        rect.width = 59
        rect.height = 82
        rect.y = 0
    end

    local anchorP = i_node.pic:getAnchorPoint()
    local i_sprite = i_node.pic
    if tolua.type(i_sprite) == "cc.Sprite" then
        local root = resMgr:createWidget("common/clipping_node")
        global.uiMgr:configUITree(root)
        i_node:addChild(root)
        i_node.pic = root
        root:setName(i_sprite:getName())
        root:setPosition(i_sprite:getPosition())
        root:setAnchorPoint(i_sprite:getAnchorPoint())

        i_sprite:removeFromParent()
    end

    --适配裁剪layout为对应的sprite的锚点坐标
    i_node.pic:setScale(scale)
    i_node.pic.clipingLayout:setContentSize(size)
    self:adjustAnchorPoint(i_node.pic.clipingLayout,rect,anchorP,scale)
    

    global.panelMgr:setTextureFor(i_node.pic.clipingLayout.pic,clipData.name)
    -- i_node.pic.clipingLayout.pic:setSpriteFrame(clipData.name)
    
end

function _Manager:adjustAnchorPoint(node,rect,anchorP,scale)
    local pos = cc.p(0,0)
    local dx = pos.x+(0-anchorP.x)*rect.width
    local dy = pos.y+(0-anchorP.y)*rect.height
    local sx = -rect.x
    local sy = -rect.y
    node:setPosition(cc.p(dx,dy))
    node.pic:setPosition(cc.p(sx,sy))
        
end

--头像
function _Manager:setSoldierAvatar(i_node,soldierData)
    self:setSoldierPicRect(i_node,soldierData,1)
end
--半身像
function _Manager:setSoldierBust(i_node,soldierData)
    self:setSoldierPicRect(i_node,soldierData,2)
end

function _Manager:setMonsterHD(i_node,soldierData, order)
    self:setSoldierPicRect(i_node,soldierData, order or 2)

  --  dump(soldierData  ,"setMonsterHD ////////////")

end

function _Manager:setSoldierBustBattle(i_node,soldierData)
    self:setSoldierPicRect(i_node,soldierData,4)
end
--圆形头像截取
function _Manager:setCircleAvatar(i_node, clipData)

    -- self:setCircleAvatarRect(i_node, clipData)
    self:setNoClipCircleAvatar(i_node, clipData)
end

-- 不需要裁剪
function _Manager:setNoClipCircleAvatar(i_node, clipData)

    if not clipData then return end
    if tolua.type(i_node.pic) == "cc.Sprite" then
        -- i_node.pic:setSpriteFrame(clipData.path)
        clipData.scale = clipData.scale or 100
        global.panelMgr:setTextureFor(i_node.pic,clipData.path)
        i_node.pic:setAnchorPoint(0.5, 0.5)
        i_node.pic:setPosition(0, 0)
        i_node.pic:setScale(clipData.scale/100)
    end
end

function _Manager:setCircleAvatarRect(i_node, clipData)

    if not clipData then return end

    local clipWidth = math.abs(clipData.x2 - clipData.x1)
    if clipWidth <= 0 then  -- 不需要裁剪(2士兵头像特殊处理)
        if tolua.type(i_node.pic) == "cc.Sprite" then
            i_node.pic:setSpriteFrame(clipData.path)
            i_node.pic:setAnchorPoint(0.5, 0.5)
            i_node.pic:setPosition(0, 0)
            i_node.pic:setScale(clipData.scale/100)
        end
        return
    end

    local clipNode = cc.ClippingNode:create()
    clipNode:setInverted(false)  
    clipNode:setAlphaThreshold(0) --大于透明度0参与裁剪 
    i_node:addChild(clipNode)

    -- local id = soldierData.id
    -- local clipData = luaCfg:get_picture_by(id*10+order)
    -- if not clipData then
    --     clipData = luaCfg:get_wild_picture_by(id*10+order)
    -- end
    local scale = clipData.scale/100

    local spriteFrame = gdisplay.newSpriteFrame(clipData.path)
    if not spriteFrame then
        return
    end
    local frameSize = spriteFrame:getOriginalSize()
    local rect = cc.rect(0,0,0,0)
    rect.width = math.abs(clipData.x2 - clipData.x1)*scale
    rect.height = math.abs(clipData.y2 - clipData.y1)*scale
    rect.x = (clipData.x2 + clipData.x1)/2*scale  
    rect.y = (clipData.y2 + clipData.y1)/2*scale 

    local i_sprite = i_node.pic
    if tolua.type(i_sprite) == "cc.Sprite" then
        local pic = cc.Sprite:createWithSpriteFrameName(clipData.path)
        pic:getTexture():setAliasTexParameters()  -- 抗锯齿  
        pic:setScale(scale)
        pic:setAnchorPoint(0, 1)
        pic:setPosition(-math.abs(rect.x) , math.abs(rect.y))
        clipNode:addChild(pic)
        i_node.pic = pic
        i_sprite:removeFromParent()
    end

    if self.circleSpr then
        self.circleSpr:removeFromParent()
    end

    -- 模板  
    self.circleSpr = cc.Sprite:createWithSpriteFrameName("ui_surface_icon/head_icon3.png") 
    local circleSize = self.circleSpr:getContentSize()
    local scaleCir = math.max(rect.width/circleSize.width,rect.height/circleSize.height)
    self.circleSpr:setScale(scaleCir)

    clipNode:setStencil(self.circleSpr)
    clipNode:setPosition(cc.p(0 , 0))

end

--srcNode：参考的节点（可以在前面也可以在后面）
--dstNode：要变动位置的节点
function _Manager:adjustNodePos(srcNode,dstNode,gap)

    if not srcNode or not dstNode then return end 

    local posX = srcNode:getPositionX()
    local size = srcNode:getContentSize()
    local anchorP = srcNode:getAnchorPoint()
    local scale = srcNode:getScaleX()

    local dstSize = dstNode:getContentSize()
    local dstAp = dstNode:getAnchorPoint()
    local dstOriginX = dstNode:getPositionX()
    local dstscaleX = dstNode:getScaleX()
    --1:dstNode在后，0：在前
    local flag = (dstOriginX-posX) >= 0 and 1 or -1

    local srcApX = (flag == 1) and (1-anchorP.x) or anchorP.x
    local dstApX = (flag == 1) and dstAp.x or (1-dstAp.x)
    local dstX = posX+flag*size.width * scale*srcApX+flag*dstSize.width*dstscaleX*dstApX
    dstX = dstX
    if gap then
        dstX = dstX+gap
    end
    dstNode:setPositionX(dstX +4)
end

-- parentNode:父节点
-- childNode：子节点
function _Manager:adjustNodePosForFather(parentNode,childdNode,gap, orginPosX)


    local par = parentNode:convertToWorldSpace(cc.p(0, 0))
    local chr = childdNode:convertToWorldSpace(cc.p(0, 0))
    
    local size = parentNode:getContentSize()
    local dstSize = childdNode:getContentSize()
    local dstAp = childdNode:getAnchorPoint()
    local dstOriginX = childdNode:getPositionX()

    local dstX = size.width+dstSize.width*dstAp.x
    if gap and not orginPosX then
        dstX = dstX + gap
    end
    childdNode:setPositionX(dstX+4)

    -- 阿拉伯处理
    local curLanguage = global.languageData:getCurrentLanguage()
    if curLanguage == "ar" and orginPosX then
        --if par.x < chr.x then
        gap = gap or 0
        orginPosX = orginPosX or 0
        parentNode:setPositionX(orginPosX+dstSize.width+gap)
        local dstOriginX = size.width+dstSize.width*dstAp.x
        childdNode:setPositionX(dstOriginX-size.width-dstSize.width-gap)
    end

end

 -- 让子类相对父类中心 水平居中
function _Manager:adjustNodeMiddle(...) 
    local childNode =  {...} 
    local Parent = nil 
    -- 检测是否为同一个父类 不是则退出
    for _ , v in pairs(childNode) do 
        if not Parent then 
         Parent =  v:getParent() 
        end
        if Parent ~=  v:getParent() then 
            return nil 
        end 
        Parent =  v:getParent() 
    end 
    local parentMiddle_x = Parent:getContentSize().width*0.5
    local minX = nil  
    local maxX = nil
    for _ , v in pairs(childNode)do 
        if not minX or not maxX then 
            minX = v:getPositionX() - (v:getAnchorPoint().x * v:getContentSize().width)
            maxX = v:getPositionX() - (v:getAnchorPoint().x * v:getContentSize().width) + v:getContentSize().width
        end
        if minX > v:getPositionX() - (v:getAnchorPoint().x * v:getContentSize().width) then 
            minX = v:getPositionX() - (v:getAnchorPoint().x * v:getContentSize().width)
        end  
        if maxX < v:getPositionX() - (v:getAnchorPoint().x * v:getContentSize().width) + v:getContentSize().width then
            maxX =v:getPositionX() - (v:getAnchorPoint().x * v:getContentSize().width) + v:getContentSize().width 
        end 
    end
    local childMiddleX  = minX + (maxX - minX) * 0.5 
    local MoeveX = parentMiddle_x  - childMiddleX
    for _ , v in pairs(childNode) do 
        v:setPositionX(v:getPositionX()+MoeveX)
    end 
end

-- parentNode:父节点
-- childNode：子节点
--父子节点垂直居中
function _Manager:adjustNodeVerical(parentNode,childdNode) 

    local parX = parentNode:getPositionX()
    local parSize = parentNode:getContentSize()
    local chiX = childdNode:getContentSize()

    local dsToCx = gdisplay.width*0.5-parX
    local rPos = parX+((dsToCx+chiX.width)-(parSize.width-dsToCx))*0.5
    parentNode:setPositionX(rPos)
end

--射线碰撞检测
function _Manager:adjustNodePos11(srcNode,dstNode)
    local arg = {} --这是碰撞的矩形坐标队列
    local point = {x=5,y=10}  --需要检测的点，一般是你们的触摸点
    local len,count,p1,p2 = #arg ,0,nil,nil

    for i = 1,len do
        p1 = arg
        if i == len then
            p2=arg[1]
        else
            p2=arg[i+1]
        end

        if p1.y == p2.y --p1p2 与 y=p0.y平行
            or
            point.y < math.min(p1.y,p2.y) --交点在p1p2延长线上
            or
            point.y >= math.max(p1.y,p2.y) --交点在p1p2延长线上
            then
        else
            --交点的 X 坐标
            local x=(point.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x
            if x > point.x then --向右水平方向发射射线
                count = count + 1
            end
        end
    end

    if count%2 == 1 then
        return true
    end
    return false 
end

--十进制转换为二进制
function _Manager:d2b(num,len)
    num = num or 0 
    local boxState = {}
    local bitTb = bit._d2b(num)
    if len then
        for i = 1,len do
            boxState[i] = bitTb[#bitTb-i+1]
        end
        return boxState
    else
        return bitTb
    end
end

--actionTargets = {{target=target,dp=cc.p(600,0)},{target=target,dp=cc.p(-600,0)}}
function _Manager:dynamicOpenUI2(window)
    local actionTargets = window.inActions
    -- if not window.isOpen then
        local overCall = function() 
            window.isOpen = true 
            if window.onEnterActionFinish then  window:onEnterActionFinish() end
        end
        for i = 1, #actionTargets do
            local targetItem = actionTargets[i]
            local dp = targetItem.dp
            local target = targetItem.target
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
        else
            -- AudioMgr:playAudio("ui_slideout")
        end
    -- end 
end

function _Manager:dynamicCloseUI2(window,func)
    local actionTargets = window.outActions
    -- if window.isOpen then
        for i = 1, #actionTargets do
            local targetItem = actionTargets[i]
            local dp = targetItem.dp
            local target = targetItem.target
            local opacity = targetItem.opacity
            local dt = targetItem.dt
            local speedType = targetItem.speedType
            if targetItem.isVisi ~= nil then
                target:setVisible(targetItem.isVisi)
            else
                if i >= #actionTargets then
                    self:moveOutFromAnyOrient(target,dp,opacity,dt,speedType,func)
                else
                    self:moveOutFromAnyOrient(target,dp,opacity,dt,speedType)
                end
            end
        end
        if not actionTargets or #actionTargets <= 0 then
            if func then func() end
        else
            -- AudioMgr:playAudio("ui_slidein")
        end
        -- window.isOpen = false
    -- end 
end

--从任何方位移入item
function _Manager:moveInFromAnyOrient(target,dp,opacity,dt,speedType,func)
    if not target or not target:isVisible() then return end
    -- target:stopAllActions()
    local initDt = dt or 0.2
    local initdp = dp or cc.p(600, 0)
    local startOpacity = opacity
    local originVisi = target:isVisible()

    target:setVisible(false)
    local originPos = cc.p(target:getPosition())
    local initPos = cc.p(originPos.x+initdp.x, originPos.y+initdp.y)
    local dt = initDt
    local ationT = {
        cc.Place:create(initPos),
        cc.Show:create(),
    }
    if startOpacity then
        target:setOpacity(startOpacity)

        if speedType == "cc.EaseBackOut" then
            table.insert(ationT,cc.Spawn:create(cc.EaseBackOut:create(cc.MoveTo:create(dt, originPos)),cc.FadeIn:create(dt)))
        else
            table.insert(ationT,cc.Spawn:create(cc.MoveTo:create(dt, originPos),cc.FadeIn:create(dt)))
        end
    else
        if speedType == "cc.EaseBackOut" then
            table.insert(ationT,cc.EaseBackOut:create(cc.MoveTo:create(dt, originPos)))
        else
            table.insert(ationT,cc.MoveTo:create(dt, originPos))
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
    -- target:stopAllActions()
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

-- 增加界面icon淡入动画
function _Manager:faceInIconForCells(tableView,func)
    local modal = global.uiMgr:addSceneModel(1)
    local allCell = tableView:getCells()
    table.sort( allCell, function(a,b)
        -- bod
        if math.abs(a:getPositionY()-b:getPositionY()) <= 1 then
            return a:getPositionX()<b:getPositionX()
        else
            return a:getPositionY()>b:getPositionY()
        end
    end )
    for i = 1, #allCell do
        local target = allCell[i]
        if target:getIdx() >= 0 then

            local overCall = function ()
                if modal and not tolua.isnull(modal) then
                    modal:removeFromParent()
                end
                if func then func() end
            end

            local opacity = 0
            local dt = 0.015+0.01*i
            local speedType = nil
            if i >= #allCell then
                global.tools:fadeInFromAnyOrient(target,opacity,dt,speedType,overCall)
            else
                global.tools:fadeInFromAnyOrient(target,opacity,dt,speedType)
            end
        end
    end
end

--从任何方位淡入item
function _Manager:fadeInFromAnyOrient(target,opacity,dt,speedType,func)
    if not target then return end
    -- target:stopAllActions()
    local initDt = dt or 0.2
    local startOpacity = opacity
    local originVisi = target:isVisible()

    target:setVisible(false)
    local dt = initDt
    local ationT = {
        -- cc.Show:create(),
    }
    if startOpacity then
        -- target:setOpacity(startOpacity)

        if speedType == "cc.EaseBackOut" then
            table.insert(ationT,cc.EaseBackOut:create(cc.DelayTime:create(dt)))
        else
            table.insert(ationT,cc.DelayTime:create(dt))
        end
    end
    table.insert(ationT,cc.Show:create())
    table.insert(ationT,cc.CallFunc:create(function() 
        if func then func() end
    end))
    target:runAction(cc.Sequence:create(ationT))
end

-- 字符串分割(str: 源字符串， delimiter：分割符)
-- global.tools:strSplit("09|str|dd", '|') 
function _Manager:strSplit(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


-- 不需要裁剪 和缩放 
function _Manager:setClipCircleAvatarWithScale(i_node, clipData, isScale)

    if not clipData then return end
    if tolua.type(i_node.pic) == "cc.Sprite" then
        -- i_node.pic:setSpriteFrame(clipData.path)
        global.panelMgr:setTextureFor(i_node.pic,clipData.path)
        i_node.pic:setAnchorPoint(0.5, 0.5)
        i_node.pic:setPosition(0, 0)
        if isScale then 
            i_node.pic:setScale(clipData.scale/100)
        end 
    end
end


function _Manager:isIphoneX()

   -- return return cc. == "ios" and gdisplay.height > 1000 

   return device.platform == "ios" and gdisplay.height == 2436
end 

global.tools = _Manager