--region UIUnLockFunItem.lua
--Author : yyt
--Date   : 2017/08/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnLockFunItem  = class("UIUnLockFunItem", function() return gdisplay.newWidget() end )

function UIUnLockFunItem:ctor()
    self:CreateUI()
end

function UIUnLockFunItem:CreateUI()
    local root = resMgr:createWidget("common/city_lvup_node_1")
    self:initUI(root)
end

function UIUnLockFunItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/city_lvup_node_1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.nextLvTitle = self.root.nextLvTitle_export
    self.bg = self.root.nextLvTitle_export.bg_export
    self.nextBg = self.root.nextLvTitle_export.nextBg_export
    self.title = self.root.nextLvTitle_export.nextBg_export.title_export
    self.curLvTitle = self.root.curLvTitle_export
    self.curTitle = self.root.curLvTitle_export.curTitle_export
    self.icon = self.root.icon_export
    self.curLvContent = self.root.curLvContent_export
    self.func_name = self.root.curLvContent_export.func_name_export
    self.func_des = self.root.curLvContent_export.func_des_export
    self.nextLvContent = self.root.nextLvContent_export
    self.func_name1 = self.root.nextLvContent_export.func_name1_export
    self.func_des1 = self.root.nextLvContent_export.func_des1_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnLockFunItem:setData(cellData)
    
    self.data = cellData
    local data = cellData.cdata
    global.panelMgr:setTextureFor(self.icon ,data.icon)
    
    self.icon:setScale(1)
    if data.scale > 0 then
        self.icon:setScale(data.scale/100)
    end
    self.icon:setPositionY(101+data.posY)

    self.curLvTitle:setVisible(false)
    self.nextLvTitle:setVisible(false)
    self.curLvContent:setVisible(false)
    self.nextLvContent:setVisible(false)
    self.root.line:setVisible(true)
    self.root.line:setScaleX(1)

    if data.nextLv then 
        self.root.line:setScaleX(2)
        self.nextLvContent:setVisible(true)
        self.nextLvTitle:setVisible(true)
        self.nextBg:setVisible(false)
        self.func_name1:setString(data.name)
        self.func_des1:setString(data.des)

        self.title:setString(global.luaCfg:get_local_string(10778, data.nextLv))
        if data.index == 1 then
            self.nextBg:setVisible(true)
            self.bg:setContentSize(cc.size(cellData.cellW, cellData.cellH - cellData.titleH))
        else
            self.bg:setContentSize(cc.size(cellData.cellW, cellData.cellH))
        end
    else
        self.curTitle:setString(global.luaCfg:get_local_string(10849, data.curLv or 0))
        self.curLvContent:setVisible(true)
        self.func_name:setString(data.name)
        self.func_des:setString(data.des)

        if data.index == 1 then    
            self.curLvTitle:setVisible(true)
        elseif data.index == data.maxNum then 
            self.root.line:setVisible(false)
        end

        if (data.index == data.maxNum) and (data.index == 1) then  
            self.root.line:setVisible(false)
        end
    end

end

--CALLBACKS_FUNCS_END

return UIUnLockFunItem

--endregion
