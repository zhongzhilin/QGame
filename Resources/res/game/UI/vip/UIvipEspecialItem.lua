--region UIvipEspecialItem.lua
--Author : zzl
--Date   : 2017/12/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIvipEspecialItem  = class("UIvipEspecialItem", function() return gdisplay.newWidget() end )
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")

function UIvipEspecialItem:ctor()
    
end

function UIvipEspecialItem:CreateUI()
    local root = resMgr:createWidget("vip/vin_package")
    self:initUI(root)
end

function UIvipEspecialItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "vip/vin_package")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.show_level_text = self.root.level_text.show_level_text_export
    self.quit = self.root.item_node.quit_export
    self.icon = self.root.item_node.icon_export
    self.name = self.root.name_export
    self.vip_point = self.root.vip_point_export
    self.effect = self.root.effect_export
    self.vip_add_item_arrow = self.root.vip_add_item_arrow_export

--EXPORT_NODE_END
    
    self:playEffect()
end


function UIvipEspecialItem:playEffect()

    self.effect:setVisible(true)

    self.effect:stopAllActions()
    local nodeTimeLine =resMgr:createTimeline("citybuff/city_buff_effect")
    self.effect:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)
end 



local luaCfg = global.luaCfg

function UIvipEspecialItem:setData(level)



    self.show_level_text:setString(level)

    local item = nil 

    for _ , v in pairs(global.luaCfg:vip_func()) do 
        if v.lv == level then 
            for _ , vv in pairs(v.buffID) do 
                if vv[2]>0 and global.vipBuffEffectData:checkEquiment(vv  , level) then 
                    item = vv
                end
            end 
        end 
    end

    if item then 

        if luaCfg:get_data_type_by(item[1]).icon and #(luaCfg:get_data_type_by(item[1]).icon)>1 then 
            self.vip_point:setSpriteFrame(luaCfg:get_data_type_by(item[1]).icon)
        end 

        local data_type = luaCfg:get_data_type_by(item[1])

        self.name:setString(data_type.paraName)


        -- tips
        if self.m_TipsControl then 
            self.m_TipsControl:ClearEventListener()
            self.m_TipsControl  = nil 
        end
        
        self.m_TipsControl = UIItemTipsControl.new()
        local tempdata ={information=clone(luaCfg:get_data_type_by(item[1])), tips_type="UIItemDescMode2", vipTips=true} 
        self.m_TipsControl:setdata(self.vip_point, tempdata, global.vipPanel.tips_node)


        if self.itemId ~= data_type.typeId then
            self:playEffect()
        end 

        self.itemId = data_type.typeId

    end 
    

end 

function UIvipEspecialItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl  = nil 
    end 
       self.itemId  = nil 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIvipEspecialItem

--endregion
