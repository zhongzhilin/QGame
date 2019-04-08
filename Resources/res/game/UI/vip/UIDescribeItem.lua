--region UIDescribeItem.lua
--Author : anlitop
--Date   : 2017/03/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDescribeItem  = class("UIDescribeItem", function() return gdisplay.newWidget() end )

function UIDescribeItem:ctor()
    self:CreateUI()
end

function UIDescribeItem:CreateUI()
    local root = resMgr:createWidget("vip/describe_item")
    self:initUI(root)
end


function UIDescribeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "vip/describe_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.describe_text = self.root.describe_text_export
    self.add_text = self.root.add_text_export
    self.vip_point = self.root.vip_point_export
    self.vip_add_item_arrow = self.root.vip_add_item_arrow_export
    self.vip_comparison_node = self.root.vip_comparison_node_export
    self.vip_up_arrow = self.root.vip_comparison_node_export.vip_up_arrow_export
    self.vip_down_arrow = self.root.vip_comparison_node_export.vip_down_arrow_export
    self.up_text = self.root.vip_comparison_node_export.up_text_export
    self.down_text = self.root.vip_comparison_node_export.down_text_export
    self.effect = self.root.effect_export

--EXPORT_NODE_END
end



local color = {
    strong  = cc.c3b( 255 , 185, 34 )  , 
    defalut = cc.c3b( 255 ,226 , 165) ,
} 



function UIDescribeItem:setData(data)
	self.data =data
	self:updateUI()
end 

function UIDescribeItem:updateUI()

    if self.data.isNewItem  then 
        self.vip_comparison_node:setVisible(false)
       -- self.vip_point:setVisible(false)
        self.vip_add_item_arrow:setVisible(true)
    else
        self.vip_add_item_arrow:setVisible(false)
        self.vip_comparison_node:setVisible(true)
        self.vip_point:setVisible(true)
    end  

    if   self.data.up_text  ~=0  then
        if not self.data.up_text then return end 
        if self.data.up_text > 0 then 
            self.down_text:setVisible(false)
            self.up_text:setString(self.data.up_text..luaCfg:get_data_type_by(self.data[1]).extra)
            self.up_text:setVisible(true)
            self.vip_up_arrow:setVisible(true)
            self.vip_down_arrow:setVisible(false)
        else
            self.down_text:setVisible(true)
            self.down_text:setString(math.abs(self.data.up_text)..luaCfg:get_data_type_by(self.data[1]).extra)
            self.up_text:setVisible(false)
            self.vip_up_arrow:setVisible(false)
            self.vip_down_arrow:setVisible(true)
        end 
    else 
         self.vip_comparison_node:setVisible(false)
    end 
    if luaCfg:get_data_type_by(self.data[1]).icon and #(luaCfg:get_data_type_by(self.data[1]).icon)>1 then 
        self.vip_point:setSpriteFrame(luaCfg:get_data_type_by(self.data[1]).icon)
    end 
	self.describe_text:setString(luaCfg:get_data_type_by(self.data[1]).paraName)
	self.add_text:setString("+"..self.data[2]..luaCfg:get_data_type_by(self.data[1]).extra)


    if  self.data.strong then 
        
        self.describe_text:setTextColor(color.strong)

        self:playEffect()

    else 

        self.effect:setVisible(false)

        self.describe_text:setTextColor(color.defalut)
    end 

end 


function UIDescribeItem:playEffect()

    self.effect:setVisible(true)

    self.effect:stopAllActions()
    local nodeTimeLine =resMgr:createTimeline("citybuff/city_buff_effect")
    self.effect:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIDescribeItem

--endregion
