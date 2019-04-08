--region UITipsSoliderNode.lua
--Author : anlitop
--Date   : 2017/07/31
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITipsSoliderNode  = class("UITipsSoliderNode", function() return gdisplay.newWidget() end )

function UITipsSoliderNode:ctor()
    self:CreateUI()
end

function UITipsSoliderNode:CreateUI()
    local root = resMgr:createWidget("common/war_tips_list_node")
    self:initUI(root)
end

function UITipsSoliderNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/war_tips_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.contentSize = self.root.contentSize_export
    self.portrait_node = self.root.contentSize_export.icon_bg.portrait_node_export
    self.num = self.root.contentSize_export.num_export
    self.name = self.root.contentSize_export.name_export
    self.SLV = self.root.contentSize_export.SLV_export
    self.star = self.root.contentSize_export.star_export
    self.star1_bj = self.root.contentSize_export.star_export.star1_bj_export
    self.star1 = self.root.contentSize_export.star_export.star1_bj_export.star1_export
    self.star2 = self.root.contentSize_export.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.contentSize_export.star_export.star2_bj_export
    self.star3 = self.root.contentSize_export.star_export.star2_bj_export.star3_export
    self.star4 = self.root.contentSize_export.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.contentSize_export.star_export.star3_bj_export
    self.star5 = self.root.contentSize_export.star_export.star3_bj_export.star5_export
    self.star6 = self.root.contentSize_export.star_export.star3_bj_export.star6_export
    self.chief = self.root.contentSize_export.chief_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UITipsSoliderNode:setData(data)

    local naiijiudu = global.luaCfg:get_local_string(10737)
    local shuliang  = global.luaCfg:get_local_string(10736)

    self.data = data 

    self:setId()

    self.num:setString(data.lcount)
    -- self.num_type:setString(shuliang)

    if self.data.soldierId ==70 then  --城强

        global.tools:setSoldierAvatar(self.portrait_node,{id=3})

        self.num:setString(data.lcount)

        -- self.num_type:setString(naiijiudu)

    elseif self.data.soldierId ==71 then  --j箭塔

        global.tools:setSoldierAvatar(self.portrait_node,{id=8071})

    elseif self.data.soldierId ==72 then  --陷阱

        global.tools:setSoldierAvatar(self.portrait_node,{id=8072})

    else 
        global.tools:setSoldierAvatar(self.portrait_node,{id=data.soldierId})

        self.soldier_id = data.soldierId
    end 

    self:test()

    self:updateChief()

    local solider_data =  global.luaCfg:get_soldier_train_by(self.soldier_id)

    if  not solider_data then 

        solider_data  = global.luaCfg:get_wild_property_by(self.soldier_id)
    end 

    if  self.soldier_id==3 then

        solider_data = global.luaCfg:get_soldier_property_by(self.soldier_id)
    end 


    if solider_data then 

        self.name:setString(solider_data.name)

    end 

    self.data.soldierLV =self.data.soldierLV or 0 
        

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end

    if self.data.soldierLV > 0 and self.data.soldierId ~=70 and self.data.soldierId~=71 and self.data.soldierId ~=72 then 
        self.SLV:setString("")
        showlvStar(self.data.soldierLV)
    else 
        showlvStar(-1)
        self.SLV:setString("")
    end 

end 



function UITipsSoliderNode:updateChief()
    self.chief:setVisible(self.data.chief)
end 


function UITipsSoliderNode:getContentSize()

    return self.contentSize:getContentSize()
end 


function  UITipsSoliderNode:setId ()

     if self.data.soldierId ==70 then  --城强
        self.soldier_id = 3 
    elseif self.data.soldierId ==71 then  --j箭塔
        self.soldier_id = 8071
    elseif self.data.soldierId ==72 then  --陷阱
        self.soldier_id = 8072
    else 
        self.soldier_id = self.data.soldierId
    end 

end 

function UITipsSoliderNode:test()

    -- self:turnGray(not (self.data.lcount <= 0)) 

    global.colorUtils.turnGray(self.num, false)

    if self.data.lcount <=0 then 

        self.num:setTextColor(gdisplay.COLOR_RED)
    else 
        self.num:setTextColor(gdisplay.COLOR_GREEN)
    end 
end 


return UITipsSoliderNode

--endregion
