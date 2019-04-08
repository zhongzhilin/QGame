--region UIMonsterListNode.lua
--Author : yyt
--Date   : 2016/12/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UIMonsterItem = require("game.UI.mail.UIMonsterItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIMonsterItem = require("game.UI.mail.UIMonsterItem")
--REQUIRE_CLASS_END

local UIMonsterListNode  = class("UIMonsterListNode", function() return gdisplay.newWidget() end )

function UIMonsterListNode:ctor()
    
end

function UIMonsterListNode:CreateUI()
    local root = resMgr:createWidget("mail/mall_wild_bj")
    self:initUI(root)
end

function UIMonsterListNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mall_wild_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.itemSize = self.root.itemSize_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.FileNode_1 = UIMonsterItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.FileNode_1)

--EXPORT_NODE_END
	

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMonsterListNode:onEnter()
    
    self:registerTouchListener()
    self.ScrollView_1:addEventListener(handler(self, self.moveScro))
end

function UIMonsterListNode:moveScro(sender, eventType)

    if self.isMove then
        --log.debug("---- move")
        self.ScrollView_1:setSwallowTouches(false)
        self.ScrollView_1:setTouchEnabled(false)
    else
        --log.debug("----not move")
        self.ScrollView_1:setSwallowTouches(true)
        self.ScrollView_1:setTouchEnabled(true)
    end
     
end


function UIMonsterListNode:registerTouchListener()
    
    local touchNode = cc.Node:create()
    self:addChild(touchNode)
    local contentMoveX, contentMoveY = 0, 0
    local beganPos, curPos = 0, 0

    local  listener = cc.EventListenerTouchOneByOne:create()

    local function touchBegan(touch, event)
       contentMoveX = 0
       contentMoveY = 0

       beganPos = touch:getLocation()
       return true
    end
    local function touchMoved(touch, event)
       
       local diff = touch:getDelta()
       contentMoveX = contentMoveX + math.abs(diff.x)
       contentMoveY = contentMoveY + math.abs(diff.y)

        curPos = touch:getLocation()

        local angle = self:getAngleByPos(beganPos, curPos)
        if (angle>-40 and angle < 40) or (angle>140 and angle <= 180) or (angle < -140 and angle > -180) then
            self.isMove = false
        else
            self.isMove = true
        end

    end
    local function touchEnded(touch, event)
        self.ScrollView_1:setTouchEnabled(true)
        self.ScrollView_1:setSwallowTouches(false)
    end

    listener:setSwallowTouches(false)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, touchNode)

end


function UIMonsterListNode:getAngleByPos(p1,p2)  
    local p = {}  
    p.x = p2.x - p1.x  
    p.y = p2.y - p1.y  
             
    local r = math.atan2(p.y,p.x)*180/math.pi  
    -- print("夹角[-180 - 180]:",r)  
    return r  
end  


function UIMonsterListNode:setData(data)
	
	self.data = data
	self:initScroll(data)
end

function UIMonsterListNode:initScroll(data)
	
    self.ScrollView_1:removeAllChildren()

    local xW = self.itemSize:getContentSize().width
    self.ScrollView_1:setInnerContainerSize(cc.size((#data)*xW, self.ScrollView_1:getContentSize().heigh))

    local posX = 15-- self:getFirstItemPosX(data, xW)
    local i = 0
    for _,v in pairs(data) do
        
        local item = UIMonsterItem.new()
        item:setPosition(cc.p(posX+xW*i , 0))
        item:setData(v)
        self.ScrollView_1:addChild(item)
        i = i + 1
    end

    self.ScrollView_1:scrollToLeft(0, false)

end

function UIMonsterListNode:getFirstItemPosX(data, xW)

	local posX = 0

	local itemNum = #data
	local itemW = itemNum*xW
	local scroW = self.ScrollView_1:getContentSize().width
	if itemW < scroW then

		posX = (scroW - itemW)/2
	end
	return posX
end

--CALLBACKS_FUNCS_END

return UIMonsterListNode

--endregion
