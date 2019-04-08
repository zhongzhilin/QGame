--region UIMergeSRoleItem.lua
--Author : wuwx
--Date   : 2018/03/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIMergeSRoleItem  = class("UIMergeSRoleItem", function() return gdisplay.newWidget() end )

function UIMergeSRoleItem:ctor()
    
    self:CreateUI()
end

function UIMergeSRoleItem:CreateUI()
    local root = resMgr:createWidget("login/role_info_node")
    self:initUI(root)
end

function UIMergeSRoleItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "login/role_info_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.ui_h_fr_1.portrait)
    self.server_name = self.root.ui_h_fr_1.server_name_export
    self.server_num = self.root.ui_h_fr_1.server_num_export
    self.bang1 = self.root.ui_h_fr_1.bang1_export
    self.bang2 = self.root.ui_h_fr_1.bang2_export
    self.icon_2 = self.root.ui_h_fr_1.icon_2_export
    self.game_center = self.root.ui_h_fr_1.icon_2_export.game_center_export
    self.name = self.root.ui_h_fr_1.name_export
    self.level = self.root.ui_h_fr_1.levle_mlan_4.level_export
    self.unionName = self.root.ui_h_fr_1.union_mlan_4.unionName_export
    self.vipNode = self.root.ui_h_fr_1.vipNode_export
    self.vipbg = self.root.ui_h_fr_1.vipNode_export.vipbg_export
    self.vip_lv = self.root.ui_h_fr_1.vipNode_export.vip_lv_export
    self.num = self.root.ui_h_fr_1.icon2.num_export
    self.black_mask = self.root.black_mask_export
    self.light_selected = self.root.light_selected_export

    uiMgr:addWidgetTouchHandler(self.root.ui_h_fr_1.icon_1_epxort, function(sender, eventType) self:onBindFb(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.icon_2, function(sender, eventType) self:onBindOther(sender, eventType) end)
--EXPORT_NODE_END
end



-- [LUA-print] -         1 = {
-- [LUA-print] -             "account_id"      = "2000305"
-- [LUA-print] -             "ally_id"         = "0"
-- [LUA-print] -             "born_svrid"      = "2"
-- [LUA-print] -             "born_time"       = "1520404430"
-- [LUA-print] -             "city_level"      = "5"
-- [LUA-print] -             "city_lv"         = "0"
-- [LUA-print] -             "country"         = "CN"
-- [LUA-print] -             "ctsn"            = "aea42a8e876b93a3f6672f76eee3c95f"
-- [LUA-print] -             "diamonds"        = "150"
-- [LUA-print] -             "face"            = "108"
-- [LUA-print] -             "face_bk"         = "1"
-- [LUA-print] -             "face_id"         = "108"
-- [LUA-print] -             "id"              = "6534"
-- [LUA-print] -             "invite_code"     = "111111111"
-- [LUA-print] -             "ip"              = "60.191.28.90"
-- [LUA-print] -             "last_login_time" = "1520404430"
-- [LUA-print] -             "level"           = "3"
-- [LUA-print] -             "login_name"      = "guest53489950"
-- [LUA-print] -             "nick_name"       = "2000305"
-- [LUA-print] -             "role_kind"       = "3"
-- [LUA-print] -             "sn"              = "aea42a8e876b93a3f6672f76eee3c95f"
-- [LUA-print] -             "status"          = "0"
-- [LUA-print] -             "svr_id"          = "2"
-- [LUA-print] -             "total_recharge"  = "0"
-- [LUA-print] -             "user_id"         = "2000305"
-- [LUA-print] -             "user_level"      = "3"
-- [LUA-print] -             "user_name"       = "2000305"
-- [LUA-print] -             "vip_level"       = "1"
-- [LUA-print] -             "vip_time"        = "0"
-- [LUA-print] -         }

-- 需要服务器名字，联盟名字
-- 魔晶数量
function UIMergeSRoleItem:setData(data)

    self.data = data
    
    self.server_num:setString(data.born_svrid)
    self.server_name:setString(data.svr_name)
    self.name:setString(data.user_name)
    self.unionName:setString(data.allyname or "-")
    self.level:setString(data.city_level)
    if data.face_id and tonumber(data.face_id)>0 then
        self.portrait:setVisible(true)
        self.portrait:setData(tonumber(data.face_id),nil,data)
    else
        self.portrait:setVisible(false)
    end
    self.vip_lv:setString(data.vip_level or "-")
    self.num:setString(data.diamonds or "-")
    
    global.tools:adjustNodePosForFather(self.unionName:getParent(),self.unionName)
    global.tools:adjustNodePosForFather(self.num:getParent(),self.num)
    global.tools:adjustNodePosForFather(self.level:getParent(),self.level)

    self:setBtnIcon()
    self:setBindText()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


local icon = {
    [1]="ui_surface_icon/gamecenter_icon.png"  ,
    [2]="ui_surface_icon/google_icon.png"  , 
}


function UIMergeSRoleItem:setSelected(isSelected)
    self.light_selected:setVisible(isSelected)
    self.black_mask:setVisible(not isSelected)
end 

function UIMergeSRoleItem:setBindText()

    if self.data.FBBind then 
        self.bang1:setString(global.luaCfg:get_local_string(10857))
    else
        self.bang1:setString(global.luaCfg:get_local_string(10495))
    end 

    if self.data.OtherBind then 
        self.bang2:setString(global.luaCfg:get_local_string(10857))
    else
        self.bang2:setString(global.luaCfg:get_local_string(10495))
    end 
end 

function UIMergeSRoleItem:setBtnIcon()

    self.game_center:setVisible(global.tools:isIos())

    -- local icon = icon[1]
    -- if  global.tools:isIos()  then 
    --     icon = icon[1]
    -- elseif global.tools:isAndroid() then 
    --     icon = icon[2]
    -- end 

    -- print(icon ,"icon->>>>>>>>>>>>>>")

    -- self.icon_2:loadTextureNormal(icon , ccui.TextureResType.plistType)
    -- self.icon_2:loadTexturePressed(icon , ccui.TextureResType.plistType)
end 

function UIMergeSRoleItem:isBuilded(chanId)

    if chanId == 1 then 
        return self.data.FBBind
    else 
        return self.data.OtherBind
    end 
end 

function UIMergeSRoleItem:onBindFb(sender, eventType)
    
    global.sdkBridge:setChannel(1)

    local FBbuildHandle = function (  )
        local finishCall = function (state , name , token)
            if state == 0 then
                if global.panelMgr:getPanel("UIMergeSRolePanel"):checkTokenBinded(token) then
                    return global.tipsMgr:showWarningDelay("repeat_bind")
                end
                global.tipsMgr:showWarningDelay("bind_success",nil,function()
                    -- body
                    self.data.FBBind = true
                    self.data.facebook = token
                    self.data.fbalias = name
                    self:setBindText()
                end)
            end
        end
        global.sdkBridge:login(finishCall , true)        -- fb绑定
    end

    local FBRemoveHandle = function ( )

        -- local finishCall = function (state , name , token)
        --   if state == 1 then
                global.tipsMgr:showWarningDelay("remove_bind_success",nil,function()
                    -- body
                    self.data.FBBind = false
                    self.data.facebook = nil
                    self.data.fbalias = nil
                    self:setBindText()
                end)
        --     end
        -- end
        -- global.sdkBridge:loginOut(finishCall , true) -- fb解绑
    end

    if not self:isBuilded(1) then 
        FBbuildHandle()
    else 
        FBRemoveHandle()
    end 
end

function UIMergeSRoleItem:onBindOther(sender, eventType)

    local chanId = 0
    if  global.tools:isIos()  then 
        chanId = 3 
    elseif global.tools:isAndroid() then 
        chanId = 2 
    end 

    global.sdkBridge:setChannel(chanId)

    local BuildHandle = function () 
        local finishCall = function (state, name,token)
            if state == 0 then
                
                if global.panelMgr:getPanel("UIMergeSRolePanel"):checkTokenBinded(token) then
                    return global.tipsMgr:showWarningDelay("repeat_bind")
                end
                global.tipsMgr:showWarningDelay("bind_success",nil,function()
                    -- body
                    self.data.OtherBind = true

                    if  global.tools:isIos()  then 
                        self.data.gamecenter = token
                        self.data.gcalias = name
                    elseif global.tools:isAndroid() then 
                        self.data.google = token
                        self.data.glalias = name
                    end 
                    self:setBindText()
                end)
            end
        end
        global.sdkBridge:login(finishCall , true) -- other绑定
    end 

    local RemoveHandle = function () 
        -- local finishCall = function (state, name , token)
        --     if state == chanId then
                global.tipsMgr:showWarningDelay("remove_bind_success",nil,function()
                    -- body
                    self.data.OtherBind = false
                    if  global.tools:isIos()  then 
                        self.data.gamecenter = nil
                        self.data.gcalias = nil
                    elseif global.tools:isAndroid() then 
                        self.data.google = nil
                        self.data.glalias = nil
                    end 
                    self:setBindText()
                end)
        --     end
        -- end
        -- global.sdkBridge:loginOut(finishCall , true) -- other解绑
    end 

    if not self:isBuilded(chanId) then 
        BuildHandle()
    else 
        RemoveHandle()
    end 
end
--CALLBACKS_FUNCS_END

return UIMergeSRoleItem

--endregion
