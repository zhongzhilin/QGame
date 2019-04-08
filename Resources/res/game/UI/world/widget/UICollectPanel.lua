--region UICollectPanel.lua
--Author : yyt
--Date   : 2016/11/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UICollectPanel  = class("UICollectPanel", function() return gdisplay.newWidget() end )

function UICollectPanel:ctor()
    self:CreateUI() 
end

function UICollectPanel:CreateUI()
    local root = resMgr:createWidget("world/mark_info")
    self:initUI(root) 
end

function UICollectPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mark_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.cityIcon = self.root.Node_export.cityIcon_export
    self.name = self.root.Node_export.name_mlan_12_export
    self.posX = self.root.Node_export.posX_export
    self.posY = self.root.Node_export.posY_export
    self.textField = self.root.Node_export.text_bj.textField_export
    self.textField = UIInputBox.new()
    uiMgr:configNestClass(self.textField, self.root.Node_export.text_bj.textField_export)
    self.text_btn = self.root.Node_export.text_btn_export
    self.select1 = self.root.Node_export.Image_13.btn01.select1_export
    self.select2 = self.root.Node_export.Image_13.btn02.select2_export
    self.select3 = self.root.Node_export.Image_13.btn03.select3_export
    self.btnAddItem = self.root.Node_export.btnAddItem_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.text_btn, function(sender, eventType) self:nameEditHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Image_13.btn01, function(sender, eventType) self:sign_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Image_13.btn02, function(sender, eventType) self:friend_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Image_13.btn03, function(sender, eventType) self:army_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnAddItem, function(sender, eventType) self:confirm_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_1, function(sender, eventType) self:shareHandler(sender, eventType) end)
--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICollectPanel:onEnter()
    self.lastName = ""
    self.textField:addEventListener(handler(self, self.check))
end

function UICollectPanel:check(eventType)

    if eventType == "began" then
        self.lastName = self.textField:getString()
    end

    if eventType == "return" then
        self:checkNameStr(self.textField:getString())
    end
end

function UICollectPanel:checkNameStr(str)

    if str == "" then
            
        self.textField:setString(self.lastName)
        global.tipsMgr:showWarningTime("CantEmpty")
        return
    end
    
    local spaceNum = 0
    local list = string.utf8ToList(str)
    for i=1,#list do

        if list[i] == " " then
            spaceNum = spaceNum + 1
        end
    end

    -- 不能全部为空格
    if spaceNum == #list then
        self.textField:setString(self.lastName)
        global.tipsMgr:showWarningTime("CantSpaceAll")
        return
    end


    if string.isEmoji(str) then
        self.textField:setString(self.lastName)
        global.tipsMgr:showWarning("13")
        return
    end

end


function UICollectPanel:setData(cityId, data, callback)

    self.text_btn:setSwallowTouches(false)
   
    self.lMapID = data.lMapID
    self.x = data.lPosX
    self.y = data.lPosY
    if cityId == -1 and data.lCityID then
        self.cityId = data.lCityID
    else
        self.cityId = cityId
    end

    if callback then
        self.name:setString(luaCfg:get_local_string(10137))
    else
        self.name:setString(luaCfg:get_local_string(10138))
    end
    
    self.m_callback = callback

    local surfacedData = luaCfg:get_world_surface_by(data.lMapID) 
    --　野怪
    if surfacedData.type == 102 then
        -- self.cityIcon:setSpriteFrame(surfacedData.uimap)
        global.panelMgr:setTextureFor(self.cityIcon,surfacedData.uimap)
    else
        global.panelMgr:setTextureFor(self.cityIcon,surfacedData.worldmap)
        -- self.cityIcon:setSpriteFrame(surfacedData.worldmap)
    end

    self.cityIcon:setScale(surfacedData.iconSize)

    self.textField:setString(data.szName)

    local pos = global.g_worldview.const:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(math.round(pos.x))
    self.posY:setString(math.round(pos.y))

    local index = 0
    if data.lType then
        index = data.lType+1
    else
        index = 1
    end
    self.lkind = index - 1
    self:selectBtn(index)
end

function UICollectPanel:selectBtn(index)
    for i=1,3 do
        if i == index then
            self["select"..i]:setVisible(true)
            self.curlkind = i-1
        else
            self["select"..i]:setVisible(false)
        end
    end
end

function UICollectPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UICollectPanel")
    -- if self.m_callback then
    --     local panel = global.panelMgr:getPanel("UICollectListPanel")
    --     panel:setData(self.lkind + 1)
    -- end 
end

function UICollectPanel:share_click(sender, eventType)

end

function UICollectPanel:sign_click(sender, eventType)
    self:selectBtn(1)
end

function UICollectPanel:friend_click(sender, eventType)
    self:selectBtn(2)
end

function UICollectPanel:army_click(sender, eventType)
    self:selectBtn(3)
end

function UICollectPanel:exitCall()
    self:exit_call()
end

function UICollectPanel:confirm_click(sender, eventType)

    self.lkind = self.curlkind
    local x, y = self.x, self.y
    local lMapID = self.lMapID
    local cityName = self.textField:getString()
    if self.m_callback then

        self.m_callback(self.lkind, cityName, handler(self, self.exitCall))
    else
        global.worldApi:setBookMark(0, self.cityId, 1, self.lkind, lMapID, x, y, cityName, function (msg)

            if msg then
                global.collectData:addCollect(msg.tgBookmarks[1])
                if self.exit_call then
                    self:exit_call()
                end 
                global.tipsMgr:showWarning("Collectionok")
                global.panelMgr:closePanelShowWorld() 
            end
        end)
    end
end

function UICollectPanel:nameEditHandler(sender, eventType)

    self.textField:touchDownAction()
end

function UICollectPanel:shareHandler(sender, eventType)

    local posXY = global.g_worldview.const:converPix2Location(cc.p(self.x, self.y))
    local x = math.round(posXY.x)
    local y = math.round(posXY.y)

    local surfaceData = luaCfg:get_world_surface_by(self.lMapID) 
    local lWildKind = surfaceData.mold

    local tagSpl = {}
    tagSpl.lKey = 3
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = {name = self.textField:getString(),posX = x,posY = y,cityId = self.cityId,wildKind = lWildKind}    
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl)   
end
--CALLBACKS_FUNCS_END

return UICollectPanel

--endregion
