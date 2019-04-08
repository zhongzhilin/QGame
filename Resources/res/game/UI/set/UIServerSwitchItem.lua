--region UIServerSwitchItem.lua
--Author : anlitop
--Date   : 2017/04/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIServerSwitchItem  = class("UIServerSwitchItem", function() return gdisplay.newWidget() end )

function UIServerSwitchItem:ctor()
    self:CreateUI()
end

function UIServerSwitchItem:CreateUI()
    local root = resMgr:createWidget("settings/server_node")
    self:initUI(root)
end

function UIServerSwitchItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/server_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.server_name = self.root.Button_2.server_name_export
    self.server_num = self.root.Button_2.server_num_export
    self.user_lv = self.root.Button_2.user_lv_export
    self.new_server = self.root.Button_2.new_server_export
    self.havRole = self.root.Button_2.havRole_export
    self.curSelect = self.root.Button_2.curSelect_export
    self.curSerIcon = self.root.Button_2.curSerIcon_export

--EXPORT_NODE_END
    self.root.Button_2:setSwallowTouches(false)
    -- self.root.Button_2:setZoomScale(WCONST.BUTTON_SCALE.SMALL)

end
--     1 = {
-- [LUA-print] -             "birthday"   = "1491207045"
-- [LUA-print] -             "image"      = "www.baidu.com"
-- [LUA-print] -             "isfirst"    = "0"
-- [LUA-print] -             "language"   = "1"
-- [LUA-print] -             "new"        = "0"
-- [LUA-print] -             "serverid"   = "2"
-- [LUA-print] -             "servername" = "松挺服"
-- [LUA-print] -             "status"     = "0"
-- [LUA-print] -         }
function UIServerSwitchItem:setData(data)
    self.data = data 
    self:updateUI()

    self.server_num:setVisible(false)
end 

function UIServerSwitchItem:updateUI()
    -- dump(self.data)
    self.server_name:setString(self.data.servername)
    self.server_num:setString( self.data.serverid)
    self.user_lv:setString(self.data.userLv or 20)
    self.data.status = tonumber(self.data.status)
    self.new_server:setVisible(self.data.new and tonumber(self.data.new)~=0)
    self:setServerMsg()
end 

function UIServerSwitchItem:setServerMsg()

    self.data.serverid = tonumber(self.data.serverid)

    local isCurSev = self.data.serverid == global.loginData:getCurServerId()
    if isCurSev then

        self.curSelect:setVisible(true)
        self.curSerIcon:setVisible(true)
        self.user_lv:setVisible(false)
        self.havRole:setVisible(false)

    else

        self.curSelect:setVisible(false)
        self.curSerIcon:setVisible(false)
        self.user_lv:setVisible(true)
        
        local userInfo = global.sdkBridge:getServerListInfo(self.data.serverid)
        if userInfo then
            self.havRole:setVisible(true)
            self.user_lv:setString(userInfo.level or 0)
        else
            self.user_lv:setVisible(false)
            self.havRole:setVisible(false)
        end

    end

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIServerSwitchItem:lordDetail_click(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIServerSwitchItem

--endregion
