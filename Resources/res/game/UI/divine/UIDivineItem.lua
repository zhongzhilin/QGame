--region UIDivineItem.lua
--Author : yyt
--Date   : 2017/03/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDivineItem  = class("UIDivineItem", function() return gdisplay.newWidget() end )

function UIDivineItem:ctor()
end

function UIDivineItem:CreateUI()
    local root = resMgr:createWidget("citybuff/divine_card_node")
    self:initUI(root)
end

function UIDivineItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "citybuff/divine_card_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.card_back = self.root.Button_11.card_back_export
    self.card_front = self.root.Button_11.card_front_export
    self.quality = self.root.Button_11.card_front_export.icon_node.quality_export
    self.icon = self.root.Button_11.card_front_export.icon_node.icon_export
    self.frame = self.root.Button_11.card_front_export.icon_node.frame_export
    self.buff = self.root.Button_11.card_front_export.buff_export

    uiMgr:addWidgetTouchHandler(self.root.Button_11, function(sender, eventType) self:cardHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self:setCascadeOpacityEnabled(true)
    self.Button_11 = self.root.Button_11
    self.Button_11:setSwallowTouches(false)
end

function UIDivineItem:isMine(id)
    if not id then return false end
    return self.data.ID == id
end

function UIDivineItem:onEnter()
    
    self.nodeTimeLine = resMgr:createTimeline("citybuff/divine_card_node")
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)
end

-- 背面倒序翻转
function UIDivineItem:setCardSideFix()
    
    self.Button_11.effect:setVisible(false)
    self.nodeTimeLine:play("animation3", false)
end

function UIDivineItem:setCardSide(isShow,isAnimation, isReset, call)
    
    self.Button_11.effect:setVisible(true)
    local nodeTimeLine = self.nodeTimeLine
    if not nodeTimeLine then return end
    if isShow then
        -- 卡牌重置
        if isReset then
            nodeTimeLine:gotoFrameAndPause(13)
        else
            --正面朝上
            if isAnimation then
                nodeTimeLine:play("animation0", false)
                nodeTimeLine:setLastFrameCallFunc(function()
                    nodeTimeLine:play("animation1", true)
                end)
            else
                nodeTimeLine:play("animation1", true)
            end
        end
    else
        --反面朝上
        if isReset then 
            nodeTimeLine:play("animation2", true)
            nodeTimeLine:setLastFrameCallFunc(function()
                if call then call() end
            end)
        else 
            nodeTimeLine:gotoFrameAndPause(26)
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
local frameBg = {
    [1] = "icon/divine/divination_1.png",
    [3] = "icon/divine/divination_2.png",
    [5] = "icon/divine/divination_3.png",
}

function UIDivineItem:setData( data, isInfo )
    
    if not data then return end
    self.data = data
    self.localId = self.data.localId
    local divineData = luaCfg:get_divine_by(self.data.ID)
    self.buff:setString(divineData.name)
    -- self.icon:setSpriteFrame(divineData.icon)
    global.panelMgr:setTextureFor(self.icon,divineData.icon)
    -- self.quality:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",divineData.quality))
    global.panelMgr:setTextureFor(self.quality,string.format("icon/item/item_bg_0%d.png",divineData.quality))
    --= self.Button_11:setTouchEnabled(isInfo == nil)
    -- self.frame:setSpriteFrame(frameBg[divineData.quality])
    global.panelMgr:setTextureFor(self.frame,frameBg[divineData.quality])
end

function UIDivineItem:cardHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIDivinePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        local divPanel = global.panelMgr:getPanel("UIDivinePanel")
        local lState = divPanel:getDivState()
        
        if lState then 

            if  lState == 0 then
                
                global.panelMgr:openPanel("UIDivineInfoPanel"):setData(self.data)
                return
            elseif lState > 10000 then

                self.data = self.data or {} 

                if self.data.ID == (lState - 10000) then
                    global.panelMgr:openPanel("UIDivineInfoPanel"):setData(self.data, true)
                else
                    if global.refershData:getDivingState() == -2 then
                        divPanel:setOtherCardFix(lState - 10000)
                        global.refershData:setDivingState(-1)
                    else
                        global.panelMgr:openPanel("UIDivineInfoPanel"):setData(self.data)
                    end
                end
                return
            end
        end 

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_DivineItme")
        global.techApi:divineList(3, function (msg)

            
            msg = msg or {}
            self:setData(msg.tgDivine[1], true)
            self:setCardSide(true,true)

            -- 刷新panel
            divPanel:setData(msg)

            -- 重置正在占卜翻转状态
            global.refershData:setDivingState(-2)

        end, self.localId)

    end

end

--CALLBACKS_FUNCS_END

return UIDivineItem

--endregion
