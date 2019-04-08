--region UIPetTime.lua
--Author : yyt
--Date   : 2017/12/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetTime  = class("UIPetTime", function() return gdisplay.newWidget() end )

function UIPetTime:ctor()
    self:CreateUI()
end

function UIPetTime:CreateUI()
    local root = resMgr:createWidget("pet/pet_fy_node")
    self:initUI(root)
end

function UIPetTime:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_fy_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.unLock = self.root.unLock_mlan_7_export
    self.timeNode = self.root.timeNode_export
    self.time = self.root.timeNode_export.time_export
    self.NodeLocked = self.root.NodeLocked_export
    self.starLv = self.root.NodeLocked_export.starLv_export
    self.lockBg = self.root.NodeLocked_export.lockBg_export
    self.petName = self.root.NodeLocked_export.lockBg_export.petName_export
    self.NodeStar = self.root.NodeLocked_export.NodeStar_export
    self.star10_bj = self.root.NodeLocked_export.NodeStar_export.star10_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star10_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star10_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star10_bj_export.starTotal9_export.star18_export
    self.star9_bj = self.root.NodeLocked_export.NodeStar_export.star9_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star9_bj_export.starTotal9_export.star18_export
    self.star8_bj = self.root.NodeLocked_export.NodeStar_export.star8_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star8_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star8_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star8_bj_export.starTotal9_export.star18_export
    self.star7_bj = self.root.NodeLocked_export.NodeStar_export.star7_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star7_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star7_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star7_bj_export.starTotal9_export.star18_export
    self.star6_bj = self.root.NodeLocked_export.NodeStar_export.star6_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star6_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star6_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star6_bj_export.starTotal9_export.star18_export
    self.star5_bj = self.root.NodeLocked_export.NodeStar_export.star5_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star5_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star5_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star5_bj_export.starTotal9_export.star18_export
    self.star4_bj = self.root.NodeLocked_export.NodeStar_export.star4_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star4_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star4_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star4_bj_export.starTotal9_export.star18_export
    self.star3_bj = self.root.NodeLocked_export.NodeStar_export.star3_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star3_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star3_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star3_bj_export.starTotal9_export.star18_export
    self.star2_bj = self.root.NodeLocked_export.NodeStar_export.star2_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star2_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star2_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star2_bj_export.starTotal9_export.star18_export
    self.star1_bj = self.root.NodeLocked_export.NodeStar_export.star1_bj_export
    self.starTotal9 = self.root.NodeLocked_export.NodeStar_export.star1_bj_export.starTotal9_export
    self.star17 = self.root.NodeLocked_export.NodeStar_export.star1_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeLocked_export.NodeStar_export.star1_bj_export.starTotal9_export.star18_export
    self.friendGet = self.root.Button_1.friendGet_export
    self.petIcon = self.root.Button_1.friendGet_export.petIcon_export
    self.interactive = self.root.Button_1.interactive_export
    self.effectPos = self.root.effectPos_export

    uiMgr:addWidgetTouchHandler(self.friendGet, function(sender, eventType) self:getFriendHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.friendGet:setSwallowTouches(false)
    self.Button_1 = self.root.Button_1

    self.effectPos:setName("PET_GUID_POS")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetTime:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_PET_CD, function ()
        if self.setFreeCd and self.Button_1 and (not self.Button_1:isVisible()) then
            self.data = global.petData:getGodAnimalByFighting()
            self:setFreeCd()
        end
    end)
    
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("pet/pet_fy_node")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
    
end

function UIPetTime:onExit()
    gdisplay.removeSpriteFrames("pet.plist", string.gsub("pet.plist", ".plist", ".png"))
end

function UIPetTime:setData(data)
    -- body

    self.data = data
    self.timeNode:setVisible(false)
    self.unLock:setVisible(false)
    self.NodeLocked:setVisible(false)
    self.Button_1:setVisible(false)



    if data.serverData.lState == 2 then  
        self.timeNode:setVisible(true)
        self:setUnLockTime()
    elseif data.serverData.lState == 3 then
        self.unLock:setVisible(true)
    else

        self.NodeLocked:setVisible(true)
        -- 设置星星
        local per = 10
        local lv = data.serverData.lGrade
        local curClass = math.ceil(lv/per) 
        for i=1,10 do
            self["star"..i.."_bj"]:setVisible(false)
            if i<=curClass then
                self["star"..i.."_bj"]:setVisible(true)
            end
        end

        local starPosX = self.lockBg:getContentSize().width/2
        self.starLv:setString("+"..(lv-per*(curClass-1)))
        local perStarWidth = 45*0.8
        local width = perStarWidth*curClass
        self.NodeStar:setPositionX(starPosX-width/2)
        self.starLv:setPosition(cc.p(self.NodeStar:getPositionX()+width, self.NodeStar:getPositionY()))
        self.petName:setString(data.name)

        -- 神兽好感cd
        self:setFreeCd()
    end
end

function UIPetTime:setFreeCd()

    gdisplay.loadSpriteFrames("pet.plist")
    
    self.Button_1:setVisible(false)
    local inIcon = {[1]="pet_17.png",[2]="pet_18.png",[3]="pet_21.png"}
    local inTitle = {[1]=11091,[2]=11092,[3]=11093}
    local curFightPet = global.petData:getGodAnimalByFighting()
    if curFightPet then

        if global.petData:isGodAnimalMaxLv(self.data.type) then return end

        local cdGetVal = {}
        local cdTemp = curFightPet.serverData.lMeetTimes
        for i=1,3 do
            if cdTemp[i] and  cdTemp[i] > global.dataMgr:getServerTime() then
            else
                table.insert(cdGetVal, i)
            end
        end

        if table.nums(cdGetVal) > 0 then -- 满级不显示
            table.sort(cdGetVal, function(s1, s2) return s1 > s2 end)
            local cdId = cdGetVal[1]
            self.petIcon:setSpriteFrame(inIcon[cdId])
            self.interactive:setString(luaCfg:get_local_string(inTitle[cdId]))
            self.Button_1:setVisible(true)
            self.cdId = cdId
        end
    end
end

function UIPetTime:setUnLockTime()
    
    self.lEndTime = 0
    if self.data.serverData and self.data.serverData.lMeetTimes and self.data.serverData.lMeetTimes[4] then
        self.lEndTime = self.data.serverData.lMeetTimes[4] 
    end 
    self:cutTime()
end

function UIPetTime:cutTime()

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIPetTime:countDownHandler(dt)
    if self.lEndTime <= 0 then
        self.time:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = self.lEndTime - curr
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        return
    end
    self.time:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIPetTime:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    self.getFriending = nil
end

function UIPetTime:getFriendHandler(sender, eventType)
    
    if not self.cdId then return end
    if self.getFriending then return end
    self.getFriending = true

    local id = self.cdId
    local data = clone(self.data)
    global.petApi:actionPet(function (msg)
        -- body
        self.getFriending = nil
        if not msg then return end
        global.petData:updateGodAnimal(msg.tagGodAnimal or {})
    
        local interData = luaCfg:get_pet_interactive_by(id)
        local friendlyVal = interData.friendly*data.serverData.lGrade
        gevent:call(global.gameEvent.EV_ON_PET_REFERSH, friendlyVal)

    end, 2, data.type, 1, id)

end

--CALLBACKS_FUNCS_END

return UIPetTime

--endregion
