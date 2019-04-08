
--region UIUBuildItem.lua
--Author : wuwx
--Date   : 2017/02/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUBuildItem  = class("UIUBuildItem", function() return gdisplay.newWidget() end )

function UIUBuildItem:ctor()
    self:CreateUI()
end

function UIUBuildItem:CreateUI()
    local root = resMgr:createWidget("union/union_build_list")
    self:initUI(root)
end

function UIUBuildItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_build_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.ing = self.root.Button_1.ing_mlan_6_export
    self.name = self.root.Button_1.text.name_export
    self.lv = self.root.Button_1.text.name_export.lv_export
    self.info2 = self.root.Button_1.text.info2_mlan_3_export
    self.text2 = self.root.Button_1.text.info2_mlan_3_export.text2_export
    self.label = self.root.Button_1.text.info2_mlan_3_export.label_export
    self.effectNode = self.root.Button_1.text.info2_mlan_3_export.effectNode_export
    self.nextEffect = self.root.Button_1.text.info2_mlan_3_export.effectNode_export.nextEffect_export
    self.nextLvJin = self.root.Button_1.text.info2_mlan_3_export.effectNode_export.nextLvJin_export
    self.info4 = self.root.Button_1.text.info4_mlan_7_export
    self.text4 = self.root.Button_1.text.text4_export
    self.info5 = self.root.Button_1.text.info5_mlan_7_export
    self.text5_num = self.root.Button_1.text.text5_num_export
    self.icon = self.root.Button_1.node_icon.icon_export
    self.effect = self.root.Button_1.effect_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:infoHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.root.Button_1:setSwallowTouches(false)
    self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)

end

function UIUBuildItem:onEnter()
    -- body
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("union/union_build_list")
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)
end

function UIUBuildItem:setData(data)
    self.data = data
    -- [1] = { id=1,  name="联盟大厅",  typelevel=1,  array=1,  Lvbasics=1,  Lvmax=10,  effect=1,  icon="mapunit/c_101.png",  },

    self.sData = global.unionData:getInUnionBuildsBy(self.data.id)
    if not self.sData then return end
    global.panelMgr:setTextureFor(self.icon,self.data.sData.icon)

    self.name:setString(self.data.sData.name)
    local nextLvId = self.data.id*1000+(self.sData.lLevel+1)
    local currLvId = self.data.id*1000+self.sData.lLevel
    local strs = {}

    self.isCanUpgrade = true
    self.ing:setVisible(self.sData.lState == 1)
    self.effect:setVisible(self.sData.lState == 1)

    self.text5_num:setTextColor(cc.c3b(255,226,165))
    self.text4:setTextColor(cc.c3b(255,226,165))

    if self:isMaxLv() then
        --等级已满
        strs[1] = "-"
        strs[4] = "-"
    else
        local nextLvData = global.luaCfg:get_union_build_levle_by(nextLvId)
        self.nextLvData = nextLvData
        local nextEffectData = global.luaCfg:get_union_build_effect_by(nextLvId)
        self.nextEffectData = nextEffectData
        strs[1] = nextLvData.Boom
        strs[4] = global.luaCfg:get_local_string(10371,nextLvData.hallLv)

        if not global.unionData:isEnoughInUnionBuildsHallLv(nextLvData.hallLv) then
            self.text4:setTextColor(cc.c3b(180,29,11))
            global.colorUtils.turnGray(self.text5_num, true)
            self.isCanUpgrade = false
        elseif not global.unionData:isEnoughInUnionStrong(nextLvData.Boom) then
            self.text5_num:setTextColor(cc.c3b(180,29,11))
        end
    end
    
    if self.sData.lLevel <= 0 then
        self.lv:setString(global.luaCfg:get_local_string(10369))
        strs[2] = global.luaCfg:get_local_string(10370)
        self.effectNode:setVisible(false)
    else
        self.currLvData = global.luaCfg:get_union_build_levle_by(currLvId)
        self.currEffectData = global.luaCfg:get_union_build_effect_by(currLvId)
        self.lv:setString("Lv"..self.sData.lLevel)
        strs[2] = global.luaCfg:get_local_string(self.currEffectData.text)
        if self:isMaxLv() then
            self.lv:setString("LvMax")
            self.effectNode:setVisible(false)
        else
            self.effectNode:setVisible(self.isCanUpgrade == true)
            self.nextEffect:setString(self.nextEffectData.typelevel)
            if self.nextEffectData.datatype > 0 then
                local dataType = global.luaCfg:get_data_type_by(self.nextEffectData.datatype)
                self.nextEffect:setString(self.nextEffectData.typelevel .. dataType.extra)
            end
        end
    end

    --繁荣度
    self.text5_num:setString(strs[1])
    --当前效果
    self.text2:setString(strs[2])
    --建设升级条件
    self.text4:setString(strs[4])

    -- 没有满足升级条件
    global.colorUtils.turnGray(self.icon, self.isCanUpgrade == false)
    global.colorUtils.turnGray(self.name, self.isCanUpgrade == false)
    global.colorUtils.turnGray(self.info2, self.isCanUpgrade == false)
    global.colorUtils.turnGray(self.info4, self.isCanUpgrade == false)
    global.colorUtils.turnGray(self.info5, self.isCanUpgrade == false)
    

--润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.text2:getParent(),self.text2)
    global.tools:adjustNodePosForFather(self.lv:getParent(),self.lv)
    global.tools:adjustNodePos(self.info4, self.text4)
    global.tools:adjustNodePos(self.info5, self.text5_num)

    -- 实现跟随自定义尺寸文本后特殊处理
    self.label:setString(self.text2:getString())
    local curWidth = self.label:getContentSize().width
    local textWidth = self.text2:getContentSize().width
    if curWidth > textWidth then
        self.effectNode:setPositionX(self.text2:getPositionX() + textWidth)
    else
        self.effectNode:setPositionX(self.text2:getPositionX() + curWidth)
    end 

end

function UIUBuildItem:isMaxLv()
    return self.sData.lLevel >= self.data.sData.Lvmax
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUBuildItem:infoHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIUBuildPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end
        global.panelMgr:openPanel("UIUBuildInfo"):setData(self.data,self.isCanUpgrade)
    end
end
--CALLBACKS_FUNCS_END

return UIUBuildItem

--endregion
