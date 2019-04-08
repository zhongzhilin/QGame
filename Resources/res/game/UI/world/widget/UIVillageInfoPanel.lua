--region UIVillageInfoPanel.lua
--Author : wuwx
--Date   : 2016/11/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIVillageInfoPanel  = class("UIVillageInfoPanel", function() return gdisplay.newWidget() end )

function UIVillageInfoPanel:ctor()
    self:CreateUI()
end

function UIVillageInfoPanel:CreateUI()
    local root = resMgr:createWidget("world/info/village_info")
    self:initUI(root)
end

function UIVillageInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/village_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.type_icon = self.root.Node_export.type_bj.type_icon_export
    self.name = self.root.Node_export.name_mlan_10_export
    self.x = self.root.Node_export.x_export
    self.y = self.root.Node_export.y_export
    self.tips4 = self.root.Node_export.Image_13.tips4_mlan_4_export
    self.tips5 = self.root.Node_export.Image_13.tips5_mlan_5_export
    self.tips6 = self.root.Node_export.Image_13.tips6_mlan_5_export
    self.tips1 = self.root.Node_export.Image_13.tips1_export
    self.tips2 = self.root.Node_export.Image_13.tips2_export
    self.tips3 = self.root.Node_export.Image_13.tips3_export
    self.info = self.root.Node_export.info_mlan_8_export

--EXPORT_NODE_END
end

function UIVillageInfoPanel:onEnter(sender, eventType)
    self:initTouchListener()
end

function UIVillageInfoPanel:initTouchListener()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(true)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.root.touch)
end

function UIVillageInfoPanel:onTouchBegan(touch, event)
    return true
end

function UIVillageInfoPanel:onTouchEnded(touch, event)
    self:onCloseHandler()
end

function UIVillageInfoPanel:onCloseHandler(sender, eventType)
    panelMgr:closePanel("UIVillageInfoPanel")
end

function UIVillageInfoPanel:setData(city,data)
    self.city = city
    self.surfaceData = data

    local lordData = self.city:getOccupierData()

    -- self.type_icon:setSpriteFrame(data.worldmap)
    global.panelMgr:setTextureFor(self.type_icon,data.worldmap)
    
    self.info:setString(self.city:getName())

    self.tips1:setString("-")
    self.tips2:setString("-")
    --地点特色
    self.tips3:setString("")
    for i,pair in ipairs(self.city:getPlusData()) do

        local douhao = i == 1 and '' or ','
        self.tips3:setString(self.tips3:getString() .. douhao .. global.buffData:getBuffStrBy(pair))
    end

    if lordData then
        self.tips1:setString(lordData.szUserName)
        self.tips2:setString(global.unionData:getUnionShortName(lordData.szAllyName))
    end

    local pos = global.g_worldview.const:converPix2Location(cc.p(self.city:getPosition()))
    self.x:setString(math.round(pos.x))
    self.y:setString(math.round(pos.y))

    --润稿翻译处理 张亮
    global.tools:adjustNodePos(self.tips4,self.tips1)
    global.tools:adjustNodePos(self.tips5,self.tips2)
    global.tools:adjustNodePos(self.tips6,self.tips3)

end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
--CALLBACKS_FUNCS_END

return UIVillageInfoPanel

--endregion
