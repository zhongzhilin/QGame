--region UIOfficalPanel.lua
--Author : Untory
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITopItemForMotherKing = require("game.UI.offical.UITopItemForMotherKing")
local UITopItem = require("game.UI.offical.UITopItem")
local UIBottomGroup = require("game.UI.offical.UIBottomGroup")
--REQUIRE_CLASS_END

local UIOfficalPanel  = class("UIOfficalPanel", function() return gdisplay.newWidget() end )

function UIOfficalPanel:ctor()
    self:CreateUI()
end

function UIOfficalPanel:CreateUI()
    local root = resMgr:createWidget("offical/offical_1st_bg")
    self:initUI(root)
end
 
function UIOfficalPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "offical/offical_1st_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_16_export
    self.scrollview = self.root.scrollview_export
    self.ps_node = self.root.scrollview_export.ps_node_export
    self.lord_name = self.root.scrollview_export.mainNode.top_bg.lord_name_export
    self.spread_node = self.root.scrollview_export.mainNode.top_bg.Panel_1.spread_node_export
    self.motherKing = UITopItemForMotherKing.new()
    uiMgr:configNestClass(self.motherKing, self.root.scrollview_export.mainNode.top_bg.motherKing)
    self.hero_btn = self.root.scrollview_export.mainNode.top_bg.hero_btn_export
    self.portrait_node = self.root.scrollview_export.mainNode.top_bg.hero_btn_export.portrait_node_export
    self.headFrame = self.root.scrollview_export.mainNode.top_bg.hero_btn_export.portrait_node_export.headFrame_export
    self.offical = self.root.scrollview_export.mainNode.top_bg.offiacal_pic_5_1.offical_export
    self.out = self.root.scrollview_export.mainNode.top_bg.out_export
    self.top_2 = UITopItem.new()
    uiMgr:configNestClass(self.top_2, self.root.scrollview_export.mainNode.top_2)
    self.top_3 = UITopItem.new()
    uiMgr:configNestClass(self.top_3, self.root.scrollview_export.mainNode.top_3)
    self.top_4 = UITopItem.new()
    uiMgr:configNestClass(self.top_4, self.root.scrollview_export.mainNode.top_4)
    self.bottom_2 = UIBottomGroup.new()
    uiMgr:configNestClass(self.bottom_2, self.root.scrollview_export.mainNode.bottom_2)
    self.bottom_3 = UIBottomGroup.new()
    uiMgr:configNestClass(self.bottom_3, self.root.scrollview_export.mainNode.bottom_3)
    self.bottom_4 = UIBottomGroup.new()
    uiMgr:configNestClass(self.bottom_4, self.root.scrollview_export.mainNode.bottom_4)

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:onHelp(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollview_export.mainNode.top_bg.Panel_1.spread_node_export.btn_land1, function(sender, eventType) self:choose_1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollview_export.mainNode.top_bg.Panel_1.spread_node_export.btn_land2, function(sender, eventType) self:choose_2(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollview_export.mainNode.top_bg.Panel_1.spread_node_export.btn_land3, function(sender, eventType) self:choose_3(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollview_export.mainNode.top_bg.Panel_1.spread_node_export.btn_land4, function(sender, eventType) self:choose_4(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.hero_btn, function(sender, eventType) self:check_top1(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.out, function(sender, eventType) self:onGotoWorldHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    self.scrollview:setContentSize(cc.size(gdisplay.width,gdisplay.height - 80))

    for i = 2,4 do
        self['top_' ..  i]:bindBottom(self['bottom_' .. i])
    end
    self:adapt()
end


function UIOfficalPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    local defY = self.scrollview:getContentSize().height
    self.scrollview:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 

    else
        self.scrollview:setTouchEnabled(false)
        self.scrollview:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.scrollview:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.scrollview:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

end 
function UIOfficalPanel:onEnter()

    self.m_eventListenerCustomList = {}
    self.lord_name:setString('')
    self.headFrame:setVisible(false)
    self.portrait_node.pic:setVisible(false)

    self.offical:setString(luaCfg:get_official_post_by(101).typeName)

    self.motherKing:setData(201,nil)

    -- 初始化二级领主
    local lead2id = {201,301,401,501}
    for i = 2,4 do
        self['top_' .. i]:setData(lead2id[i],nil)
    end

    -- 初始化3级
    local lead3id = {6,7,8,9}
    for i = 2,4 do
        self['bottom_' .. i]:setData(lead3id[i],{})
    end
end

function UIOfficalPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIOfficalPanel:getData()
    return {curLandId = self.curLandId,curOffId = self.curOffId}
end

function UIOfficalPanel:getCurLandId()
    return self.curLandId
end

function UIOfficalPanel:setCurOffId(id)
    self.curOffId = id
end

function UIOfficalPanel:setData(landId)

    self.curLandId = landId or global.g_worldview.areaDataMgr:getContentAreaId()
    self.spread_node:setPositionY(621)
    self.isHide = true

    self.offTree = {}

    global.worldApi:getOffical(function(msg)
        
        msg = msg or {}
        if self.initData then 
            self:initData(msg)
        end 
    end)    
end

-- function UIOfficalPanel:updateOffTree(data)
--     -- for _,v in ipairs(data) do        
--     --     offTree[v.lMapArea][v.lOfficialID] = v
--     -- end

--     self:initPanel()
-- end

function UIOfficalPanel:cleanId(id)
   
    local curLandTree = self.offTree[self.curLandId]    

    local funcGame = global.funcGame
    for offId,v in pairs(curLandTree) do
        local offType = funcGame:checkOfficalType(id, offId)
        if offType == 1 or offType == 2 then
            curLandTree[offId] = nil
        end
    end

    self:initTree()
end

function UIOfficalPanel:getSelfOfficalId()
    return self.selfOfficalId or -1
end

function UIOfficalPanel:initTree()

    self.curLandId = self.curLandId or 1
    self.panel_name:setString(luaCfg:get_map_region_by(self.curLandId).name)

    local offY = 0

    for i = 1,4 do
        local btn = self.spread_node['btn_land' .. i]
        btn:setVisible(i ~= self.curLandId)
        btn:setPositionY(57 + offY)
        if i ~= self.curLandId then
            offY = offY + 90
        end
    end    


    if not self.offTree[self.curLandId] then
        self.offTree[self.curLandId] = {}
    end

    local curLandTree = self.offTree[self.curLandId]

    self.selfOfficalId = self:checkSelfPos(curLandTree)

    -- 初始化领主
    local leaderData = curLandTree[101]
    self.leaderData = leaderData
    if leaderData then        
        local head = luaCfg:get_rolehead_by(leaderData.lHeadImg)
        head = global.headData:convertHeadData(leaderData, head)
        if head.path then 
            global.tools:setCircleAvatar(self.portrait_node, head)
        end 

        self.headFrame:setVisible(true)
        local headInfo = global.luaCfg:get_role_frame_by(tonumber(leaderData.lBackID))
        if headInfo and headInfo.pic then
            global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)     
        end 

        self.lord_name:setString(leaderData.lUserName)
        self.portrait_node.pic:setVisible(true)
    else
        self.lord_name:setString('')
        self.headFrame:setVisible(false)
        self.portrait_node.pic:setVisible(false)
    end

    self.offical:setString(luaCfg:get_official_post_by(101).typeName)

    self.motherKing:setData(201,curLandTree[201])

    -- 初始化二级领主
    local lead2id = {201,301,401,501}
    for i = 2,4 do
        self['top_' .. i]:setData(lead2id[i],curLandTree[lead2id[i]])
    end

    -- 初始化3级
    local lead3id = {6,3,4,5}
    for i = 2,4 do
        self['bottom_' .. i]:setData(lead3id[i],curLandTree)
    end
end

function UIOfficalPanel:initData(msg)
    
    for _,v in ipairs(msg.tagOfficialer or {}) do


        if not self.offTree[v.lMapArea] then
            self.offTree[v.lMapArea] = {}
        end

        self.offTree[v.lMapArea][v.lOfficialID] = v
    end

    self:initTree()

    -- 下载用户头像
    if msg.tagOfficialer then
        local data = {}
        for i,v in pairs(msg.tagOfficialer) do
            if v.szCustomIco ~= "" then
                table.insert(data,v.szCustomIco)
            end
        end
        local storagePath = global.headData:downloadPngzips(data)
        table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
            -- body
            if self.initTree then
                self:initTree()
            end

            if global.panelMgr:isPanelOpened("UIOfficalInfoPanel") then 
                global.panelMgr:getPanel("UIOfficalInfoPanel"):reloadData()
            end 

        end))
    end
end

-- 检测自身的职位
function UIOfficalPanel:checkSelfPos(curLandTree)

    local selfUserId = global.userData:getUserId()

    for id,v in pairs(curLandTree) do
        if v.lUserID == selfUserId then
            return id
        end
    end

    return -1
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIOfficalPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIOfficalPanel")
end


function UIOfficalPanel:onGotoWorldHandler(sender, eventType)
    
    self.spread_node:stopAllActions() 
    if not self.isHide then        
        self.isHide = true
        self.spread_node:runAction(cc.MoveTo:create(0.2,cc.p(103,621)))
        -- self.out:runAction(cc.MoveTo:create(0.2,cc.p(691.5,272)))
    else
        self.isHide = false
        self.spread_node:runAction(cc.MoveTo:create(0.2,cc.p(103,295)))
        -- self.out:runAction(cc.MoveTo:create(0.2,cc.p(753.5,272)))
    end    
end

function UIOfficalPanel:choose(landId)
    self.curLandId = landId
    self:initTree()
    self:onGotoWorldHandler() 
end

function UIOfficalPanel:choose_1(sender, eventType)
    self:choose(1)
end

function UIOfficalPanel:choose_2(sender, eventType)
    self:choose(2)
end

function UIOfficalPanel:choose_3(sender, eventType)
    self:choose(3)
end

function UIOfficalPanel:choose_4(sender, eventType)
    self:choose(4)
end

function UIOfficalPanel:check_top1(sender, eventType)
    
    global.panelMgr:openPanel('UIOfficalInfoPanel'):setData(101,self.leaderData)
end

function UIOfficalPanel:onHelp(sender, eventType)

    local data = luaCfg:get_introduction_by(28)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end
--CALLBACKS_FUNCS_END

return UIOfficalPanel

--endregion
