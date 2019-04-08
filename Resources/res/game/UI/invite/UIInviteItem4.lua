--region UIInviteItem4.lua
--Author : zzl
--Date   : 2018/03/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIInviteItem4  = class("UIInviteItem4", function() return gdisplay.newWidget() end )

function UIInviteItem4:ctor()
    self:CreateUI()
end

function UIInviteItem4:CreateUI()
    local root = resMgr:createWidget("invite/Node4")
    self:initUI(root)
end

function UIInviteItem4:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "invite/Node4")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.name_export
    self.city = self.root.city_export
    self.city_lv = self.root.city_lvv_mlan_5.city_lv_export
    self.rechardef = self.root.rechardef_mlan_5_export
    self.recharge = self.root.recharge_export
    self.icon = self.root.icon_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.portrait)

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN



function UIInviteItem4:onEnter()

end 

--    3 = {
-- [LUA-print] -             "account_id" = "4010930"
-- [LUA-print] -             "face"       = "108"
-- [LUA-print] -             "level"      = "1"
-- [LUA-print] -             "nick_name"  = "4010930"
-- [LUA-print] -             "svr_id"     = "4"
-- [LUA-print] -         }
-- [LUA-print] -         4 = {
-- [LUA-print] -             "account_id" = "4010931"
-- [LUA-print] -             "face"       = "108"
-- [LUA-print] -             "level"      = "1"
-- [LUA-print] -             "nick_name"  = "4010931"
-- [LUA-print] -             "svr_id"     = "4"
-- [LUA-print] -         }

function UIInviteItem4:setData(data)

    self.data = data 

    self.city_lv:setString(data.level)
    self.name:setString(data.nick_name)

    data.server_name = data.server_name or "TestServer"
    data.total_recharge = data.total_recharge or "0"

    -- local str = string.format(gls(11148) ,data.svr_id , data.server_name)

    local str =global.luaCfg:get_translate_string(11148,data.svr_id , data.server_name)
    
    self.city:setString(str)

    self.recharge:setString("+"..data.total_recharge )
    global.tools:adjustNodePosForFather(self.city_lv:getParent() , self.city_lv)

    self.icon:setPositionX(self.rechardef:getPositionX()+self.rechardef:getContentSize().width)
    self.recharge:setPositionX(self.icon:getPositionX()+self.icon:getContentSize().width-10)


    if self.data.face  then 
        self.data.face = tonumber(self.data.face)
    end 

    if self.data.face_bk  then 
        self.data.face_bk = tonumber(self.data.face_bk)
        if self.data.face_bk == 0 then self.data.face_bk = 1 end 
    end 

    -- local head = global.luaCfg:get_rolehead_by(self.data.face or 409)
    -- global.tools:setCircleAvatar(self.portrait_node, head)

    -- local headData = global.luaCfg:get_role_frame_by(self.data.face_bk or 1)
    -- global.panelMgr:setTextureFor(self.headFream,headData.pic)

    self.portrait:setData(self.data.face or 409, self.data.face_bk or 1, data)
end 
--CALLBACKS_FUNCS_END

return UIInviteItem4

--endregion
