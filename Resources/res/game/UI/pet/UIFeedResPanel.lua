--region UIFeedResPanel.lua
--Author : yyt
--Date   : 2017/12/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIFeedResPanel  = class("UIFeedResPanel", function() return gdisplay.newWidget() end )

function UIFeedResPanel:ctor()
    self:CreateUI()
end

function UIFeedResPanel:CreateUI()
    local root = resMgr:createWidget("pet/pet_donate_item")
    self:initUI(root)
end

function UIFeedResPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_donate_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.bg.title.name_mlan_15_export
    self.slider = self.root.Node_export.bg.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.bg.slider_export.cur)
    self.quit = self.root.Node_export.bg.quit_export
    self.icon = self.root.Node_export.bg.icon_export
    self.donateBtn = self.root.Node_export.bg.donateBtn_export
    self.grayBg = self.root.Node_export.bg.donateBtn_export.grayBg_export
    self.type3 = self.root.Node_export.type3_mlan_10_export
    self.consumeNum = self.root.Node_export.type3_mlan_10_export.consumeNum_export
    self.type1 = self.root.Node_export.type1_mlan_10_export
    self.friendNum = self.root.Node_export.type1_mlan_10_export.friendNum_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.donateBtn, function(sender, eventType) self:feedHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.bg.buy, function(sender, eventType) self:buyHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    local CountSliderControl = require("game.UI.common.UICountSliderControl")
    self.sliderControl = CountSliderControl.new(self.slider,function(count)
        -- body
        if not self.resEnough then
            count = self.data.resources
        end
        self:initConsume(count)
    end, nil, nil, true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

local iconPic = {
    [1] = "icon/item/item_icon_002.png",
    [2] = "icon/item/item_icon_004.png",
    [3] = "icon/item/item_icon_001.png",
    [4] = "icon/item/item_icon_003.png",
}

function UIFeedResPanel:setData(data)

    self.data = data
    local itemData = luaCfg:get_item_by(data.id)
    global.panelMgr:setTextureFor(self.icon, iconPic[data.id])
    global.panelMgr:setTextureFor(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality))

    local curHave = global.propData:getProp(data.id)
    self.minSaveNum = self.data.resources
    self.maxSaveNum = curHave
    self.maxSaveNum = self.maxSaveNum <= self.minSaveNum and self.minSaveNum or self.maxSaveNum
    self.sliderControl:setMaxCount(self.maxSaveNum)
    self.sliderControl:setMinCount(self.minSaveNum)
    self.sliderControl:changeCount(self.minSaveNum) 

    self.resEnough = true
    self.sliderControl.inputText:setEnabled(true)
    global.colorUtils.turnGray(self.grayBg, false)
    if curHave <= self.minSaveNum then
        global.colorUtils.turnGray(self.grayBg, true)
        self.resEnough = false
        self.sliderControl:setMaxCount(curHave)
        self.sliderControl:setMinCount(curHave)
        self.sliderControl:changeCount(curHave) 
        self.sliderControl.inputText:setEnabled(false)
    end
    
end

function UIFeedResPanel:initConsume(count)
    self.consumeNum:setString(count)
    self.friendNum:setString(count/self.data.resources*self.data.friendly)
    global.tools:adjustNodePosForFather(self.type3 , self.consumeNum)
    global.tools:adjustNodePosForFather(self.type1, self.friendNum)
end

function UIFeedResPanel:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIFeedResPanel")
end

local errorcodeIds = 
{
    [WCONST.ITEM.TID.FOOD]      = "ItemUseFood",
    [WCONST.ITEM.TID.GOLD]      = "ItemUseCoin",
    [WCONST.ITEM.TID.WOOD]      = "ItemUseWood",
    [WCONST.ITEM.TID.STONE]     = "ItemUseStone",
}

function UIFeedResPanel:feedHandler(sender, eventType)
    
    if not self.resEnough then
        return global.tipsMgr:showWarning(errorcodeIds[self.data.id])
    end

    local petData = global.petFriPanel.data
    global.petApi:actionPet(function (msg)
        -- body
        if not msg then return end
        global.petData:updateGodAnimal(msg.tagGodAnimal or {})
        gevent:call(global.gameEvent.EV_ON_PET_REFERSH)
        self:exit()
        gevent:call(global.gameEvent.EV_ON_PET_PLAYEFFECT, tonumber(self.friendNum:getString()))

        global.tipsMgr:showWarning("petFeedPrompt")
        gevent:call(gsound.EV_ON_PLAYSOUND,"pet_feelup")
        
    end, 2, petData.type, 2, self.data.id, tonumber(self.consumeNum:getString()))

end

function UIFeedResPanel:buyHandler(sender, eventType)
    
    local getPanel = global.panelMgr:openPanel("UIResGetPanel")
    getPanel:setData(global.resData:getResById(self.data.id), true)
end
--CALLBACKS_FUNCS_END

return UIFeedResPanel

--endregion
