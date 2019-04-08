--region UIMiracleNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMiracleNode  = class("UIMiracleNode", function() return gdisplay.newWidget() end )

function UIMiracleNode:ctor()
    self:CreateUI()
end

function UIMiracleNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_miracle_node")
    self:initUI(root)
end

function UIMiracleNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_miracle_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.miracle_btn = self.root.Node_1.miracle_btn_export
    self.miracle_icon = self.root.Node_1.miracle_btn_export.miracle_icon_export
    self.perhour_union = self.root.Node_1.union_mlan_8.perhour_union_export
    self.perhour_self = self.root.Node_1.self_mlan_8.perhour_self_export
    self.miracle_name = self.root.Node_1.miracle_name_export
    self.posX = self.root.Node_1.posX_export
    self.posY = self.root.Node_1.posY_export
    self.go_target = self.root.Node_1.go_target_export

    uiMgr:addWidgetTouchHandler(self.miracle_btn, function(sender, eventType) self:gpsLocation(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
--EXPORT_NODE_END

    self.miracle_btn:setSwallowTouches(false)
    self.go_target:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN 
function UIMiracleNode:getRewardData(magicType)
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do
        if v.type == magicType then
            return v
        end
    end
end

function UIMiracleNode:setData(data)
    
    self.data = data
    local miracleData = global.luaCfg:get_world_miracle_by(data.lId) or global.luaCfg:get_wild_res_by(data.lId)

    local strTb = global.tools:strSplit(data.Params, '|') or {}
    local sname = global.luaCfg:get_all_miracle_name_by(tonumber(strTb[1]))
    if sname then
        self.miracle_name:setString(sname.name)
    else
        self.miracle_name:setString(miracleData.name)
    end

    local getIcon = function (lType) 
        for _ ,v in pairs(global.luaCfg:world_surface()) do
            if lType == v.type then 
                return v.worldmap
            end 
        end 
    end 
    global.panelMgr:setTextureFor(self.miracle_icon, getIcon(miracleData.type))

    strTb[2] = strTb[2] or "0"
    strTb[3] = strTb[3] or "0"
    local upPro = 100
    for k,v in pairs(luaCfg:miracle_upgrade()) do
        if v.type == tonumber(strTb[3]) and v.lv == tonumber(strTb[2]) then
            upPro = v.upPro
        end
    end

    local miracleReward = self:getRewardData(miracleData.type)
    self.perhour_union:setString(miracleReward.league1[2]*upPro/100)
    self.perhour_self:setString(miracleReward.league2[2]*upPro/100)

    global.tools:adjustNodePosForFather(self.perhour_union:getParent(),self.perhour_union)
    global.tools:adjustNodePosForFather(self.perhour_self:getParent(),self.perhour_self)


    data.lPosX = data.lPosX or 0
    data.lPosY = data.lPosY or 0
    local worldConst = require("game.UI.world.utils.WorldConst")
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(pos.x)
    self.posY:setString(pos.y)

end

function UIMiracleNode:gpsLocation(sender, eventType)
end

function UIMiracleNode:gpsHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPandectPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        local id = tonumber(self.data.Params)
        if not id then
            id = tonumber(self.data.Params:split('|')[1])
        end

        if self.data.lType == 3 then
            global.guideMgr:setStepArg({id=id, isWild=1})
        else
            global.guideMgr:setStepArg({id=id, isWild=0})
        end
        gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_PANDECT) 
    end

end
--CALLBACKS_FUNCS_END

return UIMiracleNode

--endregion
