--region UIWallSpaceItem.lua
--Author : wuwx
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWallSpaceItem  = class("UIWallSpaceItem", function() return gdisplay.newWidget() end )

function UIWallSpaceItem:ctor()
    
end

function UIWallSpaceItem:CreateUI()
    local root = resMgr:createWidget("wall/wall_device_node")
    self:initUI(root)
end

function UIWallSpaceItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_device_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.device_name = self.root.device_name_export
    self.device_info = self.root.device_info_export
    self.portrait_node = self.root.portrait_node_export
    self.number = self.root.number_bg.number_export

    uiMgr:addWidgetTouchHandler(self.root.train_btn, function(sender, eventType) self:onOpenTrainHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIWallSpaceItem:setData(data)
    self.data = data
    local soldierData = luaCfg:get_soldier_train_by(self.data.lID)
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)

    self.device_name:setString(soldierData.name)

    local soldierProData = luaCfg:get_soldier_property_by(self.data.lID)

    local raceId = global.userData:getRace()
    local soldierPro = luaCfg:get_def_device_by(global.soldierData:getDefDeviceId(self.data.lID))
    self.device_info:setString(soldierPro.info)

    self.number:setString(self.data.lCount)

    self.root.icon_bg:setScale(1)
    local raceData = global.luaCfg:get_race_by(global.userData:getRace())
    global.panelMgr:setTextureFor(self.root.icon_bg, raceData.soldierTrainBg)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWallSpaceItem:onOpenTrainHandler(sender, eventType)
        
    if self.trainCall  then 
        
        self.trainCall ()
        return 
    end 

    global.g_cityView:getOperateMgr():train()

end
--CALLBACKS_FUNCS_END

return UIWallSpaceItem

--endregion
