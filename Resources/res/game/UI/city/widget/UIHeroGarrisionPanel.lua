--region UIHeroGarrisionPanel.lua
--Author : untory
--Date   : 2017/02/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UIHeroGarrisionDescItem = require("game.UI.city.widget.UIHeroGarrisionDescItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIGarrionItem = require("game.UI.hero.UIHeroGarrisonWidget.UIGarrionItem")
--REQUIRE_CLASS_END

local UIHeroGarrisionPanel  = class("UIHeroGarrisionPanel", function() return gdisplay.newWidget() end )

function UIHeroGarrisionPanel:ctor()
    self:CreateUI()
end

function UIHeroGarrisionPanel:CreateUI()
    local root = resMgr:createWidget("hero/hero_garrison")
    self:initUI(root)
end
 
function UIHeroGarrisionPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/hero_garrison")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.suface_title = self.root.node_top.suface_title_export
    self.infoflag = self.root.infoflag_export
    self.descScroll = self.root.infoflag_export.descScroll_export
    self.desc_node = self.root.infoflag_export.descScroll_export.desc_node_export
    self.commander_info = self.root.infoflag_export.commander_info_export
    self.item1 = self.root.item1_export
    self.item1 = UIGarrionItem.new()
    uiMgr:configNestClass(self.item1, self.root.item1_export)
    self.item2 = self.root.item2_export
    self.item2 = UIGarrionItem.new()
    uiMgr:configNestClass(self.item2, self.root.item2_export)

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.suface_title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
end

function UIHeroGarrisionPanel:setCloseCall(call)
    self.closeCall = call
end

function UIHeroGarrisionPanel:initTouchListener()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(true)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.root.touch)
end

function UIHeroGarrisionPanel:onTouchBegan(touch, event)
    return true
end

function UIHeroGarrisionPanel:onTouchEnded(touch, event)
    self:onCloseHandler()
end

function UIHeroGarrisionPanel:onEnter(touch, event)    

    global.g_cityView:setUIVisible(false)
    self:initTouchListener()

    self.item1:setData(1)
    self.item2:setData(2)

    self:flushBuff()
end

function UIHeroGarrisionPanel:flushBuff()
    
    -- self.buff:setString("")
    -- self.buff_add:setString("")

    self.desc_node:removeAllChildren()

    local add = self.item1:getGovInfo() + self.item2:getGovInfo()
    local buffs = {}



    if add ~= 0 then

        self.commander_info:setString(luaCfg:get_local_string(10671, add))
        self.commander_info:setVisible(true)        

        local add = math.floor(add / luaCfg:get_config_by(1).garrisonScale)
        local type1 = luaCfg:get_local_string(10348)
        local type2 = luaCfg:get_local_string(10351)

        table.insert(buffs,{desc = type1,num = add})
        table.insert(buffs,{desc = type2,num = add})        
    else
        self.commander_info:setVisible(false)
    end

    local otherBuffList = {}
    for i = 1,2 do

        local heroData = self["item"..i]:getHeroData()
        if heroData then

            local skills = heroData.serverData.lSkill
            for _,v in ipairs(skills) do

                if v ~= 0 then
                    
                    local skillData = luaCfg:get_skill_by(v)
                    if skillData.garrison == 1 then

                        local buffId = skillData.buff[1]
                        local buffValue = skillData.value[1]
                        otherBuffList[buffId] = otherBuffList[buffId] or 1
                        otherBuffList[buffId] =  (1 - buffValue/100)*otherBuffList[buffId]
                    end
                end                
            end
        end
    end

    for k,v in pairs(otherBuffList) do
        
        local leagueCfg = luaCfg:get_data_type_by(k)
        local str = string.format("%s%s%s", (1-v)*100, leagueCfg.str,leagueCfg.extra)

        table.insert(buffs,{desc = leagueCfg.paraName,num = str})
    end

    local count = #buffs
    for i = 1,count do

        local garrisonItem = UIHeroGarrisionDescItem.new()
        self.desc_node:addChild(garrisonItem)
        garrisonItem:setPositionY(i * 70 - 70 * (count + 1) / 2)

        garrisonItem:setData(buffs[i])
    end

    local innerSize = count * 70
    innerSize = innerSize > 250 and innerSize or 250

    self.descScroll:setInnerContainerSize(cc.size(240,70 * count))
    self.desc_node:setPositionY(innerSize / 2)

    --[[

    local add = self.item1:getGovInfo() + self.item2:getGovInfo()
    local buffStr = ""
    local buffAddStr = ""

    local insertBuff = function(str,strAdd)

        buffStr = buffStr.. str .. "\n\n\n"
        buffAddStr = buffAddStr .. "\n" .. strAdd .. "\n\n"
    end

    if add == 0 then

        self.buff:setString("")
        self.buff_add:setString("")
    else

        local add = math.floor(add / 100) * 0.1 .. "%"
        local type1 = luaCfg:get_local_string(10348)
        local type2 = luaCfg:get_local_string(10351) 
        -- self.buff:setString(string.format("%s\n\n\n%s\n\n\n",type1,type2))
        -- self.buff_add:setString(string.format("\n%s\n\n\n%s\n\n",add,add))

        insertBuff(type1,add)
        insertBuff(type2,add)        
    end    

    local otherBuffList = {}
    for i = 1,2 do

        local heroData = self["item"..i]:getHeroData()
        if heroData then

            local skills = heroData.serverData.lSkill
            for _,v in ipairs(skills) do

                if v ~= 0 then
                    
                    local skillData = luaCfg:get_skill_by(v)
                    if skillData.garrison == 1 then

                        local buffId = skillData.buff[1]
                        local buffValue = skillData.value[1]
                        otherBuffList[buffId] = otherBuffList[buffId] or 0
                        otherBuffList[buffId] = otherBuffList[buffId] + buffValue
                    end
                end                
            end
        end
    end

    for k,v in pairs(otherBuffList) do
    
        local leagueCfg = luaCfg:get_data_type_by(k)
        local str = string.format("%s%s%s",v,leagueCfg.str,leagueCfg.extra)

        insertBuff(leagueCfg.paraName,str)
    end

    self.buff:setString(buffStr)
    self.buff_add:setString(buffAddStr)

    ]]--
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeroGarrisionPanel:onCloseHandler(sender, eventType)
    global.g_cityView:setUIVisible(true)
    global.panelMgr:closePanelForBtn("UIHeroGarrisionPanel")
    if self.closeCall then self.closeCall() end
end

--CALLBACKS_FUNCS_END

return UIHeroGarrisionPanel

--endregion
