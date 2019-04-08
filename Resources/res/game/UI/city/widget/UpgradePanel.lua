--region UpgradePanel.lua
--Author : wuwx
--Date   : 2016/08/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
local cityData = global.cityData
local gameEvent = global.gameEvent

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UpgradePanel  = class("UpgradePanel", function() return gdisplay.newWidget() end )
local BuildingProItem = require("game.UI.city.widget.BuildingProItem")

function UpgradePanel:ctor()
    self:CreateUI()
end

function UpgradePanel:CreateUI()
    local root = resMgr:createWidget("city/build_lvup_ui")
    self:initUI(root)
end

function UpgradePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_lvup_ui")

    
    -- local nodeTimeLine = resMgr:createTimeline("city/build_lvup_ui")
    -- nodeTimeLine:play("animation0", false)
    -- self.root:runAction(nodeTimeLine)

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.suface_title = self.root.node_top.suface_title_export
    self.Text_build_name = self.root.node_top.Sprite_build_name.Text_build_name_export
    self.node_res = self.root.node_top.Image_29.node_res_export
    self.infoflag = self.root.infoflag_export
    self.nextlv = self.root.infoflag_export.nextlv_mlan_5_export
    self.lv_num = self.root.infoflag_export.lv_num_export
    self.TextNode = self.root.infoflag_export.TextNode_export
    self.ImgNode = self.root.infoflag_export.ImgNode_export
    self.bg_node = self.root.node.bg_node_export
    self.btn_upgrade = self.root.node.btn_upgrade_export
    self.grayBg2 = self.root.node.btn_upgrade_export.grayBg2_export
    self.time = self.root.node.btn_upgrade_export.time_export
    self.btn_quickbuild = self.root.node.btn_quickbuild_export
    self.grayBg1 = self.root.node.btn_quickbuild_export.grayBg1_export
    self.num = self.root.node.btn_quickbuild_export.num_export
    self.ScrollView_1 = self.root.node.ScrollView_1_export
    self.NodeUI = self.root.node.ScrollView_1_export.NodeUI_export

    uiMgr:addWidgetTouchHandler(self.btn_upgrade, function(sender, eventType) self:onNormalBuildHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_quickbuild, function(sender, eventType) self:onNoCdBuildHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.suface_title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    self.btn_left = self.ImgNode.btn_left
    self.btn_right = self.ImgNode.btn_right
    self.btn_left:setTouchEnabled(false)
    self.btn_right:setTouchEnabled(false)

    self.ImgNode.imgItemPage:addEventListener(handler(self,self.pageEvent))

    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.node_res)

    self.btn_upgrade:setSwallowTouches(true)

    -- 屏幕适配
    local y =  self.root.title:convertToWorldSpace((cc.p(0,0))).y 
    local part_y = 100 
    local yy = 0 
    if  y  >  gdisplay.height /2 - part_y then 
        yy =  y -(gdisplay.height /2 - part_y)
        self.root.title:setPositionY(self.root.title:getPositionY() -yy)
    end

    if yy > 0 then 
        local contentSize= self.bg_node:getContentSize()
        self.bg_node:setContentSize(cc.size(contentSize.width , contentSize.height -yy  ))

        contentSize= self.ScrollView_1:getContentSize()
        self.ScrollView_1:setContentSize(cc.size(contentSize.width , contentSize.height -yy  ))
    end 
end

function UpgradePanel:pageEvent(sender, eventType)

    local currentIndex = sender:getCurrentPageIndex()
    self.btn_left:setEnabled(currentIndex ~= 0)
    self.btn_right:setEnabled(currentIndex ~= #self.tempLvData.pic-1)
end

function UpgradePanel:initTouchListener()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(true)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.root.touch)
end

function UpgradePanel:onTouchBegan(touch, event)
    return true
end

function UpgradePanel:onTouchEnded(touch, event)
    self:onCloseHandler()
end

function UpgradePanel:onEnter(touch, event)

    self.costDiamond = 0
    global.delayCallFunc(function()
        global.luaCfg:build_lvup_ui()
    end,nil,0)    

    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.node_res)

    global.g_cityView:setUIVisible(false)
    self:initTouchListener()

    self.resBuffCut = 1
    self.buffTime = 0

    self:addEventListener(global.gameEvent.EV_ON_UI_BUILD_FLUSH, function (event, isRefershBtn)
        if isRefershBtn then
           self:refershBtn()
        else
            self:setUIText()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()        
        self:setUIText()
    end)

    self:addEventListener(global.gameEvent.EV_ON_UNION_CLEANCD,function(event , cleantype , time) --联盟帮助 清除 CD
        if self.data then 
            self:setData(self.data)
        end 
    end)

end

function UpgradePanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

function UpgradePanel:setData(data)

    local cityView = global.g_cityView
    local cityTouchMgr = global.g_cityView:getTouchMgr()
    local cityData = global.cityData

    self.data = data

    local cityView = global.g_cityView
    local cityTouchMgr = cityView:getTouchMgr()
    for i,i_building in ipairs(cityTouchMgr.registerBuildings) do
        if i_building.data and i_building.data.id == self.data.id and i_building.checkName then 
            i_building:checkName(true)
        end 
    end

    self.newData = cityData:getBuildingDataByLvAndId(data.id,data.serverData.lGrade+1)

    self:initInfoFlag()
    self.lv_num:setString(data.serverData.lGrade+1)

    local timeData = global.funcGame.formatTimeToHMS(self.newData.time)
    self.time:setString(timeData)
    -- self.num:setString(global.funcGame.getDiamondCount(self.newData.time))
    -- global.propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, self.costDiamond, self.num)
    
    self:upgradeBuff()
    self:setUIText()

    global.tools:adjustNodePos(self.nextlv,self.lv_num)



    -- cityTouchMgr:removeBuildingNodeBy(id)
end

-- 升级buff
function UpgradePanel:upgradeBuff()

    self.buffTime = 0
    self.resBuffCut = 1

    local buildingId = self.data.id
    global.gmApi:effectBuffer({{lType = luaCfg:get_buildings_pos_by(buildingId).funcType,lBind = buildingId}},function(msg)
        if tolua.isnull(self) then return end
        if not msg then return end
        if not msg.tgEffect then return end
        
        self.buffTime = self.buffTime or 0
        local buffData = msg.tgEffect[1]
        local buffs = buffData.tgEffect or {}
        for _,v in pairs(buffs) do
            if v.lEffectID == 3028 then -- 建筑资源消耗
                self.resBuffCut =  (1 - v.lVal/100)*self.resBuffCut
            elseif v.lEffectID == 3029 then -- 建筑时间减少
                self.buffTime = math.floor(100-(100-self.buffTime)*(100-v.lVal)/100)
            end
        end

        if self.setUIText then --报错处理 
            self:setUIText()
        end

        local buildTime = self.newData.time-math.floor(self.newData.time*self.buffTime/100) 
        self.time:setString(global.funcGame.formatTimeToHMS(buildTime))

    end)
end

function UpgradePanel:checkDiamond()
    local timeDiamond = global.funcGame.getDiamondCount(self.newData.time)
    local resDiamond = 0
    if self.noEnoughRes < 0 then
        local perDiamond = global.luaCfg:get_config_by(1).resPrice
        if perDiamond then 
            resDiamond = math.ceil(-self.noEnoughRes/perDiamond)
        end 
    end
    
    if self.newData.time <= global.cityData:getFreeBuildTime() then
        self.num:setString(luaCfg:get_local_string(10390))
        timeDiamond = 0
    else 
        self.num:setString(timeDiamond+resDiamond)
    end
    self.costDiamond = timeDiamond+resDiamond
    local isEnough = global.propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, self.costDiamond, self.num)
    return isEnough,timeDiamond,resDiamond
end

function UpgradePanel:setUIText()

    local cityTouchMgr = global.g_cityView:getTouchMgr()
    local canUpgrade = false
    local isFree = true
    local index = 1
    local proIdx = 0

    self.isEnoughLv = true
    self.noEnoughRes = 0
    if self.newData then

        --当前队列条件
        local builder = global.g_cityView:getFreeBuilder()
        if not builder then
            isFree = false
            index = 2

            if tolua.isnull(self.FileNode_ui_text1) then
                self.FileNode_ui_text1 = BuildingProItem.new()
                self.FileNode_ui_text1:setPositionX(-0.72)
                self.ScrollView_1.NodeUI_export:addChild(self.FileNode_ui_text1)
            end
            self.FileNode_ui_text1:setData({}, true)

        end
        self.buildingItem = cityTouchMgr:getBuildingNodeBy(self.data.id)
        self.buildingItem:setNextLvData(self.newData)
        self.Text_build_name:setString(self.data.buildsName.." "..luaCfg:get_local_string(10019,self.data.serverData.lGrade))

        --建筑多条件升级
        local isEnoughLv = true
        for _,v in pairs(self.newData.triggerId) do

            local triggerData = luaCfg:get_triggers_id_by(v) or {}
            local triggerStr = triggerData.triggerDescription
            local isEnough1 = cityData:checkTrigger(v)
            local triggerCondition = triggerData.triggerCondition
            local triggerItemData = {icon = nil,content = triggerStr, isEnough = isEnough1, triggerData = triggerData, triggerCondition = triggerCondition, isNoFirstNode = false}
            if tolua.isnull(self["FileNode_ui_text"..index]) then
                self["FileNode_ui_text"..index] = BuildingProItem.new()
                self["FileNode_ui_text"..index]:setPositionX(-0.72)
                self.ScrollView_1.NodeUI_export:addChild(self["FileNode_ui_text"..index])
            end
            self["FileNode_ui_text"..index]:setData(triggerItemData)

            index = index + 1
            isEnoughLv = isEnough1 and isEnoughLv
            self.isEnoughLv = isEnoughLv
        end

        -- 资源条件
        proIdx = index
        for i=proIdx,15 do
            if not tolua.isnull(self["FileNode_ui_text"..i]) then
                self["FileNode_ui_text"..i]:setVisible(false)
            end
        end

        local isEnough2 = true
        local t_dnum = 0
        for i=1,#self.newData.resource do

            if tolua.isnull(self["FileNode_ui_text"..proIdx]) then
                self["FileNode_ui_text"..proIdx] = BuildingProItem.new()
                self["FileNode_ui_text"..proIdx]:setPositionX(-0.72)
                self.ScrollView_1.NodeUI_export:addChild(self["FileNode_ui_text"..proIdx])
            end
            self["FileNode_ui_text"..proIdx]:setVisible(true)

            local resource = clone(self.newData.resource[i])
            local triggerData = luaCfg:get_item_by(resource[1])
            local num = math.ceil(resource[2]*self.resBuffCut)
            resource[2] = num
            local triggerStr = triggerData.itemName.." ".. global.funcGame:_formatBigNumber(num, 1) 
            local isEnough_temp,dnum = cityData:checkResource(resource)
            if dnum < 0 then
                t_dnum = t_dnum+dnum
            end
            isEnough2 = isEnough_temp and isEnough2
            local triggerItemData = {icon = triggerData.iconName,content = triggerStr, isEnough = isEnough_temp, triggerData = triggerData, isNoFirstNode = true}
            self["FileNode_ui_text"..proIdx]:setData(triggerItemData)
            proIdx = proIdx+1
        end

        canUpgrade = isEnoughLv and isEnough2
        self.noEnoughRes = t_dnum
    else
        canUpgrade = false
        global.tipsMgr:showWarning("建筑已经满级了!")
    end

    local containSizeH = proIdx*60
    local contentSizeH = self.ScrollView_1:getContentSize().height
    if containSizeH < contentSizeH then
        containSizeH = contentSizeH
    end

    self.NodeUI:setPositionX(0)
    for i=1,15 do
        if not tolua.isnull(self["FileNode_ui_text"..i]) then
            self["FileNode_ui_text"..i]:setPositionY(containSizeH-60*i)
        end
    end


    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containSizeH))
    self.ScrollView_1:jumpToTop()

    -- 临界时间点处理
    local builder = global.g_cityView:getFreeBuilder()
    if builder then
        isFree = true
    end

    self.isCanUpgrade = canUpgrade and isFree
    global.colorUtils.turnGray(self.grayBg2, self.isCanUpgrade == false)
    if self.noEnoughRes >= 0 then
        global.colorUtils.turnGray(self.grayBg1, self.isCanUpgrade == false)
    else
        global.colorUtils.turnGray(self.grayBg1, false)
    end

    self:checkDiamond()
end

-- 播放免费特效的同时按钮可点
function UpgradePanel:refershBtn()
    -- body
    local canUpgrade = false
    local isFree = true
    local index = 1
    local proIdx = 0

    self.isEnoughLv = true
    self.noEnoughRes = 0
    if self.newData then

        --当前队列条件
        local builder = global.g_cityView:getFreeBuilder()
        if not builder then
            isFree = false
            index = 2
  
        end
      
        --建筑多条件升级
        local isEnoughLv = true
        for _,v in pairs(self.newData.triggerId) do
            local isEnough1 = cityData:checkTrigger(v)
            index = index + 1
            isEnoughLv = isEnough1 and isEnoughLv
        end
        self.isEnoughLv = isEnoughLv

        -- 资源条件
        proIdx = index
        local isEnough2 = true
        local t_dnum = 0
        for i=1,#self.newData.resource do
         
            local resource = clone(self.newData.resource[i])
            local num = math.ceil(resource[2]*self.resBuffCut)
            resource[2] = num
            local isEnough_temp,dnum = cityData:checkResource(resource)
            if dnum < 0 then
                t_dnum = t_dnum+dnum
            end
            isEnough2 = isEnough_temp and isEnough2
            proIdx = proIdx+1
        end
        self.noEnoughRes = t_dnum
        canUpgrade = isEnoughLv and isEnough2
    else
        canUpgrade = false
        -- global.tipsMgr:showWarning("建筑已经满级了!")
    end

    -- 临界时间点处理
    local builder = global.g_cityView:getFreeBuilder()
    if builder then
        isFree = true
    end

    self.isCanUpgrade = canUpgrade and isFree
    global.colorUtils.turnGray(self.grayBg2, self.isCanUpgrade == false)
    if self.noEnoughRes >= 0 then
        global.colorUtils.turnGray(self.grayBg1, self.isCanUpgrade == false)
    else
        global.colorUtils.turnGray(self.grayBg1, false)
    end
end

local frameBg = {
    [1] = "icon/divine/divination_1.png",
    [3] = "icon/divine/divination_2.png",
    [5] = "icon/divine/divination_3.png",
}

function UpgradePanel:initInfoFlag()
    
    self.ImgNode.imgItemPage:removeAllChildren()

    -- 家族建筑特殊处理
    for i=1,3 do
        self.TextNode["info"..i]:setVisible(false)
        if self.TextNode["infoSp"..i] then
            self.TextNode["infoSp"..i]:setVisible(false)
        end
    end
    local isSpBuild = self.newData.buildingId > 1000
    if isSpBuild then
        self.ImgNode:setVisible(false)
        self.TextNode:setVisible(true)
        self.TextNode.unlockLv:setVisible(true)

        local nextLv = self.newData.level
        local tempLvData = self.newData
        if self.newData.typePara1 == "" then
            local stemp = {}
            local buildLvData = luaCfg:buildings_lvup()
            for _,v in pairs(buildLvData) do
                if v.buildingId == self.newData.buildingId and v.level > nextLv and v.typePara1 ~= "" then
                    table.insert(stemp, v)
                end   
            end  
            if #stemp > 0 then
                table.sort(stemp, function(s1, s2) return s1.level < s2.level end)
                tempLvData = stemp[1] 
            end
        end
        
        self.TextNode.unlockLv:setString(luaCfg:get_local_string(10011, tempLvData.level))
        local temp = 0
        for i=1,2 do
            if tempLvData["typePara"..i] ~= ""  then
                self.TextNode["infoSp"..i]:setVisible(true)
                self.TextNode["infoSp"..i].title:setString(tempLvData["typePara"..i])
                self.TextNode["infoSp"..i].des:setString(tempLvData["para"..i.."Now"])
                temp = i
            end
        end

        if temp == 1 then
            self.TextNode["infoSp1"]:setPosition(cc.p(0, 0.5))
        elseif temp == 2 then
            self.TextNode["infoSp1"]:setPosition(cc.p(0, -45))
            self.TextNode["infoSp2"]:setPosition(cc.p(0, 35))
        else
            self.TextNode.unlockLv:setVisible(false)
        end
        return
    end

    --处理解锁科技和解锁建筑
    if self.newData.intro_type < 0 then
        
        self.ImgNode:setVisible(true)
        self.TextNode:setVisible(false)

        -- 如果当前等级没有，则跳转至有的下一等级
        local nextLv = self.newData.level
        local tempLvData = self.newData
        if #self.newData.pic == 0 then

            local stemp = {}
            local buildLvData = luaCfg:buildings_lvup()
            for _,v in pairs(buildLvData) do
                if v.buildingId == self.newData.buildingId and v.level > nextLv and (#v.pic > 0) then
                    table.insert(stemp, v)
                end   
            end  
            if #stemp > 0 then
                table.sort(stemp, function(s1, s2) return s1.level < s2.level end)
                tempLvData = stemp[1] 
            end
        end 
        self.tempLvData = tempLvData

        self.ImgNode.lv_info:setString(luaCfg:get_local_string(10011,tempLvData.level))
        -- self.ImgNode.building_name:setString(self)

        self.btn_left:setVisible(#tempLvData.pic > 0)
        self.btn_right:setVisible(#tempLvData.pic > 0) 

        if  #tempLvData.pic > 0 then
            
            self.btn_left:setEnabled(false)
            self.btn_right:setEnabled(#tempLvData.pic > 1)
            self.ImgNode.imgItemPage:jumpToLeft()

            for i=1,#tempLvData.pic do
                local id = tempLvData.pic[i]
                local picName = nil
                local divBg = nil
                local name = ""
                local imgSp = ccui.ImageView:create()
                if tempLvData.intro_type == -1 then
                    -- 内城
                    if id == 16 then
                        -- 家族建筑
                        local data = luaCfg:get_buildings_pos_by(global.cityData:getBuildingType(id))
                        picName = data.name
                        name = data.buildsName
                    else
                        local data = luaCfg:get_buildings_pos_by(id)
                        picName = data.name
                        name = data.buildsName
                    end
                elseif tempLvData.intro_type == -25 then
                    -- 占卜古树
                    local data = luaCfg:get_divine_by(id)
                    divBg = frameBg[data.quality]
                    picName = data.icon
                    name = data.name
                elseif tempLvData.intro_type == -17 then
                    -- 科技研究
                    local data = luaCfg:get_science_by(id)
                    picName = data.icon
                    name = data.name
                end
                local layout=ccui.Layout:create()
                layout:setContentSize(self.ImgNode.imgItemPage:getContentSize())
                if picName then
                    -- imgSp:loadTexture(picName, ccui.TextureResType.plistType)
                    global.panelMgr:setTextureFor(imgSp,picName)
                end

                -- 占卜背景
                if divBg then
                    local divSp = ccui.ImageView:create()
                    -- divSp:loadTexture(divBg, ccui.TextureResType.plistType)
                    global.panelMgr:setTextureFor(divSp,divBg)
                    divSp:setAnchorPoint(cc.p(0, 0))
                    divSp:setPosition(cc.p(-8, -8))
                    divSp:setScale(1.42)
                    imgSp:addChild(divSp)
                end

                imgSp:setAnchorPoint(cc.p(0.5,0.5))
                imgSp:setPosition(cc.p(80, 80))
                if tempLvData.picScale[i] then
                    imgSp:setScale(tempLvData.picScale[i]/100)
                end
                layout:addChild(imgSp)
                local nameText = gdisplay.newText(self.ImgNode.building_name)
                nameText:setString("hahaha")
                nameText:setAnchorPoint(cc.p(0.5,0.5))
                nameText:setPosition(cc.p(80, 10))
                nameText:setString(name)
                layout:addChild(nameText)
                self.ImgNode.imgItemPage:addPage(layout)
            end   
        end
    elseif self.newData.intro_type == 2 then

        self.TextNode:setVisible(true)
        self.ImgNode:setVisible(false)
        self.TextNode.unlockLv:setVisible(false)

        local temp = 0
        for i=1,3 do
            self.TextNode["info"..i]:setVisible(true)
            if  self.newData["typePara"..i] ~= ""   then
                self.TextNode["info"..i]:setPosition(cc.p(0, (2-i)*60))
                self.TextNode["info"..i].lv_info:setString(self.newData["typePara"..i])
                self.TextNode["info"..i].now_info:setString(self.newData["para"..i.."Now"])
                self.TextNode["info"..i].up_info:setString(self.newData["para"..i.."Next"])
                self.TextNode["info"..i].jiahao:setVisible(true)
                temp = temp + 1
            else
                self.TextNode["info"..i].lv_info:setString("")
                self.TextNode["info"..i].now_info:setString("")
                self.TextNode["info"..i].up_info:setString("")
                self.TextNode["info"..i].jiahao:setVisible(false)
            end 
        end

        if temp == 1 then
            self.TextNode["info1"]:setPosition(cc.p(0, 0.5))
        elseif temp == 2 then
            self.TextNode["info1"]:setPosition(cc.p(0, -25))
            self.TextNode["info2"]:setPosition(cc.p(0, 35))
        end
    end
end

function UpgradePanel:setCloseCall(call)
    self.closeCall = call
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UpgradePanel:onNormalBuildHandler(sender, eventType)
    
    -- if self.data and self.data.buildingType == 17 then  -- 科技在研究不能升级
    --     if global.techData:isHaveTech() then 
    --         global.tipsMgr:showWarning("ScienceResearching")
    --         return  
    --     end 
    -- else 
    --     if not self.isCanUpgrade then
    --         global.tipsMgr:showWarning("upgrade_conditon")
    --         return 
    --     end
    -- end 

    if not self.isCanUpgrade then
        if global.g_cityView:checkThirdBuildLocked() then
            global.tipsMgr:showWarning("upgrade_conditon")
        else
            -- global.tipsMgr:showWarning(luaCfg:get_local_string(10091))
            -- global.panelMgr:openPanel("UIMonthCardPanel"):setData()
            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10979, target=5})
        end
        return 
    end

    local function workOverCall()
    end
    local builder = global.g_cityView:getFreeBuilder()
    if builder then
        self.buffTime = self.buffTime or 0
        local buildTime = self.newData.time-math.floor(self.newData.time*self.buffTime/100) 
        -- local buildTime = math.ceil(self.newData.time*self.buffTime)
        if builder:isCharged() and not global.cityData:canBuildInOpened(buildTime) then
            -- global.tipsMgr:showWarning(luaCfg:get_local_string(10091))
            --打开道具使用界面
            -- local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 解锁道具使用
            -- panel:setData(handler(builder,  builder.unLockQueueCall), builder:getQueueId(), panel.TYPE_QUEUE_UNLOCK)
            -- global.panelMgr:openPanel("UIMonthCardPanel"):setData()
            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10980, target=5})
            return
        end

        local updateCall = function()
            local cityView = global.g_cityView
            local cityNode = cityView.touchMgr:getBuildingNodeBy(self.data.id)
            if cityNode and cityNode.canHarvest and cityNode:canHarvest() then
                cityNode:harvest(true)
            end

            local beforeResLevel = global.userData:getResLevel()

            local noModal = nil
            if self.data.id == 1 and self.data.serverData.lGrade == 1 then
                noModal = false
            end
            global.cityApi:buildUpgrade(self.data.id,function(msg)
                --扣除资源
                -- for i=1,#self.newData.resource do
                --     local resource = self.newData.resource[i]
                --     propData:addProp(resource[1],-resource[2])
                -- end
                --取消重置老纹理的操作
                if self.data then
                    cityData:setNewLvDataBy(self.data.id,self.newData)
                    cityData:setServerDataById(self.data.id,msg.tgBuild,true)
                end 
                cityData:setBuilderBy(msg.tgQueue.lID,msg.tgQueue)

                if cityView and cityView.getFreeBuilder then
                    cityView:getFreeBuilder(msg.tgQueue.lID):work(workOverCall)
                end
                      
                local curResLevel = global.userData:getResLevel()
            
                print('curResLevel',curResLevel,beforeResLevel)
                if curResLevel > beforeResLevel then

                    global.userData:setFreeToMoveCity()
                end
            end,nil,noModal)  
            self:onCloseHandler()
            --　特效播放监听
            gevent:call(gameEvent.EV_ON_UI_EFFECT_PLAY, cityNode ,self.data) 
        end    

        local noProtectLv = luaCfg:get_config_by(1).noProtectLv
        if self.data.id == 1 and self.data.serverData.lGrade + 1 >= noProtectLv then            
            if global.userData:getWorldCityID() == 0 then

                global.tipsMgr:showWarning("686")
            else
                global.worldApi:checkMainCityNewProtect(function(isInProtect)
                
                    if isInProtect then                    
                        local panel = global.panelMgr:openPanel("UIPromptPanel")
                        panel:setData("CityLvProtect",updateCall,noProtectLv)
                    else                    
                        updateCall()        
                    end
                end)
            end          
        else            
            updateCall()
        end          
    else
        global.tipsMgr:showWarning("NoBuildQueue")
    end
end

function UpgradePanel:onCloseHandler(sender, eventType)
    if self.buildingItem then
        self.buildingItem:resetData()
    end
    global.g_cityView:setUIVisible(true)
    global.panelMgr:closePanelForBtn("UpgradePanel")
    if self.closeCall then self.closeCall() end
end

function UpgradePanel:onNoCdBuildHandler(sender, eventType)
    
    -- if self.data and  self.data.buildingType == 17 then  -- 科技在研究不能升级
    --     if global.techData:isHaveTech() then 
    --         global.tipsMgr:showWarning("ScienceResearching")
    --         return  
    --     end 
    -- else 
    --     if not self.isCanUpgrade then
    --         global.tipsMgr:showWarning("upgrade_conditon")
    --         return 
    --     end
    -- end 

    if not self.isCanUpgrade then
        if global.g_cityView:checkThirdBuildLocked() then
            if not self.isEnoughLv then
                local proItem = self["FileNode_ui_text1"]
                local index = 1
                for _,v in pairs(self.newData.triggerId) do
                    local data = self["FileNode_ui_text"..index]:getData() or {}
                    if not data.isEnough then
                        proItem = self["FileNode_ui_text"..index]
                    end
                    index = index+1
                end
                local data = proItem:getData()
                if data then
                    local buildingData = global.cityData:getBuildingById(data.triggerData.buildsId)
                    local titlestr = global.luaCfg:get_translate_string(10990,buildingData.buildsName,data.triggerData.triggerCondition)
                    global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=titlestr, isnottitleId = true, target=6, callback = function()
                        -- body
                        proItem:onOperateHandler()
                    end})
                end
                return  
            else
                if self.noEnoughRes < 0 then
                else
                    return global.tipsMgr:showWarning("upgrade_conditon")
                end
            end
        else
            return global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10979, target=5})
        end
    end

    local callfunction = function()
        -- body
        local builder = global.g_cityView:getFreeBuilder()
        if builder then
            if not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,self.costDiamond) then return end

            local updateCall = function()
                
                local cityView = global.g_cityView
                local cityNode = cityView.touchMgr:getBuildingNodeBy(self.data.id)
                if cityNode and cityNode.canHarvest and cityNode:canHarvest() then
                    cityNode:harvest(true)
                end
                local beforeResLevel = global.userData:getResLevel()

                local cloneData = clone(self.data)
                local noModal = nil
                if cloneData.id == 1 and cloneData.serverData.lGrade == 1 then
                    noModal = false
                end
                global.cityApi:buildUpgrade(self.data.id,function(msg)
                    --取消重置老纹理的操作
                    cityData:setNewLvDataBy(cloneData.id,self.newData)
                    cityData:setServerDataById(cloneData.id,msg.tgBuild,true)    
                    cityData:setBuilderBy(msg.tgQueue.lID,msg.tgQueue)

                    local cityView = global.g_cityView
                    cityView:getFreeBuilder(msg.tgQueue.lID):work(workOverCall)

                          
                    local curResLevel = global.userData:getResLevel()
                
                    print('curResLevel',curResLevel,beforeResLevel)
                    if curResLevel > beforeResLevel then

                        global.userData:setFreeToMoveCity()
                    end
                end,1,noModal)
                self:onCloseHandler()
                --　特效播放监听
                gevent:call(gameEvent.EV_ON_UI_EFFECT_PLAY, cityNode ,self.data) 
            end

            local noProtectLv = luaCfg:get_config_by(1).noProtectLv
            if self.data.id == 1 and self.data.serverData.lGrade + 1 >= noProtectLv then            
                if global.userData:getWorldCityID() == 0 then

                    global.tipsMgr:showWarningText("没有创建过城池，无法判断是否有保护罩")
                else
                    global.worldApi:checkMainCityNewProtect(function(isInProtect)
                    
                        if isInProtect then                    
                            local panel = global.panelMgr:openPanel("UIPromptPanel")
                            panel:setData("CityLvProtect",updateCall,noProtectLv)
                        else                    
                            updateCall()        
                        end
                    end)
                end         
            else            
                updateCall()
            end        
        else
            global.tipsMgr:showWarning("NoBuildQueue")
        end
    end


    local isEnoughDiamond,timeCost,resCost = self:checkDiamond()
    if not isEnoughDiamond then
        global.tipsMgr:showWarning("ItemUseDiamond")
        return 
    end

    if self.noEnoughRes < 0 then
        local panel = global.panelMgr:openPanel("UIPromptUpgradePanel")
        local param = {}
        param.res = {}
        param.totalcost = self.costDiamond

        for i=1,#self.newData.resource do
         
            local resource = clone(self.newData.resource[i])
            local num = math.ceil(resource[2]*self.resBuffCut)
            resource[2] = num
            local isEnough_temp,dnum = cityData:checkResource(resource)
            if dnum < 0 then
                param.res[resource[1]] = -dnum
            end
        end
        panel:setData(param,function()
            callfunction()
        end)
    else
        callfunction()
    end

end
--CALLBACKS_FUNCS_END

return UpgradePanel

--endregion
