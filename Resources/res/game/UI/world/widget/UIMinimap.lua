--region UIMinimap.lua
--Author : Administrator
--Date   : 2016/10/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END

local UIMinimap  = class("UIMinimap", function() return gdisplay.newWidget() end )

local MINI_SCALE = 0.075

function UIMinimap:ctor()
    
end

function UIMinimap:CreateUI()
    local root = resMgr:createWidget("world/map_mini")
    self:initUI(root)
end

function UIMinimap:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/map_mini")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.drawNode = self.root.drawNode_export
    self.clippingNodeParent = self.root.clippingNodeParent_export
    self.eyes = self.root.Button_2.eyes_export
    self.btn_rmb = self.root.btn_rmb_export
    self.rmb_num = self.root.btn_rmb_export.rmb_num_export
    self.landname = self.root.ui_surface_icon_mini_d_1.landname_export
    self.FileNode_1 = UISetTIme.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.root.Button_2, function(sender, eventType) self:search_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_3, function(sender, eventType) self:collect_click(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.btn_rmb, function(sender, eventType) self:onRmbClickHandler(sender, eventType) end)
    
	self.parentNode = cc.Node:create()

	self.clipNode = cc.ClippingNode:create();
    self.clipNode:setInverted(false)
    self.clipNode:setAlphaThreshold(0.1)
    self.clipNode:addChild(self.parentNode)
    self.clippingNodeParent:addChild(self.clipNode)

    local sprite = cc.Sprite:create()
    sprite:setScale(0.98)
    sprite:setSpriteFrame("ui_surface_icon/mini_di.png")
    self.clipNode:setStencil(sprite)

    local nodeTimeLine = resMgr:createTimeline("world/map_mini")
    nodeTimeLine:play("animation0", true)
    nodeTimeLine:setTimeSpeed(0.5)
    self.root:runAction(nodeTimeLine)

    local draw = cc.DrawNode:create()
    draw:setAnchorPoint(cc.p(0,0))
    draw:setPosition(cc.p(0,0))
    self.drawNode:addChild(draw)
    -- self.mapPanel:addChild(draw,998)

    self.rmb_num:setString(propData:getProp(WCONST.ITEM.TID.DIAMOND))

    local line =  {{x = 0,y = 0},
        {x = gdisplay.width * MINI_SCALE,y = 0},
        {x = gdisplay.width * MINI_SCALE,y = gdisplay.height * MINI_SCALE},
        {x = 0,y = gdisplay.height * MINI_SCALE},}

    for _,v in ipairs(line) do

        v.x = v.x - gdisplay.width * MINI_SCALE / 2
        v.y = v.y - gdisplay.height * MINI_SCALE / 2
    end

    draw:drawPolygon(line,#line,{r = 1,g = 1,b = 1, a = 0},1,{r = 0,g = 0,b = 0, a = 1})
    -- draw:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()
        if not tolua.isnull(self.rmb_num) then
            self.rmb_num:setString(propData:getProp(WCONST.ITEM.TID.DIAMOND))    
        end
    end)

    self.FileNode_1:setMode(1)
    self.FileNode_1:checkTime()
end

function UIMinimap:setPos(pos)
	-- body
	self.parentNode:setPosition(cc.p(-pos.x * MINI_SCALE,-pos.y * MINI_SCALE))
end

function UIMinimap:getSpriteFrameByType(pontType)

    local surface = luaCfg:world_surface()    

    for _,i in pairs(surface) do

        if i.type == pontType then

            return i
        end
    end
end

function UIMinimap:setName(name)
    
    self.landname:setString(name)
end

function UIMinimap:getMinimapScale()
	
	return MINI_SCALE
end

function UIMinimap:getParentNode()
	
	return self.parentNode
end

function UIMinimap:onExit()
    
    local children = self.parentNode:getChildren()
    for _,v in ipairs(children) do
        v:release()
        -- v:autorelease()
    end
end

function UIMinimap:getMapColorByAvatar( avatarType ,isEmpty )


    --0 中立 1 自己 2 同盟 3 联盟 4 敌对
    if avatarType == 0 then --中立

            return cc.c3b(255,243,45)       
    elseif avatarType == 1 then --

        return cc.c3b(4,194,255)
    elseif avatarType == 2 then --

        return cc.c3b(20,198,10)
    elseif avatarType == 3 then --

        return cc.c3b(20,198,10)
    elseif avatarType == 4 then --

        return cc.c3b(192,10,10)
    else
        


        if isEmpty then
            return cc.c3b(255,243,255)
        else
            return cc.c3b(255,243,45)
        end  
        -- return cc.c3b(255,255,255)
    end
end

function UIMinimap:onRmbClickHandler(sender, eventType)
    --钻石点击
    global.panelMgr:openPanel("UIRechargePanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMinimap:search_click(sender, eventType)
    
    -- local panel = global.panelMgr:openPanel("UISearchPanel")
    -- panel:setData()
    local eyes_open = global.g_worldview.worldPanel:hideUI_careWar()
    self.eyes:setSpriteFrame(eyes_open and 'ui_surface_icon/pinbi_02.png' or 'ui_surface_icon/pinbi_01.png')
end

function UIMinimap:collect_click(sender, eventType)
    
    local panel = global.panelMgr:openPanel("UICollectListPanel")
    panel:setData(1, -1)
end

function UIMinimap:onStateHandler(sender, eventType)

    local truePos = global.g_worldview.mapPanel:getTruePos()
    if global.g_worldview.worldPanel.mainCityPos ~= nil and truePos ~= nil then

        local panel = global.panelMgr:openPanel("UINewWorldMap")
        panel:setCurrentPos(truePos)
    end    
end
--CALLBACKS_FUNCS_END

return UIMinimap

--endregion
