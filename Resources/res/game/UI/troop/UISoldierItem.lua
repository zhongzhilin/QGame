--region UISoldierItem.lua
--Author : yyt
--Date   : 2016/09/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local CountSliderControl = require("game.UI.common.UICountSliderControl")
local UIISoldierTipsControl = require("game.UI.common.UIISoldierTipsControl")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UISoldierItem  = class("UISoldierItem", function() return gdisplay.newWidget() end )

function UISoldierItem:ctor()
    self:CreateUI()
end

function UISoldierItem:CreateUI()
    local root = resMgr:createWidget("troop/soldier_list_node")
    self:initUI(root)
end

function UISoldierItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/soldier_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_view = self.root.soldier_list_bg.portrait_view_export
    self.portrait_node = self.root.soldier_list_bg.portrait_view_export.Panel_4.portrait_node_export
    self.name = self.root.soldier_list_bg.portrait_view_export.name_export
    self.type_icon = self.root.soldier_list_bg.portrait_view_export.type_icon_export
    self.star = self.root.soldier_list_bg.portrait_view_export.star_export
    self.star1_bj = self.root.soldier_list_bg.portrait_view_export.star_export.star1_bj_export
    self.star1 = self.root.soldier_list_bg.portrait_view_export.star_export.star1_bj_export.star1_export
    self.star2 = self.root.soldier_list_bg.portrait_view_export.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.soldier_list_bg.portrait_view_export.star_export.star2_bj_export
    self.star3 = self.root.soldier_list_bg.portrait_view_export.star_export.star2_bj_export.star3_export
    self.star4 = self.root.soldier_list_bg.portrait_view_export.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.soldier_list_bg.portrait_view_export.star_export.star3_bj_export
    self.star5 = self.root.soldier_list_bg.portrait_view_export.star_export.star3_bj_export.star5_export
    self.star6 = self.root.soldier_list_bg.portrait_view_export.star_export.star3_bj_export.star6_export
    self.slider = self.root.slider_export
    self.chief = self.root.slider_export.chief_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.slider_export.cur)

--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider, handler(self,  self.changCountCallBack)) 
    self.sliderControl:setMinCount()
    self.max = self.slider.max

    self.detailPanel = global.panelMgr:getPanel("UITroopDetailPanel")
    self.perPop = 0
    self.capacity = 0
    self.soldierID = 0
    self._scroNum = 0
end

function UISoldierItem:onEnter()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISoldierItem:setDelegate(delegate)
    self.m_delegate = delegate
end

-- 检测当前部队是否满编
function UISoldierItem:checkCondition(parm, isShowTips)

    if not self.detailPanel.heroMsg then return 0  end
    local curSelctCount = 0
    for _,v in pairs(self.detailPanel.itemSoldier) do        
        if v.data.lID ~= self.data.lID then
            curSelctCount = curSelctCount + v.perPop*v.sliderControl:getContentCount()
        end
    end
    local commanderScaleMax = self.detailPanel.heroMsg.serverData.lbase[4] + self.detailPanel.heroMsg.serverData.lextra[4]
    local leftScale = math.floor((commanderScaleMax - curSelctCount)/self.perPop)
    if parm > leftScale then
        parm = parm > leftScale and leftScale or parm
        if isShowTips then
            global.tipsMgr:showWarning("heroTroopsMax")
        end
        return parm, true
    else
        parm = parm > leftScale and leftScale or parm
        return parm
    end
    
end

function UISoldierItem:getCurMaxCount()
    return self.curMaxCount
end

function UISoldierItem:getCurInitCount()
    return self.curInitCount
end

function UISoldierItem:setData( data, i )

    self.sliderControl:setDelegate(self)
    
    self.data  = data
    local soldier_data = luaCfg:get_soldier_train_by(data.lID)
    global.tools:setSoldierAvatar(self.portrait_node,soldier_data)
    local soldierData = luaCfg:get_soldier_property_by(data.lID)
    self.perPop = soldierData.perPop
    self.capacity = soldierData.capacity
    self.soldierID = soldierData.id

    local curSoldier = global.soldierData:getSoldiersBy(data.lID) or {}
    local restNum = curSoldier.lCount or 0
    if restNum < 0 then
        restNum = 0
    end

    -- 引导特殊处理
    local maxCount = data.lCount + restNum
    if global.guideMgr:isPlaying() and global.userData:getGuideStep() == 801 and i==1 then
        maxCount = restNum
    end

    self.curMaxCount = maxCount
    self.sliderControl:setMaxCount(maxCount)
    self.sliderControl:changeCount(data.lCount) 
    self.cur_count = data.lCount
    self.curInitCount = data.lCount

    if data.lCount > 0 then
        self.isAction = false
    else
        self.isAction = true
    end

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end
    local id,dataBuild = global.cityData:getBuildingIdBySoldierId(data.lID)
    if soldier_data.race ~=0 and  dataBuild and dataBuild.serverData and (soldier_data.type ~= 0) then
        showlvStar(dataBuild.serverData.lGrade or 1)
    else
        showlvStar(-1)
    end

    self.type_icon:setSpriteFrame(soldier_data.skillIcon)
    self.name:setString(soldier_data.name)

    self:addtips()

    self:setChief(data.isChief == 1) 

    self.isSetHeadList = nil
end

function UISoldierItem:setChief(isChief)
    self.chief:setVisible(isChief) 
    if isChief then
        self.portrait_view.Sprite_5:setSpriteFrame("ui_surface_icon/troops_list_hero1.png")
        self.portrait_view.Panel_4:setBackGroundImage("ui_surface_icon/troops_list_hero1.png", ccui.TextureResType.plistType)
    else
        self.portrait_view.Sprite_5:setSpriteFrame("ui_surface_icon/troops_list_hero.png")
        self.portrait_view.Panel_4:setBackGroundImage("ui_surface_icon/troops_list_hero.png", ccui.TextureResType.plistType)
    end
end

function UISoldierItem:addtips()
    self.m_TipsControl = UIISoldierTipsControl.new()
    if self.data.tips_panel and   self.data.tips_panel.tips_node then 
        local tips_node = self.data.tips_panel.tips_node
        local soldier_train  = clone(global.luaCfg:get_soldier_train_by(self.data.lID))
        self.m_TipsControl:setdata(self.portrait_view ,soldier_train,tips_node)
    end 
end

function UISoldierItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end

function UISoldierItem:setHeadListData(state)
    self.isSetHeadList = state
end

function UISoldierItem:changCountCallBack(contentCount, event)
    if self.detailPanel.itemHeadList == nil then return end
    if not self.detailPanel.heroMsg then 
        if event ~= 1 then
            return
        end
        return global.tipsMgr:showWarning("TroopsHero")
    end
    local curCount = self.sliderControl:getContentCount()
    self.cur_count = curCount

    local i = 1
    for _,v in pairs(self.detailPanel.itemHeadList) do

        if v:getTag() == (self:getTag())*10 then

            v.number:setString(curCount)
            v.curNumber = curCount

            if self.isSetHeadList then 
                v.soldier_bg:setScale(1)
                self.detailPanel:refershPosition(i)
                self.isSetHeadList = nil
                self.isAction = nil
            else
                local delayTime =  self:checkScroPosition(i) 
                self:runAction(  cc.Sequence:create(cc.DelayTime:create(delayTime),   cc.CallFunc:create(function ()
              
                    if curCount == 0 then

                        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_soldierout")
                        local spa = cc.Spawn:create(cc.FadeOut:create(0.3), cc.ScaleTo:create(0.2, 0))
                        local a = cc.Sequence:create(cc.DelayTime:create(0.1) , cc.CallFunc:create(function ()
                            self.detailPanel:refershPosition(i)
                        end))
                        v.soldier_bg:runAction(spa)
                        v.soldier_bg:runAction(a)
                        self.isAction = true
                    else
                        if self.isAction then
                            self.detailPanel:refershPosition(i)
                            local spa = cc.Spawn:create(cc.FadeIn:create(0.6), cc.ScaleTo:create(0.5, 1))
                            local a = cc.Sequence:create( cc.ScaleTo:create(0.1, 0), spa)
                            v.soldier_bg:runAction(a)
                            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_soldierin")
                        end
                        self.isAction = false
                    end

                end)))
            end

            local sbuffs = self.detailPanel.sbuffs
            local hbuffs = self.detailPanel.hbuffs
            local speed = self:checkMinSpeed() or 0
            local supply = self:getSupply() or 0
            local carry = self:checkWeightChange() or 0

            self.detailPanel.curBase.speed  = speed
            self.detailPanel.curBase.supply = supply
            self.detailPanel.curBase.carry  = carry

            -- 加成
            speed  = speed*(1+(sbuffs.speed+hbuffs.speed))
            supply = supply*(1-(sbuffs.supply+hbuffs.supply))
            carry  = carry*(1+(sbuffs.carry+hbuffs.carry))

            self.detailPanel.troops_supply_city:setString(self:checkNumChange2())
            self.detailPanel.troops_resource:setString(math.ceil(carry))
            self.detailPanel.troops_size = self:checkNumChange()
            self.detailPanel.detailData.troops_speed = string.format(luaCfg:get_local_string(10025), math.ceil(speed))
            self.detailPanel.detailData.troops_supply = math.ceil(supply).. luaCfg:get_local_string(10076)
            self.detailPanel.detailData.troops_carry = math.ceil(carry)
            local commanderScaleMax = self.detailPanel.heroMsg.serverData.lbase[4] + self.detailPanel.heroMsg.serverData.lextra[4]
            self.detailPanel.troops_scale:setString(self:checkNumChange() .. "/" .. commanderScaleMax)
            
            self.detailPanel:flushCommanderValue()
            
            global.tools:adjustNodeVerical(self.detailPanel.troops_supply_city, self.detailPanel.ml_troops_supply_city)            
            self.detailPanel.troops_supply_add_city:setPositionX(self.detailPanel.troops_supply_city:getContentSize().width+5)
        end
        i = i + 1
    end
end

function UISoldierItem:checkScroPosition( itemId )

    self:stopAllActions()
    local container = self.detailPanel.ScrollView_Soilder:getInnerContainer()

    local scroX, totNum = 0, 0
    for i,v in pairs(self.detailPanel.itemHeadList) do
        local num =  tonumber(v.number:getString()) 
        if num > 0 then
            if  i<= itemId then
                scroX = scroX + 1
            end
            totNum = totNum + 1
        end
    end

    local scroXNum = scroX
    if scroXNum%3 == 0 then
        scroXNum = scroXNum - 2
    elseif scroXNum%3 == 2 then
        scroXNum = scroXNum - 1
    end
    
    local scroNum = #self.detailPanel.itemHeadList
    local itemW =  self.detailPanel.soldier_layout:getContentSize().width
    local scroWidth = self.detailPanel.ScrollView_Soilder:getContentSize().widget
    local containerW = scroNum*itemW
    local scroY = self.detailPanel.ScrollView_Soilder:getInnerContainerPosition().y

    if scroX <= 3 then
        self.detailPanel.ScrollView_Soilder:scrollToPercentHorizontal(0, 1, true)
    elseif scroX > (totNum - 3) then
        self.detailPanel.ScrollView_Soilder:scrollToPercentHorizontal(100, 1, true)
    else 
        self.detailPanel.ScrollView_Soilder:setInnerContainerPosition(cc.p(-(scroXNum-1)*itemW, scroY))
        return 0.3
    end
    return 0
end

function UISoldierItem:getSupply()
    
    local res = 0
    for _,v in ipairs(self.detailPanel.itemSoldier) do
        
        local count = tonumber( v.cur_count or 0 )
        if count > 0 then
        
            local sd = luaCfg:get_soldier_property_by(v.soldierID)
            res = res + sd.perRes * count 
        end    
    end

    return res
end

function UISoldierItem:checkMinSpeed()
    
    local speed = false
    for _,v in ipairs(self.detailPanel.itemSoldier) do
        
        if tonumber( v.cur_count or 0) > 0 then
        
            local sd = luaCfg:get_soldier_property_by(v.soldierID)
            local sd_speed = sd.speed

            if not speed or speed > sd_speed then

                speed = sd_speed        
            end
        end    
    end

    return speed
end

function UISoldierItem:checkWeightChange()

    local num = 0
    for _,v in pairs(self.detailPanel.itemSoldier) do

        local id ,dataBuild = global.cityData:getBuildingIdBySoldierId(v.data.lID)
        local lv = dataBuild.serverData.lGrade
        local capacity = global.funcGame:getSoldierLvup(lv, v.data.lID ,"capacity")

        if  global.luaCfg:get_soldier_train_by(v.data.lID).race == 0  then --死灵骑士默认属性

            capacity =luaCfg:get_soldier_property_by(v.data.lID).capacity
        end 

        num = num + capacity*tonumber( v.cur_count or 0) 
    end
    return num 
end

function UISoldierItem:checkNumChange()

    local num = 0

    for _,v in pairs(self.detailPanel.itemSoldier) do        
        local config = global.luaCfg:get_soldier_property_by(v.data.lID)
        num = num + v.perPop*tonumber(v.cur_count or 0) 
    end
    return num
end


function UISoldierItem:checkNumChange2()

    local num = 0

    for _,v in pairs(self.detailPanel.itemSoldier) do        
        local config = global.luaCfg:get_soldier_property_by(v.data.lID)
        num = num + v.perPop*tonumber(v.cur_count or 0) * config.changeTimes
    end
    return num
end

--CALLBACKS_FUNCS_END

return UISoldierItem

--endregion
