local luaCfg = global.luaCfg
local panelMgr = global.panelMgr
local uiMgr = global.uiMgr
local userData = global.userData
local scMgr = global.scMgr
local resMgr = global.resMgr

local _Manager = {}
local _CommonList = {}

function _Manager:showWarningText(text)
    local panel = panelMgr:getPanel("UITaskTips")
    if not panelMgr:isPanelOpened("UITaskTips") then
        panel = panelMgr:openPanel("UITaskTips")
    end
    
    panel:setDesc(text)
    panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))
end

function _Manager:showTaskTips(text)
    local panel = panelMgr:getPanel("UITaskTips")
    if not panelMgr:isPanelOpened("UITaskTips") then
        panel = panelMgr:openPanel("UITaskTips")
    end
    
    panel:setDesc(text)
    panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))
end


function _Manager:showQuitConfirmPanel(msg,panelname)
    local isExit = false
    if global.scMgr:isLoginScene() then
        isExit = true
    end
    local t_msg = msg
    if type(msg) == "boolean" then
        t_msg = msg
    else
        t_msg = msg or 10619
    end
    local t_panelname = panelname or "UISystemConfirm"
    if global.panelMgr:isPanelTop("UILoginConfirm") and t_panelname == "UIMaintancePanel" then
        global.panelMgr:closePanel("UILoginConfirm")
    end
    if t_panelname == "UIMaintancePanel" and not global.scMgr:isLoginScene() then
        -- 在游戏内的时候不让弹出服务器维护中的tips 容错处理
        self:showQuitConfirmPanelNoClientNet(nil,true)
        return
    else
        if t_panelname == "UIMaintancePanel" and global.scMgr:isLoginScene() then
            if not global.netRpc:checkClientNetWithError() then
                return
            end
        end
    end
    local panel = global.panelMgr:openPanel(t_panelname)
    panel:setData(t_msg, function()
        if isExit then
            global.funcGame.allExit()
        else
            global.funcGame.RestartGame()
        end
    end)
    return panel
end

-- 跳过容错处理时的tips调用
function _Manager:showQuitConfirmPanelNoClientNet(msg,isExit)
    if global.scMgr:isLoginScene() then
        isExit = true
    end
    local t_msg = msg
    local panelname = nil
    if type(msg) == "boolean" then
        t_msg = msg
        panelname = "UIMaintancePanel"
        if not global.netRpc:checkClientNetWithError() then
            return
        end
    else
        if isExit then
            t_msg = global.luaCfg:get_local_string(10619)
        else
            t_msg = global.luaCfg:get_local_string(10956)
        end
    end
    local t_panelname = panelname or "UISystemConfirm"
    local panel = global.panelMgr:openPanel(t_panelname)
    gscheduler.unscheduleAll()
    global.panelMgr:closePanel("ConnectingPanel",true)
    panel:setData(t_msg, function()
        if isExit then
            global.funcGame.allExit()
        else
            global.funcGame.RestartGame()
        end
    end)
    return panel
end


-------------------------- tips 多个滚动播放 ------------------------- 


function _Manager:addTipsWaitList(widget)

    self._waitList = self._waitList or {}
    table.insert(self._waitList, widget)
end
function _Manager:cleanTipsWaitList()
    self._waitList = self._waitList or {}
    for _,v in pairs(self._waitList) do
        v:removeFromParent()
    end
    self._waitList = {}
end

function _Manager:showWarningLoop(tipsId)

    local widget = resMgr:createWidget("common/common_gift_tips")
    ccui.Helper:doLayout(widget)    
    uiMgr:configUITree(widget)
    uiMgr:configUILanguage(widget, "common/common_gift_tips")
    local text = self:getTipsText(tipsId)
    widget.Image_1.Text_1_export:setString(text)
    widget:setPosition(cc.p(gdisplay.size.width/2, -gdisplay.size.height))
    scMgr:CurScene():addChild(widget, 179)

    self:addTipsWaitList(widget)
end

function _Manager:showTipsList()

    self._waitList = self._waitList or {}
    local waitListNum = table.nums(self._waitList)
    if waitListNum > 1 then
        local i = 0
        for k,v in pairs(self._waitList) do
            self:showTipWidget(v, i, flag) 
            i = i + 1
        end
    elseif waitListNum == 1 then

        local tipStr = self._waitList[1].Image_1.Text_1_export:getString()
        self:showWarning(tipStr)
        self:cleanTipsWaitList()
    end
end

function _Manager:showTipWidget( widget, id , flag)
    
        local maxShowPanelNum = table.nums(self._waitList) 

        widget:setPosition(cc.p(gdisplay.size.width/2, gdisplay.size.height/2))
        widget:setScaleY(0)
        widget:setVisible(true)

        widget:runAction(cc.Sequence:create( cc.DelayTime:create(id*1),  
            cc.ScaleTo:create(0.3,1,1), cc.DelayTime:create(0.5) ,cc.CallFunc:create(function ()
                
                self:resetPosition(id)

            end),  cc.FadeOut:create(0.5)
        ,cc.Hide:create(), cc.CallFunc:create(function ()
            
            if id == (maxShowPanelNum - 1) then
                self:cleanTipsWaitList()
            end
        end)))

end

function _Manager:resetPosition(id)

    local i = 0
    for k,v in pairs(self._waitList) do
        if i <= id then
            local x, y = v:getPosition()
            v:runAction(cc.MoveTo:create(0.45, cc.p(x, y + 179)))
        end
        i = i + 1
    end
end

function _Manager:showWarningTime(tipsId, ...)

    local text = self:getTipsText(tipsId, ...)
    
    local panel = panelMgr:getPanel("UITaskTips")
    if not panelMgr:isPanelOpened("UITaskTips") then
        panel = panelMgr:openPanel("UITaskTips")
    end
    
    panel:setDesc(text, 1)
    panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))
end

function _Manager:showWarningAction(tipsId)

    local text = self:getTipsText(tipsId)
    
    local panel = panelMgr:getPanel("UITaskTips")
    if not panelMgr:isPanelOpened("UITaskTips") then
        panel = panelMgr:openPanel("UITaskTips")
    end
    
    panel:setDesc(text, false, true)
    panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))
end

-- pvp、龙潭战报errorcode
-- {titleStr="", reportId=1011, tagItem={}}
function _Manager:showBattleErrorcode(data)

    local battle1 = global.panelMgr:getPanel("UIBattleErrorcode") 
    local battle2 = global.panelMgr:getPanel("UIBattleErrorcodeNo")
    if battle1.isShow or battle2.isShow  then
        global.heroData:insertWaitTipsData(data)
        return
    end

    gevent:call(gsound.EV_ON_PLAYSOUND,"patch_new_3")

    if table.nums(data.tagItem) > 0 then
        global.panelMgr:openPanel("UIBattleErrorcode"):setData(data)  -- 有奖励
    else
        global.panelMgr:openPanel("UIBattleErrorcodeNo"):setData(data)-- 无奖励
    end
end

-------------------------- tips 多个滚动播放 ------------------------- 


function _Manager:showWarning(tipsId, ...)

    if not tipsId then return end

    log.trace("############# _Manager:showWarning(tipsId, ...): "..tipsId)
 
    -- 魔晶不足 进入充值
    if tipsId == "ItemUseDiamond" then
        global.UIRechargeListOffset = nil

        if _NO_RECHARGE then 
            return global.tipsMgr:showWarning("FuncNotFinish")
        end 

        panelMgr:openPanel("UIRechargePanel")
        return
    end

    local text = self:getTipsText(tipsId, ...)
    
    local panel = panelMgr:getPanel("UITaskTips")
    if not panelMgr:isPanelOpened("UITaskTips") then
        panel = panelMgr:openPanel("UITaskTips")
    end
    
    panel:setDesc(text)
    panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))
end

-- 调用第三方平台，导致panel缓存对象被释放的问题
function _Manager:showWarningDelay(tipsId, delayTime, callback)

    gscheduler.performWithDelayGlobal(function()
        
        local text = ""
        local errorData = luaCfg:get_errorcode_by(tipsId)
        if errorData then
            text = errorData.text
        else
            text = id
        end
        global.panelMgr:destroyPanel("UITaskTips")
        local panel = panelMgr:getPanel("UITaskTips")
        if not panelMgr:isPanelOpened("UITaskTips") then
            panel = panelMgr:openPanel("UITaskTips")
        end
        panel:setDesc(text)
        panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))

        if callback then callback() end
    end, delayTime or 0)
end

function _Manager:showEffectTips(csbName,animationName,heightPen,isDelayPlay)

     log.trace("############# _Manager:showEffectTips(tipsId, ...): "..csbName)

    
    if heightPen == nil then heightPen = 0.5 end

    local widget = resMgr:createWidget(csbName)

    local timelineAction = resMgr:createTimeline(csbName)
    timelineAction:setLastFrameCallFunc(function()

        widget:removeFromParent()  
        gdisplay.removeSpriteFrames(nil,"world/map/yun_new.png")
    end)

    if isDelayPlay then

        widget:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function( ... )
            

            timelineAction:play(animationName, false)
        end)))
    else

        timelineAction:play(animationName, false)
    end
    
    widget:runAction(timelineAction)

    widget:setPositionX(gdisplay.width / 2)
    widget:setPositionY(gdisplay.height * heightPen)

    scMgr:CurScene():addChild(widget, 31)
end

function _Manager:showCommonTips(csbName,text)

    log.trace("############# _Manager:showCommonTips(tipsId, ...): "..csbName)

    
    if _CommonList[csbName] == nil then
        
        local widget = resMgr:createWidget(csbName)

        ccui.Helper:doLayout(widget)    
        uiMgr:configUITree(widget)
        uiMgr:configUILanguage(widget, csbName)

        widget:setPositionX(gdisplay.width / 2)
        widget:setPositionY(gdisplay.height / 2)

        widget.Image_1.text:setString(text)
        widget:setScaleY(0)
        widget:setVisible(true)
        widget:runAction(cc.Sequence:create(cc.EaseBackOut:create(
            cc.ScaleTo:create(0.45,1,1)),cc.DelayTime:create(2),
            cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create()))

        scMgr:CurScene():addChild(widget, 30)
        widget:retain()
        
        _CommonList[csbName] = widget
    else

        local widget = _CommonList[csbName]

        widget.Image_1.text:setString(text)

        widget:removeFromParent()
        widget:setScaleY(0)
        widget:setVisible(true)
        
        widget:runAction(cc.Sequence:create(cc.EaseBackOut:create(
            cc.ScaleTo:create(0.45,1,1)),cc.DelayTime:create(2),
            cc.EaseBackIn:create(cc.ScaleTo:create(0.3,1,0)),cc.Hide:create()))
        scMgr:CurScene():addChild(widget, 30)


    end
end

function _Manager:showWarningWithIcon(tipsId, iconId, ...)
    local text = self:getTipsText(tipsId, ...)
    local arr = string.split(text,"#ICON#")

    local panel = panelMgr:getPanel("UITaskTips")
    if not panelMgr:isPanelOpened("UITaskTips") then
        panel = panelMgr:openPanel("UITaskTips")
    end
    
    panel:setTextWithIcon(arr,iconId)
    panel:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height / 2))
end

function _Manager:addTouchForTips(icon,tipsData)
    local container = icon
    if icon.addTouchEventListener then
    else
        if icon.container then
            container = icon.container
        else
            local layout = ccui.Layout:create()
            layout:setContentSize(icon:getContentSize())
            layout:setAnchorPoint(cc.p(0,0))
            icon:addChild(layout)
            container = layout
            icon.container = layout
        end
    end
    uiMgr:addWidgetTouchHandler(container, function(sender, eventType) 
        local tipsType = WCONST.ITEM.KIND.GOODS
        -- local tipsData = luaCfg:get_itemtable_by(self.data.item.tid)
        local pos = cc.p(icon:convertToWorldSpace(cc.p(0,0)))
        local tips = self:createTips(tipsType,tipsData,pos)
        tips:setNoOperate(true)
    end)
end

--panel:setNoOperate(false) 隐藏 操作按钮
function _Manager:createTips(tipsType,tipsData,pos)
    local panel = nil
    if WCONST.ITEM.KIND.GOODS == tipsType then
        panel = self:showItemTips(tipsData,pos)
    elseif WCONST.ITEM.KIND.EQUIP == tipsType then
        panel = self:showEquipTips(tipsData)
    end
    return panel
end

function _Manager:showItemTips(itemData,pos)
    local panelName = "UITipsItem"
    local panel = panelMgr:getPanel(panelName)
    if not panelMgr:isPanelOpened(panelName) then
        panel = panelMgr:openPanel(panelName)
    end

    panel:setData(itemData)
    if pos then
        self:updateTipsPosition(panel, pos.x, pos.y)
    else
        self:updateTopCenterTipsPostion(panel, gdisplay.cx, gdisplay.cy) 
    end
    return panel
end

function _Manager:showEquipTips(serverData)
    local panelName = "UIEquipTipsPanel"
    local panel = panelMgr:getPanel(panelName)
    if not panelMgr:isPanelOpened(panelName) then
        panel = panelMgr:openPanel(panelName)
    end
    local config = luaCfg:get_itemtable_by(serverData.tid)
    local equipCfg = luaCfg:get_hero_equipment_by(config.type_id)

    local userData = global.userData
    local cData = 
    {
        tipType = "equip",
        item = userData:GetEquipsBy(equipCfg.part)
    }

    -- local cancelCallback = function()
    --     global.equipApi:OnloadEquip(serverData.id, 0)
    -- end

    -- local confirmCallback = function()
    --     global.equipApi:OnloadEquip(serverData.id, 1)
    -- end

    -- local callback = function()
    --     if equipCfg.job ~= 0 and equipCfg.job ~= userData:GetCareer() then
    --         tipsMgr:showWarning(10037)
    --     elseif equipCfg.level > userData:GetLevel() then
    --         tipsMgr:showWarning(10038)
    --     else
    --         local onItem = cData.item
    --         local onItemCfg = onItem and luaCfg.equipCfg:getEquipmentByItemTid(onItem.tid)
            
    --         local function checkCanInheritReinforce() 
    --             local can = (equipCfg.level >= onItemCfg.level)
    --             --only one reinforce_lv > 0 then can reinforce
    --             for r_type,lv in ipairs(onItem.equip.reinforce_lvs) do
    --                 if lv > 0 then
    --                     can = can and true
    --                     break
    --                 end
    --             end

    --             for r_type,lv in ipairs(serverData.equip.reinforce_lvs) do
    --                 if lv > 0 then
    --                     can = false
    --                     break
    --                 end
    --             end
    --             if equipCfg.reinforce_maxlevel < onItemCfg.reinforce_maxlevel then
    --                 can = false
    --             end
    --             return can
    --         end
    --         --Î´Ç¿»¯¹ýµÄ×°±¸¿ÉÒÔ½ÓÊÜ¼Ì³Ð
    --         if onItem and checkCanInheritReinforce() then 
    --             global.messageMgr:showMessage(10001, {confirmHandler = confirmCallback, cancelHandler= cancelCallback})
    --         else
    --             global.equipApi:OnloadEquip(serverData.id, 0)
    --         end
    --     end
    -- end

    local data = {
        tipType = "bag",
        item = serverData,
        -- btn = 
        -- {
        --     equip = 
        --     {
        --         str = "equip",
        --         callback = callback
        --     },
        -- }       
    }
    panel:setData(data, cData)
    panel:setNoOperate(true)
    return panel
end

-- get tips text
-------------------------------------------------------
function _Manager:getTipsText(id, ...)
--    local text = ""

--    local config = luaCfg:get_tips_by(id)
--    if config then
--        text = string.format(config.content, ...)
--    else
--        text = luaCfg:get_local_string(id, ...)
--    end

--    return text
    local errorData = luaCfg:get_errorcode_by(id)
    if errorData then
        
        if errorData.type == 1 then
            local args = {...}
            local count = #args
            if count > 0 then
                return string.fformat(errorData.text, unpack(args))
            end
            return errorData.text
        elseif errorData.type == 2 then            
            return luaCfg:get_translate_string(errorData.text,...)
        end       
    else
        return id
    end
end

function _Manager:updateTopCenterTipsPostion(tips, x, y)        
    local size = tips:getSize()
    local width, height = size.width, size.height
    x = math.max(x, width / 2)
    x = math.min(x, gdisplay.size.width - width / 2)
    
    y = math.max(y, size.height)
    y = math.min(y, gdisplay.size.height)

    tips:setPosition(cc.p(x, y))
end

-- position
------------------------------------------------------
function _Manager:updateTipsPosition(tips, x, y, absolute)
    if absolute == true then
        tips:setPosition(cc.p(x, y))
    else
        local size = tips:getSize()
        local width, height = size.width, size.height
        local anchor = cc.p(0.5,0.5)
        if tips.getAnchorForTips then
            anchor = tips:getAnchorForTips()
        end

        local position = cc.p(0, 0)
        local offset = cc.p(10, 10)
        local cx = gdisplay.cx
        local cy = gdisplay.cy
        if x < cx then
            if y < cy then
                position.x = x + (width * anchor.x + offset.x)
                position.y = y + (height * anchor.y + offset.y)
            else
                position.x = x + (width * anchor.x + offset.x)
                position.y = y - (height * (1-anchor.y) + offset.y)
            end
        else
            if y < cy then
                position.x = x - (width * (1-anchor.x) + offset.x)
                position.y = y + (height * anchor.y + offset.y)
            else
                position.x = x - (width * (1-anchor.x) + offset.x)
                position.y = y - (height * (1-anchor.y) + offset.y)
            end
        end

        if (position.x - width * anchor.x) < 0 then
            position.x = width * anchor.x
        elseif (position.x + width * (1-anchor.x)) > gdisplay.width then
            position.x = gdisplay.width - width * (1-anchor.x)
        end
            
        if (position.y - height * anchor.y) < 0 then
            position.y = height * anchor.y
        elseif (position.y + height * (1-anchor.y)) > gdisplay.height then
            position.y = gdisplay.height - height * (1-anchor.y)
        end
            
        tips:setPosition(position)
    end
end

--  长按事件注册
function _Manager:registerLongPress( root, _touchBg, TipLayout ,callBack1, callBack2 )
    
    local longPressTime = 0.15
    local preAccTime = 0.1

    local touchNode = cc.Node:create()
    root:addChild(touchNode)

    local bg = _touchBg
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch,event)
        root.beganPoint = touch:getLocation()
        local point = bg:convertToNodeSpace(root.beganPoint)
        local rect = cc.rect(0,0,bg:getContentSize().width,bg:getContentSize().height)
        if cc.rectContainsPoint(rect,point) then
            root.tick = 0
            root.moved = false
            root.ended = false
            local seq = cc.Sequence:create(cc.CallFunc:create(function() self:accumate(root,preAccTime, longPressTime, callBack2,TipLayout) end),cc.DelayTime:create(preAccTime))
            root.acc = root:runAction(cc.RepeatForever:create(seq))
            if callBack1 then callBack1(TipLayout) end
        end
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function(touch,event)
        root.movedPoint = touch:getLocation()
        root.moved = true
    end,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function(touch,event)
        if root.acc then 
            root:stopAction(root.acc) 
            root.acc = nil 
        end
        root.ended = true
        TipLayout:runAction(cc.FadeOut:create(0.2))
    end,cc.Handler.EVENT_TOUCH_ENDED)
    root:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,touchNode)

    root.listener = listener
end

function _Manager:removeLongPress(root)
    if root.listener then
        root:getEventDispatcher():removeEventListener(root.listener)
    end
end

function _Manager:accumate(root, preAccTime, longPressTime, callBack2,TipLayout)
    root.tick = root.tick + preAccTime 
    if root.tick > longPressTime - preAccTime / 2 and root.tick <= longPressTime + preAccTime / 2 then
        if root.acc then 
            root:stopAction(root.acc) 
            root.acc = nil 
        end
        if not root.ended then
            ---------long press---------
            local function longPress()

                if callBack2 then callBack2(root.beganPoint,TipLayout) end
            end
            if root.moved then
                if math.abs(root.beganPoint.x - root.movedPoint.x) < 10 and math.abs(root.beganPoint.y - root.movedPoint.y) < 10 then
                    longPress()
                end
            else
                longPress()
            end
        end
    end
end

global.tipsMgr = _Manager