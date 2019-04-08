--region UIWildResPro.lua
--Author : wuwx
--Date   : 2016/11/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildResPro  = class("UIWildResPro", function() return gdisplay.newWidget() end )

function UIWildResPro:ctor()
    
end

function UIWildResPro:CreateUI()
    local root = resMgr:createWidget("wild/wild_currency1")
    self:initUI(root)
end

function UIWildResPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_currency1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.lv = self.root.Node_1.lv_mlan_5.lv_export
    self.type = self.root.Node_1.type_mlan_5.type_export
    self.hp = self.root.Node_1.hp_mlan_5.hp_export
    self.player = self.root.Node_1.player_mlan_5.player_export
    self.union = self.root.Node_1.union_mlan_5.union_export
    self.consume = self.root.Node_1.consume_mlan_5.consume_export
    self.time = self.root.Node_1.time_mlan_5.time_export
    self.yield_info = self.root.Node_1.yield_info_mlan_8_export
    self.yield = self.root.Node_1.yield_export
    self.type_icon = self.root.Node_1.type_bj.type_icon_export

--EXPORT_NODE_END
end

function UIWildResPro:onExit()
    if self.m_scheduleId then
        gscheduler.unscheduleGlobal(self.m_scheduleId)
        self.m_scheduleId = nil
    end
end

function UIWildResPro:setData(data,designerData,isSelf)
    self.data = data

    self.designerData = designerData
    local surface = luaCfg:get_world_surface_by(designerData.file)
    self.lv:setString(designerData.level)
    -- self.type_icon:setSpriteFrame(surface.worldmap)
    global.panelMgr:setTextureFor(self.type_icon,surface.worldmap)
    self.type_icon:setScale(surface.iconSize)
    self.consume:setString(designerData.energy)

    if data.tagOwner then
        self.player:setString(data.tagOwner.szUserName)
        self.union:setString(global.unionData:getUnionShortName(data.tagOwner.szAllyName))
    else
        self.player:setString("-")
        self.union:setString("-")
    end
    self.type:setString(surface.name)    

    local drop = luaCfg:get_item_by(designerData.itemtype)
    self.yield_info:setString(luaCfg:get_local_string(10186,drop.itemName))

    global.tools:adjustNodePos(self.yield_info,self.yield)


    --耐久
    if not self.m_scheduleId then
        self.m_scheduleId = gscheduler.scheduleGlobal(handler(self,self.updateHp), 1)
    end
    self:updateHp()

    -- self.yield:setString(designerData.yield..luaCfg:get_local_string(10076))

    if isSelf then

        local tgReq = {
            lType = 8,
            lBind = self.data.lResID,
        }

        global.gmApi:effectBuffer(tgReq, function(data)
        
            data.tgEffect = data.tgEffect or {}

            local add = 0
            for _,v in ipairs(data.tgEffect) do
                add = add + math.floor(designerData.yield * data.tgEffect[1].lVal / 10000)
            end
            -- self.yield:setString(add..luaCfg:get_local_string(10076)) 
            if self.setYield then --protect 
                self:setYield(designerData.yield, add)
            end 
        end)
    else
        self:setYield(designerData.yield, 0)
    end

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.lv:getParent(),self.lv)
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    global.tools:adjustNodePosForFather(self.hp:getParent(),self.hp)
    global.tools:adjustNodePosForFather(self.player:getParent(),self.player)
    global.tools:adjustNodePosForFather(self.player:getParent(),self.player)
    global.tools:adjustNodePosForFather(self.union:getParent(),self.union)
    global.tools:adjustNodePosForFather(self.time:getParent(),self.time)
    global.tools:adjustNodePosForFather(self.consume:getParent(),self.consume)


end

function UIWildResPro:setYield(base,add)
    
    if add == 0 then
        add = ""
    else
        add = " +" .. add
    end 
    global.uiMgr:setRichText(self, "yield", 50045, {basics = base,addnum = add})
end

function UIWildResPro:updateHp()
    local currSvrTime = global.dataMgr:getServerTime()
    local maxHp = self.designerData.waste
    
    local hp = maxHp
    if self.data.lFlushTime ~= 0 then
        hp = maxHp-(currSvrTime-self.data.lFlushTime)/self.designerData.consume
    else 
        self.time:setString('-')
        self.hp:setString(string.format("%s/%s",hp,maxHp))
        return        
    end    
    
    local restTime = maxHp*self.designerData.consume - (currSvrTime-self.data.lFlushTime)
    hp = math.ceil(hp)
    self.hp:setString(string.format("%s/%s",hp,maxHp))
    self.time:setString(global.funcGame.formatTimeToHMS(restTime))

    if hp <= 0 then
        self.hp:setString(string.format("0/%s",maxHp))
        self.time:setString(global.funcGame.formatTimeToHMS(0))

        if self.m_overCall then self.m_overCall() end
        if self.m_scheduleId then
            gscheduler.unscheduleGlobal(self.m_scheduleId)
            self.m_scheduleId = nil
        end
    end
end

function UIWildResPro:setOverCall(call)
    self.m_overCall = call
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
--CALLBACKS_FUNCS_END

return UIWildResPro

--endregion
