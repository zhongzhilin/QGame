--region UIHeadFrameItem.lua
--Author : anlitop
--Date   : 2017/07/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeadFrameItem  = class("UIHeadFrameItem", function() return gdisplay.newWidget() end )

function UIHeadFrameItem:ctor()

    self:CreateUI()
end

function UIHeadFrameItem:CreateUI()
    local root = resMgr:createWidget("rolehead/frame_item_node")
    self:initUI(root)
end

function UIHeadFrameItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rolehead/frame_item_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.item_bt = self.root.item_bt_export
    self.portrait_node = self.root.item_bt_export.Node_4.portrait_node_export
    self.frame = self.root.item_bt_export.Node_4.frame_export
    self.locked = self.root.item_bt_export.Node_4.locked_mlan_7_export
    self.name = self.root.item_bt_export.Node_4.name_export
    self.condition = self.root.item_bt_export.Node_4.condition_export
    self.buy_btn = self.root.item_bt_export.Node_4.buy_btn_export
    self.num = self.root.item_bt_export.Node_4.buy_btn_export.num_export
    self.use_btn = self.root.item_bt_export.Node_4.use_btn_export
    self.select = self.root.item_bt_export.Node_4.select_mlan_7_export
    self.lock = self.root.item_bt_export.lock_export

    uiMgr:addWidgetTouchHandler(self.buy_btn, function(sender, eventType) self:onbuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.use_btn, function(sender, eventType) self:onuse(sender, eventType) end)
--EXPORT_NODE_END

    self.item_bt:setSwallowTouches(false)
    self.item_bt:setZoomScale(0)
end



function UIHeadFrameItem:setData(data)
    
    self.data = data 

    self.use_btn:setVisible(false)
    
    self.locked:setVisible(false)

    self.buy_btn:setVisible(false)

    self.select:setVisible(false)

    self.portrait_node:setVisible(false)

     self.lock:setVisible(false)

    self.name:setString(self.data.name)

    if self.data.state == global.userheadframedata.STATE.ON then 

        self.condition:setString(global.luaCfg:get_local_string(10718))

        if self.data.select then 

            self.portrait_node:setVisible(true)

            self.select:setVisible(true)
            
        else 
            self.use_btn:setVisible(true)
        end 

    else 
        self.condition:setString(self.data.desc)
            
         self.lock:setVisible(true)
            
        if self.data.condition_type == 1 then  -- 成就解锁

            self.locked:setVisible(true)

        elseif self.data.condition_type == 2 then   -- 魔晶解锁

            self.buy_btn:setVisible(true)

            self.num:setString(self.data.condition)

            self.DIAMOND = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

            if self.DIAMOND > self.data.condition     then 

                 self.num:setTextColor(gdisplay.COLOR_WHITE)
            else 

                 self.num:setTextColor(gdisplay.COLOR_RED)
            end 
        else
            self.locked:setVisible(true)
        end 

    end


    global.panelMgr:setTextureFor( self.frame,self.data.pic)

    local head = clone(global.headData:getCurHead())
    if head then
         global.tools:setCircleAvatar(self.portrait_node, head)
    end

end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeadFrameItem:onbuy(sender, eventType)
    
    if self.DIAMOND < self.data.condition     then 

         global.tipsMgr:showWarning("ItemUseDiamond")

        return 
    end 

    local panel = global.panelMgr:openPanel("UIPromptPanel")

    panel:setData(string.format(global.luaCfg:get_localization_by(10720).value , self.data.condition,self.data.name), function()
            
        global.itemApi:diamondUse(function () 

            global.userheadframedata:deblockingHeadFrame(self.data.id)

        end , 11 , self.data.id)
    end)    

end


function UIHeadFrameItem:onuse(sender, eventType)

    global.loginApi:updateUserHeadFrame(self.data.id, function () 

        global.tipsMgr:showWarning("use_frame_success")    
        
        global.userheadframedata:setCrutFrame(self.data.id)

    end)
end
--CALLBACKS_FUNCS_END

return UIHeadFrameItem

--endregion
