
---@classdef gdisplay
gdisplay = {}

local sharedDirector         = cc.Director:getInstance()
local sharedTextureCache     = sharedDirector:getTextureCache()
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()

--fix
kResolutionFixedHeight = 3
kResolutionFixedWidth = 4


-- function gdisplay.initResolution(dw, dh)
--     -- check gdevice screen size
--     local glview = sharedDirector:getOpenGLView()
--     local size = glview:getFrameSize()

--     size = { width = size.width, height = size.height }
--     if size.width < size.height then
--         local temp = size.width
--         size.width = size.height
--         size.height = temp
--     end
    
--     gdisplay.sizeInPixels = {width = size.width, height = size.height}

--     local w = gdisplay.sizeInPixels.width
--     local h = gdisplay.sizeInPixels.height

--     CONFIG_SCREEN_WIDTH = dw
--     CONFIG_SCREEN_HEIGHT = dh
    
--     if CONFIG_SCREEN_WIDTH == nil or CONFIG_SCREEN_HEIGHT == nil then
--         CONFIG_SCREEN_WIDTH = w
--         CONFIG_SCREEN_HEIGHT = h
--     end

--     if not CONFIG_SCREEN_AUTOSCALE then
--         if w > h then
--             CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
--         else
--             CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
--         end
--     else
--         CONFIG_SCREEN_AUTOSCALE = string.upper(CONFIG_SCREEN_AUTOSCALE)
--     end

--     local scale, scaleX, scaleY

--     if CONFIG_SCREEN_AUTOSCALE then
--         if type(CONFIG_SCREEN_AUTOSCALE_CALLBACK) == "function" then
--             scaleX, scaleY = CONFIG_SCREEN_AUTOSCALE_CALLBACK(w, h, gdevice.model)
--         end

--         if not scaleX or not scaleY then
--             scaleX, scaleY = w / CONFIG_SCREEN_WIDTH, h / CONFIG_SCREEN_HEIGHT
--         end

--         if CONFIG_SCREEN_AUTOSCALE == "FIXED_WIDTH" then
--             scale = scaleX
--             CONFIG_SCREEN_HEIGHT = h / scale
--         elseif CONFIG_SCREEN_AUTOSCALE == "FIXED_HEIGHT" then
--             scale = scaleY
--             CONFIG_SCREEN_WIDTH = w / scale
--         else
--             scale = 1.0
--             log.error(string.format("gdisplay - invalid CONFIG_SCREEN_AUTOSCALE \"%s\"", CONFIG_SCREEN_AUTOSCALE))
--         end
--         local policy = cc.ResolutionPolicy.SHOW_ALL
--         local minRatio = 1024.00/768
--         local curRatio = size.width / size.height
--         if curRatio <= minRatio then
--             CONFIG_SCREEN_WIDTH = 960
--             CONFIG_SCREEN_HEIGHT = 640
--             -- policy = kResolutionFillAll
--             policy = cc.ResolutionPolicy.SHOW_ALL
--         end
--         glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, policy)
--     end

--     local winSize = sharedDirector:getWinSize()

--     gdisplay.contentScaleFactor = scale
--     gdisplay.size               = {width = winSize.width, height = winSize.height}
--     gdisplay.width              = gdisplay.size.width
--     gdisplay.height             = gdisplay.size.height
--     gdisplay.cx                 = gdisplay.width / 2
--     gdisplay.cy                 = gdisplay.height / 2
--     gdisplay.c_left             = -gdisplay.width / 2
--     gdisplay.c_right            = gdisplay.width / 2
--     gdisplay.c_top              = gdisplay.height / 2
--     gdisplay.c_bottom           = -gdisplay.height / 2
--     gdisplay.left               = 0
--     gdisplay.right              = gdisplay.width
--     gdisplay.top                = gdisplay.height
--     gdisplay.bottom             = 0
--     gdisplay.widthInPixels      = gdisplay.sizeInPixels.width
--     gdisplay.heightInPixels     = gdisplay.sizeInPixels.height  

--     gdisplay.center             = cc.p(gdisplay.cx, gdisplay.cy)
--     gdisplay.left_top           = cc.p(gdisplay.left, gdisplay.top)
--     gdisplay.left_bottom        = cc.p(gdisplay.left, gdisplay.bottom)
--     gdisplay.left_center        = cc.p(gdisplay.left, gdisplay.cy)
--     gdisplay.right_top          = cc.p(gdisplay.right, gdisplay.top)
--     gdisplay.right_bottom       = cc.p(gdisplay.right, gdisplay.bottom)
--     gdisplay.right_center       = cc.p(gdisplay.right, gdisplay.cy)
--     gdisplay.top_center         = cc.p(gdisplay.cx, gdisplay.top)
--     gdisplay.top_bottom         = cc.p(gdisplay.cx, gdisplay.bottom)
-- end


local glview = sharedDirector:getOpenGLView()
local framesize = glview:getFrameSize()
local function setDesignResolution(r, framesize)
    -- check gdevice screen size
    local size = glview:getFrameSize()
    
    if r.autoscale == "FILL_ALL" then
        glview:setDesignResolutionSize(framesize.width, framesize.height, cc.ResolutionPolicy.FILL_ALL)
    else
        local scaleX, scaleY = framesize.width / r.width, framesize.height / r.height
        local width, height = framesize.width, framesize.height
        if r.autoscale == "FIXED_WIDTH" then
            width = framesize.width / scaleX
            height = framesize.height / scaleX
            glview:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "FIXED_HEIGHT" then
            width = framesize.width / scaleY
            height = framesize.height / scaleY
            glview:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "EXACT_FIT" then
            glview:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.EXACT_FIT)
        elseif r.autoscale == "NO_BORDER" then
            glview:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "SHOW_ALL" then
            glview:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.SHOW_ALL)
        else
            printError(string.format("gdisplay - invalid r.autoscale \"%s\"", r.autoscale))
        end
    end

    local winSize = sharedDirector:getWinSize()

    gdisplay.contentScaleFactor = scale
    gdisplay.size               = {width = winSize.width, height = winSize.height}
    gdisplay.width              = gdisplay.size.width
    gdisplay.height             = gdisplay.size.height
    gdisplay.cx                 = gdisplay.width / 2
    gdisplay.cy                 = gdisplay.height / 2
    gdisplay.c_left             = -gdisplay.width / 2
    gdisplay.c_right            = gdisplay.width / 2
    gdisplay.c_top              = gdisplay.height / 2
    gdisplay.c_bottom           = -gdisplay.height / 2
    gdisplay.left               = 0
    gdisplay.right              = gdisplay.width
    gdisplay.top                = gdisplay.height
    gdisplay.bottom             = 0
    -- gdisplay.widthInPixels      = gdisplay.sizeInPixels.width
    -- gdisplay.heightInPixels     = gdisplay.sizeInPixels.height  
    
    gdisplay.center             = cc.p(gdisplay.cx, gdisplay.cy)
    gdisplay.left_top           = cc.p(gdisplay.left, gdisplay.top)
    gdisplay.left_bottom        = cc.p(gdisplay.left, gdisplay.bottom)
    gdisplay.left_center        = cc.p(gdisplay.left, gdisplay.cy)
    gdisplay.right_top          = cc.p(gdisplay.right, gdisplay.top)
    gdisplay.right_bottom       = cc.p(gdisplay.right, gdisplay.bottom)
    gdisplay.right_center       = cc.p(gdisplay.right, gdisplay.cy)
    gdisplay.top_center         = cc.p(gdisplay.cx, gdisplay.top)
    gdisplay.top_bottom         = cc.p(gdisplay.cx, gdisplay.bottom)
end

local function checkResolution(r)
    r.width = checknumber(r.width)
    r.height = checknumber(r.height)
    r.autoscale = string.upper(r.autoscale)
    assert(r.width > 0 and r.height > 0,
        string.format("gdisplay - invalid design resolution size %d, %d", r.width, r.height))
end

function gdisplay.initResolution(dw,dh)
    local configs = {
        width = dw,
        height = dh,
        autoscale = "FIXED_WIDTH",
        -- callback = function(framesize)
        --     local ratio = framesize.width / framesize.height
        --     if ratio <= 1.34 then
        --         -- iPad 768*1024(1536*2048) is 4:3 screen
        --         return { autoscale = "SHOW_ALL" }
        --     end
        -- end
    }
    if type(configs) ~= "table" then return end

    checkResolution(configs)
    if type(configs.callback) == "function" then
        local c = configs.callback(framesize)
        for k, v in pairs(c or {}) do
            configs[k] = v
        end
        checkResolution(configs)
    end

    setDesignResolution(configs, framesize)

    printInfo(string.format("# design resolution size       = {width = %0.2f, height = %0.2f}", configs.width, configs.height))
    printInfo(string.format("# design resolution autoscale  = %s", configs.autoscale))
    -- setConstants()
end


--gdisplay.initResolution()

gdisplay.COLOR_WHITE = cc.c3b(255, 255, 255)
gdisplay.COLOR_BLACK = cc.c3b(0, 0, 0)
gdisplay.COLOR_RED   = cc.c3b(255, 0, 0)
gdisplay.COLOR_GREEN = cc.c3b(0, 255, 0)
gdisplay.COLOR_BLUE  = cc.c3b(0, 0, 255)
gdisplay.COLOR_TEXT_YELLOW  = cc.c3b(255, 216, 0)
gdisplay.COLOR_TEXT_BROWN = cc.c3b(255, 226, 165)

gdisplay.AUTO_SIZE      = 0
gdisplay.FIXED_SIZE     = 1
gdisplay.LEFT_TO_RIGHT  = 0
gdisplay.RIGHT_TO_LEFT  = 1
gdisplay.TOP_TO_BOTTOM  = 2
gdisplay.BOTTOM_TO_TOP  = 3

gdisplay.CENTER        = 1
gdisplay.LEFT_TOP      = 2; gdisplay.TOP_LEFT      = 2
gdisplay.CENTER_TOP    = 3; gdisplay.TOP_CENTER    = 3
gdisplay.RIGHT_TOP     = 4; gdisplay.TOP_RIGHT     = 4
gdisplay.CENTER_LEFT   = 5; gdisplay.LEFT_CENTER   = 5
gdisplay.CENTER_RIGHT  = 6; gdisplay.RIGHT_CENTER  = 6
gdisplay.BOTTOM_LEFT   = 7; gdisplay.LEFT_BOTTOM   = 7
gdisplay.BOTTOM_RIGHT  = 8; gdisplay.RIGHT_BOTTOM  = 8
gdisplay.BOTTOM_CENTER = 9; gdisplay.CENTER_BOTTOM = 9

gdisplay.ANCHOR_POINTS = {
    { x = 0.5,  y = 0.5 },      -- CENTER
    { x = 0,    y = 1   },      -- TOP_LEFT
    { x = 0.5,  y = 1   },      -- TOP_CENTER
    { x = 1,    y = 1   },      -- TOP_RIGHT
    { x = 0,    y = 0.5 },      -- CENTER_LEFT
    { x = 1,    y = 0.5 },      -- CENTER_RIGHT
    { x = 0,    y = 0   },      -- BOTTOM_LEFT
    { x = 1,    y = 0   },      -- BOTTOM_RIGHT
    { x = 0.5,  y = 0   },      -- BOTTOM_CENTER
}

gdisplay.SCENE_TRANSITIONS = {
    CROSSFADE       = {cc.TransitionCrossFade, 2},
    FADE            = {cc.TransitionFade, 3, cc.c3b(0, 0, 0)},
    FADEWHITE       = {cc.TransitionFade, 3, cc.c3b(255, 255, 255)},
    FADEBL          = {cc.TransitionFadeBL, 2},
    FADEDOWN        = {cc.TransitionFadeDown, 2},
    FADETR          = {cc.TransitionFadeTR, 2},
    FADEUP          = {cc.TransitionFadeUp, 2},
    FLIPANGULAR     = {cc.TransitionFlipAngular, 3, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    FLIPX           = {cc.TransitionFlipX, 3, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    FLIPY           = {cc.TransitionFlipY, 3, cc.TRANSITION_ORIENTATION_UP_OVER},
    JUMPZOOM        = {cc.TransitionJumpZoom, 2},
    MOVEINB         = {cc.TransitionMoveInB, 2},
    MOVEINL         = {cc.TransitionMoveInL, 2},
    MOVEINR         = {cc.TransitionMoveInR, 2},
    MOVEINT         = {cc.TransitionMoveInT, 2},
    PAGETURN        = {cc.TransitionPageTurn, 3, false},
    ROTOZOOM        = {cc.TransitionRotoZoom, 2},
    SHRINKGROW      = {cc.TransitionShrinkGrow, 2},
    SLIDEINB        = {cc.TransitionSlideInB, 2},
    SLIDEINL        = {cc.TransitionSlideInL, 2},
    SLIDEINR        = {cc.TransitionSlideInR, 2},
    SLIDEINT        = {cc.TransitionSlideInT, 2},
    SPLITCOLS       = {cc.TransitionSplitCols, 2},
    SPLITROWS       = {cc.TransitionSplitRows, 2},
    TURNOFFTILES    = {cc.TransitionTurnOffTiles, 2},
    ZOOMFLIPANGULAR = {cc.TransitionZoomFlipAngular, 2},
    ZOOMFLIPX       = {cc.TransitionZoomFlipX, 3, cc.TRANSITION_ORIENTATION_LEFT_OVER},
    ZOOMFLIPY       = {cc.TransitionZoomFlipY, 3, cc.TRANSITION_ORIENTATION_UP_OVER},
}

gdisplay.TEXTURES_PIXEL_FORMAT = {}

function gdisplay.showInfo()
    log.debug(string.format("# CONFIG_SCREEN_AUTOSCALE       = %s", CONFIG_SCREEN_AUTOSCALE))
    log.debug(string.format("# CONFIG_SCREEN_WIDTH           = %0.2f", CONFIG_SCREEN_WIDTH))
    log.debug(string.format("# CONFIG_SCREEN_HEIGHT          = %0.2f", CONFIG_SCREEN_HEIGHT))
    log.debug(string.format("# gdisplay.widthInPixels        = %0.2f", gdisplay.widthInPixels))
    log.debug(string.format("# gdisplay.heightInPixels       = %0.2f", gdisplay.heightInPixels))
    log.debug(string.format("# gdisplay.contentScaleFactor   = %0.2f", gdisplay.contentScaleFactor))
    log.debug(string.format("# gdisplay.width                = %0.2f", gdisplay.width))
    log.debug(string.format("# gdisplay.height               = %0.2f", gdisplay.height))
    log.debug(string.format("# gdisplay.cx                   = %0.2f", gdisplay.cx))
    log.debug(string.format("# gdisplay.cy                   = %0.2f", gdisplay.cy))
    log.debug(string.format("# gdisplay.left                 = %0.2f", gdisplay.left))
    log.debug(string.format("# gdisplay.right                = %0.2f", gdisplay.right))
    log.debug(string.format("# gdisplay.top                  = %0.2f", gdisplay.top))
    log.debug(string.format("# gdisplay.bottom               = %0.2f", gdisplay.bottom))
    log.debug(string.format("# gdisplay.c_left               = %0.2f", gdisplay.c_left))
    log.debug(string.format("# gdisplay.c_right              = %0.2f", gdisplay.c_right))
    log.debug(string.format("# gdisplay.c_top                = %0.2f", gdisplay.c_top))
    log.debug(string.format("# gdisplay.c_bottom             = %0.2f", gdisplay.c_bottom))
    log.debug("#")
end

function gdisplay.newScene(name)
    local scene = CCSceneExtend.extend(cc.Scene:create())
    scene.name = name or "<unknown-scene>"
    return scene
end

function gdisplay.wrapSceneWithTransition(scene, transitionType, time, more)
    local key = string.upper(tostring(transitionType))
    if string.sub(key, 1, 12) == "CCTRANSITION" then
        key = string.sub(key, 13)
    end

    if key == "RANDOM" then
        local keys = table.keys(gdisplay.SCENE_TRANSITIONS)
        key = keys[math.random(1, #keys)]
    end

    if gdisplay.SCENE_TRANSITIONS[key] then
        local cls, count, default = unpack(gdisplay.SCENE_TRANSITIONS[key])
        time = time or 0.2

        if count == 3 then
            scene = cls:create(time, scene, more or default)
        else
            scene = cls:create(time, scene)
        end
    else
        log.error("gdisplay.wrapSceneWithTransition() - invalid transitionType %s", tostring(transitionType))
    end
    return scene
end

function gdisplay.replaceScene(newScene, transitionType, time, more)
    if sharedDirector:getRunningScene() then
        if transitionType then
            newScene = gdisplay.wrapSceneWithTransition(newScene, transitionType, time, more)
        end
        sharedDirector:replaceScene(newScene)
    else
        sharedDirector:runWithScene(newScene)
    end
end

function gdisplay.getRunningScene()
    return sharedDirector:getRunningScene()
end

function gdisplay.pause()
    sharedDirector:pause()
end

function gdisplay.resume()
    sharedDirector:resume()
end

function gdisplay.newLayer()
    return CCLayerExtend.extend(cc.Layer:create())
end

function gdisplay.newColorLayer(color)
    return CCLayerExtend.extend(cc.LayerColor:create(color))
end

function gdisplay.newNode()
    return CCNodeExtend.extend(cc.Node:create())
end

function gdisplay.newWidget()
    local w = WidgetExtend.extend(ccui.Widget:create())
    w:setNodeEventEnabled(true)
    return w
end

function gdisplay.newText(cloneText)
    local text = ccui.Text:create()
    if cloneText then
        local cloneLabel = cloneText:getVirtualRenderer()
        text:getVirtualRenderer():setTTFConfig(cloneLabel:getTTFConfig())
        text:setFontName(cloneText:getFontName())
        text:setFontSize(cloneText:getFontSize())

        text:setTextColor(cloneText:getTextColor())
        text:setTouchScaleChangeEnabled(cloneText:isTouchScaleChangeEnabled())
        text:setTextHorizontalAlignment(cloneLabel:getHorizontalAlignment())
        text:setTextVerticalAlignment(cloneLabel:getVerticalAlignment())
        text:setTextAreaSize(cloneLabel:getDimensions())
        text:setContentSize(cloneLabel:getContentSize())
    end
    return text
end

function gdisplay.newHQTableViewCell()
    return HQTableViewCellExtend.extend(HQTableViewCell:create())
end

function gdisplay.newSprite(filename, x, y)
    local t = type(filename)
    if t == "userdata" then t = tolua.type(filename) end
    local sprite

    if not filename then
        sprite = cc.Sprite:create()
    elseif t == "string" then
        if string.byte(filename) == 35 then -- first char is #
            local frame = gdisplay.newSpriteFrame(string.sub(filename, 2))
            if frame then
                sprite = cc.Sprite:createWithSpriteFrame(frame)
            end
        else
            if gdisplay.TEXTURES_PIXEL_FORMAT[filename] then
                CCTexture2D:setDefaultAlphaPixelFormat(gdisplay.TEXTURES_PIXEL_FORMAT[filename])
                sprite = cc.Sprite:create(filename)
                CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
            else
                sprite = cc.Sprite:create(filename)
            end
        end
    elseif t == "CCSpriteFrame" then
        sprite = cc.Sprite:createWithSpriteFrame(filename)
    else
        log.error("gdisplay.newSprite() - invalid filename value type")
        sprite = cc.Sprite:create()
    end

    if sprite then
        CCSpriteExtend.extend(sprite)
        if x and y then sprite:setPosition(x, y) end
    else
        log.error("gdisplay.newSprite() - create sprite failure, filename %s", tostring(filename))
        sprite = cc.Sprite:create()
    end

    return sprite
end

function gdisplay.newScale9Sprite(filename, x, y, size)
    local t = type(filename)
    if t ~= "string" then
        log.error("gdisplay.newScale9Sprite() - invalid filename type")
        return
    end

    local sprite
    if string.byte(filename) == 35 then -- first char is #
        local frame = gdisplay.newSpriteFrame(string.sub(filename, 2))
        if frame then
            sprite = CCScale9Sprite:createWithSpriteFrame(frame)
        end
    else
        if gdisplay.TEXTURES_PIXEL_FORMAT[filename] then
            CCTexture2D:setDefaultAlphaPixelFormat(gdisplay.TEXTURES_PIXEL_FORMAT[filename])
            sprite = CCScale9Sprite:create(filename)
            CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
        else
            sprite = CCScale9Sprite:create(filename)
        end
    end

    if sprite then
        CCSpriteExtend.extend(sprite)
        if x and y then sprite:setPosition(x, y) end
        if size then sprite:setContentSize(size) end
    else
        log.error("gdisplay.newScale9Sprite() - create sprite failure, filename %s", tostring(filename))
    end

    return sprite
end

function gdisplay.newTilesSprite(filename, rect)
    if not rect then
        rect = cc.rect(0, 0, gdisplay.width, gdisplay.height)
    end
    local sprite = cc.Sprite:create(filename, rect)
    if not sprite then
        log.error("gdisplay.newTilesSprite() - create sprite failure, filename %s", tostring(filename))
        return
    end

    local tp = ccTexParams()
    tp.minFilter = 9729
    tp.magFilter = 9729
    tp.wrapS = 10497
    tp.wrapT = 10497
    sprite:getTexture():setTexParameters(tp)
    CCSpriteExtend.extend(sprite)

    gdisplay.align(sprite, gdisplay.LEFT_BOTTOM, 0, 0)

    return sprite
end

--- create a tiled CCSpriteBatchNode, the image can not a POT file.
-- @author zrong(zengrong.net)
-- Creation: 2014-01-21
-- @param __fileName the first parameter for gdisplay.newSprite
-- @param __texture texture(plist) image filename, __fileName must be a part of the texture.
-- @param __size the tiled node size, use cc.size create it please.
-- @param __hPadding horizontal padding, it will gdisplay 1 px gap on moving the node, set padding for fix it.
-- @param __vPadding vertical padding.
-- @return a CCSpriteBatchNode
function gdisplay.newTiledBatchNode(__fileName, __texture, __size, __hPadding, __vPadding)
	__size = __size or cc.size(gdisplay.width, gdisplay.height)
	__hPadding = __hPadding or 0
	__vPadding = __vPadding or 0
	local __sprite = gdisplay.newSprite(__fileName)
	local __sliceSize = __sprite:getContentSize()
	__sliceSize.width = __sliceSize.width - __hPadding
	__sliceSize.height = __sliceSize.height - __vPadding
	local __xRepeat = math.ceil(__size.width/__sliceSize.width)
	local __yRepeat = math.ceil(__size.height/__sliceSize.height)
	-- how maney sprites we need to fill in tiled node?
	local __capacity = __xRepeat * __yRepeat
	local __batch = gdisplay.newBatchNode(__texture, __capacity)
	local __newSize = cc.size(0,0)
	--printf("newTileNode xRepeat:%u, yRepeat:%u", __xRepeat, __yRepeat)
	for y=0,__yRepeat-1 do
		for x=0,__xRepeat-1 do
			__newSize.width = __newSize.width + __sliceSize.width
			__sprite = gdisplay.newSprite(__fileName)
				:align(gdisplay.LEFT_BOTTOM,x*__sliceSize.width, y*__sliceSize.height)
				:addTo(__batch)
				--print("newTileNode:", x*__sliceSize.width, y*__sliceSize.height)
		end
		__newSize.height = __newSize.height + __sliceSize.height
	end
	__batch:setContentSize(__newSize)
	return __batch, __newSize.width, __newSize.height
end

--- Create a masked sprite
-- @author zrong(zengrong.net)
-- Creation: 2014-01-21
function gdisplay.newMaskedSprite(__mask, __pic)
	local __mb = ccBlendFunc:new()
	__mb.src = GL_ONE
	__mb.dst = GL_ZERO

	local __pb = ccBlendFunc:new()
	__pb.src = GL_DST_ALPHA
	__pb.dst = GL_ZERO

	local __maskSprite = gdisplay.newSprite(__mask):align(gdisplay.LEFT_BOTTOM, 0, 0)
	__maskSprite:setBlendFunc(__mb)

	local __picSprite = gdisplay.newSprite(__pic):align(gdisplay.LEFT_BOTTOM, 0, 0)
	__picSprite:setBlendFunc(__pb)

	local __maskSize = __maskSprite:getContentSize()
	local __canva = CCRenderTexture:create(__maskSize.width,__maskSize.height)
	__canva:begin()
	__maskSprite:visit()
	__picSprite:visit()
	__canva:endToLua()

	local __resultSprite = CCSpriteExtend.extend(
		cc.Sprite:createWithTexture(
			__canva:getSprite():getTexture()
		))
		:flipY(true)
	return __resultSprite
end

--- Create a circle or a sector or a pie by CCDrawNode
-- @author zrong(zengrong.net)
-- Creation: 2014-03-11
function gdisplay.newSolidCircle(radius, params)
	local circle = CCNodeExtend.extend(CCDrawNode:create())
	local fillColor = cc.c4f(1,1,1,1)
	local borderColor = cc.c4f(1,1,1,1)
	local segments = 32
	local startRadian = 0
	local endRadian = math.pi*2
	local borderWidth = 0
	local x,y = 0,0
	if params then
		x = params.x or x
		y = params.y or y
		if params.segments then segments = params.segments end
		if params.startDegree then
			startRadian = params.startDegree*math.pi/180
		end
		if params.degree then
			endRadian = startRadian+(params.degree)*math.pi/180
		end
		if params.fillColor then fillColor = params.fillColor end
		if params.borderColor then borderColor = params.borderColor end
		if params.borderWidth then borderWidth = params.borderWidth end
	end
	local radianPerSegm = 2 * math.pi/segments
	local points = CCPointArray:create(segments)
	for i=1,segments do
		local radii = startRadian+i*radianPerSegm
		if radii > endRadian then break end
		points:add(cc.p(radius * math.cos(radii), radius * math.sin(radii)))
	end
	circle:drawPolygon(points:fetchPoints(), points:count(), fillColor, borderWidth, borderColor)
	circle:pos(x,y)
	return circle
end

function gdisplay.newCircle(radius, params)
    local circle = CCNodeExtend.extend(CCCircleShape:create(radius))
	local x,y = 0,0
	local align=gdisplay.CENTER
	if params then
		x = params.x or x
		y = params.y or y
		align = params.align or align
		if params.fill then circle:setFill(params.fill) end
		if params.color then circle:setLineColor(params.color) end
		if params.strippleEnabled then circle:setLineStippleEnabled(params.strippleEnabled) end
		if params.lineStripple then circle:setLineStipple(params.lineStripple) end
		local lineWidth = params.lineWidth or params.borderWidth 
		if lineWidth then circle:setLineWidth(lineWidth) end
	end
	circle:setContentSize(cc.size(radius*2,radius*2))
	circle:align(align, x,y)
	return circle
end

function gdisplay.newRect(width, height, params)
    local x, y = 0, 0
    if type(width) == "userdata" then
        local t = tolua.type(width)
        if t == "CCRect" then
            x = width.origin.x
            y = width.origin.y
            height = width.size.height
            width = width.size.width
        elseif t == "CCSize" then
            height = width.height
            width = width.width
        else
            log.error("gdisplay.newRect() - invalid parameters")
            return
        end
    end

    local rect = CCNodeExtend.extend(CCRectShape:create(CCSize(width, height)))
	local align=gdisplay.CENTER
	if type(height) == "table" then params = hight end
	if type(params) == "table" then
		x = params.x or x
		y = params.y or y
		align = params.align or align
		if params.color then rect:setLineColor(params.color) end
		if params.strippleEnabled then rect:setLineStippleEnabled(params.strippleEnabled) end
		if params.lineStripple then rect:setLineStipple(params.lineStripple) end
		if params.fill then rect:setFill(params.fill) end
		local lineWidth = params.lineWidth or params.borderWidth 
		if lineWidth then rect:setLineWidth(lineWidth) end
	end
	rect:setContentSize(cc.size(width, height))
	rect:align(align, x,y)
    return rect
end

function gdisplay.newPolygon(points, scale)
    if type(scale) ~= "number" then scale = 1 end
    local arr = CCPointArray:create(#points)
    for i, p in ipairs(points) do
        p = CCPoint(p[1] * scale, p[2] * scale)
        arr:add(p)
    end

    return CCNodeExtend.extend(CCPolygonShape:create(arr))
end

function gdisplay.align(target, anchorPoint, x, y)
    target:setAnchorPoint(gdisplay.ANCHOR_POINTS[anchorPoint])
    if x and y then target:setPosition(x, y) end
end


local fileUtils = cc.FileUtils:getInstance()
function gdisplay.getImage(imageFilename)
    local fullpath = fileUtils:fullPathForFilename(imageFilename)
    return sharedTextureCache:getTextureForKey(fullpath)
end

function gdisplay.removeImage(imageFilename)
    if sharedTextureCache:getTextureForKey(imageFilename) then
        print("##########-removeSpriteFrames success="..imageFilename)
        sharedTextureCache:removeTextureForKey(imageFilename)
    end
end

function gdisplay.loadSpriteFrames(dataFilename, imageFilename, callback)
    local i_dataFilename = dataFilename
    imageFilename = imageFilename or string.gsub(dataFilename,".plist",".png")
    if gdisplay.TEXTURES_PIXEL_FORMAT[imageFilename] then
        cc.Texture2D:setDefaultAlphaPixelFormat(gdisplay.TEXTURES_PIXEL_FORMAT[imageFilename])
    end
    if not callback then
        print("##########-》dataFilename success="..dataFilename)
        spriteFrameCache:addSpriteFrames(dataFilename, imageFilename)
    else
        gdisplay.addImageAsync(imageFilename, function()
            -- body
            print("##########-》dataFilename ASYNC success="..imageFilename)
            if i_dataFilename and i_dataFilename ~= "" then
                spriteFrameCache:addSpriteFrames(i_dataFilename)
            end
            if callback then callback() end
        end)
        -- spriteFrameCache:addSpriteFramesAsync(dataFilename, imageFilename, callback)
    end
    if gdisplay.TEXTURES_PIXEL_FORMAT[imageFilename] then
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
    end
end

function gdisplay.removeSpriteFrames(dataFilename, imageFilename)
    if dataFilename then
        print("==================dataFilename=",dataFilename)
    else
        if imageFilename then
            print("==================imageFilename=",imageFilename)
        end
    end
    if dataFilename and dataFilename ~= "" then
        if spriteFrameCache:isSpriteFramesWithFileLoaded(dataFilename) then
            spriteFrameCache:removeSpriteFramesFromFile(dataFilename)
        end
    end
    if imageFilename and imageFilename ~= ""  then
        gdisplay.removeImage(imageFilename)
    end
end

function gdisplay.removeSpriteFrame(imageFilename)
    spriteFrameCache:removeSpriteFrameByName(imageFilename)
end

function gdisplay.addImageAsync(imagePath, callback)
    sharedTextureCache:addImageAsync(imagePath, callback)
end

function gdisplay.addSpriteFramesWithFile(plistFilename, image)
    if gdisplay.TEXTURES_PIXEL_FORMAT[image] then
        CCTexture2D:setDefaultAlphaPixelFormat(gdisplay.TEXTURES_PIXEL_FORMAT[image])
        sharedSpriteFrameCache:addSpriteFrames(plistFilename, image)
        CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
    else
        sharedSpriteFrameCache:addSpriteFrames(plistFilename, image)
    end
end

function gdisplay.removeSpriteFramesWithFile(plistFilename, imageName)
    sharedSpriteFrameCache:removeSpriteFramesFromFile(plistFilename)
    if imageName then
        gdisplay.removeSpriteFrameByImageName(imageName)
    end
end

function gdisplay.setTexturePixelFormat(filename, format)
    gdisplay.TEXTURES_PIXEL_FORMAT[filename] = format
end

function gdisplay.removeSpriteFrameByImageName(imageName)
    sharedSpriteFrameCache:removeSpriteFrameByName(imageName)
    CCTextureCache:sharedTextureCache():removeTextureForKey(imageName)
end

function gdisplay.newBatchNode(image, capacity)
    return CCNodeExtend.extend(CCSpriteBatchNode:create(image, capacity or 100))
end

function gdisplay.newSpriteFrame(frameName)
    local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
    if not frame then
        log.error("gdisplay.newSpriteFrame() - invalid frameName %s", tostring(frameName))
    end
    return frame
end

function gdisplay.newFrames(pattern, begin, length, isReversed)
    local frames = {}
    local step = 1
    local last = begin + length - 1
    if isReversed then
        last, begin = begin, last
        step = -1
    end

    for index = begin, last, step do
        local frameName = string.format(pattern, index)
        local frame = sharedSpriteFrameCache:spriteFrameByName(frameName)
        if not frame then
            log.error("gdisplay.newFrames() - invalid frame, name %s", tostring(frameName))
            return
        end

        frames[#frames + 1] = frame
    end
    return frames
end

function gdisplay.removeUnusedSpriteFrames()
    -- sharedSpriteFrameCache:removeUnusedSpriteFrames()
    sharedTextureCache:removeUnusedTextures()
end
function gdisplay.removeAllSpriteFrames()
    sharedSpriteFrameCache:removeSpriteFrames()
    sharedTextureCache:removeAllTextures()
end

gdisplay.PROGRESS_TIMER_BAR = kCCProgressTimerTypeBar
gdisplay.PROGRESS_TIMER_RADIAL = kCCProgressTimerTypeRadial

function gdisplay.newProgressTimer(image, progresssType)
    if type(image) == "string" then
        img =  cc.Sprite:create() 
        img:setSpriteFrame(image)
    end

    local progress = cc.ProgressTimer:create(img)
    progress:setType(progresssType)
    return progress
end

function gdisplay.setNodeCase(node)
    local function _setNodeCase(node)
        node:setCascadeOpacityEnabled(true)

        local children = node:getChildren()
        local childCount = node:getChildrenCount()
        if childCount < 1 then
            return
        end

        for i = 1, childCount do
            local childNode = nil
            if "table" == type(children) then
                childNode = children[i]
            elseif "userdata" == type(children) then
                childNode = children:objectAtIndex(i - 1)
            end

            if childNode then
                _setNodeCase(childNode)
            end
        end
    end

    _setNodeCase(node)
end

function gdisplay.fadeInWindow(node, fadeInTime) --Ð¯´ø×ÓÎïÌåµÄfadein·½·¨
    gdisplay.setNodeCase(node)
    transition.fadeIn(node, { time = fadeInTime })
end

function gdisplay.fadeOutWindow(node, fadeInTime)
    gdisplay.setNodeCase(node)
    transition.fadeOut(node, { time = fadeInTime })
end

