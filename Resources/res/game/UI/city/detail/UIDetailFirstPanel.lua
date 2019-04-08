--region UIDetailFirstPanel.lua
--Author : wuwx
--Date   : 2016/10/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDetailFirstProItem = require("game.UI.city.detail.widget.UIDetailFirstProItem")
--REQUIRE_CLASS_END

local UIDetailFirstPanel  = class("UIDetailFirstPanel", function() return gdisplay.newWidget() end )

function UIDetailFirstPanel:ctor()
    self:CreateUI()
end

function UIDetailFirstPanel:CreateUI()
    local root = resMgr:createWidget("city/build_info_1st")
    self:initUI(root)
end

function UIDetailFirstPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_info_1st")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.suface_title = self.root.node_top.suface_title_export
    self.Text_build_name = self.root.node_top.Sprite_build_name.Text_build_name_export
    self.infoflag = self.root.infoflag_export
    self.lv_num = self.root.infoflag_export.lv_num_export
    self.lv_info = self.root.infoflag_export.lv_info_export
    self.ScrollView_1 = self.root.node.ScrollView_1_export
    self.num_node = self.root.node.ScrollView_1_export.num_node_export
    self.ui_text1 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text1, self.root.node.ScrollView_1_export.num_node_export.ui_text1)
    self.ui_text2 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text2, self.root.node.ScrollView_1_export.num_node_export.ui_text2)
    self.ui_text3 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text3, self.root.node.ScrollView_1_export.num_node_export.ui_text3)
    self.ui_text4 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text4, self.root.node.ScrollView_1_export.num_node_export.ui_text4)
    self.ui_text5 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text5, self.root.node.ScrollView_1_export.num_node_export.ui_text5)
    self.ui_text6 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text6, self.root.node.ScrollView_1_export.num_node_export.ui_text6)
    self.ui_text7 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text7, self.root.node.ScrollView_1_export.num_node_export.ui_text7)
    self.ui_text8 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text8, self.root.node.ScrollView_1_export.num_node_export.ui_text8)
    self.ui_text9 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text9, self.root.node.ScrollView_1_export.num_node_export.ui_text9)
    self.ui_text10 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text10, self.root.node.ScrollView_1_export.num_node_export.ui_text10)
    self.ui_text11 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text11, self.root.node.ScrollView_1_export.num_node_export.ui_text11)
    self.ui_text12 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text12, self.root.node.ScrollView_1_export.num_node_export.ui_text12)
    self.ui_text13 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text13, self.root.node.ScrollView_1_export.num_node_export.ui_text13)
    self.ui_text14 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text14, self.root.node.ScrollView_1_export.num_node_export.ui_text14)
    self.ui_text15 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text15, self.root.node.ScrollView_1_export.num_node_export.ui_text15)
    self.ui_text16 = UIDetailFirstProItem.new()
    uiMgr:configNestClass(self.ui_text16, self.root.node.ScrollView_1_export.num_node_export.ui_text16)
    self.txt_node = self.root.node.txt_node_export
    self.text = self.root.node.txt_node_export.text_export
    self.btn_upgrade = self.root.node.btn_upgrade_export

    uiMgr:addWidgetTouchHandler(self.btn_upgrade, function(sender, eventType) self:onMoreInfoHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.suface_title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    -- 屏幕适配

    self.title = self.root.node.title
    self.bg_node = self.root.node.Image_1

    local y = self.title:convertToWorldSpace((cc.p(0,0))).y 
    local part_y = 100 
    local yy = 0 
    if  y  >  gdisplay.height /2 - part_y then 
        yy =  y -(gdisplay.height /2 - part_y)
        self.title:setPositionY(self.title:getPositionY() -yy)
    end
    if yy > 0 then 
        local contentSize= self.bg_node:getContentSize()
        self.bg_node:setContentSize(cc.size(contentSize.width , contentSize.height -yy  ))

        contentSize= self.ScrollView_1:getContentSize()
        self.ScrollView_1:setContentSize(cc.size(contentSize.width , contentSize.height -yy  ))
    end 



end

function UIDetailFirstPanel:onEnter(touch, event)
    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.node_res)

    global.g_cityView:setUIVisible(false)
    self:initTouchListener()
end

function UIDetailFirstPanel:initTouchListener()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(true)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.root.touch)
end

function UIDetailFirstPanel:onTouchBegan(touch, event)
    return true
end

function UIDetailFirstPanel:onTouchEnded(touch, event)
    self:onCloseHandler()
end

function UIDetailFirstPanel:onEnter(touch, event)
    global.g_cityView:setUIVisible(false)
    self:initTouchListener()
end


function UIDetailFirstPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDetailFirstPanel:onMoreInfoHandler(sender, eventType)
    local detailPanel = global.panelMgr:openPanel("UICityDetailPanel")
    detailPanel:setData(self.data)
end
--CALLBACKS_FUNCS_END

function UIDetailFirstPanel:setData(data)
    self.data = data

    self.Text_build_name:setString(data.buildsName.." "..luaCfg:get_local_string(10019,data.serverData.lGrade))
    self.lv_info:setString(data.description)
    self.lv_num:setString(data.serverData.lGrade)

    local needShow = data.infoDes==""
    self.num_node:setVisible(needShow)
    self.txt_node:setVisible(not needShow)
    self.text:setString(data.infoDes)

    if needShow then
        local infoId = global.cityData:getBuildingsInfoId(data.buildingType,data.serverData.lGrade)
        local infos = clone(luaCfg:get_buildings_info_by(infoId))
        if not infos then 
            --protect 
            return 
        end 
        local proData = {}
        if infos.switchId > 0 then
            infos = self:getLvUnlockSkill(infos, data)
            proData = infos.data
        else
            proData = infos.data
        end

        self.ui_text1:setVisible(true)
        self.ui_text1:setData(data,19,infos.combat,{})
        for i = 2,16 do
            local dataIdx = i-1
            local typePara = infos["typePara"..dataIdx]
            local paraNum = infos["para"..dataIdx.."Num"]
            if proData and proData[dataIdx] and proData[dataIdx] ~= 0 then
                self["ui_text"..i]:setVisible(true)
                self["ui_text"..i]:setData(data,proData[dataIdx],paraNum,{})
            else
                self["ui_text"..i]:setVisible(false)
            end
        end

        self:initScroll(proData)
    end 

    global.gmApi:effectBuffer({{lType = luaCfg:get_buildings_pos_by(data.id).funcType,lBind = data.id}},function(msg)

        -- dump(msg,">>>>>>>>>msg")
        if tolua.isnull(self.num_node) then return end

        local needShow = data.infoDes==""
        self.num_node:setVisible(needShow)
        self.txt_node:setVisible(not needShow)
        self.text:setString(data.infoDes)

        if needShow then
            local infoId = global.cityData:getBuildingsInfoId(data.buildingType,data.serverData.lGrade)
            local infos = clone(luaCfg:get_buildings_info_by(infoId))
            local proData = {}

            if infos.switchId > 0 then
                infos = self:getLvUnlockSkill(infos, data)
                proData = infos.data
            else
                proData = infos.data
            end
  
            self.ui_text1:setVisible(true)
            self.ui_text1:setData(data,19,infos.combat,{})
            for i = 2,16 do
                local dataIdx = i-1
                local typePara = infos["typePara"..dataIdx]
                local paraNum = infos["para"..dataIdx.."Num"]
                if proData and proData[dataIdx] and proData[dataIdx] ~= 0 then
                    self["ui_text"..i]:setVisible(true)
                    self["ui_text"..i]:setData(data,proData[dataIdx],paraNum,msg.tgEffect[1])
                else
                    self["ui_text"..i]:setVisible(false)
                end
            end

            self:initScroll(proData)
        end 
    end)    
end

-- 训练建筑士兵技能解锁效果
function UIDetailFirstPanel:getLvUnlockSkill(infos,  data)
    -- body
    local switchId = infos.switchId - 1
    local lockedSkill = {}
    local infoId = global.cityData:getBuildingsInfoId(data.buildingType,data.serverData.lGrade)
    local infosConfig = luaCfg:buildings_info(infoId)
    for _,v in pairs(infosConfig) do
        if v.type == data.buildingType and v.level <= data.serverData.lGrade and v.para3Num ~= "" then
            local temp = {}
            temp.typePara =  v.typePara3
            temp.paraNum  =  v.para3Num
            temp.lv = v.level
            table.insert(lockedSkill, temp)
        end
    end

    if #lockedSkill > 1 then
        table.sort(lockedSkill, function(s1, s2) return s1.lv < s2.lv end)
    end

    for i=1,15 do
        local dataParm = lockedSkill[i] 
        if dataParm then
            infos["typePara"..(i+switchId)] = dataParm.typePara
            infos["para"..(i+switchId).."Num"] = dataParm.paraNum
            infos.data[i+switchId] = infos.data[switchId+1]
        end
    end

    if infos["para"..(1+switchId).."Num"] and infos["para"..(1+switchId).."Num"] == "" then
        infos.data[switchId+1] = 0
    end

    return infos
end

function UIDetailFirstPanel:initScroll(proData)
    -- body
    local containSizeH = (#proData+1)*60
    local contentSizeH = self.ScrollView_1:getContentSize().height
    if containSizeH < contentSizeH then
        containSizeH = contentSizeH
    end
    for i=1,16 do
        self["ui_text"..i]:setPositionY(containSizeH-60*i+25)
    end

    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containSizeH))
    self.ScrollView_1:jumpToTop()
end

function UIDetailFirstPanel:setCloseCall(call)
    self.closeCall = call
end

function UIDetailFirstPanel:onCloseHandler(sender, eventType)
    global.g_cityView:setUIVisible(true)
    global.panelMgr:closePanelForBtn("UIDetailFirstPanel")
    if self.closeCall then self.closeCall() end
end

return UIDetailFirstPanel

--endregion
