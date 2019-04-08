local global = global
local define = global.define
local luaCfg = global.luaCfg

local gameFunc = global.funcGame
local cast = tolua.cast

local _Manager = {}

-- widget
----------------------------------------------------------------
function _Manager:getWidget(root, name, typeName, warning)
    if root == nil  then
        if warning == true then
            log.debug("[Error][UI] Can't get %s(%s) with root(nil).", name, typeName or "unknow")
        end
        return
    end

    local widget = root:getChildByName(name)
    if widget == nil then
        widget = ccui.Helper:seekWidgetByName(root, name)
    end

    if widget and typeName then
        widget = cast(widget, typeName)
    end

    if widget == nil and warning == true then
        log.debug("[Error][UI] Can't get %s(%s).", name, typeName)
    end
    return widget
end

function _Manager:isWidget(node)
    if node.addNode then
        return true
    else
        return false
    end
end

local noNetModal = true
function _Manager:addWidgetTouchHandler(widget, handler, eventFlow, noNetCheck)
    
    local panelMgr = global.panelMgr

    if widget and not tolua.isnull(widget) then
        widget.bindPanelName = panelMgr.nowCreatingName
    end

    local onTouchHandler = function(sender, eventType)

        if eventType == ccui.TouchEventType.ended then

            if self.preButton == sender then

                gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
                if handler and noNetModal and not global.disableButton then
                    
                    handler(sender)
                end
            
                self.preButton = nil
            end
        elseif eventType == ccui.TouchEventType.began then
            noNetModal = (not global.isConnecting or noNetCheck)

            if global.disableButton then
                sender:stopActionByTag(1021)
            end

            if tolua.isnull(self.preButton) or self.preButton.bindPanelName ~= panelMgr:getTopPanelName() then

                self.preButton = nil                
            end

            if self.preButton == nil then self.preButton = sender end              
        elseif eventType == ccui.TouchEventType.canceled then

            if self.preButton == sender then
               self.preButton = nil
            end
        end
    end

    if widget and handler then
        widget:setTouchEnabled(true)

        if eventFlow == true then
            widget:addTouchEventListener(handler)
        else
            widget:addTouchEventListener(onTouchHandler)
        end
    end
end

function _Manager:getWidgetRenderer(widget, typeArr)
    if widget == nil then
        return nil
    end
    typeArr = typeArr or {
        ImageView = "CCSprite",
        Label = "CCLabelTTF",
        LabelBMFont = "CCLabelBMFont",
    }

    local renderer = nil
    local description = widget:getDescription()
    if typeArr[description] then
        widget = tolua.cast(widget, description)
        renderer = tolua.cast(widget:getVirtualRenderer(), typeArr[description])
    end
    return renderer
end

function _Manager:setWidgetOpacity(widget, value, originFlag)
    
    local _setOpacity = function(node)
        if node == nil then
            return
        end
        node:setOpacity(value)

        if originFlag == true then
            node.originOpacity = value
        end
    end

    local checkWidget = nil
    checkWidget = function(widget)
        if widget == nil or widget.addNode == nil then
            return
        end
        
        -- self
        local renderer = self:getWidgetRenderer(widget)
        if renderer then
            _setOpacity(renderer)
        end

        -- children
        local children = widget:getChildren()
        local childCount = children:count()
        for i = 0, (childCount - 1) do
            local child = tolua.cast(children:objectAtIndex(i), "Widget")
            checkWidget(child)
        end
    end

    checkWidget(widget)
end


function _Manager:runWidgetFadeIn(widget, time, useOpacityNow, callBack, typeArr)
    
    local runFadeInAction = function(node)
        if node == nil then
            return
        end
        local onCallBack = function()
            if node.fadeInAction then
                node:stopAction(node.fadeInAction)
                node.fadeInAction = nil
            end

            if callBack then
                callBack()
                callBack = nil
            end
        end

        if node.fadeInAction == nil then
            if not useOpacityNow then
                node:setOpacity(0)
            end

            local array = CCArray:create()
            array:addObject(CCFadeTo:create(time, node.originOpacity or 255))
            array:addObject(CCCallFunc:create(onCallBack))
            local action = CCSequence:create(array)
            node:runAction(action)
            node.fadeInAction = action
        end
    end

    local checkWidget = nil
    checkWidget = function(widget)
        if widget == nil or widget.addNode == nil then
            return
        end

        -- self
        local renderer = self:getWidgetRenderer(widget, typeArr)
        if renderer then
            if renderer.originOpacity == nil then
                renderer.originOpacity = renderer:getOpacity()
            end
            runFadeInAction(renderer)
        end

        -- children
        local children = widget:getChildren()
        local childCount = children:count()
        for i = 0, (childCount - 1) do
            local child = tolua.cast(children:objectAtIndex(i), "Widget")
            checkWidget(child)
        end
    end

    checkWidget(widget)
end

function _Manager:stopWidgetFadeIn(widget, typeArr)
    local checkWidget = nil
    checkWidget = function(widget)
        if widget == nil or widget.addNode == nil then
            return
        end

        -- self
        local renderer = self:getWidgetRenderer(widget, typeArr)
        if renderer then
            if renderer.fadeInAction then
                renderer:stopAction(renderer.fadeInAction)
                renderer.fadeInAction = nil
            end
        end

        -- children
        local children = widget:getChildren()
        local childCount = children:count()
        for i = 0, (childCount - 1) do
            local child = tolua.cast(children:objectAtIndex(i), "Widget")
            checkWidget(child)
        end
    end

    checkWidget(widget)
end

function _Manager:runWidgetFadeOut(widget, time, useOpacityNow, callBack, typeArr)

    local runFadeOutAction = function(node)
        if node == nil then
            return
        end
        local onCallBack = function()
            if node.fadeOutAction then
                node:stopAction(node.fadeOutAction)
                node.fadeOutAction = nil
            end

            if callBack then
                callBack()
                callBack = nil
            end
        end

        if node.fadeOutAction == nil then
            if not useOpacityNow then
                node:setOpacity(node.originOpacity or 255)
            end

            local array = CCArray:create()

            array:addObject(CCFadeTo:create(time, 0))
            array:addObject(CCCallFunc:create(onCallBack))
            local action = CCSequence:create(array)
            node:runAction(action)
            node.fadeOutAction = action
        end
    end

    local checkWidget = nil
    checkWidget = function(widget)
        if widget == nil or widget.addNode == nil then
            return
        end

        -- self
        local renderer = self:getWidgetRenderer(widget, typeArr)
        if renderer then
            if renderer.originOpacity == nil then
                renderer.originOpacity = renderer:getOpacity()
            end
            runFadeOutAction(renderer)
        end

        -- children
        local children = widget:getChildren()
        local childCount = children:count()
        for i = 0, (childCount - 1) do
            local child = tolua.cast(children:objectAtIndex(i), "Widget")
            checkWidget(child)
        end
    end

    checkWidget(widget)
end

function _Manager:stopWidgetFadeOut(widget, typeArr)
    local checkWidget = nil
    checkWidget = function(widget)
        if widget == nil or widget.addNode == nil then
            return
        end

        -- self
        local renderer = self:getWidgetRenderer(widget, typeArr)
        if renderer then
            if renderer.fadeOutAction then
                renderer:stopAction(renderer.fadeOutAction)
                renderer.fadeOutAction = nil
            end
        end

        -- children
        local children = widget:getChildren()
        local childCount = children:count()
        for i = 0, (childCount - 1) do
            local child = tolua.cast(children:objectAtIndex(i), "Widget")
            checkWidget(child)
        end
    end

    checkWidget(widget)
end


-- label
---------------------------------------------
function _Manager:createLabel(size)
    local label = cc.Label:createWithSystemFont("1",define.SYSTEM_FONT, size or 26)
    --label:setFontSize(26)
    --label:setFontName(define.SYSTEM_FONT)    
    return label
end

function _Manager:getLabel(root, name, warning)
    return self:getWidget(root, name, "Label", warning)
end

function _Manager:configLabel(root, name, stroke, size)
    local label = self:getLabel(root, name, true)
    if label and stroke then
        self:setLabelStroke(label, stroke, size)
    end
    return label
end

function _Manager:setLabelText(label, value, ...)
    local text = luaCfg:get_local_string(value, ...)
    if label and text then
        if label.setText then
            label:setText(text)
        elseif label.setString then
            label:setString(text)
        end
    end
end

function _Manager:setRichText(root,labelkey,richKey,data)

    local richText = nil
    local node = root[labelkey]

    if tolua.type(node) == "ccui.Text" then    --第一次设置

        richText = ccui.RichText:create()        
        richText:setAnchorPoint(node:getAnchorPoint())
        richText:setPosition(node:getPosition())
        
        if node:getContentSize().width == 0 then

            richText:ignoreContentAdaptWithSize(true)
        else

            richText:setContentSize(node:getContentSize())
            richText:ignoreContentAdaptWithSize(false)
        end        

        richText.defaultSize = node:getFontSize()
        richText.defaultColor = node:getTextColor()
        node:getParent():addChild(richText, node:getLocalZOrder(), node:getTag())

        root[labelkey] = richText

        node:removeFromParent()
    else

        richText = node        
    end 

    richText:clearElement()

    local richInfo = nil
    if type(richKey) == "number" then
        local richData = global.luaCfg:get_richText_by(richKey) 
        if richData then
            richInfo = richData.text
        end
    else
        richInfo = richKey
    end    

    if richInfo then

        local richTextData = self:decodeRichData(richInfo) --TODO 做一下缓存，不需要每次都加载
        for tag,v in ipairs(richTextData) do

            v.type = v.type or "text"

            local element = nil

            if v.type == "text" then

                v.color = self:decodeRGB(v.color or richText.defaultColor)
                v.size = tonumber(v.size) or richText.defaultSize
                v.outline = tonumber(v.outline) or false
                v.outlineColor = self:decodeRGB(v.outlineColor or cc.c3b(0,0,0))
                if v.key then v.label = v.label or data[v.key] end
                if v.label then

                    if v.outline then

                        element = ccui.RichElementText:create(tag, v.color, 255, v.label,"fonts/normal.ttf", v.size,v.outlineColor,v.outline)
                    else 

                        element = ccui.RichElementText:create(tag, v.color, 255, v.label,"fonts/normal.ttf", v.size)
                    end                    
                else

                    log.error("rich text's label can not be nil")
                end       
            elseif v.type == "newLine" then

                element = ccui.RichElementNewLine:create(0,cc.c3b(0,0,0),255)
            end
            if element then
                richText:pushBackElement(element)
            end        
                
        end
        richText:formatText()
    end   
end

function _Manager:decodeRGB(hex)

    if type(hex) ~= "string" then return hex end
    
    local red = string.sub(hex, 1, 2)
    local green = string.sub(hex, 3, 4)
    local blue = string.sub(hex, 5, 6)

    red = tonumber(red, 16)
    green = tonumber(green, 16)
    blue = tonumber(blue, 16)

    return cc.c3b(red, green, blue)
end

function _Manager:decodeRichData(str)
    
    str = string.gsub(str,'_en','')

    str = string.gsub(str,'\n\n','#type:<newLine>#label:< >#type:<newLine>')
    str = string.gsub(str,'\n','#type:<newLine>')

    local list = string.split(str,"#")
    local res = {}

    for _,v in ipairs(list) do

        if #v ~= 0 then
            
            local data = {}
            v = v .. ","
            local valueList = string.split(v,">,")       

            for _,v in ipairs(valueList) do

                local endList = string.split(v,":<")
                data[endList[1]] = endList[2]
            end
            table.insert(res,data)
        end        
    end

    -- dump(res,"look res")
    -- print(str)

    return res
end

function _Manager:setLabelStroke(label, stroke, size)
    if label then
        local labelTTF = tolua.cast(label:getVirtualRenderer(), "CCLabelTTF")
        self:setLabelTTFStroke(labelTTF, stroke, size)
    end    
end

function _Manager:configTitleLabel(root, text)
    local label = self:configLabel(root, "Label_Title", define.STROKE_COLOR_TITLE)
    if label and text then
        self:setLabelText(label, text)
    end

    return label
end

function _Manager:createLabelTTF(fontName)
    local label = CCLabelTTF:create()
    label:setFontSize(26)
    if fontName == nil then
        label:setFontName(define.SYSTEM_FONT)
    end
    return label
end

function _Manager:setLabelTTFStroke(labelTTF, stroke, size)
    if labelTTF then
        if stroke then
            labelTTF:enableStroke(stroke, size or 4)
        else
            labelTTF:disableStroke()
        end
    end
end


-- image
-----------------------------------------------
function _Manager:configImage(root, name, handler, eventFlow)
    local image = self:getImage(root, name)
    self:addWidgetTouchHandler(image, handler, eventFlow)
    return image
end

function _Manager:getImageRenderer( image )
	if image == nil then
		return nil
	else
		if image.mRenderer == nil then
            if image:isScale9Enabled() then
                image.mRenderer = tolua.cast(image:getVirtualRenderer(), "CCScale9Sprite")
                image.mRenderer = image.mRenderer:getBatchNode()
            else
                image.mRenderer = tolua.cast(image:getVirtualRenderer(), "CCSprite")
			end
		end
		return image.mRenderer
	end
end

function _Manager:initScrollText(text)
    
    local scrollText = require("game.UI.common.UIScrollText")
    local scrollInstance = scrollText.new()
    scrollInstance:setData(text)
end

function _Manager:setImageShader( image, key )
	if image ~= nil then
		local renderer = self:getImageRenderer(image)
		if renderer ~= nil then
            local shader = CCShaderCache:sharedShaderCache():programForKey(key)
            renderer:setShaderProgram(shader)
		end
	end
end

function _Manager:getImage(root, name, warning)
    return self:getWidget(root, name, "ImageView", warning)
end

function _Manager:createImage(data)
    local image = ImageView:create()
    self:setImage(image, data)

    return image
end

function _Manager:setImage(image, data)
    if image == nil or data == nil then
        return
    end

    local fileName = data.fileName or data[1] or ""
    if fileName and fileName ~= "" then
        if image.mFileName ~= fileName then
            image.mFileName = fileName

            local textureType = data.textureType or data[2] or UI_TEX_TYPE_LOCAL
            image:loadTexture(fileName, textureType)

            local scale = data[3]
            if scale then
                if type(scale) == "number" then
                    image:setScale(scale)
                elseif type(scale) == "table" then
                    image:setScaleX(scale[1] or 1)
                    image:setScaleY(scale[2] or 1)
                end
            end

            local positionOffSet = data[4]
            if positionOffSet then
                local position = cc.p(positionOffSet[1] or 0, positionOffSet[2] or 0)
                image:setPosition(position)
            end

            local opacity = data[5]
            if opacity then
                image:setOpacity(opacity)
            end
        end
        image:setVisible(true)
    else
        image:setVisible(false)
    end
end

-- button
-----------------------------------------------
function _Manager:configButton(root, name, handler, eventFlow)
    local button = self:getButton(root, name)
    self:addWidgetTouchHandler(button, handler, eventFlow)
    
    local label = self:getLabel(button, "Label_Name")
        or self:getLabel(button, "Label_ButtonName")
        or self:getLabel(button, "Label_btn")

    button.mNameLabel = label

    local bubbleImage = self:getImage(button, "Image_Bubble")
    if bubbleImage then
        bubbleImage.mNumLabel = self:getLabel(bubbleImage, "Label_Num")
    end
    button.mBubbleImage = bubbleImage

    return button
end

function _Manager:getButton(root, name, warning)
    return self:getWidget(root, name, "Button", warning)
end

function _Manager:configLabelButton(root, name, handler, eventFlow)
    local button = self:getButton(root, name)
    self:addWidgetTouchHandler(button, handler, eventFlow)

    local bubbleImage = self:getImage(button, "Image_Bubble")
    if bubbleImage then
        bubbleImage.mNumLabel = self:getLabel(bubbleImage, "Label_Num")
    end
    button.mBubbleImage = bubbleImage
    
    button.mNameLabel = self:configLabel(button, "Label_Name")
    return button
end



function _Manager:getLayout(root, name, warning)
    return self:getWidget(root, name, "Layout", warning)
end

function _Manager:configLayout(root, name, handler, eventFlow)
    local layout = self:getLayout(root, name, true)
    self:addWidgetTouchHandler(layout, handler, eventFlow)

    return layout
end

-- cost layout
--------------------------------------
function _Manager:configCostLayout(root, name, stroke, size)
    local layout = self:configLayout(root, name)
    layout.mIconImage = self:configImage(layout, "Image_Icon")
    layout.mNumLabel = self:configLabel(layout, "Label_Num", define.STROKE_COLOR_WORD1)
    layout.mCostLabel = self:configLabel(layout, "Label_Cost", define.STROKE_COLOR_WORD1)
    layout.mBackImage = self:configImage(layout, "Image_Back")
    
    return layout
end


-- bone
------------------------------------------------
function _Manager:changeBoneDisplay(bone, node, index)
    if bone == nil or node == nil then
        return
    end
    
    if index == nil then
        index = 1
    end

    self:removeBoneDisplay(bone, index)
    self:addBoneDisplay(bone, node, index)
end

function _Manager:addBoneDisplay(bone, node, index)
    if bone == nil or node == nil then
        return
    end

    if index == nil then
        index = 1
    end

    if bone.displayList == nil then
        bone.displayList = {}
    end

    bone.displayList[index] = true
    bone:addDisplay(node, index)
    
    local originBone = bone:getDisplayRenderNode();
    if originBone then
        node:setContentSize(cc.size(0, 0))
        node:setAnchorPoint(originBone:getAnchorPoint())
        node:setPosition(cc.p(originBone:getPosition()))
    end
    
    bone:changeDisplayWithIndex(index, true);
end

function _Manager:addButtomModal(panel)
    
    local touchNode = cc.Node:create()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function() log.debug("yes") return true end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)

    touchNode:setLocalZOrder(-1)

    panel:addChild(touchNode)
end

function _Manager:addTopModal(panel,time, isCall)

    panel = panel or global.panelMgr:getTopPanel()

    local touchNode = cc.Node:create()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function() log.debug("yes") return true end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
    touchNode:setTag(12048)
    panel:addChild(touchNode)
    
    panel._panelModal = touchNode

    if time and (not isCall) then
        touchNode:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.RemoveSelf:create()))
    end

    return touchNode
end

function _Manager:removePanelModel(panel)

    panel = panel or global.panelMgr:getTopPanel()
    local touchNode = panel:getChildByTag(12048)
    if touchNode then
        touchNode:removeFromParent()
    end
end

function _Manager:addSceneModel(time,modalTag,isSendGood)

    local curScene = global.scMgr:CurScene()

    local touchNode = cc.Node:create()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function() print("yes",modalTag) return true end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)
    touchNode:setLocalZOrder(31)
    if modalTag then
        touchNode:setTag(modalTag)
    end    
    curScene:addChild(touchNode)

    if isSendGood then
        local blackBg = cc.LayerColor:create()
        touchNode:addChild(blackBg, 1)
        blackBg:setContentSize(cc.size(gdisplay.size.width, gdisplay.size.height))
        blackBg:setColor(cc.c3b(0, 0, 0))
        blackBg:setOpacity(255*0.55)

        local labelCsb = global.resMgr:createWidget("common/wait_gift_node")
    
        self:configUITree(labelCsb)
        self:configUILanguage(labelCsb, "common/wait_gift_node")

        touchNode:addChild(labelCsb, 2)
        labelCsb:setPosition(cc.p(gdisplay.cx,gdisplay.cy))
    end


    if time then
        touchNode:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.RemoveSelf:create()))
    end

    return touchNode,listener
end

function _Manager:removeSceneModal(modalTag)
    
    if global.scMgr then
        local curScene = global.scMgr:CurScene()
        if curScene and not tolua.isnull(curScene) then
            curScene:removeChildByTag(modalTag)
        end
    end
end

function _Manager:removeBoneDisplay(bone, index)
    if bone == nil then
        return
    end

    if index == nil then
        index = 1
    end

    if bone.displayList == nil then
        bone.displayList = {}
    end

    if bone.displayList[index] == true then
        bone.displayList[index] = false
        bone:removeDisplay(index)
    end

    bone:changeDisplayWithIndex(-1, true)
end

local ishide = cc.UserDefault:getInstance():getBoolForKey("kgame_isHidelantext",false)
function _Manager:configUILanguage(uiRoot, fileName)
    if global.languageData:getCurrentLanguage() == "cn" then
        return
    end

    local uiLanCfg = global.luaCfg:get_ui_language_cfg_by_module(fileName)
    for key, id in pairs(uiLanCfg or {}) do
        local nameList = string.split(key, ".")
        local node = uiRoot
        for i, nodeName in ipairs(nameList) do
            node = node[nodeName]
            if node == nil then
                break
            end
        end

        if id and node then
            local lan_data = global.luaCfg:get_ui_language_string_by(id)
            local currLan = "_"..global.languageData:getCurrentLanguage()
            if currLan == "_cn" then 
                currLan = ""
            end
            local content = lan_data and lan_data["value"..currLan] or string.format("errstr<%d>", id)
            if ishide then
                content = ""
            end
            if node.setString then
                node:setString(content)
            elseif node.setTitleText then
                node:setTitleText(content)   
            end
        end
    end
end

function _Manager:configUITree(uiRoot)

    if tolua.isnull(uiRoot) then 
        --protect 
        return 
    end 

    local function paserNode(node, children)
        for i, childNode in ipairs(children) do 
            local name = childNode:getName()
            node[name] = childNode
            self:adjustText(childNode)

            local tempChildren = childNode:getChildren()
            if #tempChildren > 0 then
                paserNode(childNode, tempChildren)
            end
        end
    end

    paserNode(uiRoot, uiRoot:getChildren())
end

function _Manager:adjustText(node)
    if tolua.type(node) == 'ccui.Text' then
        local virtualRenderer = node:getVirtualRenderer() 
        if node:getFontName() ~= '' and node:getContentSize().height < (virtualRenderer:getLineHeight() * 2) then
            virtualRenderer:setLineBreakWithoutSpace(true)            
        end        
    end
end

function _Manager:configNestClass(comp, node)
    local parent = node:getParent()
    local posx, posy = node:getPosition()
    local zorder = node:getLocalZOrder()
    node:retain()
    node:removeFromParent(false)
    comp:setPosition(posx, posy)
    node:setPosition(0, 0)

    assert(parent, "no parent")
    parent:addChild(comp, zorder)
    comp:initUI(node)
    node:release()
end

global.uiMgr = _Manager
