--region UIEquipPutDown.lua
--Author : untory
--Date   : 2017/02/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipInfo = require("game.UI.equip.UIEquipInfo")
--REQUIRE_CLASS_END

local UIEquipPutDown  = class("UIEquipPutDown", function() return gdisplay.newWidget() end )

function UIEquipPutDown:ctor()
    self:CreateUI()
end

function UIEquipPutDown:CreateUI()
    local root = resMgr:createWidget("equip/equip_down")
    self:initUI(root)
end

function UIEquipPutDown:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_down")

-- do not edit code in this region!!!!
-- --EXPORT_NODE_BEGIN
    self.info = self.root.info_export
    self.info = UIEquipInfo.new()
    uiMgr:configNestClass(self.info, self.root.info_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIEquipPutDown:setData(data,isOther)
    
    self.info:setData(data,data.lHeroID,true,isOther)    
    return self
end

function UIEquipPutDown:setEquipInfo(isShowButton,str,isSinglePanel,callback)
    
    self.equipInfoData = {

        isShowButton = isShowButton,
        buttonStr = str,
        callback = callback,
        isSinglePanel = isSinglePanel,
    }

    self.info:setButton(self.equipInfoData.isShowButton,self.equipInfoData.buttonStr,self.equipInfoData.isSinglePanel,self.equipInfoData.callback)
    self.info:setPositionY((gdisplay.height - self.info:getContentHeigth()) / 2)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIEquipPutDown:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIEquipPutDown")
end
--CALLBACKS_FUNCS_END

return UIEquipPutDown

--endregion
