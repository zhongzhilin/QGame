--region UISetAccountNode.lua
--Author : yyt
--Date   : 2017/04/13
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISetAccountNode  = class("UISetAccountNode", function() return gdisplay.newWidget() end )

function UISetAccountNode:ctor()
  
end

function UISetAccountNode:CreateUI()
    local root = resMgr:createWidget("settings/account_node_1")
    self:initUI(root)
end

function UISetAccountNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/account_node_1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btnHead = self.root.Node1.btnHead_export
    self.userName = self.root.Node1.userName_export
    self.castle = self.root.Node1.castle_export
    self.serverName = self.root.Node1.serverName_export
    self.id = self.root.Node1.id_export
    self.lord_id = self.root.Node1.lord_id_mlan_5_export
    self.lord_name = self.root.Node1.lord_name_mlan_5_export
    self.server_name = self.root.Node1.server_name_mlan_5_export
    self.castle_level = self.root.Node1.castle_level_mlan_5_export

--EXPORT_NODE_END

    global.tools:adjustNodePos(self.lord_name,self.userName)
    global.tools:adjustNodePos(self.lord_id,self.id)
    global.tools:adjustNodePos(self.castle_level,self.castle)
    global.tools:adjustNodePos(self.server_name,self.serverName)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISetAccountNode:setData()

	-- 当前账号信息
    local head = clone(global.headData:getCurHead())
    if head then
        global.tools:setCircleAvatar(self.btnHead.IconNode, head)
    end 
    self.userName:setString(global.userData:getUserName())

    local castLv = global.cityData:getBuildingById(1).serverData.lGrade
    self.castle:setString(castLv) --luaCfg:get_local_string(10480, castLv))  
    self.id:setString(global.userData:getUserId())

    local serverData = global.ServerData:getServerDataBy(global.loginData:getCurServerId())
    uiMgr:setRichText(self, "serverName", 50052 , {server_id = "", server_name = serverData.servername} )

end
--CALLBACKS_FUNCS_END

return UISetAccountNode

--endregion
