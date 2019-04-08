--region UIActivityPointNode.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityPointNode  = class("UIActivityPointNode", function() return gdisplay.newWidget() end )

function UIActivityPointNode:ctor()
    
end

function UIActivityPointNode:CreateUI()
    local root = resMgr:createWidget("activity/point_reward_node")
    self:initUI(root)
end

function UIActivityPointNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/point_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.Node_1.bg_export
    self.point_title = self.root.Node_1.bg_export.point_title_export
    self.my_point = self.root.Node_1.bg_export.point_title_export.my_point_export
    self.loadingbar_point1 = self.root.Node_1.bg_export.LoadingBar_bg.loadingbar_point1_export
    self.loadingbar_point3 = self.root.Node_1.bg_export.LoadingBar_bg.loadingbar_point3_export
    self.loadingbar_point2 = self.root.Node_1.bg_export.LoadingBar_bg.loadingbar_point2_export
    self.point1 = self.root.point1_export
    self.point2 = self.root.point2_export
    self.point3 = self.root.point3_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:box_one_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_1_0, function(sender, eventType) self:box_two_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Button_4, function(sender, eventType) self:box_three_click(sender, eventType) end)
--EXPORT_NODE_END

    
    global.tools:adjustNodePosForFather(self.my_point:getParent() , self.my_point)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
-- t] -     2 = {
-- [LUA-print] -         "activity_id" = 14001
-- [LUA-print] -         "id"          = 5
-- [LUA-print] -         "num"         = 0
-- [LUA-print] -         "point"       = 300
-- [LUA-print] -         "reward"      = 100031
-- [LUA-print] -     }
-- [LUA-print] -     3 = {
-- [LUA-print] -         "activity_id" = 14001
-- [LUA-print] -         "id"          = 6
-- [LUA-print] -         "num"         = 0
-- [LUA-print] -         "point"       = 1000
-- [LUA-print] -         "reward"      = 100030
-- [LUA-print] -     }

function UIActivityPointNode:setData(data)
    self.data = data 
    if  not self.data or  #self.data~=3  then return end 
    table.sort(self.data , function(A ,B) return A.point < B.point end )
   
    self.loadingbar_point1:setPercent(0)
    self.loadingbar_point2:setPercent(0)
    self.loadingbar_point3:setPercent(0)


    if self.data[1].activity_id == 11001 then 
        self.point_title:setString(global.luaCfg:get_local_string(10930))
    else 
        self.point_title:setString(global.luaCfg:get_local_string(10931))
    end 

    self.bg:loadTexture(global.luaCfg:get_activity_by(self.data[1].activity_id).banner, ccui.TextureResType.plistType)

    global.ActivityAPI:ActivityListReq({self.data[1].activity_id}, function (ret,msg)
        if msg and msg.tagAct  then 
            self.my_point_a = msg.tagAct[1].lParam or  0 
            if self.updateUI then
                self:updateUI()
            end
        end 
    end)
end 


function UIActivityPointNode:updateUI()
    my_point = self.my_point_a
    self.my_point:setString(my_point)
    self.point1:setString(self.data[1].point)
    self.point2:setString(self.data[2].point)
    self.point3:setString(self.data[3].point)

    self.loadingbar_point1:setPercent(0)
    self.loadingbar_point2:setPercent(0)
    self.loadingbar_point3:setPercent(0)

    if my_point <= self.data[1].point then 
        self.loadingbar_point1:setPercent(my_point / self.data[1].point * 100 )
    elseif my_point > self.data[1].point and my_point <= self.data[2].point then 
        self.loadingbar_point1:setPercent(100)
        my_point = my_point - self.data[1].point 
        self.loadingbar_point2:setPercent(my_point / (self.data[2].point - self.data[1].point  ) * 100 )
    elseif  my_point > self.data[2].point then 
        self.loadingbar_point1:setPercent(100)
        self.loadingbar_point2:setPercent(100)
         my_point = my_point - self.data[2].point
        self.loadingbar_point3:setPercent(my_point / (self.data[3].point -self.data[2].point) * 100 )
    end 


    global.tools:adjustNodePosForFather(self.my_point:getParent() , self.my_point)
    
end 

function UIActivityPointNode:onExit()

end 

function UIActivityPointNode:onEnter()

end 

function UIActivityPointNode:box_three_click(sender, eventType)
     self:showGifPanel(3)
end

function UIActivityPointNode:box_two_click(sender, eventType)
    self:showGifPanel(2)
end

function UIActivityPointNode:box_one_click(sender, eventType)
    self:showGifPanel(1)
end


function UIActivityPointNode:showGifPanel(index)
    local activity_data = clone(global.luaCfg:get_activity_by(self.data[index].activity_id))
    activity_data.reward = self.data[index].reward
    local panel = global.panelMgr:openPanel("UINormalRewardPanel")
    panel:setData(activity_data)
    
end 
--CALLBACKS_FUNCS_END

return UIActivityPointNode

--endregion
