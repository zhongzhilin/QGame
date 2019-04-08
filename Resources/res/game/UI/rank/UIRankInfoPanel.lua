--region UIRankInfoPanel.lua
--Author : yyt
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRankInfoPanel  = class("UIRankInfoPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIRankInfoCell = require("game.UI.rank.UIRankInfoCell")

function UIRankInfoPanel:ctor()
    self:CreateUI()
end

function UIRankInfoPanel:CreateUI()
    local root = resMgr:createWidget("rank/rank_2nd_bg")
    self:initUI(root)
end

function UIRankInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rank/rank_2nd_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.rankTitle = self.root.title_export.rankTitle_fnt_mlan_15_export
    self.node_table = self.root.node_table_export
    self.rankMineNone = self.root.rankMineNone_export
    self.none = self.root.rankMineNone_export.none_mlan_12_export
    self.rankMineHave = self.root.rankMineHave_export
    self.all_combat = self.root.rankMineHave_export.all_combat_export
    self.noRank = self.root.rankMineHave_export.noRank_export
    self.icon = self.root.rankMineHave_export.icon_export
    self.ownValue = self.root.rankMineHave_export.ownValue_export
    self.up_node = self.root.rankMineHave_export.up_node_export
    self.up_num = self.root.rankMineHave_export.up_node_export.up_num_export
    self.down_node = self.root.rankMineHave_export.down_node_export
    self.down_num = self.root.rankMineHave_export.down_node_export.down_num_export
    self.nochange_node = self.root.rankMineHave_export.nochange_node_export
    self.portrait_node = self.root.rankMineHave_export.portrait_node_export
    self.headFrame = self.root.rankMineHave_export.portrait_node_export.headFrame_export
    self.name = self.root.rankMineHave_export.name_export
    self.bottomNode = self.root.bottomNode_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.topNode = self.root.topNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIRankInfoCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_table:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRankInfoPanel:onEnter()
    self.m_eventListenerCustomList = {}
    if  not  self.isActivity then  
        self:addEventListener(global.gameEvent.EV_ON_UNION_JOIN, function ()
            self:refresh(self.data.id+3, false)
        end) 
    end 

end

function UIRankInfoPanel:onExit()
    self.isActivity = nil 
    self.icon:setVisible(true)
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end 

-------------------------------------------------活动系统
function UIRankInfoPanel:setActvityData(data)

    self.isActivity  =true 
    self.activity_data = data 
    self.data = data
    if not  self.activity_data then return end 
    if not tolua.isnull(self.star) then
        self.star:setVisible(false)
    end
    self.nochange_node:setVisible(false)
    self.up_node:setVisible(false)
    self.down_node:setVisible(false)
    self.all_combat:setString("")
    self.ownValue:setString("")                                                   
    self.name:setString("")
--   self.icon:setSpriteFrame(data.icon)
    self.rankTitle:setString(data.name)
    self:refreshActivityData(true)
end 
--掠夺

-- t] - "<var>" = {
-- [LUA-print] -     "tagItem" = {
-- [LUA-print] -         1 = {
-- [LUA-print] -             "lFindID"  = 3000060
-- [LUA-print] -             "lRank"    = 1
-- [LUA-print] -             "lValue"   = 150
-- [LUA-print] -             "szParams" = {
-- [LUA-print] -                 1 = "6"
-- [LUA-print] -                 2 = "MVP"
-- [LUA-print] -                 3 = "MVP"
-- [LUA-print] -             }
-- [LUA-print] -         }
-- [LUA-print] -     }
-- [LUA-print] - }
--   100 = {
-- [LUA-print] -             "lFindID"  = 3000236
-- [LUA-print] -             "lRank"    = 100
-- [LUA-print] -             "lValue"   = 6142
-- [LUA-print] -             "szParams" = {
-- [LUA-print] -                 1 = "3000236"
-- [LUA-print] -                 2 = "4"
-- [LUA-print] -                 3 = "000"
-- [LUA-print] -                 4 = "000000"
-- [LUA-print] -                 5 = "0"
-- [LUA-print] -             }
-- [LUA-print] -         }
-- --   }

function UIRankInfoPanel:refreshActivityData(flag)
    global.ActivityAPI:ActivityRankReq( self.activity_data.activity_id,0,self.activity_data.rankNum,function (ret, msg)
        local data = msg.tagItem or {}
        if   self.data.type == 1 then 
            for _ , v in pairs(data) do 
                v.szParams = v.szParams or {}
                v.szParams[5] =v.szParams[5] or "0"
                v.szParams[4] = v.szParams[3]
                v.szParams[3] = v.szParams[2]
                v.szParams[2] = v.szParams[1]
                v.szParams[1] = v.lFindID
            end 
        end
        self.tableView:setData(self:getRankData(data))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
        self:initMineActivity(data)
        if flag then self:cellAnimation() end
    end)
end
---------------------------------------------------



function UIRankInfoPanel:setData(data)

    self.data = data
    self.nochange_node:setVisible(false)
    self.up_node:setVisible(false)
    self.down_node:setVisible(false)

    self.all_combat:setString("")
    self.ownValue:setString("")
    self.name:setString("")
    -- self.icon:setSpriteFrame(data.icon)

    if not tolua.isnull(self.star) then
        self.star:setVisible(false)
    end
    self.icon:setVisible(true)
    if data.id == 11 then
        self.icon:setVisible(false)
    else
        global.panelMgr:setTextureFor(self.icon,data.icon)
    end

    self.rankTitle:setString(data.name)

    self:refresh(data.id+3, true)
end

function UIRankInfoPanel:refresh(index, flag)

    global.unionApi:getUserRankList(function(msg)
        -- body
        local data = msg.tgRankItems or {}
        if not tolua.isnull(self.tableView) then 
            self.tableView:setData(self:getRankData(data))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
        end 
        if self.initMine then
            self:initMine(data)
        end
        if flag then self:cellAnimation() end

    end, index)
end

function UIRankInfoPanel:getRankData(data)
    
    local rank = {}
    for _,v in pairs(data) do
        if v.lRank <= (#data) and v.lRank > 0 then
            table.insert(rank, v)
        end
    end
    table.sort(rank, function(s1, s2) return s1.lRank < s2.lRank end )


    -- 下载用户头像
    local data1 = {}
    for i,v in pairs(data) do
        if v.szCustomIco ~= "" then
            table.insert(data1,v.szCustomIco)
        end
    end
    local storagePath = global.headData:downloadPngzips(data1)
    table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
        -- body
        if self and not tolua.isnull(self.tableView) then
            self.tableView:setData(self.tableView:getData(),true)
        end
    end))
    return  rank
end

function UIRankInfoPanel:initMine(msg)

    self.ownValue:setVisible(true)
    self.rankMineNone:setVisible(false)
    self.rankMineHave:setVisible(false)
    if not tolua.isnull(self.flagNode) then
        self.flagNode:setVisible(false)
    end
    self.portrait_node:setVisible(false)
    self.all_combat:setVisible(false)
    self.noRank:setVisible(false)

    local mData = self:getMineData(msg, self.data.type)


    dump(mData,"mData data ///////////////////")

    -- 联盟
    if self.data.type == 1 then
        
        if not global.chatData:isJoinUnion() then
            self.rankMineNone:setVisible(true)  
            self.none:setString(global.luaCfg:get_local_string(10797))
        else
            self.rankMineHave:setVisible(true)
    
            if mData then 

                if not self.flagNode then
                    self.flagNode = require("game.UI.union.widget.UIUnionFlagWidget").new()
                    self.flagNode:CreateUI()
                    self.flagNode:setPosition(cc.p(252, 42))
                    self.flagNode:setScale(0.25)
                    self.rankMineHave:addChild(self.flagNode)                    
                end
                self.flagNode:setVisible(true)
                self.flagNode:setData(tonumber(mData.szParams[2]))

                if mData.lRank <= 0 then 
                    self.noRank:setVisible(true)
                else
                    self.all_combat:setVisible(true)
                    self.all_combat:setString(mData.lRank)
                end
                self.ownValue:setString(mData.lValue)
                self:checkRank(mData.szParams[5], mData.lRank)
                local szShortName = global.unionData:getUnionShortName(mData.szParams[3])
                self.name:setString(string.format("%s%s",szShortName,mData.szParams[4]))
            end

        end 
        
    else

        self:setHeadFrame()

        self.rankMineHave:setVisible(true)
        self.portrait_node:setVisible(true)
        -- 头像
        if self.data.id ~= 8 and self.data.id ~= 11 then 
            global.tools:setCircleAvatar(self.portrait_node, global.headData:getCurHead())
        end

        if mData then
            if mData.lRank <= 0 then 
                self.noRank:setVisible(true)
            else
                self.all_combat:setVisible(true)
                self.all_combat:setString(mData.lRank)
            end


            self.ownValue:setString(mData.lValue)
            self.name:setString(global.userData:getUserName())

            mData.szParams = mData.szParams or {}
            self:checkRank(mData.szParams[3] or 0, mData.lRank)

            if self.data.id == 8 then -- 英雄排行榜
                local headAll = global.luaCfg:rolehead()
                for _,v in pairs(headAll) do
                    if v.triggerId == tonumber(mData.szParams[1] or 0) then
                        global.tools:setCircleAvatar(self.portrait_node, v) 
                        break
                    end
                end
                local heroData = global.luaCfg:get_hero_property_by(tonumber(mData.szParams[1] or 0))
                self.name:setString(heroData.name)
            
            elseif self.data.id == 11 then 

                self.ownValue:setVisible(false)
                self.icon:setVisible(false)

                if not self.star then
                    self.star = require("game.UI.rank.UIRankInfoStar").new()                    
                    self.root:addChild(self.star)
                    self.star:setPosition(cc.p(419, gdisplay.height-200))
                end
                self.star:setVisible(true)
                self.star:setData(mData)

                local head = {}
                local petConfig = luaCfg:get_pet_type_by(tonumber(mData.szParams[1] or 1))
                local tempPet = global.petData:getPetConfig(tonumber(mData.szParams[1] or 1), mData.lValue)
                head.path = petConfig["iconRank"..tempPet.growingPhase]
                head.scale = 78
                global.tools:setCircleAvatar(self.portrait_node, head) 

            end

        else
            if not tolua.isnull(self.star) then
                self.star:setVisible(false)
            end
            self.rankMineHave:setVisible(false)
            self.portrait_node:setVisible(false)
            self.rankMineNone:setVisible(true)  
            self.none:setString("")
        end

    end



    if mData then 
        if  not self.isActivity and table.hasval({1 , 4 , 8, 13  } , self.data.id) then 
            self.ownValue:setString(global.funcGame:_formatBigNumber(  mData.lValue , 1 ))
        end 
    end 

end


function UIRankInfoPanel:initMineActivity(msg)

    self.rankMineNone:setVisible(false)
    self.rankMineHave:setVisible(false)
    if not tolua.isnull(self.flagNode) then
        self.flagNode:setVisible(false)
    end
    self.portrait_node:setVisible(false)
    self.all_combat:setVisible(false)
    self.noRank:setVisible(false)
    self.icon:setVisible(false)

    local mData = self:getMineData(msg, self.data.type)

    -- 联盟
    if self.data.type == 1 then
        if not global.chatData:isJoinUnion() then
            self.rankMineNone:setVisible(true)  
        else
            self.rankMineHave:setVisible(true)

            if self.data.activity_id == 13001 then  -- 奇迹排行榜
                self.icon:setVisible(true)
                global.panelMgr:setTextureFor(self.icon,"icon/rank/rank_miracle_icon.png")
            end 

            if mData then 
                if not self.flagNode then
                    self.flagNode = require("game.UI.union.widget.UIUnionFlagWidget").new()
                    self.flagNode:CreateUI()
                    self.flagNode:setPosition(cc.p(252, 42))
                    self.flagNode:setScale(0.25)
                    self.rankMineHave:addChild(self.flagNode)                    
                end
                self.flagNode:setVisible(true)
                self.flagNode:setData(tonumber(mData.szParams[2]))

                if mData.lRank <= 0 then 
                    self.noRank:setVisible(true)
                else
                    self.all_combat:setVisible(true)
                    self.all_combat:setString(mData.lRank)
                end
                self.ownValue:setString(mData.lValue)
                self:checkRank(mData.szParams[5], mData.lRank)
                local szShortName = global.unionData:getUnionShortName(mData.szParams[3])
                self.name:setString(string.format("%s%s",szShortName,mData.szParams[4]))
            else 

                local unionData = global.unionData:getInUnion()
                local flagData = global.unionData:getUnionFlagData(unionData.lTotem)
                if flagData and flagData.national ~= "" then
                    if not self.flagNode then
                        self.flagNode = require("game.UI.union.widget.UIUnionFlagWidget").new()
                        self.flagNode:CreateUI()
                        self.flagNode:setPosition(cc.p(252, 42))
                        self.flagNode:setScale(0.25)
                        self.rankMineHave:addChild(self.flagNode)                    
                    end
                    self.flagNode:setVisible(true)
                    self.flagNode:setData(unionData.lTotem)
                else
                    if not tolua.isnull(self.flagNode) then
                        self.flagNode:setVisible(false)
                    end
                end
                self.name:setString(global.unionData:getInUnionName()) 
                self.ownValue:setString("0")

            end 
        end 
        
    else


        self:setHeadFrame()

        if self.data.activity_id == 14001  then  -- 杀怪 
            self.icon:setVisible(true)
            global.panelMgr:setTextureFor(self.icon,"icon/rank/union_battle.png")
        end 

        if self.data.activity_id == 11001  then  --掠夺
            self.icon:setVisible(true)
            global.panelMgr:setTextureFor(self.icon,"icon/rank/union_battle.png")
        end 

        self.rankMineHave:setVisible(true)
        self.portrait_node:setVisible(true)
        -- 头像
        local head = global.headData:getCurHead()
        global.tools:setCircleAvatar(self.portrait_node, head)
        if mData then

            if mData.lRank <= 0 then 
                self.noRank:setVisible(true)
            else
                self.all_combat:setVisible(true)
                self.all_combat:setString(mData.lRank)
            end
            self.ownValue:setString(mData.lValue)
            self.name:setString(global.userData:getUserName())
            self:checkRank(mData.szParams[3], mData.lRank)
        else 

            self.name:setString(global.userData:getUserName()) 
            self.ownValue:setString("0")

        end 
    end
end

function UIRankInfoPanel:getMineData(data, lType)

    local allHeroRank = {}

    for i,v in ipairs(data) do

        if lType == 1 then
            if v.lFindID == global.userData:getlAllyID() then
                return v
            end
        else
            if global.userData:isMine(v.lFindID) then
                if self.data.id == 8 then
                    table.insert(allHeroRank, v)
                else
                    return v
                end
            end
        end
    end

    if self.data.id == 8 then
        if table.nums(allHeroRank) > 0 then
            table.sort(allHeroRank, function (s1, s2) return s1.lValue > s2.lValue  end)
            return allHeroRank[1]
        else
            return nil
        end
    end
end

function UIRankInfoPanel:getInfoData()
    return self.data
end

function UIRankInfoPanel:checkRank(value, rank)
    
    if tonumber(rank) <= 0 then return end
    value = tonumber(value)
    if not value   then return end 

    if value == 0 then
        self.nochange_node:setVisible(true)
    elseif  value > 0 then
        self.up_node:setVisible(true)
        self.up_num:setString(value)
    else
        self.down_node:setVisible(true)
        self.down_num:setString(math.abs(value))
    end


   if  self.isActivity or global.panelMgr:getPanel("UIRankInfoPanel"):getInfoData().id== 13  then 
         self.nochange_node:setVisible(false)
        self.up_node:setVisible(false)
        self.up_num:setVisible(false)
   end 

end

-- cell 出现动画
function UIRankInfoPanel:cellAnimation()

    global.uiMgr:addSceneModel(1)
 
    local allCell = self.tableView:getCells()
    table.sort( allCell, function(a,b)
        -- bod
        return a:getPositionY()>b:getPositionY()
    end )
    local speed = 5000
    for i = 1, #allCell do
        local target = allCell[i]
        if target:getIdx() >= 0 then

            local overCall = function ()
                gsound.stopEffect("city_click")
                gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
            end

            local opacity = 0
            local dt = 0.1*i
            local dy = -dt*speed
            if dy >= -gdisplay.height then
                dy = -gdisplay.height
            end
            local dp = cc.p(0,dy)
            local speedType = nil
            if i >= #allCell then
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            else
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            end
        end
    end
end

function UIRankInfoPanel:setHeadFrame()
    -- self.headFream:setSpriteFrame(global.userheadframedata:getCrutFrame().pic)
    local headInfo = global.userheadframedata:getCrutFrame()
    if headInfo and headInfo.pic then
        global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)
    end
end 


function UIRankInfoPanel:exit_call(sender, eventType)
    self.tableView:setData({})
    global.panelMgr:closePanelForBtn("UIRankInfoPanel")  
end

--CALLBACKS_FUNCS_END

return UIRankInfoPanel

--endregion
