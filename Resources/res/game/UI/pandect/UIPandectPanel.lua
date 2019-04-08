--region UIPandectPanel.lua
--Author : yyt
--Date   : 2017/08/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local resData = global.resData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIPandectPanel  = class("UIPandectPanel", function() return gdisplay.newWidget() end )

local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIPandectItemCell = require("game.UI.pandect.UIPandectItemCell")
local TabControl = require("game.UI.common.UITabControl")

function UIPandectPanel:ctor()
    self:CreateUI()
end

function UIPandectPanel:CreateUI()
    local root = resMgr:createWidget("common/pandect_bg")
    self:initUI(root)
end

function UIPandectPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.commonNode = self.root.Node_1.commonNode_export
    self.level = self.root.Node_1.commonNode_export.levle_mlan_6.level_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.Node_1.commonNode_export.portrait)
    self.name = self.root.Node_1.commonNode_export.name_export
    self.ach_num = self.root.Node_1.commonNode_export.ach_num_export
    self.txt_power = self.root.Node_1.commonNode_export.txt_power_export
    self.sever = self.root.Node_1.commonNode_export.sever_mlan_6.sever_export
    self.tbControlNode = self.root.tbControlNode_export
    self.topNode = self.root.topNode_export
    self.tbSize = self.root.tbSize_export
    self.cellSize = self.root.cellSize_export
    self.node_table = self.root.node_table_export
    self.itemH1 = self.root.itemH1_export
    self.cellSizeSoldier = self.root.cellSizeSoldier_export
    self.cellSizeTroop = self.root.cellSizeTroop_export
    self.itemH2 = self.root.itemH2_export
    self.itemH3 = self.root.itemH3_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tabControl = TabControl.new(self.tbControlNode, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.tableView = UIChatTableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIPandectItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN) 
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)  
        :setColumn(1)      
    self.node_table:addChild(self.tableView)

    --润稿翻译 张亮
    global.tools:adjustNodePosForFather(self.sever:getParent(),self.sever)
    global.tools:adjustNodePosForFather(self.level:getParent(),self.level)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPandectPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIPandectPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIPandectPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIPandectPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIPandectPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIPandectPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIPandectPanel:onEnter()

    self.isPageMove = false
    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACM_UPDATE, function()       
        local completeNum = global.achieveData:getCurCompleteNum()
        local totalNum = table.nums(luaCfg:achievement())
        self.ach_num:setString(completeNum .. "/" .. totalNum)
    end)

    self:addEventListener(global.gameEvent.EV_ON_SKINPANDECT_UPDATE, function ()
        -- body
        if self.initSerVal then
            self:initSerVal(true)
        end
    end)
    
    -- 资源分页buff
    self.wareHouseAdd = 0
    self:resBuff()
end

------------------------------------------ 资源分页buff ---------------------------------------
function UIPandectPanel:resBuff()

    self.resAddServer = {}

    local tgReq = {}
    for i=1,4 do
        local temp = {}
        temp.lType = 5
        temp.lBind = i
        table.insert(tgReq, temp)
    end

    -- 仓库保护百分比
    local wareHouse = {}
    wareHouse.lType = global.luaCfg:get_buildings_pos_by(18).funcType
    wareHouse.lBind = 18
    table.insert(tgReq, wareHouse)

    global.gmApi:effectBuffer(tgReq, function (msg)

        if not self.setResBuff or not self.resAddServer then -- 协议返回 方法可能为 nil  
            return 
        end 
        msg.tgEffect = msg.tgEffect or {}
        for _,v in pairs(msg.tgEffect) do
            if v.tgEffect then 

                if v.lBind <= 4 then
                    local temp = {}
                    temp.lBind = v.lBind
                    temp.lType = v.lType
                    temp.serverData = self:setResBuff(v.tgEffect) 
                    table.insert(self.resAddServer, temp)
                elseif v.lBind == 18 then

                    local addVal = 0
                    local buffs = v.tgEffect or {}
                    for _,vv in pairs(buffs) do
                        if vv.lEffectID == 3060 then
                            addVal = addVal + vv.lVal
                        end
                    end
                    if addVal > 0 then
                        self.wareHouseAdd = addVal
                        gevent:call(global.gameEvent.EV_ON_RESWAREHOUSE, addVal)
                    end
                end
            end
        end
        resData:setServerBuff(self.resAddServer)
        resData:initData()
        gevent:call(global.gameEvent.EV_ON_UI_CITY_FEATURE)

    end)

    -- 更新自己城池特色加成
    local mainCityId = global.userData:getWorldCityID()
    global.worldApi:getCityDetail(mainCityId,function(msg)

        resData:setOccupyMaxInfo(msg)
        resData:initData()
        gevent:call(global.gameEvent.EV_ON_UI_CITY_FEATURE)
    end)
    
end

function UIPandectPanel:setResBuff(msg)
    
    local itemBuff = {}
    local heroBuff = {}
    local techBuff = {}
    local divineBuff = {}
    local cityBuff = {}
    local vipBuff = {}
    local lordBuff={}

    for i,v in ipairs(msg) do

        if v.lFrom == 2 then
            table.insert(heroBuff, v)
        elseif v.lFrom == 3 then
            table.insert(techBuff, v)
        elseif v.lFrom == 4 then
            table.insert(vipBuff, v)
        elseif v.lFrom == 5 then
            table.insert(divineBuff, v)
        elseif v.lFrom == 6 then
            table.insert(itemBuff, v)
        elseif v.lFrom == 7 then
            table.insert(cityBuff, v)
        elseif v.lFrom == 12 then 
            table.insert(lordBuff, v)
        end       
    end

    local temp = {}
    temp.heroBuff = heroBuff
    temp.techBuff = techBuff
    temp.vipBuff = vipBuff
    temp.divineBuff = divineBuff
    temp.itemBuff = itemBuff
    temp.cityBuff = cityBuff
    temp.lordBuff = lordBuff
    return temp
end
------------------------------------------ 资源分页buff ---------------------------------------

function UIPandectPanel:initData(defaultIndex)

    self.defaultIndex = defaultIndex
    self:initInfo()
    self:initSerVal()
    self:refershPandect(luaCfg:data_pandect())

end

function UIPandectPanel:initSerVal(isnotSet)

    global.commonApi:getAllMsgInfo(function (msg)
        -- body
        msg.tagCombat = msg.tagCombat or {}
        msg.tagFightRecord = msg.tagFightRecord or {}
        msg.tagBuffTotal  = msg.tagBuffTotal  or {}
        msg.tagOccupyTotal  = msg.tagOccupyTotal  or {}

        local getBuffVal = function (buffId)
            -- body
            for _,v in pairs(msg.tagBuffTotal) do
                if v.lBuffid == buffId then
                    return v.lValue, v.tagBuffFrom
                end
            end
            return 0, nil
        end

        -- 计算胜率
        local recordFight = {}
        for i=1,#msg.tagFightRecord do

            if i == 3 then
                local winR = msg.tagFightRecord[1]
                local figR = msg.tagFightRecord[2]
                local winBuff = 0
                if (winR+figR) > 0 then
                    winBuff = winR/(winR+figR)
                end
                table.insert(recordFight, winBuff*100)
            end
            table.insert(recordFight, msg.tagFightRecord[i])
        end
        
        local configData = clone(luaCfg:data_pandect())
        for _,v in pairs(configData) do
         
            if v.data_type > 0 then
                v.serVal, v.serBuffFrom = getBuffVal(v.data_type)
            else
                if v.type == 1 and v.kind == 1 then
                    v.serVal = msg.tagCombat[v.order] or 0
                end
                if v.type == 1 and v.kind == 2 then
                    v.serVal = recordFight[v.order] or 0
                end
            end
        end

        local wildMax, _   = getBuffVal(3078) -- 占领野地上限
        local villageMax,_ = getBuffVal(3077) -- 占领村庄上限
        local cityMax, _   = getBuffVal(3076) -- 占领城池上限
        local sevExtra = {occupyData=msg.tagOccupyTotal, wildMax=wildMax, villageMax=villageMax, cityMax=cityMax}
        if self.refershPandect then 
            self:refershPandect(configData,  sevExtra, isnotSet)
        end 
    end)

end

-- 自己部队和盟友驻防部队
function UIPandectPanel:getTroopAll()

    local data = {}
    local userId = global.userData:getUserId()
    for _,v in pairs(global.troopData:getTroopList()) do
        if v.lUserID == userId and v.lID ~= 0 then
            v.troopScale = global.troopData:getTroopsScaleById(v.lID) or 0
            table.insert(data, v)
        elseif v.lTarget == global.userData:getWorldCityID() and v.lID ~= 0 then
            v.troopScale = global.troopData:getTroopsScaleById(v.lID) or 0
            table.insert(data, v)
        end
    end
    if table.nums(data) > 1 then
        table.sort(data, function (s1, s2)  return s1.troopScale > s2.troopScale end)
    end

    -- 部队上限
    local canNewTroopNum = luaCfg:get_troop_max_by(global.userData:getLevel()).num
    for i=#data+1, canNewTroopNum  do
        table.insert(data, {isEmptyItem=true, lType=i})
    end

    return data
end

-- 所有的未编队士兵
function UIPandectPanel:getSoldierAll()

    local data = {}
    local soldier = global.soldierData:getSoldiers()
    for i,v in ipairs(soldier) do
        if v.lCount > 0 then
            table.insert(data, v)
        end
    end
    if #data > 1 then
        table.sort(data, function(s1, s2) return s1.lID < s2.lID end) 
    end
    -- 士兵空位
    if #data == 0 then
        table.insert(data, {isEmptyItem=true, lType=6})
    end
    return data
end

function UIPandectPanel:refershPandect(configData, sevExtra, isnotSet)

    self.totalData = {}

    -- 加成
    local addPandect = function ()
        local buffs = {}
        local tbData = self:getPandectData(1, configData)
        local singleCellH1 = self.itemH1:getContentSize().height
        for _,v in ipairs(tbData) do
            local temp = {}
            local iNum = table.nums(v) 
            temp.cellH = iNum*singleCellH1 + 60 -- 标题高度
            temp.cdata = clone(v)
            temp.cType = 0
            table.insert(buffs, temp)
        end
        table.insert(self.totalData, buffs)
    end

    -- 部队
    local troopPandect = function ()
        local troop = {} 
        local troopData = self:getTroopAll()
        for i,v in ipairs(troopData) do
            local temp1 = {}
            temp1.cellH = self.cellSizeTroop:getContentSize().height
            temp1.cdata = v
            if v.isEmptyItem then
                temp1.cType = 7
            else
                temp1.cType = 5
            end
            table.insert(troop, temp1)
        end
        table.insert(self.totalData, troop)
    end

    -- 士兵
    local soldierPandect = function ()
        local soldier = {}
        local soldierData = self:getSoldierAll()
        for i,v in ipairs(soldierData) do
            local temp2 = {}
            temp2.cellH = self.cellSizeSoldier:getContentSize().height
            temp2.cdata = v
            if v.isEmptyItem then
                temp2.cType = 8
            else
                temp2.cType = 6
            end
            table.insert(soldier, temp2)
        end
        table.insert(self.totalData, soldier)
    end

    -- 野地1 、村庄2 、占领城池3、奇迹4
    local cityPandect = function ()
        -- body
        local cityOccupy = {}
        local singleCellH2 = self.itemH2:getContentSize().height
        for i=1,4 do
            local temp3 = {}
            local occupyData = self:getOccupyByType(i, sevExtra)
            local iNum1 = table.nums(occupyData) 
            temp3.cellH = iNum1*singleCellH2 + 60 -- 标题高度
            temp3.cdata = occupyData
            temp3.cType = i
            table.insert(cityOccupy, temp3)
        end

        table.insert(self.totalData, cityOccupy)
    end

    -- 资源
    local resPandect = function ()
        -- body
        local resD = {}
        for i,v in ipairs(global.resData:getRes()) do
            local temp4 = {}
            temp4.cellH = self.itemH3:getContentSize().height
            temp4.cType = 9
            temp4.cdata = v
            temp4.wareHouseAdd = self.wareHouseAdd
            table.insert(resD, temp4)
        end
        table.insert(self.totalData, resD)
    end

    addPandect()
    troopPandect()
    soldierPandect()
    cityPandect()
    resPandect()

    self.tabControl:setSelectedIdx(self.defaultIndex or 1)
    self:setData(self.totalData[self.defaultIndex or 1], isnotSet)
end

function UIPandectPanel:getOccupyByType(lType, sevExtra)

    sevExtra = sevExtra or {}
    local tagOccupyTotal = sevExtra.occupyData

    local getOccupy = function (lType, params)
        if not tagOccupyTotal then return {} end
        params = params or -1
        local data = {}
        for i,v in ipairs(tagOccupyTotal) do
            if v.lType == lType or v.lType == params then
                table.insert(data, v)
            end
        end
        return data
    end

    local temp = {}
    if lType == 1 then

        temp = clone(global.resData:getWorldWild())
        -- 占领野地上限
        for i=#temp+1, sevExtra.wildMax or 0   do
            table.insert(temp, {isEmptyItem=true, lType=1})
        end

    elseif lType == 2 then

        temp = getOccupy(1) 
        -- 占领村庄上限
        for i=#temp+1, sevExtra.villageMax or 0  do
            table.insert(temp, {isEmptyItem=true, lType=2})
        end

    elseif lType == 3 then

        temp = clone(global.resData:getCityResData())
        -- 占领城池上限
        for i=#temp+1, sevExtra.cityMax or 0  do
            table.insert(temp, {isEmptyItem=true, lType=3})
        end

    elseif lType == 4 then
        temp = getOccupy(2)      -- 奇迹
        local tb = getOccupy(3, 4)  -- 神殿\奇迹
        for _,v in pairs(tb) do
            table.insert(temp, v)
        end

        if #temp == 0 then
            table.insert(temp, {isEmptyItem=true, lType=4})
        end
    end
    return temp
end

function UIPandectPanel:initInfo()
    
    local shortName = global.unionData:getInUnionShortName()
    local name = global.userData:getUserName()
    if shortName ~= "" then
        self.name:setPositionX(-105)
        self.name:setString(luaCfg:get_local_string(10333, shortName) .. name)
    else
        self.name:setPositionX(-95)
        self.name:setString(name)
    end
    self.level:setString(global.userData:getLevel())
    local serverData = global.ServerData:getServerDataBy(global.loginData:getCurServerId())
    self.sever:setString(serverData.servername)
    self.txt_power:setString(global.userData:getPower())

    local headInfo = global.userheadframedata:getCrutFrame() or {}
    local headData = global.headData:getCurHead() or {}
    self.portrait:setData(headData.id or 108, headInfo.id or nil, {szCustomIco = global.headData:getSdefineHead()})

    global.achieveData:isFinishAchieve()
    local completeNum = global.achieveData:getCurCompleteNum()
    local totalNum = table.nums(luaCfg:achievement())
    self.ach_num:setString(completeNum .. "/" .. totalNum)

end

function UIPandectPanel:setData(data, isnotSet)
    self.tableView:stopScrolling() -- 停止继续向前惯性滑动
    self.tableView:setData(data, isnotSet)
end

function UIPandectPanel:onTabButtonChanged(index)
    self.defaultIndex = index
    self.tabControl:setSelectedIdx(index)
    self:setData(self.totalData[index])
end

-- 分类型读取表格内容
function UIPandectPanel:getPandectData(lType, configData)
    -- body
    local typeData = {}
    for _,v in pairs(configData) do
        if v.type == lType then
            table.insert(typeData, v)
        end
    end

    table.sort(typeData, function(s1, s2) return s1.kind > s2.kind end)
    local kindNum = typeData[1].kind

    local getKindData = function (kind)
        -- body
        local temp = {}
        for _,v in pairs(typeData) do
            if (v.kind == kind) and (v.open == 1) then -- 是否开启
                table.insert(temp, v)
            end
        end
        table.sort(temp, function(s1, s2) return s1.order < s2.order end)
        return temp
    end

    local data = {}
    for i=1,kindNum do
        table.insert(data, getKindData(i))    
    end 
    return data
    
end

function UIPandectPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPandectPanel")  
end

--CALLBACKS_FUNCS_END

return UIPandectPanel

--endregion
