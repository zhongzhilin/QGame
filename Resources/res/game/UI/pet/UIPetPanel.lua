--region UIPetPanel.lua
--Author : yyt
--Date   : 2017/12/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetPanel  = class("UIPetPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIPetCell = require("game.UI.pet.UIPetCell")
local UIPetIcon = require("game.UI.pet.UIPetIcon")

function UIPetPanel:ctor()
    self:CreateUI()
end

function UIPetPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_first")
    self:initUI(root)
end

function UIPetPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_first")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_12_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.tbNode = self.root.ScrollView_1_export.tbNode_export
    self.tbSize = self.root.ScrollView_1_export.tbSize_export
    self.cellSize = self.root.ScrollView_1_export.cellSize_export
    self.bottom = self.root.ScrollView_1_export.bottom_export
    self.activateBtn = self.root.ScrollView_1_export.bottom_export.activateBtn_export
    self.diamond = self.root.ScrollView_1_export.bottom_export.activateBtn_export.diamond_export
    self.diamond_num = self.root.ScrollView_1_export.bottom_export.activateBtn_export.diamond_export.diamond_num_export
    self.firstAct = self.root.ScrollView_1_export.bottom_export.activateBtn_export.firstAct_mlan_7_export
    self.openBtn = self.root.ScrollView_1_export.bottom_export.openBtn_export
    self.goFightBtn = self.root.ScrollView_1_export.bottom_export.goFightBtn_export
    self.petMiddleBg = self.root.ScrollView_1_export.middle.petMiddleBg_export
    self.name = self.root.ScrollView_1_export.middle.name_export
    self.garrisonLv = self.root.ScrollView_1_export.middle.garrisonLv_export
    self.Label = self.root.ScrollView_1_export.middle.Label_export
    self.NodeT = self.root.ScrollView_1_export.middle.NodeT_export
    self.PageView_1 = self.root.ScrollView_1_export.middle.NodeT_export.PageView_1_export
    self.leftBtn = self.root.ScrollView_1_export.middle.NodeT_export.leftBtn_export
    self.rightBtn = self.root.ScrollView_1_export.middle.NodeT_export.rightBtn_export
    self.rightRole = self.root.ScrollView_1_export.middle.NodeT_export.rightRole_mlan_6_export
    self.leftRole = self.root.ScrollView_1_export.middle.NodeT_export.leftRole_mlan_6_export
    self.typePet = self.root.ScrollView_1_export.middle.NodeT_export.typePet_export
    self.Node_Gorw = self.root.ScrollView_1_export.middle.NodeT_export.Node_Gorw_export
    self.garrisonNeed1 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Gorw_export.garrisonNeed1_export
    self.preGrow = self.root.ScrollView_1_export.middle.NodeT_export.Node_Gorw_export.preGrow_export
    self.curGrow = self.root.ScrollView_1_export.middle.NodeT_export.Node_Gorw_export.curGrow_export
    self.Node_Attr = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export
    self.garrisonNeed = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.garrisonNeed_mlan_22_export
    self.att1 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.att1_export
    self.att2 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.att2_export
    self.att3 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.att3_export
    self.att4 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.att4_export
    self.att5 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.att5_export
    self.att6 = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.att6_export
    self.attTitle = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.attTitle_mlan_12_export
    self.firstGrowTitle = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.firstGrowTitle_mlan_5_export
    self.firstGrow = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.firstGrow_export
    self.label = self.root.ScrollView_1_export.middle.NodeT_export.Node_Attr_export.label_export
    self.rightFireBg = self.root.ScrollView_1_export.middle.rightFireBg_export
    self.leftFireBg = self.root.ScrollView_1_export.middle.leftFireBg_export
    self.ImageLeft = self.root.ScrollView_1_export.middle.ImageLeft_export
    self.ImageRight = self.root.ScrollView_1_export.middle.ImageRight_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:info_btn(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.activateBtn, function(sender, eventType) self:activityHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.openBtn, function(sender, eventType) self:openHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.goFightBtn, function(sender, eventType) self:fightHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.PageView_1, function(sender, eventType) self:touEvnenter(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:leftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:rightHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.ScrollView_1_export.Button_1, function(sender, eventType) self:clickPetHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize())
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPetCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.tbNode:addChild(self.tableView)

    self.PageView_1:addEventListener(handler(self, self.pageViewEvent))
    self.PageView_1:setSwallowTouches(false)
    self.ScrollView_1.Button_1:setSwallowTouches(false)

    self.isNormalWidget = false
    self.ScrollView_1:setTouchEnabled(true)
    local contentSize = self.ScrollView_1:getContentSize().height
    local sHeight = gdisplay.height - 75
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight >= contentSize then
        self.ScrollView_1:setTouchEnabled(false)
        self.isNormalWidget = true
    end
    self:adapt(contentSize)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetPanel:adapt(contentSize)
  
    if (gdisplay.height - 80) > contentSize then
        
        self.ScrollView_1:setInnerContainerSize(cc.size(720,gdisplay.height - 80))
        local tt = gdisplay.height - 80 - contentSize
        for _ ,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 

        self.petMiddleBg:setContentSize(cc.size(gdisplay.width+tt, self.petMiddleBg:getContentSize().height+tt))
        self.ImageLeft:setContentSize(cc.size(self.ImageLeft:getContentSize().width, self.ImageLeft:getContentSize().height+tt))
        self.ImageRight:setContentSize(cc.size(self.ImageRight:getContentSize().width, self.ImageRight:getContentSize().height+tt))
        self.bottom:setPositionY(0)

        self.ScrollView_1.effectL:setPositionY(self.ScrollView_1.effectL:getPositionY()-tt)
        self.ScrollView_1.effectR:setPositionY(self.ScrollView_1.effectR:getPositionY()-tt)
        self.leftFireBg:setPositionY(self.leftFireBg:getPositionY()-tt)
        self.rightFireBg:setPositionY(self.rightFireBg:getPositionY()-tt)
        self.ImageLeft:setPositionY(self.ImageLeft:getPositionY()-tt)
        self.ImageRight:setPositionY(self.ImageRight:getPositionY()-tt)
        self.NodeT:setPositionY(self.NodeT:getPositionY()-tt/2)
    end
end


local picName = {
    [1] = "ui_button/btn_refresh.png",
    [2] = "ui_button/btn_task_sec_equip.png",
}

function UIPetPanel:pageViewEvent(sender, eventType )

    if eventType == ccui.PageViewEventType.turning then

        local curIndex = self.PageView_1:getCurrentPageIndex()
        -- if curIndex  == (self.maxPetGrow + 1) then 
        --     curIndex = 1
        -- elseif curIndex  == 0 then
        --     curIndex = self.maxPetGrow
        -- end
        self:refersh(curIndex, true)
    end
end

function UIPetPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPetPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
local contentMoveX, contentMoveY = 0, 0
function UIPetPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()

    if not self.isNormalWidget then
        contentMoveX, contentMoveY = 0, 0
        self.PageView_1:setTouchEnabled(true)
    end

    return true
end
function UIPetPanel:onTouchMoved(touch, event)
    isMoved = true

    if not self.isNormalWidget then
        -- 上下移动和左右移动
        local diff = touch:getDelta()
        contentMoveX = contentMoveX + math.abs(diff.x)
        contentMoveY = contentMoveY + math.abs(diff.y)
        local curPos = touch:getLocation()

        local angle = self:getAngleByPos(beganPos, curPos)
        if (angle>-60 and angle < 60) or (angle>120 and angle <= 180) or (angle < -120 and angle > -180) then
            self.PageView_1:setTouchEnabled(true)  -- 左右操作
        else
            self.PageView_1:setTouchEnabled(false) -- 上下操作
        end
    end
end

function UIPetPanel:getAngleByPos(p1,p2)  
    local p = {}  
    p.x = p2.x - p1.x  
    p.y = p2.y - p1.y  
             
    local r = math.atan2(p.y,p.x)*180/math.pi  
    -- print("夹角[-180 - 180]:",r)  
    return r  
end  

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPetPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
    self.PageView_1:setTouchEnabled(true)
end

function UIPetPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPetPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_PET_REFERSH, function ()
        -- body
        if self.setData then
            self:setData()
        end
    end)

    local nodeTimeLine = resMgr:createTimeline("pet/pet_first")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self.isPageMove = false
    self:registerMove()
    self:setData()
end

function UIPetPanel:setData()

    self.data = global.petData:getGodAnimal()
    self.maxPetGrow = global.petData:getPetGrowMax()
    self.tableView:setData(self.data)

    local index = 1
    local curFightPet = global.petData:getGodAnimalByFighting()
    if curFightPet then
        index = curFightPet.type
        index = self.curDefaultSelect or index
    end
    self:showPage(index)
end

function UIPetPanel:showPage(index)

    self:refershSelect(index)
    local curSelect = self.data[index]

    self.PageView_1:removeAllPages()
    if self.maxPetGrow > 0 then

        --  加入首部循环页
        -- local item1 = UIPetIcon.new()
        -- item1:setData(global.petData:getPetConfigByGrow(curSelect.type, self.maxPetGrow))
        -- self.PageView_1:addPage(item1) 
        
        for i=1,self.maxPetGrow do
            local item= UIPetIcon.new()
            item:setData(global.petData:getPetConfigByGrow(curSelect.type, i))
            self.PageView_1:addPage(item)
        end 

        --  加入尾部循环页
        -- local item2 = UIPetIcon.new()
        -- item2:setData(global.petData:getPetConfigByGrow(curSelect.type, 1))
        -- self.PageView_1:addPage(item2) 

        if curSelect.serverData then
            local configData = global.petData:getPetConfig(curSelect.type, curSelect.serverData.lGrade)
            self:jumpToPage(configData.growingPhase-1)
        else
            self:jumpToPage(0)
        end
    end

end

function UIPetPanel:jumpToPage(index, isNoRset)
    self.PageView_1:setCurrentPageIndex(index) -- 无动画跳转
    self:refersh(index, isNoRset)
end

function UIPetPanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamond_num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.diamond_num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UIPetPanel:refersh(index, isNoRset)

    self.activateBtn:setVisible(false)
    self.openBtn:setVisible(false)
    self.goFightBtn:setVisible(false)

    local curSelectData = self:getCurSelectPet()
    if curSelectData.serverData and curSelectData.serverData.lState == 1 then     -- 出战状态

        self.openBtn:setPositionX(gdisplay.width/2)
        self.openBtn:setVisible(true)

    elseif curSelectData.serverData and curSelectData.serverData.lState == 0 then -- 休息状态

        self.openBtn:setPositionX(gdisplay.width/3-40)
        self.openBtn:setVisible(true)
        self.goFightBtn:setVisible(true)

    else                                                                          -- 未激活

        self.activateBtn:setVisible(true)
        self.diamond:setVisible(false)
        self.firstAct:setVisible(false)

        if global.petData:getPetActNum() > 0 then -- 魔晶激活
            self.diamond:setVisible(true)
            local actPet = luaCfg:get_pet_activation_by(1)
            self.diamond_num:setString(actPet["demand"..global.petData:getPetActNum()])
            self:checkDiamondEnough(actPet["demand"..global.petData:getPetActNum()])
        else
            self.firstAct:setVisible(true)
        end
        
    end

    -- 当前成长阶段
    local curGarrData = global.petData:getPetConfigByGrow(curSelectData.type, index+1)
    if curGarrData then

        local curGarrGrowing = 1
        local curGarrGrowPet = global.petData:getGodAnimalByType(curSelectData.type)
        if curGarrGrowPet.serverData and curGarrGrowPet.serverData.lGrade and curGarrGrowPet.serverData.lGrade > 0 then
            curGarrGrowing = global.petData:getPetConfig(curSelectData.type, curGarrGrowPet.serverData.lGrade).growingPhase
        end

        self.Node_Attr:setVisible(curGarrData.growingPhase <= curGarrGrowing)
        self.Node_Gorw:setVisible(curGarrData.growingPhase > curGarrGrowing)

        self.leftBtn:setVisible(curGarrData.growingPhase ~= 1)
        self.rightBtn:setVisible(curGarrData.growingPhase ~= global.petData:getPetGrowMax())
        self.leftRole:setVisible(curGarrData.growingPhase ~= 1)
        self.rightRole:setVisible(curGarrData.growingPhase ~= global.petData:getPetGrowMax())

        self.name:setString(curGarrData.name)
        self.garrisonLv:setString("("..curGarrData.phaseName..")")

        local pet = luaCfg:get_pet_type_by(curGarrData.type)
        self.typePet:setString(pet.typeName)

        self.att1:setPositionY(self.attTitle:getPositionY()-7) 
        self.att4:setPositionY(self.attTitle:getPositionY()-7) 

        for i=1,6 do
            self["att"..i]:setVisible(false)
            local skill = global.petData:getPetPropertyClient(curGarrData.propertyValueClient)
            if skill[i] then
                self["att"..i]:setVisible(true)
                local skillD = curGarrData.propertyValue
                local dataType = luaCfg:get_data_type_by(skillD[i][1])
                local attStr = skill[i][1] .. ":+" .. skill[i][2]/100 .. dataType.extra
                self["att"..i]:setString(attStr)

                -- 超框适配处理
                if i == 1 or i == 4 then
                else
                    local preAtt = self["att"..(i-1)]
                    self.label:setString(preAtt:getString())
                    local prePosY = preAtt:getPositionY()
                    local labH = self.label:getContentSize().height
                    local labW = self.label:getContentSize().width
                    if labW > preAtt:getContentSize().width then -- 换行
                        labH = preAtt:getContentSize().height
                    end
                    self["att"..i]:setPositionY(prePosY-labH)
                end

            end
        end

        self.curGrow:setString(curGarrData.phaseAptitude)
        local preGarrData = global.petData:getPetConfigByGrow(curSelectData.type, index)
        if preGarrData then
            self.preGrow:setString(preGarrData.phaseAptitude)
        end

        self.firstGrow:setString(curGarrData.phaseAptitude)
        global.tools:adjustNodePos(self.firstGrowTitle, self.firstGrow)

        self.garrisonNeed:setVisible(curGarrData.growingPhase > curGarrGrowing)
        local starClass, starNum = global.petData:getPetStarClassByLv(curGarrData.lv)
        self.garrisonNeed:setString(luaCfg:get_translate_string(10978, starClass, starNum, curGarrData.phaseName))
        self.garrisonNeed1:setVisible(curGarrData.growingPhase ~= 1)
        local starClass, starNum = global.petData:getPetStarClassByLv(curGarrData.lv)
        self.garrisonNeed1:setString(luaCfg:get_translate_string(10978, starClass, starNum, curGarrData.phaseName))
    end
    
end

function UIPetPanel:refershSelect(index)

    for i,v in ipairs(self.data) do
        v.isSelected = 0
        if v.type == index then
            v.isSelected = 1
        end
    end
    self.tableView:setData(self.data, isNoRset)
end

function UIPetPanel:getCurSelectPet()
    
    for i,v in ipairs(self.data) do
        if v.isSelected == 1 then
            return v
        end
    end
end

function UIPetPanel:info_btn(sender, eventType)
    local data = luaCfg:get_introduction_by(31)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIPetPanel:leftHandler(sender, eventType)
    
    uiMgr:addSceneModel(0.5)
    local curIndex = self.PageView_1:getCurrentPageIndex() - 1
    -- if curIndex == 0 then
    --     self.PageView_1:scrollToPage(curIndex)
    --     curIndex = self.maxPetGrow
    --     self:refersh(curIndex, true)
    -- elseif curIndex < 0 then
    --     curIndex = self.maxPetGrow
    --     self:jumpToPage(self.curIndex)
    --     curIndex =  curIndex -1
    --     self.PageView_1:scrollToPage(curIndex)
    --     self:refersh(curIndex, true)
    -- else
        self.PageView_1:scrollToPage(curIndex)
        self:refersh(curIndex, true)
    -- end
    
end

function UIPetPanel:rightHandler(sender, eventType)
    
    uiMgr:addSceneModel(0.5)
    local curIndex = self.PageView_1:getCurrentPageIndex() + 1
    -- if curIndex == (self.maxPetGrow + 1) then
    --     self.PageView_1:scrollToPage(curIndex)
    --     curIndex = 1
    --     self:refersh(curIndex, true)
    -- elseif curIndex > (self.maxPetGrow + 1) then
    --     curIndex = 1
    --     self:jumpToPage(curIndex)
    --     curIndex =  curIndex + 1
    --     self.PageView_1:scrollToPage(curIndex)
    --     self:refersh(curIndex, true)
    -- else
        self.PageView_1:scrollToPage(curIndex)
        self:refersh(curIndex, true)
    --end
end

function UIPetPanel:exit_call(sender, eventType)

    self.curDefaultSelect = nil
    global.panelMgr:closePanelForBtn("UIPetPanel")
end

function UIPetPanel:touEvnenter(sender, eventType)

    -- if not self.data then return end
    -- local currPageIndex = self.PageView_1:getCurrentPageIndex()
    -- if eventType == 2 or eventType == 3 then
    --     if currPageIndex == (self.maxPetGrow+1) then
    --         self:jumpToPage(1)
    --     elseif currPageIndex == 0 then
    --         self:jumpToPage(self.maxPetGrow)
    --     end
    -- end
end

function UIPetPanel:activityHandler(sender, eventType)

    if not self:checkDiamondEnough(tonumber(self.diamond_num:getString())) and global.petData:getPetActNum() > 0 then
        global.panelMgr:openPanel("UIRechargePanel"):setCallBack(function ()
            self:checkDiamondEnough(tonumber(self.diamond_num:getString()))
        end)
        return 
    end

    global.panelMgr:openPanel("UIPetActivatPanel"):setData(self:getCurSelectPet(), function ()
        -- body
        self:exit_call()
        local curSelectId = self:getCurSelectPet().type
        global.panelMgr:openPanel("UIPetGetPanel"):setData(global.petData:getGodAnimalByType(curSelectId), function (petType)
            global.panelMgr:openPanel("UIPetInfoPanel"):setData(global.petData:getGodAnimalByType(petType))
        end)
    end)
end

function UIPetPanel:openHandler(sender, eventType)
    self.curDefaultSelect = self:getCurSelectPet().type
    global.panelMgr:openPanel("UIPetInfoPanel"):setData(self:getCurSelectPet())
end

function UIPetPanel:fightHandler(sender, eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("petPrompt03", function()

        global.petApi:actionPet(function (msg)
            -- body
            if not msg then return end
            global.petData:resetGodAnimalState()
            global.petData:updateGodAnimal(msg.tagGodAnimal or {})
            -- global.panelMgr:openPanel("UIPetInfoPanel"):setData(global.petData:getGodAnimalByType(self:getCurSelectPet().id))
            gevent:call(global.gameEvent.EV_ON_PET_REFERSH)
            global.tipsMgr:showWarning("petPrompt02")
            self:exit_call()
        end, 3, self:getCurSelectPet().type)
    end)
end

local last = "" 
function UIPetPanel:clickPetHandler(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        if self.isPageMove then 
            return
        end

        if last ~= "" then 
            gsound.stopEffect(last)
        end 

        local music  = "pte_dianji_"..self:getCurSelectPet().type
        gevent:call(gsound.EV_ON_PLAYSOUND,music)
        last = music
    end

end
--CALLBACKS_FUNCS_END

return UIPetPanel

--endregion
