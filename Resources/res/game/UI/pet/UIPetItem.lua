--region UIPetItem.lua
--Author : yyt
--Date   : 2017/12/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetItem  = class("UIPetItem", function() return gdisplay.newWidget() end )

function UIPetItem:ctor()
    self:CreateUI()
end

function UIPetItem:CreateUI()
    local root = resMgr:createWidget("pet/pet_first_node")
    self:initUI(root)
end

function UIPetItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_first_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Button_5.Node_export
    self.selectBg = self.root.Button_5.Node_export.selectBg_export
    self.icon = self.root.Button_5.Node_export.icon_export
    self.stateBg = self.root.Button_5.Node_export.stateBg_export
    self.stateText = self.root.Button_5.Node_export.stateBg_export.stateText_export
    self.typeIcon = self.root.Button_5.Node_export.typeIcon_export
    self.name = self.root.Button_5.Node_export.name_export

    uiMgr:addWidgetTouchHandler(self.root.Button_5, function(sender, eventType) self:clickHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.root.Button_5:setSwallowTouches(false)
    self.root.Button_5:setZoomScale(0)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- 0.休息中 1.出战中 
function UIPetItem:setData(data)

    self.data = data
    self.selectBg:setVisible(data.isSelected == 1)
    self.name:setString(data.name)

    self.stateBg:setSpriteFrame("pet_9.png")
    self.stateText:setTextColor(cc.c3b(255, 255, 255))
    global.colorUtils.turnGray(self.stateBg, true)
    local stateStrId = 10938
    if data.serverData then

        global.colorUtils.turnGray(self.stateBg, false)
        self.stateText:setTextColor(cc.c3b(141, 211, 255))
        stateStrId = 10940
        if data.serverData.lState == 1 then -- 出战中
            self.stateBg:setSpriteFrame("ui_surface_icon/greed_tap.png")
            self.stateText:setTextColor(cc.c3b(188, 245, 133))
            stateStrId = 10939
        end
    end
    self.stateText:setString(luaCfg:get_local_string(stateStrId))  
    self.typeIcon:setSpriteFrame(data.typeIcon)
    self.icon:setSpriteFrame(data.icon)
    
end

function UIPetItem:clickHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIPetPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        if sPanel.isPageMove then 
            return
        end

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_mailbox")
        
        local curSelect = sPanel:getCurSelectPet().type
        if curSelect == self.data.type then
            return
        end
        sPanel:showPage(self.data.type)
    end
end
--CALLBACKS_FUNCS_END

return UIPetItem

--endregion
