--region UIUWarListItemH.lua
--Author : wuwx
--Date   : 2017/02/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarListItemH  = class("UIUWarListItemH", function() return gdisplay.newWidget() end )
local worldConst = require("game.UI.world.utils.WorldConst")

function UIUWarListItemH:ctor()
    self:CreateUI()
end

function UIUWarListItemH:CreateUI()
    local root = resMgr:createWidget("union/union_battle_type3")
    self:initUI(root)
end

function UIUWarListItemH:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_type3")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.type_top = self.root.type_top_export
    self.title = self.root.type_top_export.title_export
    self.type_bg = self.root.Node.type_bg_export
    self.timing = self.root.Node.waring_mlan_6.timing_export
    self.atk_union = self.root.atk_union_export
    self.atk_scale = self.root.atk_scale_export
    self.def_union = self.root.def_union_export
    self.def_scale = self.root.def_scale_export
    self.icon = self.root.icon_export
    self.go_target = self.root.go_target_export
    self.Y = self.root.Y_export
    self.X = self.root.X_export
    self.city_name = self.root.city_name_export
    self.atk_people = self.root.Image_8.atk_people_export
    self.atk_icon = self.root.atk_icon_export
    self.side_icon2 = self.root.side_icon2_export
    self.def_people = self.root.Image_8_0.def_people_export
    self.def_parter_node = self.root.def_parter_node_export
    self.def_btn = self.root.def_parter_node_export.def_btn_export
    self.atk_parter_node = self.root.atk_parter_node_export
    self.atk_btn = self.root.atk_parter_node_export.atk_btn_export
    self.atk_help_btn = self.root.atk_help_btn_export
    self.atk_help = self.root.atk_help_btn_export.atk_help_export
    self.def_help_btn = self.root.def_help_btn_export
    self.def_help = self.root.def_help_btn_export.def_help_mlan_5_export
    self.skin_effect_node = self.root.skin_effect_node_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:onGPSHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.atk_help_btn, function(sender, eventType) self:onAttackHelp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.def_help_btn, function(sender, eventType) self:onDefendHelp(sender, eventType) end)
--EXPORT_NODE_END
    
    local UITableView = require("game.UI.common.UITableView")
    local UIUWarPortraitCell = require("game.UI.union.second.war.UIUWarPortraitCell")
    self.tableView_atk = UITableView.new()
        :setSize(self.atk_parter_node.contentLayout:getContentSize())
        :setCellSize(self.atk_parter_node.itemLayout:getContentSize())
        :setCellTemplate(UIUWarPortraitCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.atk_parter_node.node_tableView:addChild(self.tableView_atk)

    self.tableView_def = UITableView.new()
        :setSize(self.def_parter_node.contentLayout:getContentSize())
        :setCellSize(self.def_parter_node.itemLayout:getContentSize())
        :setCellTemplate(UIUWarPortraitCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)
    self.def_parter_node.node_tableView:addChild(self.tableView_def)
end

function UIUWarListItemH:scrollViewDidScroll(tableView, idx)
    if tableView.scrollAction then
        tableView:getParent():stopAction(tableView.scrollAction)
        tableView.scrollAction = nil
    end
    global.panelMgr:getPanel("UIUWarListPanel"):setScroll(false)
    tableView.scrollAction = tableView:getParent():runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function() 
        global.panelMgr:getPanel("UIUWarListPanel"):setScroll(true)
        tableView.scrollAction = nil
    end)))
end

function UIUWarListItemH:setData(data)
    self.data = data

    --保证横向滑动时纵向不动
    self.tableView_atk:setDidScrollCall(nil)
    self.tableView_def:setDidScrollCall(nil)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function() 
        --延迟一帧，防止刚创建的时候调用
        self.tableView_atk:setDidScrollCall(handler(self,self.scrollViewDidScroll))
        self.tableView_def:setDidScrollCall(handler(self,self.scrollViewDidScroll))
    end)))
    --添加到禁止滚动列表
    global.panelMgr:getPanel("UIUWarListPanel"):addTableViewList(self.data.lMapID,{self.tableView_atk,self.tableView_def})

    --攻击方
    self.tableView_atk:setData(data.tgAtkUser)
    self.atk_people:setString(#data.tgAtkUser)
    local atkUser = {}
    for _,v in ipairs(data.tgAtkUser) do
        if v.lUserID == data.lAtkLeader then
            atkUser = v
            break
        end
    end
    -- self.atk_scale:setString(global.luaCfg:get_local_string(10341)..":"..(data.lAtkPower or 0))
    self.atk_scale:setVisible(false)
    local unionName = ""
    if atkUser.szAllyName and atkUser.szAllyName == "" then
        unionName = atkUser.szName
    else
        unionName = string.format("【%s】%s",(atkUser.szAllyFlag or ""), (atkUser.szName or ""))
    end
    self.atk_union:setString(unionName)
    if atkUser.szAllyName == global.unionData:getInUnionName() then
        self.atk_union:setTextColor(cc.c3b(87, 213, 63))
    else
        self.atk_union:setTextColor(cc.c3b(180, 29, 11))
    end

    --防守方
    data.tgDefUser = data.tgDefUser or {}
    self.tableView_def:setData(data.tgDefUser)
    self.def_people:setString(#data.tgDefUser)
    local defUser = {}
    for _,v in ipairs(data.tgDefUser) do
        if v.lUserID == data.lDefLeader then
            defUser = v
            break
        end
    end
    -- self.def_scale:setString(global.luaCfg:get_local_string(10341)..":"..(data.lDefPower or 0))
    self.def_scale:setVisible(false)
    local unionName = ""
    if defUser.szAllyName and defUser.szAllyName == "" then
        unionName = defUser.szName
    else
        unionName = string.format("【%s】%s",(defUser.szAllyFlag or ""), (defUser.szName or ""))
    end
    self.def_union:setString(unionName)
    if defUser.szAllyName == global.unionData:getInUnionName() then
        self.def_union:setTextColor(cc.c3b(87, 213, 63))
    else
        self.def_union:setTextColor(cc.c3b(180, 29, 11))
    end

    --双方ui信息
    local sideDatas = {
        {bar="union_battle_top_r.jpg",title=10153,bg="union_battle_bg_r.jpg"},
        {bar="union_battle_top_b.jpg",title=10340,bg="union_battle_bg_b.jpg"}
    }
    local sideData = sideDatas[data.lParty+1]
    self.title:setString(global.luaCfg:get_local_string(sideData.title))
    self.type_top:loadTexture(sideData.bar,ccui.TextureResType.plistType)
    self.type_bg:loadTexture(sideData.bg,ccui.TextureResType.plistType)
    self.atk_help_btn:setVisible(data.lParty==0)
    self.def_help_btn:setVisible(data.lParty==1)

    local attackTypes = {[1]=10125,[2]=10124,[6]=10126}
    local attackStr = ""
    if data.lSupportType and attackTypes[data.lSupportType] then
        attackStr = global.luaCfg:get_local_string(attackTypes[data.lSupportType])..global.luaCfg:get_local_string(10345)
    end
    self.atk_help:setString(attackStr)

    --城池信息
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.X:setString(pos.x)
    self.Y:setString(pos.y)
    -- 地点
    self.city_name:setString(global.unionData:getUnionWarTarget(data.lType, data.szCityName))

    local setSkin = function(skinId) 
        local city_image = global.luaCfg:get_world_city_image_by(skinId)
        if city_image  then 
            if city_image.worldeffect ~= "" then 
                self.skin_effect_node:setVisible(true)
                self.skin_effect_node:removeAllChildren()
                local effect = resMgr:createCsbAction(city_image.worldeffect,"animation0",true)
                self.skin_effect_node:addChild(effect)
            else 
                print("设置了皮肤啊")
                self.icon:setVisible(true)
                global.panelMgr:setTextureFor(self.icon, city_image.worldmap)
            end 
        end 
    end 
    
    self.icon:setScale(0.5)
    self.icon:setVisible(false)
    self.skin_effect_node:setVisible(false)
    if self.data.lCityAvatar and self.data.lCityAvatar ~=0  then 
       setSkin(self.data.lCityAvatar)
    else 

        if self.data.lKing and self.data.lCityLv and data.lType == 1 then 
            local skinId =  global.userData:getSkinId(self.data.lCityLv , self.data.lKing) 
            print(skinId ,"skinId//////////////")
            setSkin(skinId)
        else 
            self.icon:setVisible(true)
            global.panelMgr:setTextureFor(self.icon,"icon/mapunit/c_1102.png")

            local getSurfaceData = function (lType)
                -- body
                for k,v in pairs(global.luaCfg:world_surface()) do
                    if v.type == lType then
                        return v
                    end
                end
                return nil
            end

            local sData = global.luaCfg:get_world_type_by(tonumber(data.szCityName))
            if sData and getSurfaceData(sData.type) then
                self.icon:setScale(getSurfaceData(sData.type).unionSize or 1)
                global.panelMgr:setTextureFor(self.icon, getSurfaceData(sData.type).worldmap)
            else
                sData = global.luaCfg:get_all_miracle_name_by(tonumber(data.szCityName))
                if sData and getSurfaceData(sData.type) then
                    self.icon:setScale(getSurfaceData(sData.type).unionSize or 1)
                    global.panelMgr:setTextureFor(self.icon, getSurfaceData(sData.type).worldmap)
                end       
            end

        end 
    end 

    --倒计时
    if self.m_countDownTimer then
    else
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIUWarListItemH:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

local zeroTimes = 0
function UIUWarListItemH:countDownHandler()
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


function UIUWarListItemH:onGPSHandler(sender, eventType)
    global.funcGame:gpsWorldCity(self.data.lMapID)
end

function UIUWarListItemH:onAttackHelp(sender, eventType)
    if global.userData:getWorldCityID() == 0 then
        return global.tipsMgr:showWarning("NoCityNoHelp")
    end
    global.worldApi:checkMainCityProtect(function(isProtected)
        if isProtected then
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("ProtectMarch", self:callDeProtectCall(function()
                -- body
                global.troopData:setTargetData(self.data.lSupportType,0,self.data.lMapID,self.data.szCityName)
                global.panelMgr:openPanel("UITroopPanel")
            end))
        else
            global.troopData:setTargetData(self.data.lSupportType,0,self.data.lMapID,self.data.szCityName)
            global.panelMgr:openPanel("UITroopPanel")
        end
    end)
end

function UIUWarListItemH:onDefendHelp(sender, eventType)
    if global.userData:getWorldCityID() == 0 then
        return global.tipsMgr:showWarning("NoCityNoHelp")
    end
    global.worldApi:checkMainCityProtect(function(isProtected)
        if isProtected then
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("ProtectMarch", self:callDeProtectCall(function()
                -- body
                global.troopData:setTargetData(self:getSupportType(self.data.lSupportType), 0,self.data.lMapID,self.data.szCityName)
                global.panelMgr:openPanel("UITroopPanel")
            end))
        else
            self.data = self.data or {} 
            if self.getSupportType then
                global.troopData:setTargetData(self:getSupportType(self.data.lSupportType), 0,self.data.lMapID,self.data.szCityName)
            end
            global.panelMgr:openPanel("UITroopPanel")
        end
    end)
end

-- 防守方的同盟，lSupportType：4（防守增援）
function UIUWarListItemH:getSupportType(lSupportType)

    local supportType = lSupportType
    if self.data.lParty == 1 and self.data.lDefLeader ~= global.userData:getUserId() then -- 防守方
        supportType = 4
    end
    supportType = supportType == 0 and 4 or supportType
    return supportType
end
--CALLBACKS_FUNCS_END

function UIUWarListItemH:callDeProtectCall(cb)
    
    return function()
       
        global.worldApi:removeProtection(function(msg)
                    
            cb()
        end)
    end
end

return UIUWarListItemH

--endregion
