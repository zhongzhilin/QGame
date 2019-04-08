-- 
--author: cai 
--
local ColorUtils = {}
function ColorUtils.labelGray(_node, _isGray)
	local pProgram = nil
	if _node then
		
		if _isGray == true then
			pProgram = cc.GLProgramCache:getInstance():getGLProgram("Label_OutLine_Gray")
		else
			pProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderLabelNormal")
		end
		_node:setGLProgram(pProgram)
	end
end

function ColorUtils.labelGray2(_node, _isGray)
    local pProgram = nil
    if _node then
        if not _isGray then
            if _node.originColor then
                _node:setTextColor(_node.originColor)
            end
        else
            local originColor = _node:getTextColor()
            local GrayColor =  cc.c3b(219, 219, 219)  -- cc.c3b(120, 104, 114)
            _node:setTextColor(GrayColor)
            if originColor.r == GrayColor.r and (originColor.g == GrayColor.g) and (originColor.b == GrayColor.b) then
            else
                _node.originColor = originColor
            end
        end
    end
end

function ColorUtils.commonGray(_node, _isGray)
	-- body
	local pProgram = nil
	if _node then
		if _isGray == true then
			pProgram = cc.GLProgramCache:getInstance():getGLProgram("Common_Gray")
		else
			pProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
		end
		_node:setGLProgram(pProgram)
	end
end
--这个效果偏白，亮度偏高
function ColorUtils.commonGray2(_node, _isGray)
	local pProgram = nil
	if _isGray == true then
		pProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderUIGrayScale")
	else
		pProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
	end
	_node:setGLProgram(pProgram)
end

function ColorUtils.turnGray(_node, _isGray)
    local children = _node:getChildren()
    local count = _node:getChildrenCount()
    if count > 0 then 
        local child = nil 
        for i=1,count do
            child = nil
            if "table" == type(children) then
                child = tolua.cast(children[i], "cc.Node")
            elseif "userdata" == type(children) then 
                child = tolua.cast(children:objectAtIndex(i-1), "cc.Node")
            end
            if child ~= nil then
                ColorUtils.turnGray(child, _isGray)
            end
        end
    end
    
    if _node.getVirtualRenderer~=nil and tolua.type(_node:getVirtualRenderer()) == "ccui.Scale9Sprite" then
        if _isGray == true then
            _node:getVirtualRenderer():setState(1)
        else
            _node:getVirtualRenderer():setState(0)
        end
    elseif tolua.type(_node) == "ccui.Button" then
        _node:setTouchEnabled(not _isGray)
    elseif tolua.type(_node) == "ccui.Scale9Sprite" then
        if _isGray == true then
            _node:setState(1)
        else
            _node:setState(0)
        end
    elseif tolua.type(_node) == "ccui.Text" then
        -- _node:disableEffect()
        ColorUtils.labelGray2(_node:getVirtualRenderer(), _isGray)
    elseif tolua.type(_node) == "cc.Label" then
        -- _node:disableEffect()
        ColorUtils.labelGray2(_node, _isGray)
    else
        ColorUtils.commonGray2(_node, _isGray)
    end
end


function ColorUtils.turnSingleOutline(_node, _isOutline)
	if tolua.type(_node) == "cc.Sprite" then
		local pProgram = nil
		if _isOutline == true then
			pProgram = cc.GLProgramCache:getInstance():getGLProgram("Sprite_Outline")
		else
			pProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
		end
		_node:setGLProgram(pProgram)
	end
end
--仅对Sprite有效
function ColorUtils.turnOutline(_node, _isOutline)
	local children = _node:getChildren()
    local count = _node:getChildrenCount()
    if count > 0 then 
    	local child = nil 
    	for i=1,count do
    		child = nil
    		if "table" == type(children) then
    			child = children[i]--tolua.cast(children[i], "cc.Node")
    		elseif "userdata" == type(children) then 
    			child = children:objectAtIndex(i-1)--tolua.cast(children:objectAtIndex(i-1), "cc.Node")
    		end
    		if child ~= nil then
    			ColorUtils.turnOutline(child, _isOutline)
    		end
    	end
    end
    ColorUtils.turnSingleOutline(_node, _isOutline)
end


function ColorUtils.getColorGrade(_grade)
    local clr = cc.c3b(0,0,0)
    if _grade == 1 then
        clr = cc.c3b(175,165,162)
    elseif _grade == 2 then
        clr = cc.c3b(66,126,63)
    elseif _grade == 3 then
        clr = cc.c3b(49,123,168)
    elseif _grade == 4 then
        clr = cc.c3b(255,215,52)
    elseif _grade == 5 then
        clr = cc.c3b(196,0,196)
    elseif _grade == 6 then
        clr = cc.c3b(255,108,60)
    end
    return clr
end

global.colorUtils = ColorUtils