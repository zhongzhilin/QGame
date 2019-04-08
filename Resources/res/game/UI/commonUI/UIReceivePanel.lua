--region UIReceivePanel.lua
--Author : anlitop
--Date   : 2017/04/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBagItem = require("game.UI.bag.UIBagItem")
--REQUIRE_CLASS_END

local UIReceivePanel  = class("UIReceivePanel", function() return gdisplay.newWidget() end )

function UIReceivePanel:ctor()
    self:CreateUI()
end

function UIReceivePanel:CreateUI()
    local root = resMgr:createWidget("common/receive_panel")
    self:initUI(root)
end

function UIReceivePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/receive_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Size = self.root.Size_export
    self.xxx = UIBagItem.new()
    uiMgr:configNestClass(self.xxx, self.root.xxx)
    self.Panel = self.root.Panel_export
    self.effect_node = self.root.effect_node_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_7, function(sender, eventType) self:onexitpanel(sender, eventType) end)
--EXPORT_NODE_END
end

function UIReceivePanel:setReceiveData(item_arr) -- data    结构  -- {3,817,100}
    self.item_arr = item_arr 
    self:initReceivePanel()
end

function UIReceivePanel:initReceivePanel()

    local size = self.Size:getBoundingBox()
    dump(size,"self.Size:boundingBox()")
    self.ps = {}
    local x,y =self.Panel:getPosition()
    self.ps.x  =x 
    self.ps.y  = y 
    self.itemData = {}
    local dropData =  {}
    for _ ,v in  pairs(self.item_arr ) do 
        local drop_item = {} 
        drop_item[1] = v.id 
        drop_item[2] = v.count
        drop_item[3] = 100 
        table.insert(dropData, drop_item)
    end


   self.item = {} 

    local lineMaxCount = 4 
    local i = 0 
    local x = 0
    local y =0 
    local fuck = 0 
    for _, v in pairs(dropData) do
        if i  >= lineMaxCount then 
            i = 0 
            y = y + 1 
        end
        x = i * size.width +self.Panel:getContentSize().width /2  
        i = i + 1
        local item = UIBagItem.new()
        item:setScale(0.7)
        item:setItemData(v,true)
        item:setTag(100+fuck)
        self.Panel:addChild(item)
        item:setPosition(cc.p(x,-(y*size.height)))
        fuck = fuck + 1 
        table.insert(self.item,item)
    end
    self.itemData = clone(dropData)
    local panel_width = 0 
     if  #dropData <= lineMaxCount   then  
        panel_width =  #dropData  *  size.width 
    else
         panel_width = lineMaxCount  *  size.width 
    end 
    --self.Panel:setContentSize(cc.size(panel_width,size.height))
    print(self.Panel:getContentSize().width,"self.Panel:getContentSize().width")
    self.Panel:setPosition(cc.p(self.Panel:getPositionX() - panel_width/2,self.Panel:getPositionY()))
   self:itemAction()
end


function UIReceivePanel:itemRunAction(item , i)


end 

function UIReceivePanel:exit()
    self:stopAllActions()
    self.PanelModel:setVisible(true)
    self.root.Panel_1:setVisible(false)
    self:itemAnmation()
end


function UIReceivePanel:onExit()
    -- body
    dump(self.ps,"self.ps  ========")
    self.Panel:setPosition(cc.p(self.ps.x, self.ps.y))
    self.Panel:removeAllChildren()
end

function UIReceivePanel:itemAction()
    self.effect_node:stopAllActions()
    self.effect_node:setVisible(false)
    local nodeTimeLine =resMgr:createTimeline("effect/zhuangbei_light")
    self.effect_node:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)

    local delayT = 0.2
    local nodeX, nodeY = self.Panel:getPosition()
    dump( self.effect_node:getContentSize(),"waht the fuck ")
        dump( self.effect_node:getPosition(),"waht the fuck ")
    local spw = cc.Spawn:create( cc.MoveTo:create(delayT, cc.p(self.effect_node:getPositionX()-55, self.effect_node:getPositionY()-60)), cc.ScaleTo:create(delayT, 0.5) )
    self.Panel:runAction( cc.Sequence:create(spw , cc.CallFunc:create(function ()
    end) , 
     cc.Repeat:create(cc.Sequence:create(  cc.ScaleTo:create(delayT, 1),cc.CallFunc:create(function ()
        self.effect_node:setVisible(true)
    end),cc.ScaleTo:create(delayT, 0.8),cc.ScaleTo:create(delayT, 1)  ), 1), cc.DelayTime:create(delayT*2), cc.CallFunc:create(function ()
        self:itemMove()
        self.effect_node:setVisible(false)
     end )))



end

function UIReceivePanel:itemMoveAction( item, i )

    local moveSpeed = 0.2
    local pox = self.Panel:convertToNodeSpace(cc.p(gdisplay.width/3-50, 50))
    local spa = cc.Spawn:create(  cc.MoveTo:create(moveSpeed, cc.p(pox.x, pox.y)),  cc.ScaleTo:create(moveSpeed, 0))
    item:runAction( cc.Sequence:create( cc.DelayTime:create(0.1*i), spa, cc.CallFunc:create(function ()
            if i ==  (#self.itemData-1) then                 
                self:exitCall() 
            end
            item:removeFromParent()
    end) ))
end

function UIReceivePanel:itemMove()

    for i=0,#self.itemData-1 do
   
        local item = self.Panel:getChildByTag(100+i)
        -- local itemBg = self.Panel:getChildByTag(200+i)
        self:itemMoveAction(item, i)
        -- self:itemMoveAction(itemBg, i)
    end
end


function UIReceivePanel:exitCall()
    
    -- -- self.PanelModel:setVisible(false)
    -- self.root.Panel_1:setVisible(true)
    -- if self.scheduleCutNum then
    --     gscheduler.unscheduleGlobal(self.scheduleCutNum)
    --     self.scheduleCutNum = nil
    -- end
    global.panelMgr:closePanel("UIReceivePanel") 
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIReceivePanel:onexitpanel(sender, eventType)
      global.panelMgr:closePanel("UIReceivePanel") 
end
--CALLBACKS_FUNCS_END

return UIReceivePanel

--endregion
