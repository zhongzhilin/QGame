--region UIBagUseBoard.lua
--Author : Administrator
--Date   : 2016/08/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local panelMgr = global.panelMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBagUseBoard  = class("UIBagUseBoard", function() return gdisplay.newWidget() end )

-- UIBagUseBoard._preItem = nil

local _instance = nil

function UIBagUseBoard:ctor()

	self:CreateUI()

	self:retain()
end

function UIBagUseBoard:getInstance()
    
    if _instance == nil then _instance = UIBagUseBoard.new() end

    return _instance

end

function UIBagUseBoard:CreateUI()
    
    local root = resMgr:createWidget("bag/bag_go")
    self:initUI(root)
end

function UIBagUseBoard:initUI(root)
    
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_go")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.use_board = self.root.use_board_export
    self.btn = self.root.use_board_export.btn_export
    self.btn_sell = self.root.use_board_export.btn_sell_export
    self.name = self.root.use_board_export.name_export
    self.desc = self.root.use_board_export.desc_export
    self.jiantou = self.root.use_board_export.jiantou_export
    self.btn_resolve = self.root.use_board_export.btn_resolve_export

    uiMgr:addWidgetTouchHandler(self.btn, function(sender, eventType) self:use_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_sell, function(sender, eventType) self:sell_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_resolve, function(sender, eventType) self:resolve_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UIBagUseBoard:bindToItem(item,sort)

	local data = item.data
    local itemData = luaCfg:get_item_by(data.id)

    self.count = data.count
    self.data = data

    self.name:setString(itemData.itemName)
    self.desc:setString(itemData.itemDes)
    self.btn:setVisible(itemData.useway ~= 0 )
    self.btn_sell:setVisible(itemData.useway == 0 and itemData.canSell ~= 0 and global.guideMgr:isMainScriptDone())
    self.btn_resolve:setVisible(false)

    self.useway = itemData.useway

    -- self.btn_sell:setVisible(global.userData:getGuideStep() == 999999)

	if self.preItem then

		self:removeFromParent()
    end

    self.root:setOpacity(0)
    self.root:stopAllActions()
    self.root:runAction(cc.Sequence:create(cc.FadeIn:create(0.4)))

	self.preItem = item

	local offsetX = (sort % 4) * 170 + 24

	self:setPositionX(offsetX * -1)
	self.jiantou:stopAllActions()
	self.jiantou:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.3,cc.p(offsetX,193)),1.5))

	item:addChild(self)

	return self
end

function UIBagUseBoard:hideSelf(item)

	if item ~= self.preItem then return end

	if self.preItem then

		self:removeFromParent()
	end

	self.preItem = nil
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBagUseBoard:use_call(sender, eventType)

print("############## UIBagUseBoard:use_call ")
dump(self.data)
    
    if global.EasyDev:CheckContrains( global.EasyDev.VIP_POINT_GOODS,self.data.id)then 
        if global.vipBuffEffectData:getVipLevel() >= global.vipBuffEffectData:getMaxVIPLevel() then 
             global.tipsMgr:showWarning("VIP_FULL")
            return 
        end 
    end 

    if self.useway == 1 then

        if self.count == 1 then
        
            panelMgr:openPanel("UIBagUseSingle"):setData(self.data)
        else
            local data = clone(self.data)
            data.itemId = data.id
            -- panelMgr:openPanel("UIBagUse"):setData()

            local itemData = luaCfg:get_item_by(self.data.id)

            local maxCount = 9999999
            local curCount = tonumber(self.data.count)
            if itemData.dropType == 1 then
                local dropData = luaCfg:get_drop_by(itemData.typePara1)
                
                for _,v in ipairs(dropData.dropItem) do

                    local dropItemId = v[1]
                    local dropItemNum = v[2]
                    local per, resData, maxNum, currNum = global.resData:getPropPer(dropItemId)
                    
                    if per then

                        maxCount = math.ceil((maxNum - currNum)/dropItemNum)
                        if maxCount <= 0 then
                            global.tipsMgr:showWarning(luaCfg:get_local_string(10092))
                            return
                        end
                    end                    
                end                
            else
                if itemData.itemType == 106 then
                    --经验道具上限判断
                    local dropItemNum = itemData.typePara1
                    local currTotalExp,TotalExp = global.userData:getFullExp()
                    maxCount = math.ceil((TotalExp - currTotalExp)/dropItemNum)
                    if maxCount <= 0 then
                        global.tipsMgr:showWarning(luaCfg:get_local_string(10123))
                        return
                    end
                else
                    maxCount = 9999999999
                end
            end

            if curCount < maxCount then
                maxCount = curCount
            end
            local itemUsePanel = panelMgr:openPanel("UIItemUsePanel")
            local isBag = false
            if itemData.itemType == 101 then
                isBag = true
            end 
            local data = {itemId = self.data.id, maxCount = maxCount, isBag=isBag}
            panelMgr:openPanel("UIItemUsePanel"):setData(data,handler(self,self.use_call_back))
        end
    end

    if self.useway == 2 then
       panelMgr:openPanel("UIBagUseSingle"):setData(self.data)
    end

    if self.useway == 5 then
        panelMgr:openPanel("UIChangeNamePanel")
    end
end

function UIBagUseBoard:sell_call(sender, eventType)

    panelMgr:openPanel("UIBagSell"):setData(self.data)
end

function UIBagUseBoard:resolve_call(sender, eventType)

end
--CALLBACKS_FUNCS_END


function UIBagUseBoard:used_tips(msg) -- 特殊道具使用后的tips 提示 
    local tips =  nil 
    if msg.lID == 10601 then -- 領主經驗
        global.tipsMgr:showWarning("lord_exp_gain",msg.tgItem[1].lCount)
        return false 
    end 
    return true 
end 

function UIBagUseBoard:use_call_back(num, callback, userNumber)
    local itemData = luaCfg:get_item_by(self.data.id)
    local window = itemData.window

    global.itemApi:itemUse(self.data.id, num, 0, 0, function(msg)
        if callback then callback() end
        --　领主经验道具使用
        gevent:call(global.gameEvent.EV_ON_UI_USER_UPDATE)
        
        local data = {} --msg.tgItem--global.normalItemData:useItem(self.data.id, num)        
        for _,v in ipairs(msg.tgItem or {}) do

            table.insert(data,{[1] = v.lID,[2] = v.lCount})            
        end

        if self:used_tips(msg) == false then 
            return 
        end 

        if window == 0 then
            
            return

        elseif  window == 1 then
            --todo

            local tipStr = ""
            local itemData = luaCfg:get_item_by(self.data.id)
            if itemData.itemType == 101 and data[1] then
                data[1][2] = userNumber
            end 
            if data then tipStr = global.taskData.getGiftInfoBySort(data) end
            global.tipsMgr:showTaskTips(tipStr)
        elseif  window == 2 then

            panelMgr:openPanel("UIItemRewardPanel"):setData(data)
        elseif window == 3 then

            local id = itemData.typePara1

            local soldierData = luaCfg:get_soldier_property_by(id)
            global.tipsMgr:showTaskTips(luaCfg:get_local_string(10206,soldierData.name,num))

            return
        elseif window == 4 then
            
            global.tipsMgr:showTaskTips(itemData.useDes)
        end
    end)
end

return UIBagUseBoard

--endregion
