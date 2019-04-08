--region UIWorldMapInfoItem1.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWorldMapInfoItem1  = class("UIWorldMapInfoItem1", function() return gdisplay.newWidget() end )

function UIWorldMapInfoItem1:ctor()
    
end

function UIWorldMapInfoItem1:CreateUI()
    local root = resMgr:createWidget("world/miracle_info_list1")
    self:initUI(root)
end

function UIWorldMapInfoItem1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/miracle_info_list1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.Text1 = self.root.Text1_export
    self.Text2 = self.root.Text2_export
    self.Text3 = self.root.Text3_export
    self.Text4 = self.root.Text4_export

--EXPORT_NODE_END
end

function UIWorldMapInfoItem1:setData(index)

    local panel = global.panelMgr:getPanel("UINewWorldMap")    
    local data = panel:getAllyInfoByMiracleType(index)    

    self.Text1:setString(luaCfg:get_map_region_by(index).name)
    self.icon:setSpriteFrame(luaCfg:get_world_miracle_name_by(index).icon)

    if data and  data.lAllyID then -- protect 

        -- local sort = panel:getAllySort(data.lAllyID)
        -- if sort > 10 then

        --     self.icon:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(11).color)))
        -- else

        --     self.icon:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(sort).color)))
        -- end

        if data.lAllyID == 0 then
        
            self.Text3:setString("-")
        else

            self.Text3:setString(string.format("【%s】%s",data.szallyFlag,data.szAllyName))
        end
        
        self.Text4:setString(data.szOwnerName)
    else

        -- self.icon:setColor(cc.c3b(unpack(luaCfg:get_map_color_by(12).color)))
        self.Text3:setString("-")
        self.Text4:setString("-")
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWorldMapInfoItem1

--endregion
