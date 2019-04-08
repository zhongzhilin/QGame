--region UIInvitePanel.lua
--Author : zzl
--Date   : 2018/03/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIInvitePanel  = class("UIInvitePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local TabControl = require("game.UI.common.UITabControl")
local UIInviteItemCell = require("game.UI.invite.UIInviteItemCell")


local luaCfg = global.luaCfg
local json    = require "json"
local crypto  = require "hqgame"
local app_cfg = require "app_cfg"

function UIInvitePanel:ctor()
    self:CreateUI()
end

function UIInvitePanel:CreateUI()
    local root = resMgr:createWidget("invite/invite_panel")
    self:initUI(root)
end

function UIInvitePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "invite/invite_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.black_bg = self.root.Node_export.black_bg_export
    self.bg = self.root.Node_export.bg_export
    self.tab = self.root.Node_export.tab_export
    self.node_1 = self.root.Node_export.node_1_export
    self.line = self.root.Node_export.node_1_export.line_export
    self.code_text = self.root.Node_export.node_1_export.code_text_export
    self.free_btn = self.root.Node_export.node_1_export.free_btn_export
    self.text = self.root.Node_export.node_1_export.free_btn_export.text_mlan_7_export
    self.body_text = self.root.Node_export.node_1_export.body_text_export
    self.node_2 = self.root.Node_export.node_2_export
    self.line = self.root.Node_export.node_2_export.line_export_0
    self.input = self.root.Node_export.node_2_export.input_export
    self.input = UIInputBox.new()
    uiMgr:configNestClass(self.input, self.root.Node_export.node_2_export.input_export)
    self.checkinfo = self.root.Node_export.node_2_export.checkinfo_export
    self.checktips = self.root.Node_export.node_2_export.checkinfo_export.checktips_mlan_6_export
    self.text = self.root.Node_export.node_2_export.free_btn.text_mlan_7_export
    self.node_3 = self.root.Node_export.node_3_export
    self.player_name = self.root.Node_export.node_3_export.player_name_export
    self.player_lv = self.root.Node_export.node_3_export.player_lv_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.Node_export.node_3_export.portrait)
    self.city = self.root.Node_export.node_3_export.city_export
    self.node_4 = self.root.Node_export.node_4_export
    self.noone = self.root.Node_export.node_4_export.noone_mlan_50_export
    self.tab_top1 = self.root.Node_export.tab_top1_export
    self.tab_bot1 = self.root.Node_export.tab_bot1_export
    self.tab_top4 = self.root.Node_export.tab_top4_export
    self.tab_bot4 = self.root.Node_export.tab_bot4_export
    self.tab_add = self.root.Node_export.tab_add_export
    self.tab_content = self.root.tab_content_export
    self.tab_item_conent = self.root.tab_item_conent_export

    uiMgr:addWidgetTouchHandler(self.root.mode, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_btn, function(sender, eventType) self:copyCode(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.node_2_export.free_btn, function(sender, eventType) self:sendCodeClick(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tab_content:getContentSize(), self.tab_top1 , self.tab_bot1)
        :setCellSize(self.tab_item_conent:getContentSize())
        :setCellTemplate(UIInviteItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tab_add:addChild(self.tableView)

    self.tabControl = TabControl.new(self.tab, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--  "invite_code" = "U3NRHXU75"
-- [LUA-print] -     "ret"         = 0

function UIInvitePanel:onEnter()

    self.tabControl:setSelectedIdx(1)
    self:onTabButtonChanged(1)
        
    global.social_invite = clone(global.luaCfg:social_invite())

    self:initInvite()
    self.m_eventListenerCustomList = {}
end 

function UIInvitePanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIInvitePanel:setData()

end 

-- {"account_id":"4010932","svr_id":"4","nick_name":"4010932","face":"103","level":"1"}

local orderKey = {
    "nick_name" , 
    "face",
    "face_bk",
    "level",
    "server_name",
    "svr_id" ,
} 

-- t] -     "account_id"  = "4010934"
-- [LUA-print] -     "face"        = "108"
-- [LUA-print] -     "face_bk"     = "1"
-- [LUA-print] -     "level"       = "1"
-- [LUA-print] -     "nick_name"   = "4010934"
-- [LUA-print] -     "server_name" = "晶晶服"
-- [LUA-print] -     "svr_id"      = "4"
-- [LUA-print] - }

-- 1:一般现在时
-- 2:一般过去式

local inviteKey = "InviteInfo"..tostring(global.userData:getUserId())

function UIInvitePanel:initInvite() --

    local key =inviteKey
    
    local setBtn = function ()
        self.tab.Button_4:setVisible(false) -- 我的邀请人 按钮

        if self:isHaveInvite() then 

            self:setInviteInfo()
            self.tab.Button_4:setVisible(true)
            self.tab.Button_3:setPositionX(1500)
        else
            self.tab.Button_3:setPositionX(self.tab.Button_4:getPositionX())
        end 
    end 

    setBtn()

    self:requestBondinfo(function (request)

        if not request then return end 
        local data = json.decode(request:getResponseData()) or {} 
        if data.ret ~= 0 then 
            return 
        end 
        local responsedata =  {} 
        if data.bindinfo and data.bindinfo[1] then 
            responsedata = data.bindinfo[1]
        end 
        local info = ""
        for _ , v in pairs(orderKey) do 
           responsedata[v] =  responsedata[v] or "##"
            if info == "" then 
                info =  responsedata[v]
            else 
                info = info.."|".. responsedata[v]
            end 
        end 
        cc.UserDefault:getInstance():setStringForKey(key , tostring(info))
        if global.panelMgr:getTopPanelName() == "UIInvitePanel" then 
            setBtn()
        end 
    end)
end 

function UIInvitePanel:isHaveInvite()

    local key =inviteKey

    local code = cc.UserDefault:getInstance():getStringForKey(key , "")

    if not code or code == "" then return false  end 

    return true 
end 

function UIInvitePanel:setInviteInfo()

    local info = {} 

    local key =inviteKey

    local code = cc.UserDefault:getInstance():getStringForKey(key , "")

    if not code or code == "" then return end 

    local id_arr = global.tools:strSplit(code, '|')

    for index , v in pairs(orderKey) do 

        info[v] = id_arr[index] 
    end 

    for key , v in pairs(info) do 
        if info[key] == "##" then 
            info[key] = nil
        end 
    end 

    local str =global.luaCfg:get_translate_string(11148,info.svr_id , info.server_name)
    self.city:setString(str)

    self.player_name:setString(info.nick_name)
    self.player_lv:setString(info.level)

    if info.face  then 
        info.face = tonumber(info.face)
    end 

    if info.face_bk  then 
        info.face_bk = tonumber(info.face_bk)
    end 

    self.portrait:setData(info.face or 409, info.face_bk or 1, info)

end 

function UIInvitePanel:requestBondinfo(call)
    local dictionaryData = clone(global.ServerData:getDictionaryData())
    dictionaryData["code"] = "invitecodebind"
    dictionaryData["account_id"] =global.userData:getUserId()
    global.SimpleHttpAPI:SimpleHttpCall(app_cfg.get_serverlist_url(),app_cfg.server_list_method,dictionaryData,
    "json",function (request)
        if call then 
            call(request)
        end 
    end)
end 

function UIInvitePanel:initCode()

    local key ="InviteCode"..tostring(global.userData:getUserId())
    local setStr = function ()
        local code = cc.UserDefault:getInstance():getStringForKey(key , "")
        self.code_text:setString(code)
    end 
    local code = cc.UserDefault:getInstance():getStringForKey(key , "")

    print(code ,"code-->>>>>>>>>>>>")

    if code and  code ~= ""  then
        setStr()
    else 
        local dictionaryData = clone(global.ServerData:getDictionaryData())
        dictionaryData["code"] = "invitecode"
        dictionaryData["account_id"] =global.userData:getUserId()
        global.SimpleHttpAPI:SimpleHttpCall(app_cfg.get_serverlist_url(),app_cfg.server_list_method,dictionaryData,
        "json",function (request)
            local responsedata = json.decode(request:getResponseData()) 
            cc.UserDefault:getInstance():setStringForKey(key , tostring(responsedata.invite_code))
            setStr()
        end)
    end 

    self.body_text:setString(gls(11144))
end 

local indexMap ={

    [1]= 1,--奖励列表
    [2]= 4,--邀请列表
    [3]= 2,--输入code
    [4]= 3,--我的邀请人
}


function UIInvitePanel:reFreshList()

     global.commonApi:inviteApi(1, nil , nil , function (msg)--1 拉取列表 2 领取奖励 3 绑定code

        -- dump(msg ,"dump ==>>> ")

        if not self.changeMode then return end 

        msg = msg or {} 

        table.traverse(msg.tgTasks or {}  , global.social_invite , function (A , B) 
            if A.lID == B.id then 
                B.serverdata = A
            end 
        end)

        -- dump(global.social_invite ,"social_invite")
        -- dump(msg.tgTasks ,"social_invite")

        if self.index  ==  1  then 
            self.tableView:setData(global.social_invite , true)
        end 
    end)

end 

function UIInvitePanel:onTabButtonChanged(index , isSwitch)

    self.tableView:setData({})

    self.index = indexMap[index] 

    print(self.index ,"UIInvitePanel.index -->>>>.")

    for i= 1,  4  do 
        self["node_"..i]:setVisible(i == self.index )
    end 

    if  self.index  ==  1  then 

        self:changeMode(self["tab_top".. self.index ] , self["tab_bot".. self.index ])

        self:initCode()

        self:reFreshList()

        if isSwitch then 
            self.tableView:setData(global.social_invite)
        end 

    elseif  self.index  ==  4   then 

        self:changeMode(self["tab_top".. self.index ] , self["tab_bot".. self.index ])

        self.noone:setVisible(true)

        local dictionaryData = clone(global.ServerData:getDictionaryData())
        dictionaryData["code"] = "invitecodelist"
        dictionaryData["account_id"] =global.userData:getUserId()
        global.SimpleHttpAPI:SimpleHttpCall(app_cfg.get_serverlist_url(),app_cfg.server_list_method,dictionaryData,
        "json",function (request)
            local responsedata = {}
            if request then
                responsedata = json.decode(request:getResponseData())
            end
            if responsedata.ret ~= 0 then 
                return 
            end 
            if responsedata.dataList and #responsedata.dataList>0 then 
                self.noone:setVisible(false)
            end 
            if self.index == 4 then 
                self.tableView:setData(responsedata.dataList)

                -- 下载用户头像
                if responsedata.dataList then
                    local data = {}
                    for i,v in pairs(responsedata.dataList) do
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
            end 
        end)

    elseif  self.index  ==  3   then 
        self:initInvite()
    
    elseif self.index == 2 then 

        self.checkinfo:setString(global.luaCfg:get_target_condition_by(298).description)
        global.tools:adjustNodePosForFather(self.checkinfo , self.checktips)
    end  
end 


function UIInvitePanel:changeMode( top , bot)

    self.tableView:setSize(self.tab_content:getContentSize(), top , bot)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

end 

function UIInvitePanel:onExit()

end 

function UIInvitePanel:onCloseHanler(sender, eventType)

    global.panelMgr:closePanelForBtn("UIInvitePanel")
end

function UIInvitePanel:copyCode(sender, eventType)
    global.tipsMgr:showWarning("inviteFriend")
    local str =string.format(global.luaCfg:get_translate_string(11146)  , self.code_text:getString())

    print(str ,"str ")
    CCHgame:setPasteBoard(str)
end

function UIInvitePanel:sendCodeClick(sender, eventType)

    if global.funcGame:checkCondition(298) then 
        return  global.tipsMgr:showWarning("inviteFriend3")
    end 

    local string_giftcode = self.input:getString()
    self.input:setString("")
     if string.len(string_giftcode)<=0 then
             global.tipsMgr:showWarning("inviteFriend1")
     else  
        global.commonApi:inviteApi(3, nil , string_giftcode , function (msg)
            if self.initInvite then 
                self:initInvite()
                self:onTabButtonChanged(4)
            end
            global.tipsMgr:showWarning("inviteFriend2")   
        end)
    end     

end
--CALLBACKS_FUNCS_END

return UIInvitePanel

--endregion
