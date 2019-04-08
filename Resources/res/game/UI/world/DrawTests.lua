--region DrawTests.lua
--Author : Administrator
--Date   : 2016/10/25
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local DrawTests  = class("DrawTests", function() return gdisplay.newWidget() end )

local points = {}

function DrawTests:ctor()
    self:CreateUI()
end

function DrawTests:CreateUI()
    local root = resMgr:createWidget("world/DrawTest")
    self:initUI(root)
end

function DrawTests:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/DrawTest")

    print("start")

    local draw = cc.DrawNode:create()
	draw:setAnchorPoint(cc.p(0,0))
	draw:setPosition(cc.p(0,0))
	self:addChild(draw)

    --当结束点是凹点时会错误
    --

    line = {
        {x = 120,y = 270},
                        {x = 120,y = 270},        
        {x = 110,y = 310},
        {x = 100,y = 300},
        {x = 100,y = 100},
        {x = 200,y = 230},

        {x = 300,y = 300},

        {x = 200,y = 350},
        {x = 200,y = 350},
                
    }
    draw:drawPolygon(line,#line,{r = 0,g = 1,b = 0, a = 0.2},3,{r = 0,g = 1,b = 0, a = 0.2})

    for i=0,10 do

    	for j = 0,20 do

    		  	local node = cc.Sprite:create()
				node:setSpriteFrame("ui_surface_icon/mini_g.png")
				-- node:setPosition(cc.p(math.random(gdisplay.width),math.random(gdisplay.height)))
				node:setPosition(cc.p(i * gdisplay.width / 10,j * gdisplay.height / 20))
				self:addChild(node)

				table.insert(points,node)
    	end  
    end

    local map = cc.TMXTiledMap:create("map/test.tmx")
	local data = map:getObjectGroup("player")
	local wayData = data:getObjects()

    local resData = {18,19,20,21,33,35,34}
    local lineWidth = 290
    -- local resData = {16,17,18}

	for i,v in ipairs(wayData) do

		local node = cc.Sprite:create()
		node:setSpriteFrame("ui_surface_icon/mini_g.png")
		node:setPosition(v)
        node:setTag(i)
		-- node:setPosition(cc.p(i * gdisplay.width / 10,j * gdisplay.height / 20))
		self:addChild(node)

        for _,rv in ipairs(resData) do

            if rv == i then

                node:setSpriteFrame("ui_surface_icon/mini_r.png")
            end
        end

		table.insert(points,node)
	end

	-- for j = 0,50 do

	-- 	  	local node = cc.Sprite:create()
	-- 		node:setSpriteFrame("ui_surface_icon/mini_g.png")
	-- 		node:setPosition(cc.p(math.random(gdisplay.width),math.random(gdisplay.height)))
	-- 		-- node:setPosition(cc.p(i * gdisplay.width / 10,j * gdisplay.height / 20))
	-- 		self:addChild(node)

	-- 		table.insert(points,node)
	-- end  



    local lineCache = {}

    local isPointEquie = function(p1,p2)    --判断俩个点是否相等
    	
    	return (p1.x == p2.x and p1.y == p2.y)
    end

    local getK = function(p1,p2)    --拿到俩点取K值
    	
    	if p1.x == p2.x then return 0 end

    	return math.abs(p1.y - p2.y) / math.abs(p1.x - p2.x)
    end

    local checkLine = function(startPos,endPos)    	    

    	for _,i in ipairs(lineCache) do

    		local preStart = i[1]
    		local preEnd = i[2]

    		if isPointEquie(startPos,preStart) or isPointEquie(startPos,preEnd) or isPointEquie(endPos,preStart) or isPointEquie(endPos,preEnd) then

    		else

    			if cc.pIsSegmentIntersect(preStart,preEnd,startPos,endPos) then

	    			return false
	    		end
    		end    	
    	end

    	return true
    end

    local lineCount = 0 

    local checkCupDatas = {}
    local checkCup = function(i,j)
    	
    	for _,v in ipairs(checkCupDatas) do

    		if (v.i == i and v.j == j) or (v.i == j and v.j == i) then

    			return false
    		end
    	end    

    	return true
    end

    function isHavaAngle(tb,angle)

		for _,av in ipairs(tb) do

			if angle < 0 then angle = angle + 360 end
			if av < 0 then av = av + 360 end

			if math.abs(angle - av) < 6 then

				return true
			end
		end	    	

		return false
    end

    for _,i in ipairs(points) do

    	local allAngle = {}

    	for _,j in ipairs(points) do

    		local startPos = cc.p(i:getPosition())
    		local endPos = cc.p(j:getPosition())

    		local dis = cc.pGetDistance(startPos,endPos)
    	
    		local angle = cc.pToAngleSelf(cc.pSub(startPos,endPos)) / 3.14 * 180



    		if dis < lineWidth and not isHavaAngle(allAngle,angle) and checkLine(startPos,endPos) and i~=j and checkCup(i,j) then


    			table.insert(allAngle,angle)
    			table.insert(lineCache,{[1] = startPos,[2] = endPos})
    			table.insert(checkCupDatas,{i = i,j = j})

    			lineCount = lineCount + 0.01

    			self:runAction(cc.Sequence:create(cc.DelayTime:create(lineCount),cc.CallFunc:create(function()
				
					draw:drawSegment(startPos,endPos, 3, {r = 0,g = 1,b = 0, a = 0.2}) 
					print(angle)

    				end)))
    		end
    	end
    end


    local isLineInLineCache = function(startPos,endPos)
        
        for _,i in ipairs(lineCache) do

            local preStart = i[1]
            local preEnd = i[2]

            if (isPointEquie(startPos,preStart) and isPointEquie(endPos,preEnd)) or (isPointEquie(startPos,preEnd) and isPointEquie(endPos,preStart)) then

                return true
            end
        end

        return false
    end

    local draw1 = cc.DrawNode:create()
    draw1:setAnchorPoint(cc.p(0,0))
    draw1:setPosition(cc.p(0,0))
    self:addChild(draw1)

    self.draw1 = draw1


    for _,j in ipairs(resData) do
        
        local point3 = cc.p(self:getChildByTag(j):getPosition())
        local line = {}
        
        for _,i in ipairs(lineCache) do
            
            if isPointEquie(point3,i[1]) then
            
                table.insert(line,i[2])
            end

            if isPointEquie(point3,i[2]) then
               
                table.insert(line,i[1])
            end
        end

        local sortFun = function(pos1,pos2)
            
            local ang1 = cc.pToAngleSelf(cc.pSub(point3,pos1))
            local ang2 = cc.pToAngleSelf(cc.pSub(point3,pos2))

            return ang1 < ang2
        end

        table.sort(line,sortFun)

        if #line ~= 1 then

            local centerPoss = {}

            local lineCount = #line

            for i = 1,lineCount do
                

                local nextIndex = i + 1

                local pos1 = line[i]
                
                if i == lineCount then

                    nextIndex = 1
                end

                local pos2 = line[nextIndex]
            
                local centerPos = cc.p((pos1.x + pos2.x + point3.x) / 3,(pos1.y + pos2.y + point3.y) / 3)
                
                table.insert(centerPoss,centerPos)
            end

            for i = 1,lineCount do

                line[i] = cc.p((line[i].x + point3.x) / 2,(line[i].y + point3.y) / 2)
            end
            
            for _,v in ipairs(centerPoss) do

                table.insert(line,v)
            end

            table.sort(line,sortFun)
        end

        lineCount = lineCount + 0.05

    self:runAction(cc.Sequence:create(cc.DelayTime:create(lineCount),cc.CallFunc:create(function()
    
        draw1:drawPolygon(line,#line,{r = 0,g = 1,b = 0, a = 0.2},3,{r = 0,g = 1,b = 0, a = 0.2})

    end))) 
        
    end

    print("end")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN

    uiMgr:addWidgetTouchHandler(self.root.Button_5, function(sender, eventType) self:changeView(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function DrawTests:changeView(sender, eventType)

    self.draw1:setVisible(not self.draw1:isVisible())
end
--CALLBACKS_FUNCS_END

return DrawTests

--endregion
