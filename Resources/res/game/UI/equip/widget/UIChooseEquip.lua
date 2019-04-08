--region UIChooseEquip.lua
--Author : Administrator
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChooseEquip  = class("UIChooseEquip", function() return gdisplay.newWidget() end )

function UIChooseEquip:ctor()
    
end

function UIChooseEquip:CreateUI()
    local root = resMgr:createWidget("equip/resolve_node")
    self:initUI(root)
end

function UIChooseEquip:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/resolve_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.add_btn = self.root.add_btn_export
    self.equip_node = self.root.equip_node_export
    self.itemIcon = self.root.equip_node_export.buttonNode.itemIcon_export
    self.plus_icon = self.root.equip_node_export.plus_icon_export
    self.strengthen_lv = self.root.equip_node_export.plus_icon_export.strengthen_lv_export
    self.equip_name = self.root.equip_node_export.equip_name_export

    uiMgr:addWidgetTouchHandler(self.add_btn, function(sender, eventType) self:choose(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.itemIcon, function(sender, eventType) self:cancel(sender, eventType) end, true)
--EXPORT_NODE_END
    self.add_btn:setSwallowTouches(false)
    self.itemIcon:setSwallowTouches(false)
end

function UIChooseEquip:setIndex(index)
    
    self.index = index
end


function UIChooseEquip:playChooseAction()
    
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_EquipSplitInto")
    
    self.nodeTimeLine:play("animation0",false)
    self.nodeTimeLine:setLastFrameCallFunc(function()
  
    end)    
end


function UIChooseEquip:setData(data)
    
    self.data = data
    if data == nil then
    
        self.add_btn:setVisible(true)
        self.equip_node:setVisible(false)
    else

        self:playChooseAction()

        self.add_btn:setVisible(false)
        self.equip_node:setVisible(true)

        if data.lStronglv > 0 then
            self.plus_icon:setVisible(true)
            self.strengthen_lv:setString(data.lStronglv)
        else
            self.plus_icon:setVisible(false)
        end

        self.equip_name:setString(data.confData.name)
        self.equip_name:setTextColor(cc.c3b(unpack(luaCfg:get_quality_color_by(data.confData.quality).rgb)))
        -- self.itemIcon:loadTextureNormal(data.confData.icon, ccui.TextureResType.plistType)
        -- self.itemIcon:loadTexturePressed(data.confData.icon, ccui.TextureResType.plistType)
        global.panelMgr:setTextureFor(self.itemIcon,data.confData.icon)
    end
end

function UIChooseEquip:getData()
    
    return self.data
end

function UIChooseEquip:onEnter()
    
    self.nodeTimeLine = resMgr:createTimeline("equip/resolve_node")    
    self.root:stopAllActions()
    self.root:runAction(self.nodeTimeLine)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChooseEquip:setRoyalDeleteData(data) --御令分解
    if not data then 
        self.add_btn:setVisible(false)
        self.equip_node:setVisible(false)
        self.data =  nil 
        return 
    end 

    local item = global.luaCfg:get_item_by(data)
    self.itemIcon:setVisible(true)
    self.equip_node:setVisible(true)
    self.plus_icon:setVisible(false)
    self.equip_name:setString(item.itemName)
    self.add_btn:setVisible(false)
    global.panelMgr:setTextureFor(self.itemIcon,item.itemIcon)
    self.isRoyal  = true 
    self.data ={} 
    self.data.lID = data  
end 

function UIChooseEquip:choose(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIDeletePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        global.panelMgr:openPanel("UIEquipPanel"):setDataRaw(function()
            return global.equipData:getDumpList()
        end)
            :setEquipInfo(true, 10425,false,function(data)
                
            global.panelMgr:getPanel("UIDeletePanel"):chooseEquip(data,self.index)
            global.panelMgr:closePanelForBtn("UIEquipPanel")
        end):setFilterCall(function(tbdata)
            
            print(">>>>>>>>self set filter call")
            global.panelMgr:getPanel("UIDeletePanel"):filterData(tbdata)
            
        end)

    end
end

function UIChooseEquip:cancel(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIDeletePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("GetOffEquip",function()

            if  self.isRoyal  then 

                global.panelMgr:getPanel("UIRoyalDeletePanel"):chooseEquip(nil,self.index)
            else 

                global.panelMgr:getPanel("UIDeletePanel"):chooseEquip(nil,self.index)

            end 
        end)

    end
end
--CALLBACKS_FUNCS_END

return UIChooseEquip

--endregion
