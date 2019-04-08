--region UIMergeSRolePanel.lua
--Author : wuwx
--Date   : 2018/03/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local UIMergeSRoleCell = require("game.UI.Login.UIMergeSRoleCell")
local UITableView = require("game.UI.common.UITableView")

local UIMergeSRolePanel  = class("UIMergeSRolePanel", function() return gdisplay.newWidget() end )

function UIMergeSRolePanel:ctor()
    self:CreateUI()
end

function UIMergeSRolePanel:CreateUI()
    local root = resMgr:createWidget("login/account_choose_bg")
    self:initUI(root)
end

function UIMergeSRolePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/account_choose_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bottomNode = self.root.bottomNode_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.table_node = self.root.table_node_export
    self.topNode = self.root.topNode_export

    uiMgr:addWidgetTouchHandler(self.root.start1_btn, function(sender, eventType) self:start1_game(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIMergeSRoleCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

end

function UIMergeSRolePanel:onEnter()
    self.m_eventListenerCustomList = {}
end

function UIMergeSRolePanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIMergeSRolePanel:setData(data,checkcall)
    self.checkcall = checkcall
    -- if data
    self.data = data
    -- local cjson = require "base.pack.json"
    -- local data = cjson.decode('{"ret":0,"params":[{"id":"6534","account_id":"2000305","device_id":null,"bind_passport_name":null,"alias":null,"facebook":null,"fbalias":null,"gamecenter":null,"gcalias":null,"sn":"aea42a8e876b93a3f6672f76eee3c95f","last_login_time":"1520404430","active":null,"login_name":"guest53489950","svr_id":"2","ip":"60.191.28.90","status":"0","nick_name":"2000305","ctsn":"aea42a8e876b93a3f6672f76eee3c95f","born_time":"1520404430","google":null,"glalias":null,"country":"CN","face":"108","level":"3","face_bk":"1","total_recharge":"0","city_lv":"0","invite_code":"111111111","user_id":"2000305","ally_id":"0","user_name":"2000305","face_id":"108","role_kind":"3","user_level":"3","born_svrid":"2","vip_level":"1","vip_time":"0","city_level":"5","diamonds":"150","totem":null,"nickname":null,"shortname":null},{"id":"6534","account_id":"2000305","device_id":null,"bind_passport_name":null,"alias":null,"facebook":null,"fbalias":null,"gamecenter":null,"gcalias":null,"sn":"aea42a8e876b93a3f6672f76eee3c95f","last_login_time":"1520404430","active":null,"login_name":"guest53489950","svr_id":"2","ip":"60.191.28.90","status":"0","nick_name":"2000305","ctsn":"aea42a8e876b93a3f6672f76eee3c95f","born_time":"1520404430","google":null,"glalias":null,"country":"CN","face":"108","level":"3","face_bk":"1","total_recharge":"0","city_lv":"0","invite_code":"111111111","user_id":"2000305","ally_id":"0","user_name":"2000305","face_id":"108","role_kind":"3","user_level":"3","born_svrid":"2","vip_level":"1","vip_time":"0","city_level":"5","diamonds":"150","totem":null,"nickname":null,"shortname":null},{"id":"6534","account_id":"2000305","device_id":null,"bind_passport_name":null,"alias":null,"facebook":null,"fbalias":null,"gamecenter":null,"gcalias":null,"sn":"aea42a8e876b93a3f6672f76eee3c95f","last_login_time":"1520404430","active":null,"login_name":"guest53489950","svr_id":"2","ip":"60.191.28.90","status":"0","nick_name":"2000305","ctsn":"aea42a8e876b93a3f6672f76eee3c95f","born_time":"1520404430","google":null,"glalias":null,"country":"CN","face":"108","level":"3","face_bk":"1","total_recharge":"0","city_lv":"0","invite_code":"111111111","user_id":"2000305","ally_id":"0","user_name":"2000305","face_id":"108","role_kind":"3","user_level":"3","born_svrid":"2","vip_level":"1","vip_time":"0","city_level":"5","diamonds":"150","totem":null,"nickname":null,"shortname":null}],"param":{"sc":"e20ae0efb2bdd27fa462454be47e908a"}}')

    local roleList = {}
    for i,v in pairs(data.params) do
        if v.account_id and v.user_id then
            table.insert(roleList,v)
        end
    end
    table.sort(roleList,function(a,b)
        -- body
        return tonumber(a.city_level) > tonumber(b.city_level)
    end)
    self.tableView:setFocusIndex(1)
    -- dump(roleList)
    self.tableView:setData(roleList)

    local alldata = self.tableView:getData()
    -- dump(alldata)
    local str = ""
    for i,v in pairs(alldata) do
        if not string.find(str,v.svr_name) then
            str = str .. v.svr_name.."|"
        end
    end
    local data = global.luaCfg:get_introduction_by(45)
    data.addParams = {key_1 = str}
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)

    
    -- 下载用户头像
    if roleList then
        local data = {}
        for i,v in pairs(roleList) do
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


function UIMergeSRolePanel:checkTokenBinded(token)
    local data = self.tableView:getData()
    for i,v in pairs(data) do
        if v.gamecenter == token or v.google == token or v.facebook == token then
            return true
        end
    end
    return false
end

    -- VISITOR    = 0,
    -- FACEBOOK   = 1,
    -- GOOGLE     = 2,
    -- GAMECENTER = 3,
    -- "google":null,"glalias":null,"c
function UIMergeSRolePanel:convertChgsvrData(param,listdata,isselect)
    local isBind = false
    -- dump(param)
    -- dump(listdata)
    if param.facebook and param.facebook ~= "" then
        isBind = true
        local temp = {
            login_name = param.login_name,
            uid = param.user_id,
            des = param.svr_id, -- 目标服务器id
            src = param.born_svrid, -- 源服务器id
            bind_name = param.facebook,
            alias_name = param.fbalias,
        }
        temp["type"] = WDEFINE.CHANNEL.FACEBOOK
        table.insert(listdata,temp)
    end

    if param.google and param.google ~= "" then
        isBind = true
        local temp = {
            login_name = param.login_name,
            uid = param.user_id,
            des = param.svr_id, -- 目标服务器id
            src = param.born_svrid, -- 源服务器id
            bind_name = param.google,
            alias_name = param.glalias,
        }
        temp["type"] = WDEFINE.CHANNEL.GOOGLE
        table.insert(listdata,temp)
    end

    if param.gamecenter and param.gamecenter ~= "" then
        isBind = true
        local temp = {
            login_name = param.login_name,
            uid = param.user_id,
            des = param.svr_id, -- 目标服务器id
            src = param.born_svrid, -- 源服务器id
            bind_name = param.gamecenter,
            alias_name = param.gcalias,
        }
        temp["type"] = WDEFINE.CHANNEL.GAMECENTER
        table.insert(listdata,temp)
    end
    if not isBind and isselect then
        local temp = {
            login_name = param.login_name,
            uid = param.user_id,
            des = param.svr_id, -- 目标服务器id
            src = param.born_svrid, -- 源服务器id
            bind_name = nil,
            alias_name = nil,
        }
        temp["type"] = nil
        table.insert(listdata,temp)
    end
    return listdata
end


function UIMergeSRolePanel:record(data)

    local chanId = 0
    local token = ""
    local name = ""
    
    if data.OtherBind  then 
        if  global.tools:isIos()  then 
            chanId = 3 
            token =  data.gamecenter or ""
            name = data.gcalias or ""

        elseif global.tools:isAndroid() then 
            chanId = 2  
            token  =  data.google or ""
            name =  data.glalias  or ""
        end 

        global.sdkBridge:setChannelInfo(chanId ,name , token)
    end 

    if data.FBBind then 
        chanId = 1 
        token  = data.facebook or ""
        name  = data.fbalias or  ""
        global.sdkBridge:setChannelInfo(chanId ,name , token)
    end 

end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIMergeSRolePanel:start1_game(sender, eventType)
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("SeverCombine", function()
        local selectData = self.tableView:getSelectedData()
        local data = self.tableView:getData()
        -- dump(data)
        -- dump(selectData,"~~~~~~~~~~~")
        local listdata = {}
        for i,v in pairs(data) do
            v.sc = self.data.param.sc
            listdata = self:convertChgsvrData(v,listdata,tonumber(v.account_id) == tonumber(selectData.account_id))
        end
        local chooseData =  self.tableView:getData()
        -- dump(listdata)
        global.sdkBridge:mergeSKeepRole(function(data)
            -- body
            local channelId, token = global.sdkBridge:getLoginBind()
            if channelId== "" or token== "" then
                channelId = -1
                token = -1
            else
                global.sdkBridge:deleteChannelInfo()
            end
            self:record(chooseData)
            global.panelMgr:closePanel("UIMergeSRolePanel")
            if self.checkcall then self.checkcall(selectData) end
        end,listdata)
    end)
end
--CALLBACKS_FUNCS_END

return UIMergeSRolePanel

--endregion
