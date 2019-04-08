--region UIWorldMapInfoItem2.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldMapInfoItem2  = class("UIWorldMapInfoItem2", function() return gdisplay.newWidget() end )

function UIWorldMapInfoItem2:ctor()
    
end

function UIWorldMapInfoItem2:CreateUI()
    local root = resMgr:createWidget("world/miracle_info_list2")
    self:initUI(root)
end

function UIWorldMapInfoItem2:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/miracle_info_list2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.num = self.root.num_export
    self.union = self.root.union_export
    self.color = self.root.color_export

--EXPORT_NODE_END
end

function UIWorldMapInfoItem2:setData(index)
    
    local panel = global.panelMgr:getPanel("UINewWorldMap")
    local info = panel:getAllyInfoBySort(index)

    if info == nil then 

        self.num:setString("-")
        self.union:setString("-")
    else

        self.num:setString(info.count)
        self.union:setString(info.name)
    end

    self.top:setString(index)
    self.color:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(index).color)))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWorldMapInfoItem2

--endregion
