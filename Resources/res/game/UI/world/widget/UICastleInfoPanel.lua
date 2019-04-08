--region UICastleInfoPanel.lua
--Author : wuwx
--Date   : 2016/11/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UICastleInfoPanel  = class("UICastleInfoPanel", function() return gdisplay.newWidget() end )

function UICastleInfoPanel:ctor()
    self:CreateUI()
end

function UICastleInfoPanel:CreateUI()
    local root = resMgr:createWidget("world/info/castle_info")
    self:initUI(root)
end

function UICastleInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/castle_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.title = self.root.title_export
    self.scrollView = self.root.scrollView_export
    self.ps_node = self.root.scrollView_export.ps_node_export
    self.bot_bg = self.root.scrollView_export.bot_bg_export
    self.qianming_input = self.root.scrollView_export.Node_1.qianming_input_export
    self.qianming_input = UIInputBox.new()
    uiMgr:configNestClass(self.qianming_input, self.root.scrollView_export.Node_1.qianming_input_export)
    self.city_icon = self.root.scrollView_export.Node_1.city_icon_export
    self.loadingbar_bg = self.root.scrollView_export.loadingbar_bg_export
    self.LoadingBar = self.root.scrollView_export.loadingbar_bg_export.LoadingBar_export
    self.now_num = self.root.scrollView_export.loadingbar_bg_export.now_num_export
    self.total_num = self.root.scrollView_export.loadingbar_bg_export.total_num_export
    self.castle_name = self.root.scrollView_export.player_info.castle_name_export
    self.castle_lv = self.root.scrollView_export.player_info.castle_lv_export
    self.text11 = self.root.scrollView_export.player_info.text11_mlan_4_export
    self.text12 = self.root.scrollView_export.player_info.text12_mlan_5_export
    self.text13 = self.root.scrollView_export.player_info.text13_mlan_4_export
    self.text14 = self.root.scrollView_export.player_info.text14_mlan_4_export
    self.text15 = self.root.scrollView_export.player_info.text15_mlan_4_export
    self.text1 = self.root.scrollView_export.player_info.text1_export
    self.text2 = self.root.scrollView_export.player_info.text2_export
    self.text3 = self.root.scrollView_export.player_info.text3_export
    self.text4 = self.root.scrollView_export.player_info.text4_export
    self.text5 = self.root.scrollView_export.player_info.text5_export
    self.text16 = self.root.scrollView_export.player_info.text16_mlan_6_export
    self.text6_now = self.root.scrollView_export.player_info.text6_now_export
    self.text6_1 = self.root.scrollView_export.player_info.text6_1_export
    self.text6_max = self.root.scrollView_export.player_info.text6_max_export
    self.text19 = self.root.scrollView_export.player_info.text19_mlan_6_export
    self.text7_now = self.root.scrollView_export.player_info.text7_now_export
    self.text7_1 = self.root.scrollView_export.player_info.text7_1_export
    self.text7_max = self.root.scrollView_export.player_info.text7_max_export
    self.text17 = self.root.scrollView_export.player_info.text17_mlan_6_export
    self.text8_now = self.root.scrollView_export.player_info.text8_now_export
    self.text8_1 = self.root.scrollView_export.player_info.text8_1_export
    self.text8_max = self.root.scrollView_export.player_info.text8_max_export
    self.txt11 = self.root.scrollView_export.info2.txt11_mlan_4_export
    self.txt12 = self.root.scrollView_export.info2.txt12_mlan_3_export
    self.txt13 = self.root.scrollView_export.info2.txt13_mlan_5_export
    self.txt14 = self.root.scrollView_export.info2.txt14_mlan_4_export
    self.txt15 = self.root.scrollView_export.info2.txt15_mlan_6_export
    self.txt2 = self.root.scrollView_export.info2.txt2_export
    self.txt3 = self.root.scrollView_export.info2.txt3_export
    self.txt4 = self.root.scrollView_export.info2.txt4_export
    self.txt5 = self.root.scrollView_export.info2.txt5_export
    self.Button_6 = self.root.scrollView_export.Button_6_export
    self.Button_5 = self.root.scrollView_export.Button_5_export
    self.Button_7 = self.root.scrollView_export.Button_7_export
    self.skin_bt = self.root.scrollView_export.skin_bt_export

    uiMgr:addWidgetTouchHandler(self.root.scrollView_export.Node_1.Panel_3, function(sender, eventType) self:edit_tips(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollView_export.Button_1, function(sender, eventType) self:lordDetailHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollView_export.Button_2, function(sender, eventType) self:unionDetailHandle(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollView_export.Button_4, function(sender, eventType) self:sendMailHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_6, function(sender, eventType) self:cancelHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_5, function(sender, eventType) self:setWarningHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_7, function(sender, eventType) self:queryOccupy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.scrollView_export.Button_8, function(sender, eventType) self:editDeclaration(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.skin_bt, function(sender, eventType) self:iconChange_click(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    -- global.panelMgr:trimScrollView(self.scrollView,self.top)
    self:adapt()
    self.qianming_input:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)

    self.qianming_input:setTextColor(cc.c3b(255,226,165))
    self.qianming_input:setMaxLength(100)
end


function UICastleInfoPanel:adapt()

    local sHeight= (gdisplay.height - self.top:getContentSize().height)
    local defY = self.scrollView:getContentSize().height
    self.scrollView:setContentSize(cc.size(gdisplay.width, sHeight))
    local minsize= cc.size(gdisplay.width, defY)
    if sHeight < defY then 

    else
        self.scrollView:setTouchEnabled(false)
        self.scrollView:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.scrollView:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.scrollView:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
        local old = self.bot_bg:getContentSize()

        print(self.bot_bg:getPositionY() ,"self.bot_bg:getPositionY()")
        
        self.bot_bg:setContentSize(cc.size(old.width , old.height+self.bot_bg:getPositionY()-10))
        self.bot_bg:setPositionY(10)
    end 

end 


function UICastleInfoPanel:initEventListener()
    local callBB = function(eventName,msg)
        -- body
        if self.defChange then
            self:defChange(msg)
        end
    end
    self:addEventListener(global.gameEvent.EV_ON_WORLD_CITY_DEF_CHANGE,callBB)

    self:addEventListener(global.gameEvent.EV_ON_CASTLE_SKILL_UPDATE,function()
        if  self.city:getId() == global.userData:getWorldCityID() then 
            global.panelMgr:setTextureFor(self.city_icon,global.userCastleSkinData:getCrutSkin().worldmap)
        end 
    end)
    
end

function UICastleInfoPanel:onEnter()
    self:initEventListener()
    self.qianming_input:addEventListener(handler(self, self.nameEditCall))
    -- self.qianming_input:setString("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    -- self.qianming_input:ignoreContentAdaptWithSize(false)
    -- self.qianming_input:setSize(cc.size(650, 200))
 end

function UICastleInfoPanel:nameEditCall(eventType)
    if eventType == "return" then
        self.lastName = self.qianming_input:getString()
        self:checkQianMing(self.lastName)
    end
end

function UICastleInfoPanel:checkQianMing(str)
    print(global.userData:getUserId(),"sdfsdf")
    global.cityApi:modifyCitySimpleIntroduction(tonumber(self.DetailData.lCitys.lCityID), str , function(msg)
        global.tipsMgr:showWarning("Autograph01")
    end)
end  

function UICastleInfoPanel:onExit()
    if self.m_scheduleId then
        gscheduler.unscheduleGlobal(self.m_scheduleId)
        self.m_scheduleId = nil
    end
end

function UICastleInfoPanel:setData(city,data,defData)
    self.city = city

    self.surfaceData = data
    self.m_isSelfCity = global.userData:isSelfCity(self.city:getId())

    local lordData = self.city:getLordData()
    local occupierData = self.city:getOccupierData()

    -- self.city_icon:loadTexture( city:getIconPath(), ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.city_icon,city:getIconPath())
    self.castle_name:setString(self.city:getName())

    self.castle_lv:setString(string.format(luaCfg:get_local_string(10019),self.city:getCastleLv()))

    global.tools:adjustNodePos(self.castle_name,self.castle_lv)
    

    if lordData then
        --领主名字
        self.text1:setString(lordData.szUserName)
        --领主等级
        self.text2:setString(lordData.lUserGrade)
        self.text3:setString(self.city:getRaceName(lordData.lKind))
        self.text4:setString(global.unionData:getUnionShortName(lordData.szAllyName))
        self.text5:setString(lordData.lPowerLord)
    end

    self.txt2:setString("-")
    --地点特色

    self.txt3:setString("")
    for i,pair in ipairs(self.city:getPlusData()) do
    
        local douhao = i == 1 and '' or ','
        self.txt3:setString(self.txt3:getString() .. douhao .. global.buffData:getBuffStrBy(pair))
    end

    self.txt4:setString("-")
    self.txt5:setString("-")

    if occupierData then
        self.txt4:setString(occupierData.szUserName)
        self.txt5:setString(global.unionData:getUnionShortName(occupierData.szAllyName))
    end


    self:defChange(defData)

    self.Button_5:setVisible(true)
    self.Button_6:setVisible(true)
    
    local relationFlag = self.city:getRelationFlag()
    if relationFlag == 1 then
        self.Button_5:setVisible(false)
    else
        self.Button_6:setVisible(false)
    end
    
    --润稿翻译处理 张亮
    global.tools:adjustNodePos(self.text11,self.text1)
    global.tools:adjustNodePos(self.text12,self.text2)
    global.tools:adjustNodePos(self.text13,self.text3)
    global.tools:adjustNodePos(self.text14,self.text4)
    global.tools:adjustNodePos(self.text15,self.text5)


    global.tools:adjustNodePos(self.text16,self.text6_now)
    global.tools:adjustNodePos(self.text6_now,self.text6_1)
    global.tools:adjustNodePos(self.text6_1,self.text6_max)


    global.tools:adjustNodePos(self.text19,self.text7_now)
    global.tools:adjustNodePos(self.text7_now,self.text7_1)
    global.tools:adjustNodePos(self.text7_1,self.text7_max)

    global.tools:adjustNodePos(self.text17,self.text8_now)
    global.tools:adjustNodePos(self.text8_now,self.text8_1)
    global.tools:adjustNodePos(self.text8_1,self.text8_max)

    global.tools:adjustNodePos(self.txt12,self.txt2)
    global.tools:adjustNodePos(self.txt13,self.txt3)
    global.tools:adjustNodePos(self.txt14,self.txt4)
    global.tools:adjustNodePos(self.txt15,self.txt5)



end


function UICastleInfoPanel:getVIPCount(leavel , effectid)

    local vipData  = global.luaCfg:get_vip_func_by(leavel)

    if vipData then 
        for _ ,v in ipairs(vipData.buffID) do 
            if v[1]  == effectid then 
                return v[2]
            end 
        end 
    else 
        global.tipsMgr:showWarning("erroce 248 ")
    end 

    return   0 
end 

function UICastleInfoPanel:setDetailData( data )

    self.DetailData = data

    local vip_level = 0 
    if  data.lCitys and data.lCitys.tagCityUser then 
       vip_level =  data.lCitys.tagCityUser.lVIPLevel or 0 
    end 

    local vip_Village  =  self:getVIPCount(vip_level , 3077) 
    local vip_Resource =  self:getVIPCount(vip_level , 3078)  
    local vip_tagCity  =  self:getVIPCount(vip_level , 3076) 

    print(vip_Village , vip_Resource , vip_tagCity)
    self.text6_now:setString(data.tagVillage.lCurOccupy) --鏉戝簞
    self.text6_max:setString(data.tagVillage.lMaxOccupy+vip_Village)
    self.text7_now:setString(data.tagResource.lCurOccupy) --閲庡湴
    self.text7_max:setString(data.tagResource.lMaxOccupy+vip_Resource)
    self.text8_now:setString(data.tagCity.lCurOccupy) --鍩庡牎
    self.text8_max:setString(data.tagCity.lMaxOccupy+vip_tagCity)

    local content = "" 
    if self.DetailData.lCitys.lProfile then 
        content = self.DetailData.lCitys.lProfile
    else 
        content = global.luaCfg:get_local_string(10638)
    end 
    if   self.qianming_input then 
        self.qianming_input:setString(content)
    end 
    self.qianming_input:setEnabled(self.DetailData.lCitys.tagCityUser.lUserID == global.userData:getUserId())

    self.skin_bt:setVisible(self.DetailData.lCitys.tagCityUser.lUserID == global.userData:getUserId())
end

function UICastleInfoPanel:defChange(defData)

    defData.lDefense  = defData.lDefense or 0 
    defData.lMaxDefense  = defData.lMaxDefense or 0 

    if defData.lDefense > defData.lMaxDefense then
        defData.lDefense = defData.lMaxDefense
    end
    self.now_num:setString(defData.lDefense)
    self.total_num:setString(defData.lMaxDefense)
    self.LoadingBar:setPercent(defData.lDefense/defData.lMaxDefense*100)

    if self.m_scheduleId and defData.lDefense <= 0 then
        if self.exitPanel then
            self:exitPanel()
        end
        gscheduler.unscheduleGlobal(self.m_scheduleId)
        self.m_scheduleId = nil
    else
        local callBB1 = function(eventName,msg)
            -- body

            local lFlag = true
            if tolua.isnull(self.city) then return end
            local lCityID = self.city:getId()
            local function call(msg) 
                -- body
                if self.defChange then
                    self:defChange(msg)
                end
            end
            local function errorCall()
                if self.exitPanel then
                    self:exitPanel()
                end
            end
            global.worldApi:worldCityDef(call, lFlag, lCityID, errorCall)
        end
        if not self.m_scheduleId then
            self.m_scheduleId = gscheduler.scheduleGlobal(callBB1, 2)
        end
    end
end

--不带音效的退出界面
function UICastleInfoPanel:exitPanel()
    
    if not global.panelMgr:isPanelOpened("UICastleInfoPanel") then
        
        if self.m_scheduleId then
            gscheduler.unscheduleGlobal(self.m_scheduleId)
        end
        
        return
    end

    local lFlag = false
    local lCityID = self.city:getId()
    local function call()
        -- body
        panelMgr:closePanel("UICastleInfoPanel")
    end

    local function errorCall()
        -- 城池已经烧毁或者状态错误关闭界面
        if not self.m_isSelfCity then
            global.tipsMgr:showWarning("CityBurnInCity")
        end
        panelMgr:closePanel("UICastleInfoPanel")
    end
    global.worldApi:worldCityDef(call, lFlag, lCityID,errorCall)
end

function UICastleInfoPanel:onCloseHandler(sender, eventType)
    local lFlag = false
    local lCityID = self.city:getId()
    local function call()
        -- body
        panelMgr:closePanelForBtn("UICastleInfoPanel")
    end

    local function errorCall()
        -- body
        panelMgr:closePanelForBtn("UICastleInfoPanel")
    end
    global.worldApi:worldCityDef(call, lFlag, lCityID,errorCall)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UICastleInfoPanel:lordDetailHandler(sender, eventType)
  --
  local selectUserId = self.surfaceData.id
          global.chatApi:getUserInfo(function(msg)
            msg.tgInfo = msg.tgInfo or {}
            local panel = global.panelMgr:openPanel("UIChatUserInfoPanel")
            panel:setData(msg.tgInfo[1])
        end,  {self.DetailData.lCitys.tagCityUser.lUserID})
end

function UICastleInfoPanel:makeFriendHandler(sender, eventType)
    global.tipsMgr:showWarning("FuncNotFinish")
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10194, handler(self, self.warningCall))
end


local INPUT_MODE = {
    NORMAL = 0,
    FOREIGN = 1,
}

function UICastleInfoPanel:unionDetailHandle(sender, eventType)
    if self.city:getLordData().szAllyName then 
        global.unionApi:getUnionInfo(function (msg)
        msg.tgAlly = msg.tgAlly or {}
        local panel  = panelMgr:openPanel("UIJoinUnionPanel")
        panel:setData(msg.tgAlly)
        panel.m_inputMode  = INPUT_MODE.NORMAL
        panel:updateUI()
        end, self.DetailData.lCitys.tagCityUser.lAllyID)
   else 
        global.tipsMgr:showWarning("castle_union")
   end       
end

function UICastleInfoPanel:sendMailHandler(sender, eventType)
     if self.DetailData.lCitys.tagCityUser.lUserID == global.userData:getUserId() then
        global.tipsMgr:showWarning("unionMyNot")
        return 
    end 
    global.panelMgr:openPanel("UIChatPrivatePanel"):init( self.DetailData.lCitys.tagCityUser.lUserID ,  self.DetailData.lCitys.tagCityUser.szUserName)
end
 

function UICastleInfoPanel:cancelHandler(sender, eventType)

    if self.city:getId() ~= global.userData:getWorldCityID() then

        global.tipsMgr:showWarning("CantSetOtherGuard")
        return 
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10195, handler(self, self.cancelCall))
    
end

function UICastleInfoPanel:cancelCall()
    
    global.worldApi:setAlert(0, function(msg)
        
        self.city.stop:setVisible(false)
        self.Button_5:setVisible(true)
        self.Button_6:setVisible(false)
    end)
end

function UICastleInfoPanel:setWarningHandler(sender, eventType)

    -- local userId = global.userData:getUserId()
    -- local lordData = self.city:getLordData()
    -- if lordData.lUserID ~= userId then
    --     global.tipsMgr:showWarning("CantSetOtherGuard")
    --     return
    -- end


    if self.city:getId() ~= global.userData:getWorldCityID() then

        global.tipsMgr:showWarning("CantSetOtherGuard")
        return 
    end

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(10194, handler(self, self.warningCall))
    
end

function UICastleInfoPanel:warningCall()    

    global.worldApi:setAlert(1, function(msg)

        self.city.stop:setVisible(true)
        self.Button_5:setVisible(false)
        self.Button_6:setVisible(true)
    end)
end


function UICastleInfoPanel:queryOccupy(sender, eventType)
    
    local userId = global.userData:getUserId()
    local lordData = self.city:getLordData()
    if lordData.lUserID ~= userId then
        global.tipsMgr:showWarning("cannotlookoc")
        return
    end

    local panel = global.panelMgr:openPanel("UIOccupyPanel")
end

function UICastleInfoPanel:editDeclaration(sender, eventType)
   if self.DetailData.lCitys.tagCityUser.lUserID ~= global.userData:getUserId() then
        global.tipsMgr:showWarning("Autograph02")
        return 
    end 
    self.qianming_input:touchDownAction()
end

function UICastleInfoPanel:edit_tips(sender, eventType)
    if self.DetailData.lCitys.tagCityUser.lUserID ~= global.userData:getUserId() then
        global.tipsMgr:showWarning("Autograph02")
    end 
end

function UICastleInfoPanel:iconChange_click(sender, eventType)
    
    global.panelMgr:openPanel("UISelectSkinPanel")

end
--CALLBACKS_FUNCS_END

return UICastleInfoPanel

--endregion
