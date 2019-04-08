--region UIBottomGroup.lua
--Author : Untory
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIBottomItem = require("game.UI.offical.UIBottomItem")
--REQUIRE_CLASS_END

local UIBottomGroup  = class("UIBottomGroup", function() return gdisplay.newWidget() end )

function UIBottomGroup:ctor()
    
end

function UIBottomGroup:CreateUI()
    local root = resMgr:createWidget("offical/offical_spread_node")
    self:initUI(root)
end

function UIBottomGroup:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "offical/offical_spread_node")

-- do not edit code in this region!!!! 
--EXPORT_NODE_BEGIN
    self.board = self.root.Panel_1.board_export
    self.order_1 = UIBottomItem.new()
    uiMgr:configNestClass(self.order_1, self.root.Panel_1.board_export.order_1)
    self.order_2 = UIBottomItem.new()
    uiMgr:configNestClass(self.order_2, self.root.Panel_1.board_export.order_2)
    self.order_3 = UIBottomItem.new()
    uiMgr:configNestClass(self.order_3, self.root.Panel_1.board_export.order_3)
    self.order_4 = UIBottomItem.new()
    uiMgr:configNestClass(self.order_4, self.root.Panel_1.board_export.order_4)

--EXPORT_NODE_END

    self.board:setPositionY(950)
end

function UIBottomGroup:outAction()
    self.board:stopAllActions()
    self.board:runAction(cc.MoveTo:create(0.2,cc.p(77,950)))
end

function UIBottomGroup:inAction()
    self.board:stopAllActions()
    self.board:runAction(cc.MoveTo:create(0.2,cc.p(77,466)))
end

function UIBottomGroup:setData(offType,curTree)
    
    for i = 1,4 do
        self['order_' .. i]:setVisible(false)
    end

    local offData = luaCfg:official_post()    
    local ids = {}
    for _,v in pairs(offData) do        
        if v.senior == offType then            
            table.insert(ids,{id = v.id})            
        end
    end

    table.sortBySortList(ids,{{'id','min'}})

    for count,v in ipairs(ids) do
        self['order_' .. count]:setData(v.id,curTree[v.id])
        self['order_' .. count]:setVisible(true)
    end

    -- local count = #ids
    -- self.board:setContnetSize(cc.size(154,460 - (count - 4) * 103))

    -- for i = 1,3 do
    --     local id = offType * 100 + i
    -- end  
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIBottomGroup

--endregion
