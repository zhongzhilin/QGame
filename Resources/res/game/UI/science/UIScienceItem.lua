--region UIScienceItem.lua
--Author : yyt
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIScienceItem  = class("UIScienceItem", function() return gdisplay.newWidget() end )

function UIScienceItem:ctor()
    
end

function UIScienceItem:CreateUI()
    local root = resMgr:createWidget("science/science_type_node")
    self:initUI(root)
end

function UIScienceItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/science_type_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button_1 = self.root.Button_1_export
    self.icon = self.root.Button_1_export.icon_export
    self.type = self.root.Button_1_export.type_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:clickHandler(sender, eventType) end)
--EXPORT_NODE_END
end

local lockBg = {
    [1] = "science_type_lock.png",
    [2] = "science_type_unlock.png",
}

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIScienceItem:onEnter()

    local nodeTimeLine = resMgr:createTimeline("science/science_type_node")
    nodeTimeLine:play("animation0", false)
    self:runAction(nodeTimeLine)

end

function UIScienceItem:setData(id)
  
   -- dump(id,"科技分类")
    self.Button_1:setName(self.Button_1:getName()..id)

    self.id = id
    local data = luaCfg:get_science_type_by(id)
    self.type:setString(data.name)
    -- self.icon:setSpriteFrame(data.pic)
    global.panelMgr:setTextureFor(self.icon,data.pic)

    if self.id then
        
        self.Button_1:loadTextures(lockBg[1],lockBg[1],lockBg[1],ccui.TextureResType.plistType)

    else
    
        self.Button_1:loadTextures(lockBg[2],lockBg[2],lockBg[2],ccui.TextureResType.plistType)
    end

end


function UIScienceItem:clickHandler(sender, eventType)
    
    local scePanel = global.panelMgr:getPanel("UISciencePanel")
    gaudio.stopSound(scePanel:getSound())

    global.panelMgr:openPanel("UIScienceDPanel"):setData(self.id, false)

end
--CALLBACKS_FUNCS_END

return UIScienceItem

--endregion
