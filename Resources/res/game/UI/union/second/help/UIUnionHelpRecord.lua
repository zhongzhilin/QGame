--region UIUnionHelpRecord.lua
--Author : zzl
--Date   : 2017/12/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionHelpRecord  = class("UIUnionHelpRecord", function() return gdisplay.newWidget() end )

function UIUnionHelpRecord:ctor()
    self:CreateUI()
end

function UIUnionHelpRecord:CreateUI()
    local root = resMgr:createWidget("union/union_help_list2")
    self:initUI(root)
end

function UIUnionHelpRecord:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_help_list2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.time_export
    self.text = self.root.text_export
    self.portrait_node = self.root.portrait_node_export
    self.frame = self.root.portrait_node_export.frame_export

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


function UIUnionHelpRecord:setData(data)

    self.data = data 

    local head = global.luaCfg:get_rolehead_by(self.data.lUserHead or 409)

    global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data,head))

    local headData = global.luaCfg:get_role_frame_by(self.data.lUserHeadFrame or 1)

    global.panelMgr:setTextureFor(self.frame,headData.pic)

    -- local building = global.cityData:getBuildingById(self.data.lBindID)

    -- local name = ""

    -- if building then 
    --     name = building.buildsName
    -- end 

    -- self.text:setString(global.luaCfg:get_translate_string(10972, self.data.szUserName ,self.data.szBUserName , self.data.lBuildLV ,name ))
    global.netRpc:delHeartCall(self)

    if self:isQueue(self.data) then 

        -- self.text:setString(global.luaCfg:get_translate_string(10976,self.data.szBUserName ,self.data.szUserName))
        uiMgr:setRichText(self,"text",50251, {key1 = self.data.szBUserName ,key2 = self.data.szUserName})

    else 
        -- self.text:setString(global.luaCfg:get_translate_string(10972,self.data.szBUserName, self.data.szUserName ,self.data.lBindParam , global.luaCfg:get_science_by(self.data.lBindID).name))

        uiMgr:setRichText(self,"text",50250,{key1= self.data.szBUserName, key2 = self.data.szUserName , key3= self.data.lBindParam , key4= global.luaCfg:get_science_by(self.data.lBindID).name})

    end 

    local timerCall = function () 

       if not self.data then 
            global.netRpc:delHeartCall(self)        
            return 
        end  

        local overtime =  global.dataMgr:getServerTime() - self.data.lAddTime
        
        if overtime < 60*60 then --多少分钟 

            local m = math.floor(overtime/60)
            if m== 0 then 
                m = 1 
            end 
            self.time:setString(m..global.luaCfg:get_translate_string(10088))

        elseif overtime < 60*60*24 then --多少小时
            self.time:setString(math.floor(overtime / (60*60))..global.luaCfg:get_translate_string(10087))
        else
            self.time:setString(math.floor(overtime /(60*60*24) )..global.luaCfg:get_translate_string(10086))
        end
    end

    global.netRpc:addHeartCall(timerCall,self)

    timerCall()
end 


function UIUnionHelpRecord:onExit()
    
    global.netRpc:delHeartCall(self)
end 


function UIUnionHelpRecord:isTech()

end 

function UIUnionHelpRecord:isQueue(data)

    return self.data.lBindID < 100000
end 


--CALLBACKS_FUNCS_END

return UIUnionHelpRecord

--endregion
