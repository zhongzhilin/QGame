--region UIDeveloperPanel.lua
--Author : anlitop
--Date   : 2017/03/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UIDeveloperItem = require("game.UI.set.UIDeveloperItem")

local UIDeveloperPanel  = class("UIDeveloperPanel", function() return gdisplay.newWidget() end )

function UIDeveloperPanel:ctor()
    self:CreateUI()
end

function UIDeveloperPanel:CreateUI()
    local root = resMgr:createWidget("settings/developer_list")
    self:initUI(root)
end

function UIDeveloperPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/developer_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Panel = self.root.Panel_export
    self.developer_liset = self.root.developer_liset_export

    uiMgr:addWidgetTouchHandler(self.Panel, function(sender, eventType) self:onClickexit(sender, eventType) end)
--EXPORT_NODE_END
    
    self:setData()
end

function UIDeveloperPanel:onExit()
    -- body
     self.developer_liset:setPositionY(self.oldY)
end

function UIDeveloperPanel:setData(data)
    self.data = luaCfg:developer()
    self.speed =9  -- 向上滚动速度
    self.part  = 70 
    self.itemallheight=0
    for i =1 , #self.data do 
        local UIDeveloperItem_text = UIDeveloperItem.new()
        UIDeveloperItem_text.developer_item:setString(self.data[i].name)
        UIDeveloperItem_text:setPositionY(-i*self.part)
        self.developer_liset:addChild(UIDeveloperItem_text)
        self.itemallheight= self.itemallheight+ self.part 
    end 
end 

function UIDeveloperPanel:onEnter()
    self.oldY= self.developer_liset:getPositionY()
    self:updateUI()
end 

function UIDeveloperPanel:updateUI()

    local   y = self.Panel:getContentSize().height+self.itemallheight 
    local  move  = cc.MoveTo:create(self.speed,cc.p(self.developer_liset:getPositionX(),y))
     self.developer_liset:runAction(cc.Sequence:create(move,cc.CallFunc:create(function ()
                          global.panelMgr:closePanel("UIDeveloperPanel")
                    end 
                 )
         )  
    )    

-- itemUI:runAction(,cc.RemoveSelf:create()))
--                 end)))              
--    -- self.developer_liset:setPositionY(self.developer_liset:getPositionY()+self.speed)

end     

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDeveloperPanel:onClickexit(sender, eventType)
     global.panelMgr:closePanel("UIDeveloperPanel")
     global.panelMgr:openPanel("UISetPanel")
end
--CALLBACKS_FUNCS_END

return UIDeveloperPanel

--endregion
