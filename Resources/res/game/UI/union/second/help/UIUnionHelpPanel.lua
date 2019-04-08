--region UIUnionHelpPanel.lua
--Author : zzl
--Date   : 2017/12/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionHelpPanel  = class("UIUnionHelpPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIUnionHelpItemCell = require("game.UI.union.second.help.UIUnionHelpItemCell")
local UIUnionHelpRecordCell = require("game.UI.union.second.help.UIUnionHelpRecordCell")

function UIUnionHelpPanel:ctor()
    self:CreateUI()
end

function UIUnionHelpPanel:CreateUI()
    local root = resMgr:createWidget("union/union_help_bj")
    self:initUI(root)
end

function UIUnionHelpPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_help_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.titleNode = self.root.titleNode_export
    self.tb_top_node = self.root.tb_top_node_export
    self.tb_bottom_node = self.root.tb_bottom_node_export
    self.tb_item_content_size = self.root.tb_item_content_size_export
    self.tb_content_size = self.root.tb_content_size_export
    self.tb2_bottom_node = self.root.tb2_bottom_node_export
    self.tb2_top_node = self.root.tb2_top_node_export
    self.tb2_item_content_size = self.root.tb2_item_content_size_export
    self.tb2_content_size = self.root.tb2_content_size_export
    self.tb_add_node = self.root.tb_add_node_export

    uiMgr:addWidgetTouchHandler(self.root.btn_bj.change, function(sender, eventType) self:refreshHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.titleNode.esc, function(sender, eventType) 
        global.panelMgr:closePanel("UIUnionHelpPanel")
    end)

    self.tableView = UITableView.new()
        :setSize(self.tb_content_size:getContentSize(), self.tb_top_node ,self.tb_bottom_node)
        :setCellSize(self.tb_item_content_size:getContentSize())
        :setCellTemplate(UIUnionHelpItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add_node:addChild(self.tableView)


    self.tableView2 = UITableView.new()
        :setSize(self.tb2_content_size:getContentSize(), self.tb2_top_node ,self.tb2_bottom_node)
        :setCellSize(self.tb2_item_content_size:getContentSize())
        :setCellTemplate(UIUnionHelpRecordCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add_node:addChild(self.tableView2)

    self:adapt()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionHelpPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))

end 

function UIUnionHelpPanel:onEnter()


    self:addEventListener(global.gameEvent.EV_ON_UNION_HELP_REFRESH ,function () 
        self:setData()
    end)

    self:reFresh()
    -- self:setData()

    self.m_eventListenerCustomList = {}
end 

function UIUnionHelpPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end 

function UIUnionHelpPanel:reFresh(stay)

    global.unionData:setNumberBuildState(false)

    global.unionApi:HelpList(function (msg) 

        if self.setData then 
            self:setData(msg ,stay)
        end 

    end)

end 

function UIUnionHelpPanel:setData(msg ,stay)

    -- message BuildHelp
-- {
--     required int32      lUserID = 1;    //发起人 ID
--     required int32      lBuildID = 2;   //建筑ID
--     required int32      lBuildLV = 3;   //建筑等级
--     required int32      lCountLimit = 4; //当前进度
--     required int32      lEndTime = 5;   //发起帮助的时间
--     optional int32      lBUserID = 6;   //被帮人 ID

--     required int32      lCount = 8;     //总进度
--     optional int32      lStale = 8;     //我是否帮助过
--     optional int32      lUserName = 6;  //帮助名字
--     optional int32      lUserHead = 6;  //帮助人头像
--     optional int32      lUserHeadFrame = 6;  //帮助人头像框
--     optional int32      lBUserName = 6;  //被帮助人Name
-- }
    
    -- local t1 ={
    --     lBuildID =1 ,
    --     lBuildLV =23 ,
    --     lCountLimit =4 ,
    --     lEndTime =global.dataMgr:getServerTime() - 60*60*3 ,
    --     lCount = 10,
    --     lStale = 0,
    --     lUserName = "test1",
    --     lUserHead = 320,
    --     lUserHeadFrame = 2,
    -- }

    -- local t2 ={
    --     lBuildID =2 ,
    --     lBuildLV =14 ,
    --     lCountLimit = 10 ,
    --     lEndTime =global.dataMgr:getServerTime() -60*60*24*2 ,
    --     lCount = 30,
    --     lStale = 1,
    --     lUserName = "test123",
    --     lUserHead = 323,
    --     lUserHeadFrame = 2,
    -- }

    -- local data1 = {t1 , t2} 
    -- msg = {}
    -- msg.tagHelp =data1

   
    -- local t3 ={
    --     lBuildID =2 ,
    --     lBuildLV =14 ,
    --     lEndTime =global.dataMgr:getServerTime() -100 ,
    --     lUserName = "test1",
    --     lUserHead = 320,
    --     lUserHeadFrame = 2,
    --     lBUserName = "下23sd"
    -- }

    -- local t4 ={
    --     lBuildID =2 ,
    --     lBuildLV =14 ,
    --     lEndTime =global.dataMgr:getServerTime() -100 ,
    --     lUserName = "test123",
    --     lUserHead = 323,
    --     lUserHeadFrame = 2,
    --     lBUserName = "下23s232d"
    -- }

    -- local data233 ={t3 ,t4 }
    -- msg.tagHelpLog = data233

    self.data = msg

    table.sort(msg.tagHelpLog or {}  , function(A,B)
        return A.lAddTime > B.lAddTime
    end)

       table.sort(msg.tagHelp or {} , function(A,B)
        return A.lAddTime > B.lAddTime
    end)

    self.helpData = {} 


    for _ ,v in ipairs(self.data.tagHelp or {} ) do 

        if v.lEndTime > global.dataMgr:getServerTime() and (v.lCountLimit > v.lCount) and (not self:isExistLatest(self.data.tagHelp , v)) then 

            table.insert(self.helpData   , v )

        end 
    end 

    -- dump(self.helpData ,"first data ")

    if table.nums(self.helpData) == 0 then --补丁 校正 红点

        global.unionData:setInUnionRed(10, 0)

        global.userData:updatelAllyRedCount({lID=12 , 0})
    end 

    self.tableView:setData(self.helpData ,stay)

    self.tableView2:setData(msg.tagHelpLog or {} ,stay)


    -- 下载用户头像
    if msg.tgMember then
        local data = {}
        for i,v in pairs(msg.tgMember) do
            if v.szCustomIco ~= "" then
                table.insert(data,v.szCustomIco)
            end
        end
        local storagePath = global.headData:downloadPngzips(data)
        table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
            -- body
            if self and not tolua.isnull(self.tableView) then
                self.tableView:setData(self.tableView:getData(),true)
            end
        end))
    end

    global.netRpc:delHeartCall(self)     

    global.netRpc:addHeartCall(function () 

       if not self.helpData then 
            global.netRpc:delHeartCall(self)        
            return 
        end  

        local flg = false 

        for _ ,v in ipairs(self.helpData or {} ) do 

            if v.lEndTime < global.dataMgr:getServerTime() then 
                flg = true 
            end  
        end 

        if flg then 

            local tempData = {} 
            for _ ,v in ipairs(self.helpData or {} ) do 
                if v.lEndTime > global.dataMgr:getServerTime() then 
                    table.insert(tempData   , v )
                end 
            end 
            self.tableView:setData(tempData ,stay)
            self.helpData = tempData
        end 

    end,self)



    -- 下载用户头像
    local data = {}
    if self.helpData then
        for i,v in pairs(self.helpData) do
            if v.szCustomIco ~= "" then
                table.insert(data,v.szCustomIco)
            end
        end
    end

    if msg.tagHelpLog then
        for i,v in pairs(msg.tagHelpLog) do
            if v.szCustomIco ~= "" then
                table.insert(data,v.szCustomIco)
            end
        end
    end
    local storagePath = global.headData:downloadPngzips(data)
    table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
        -- body
        if self and not tolua.isnull(self.tableView) then
            self.tableView:setData(self.tableView:getData(),true)
        end
    end))
end 


--  = {
-- [LUA-print] -         "lAddTime"       = 1513574093
-- [LUA-print] -         "lBUserID"       = 0
-- [LUA-print] -         "lBindID"        = 1
-- [LUA-print] -         "lBindParam"     = 4
-- [LUA-print] -         "lCount"         = 0
-- [LUA-print] -         "lCountLimit"    = 1
-- [LUA-print] -         "lEndTime"       = 1513575863
-- [LUA-print] -         "lID"            = 19
-- [LUA-print] -         "lQID"           = 1
-- [LUA-print] -         "lUserHead"      = 108
-- [LUA-print] -         "lUserHeadFrame" = 1
-- [LUA-print] -         "lUserID"        = 2000164
-- [LUA-print] -         "szUserName"     = "Mareon

function UIUnionHelpPanel:isExistLatest(data ,value)

    for _ , v in ipairs(data or {} ) do 

        if v.lUserID  == value.lUserID and  v.lQID == value.lQID  and v.lAddTime > value.lAddTime then 

            return true 
        end 
    end 

    return false 
end 

function UIUnionHelpPanel:onExit()

    self.tableView:setData({})
    self.tableView2:setData({})

    global.netRpc:delHeartCall(self)     

end 


function UIUnionHelpPanel:cleanUserCD(id , time , count)

    -- for _ ,v in ipairs(self.helpData) do 
    --     if v.lUserID == global.userData:getUserId() and v.lQID == id  then 
    --         if time then 
    --             v.lEndTime = time
    --         end 
    --         if count then 
    --             v.lCount  = count
    --         end 
    --     end 
    -- end

end 

function UIUnionHelpPanel:refreshHandler(sender, eventType)

    if not self.helpData then 
        return 
    end 

    local arr = {} 
    for _ ,v in ipairs(self.helpData or {} ) do 
        if not v.lStale and v.lUserID ~= global.userData:getUserId() then 
            table.insert(arr , v.lID)
        end 
    end 
    if # arr> 0 then 
        global.unionApi:helpBuild(arr , function (msg) 

            local add  = ""
            if msg and msg.tgItem then 

                for _ , v in pairs(msg.tgItem) do 
                    local item = global.luaCfg:get_item_by(v.lID)
                    add = add .. item.itemName
                    add = add .."+".. v.lCount
                end 
            end 

            gevent:call(gsound.EV_ON_PLAYSOUND,"ui_unionhelpothers")
            global.tipsMgr:showWarning("union_help02", add)
            global.panelMgr:closePanel("UIUnionHelpPanel") 

        end)
    else
        
        global.tipsMgr:showWarning("union_help04")

    end 
end

--CALLBACKS_FUNCS_END

return UIUnionHelpPanel

--endregion
