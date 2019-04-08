--region UIPandectInfoItem.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPandectInfoItem  = class("UIPandectInfoItem", function() return gdisplay.newWidget() end )

function UIPandectInfoItem:ctor()
    self:CreateUI()
end

function UIPandectInfoItem:CreateUI()
    local root = resMgr:createWidget("common/pandect_info_node")
    self:initUI(root)
end

function UIPandectInfoItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_info_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.Node_2.title_export
    self.num = self.root.Node_2.num_export
    self.go = self.root.Node_2.go_export

    uiMgr:addWidgetTouchHandler(self.go, function(sender, eventType) self:goHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.go:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPandectInfoItem:setData(data)
    
    self.data = data
    local infoPanel = global.panelMgr:getPanel("UIPandectInfoPanel")
    local infoData = infoPanel:getInfoData()
    self.infoData = infoData
    self.go:setVisible(true)
    self.num:setVisible(true)

    if data.lFrom == 0 then -- 基础值
        self.title:setString(infoData.source0txt)
        self.num:setString(data.lValue)
        if infoData.source0target == "" then
            self.go:setVisible(false)
        end
    elseif data.lFrom == 999 then
        self.go:setVisible(false)
        self.num:setVisible(false)
        self.title:setString(luaCfg:get_local_string(10804))
    else
        local fromData = luaCfg:get_buff_source_by(data.lFrom)
        self.title:setString(fromData.name)
        local buffData = luaCfg:get_data_type_by(self.infoData.data_type)
        self.num:setString(data.lValue .. buffData.extra)
    end

   
end

function UIPandectInfoItem:goTarget(curBuildId ,panelName, isWorldOpen)

    -- 检测是否有当前建筑
    local checkCurBuild = function (buildId)
        if buildId ~= 0 and (not global.cityData:checkBuildLv(buildId, 1)) then 
            return false
        end
        return true
    end

    -- 种族建筑
    if self.data.lFrom == 11 then
        local isHave = false
        for _,v in pairs(curBuildId) do
            if checkCurBuild(v) then
                isHave = true
            end
        end
        if not isHave then
            local raceBuildingId = 16+1000*global.userData:getRace()
            local builds = luaCfg:get_buildings_pos_by(raceBuildingId)
            global.tipsMgr:showWarning("pandectBuild", builds.buildsName)
            return
        end
    else
        if not checkCurBuild(curBuildId) then
            local builds = luaCfg:get_buildings_pos_by(tonumber(curBuildId))
            global.tipsMgr:showWarning("pandectBuild", builds.buildsName)
            return
        end
    end 
   
    local data = clone(self.data)
    local infoData = clone(self.infoData)

    local lType = self.infoData.data_type
    isWorldOpen = isWorldOpen or (lType == 60 or lType == 63 or data.lFrom == 9)
    if global.scMgr:isWorldScene() and (not isWorldOpen) then
        global.g_worldview.mapPanel:cleanSchedule()
        global.scMgr:setMainSceneCall(function()    
            global.userData:setOpenFirst(false)         
            global.funcGame:pandectFunCall(data, infoData, panelName)
            global.userData:setOpenFirst(true)
        end)
        global.scMgr:gotoMainSceneWithAnimation()
    else
        global.funcGame:pandectFunCall(data, infoData, panelName)
    end
end

function UIPandectInfoItem:goHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPandectInfoPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        local closePanelInfo = function ()
            global.panelMgr:closePanel("UIPandectInfoPanel")
            global.panelMgr:closePanel("UIPandectPanel")
        end

        local isGoWorld = self.data.lFrom == 9 or self.data.lFrom == 13 or self.data.lFrom == 15 
        local cityId = global.userData:getWorldCityID()
        if cityId == 0 and global.scMgr:isMainScene() and isGoWorld then 
            -- return global.tipsMgr:showWarning("pleaseSetUpCity")
            closePanelInfo()
            global.scMgr:gotoWorldSceneWithAnimation()
            return 
        end

        local pandect = self.infoData
        if self.data.lFrom == 0 then
            if lType == 27 or lType == 3086 then
                self:goTarget(tonumber(pandect.source0target))
            else
                self:goTarget(0)
            end
        elseif self.data.lFrom == 1 then
            self:goTarget(pandect.source1target)
        elseif self.data.lFrom == 2 then

            -- 英雄驻防解锁条件判断
            local gdata = {}  
            for i,v in ipairs(luaCfg:garrison_effect()) do
                if v.building_id == pandect.source2target then
                    gdata = v
                end
            end
            local targetId = gdata.unlock_level_1
            if not targetId then return end
            local isUnlock = global.funcGame:checkTarget(targetId)
            if not isUnlock then
                local triggerData = luaCfg:get_target_condition_by(targetId)
                local builds = luaCfg:get_buildings_pos_by(triggerData.objectId)
                global.tipsMgr:showWarning("unlockCondition", builds.buildsName, triggerData.condition)
                return
            else         
                self:goTarget(0)
            end

        elseif self.data.lFrom == 3 then
            self:goTarget(17)
        elseif self.data.lFrom == 4 then
            self:goTarget(0, "UIvipPanel", true)
        elseif self.data.lFrom == 5 then
            self:goTarget(25, "UIDivinePanel")
        elseif self.data.lFrom == 6 then
        elseif self.data.lFrom == 7 then
            self:goTarget(0)
        elseif self.data.lFrom == 8 then

            if global.userData:checkJoinUnion() then --已有联盟信息界面
                global.panelMgr:openPanel("UIHadUnionPanel")
                global.panelMgr:openPanel("UIUBuildPanel")
            else --选择加入联盟列表
                global.panelMgr:openPanel("UIUnionPanel"):setData()
            end
        elseif self.data.lFrom == 9 then
            self:goTarget(0)
        elseif self.data.lFrom == 10 then
            global.panelMgr:openPanel("UISelectSkinPanel"):setPandectCall(handler(self, self.refershBuff))
        elseif self.data.lFrom == 11 then
            self:goTarget(pandect.source11target)
        elseif self.data.lFrom == 12 then
           local panel =  global.panelMgr:openPanel("UILordPanel")
            panel:setData()
            panel:setPandectCall(handler(self, self.refershBuff))
        elseif self.data.lFrom == 13 then
            self:goTarget(0, "UIOfficalPanel", true)
        elseif self.data.lFrom == 14 then

            closePanelInfo()
            if global.scMgr:isWorldScene() then
                global.g_worldview.mapPanel:cleanSchedule()
                global.scMgr:setMainSceneCall(function()    
                    global.userData:setOpenFirst(false)        
                    global.panelMgr:openPanel("UIPetInfoPanel"):setData(global.petData:getGodAnimalByFighting())
                    global.userData:setOpenFirst(true)
                end)
                global.scMgr:gotoMainSceneWithAnimation()
            else
                global.panelMgr:openPanel("UIPetInfoPanel"):setData(global.petData:getGodAnimalByFighting())
            end
        elseif self.data.lFrom == 15 then 

            closePanelInfo()
            if global.scMgr:isMainScene() then
                global.scMgr:gotoWorldSceneWithAnimation()        
            else
                global.funcGame:returnMainCity()
            end
        end 
    end

end

function UIPandectInfoItem:refershBuff()

    if not self.data then return end
    -- 城堡装扮buff
    if self.data.lFrom == 10 then
        local curSkinData = global.userCastleSkinData:getClickSkin() or {}
        curSkinData.buffnum = curSkinData.buffnum or 0
        local curBuffValue = 0
        if curSkinData.buffnum > 0 then 
            for i= 1, curSkinData.buffnum  do 
                local curBuffId = curSkinData["buff"..i][1]
                if curBuffId == self.infoData.data_type then
                    curBuffValue = curSkinData["buff"..i][2]
                    break
                end
            end
        end 
        if curBuffValue ~= self.data.lValue then
            gevent:call(global.gameEvent.EV_ON_SKINPANDECT_UPDATE) 
        end
    elseif self.data.lFrom == 12 then 

        gevent:call(global.gameEvent.EV_ON_SKINPANDECT_UPDATE) 

    end  
end

--CALLBACKS_FUNCS_END

return UIPandectInfoItem

--endregion
