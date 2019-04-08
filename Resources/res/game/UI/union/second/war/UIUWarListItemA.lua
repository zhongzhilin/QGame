--region UIUWarListItemA.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUWarListItemA  = class("UIUWarListItemA", function() return gdisplay.newWidget() end )
local worldConst = require("game.UI.world.utils.WorldConst")

function UIUWarListItemA:ctor()
    self:CreateUI()
end

function UIUWarListItemA:CreateUI()
    local root = resMgr:createWidget("union/union_battle_type1")
    self:initUI(root)
end

function UIUWarListItemA:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_type1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.type_bg = self.root.Node.type_bg_export
    self.atk_head = UIPortraitWidget.new()
    uiMgr:configNestClass(self.atk_head, self.root.Node.atk_head)
    self.def_head = UIPortraitWidget.new()
    uiMgr:configNestClass(self.def_head, self.root.Node.def_head)
    self.city = self.root.Node.city_export
    self.timing = self.root.Node.waring_mlan_5.timing_export
    self.atk_name = self.root.Node.atk_name_export
    self.atk_union = self.root.Node.atk_union_export
    self.def_name = self.root.Node.def_name_export
    self.def_union = self.root.Node.def_union_export
    self.go_target = self.root.Node.go_target_export
    self.Y = self.root.Node.Y_export
    self.X = self.root.Node.X_export
    self.type_top = self.root.type_top_export
    self.side = self.root.type_top_export.side_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:onGPSHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUWarListItemA:setData(data)

    self.data = data
    if not data then return end
    data.tgAtkUser = data.tgAtkUser or {}
    data.tgDefUser = data.tgDefUser or {}

    if table.nums(data.tgAtkUser) > 0 then
        local atkUser = data.tgAtkUser[1] 
        self.atk_head:setData(atkUser.lHeadID,atkUser.lBackID,atkUser)
        self.atk_name:setString(atkUser.szName)
        local unionName = ""
        if atkUser.szAllyName and atkUser.szAllyName == "" then
        else
            unionName = string.format("【%s】%s",(atkUser.szAllyFlag or ""), (atkUser.szAllyName or ""))
        end
        self.atk_union:setString(unionName)
        if atkUser.szAllyName == global.unionData:getInUnionName() then
            self.atk_name:setTextColor(cc.c3b(87, 213, 63))
        else
            self.atk_name:setTextColor(cc.c3b(180, 29, 11))
        end
    end

    if table.nums(data.tgDefUser) > 0 then
        local defUser = data.tgDefUser[1]
        self.def_head:setData(defUser.lHeadID,defUser.lBackID,defUser)
        self.def_name:setString(defUser.szName)
        local unionName = ""
        if defUser.szAllyName and defUser.szAllyName == "" then
        else
            unionName = string.format("【%s】%s",(defUser.szAllyFlag or ""), (defUser.szAllyName or ""))
        end
        self.def_union:setString(unionName)
        if defUser.szAllyName == global.unionData:getInUnionName() then
            self.def_name:setTextColor(cc.c3b(87, 213, 63))
        else
            self.def_name:setTextColor(cc.c3b(180, 29, 11))
        end
    end

    --城池信息
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.X:setString(pos.x)
    self.Y:setString(pos.y)
    -- 地点
    self.city:setString(global.unionData:getUnionWarTarget(data.lType, data.szCityName))

    local sideDatas = {
        {bar="union_battle_top_r.jpg",title=10153,bg="union_battle_bg_r.jpg"},
        {bar="union_battle_top_b.jpg",title=10340,bg="union_battle_bg_b.jpg"}
    }
    local sideData = sideDatas[data.lParty+1]
    self.side:setString(global.luaCfg:get_local_string(sideData.title))
    self.type_top:loadTexture(sideData.bar,ccui.TextureResType.plistType)
    self.type_bg:setSpriteFrame(sideData.bg)

    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()

end

function UIUWarListItemA:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

local zeroTimes = 0
function UIUWarListItemA:countDownHandler()
    local lRestTime = self.data.lArrived - global.dataMgr:getServerTime()
    if lRestTime < 0 then
        zeroTimes = zeroTimes+1
        lRestTime = 0
        if zeroTimes >= 5 then
            gevent:call(global.gameEvent.EV_ON_UNION_WAR_REFRESH,true)
            zeroTimes = 0
        end
    end
    self.timing:setString(global.funcGame.formatTimeToHMS(lRestTime))

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.timing:getParent(),self.timing)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUWarListItemA:onGPSHandler(sender, eventType)
    global.funcGame:gpsWorldCity(self.data.lMapID)
end
--CALLBACKS_FUNCS_END

return UIUWarListItemA

--endregion
