--region UIUnionMemSecA.lua
--Author : wuwx
--Date   : 2016/12/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUnionMemSecA  = class("UIUnionMemSecA", function() return gdisplay.newWidget() end )

function UIUnionMemSecA:ctor()
    
    self:CreateUI()
end

function UIUnionMemSecA:CreateUI()
    local root = resMgr:createWidget("union/union_member_mem_boss")
    self:initUI(root)
end

function UIUnionMemSecA:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_member_mem_boss")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.btn_export.portrait)
    self.name = self.root.btn_export.name_export
    self.battle = self.root.btn_export.battle.battle_export
    self.time = self.root.btn_export.time_export

--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionMemSecA:setData(data)
    self.data = data

    self.name:setString(data.sData.szName)
    -- self.icon:setSpriteFrame(data.icon)
    -- self.num:setString(string.format("%s/%s",self.data.count,20))
    self.time:setVisible(data.canLookOnlineState)
    if data.sData.lOnline == 1 then
        self.time:setString(global.luaCfg:get_local_string(10250))
        self.time:setTextColor(cc.c3b(87, 213, 63)) 
    else
        self.time:setString(global.funcGame.getDurationToNow(data.sData.lLastTime))
        self.time:setTextColor(cc.c3b(109, 79, 53)) 
    end
    self.battle:setString(data.sData.lPower)

    self.portrait:setData(data.sData.lFace,data.sData.lBackID,data.sData)
    
    local csbName = "union/union_member_mem_boss"
    local node = resMgr:createWidget(csbName)
    local nodeTimeLine = resMgr:createTimeline(csbName)
    nodeTimeLine:setLastFrameCallFunc(function()
    end)
    nodeTimeLine:play("animation0", true)
    self.nodeTimeLine = nodeTimeLine
    self.root:runAction(nodeTimeLine)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionMemSecA:onSecondCityHandler(sender, eventType)
    --点击成员头像
    global.tipsMgr:showWarning("FuncNotFinish")
end
--CALLBACKS_FUNCS_END

return UIUnionMemSecA

--endregion
