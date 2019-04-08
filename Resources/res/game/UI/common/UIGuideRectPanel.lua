--region UIGuideRectPanel.lua
--Author : untory
--Date   : 2017/03/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGuideRectPanel  = class("UIGuideRectPanel", function() return gdisplay.newWidget() end )

function UIGuideRectPanel:ctor()
    self:CreateUI()
end

function UIGuideRectPanel:CreateUI()
    local root = resMgr:createWidget("common/common_guide_panel")
    self:initUI(root)
end

function UIGuideRectPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_guide_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.model = self.root.model_export
    self.point_node = self.root.point_node_export
    self.rect = self.root.point_node_export.rect_export
    self.rect_light = self.root.point_node_export.rect_export.rect_light_export
    self.hand = self.root.hand_export
    self.circle_node = self.root.circle_node_export
    self.rect = self.root.circle_node_export.rect_export
    self.rect_light = self.root.circle_node_export.rect_export.rect_light_export    
--EXPORT_NODE_END

    -- self:initTouch()
    self.model:setVisible(false)
end

function UIGuideRectPanel:showHand(pointPos,size)

    self.hand:stopAllActions()

    if pointPos.x > gdisplay.width / 2 then
        self.hand:setScaleX(-1)
    else
        self.hand:setScaleX(1)
    end

    if pointPos.y > gdisplay.height / 2 then
        self.hand:setScaleY(-1)        
        self.hand:runAction(cc.RepeatForever:create(cc.EaseInOut:create(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-20)),cc.MoveBy:create(0.5,cc.p(0,20))),1)))
    else

        self.hand:setScaleY(1)
        self.hand:runAction(cc.RepeatForever:create(cc.EaseInOut:create(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,20)),cc.MoveBy:create(0.5,cc.p(0,-20))),1)))
    end

    if self.data.scaleX then
        self.hand:setScaleX(self.data.scaleX)
    end

    if self.data.scaleY then
        self.hand:setScaleY(self.data.scaleY)
    end

    self.point_node:setPosition(pointPos)
    self.circle_node:setPosition(pointPos)
    self.hand:runAction(cc.Sequence:create(cc.EaseInOut:create(cc.MoveTo:create(0.3,pointPos),2),cc.CallFunc:create(function()
        
        self.isReady = true
    end)))
    
    size.width = size.width + 27
    size.height = size.height + 27
    
    self.point_node.rect_export:setContentSize(size)    
    self.point_node.rect_export.rect_light_export:stopAllActions()
    self.point_node.rect_export.rect_light_export:setContentSize(size)    
    self.point_node.rect_export.rect_light_export:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))

    self.circle_node.rect_export:setScale(self.data.len / 133)       
    self.circle_node.rect_export.rect_light_export:stopAllActions()     
    -- self.circle_node.rect_export.rect_light_export:setScale(self.data.len / 133)       
    self.circle_node.rect_export.rect_light_export:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
end

function UIGuideRectPanel:onEnter()
    
end

function UIGuideRectPanel:handleUI(widget)   
    
    self.widget = widget

    local scrollView = self:seekWidgetScrollView(widget,screenPos)
    if scrollView then

        local screenPos = widget:convertToWorldSpace(cc.p(0,0))      
        local offsetY = 0 

        if screenPos.y < 0 then

            offsetY = -screenPos.y-- - gdisplay.height            
        end

        if screenPos.y > gdisplay.height then

            offsetY = screenPos.y - gdisplay.height
        end

        local innerSize = scrollView:getInnerContainerSize()
        local scrollSize = scrollView:getContentSize()
        local innerPos = scrollView:getInnerContainerPosition()

        innerPos.y = innerPos.y + offsetY            
        scrollView:setInnerContainerPosition(cc.p(innerPos))            

        self:setVisible(false)
        global.delayCallFunc(function()
                
            local screenPos = widget:convertToWorldSpace(cc.p(0,0))            
            local anchorPos = widget:getAnchorPoint()
            local size = widget:getContentSize()
            local dtPos = cc.p(0.5 * size.width,0.5 * size.height)
            local pointPos = cc.pAdd(screenPos,dtPos)

            self:setVisible(true)    
            self:showHand(pointPos,size)                
        end,0,1 / 60)
    else

        local screenPos = widget:convertToWorldSpace(cc.p(0,0))            
        local anchorPos = widget:getAnchorPoint()
        local size = widget:getContentSize()        
        local scale = widget:getScale()

        size.width = size.width * scale
        size.height = size.height * scale

        local dtPos = cc.p(0.5 * size.width,0.5 * size.height)
        local pointPos = cc.pAdd(screenPos,dtPos)

        self:showHand(pointPos,size)
    end
end

function UIGuideRectPanel:seekWidgetScrollView(widget)
    
    local parent = widget:getParent()
    
    if parent == nil then        
        return nil 
    else 

        local parentType = tolua.type(parent)
        -- print(parentType,parent:getName())
        if parentType == "ccui.ScrollView" then

            -- local innerSize = parent:getInnerContainerSize()
            -- local scrollSize = parent:getContentSize()
            -- local innerPos = parent:getInnerContainerPosition()

            -- dump(innerPos,"innerPos")
            -- print(widget:getPositionY(),"widget:getPositionY()")

            -- innerPos.y = innerPos.y + 60            
            -- parent:setInnerContainerPosition(cc.p(innerPos))            
            return parent
        else

            return self:seekWidgetScrollView(parent)
        end
    end

end

function UIGuideRectPanel:handleUI_tableview(tableview,dataCatch)
    
    self:setVisible(false)

    local tableData = tableview.__tableData
    local catchfunc = function(data)
        
        for k,v in pairs(dataCatch) do

            if data[k] ~= v then

                return false
            end            
        end        

        return true
    end
    for index,v in ipairs(tableData) do

        -- dump(v,"table view data")

        if catchfunc(v) then

            local index = index - 1
            tableview:jumpToCellByIdx(index)            
            global.delayCallFunc(function()
    
                self:setVisible(true)

                local widget = nil
                for k, v in ipairs(tableview.__cellList) do                    
                    if v:getIdx() == index then                                        
                        widget = v
                    end
                end  

                local screenPos = widget:convertToWorldSpace(cc.p(0,0)) 
                local anchorPos = widget:getAnchorPoint()
                local size = clone(tableview.__cellSize)
                local dtPos = cc.p(0.5 * size.width,0.5 * size.height)
                local pointPos = cc.pAdd(screenPos,dtPos)

                self:showHand(pointPos,size)

                self.widget = widget
                -- self.point_node:setPosition(pointPos)
                -- self.hand:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.3,pointPos),2))
                -- self.rect:setContentSize(size)
                -- self.rect_light:setContentSize(size)
            end,nil,0.5)            

            return true
        end
    end

    return false
end

function UIGuideRectPanel:setData(data)
    
    self.data = data

    local panelName = data.panelName
    local widgetName = data.widgetName
    local tableViewName = data.tableViewName

    self.data.len = self.data.len or 100
    
    self.circle_node:setVisible(self.data.isCircle)
    self.point_node:setVisible(not self.data.isCircle)

    if data.widgetNameFunc then
        widgetName = data.widgetNameFunc()
    end

    local isShowLight = true
    if data.isShowLight ~= nil then
        isShowLight = data.isShowLight
    end

    local isShowHand = true
    if data.isShowHand ~= nil then
        isShowHand = data.isShowHand
    end

    self.isReady = false
    
    self.point_node.rect_export.rect_light_export:setVisible(isShowLight)
    self.point_node.rect_export:setVisible(isShowLight)

    self.circle_node.rect_export.rect_light_export:setVisible(isShowLight)
    self.circle_node.rect_export:setVisible(isShowLight)

    self.hand:setVisible(isShowHand)

    local panel = global.panelMgr:getPanel(panelName)
    local ok = true

    self.panel = panel

    if panel then

        if tableViewName then
            --mean this is a table view cell

            local tableview = ccui.Helper:seekNodeByName(panel,tableViewName)
            if tableview then

                if not self:handleUI_tableview(tableview,data.dataCatch) then
                   
                    ok = false
                    print("data catch fail")
                end
            else

                ok = false
                print("can not find the table view :" .. widgetName)
            end        
        elseif widgetName then

            local widget = ccui.Helper:seekNodeByName(panel,widgetName)
            if widget then

                self:handleUI(widget)
            else

                ok = false 
                print("can not find the widget :" .. widgetName) 
            end       
        else

            ok = false            
        end            
    else

        ok = false
        print("can not find the panel :" .. panelName)
    end

    if not ok then

        global.panelMgr:closePanel("UIGuideRectPanel")
    end    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIGuideRectPanel

--endregion
