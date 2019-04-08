--region UIComInfo.lua
--Author : untory
--Date   : 2017/05/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIComInfo  = class("UIComInfo", function() return gdisplay.newWidget() end )

function UIComInfo:ctor()
    self:CreateUI()
end

function UIComInfo:CreateUI()
    local root = resMgr:createWidget("world/info/world_info")
    self:initUI(root)
end

function UIComInfo:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/world_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.node = self.root.Node_details.node_export
    self.text1 = self.root.Node_details.text1_export
    self.text2 = self.root.Node_details.text2_export
    self.text3 = self.root.Node_details.text3_export
    self.close_node = self.root.Node_details.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_details.close_node_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_bg, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
--EXPORT_NODE_END

    self.close_node:setData(function ()
        global.panelMgr:closePanel("UIComInfo")
        global.guideMgr:dealScript()
    end)
end

function UIComInfo:setData(data)
    
    self.data = data

    local id = data.id
    local conf = global.luaCfg:get_guide_world_info_by(id)
    if conf then
        self.text1:setString(conf.title)
        self.text2:setString(conf.small_title)
        self.text3:setString(conf.desc)
        -- self.img:setSpriteFrame(conf.img)

        self.node:removeAllChildren()
        local csd = resMgr:createWidget(conf.img)
        uiMgr:configUITree(csd)
        if conf.ID == 1 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
        elseif conf.ID == 2 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.soldier_wild_monster_001_8,"icon/soldier/wild/monster_001.png")
            global.panelMgr:setTextureFor(csd.soldier_wild_monster_002_9,"icon/soldier/wild/monster_002.png")
            global.panelMgr:setTextureFor(csd.soldier_wild_monster_003_10,"icon/soldier/wild/monster_003.png")
            global.panelMgr:setTextureFor(csd.soldier_wild_monster_004_11,"icon/soldier/wild/monster_004.png")
        elseif conf.ID == 3 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.mapunit_c_010_4,"icon/mapunit/c_010.png")
        elseif conf.ID == 4 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.mapunit_c_010_4,"icon/mapunit/c_006.png")
        elseif conf.ID == 5 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.mapunit_transfer_gate_5,"icon/mapunit/c_008.png")
        elseif conf.ID == 6 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.mapunit_c_1103_35,"icon/mapunit/c_1103.png")
        elseif conf.ID == 7 then
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.mapunit_c_1103_35,"icon/mapunit/c_001.png")
        elseif conf.ID == 8 then
            global.panelMgr:setTextureFor(csd.c_001_163,"icon/mapunit/c_001.png")
            global.panelMgr:setTextureFor(csd.c_001_163_0,"icon/mapunit/c_001.png")
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1,"icon/mapunit/c_1203.png")
            global.panelMgr:setTextureFor(csd.mapunit_c_1203_1_0,"icon/mapunit/c_1203.png")
        end
        self.node:addChild(csd)
    end    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIComInfo:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIComInfo")
    global.guideMgr:dealScript()
end
--CALLBACKS_FUNCS_END

return UIComInfo

--endregion
