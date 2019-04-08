--region UIPetGetPanel.lua
--Author : yyt
--Date   : 2017/12/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetGetPanel  = class("UIPetGetPanel", function() return gdisplay.newWidget() end )

function UIPetGetPanel:ctor()
    self:CreateUI()
end

function UIPetGetPanel:CreateUI()
    local root = resMgr:createWidget("pet/get_pet")
    self:initUI(root)
end

function UIPetGetPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/get_pet")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.parent = self.root.Node_export.parent_export
    self.pet_pick = self.root.Node_export.parent_export.pet.pet_pick_export
    self.petName = self.root.Node_export.parent_export.pet.petName_export
    self.petNode = self.root.Node_export.parent_export.petNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.parent_export.Button_1, function(sender, eventType) self:cofirmHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIPetGetPanel:setData(data, callBack)
    -- body
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"pte_new")
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("pet/get_pet")
    nodeTimeLine:play("animation0", false)
    self.root:runAction(nodeTimeLine)

    self.callBack = callBack
    local petConfig = global.petData:getPetConfig(data.type, data.serverData.lGrade)
    if petConfig then
        self.petConfig = petConfig
        self.parent:removeChildByTag(0101065)
        local node = resMgr:createCsbAction(petConfig.Animation, "animation0" , true)
        node:setPosition(self.petNode:getPosition())
        node:setTag(0101065)
        self.parent:addChild(node)
        self.petName:setString(petConfig.name)
    end 
end

function UIPetGetPanel:exit(sender, eventType)
    if self.callBack then
        self.callBack(self.petConfig.type)
    end
    global.panelMgr:closePanel("UIPetGetPanel")
end

function UIPetGetPanel:cofirmHandler(sender, eventType)
    if self.callBack then
        self.callBack(self.petConfig.type)
    end
    global.panelMgr:closePanel("UIPetGetPanel")
end
--CALLBACKS_FUNCS_END

return UIPetGetPanel

--endregion
