--region UIUnionHelpItem.lua
--Author : zzl
--Date   : 2017/12/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionHelpItem  = class("UIUnionHelpItem", function() return gdisplay.newWidget() end )

function UIUnionHelpItem:ctor()
    self:CreateUI()
end

function UIUnionHelpItem:CreateUI()
    local root = resMgr:createWidget("union/union_help_list1")
    self:initUI(root)
end

function UIUnionHelpItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_help_list1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.time_export
    self.text = self.root.text_export
    self.name = self.root.name_export
    self.help_bt = self.root.help_bt_export
    self.loadingbar_bg = self.root.loadingbar_bg_export
    self.LoadingBar = self.root.LoadingBar_export
    self.loadingBar_text = self.root.loadingBar_text_export
    self.portrait_node = self.root.portrait_node_export
    self.frame = self.root.portrait_node_export.frame_export
    self.helped_text = self.root.helped_text_mlan_3_export

    uiMgr:addWidgetTouchHandler(self.help_bt, function(sender, eventType) self:click_help(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- message AllyHelp
-- {
--     required int32  lID = 1;//唯一ID
--     required int32  lUserID = 2; //发起人 ID
--     required int32  lQID = 3;//队列ID
--     optional int32  lBindID = 4; //绑定参数
--     optional int32  lBindParam = 5; //保留
--     optional int32  lCountLimit = 6; //限制次数
--     optional int32  lCount = 7;//当前次数
--     optional int32  lEndTime = 8; //发起帮助的结束时间
--     optional int32  lBUserID = 9; //帮人 ID
--     optional int32      lStale = 10;  //我是否帮助过
--     optional int32  lAddTime = 11;//发起帮助的时间

--     optional string  szUserName = 12;  //帮助名字
--     optional int32  lUserHead = 13;  //帮助人头像
--     optional int32  lUserHeadFrame = 14;  //帮助人头像框
--     optional string szParams = 15;//扩展
-- }
-- message AllyHelpLog
-- {
--     required int32  lUserID = 1; //发起人 ID
--     required int32  lBUserID = 2;//被帮助ID
--     required int32  lAddTime = 3;//添加时间
--     optional string     szUserName = 4;  //发起帮助名字
--     optional int32  lUserHead = 5;  //帮助人头像
--     optional int32      lUserHeadFrame = 6;  //帮助人头像框
--     optional string     szBUserName = 7;  //帮助人Name
--     optional int32  lBindID = 8; //绑定参数
--     optional int32  lBindParam = 9; //保留
--     optional string     szParams = 10;//扩展
-- }

--         1 = {
-- [LUA-print] -             "lBUserID"       = 0
-- [LUA-print] -             "lBindID"        = 15
-- [LUA-print] -             "lBindParam"     = 21 --等级
-- [LUA-print] -             "lCountLimit"    = 0
-- [LUA-print] -             "lEndTime"       = 1513622485
-- [LUA-print] -             "lID"            = 1
-- [LUA-print] -             "lQID"           = 2
-- [LUA-print] -             "lUserHead"      = 108
-- [LUA-print] -             "lUserHeadFrame" = 1
-- [LUA-print] -             "szUserName"     = "TommieAddie"
-- [LUA-print] -         }


function UIUnionHelpItem:isTech()

end 

function UIUnionHelpItem:isQueue(data)

    return self.data.lQID <=3 
end 

function UIUnionHelpItem:setData(data)

    self.data = data 

    local head = global.luaCfg:get_rolehead_by(self.data.lUserHead or 409)
    global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data,head))

    local headData = global.luaCfg:get_role_frame_by(self.data.lUserHeadFrame or 1)
    global.panelMgr:setTextureFor(self.frame,headData.pic)

    self.data.lCount = self.data.lCount or 0 

    self.loadingBar_text:setString(self.data.lCount.."/"..self.data.lCountLimit)

    self.LoadingBar:setPercent(self.data.lCount/self.data.lCountLimit * 100 )

    self.help_bt:setVisible(not self.data.lStale and self.data.lUserID ~=global.userData:getUserId())

    self.helped_text:setVisible(self.data.lStale and self.data.lUserID ~=global.userData:getUserId())



    self.name:setString(self.data.szUserName or "")

    if self:isQueue(self.data) then -- 建造队列加速

        -- self.text:setString(global.luaCfg:get_translate_string(10971, self.data.lBuildLV , global.cityData:getBuildingById(self.data.lBuildID).buildsName))
        self.text:setString(global.luaCfg:get_translate_string(10971))

    else 

        self.text:setString(global.luaCfg:get_translate_string(10977, self.data.lBindParam , global.luaCfg:get_science_by(self.data.lBindID).name))

    end 

    global.netRpc:delHeartCall(self)        

    local timerCall = function () 

        if not self.data then 
            global.netRpc:delHeartCall(self)        
            return 
        end  

        local overtime =  global.dataMgr:getServerTime() - self.data.lAddTime

        if overtime < 60*60 then --多少分钟 
            local m = math.ceil(overtime/60)
            if m== 0 then 
                m = 1 
            end
            self.time:setString(m..global.luaCfg:get_translate_string(10088))

        elseif overtime < 60*60*24 then --多少小时

            self.time:setString(math.floor(overtime/(60*60))..global.luaCfg:get_translate_string(10087))
        else
            
            self.time:setString(math.floor(overtime /(60*60*24) )..global.luaCfg:get_translate_string(10086))
            -- local time = global.funcGame.formatTimeToTime( self.data.lEndTime,true)
            -- -- local str = global.funcGame.formatTimeToHMSByLargeTime()
            -- self.time:setString(global.luaCfg:get_local_string("%s-%s-%s %s:%02d:%02d",time.year,time.month,time.day,time.hour,time.minute,time.second))
        end
    end 

    global.netRpc:addHeartCall(timerCall,self)

    timerCall()
end 

function UIUnionHelpItem:onExit()
    
        global.netRpc:delHeartCall(self)        
end 

function UIUnionHelpItem:click_help(sender, eventType)
    
    if not self.data then 
        return 
    end 

    global.unionApi:helpBuild({self.data.lID}, function (msg) 

        local add  = ""
        if msg and  msg.tgItem then 
            for _ , v in pairs(msg.tgItem) do 
                local item = global.luaCfg:get_item_by(v.lID)
                add = add .. item.itemName
                add = add .."+".. v.lCount
            end 
        end 

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_unionhelpothers")
        global.tipsMgr:showWarning("union_help01", add)

        if global.panelMgr:getTopPanelName() == "UIUnionHelpPanel" then 
            global.panelMgr:getPanel("UIUnionHelpPanel"):reFresh(true)
        end  
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionHelpItem

--endregion
