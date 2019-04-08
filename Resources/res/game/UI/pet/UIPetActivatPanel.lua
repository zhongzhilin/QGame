--region UIPetActivatPanel.lua
--Author : yyt
--Date   : 2017/12/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetActivatPanel  = class("UIPetActivatPanel", function() return gdisplay.newWidget() end )

function UIPetActivatPanel:ctor()
    self:CreateUI()
end

function UIPetActivatPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_activation")
    self:initUI(root)
end

function UIPetActivatPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_activation")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt = self.root.Node_export.txt_mlan_10_export
    self.txt2 = self.root.Node_export.txt2_mlan_10_export
    self.name = self.root.Node_export.name_export
    self.firstConsume = self.root.Node_export.firstConsume_mlan_10_export
    self.diamond = self.root.Node_export.diamond_export
    self.diamond_num = self.root.Node_export.diamond_export.diamond_num_export
    self.introduce = self.root.Node_export.introduce_export
    self.introduce1 = self.root.Node_export.introduce1_export
    self.txt3 = self.root.Node_export.txt3_mlan_10_export
    self.petType = self.root.Node_export.petType_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:closeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.activBtn, function(sender, eventType) self:activateHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.cancelBtn, function(sender, eventType) self:closeHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetActivatPanel:setData(data, callBack)

    if not data then return end
    self.callBack = callBack
    self.data = data
    self.name:setString(data.name)
    
    self.firstConsume:setVisible(true)
    self.diamond:setVisible(false)
    local actPet = luaCfg:get_pet_activation_by(1)
    
    self.introduce:setVisible(false)
    self.introduce1:setVisible(false)
    if global.petData:getPetActNum() > 0 then
        self.firstConsume:setVisible(false)
        self.diamond:setVisible(true)
        self.diamond_num:setString(actPet["demand"..global.petData:getPetActNum()])
        self:checkDiamondEnough(actPet["demand"..global.petData:getPetActNum()])
        self.introduce:setVisible(true)
        uiMgr:setRichText(self, "introduce", 50237, {})
    else
        self.introduce1:setVisible(true)
        uiMgr:setRichText(self, "introduce1", 50248, {time=actPet.sealTime/3600})
    end

    local pet = luaCfg:get_pet_type_by(data.id)
    self.petType:setString(pet.typeName)

    -- global.tools:adjustNodePos(self.txt, self.name)
    -- global.tools:adjustNodePos(self.txt2, self.firstConsume)
    -- global.tools:adjustNodePos(self.txt2, self.diamond)

end

function UIPetActivatPanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamond_num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.diamond_num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UIPetActivatPanel:closeHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIPetActivatPanel")
end

function UIPetActivatPanel:activateHandler(sender, eventType)

    if not self:checkDiamondEnough(tonumber(self.diamond_num:getString())) and global.petData:getPetActNum() > 0 then
        global.panelMgr:openPanel("UIRechargePanel"):setCallBack(function ()
            self:checkDiamondEnough(tonumber(self.diamond_num:getString()))
        end)
        return 
    end

    gevent:call(gsound.EV_ON_PLAYSOUND,"pet_seal")
    global.petApi:actionPet(function (msg)
        -- body
        if not msg then return end
        global.petData:resetGodAnimalState()
        if global.petData:getPetActNum() > 0 then
            global.petData:updateGodAnimal(msg.tagGodAnimal or {})
            gevent:call(global.gameEvent.EV_ON_PET_REFERSH)
            self:closeHandler()
            if self.callBack then
                self.callBack()
            end
        else -- 解除封印
            global.petData:updateGodAnimal(msg.tagGodAnimal or {})
            self:closeHandler()
            global.panelMgr:closePanel("UIPetPanel")
            gevent:call(global.gameEvent.EV_ON_PET_UNLOCK)
        end

    end, 1, self.data.id)
end


--CALLBACKS_FUNCS_END

return UIPetActivatPanel

--endregion
