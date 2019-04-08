--region UIActivityDetailNode.lua
--Author : anlitop
--Date   : 2017/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIActivityDetailNode  = class("UIActivityDetailNode", function() return gdisplay.newWidget() end )
-- local btns = {

--     [3] = {btn = "score",callback = "gotoScore"},   --积分奖励
--     [2] = {btn = "scoreRule",callback = "gotoScoreRule"},    --积分规则
--     [3] = {btn = "sortReward",callback = "gotoSortReward"},      --排名奖励
--     [4] = {btn = "lookRank",callback = "gotoLookRank"},    --查看排名
--     [1] = {btn = "lookReward",callback = "gotoLookReward"},   --积分奖励
-- }

function UIActivityDetailNode:ctor()
    self:CreateUI()
end

function UIActivityDetailNode:CreateUI()
    local root = resMgr:createWidget("activity/activity_detail_node")
    self:initUI(root)
 end

function UIActivityDetailNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_detail_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_node = self.root.Node_1.btn_node_export
    self.ScrollView_1 = self.root.Node_1.ScrollView_1_export
    self.desc_text = self.root.Node_1.ScrollView_1_export.desc_text_export
    self.reward_btn = self.root.Node_1.reward_btn_export
    self.point = self.root.Node_1.point_export
    self.btn_rank_1 = self.root.Node_1.btn_rank_1_export

    uiMgr:addWidgetTouchHandler(self.reward_btn, function(sender, eventType) self:militaryHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.point, function(sender, eventType) self:point_Handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_rank_1, function(sender, eventType) self:showRankClick(sender, eventType) end)
--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIActivityDetailNode:setData(data)
    self.data= data
    -- if not self.data then return end 
    self:updateUI()
end 

function UIActivityDetailNode:updateUI()

    self.point:setVisible(false) -- 是否有积分

    self.btn_rank_1:setVisible(false)

    self.reward_btn:setVisible(false)

 
    -- local textH = 0 
    -- self.desc_text:setTextAreaSize(cc.size(self.desc_text:getContentSize().width,0))
    -- self.desc_text:setString(luaCfg:get_local_string(self.data.desc))
    -- local label = self.desc_text:getVirtualRenderer()
    -- local desSize = label:getContentSize()
    -- self.desc_text:setContentSize(desSize)
    -- textH= self.desc_text:getContentSize().height+100
    -- self.ScrollView_1:setInnerContainerSize(cc.size(self.desc_text:getContentSize().width,textH))
    -- self.desc_text:setPositionY(textH)
    -- self.ScrollView_1:jumpToTop()


    uiMgr:setRichText(self, "desc_text", self.data.desc)

    local size = self.desc_text:getRichTextSize()

    self.ScrollView_1:setInnerContainerSize(cc.size(size.width,size.height))

    if size.height <  self.ScrollView_1:getContentSize().height then 
        self.desc_text:setPositionY(self.ScrollView_1:getContentSize().height - 15 )
    else 
        self.desc_text:setPositionY(size.height)
    end 

    self.ScrollView_1:jumpToTop()

    local btnCount = #self.data.btn

    print(btnCount,"btnCount")

    local btnNode = resMgr:createWidget("activity/activity_btns/btn_" .. btnCount)
    self.btn_node:removeAllChildren()
    self.btn_node:addChild(btnNode)

    uiMgr:configUITree(btnNode)

    -- dump(self.data.btn)
    -- dump(btnNode)
    for index, panel_index in pairs(self.data.btn) do

        print(panel_index ,  "panel_index ////////")

        local btn = btnNode["btn_" .. index]

        local btn_item =luaCfg:get_btn_by(self.data.btn[index])

        btn.text:setString(btn_item.name)

        btn:loadTextures(btn_item.pic,btn_item.pic,nil,ccui.TextureResType.plistType)

        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType) 
            -- print(sender.text:getString())

            print(panel_index ,  "panel_index ////////")

            local panels = {

                [1] = "UINormalRewardPanel",
                [2] = "UIActivityRankPanel",
                [3] = "UIActivityPointPanel",
                [4] = "UIActivityRankPanel",
                [5] = "UIActivityRankPanel",
                [6] = "UIRankInfoPanel",
                [7] = "UIRegisterPanel",
                [8] = "UIActivityRulePanel", 
                [9] = "UIAccRechargePanel",
                [10] = "UIBagPanel", 
                [11] = "UILevelUpRewordPanel",                 
            }

            global.panelMgr:closePanel("UIActivityDetailPanel")  

            if panel_index  == 6  then 
                if self.data.activity_id  == 11001 or self.data.activity_id== 13001 or  self.data.activity_id== 14001 then 
                    for _ ,v in pairs(global.luaCfg:activity_rank()) do
                        if v.activity_id == self.data.activity_id then 
                            local  panel =  global.panelMgr:openPanel("UIRankInfoPanel")
                            panel:setActvityData(v)
                            return 
                        end 
                    end 
                end 
                 if  self.data.reward_window == 21 then --  领主等级活动
                    local data = global.luaCfg:get_rank_by(5)
                    global.panelMgr:openPanel("UIRankInfoPanel"):setData(data)
                    return 
                elseif  self.data.reward_window == 22 then --城堡活动   
                    local data = global.luaCfg:get_rank_by(7)
                    global.panelMgr:openPanel("UIRankInfoPanel"):setData(data)
                    return 
                end
            elseif  panel_index == 10  then 
                local  activity = global.ActivityData:getCurrentActivityData(2 , 8001)
                if activity then 
                    if activity.serverdata and activity.serverdata.lStatus==1 then 
                         local panel = global.panelMgr:openPanel(panels[panel_index])
                         panel:onTopButtonChanged(3)
                    else 
                        global.tipsMgr:showWarning("activity_not_open")
                    end  
                else 
                    global.tipsMgr:showWarning("activity_not_open")
                end 
               
            else 

                local panel = global.panelMgr:openPanel(panels[panel_index])

                panel:setData(self.data)

            end 

        end)
    end
     -- 普通文本    
    -- local textH = 0 
    -- self.desc_text:setTextAreaSize(cc.size(self.desc_text:getContentSize().width,0))
    -- self.desc_text:setString(self.data.desc)
    -- local label = self.desc_text:getVirtualRenderer()
    -- local desSize = label:getContentSize()
    -- self.desc_text:setContentSize(desSize)
    -- textH= self.desc_text:getContentSize().height+100
    -- self.ScrollView_1:setInnerContainerSize(cc.size(self.desc_text:getContentSize().width,textH))
    -- self.desc_text:setPositionY(textH)
    -- self.ScrollView_1:jumpToTop()

    -- print("是否是积分",global.ActivityData:isPointActiviy(self.data.activity_id))
    -- print("是否是rank",global.ActivityData:isRankActiviy(self.data.activity_id))
    -- print(global.ActivityData:isRankActiviy(self.data.activity_id),"what the fuck")


    -- self.needShow = {}


    -- self.reward_btn:setVisible(true)
    -- if global.ActivityData:isPointActiviy(self.data.activity_id) then -- 积分 
    --     self.point:setVisible(true)
    --     if global.ActivityData:isRankActiviy(self.data.activity_id) then --排行
    --         self.btn_rank_1:setVisible(true)
    --         self.point:setPosition(self.ps_node_1:getPosition())
    --         self.reward_btn:setPosition(self.ps_node_3:getPosition())
    --         self.btn_rank_1:setPosition(self.ps_node_5:getPosition())
    --     else
    --         self.reward_btn:setPosition(self.ps_node_2:getPosition())
    --         self.point:setPosition(self.ps_node_4:getPosition())
    --     end 
    -- else
    --     if global.ActivityData:isRankActiviy(self.data.activity_id) then -- 排行
    --         self.btn_rank_1:setVisible(true)
    --         self.reward_btn:setPosition(self.ps_node_2:getPosition())
    --         self.btn_rank_1:setPosition(self.ps_node_4:getPosition())
    --     else 
    --         self.reward_btn:setPosition(self.ps_node_3:getPosition())
    --     end  
    -- end

     -- 1 ：
     -- 2 ：
end 

-- function UIActivityDetailNode:initBtns()
--     -- 1 :
--     local btnRes = {}
--     for _,v in ipairs(btns) do
--         if self[v.target](self) then
--             table.insert(btnRes)
--         end 
--     end


--     -- btn1.csb  btn2.csb   btn3.csb   btn4.csb btn5.csb
--     local btnCount = #btnRes
--     local btnNode = resMgr:createWidget("activity/activity_btns/btn_" .. btnCount)
--     uiMgr:configUITree(btnNode)
    
--     for index,v in ipairs(btnRes) do

--         btnNode["button_" .. index]:setTitleString(v.btn)
--         --加建厅
--         addBtnListener(btnNode["button_" .. index],function()
--             self[v.callback](self)
--         end)
--     end
--     self.node_13:addChild(btnNode)
-- end

-- function UIActivityDetailNode:gotoSortReward()

--     local panel = global.panelMgr:openPanel("UIActivityRankPanel")
--     panel:setData(self.data)
-- end

-- function UIActivityDetailNode:gotoLookRank()
    
--     local panel = global.panelMgr:openPanel("UIRankInfoPanel")
--     panel:setData(self.data)
-- end

-- function UIActivityDetailNode:gotoLookReward()
    
--     local panel = global.panelMgr:openPanel("UIRankInfoPanel")
--     panel:setData(self.data)
-- end

-- function UIActivityDetailNode:gotoScoreRule()

--     local panel = global.panelMgr:openPanel("UIActivityRulePanel")
--     panel:setData(self.data)
-- end

-- function UIActivityDetailNode:gotoScore()

--     local panel = global.panelMgr:openPanel("UIActivityPointPanel")
--     panel:setData(self.data)
-- end

-- function UIActivityDetailNode:point_Handler(sender, eventType)
    

--     global.panelMgr:closePanel("UIActivityDetailPanel")  
--     local panel = global.panelMgr:openPanel("UIActivityRulePanel") 
--     panel:setData(self.data)
-- end
 
-- function UIActivityDetailNode:militaryHandler(sender, eventType)
--     global.panelMgr:closePanel("UIActivityDetailPanel")  
--     dump(self.data)
    
--     -- local window_type = "" 
--     if self.data.reward_window == 1  then 
--         window_type = "UINormalRewardPanel"
--     -- elseif self.data.reward_window == 2 then 
--     --     window_type = "UINormalRewardPanel"
--     elseif self.data.reward_window == 3 then
--         window_type = "UIActivityRankPanel"
--     elseif self.data.reward_window == 4 then
--         window_type = "UIActivityPointPanel"
--     elseif self.data.reward_window == 5 then
--         window_type = "UIRankAndPointPanel"
--     elseif self.data.reward_window == 6 then -- 绛惧埌
--          local register =global.dailyTaskData:getTagSignInfo()
--         global.panelMgr:openPanel("UIRegisterPanel"):setData(register)
--         return 
--     elseif self.data.reward_window == 21 then --闋樹富 
--         window_type = "UIActivityRankPanel"
--     elseif self.data.reward_window == 22 then -- 鍩庡牎
--         window_type = "UIActivityRankPanel"
--     end 

--     local panel = global.panelMgr:openPanel(window_type)
--     panel:setData(self.data)
-- end


-- function UIActivityDetailNode:showRankClick(sender, eventType)
--     global.panelMgr:closePanel("UIActivityDetailPanel")  

--     if self.data.serverdata.lStatus ~= 1 then 
--         global.tipsMgr:showWarning("活动暂未开放")
--         return 
--     end 

--     if global.ActivityData:isRankActiviy(self.data.activity_id) then 
--          if  self.data.reward_window == 21 then --  领主等级活动
--             local data = global.luaCfg:get_rank_by(5)
--             global.panelMgr:openPanel("UIRankInfoPanel"):setData(data)
--             return 
--         elseif  self.data.reward_window == 22 then --城堡活动   
--             local data = global.luaCfg:get_rank_by(7)
--             global.panelMgr:openPanel("UIRankInfoPanel"):setData(data)
--             return 
--         end
--         for _ ,v in pairs(global.luaCfg:activity_rank()) do
--             if v.activity_id == self.data.activity_id then 
--                 local  panel =  global.panelMgr:openPanel("UIRankInfoPanel")
--                 panel:setActvityData(v)
--                 return 
--             end 
--         end
--     end  
-- end
--CALLBACKS_FUNCS_END

return UIActivityDetailNode

--endregion
