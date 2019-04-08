local ResManager = {
    packageRoot = "game",   
}

local _playerRes = {}
local _playerResCache = {}
local _playerImageRes = {}
local _playerImageResCash = {}


local _armatureRes = {}
local _stageResList = {}

local _unloadList = {}

local _srokeSetMap = {}

local global = global
-- local guiReader = GuiReaderHelper:getInstance()
local armatureMgr = ccs.ArmatureDataManager:getInstance()
local textureCash = cc.Director:getInstance():getTextureCache()
local luaCfg = global.luaCfg


function ResManager:checkWidgetStroke(name, widget)

    local uiStrokeConfig = require("ui_stroke_cfg")

    if _srokeSetMap[name] == nil and uiStrokeConfig and uiStrokeConfig[name] then
        for path, strokeInfo in pairs(uiStrokeConfig[name]) do
            pathArr = string.split(path, "/")
            local targetWidget = widget
            for i = 1, #pathArr do
                local v = pathArr[i]
                targetWidget = ccui.Helper:seekWidgetByName(targetWidget, v)
                if targetWidget == nil then
                    -- log.debug("!ERROR! ResManager:createWidget(%s) seek path %s failed! at %s", name, path, v)
                    break
                else
                    -- log.trace("!SUCCESS! ResManager:createWidget(%s) seek path %s at %s", name, path, v)
                end
            end

            if targetWidget then
                targetWidget = tolua.cast(targetWidget, "Label")
                if targetWidget == nil then
                    -- log.debug("!ERROR! ResManager:createWidget(%s) seek path %s failed! target isNot Label", name, path)
                else
                    -- log.trace("!SUCCESS! ResManager:createWidget(%s) CheckWidgetStroke %s info %s", name, path, vardump(strokeInfo))
                    global.uiMgr:setLabelStroke(targetWidget, strokeInfo[1], strokeInfo[2])
                end
            end
        end
    else
        log.trace("!ERROR! ResManager:createWidget(%s) has no path uiStrokeConfig %s", name, vardump(uiStrokeConfig))
    end

    _srokeSetMap[name] = 1
end

local allWigdets = {}
function ResManager:createWidget(name)
    log.trace("###############ResManager:createWidget:name=%s",name)
    local widget = cc.CSLoader:createNode(name..".csb")
    if widget then 
        widget.m_fileName = name
        table.insert(allWigdets,widget)
    end 
--    self:checkWidgetStroke(name, widget)
    return widget
end

function ResManager:purgeAllWidgets()
    -- body

    for i,v in pairs(allWigdets) do

        if v and not tolua.isnull(v) then
            -- print(v:getParent())
            print("----->reference="..v:getReferenceCount())
            print("----->widgetname="..v.m_fileName)
        end
    end
    gscheduler.performWithDelayGlobal(function()
        -- body
        for i,v in pairs(allWigdets) do

            if v and not tolua.isnull(v) then
                -- print(v:getParent())
                print("then----->reference="..v:getReferenceCount())
                print("then----->widgetname="..v.m_fileName)
            end
        end
    end, 0)

end

function ResManager:createTimeline(name,frameListener,node)
    global.g_all_timeline = global.g_all_timeline or {}
    
    log.trace("###############ResManager:createTimeline:name=%s",name)

    local widget = cc.CSLoader:createTimeline(name..".csb")

    local function onFrameEvent(frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()

        if str == "over" then
        end
        
        local _, i_end = string.find(str, "playsound")
        
        if i_end then
            
            if not node or node:isVisible() then
                
                local eventName = string.sub(str, i_end+2)
                gevent:call(gsound.EV_ON_PLAYSOUND,eventName)
            end            
        end
        
        if frameListener then frameListener(frame,node , name ) end
    end
    widget:setFrameEventCallFunc(onFrameEvent)
    table.insert(global.g_all_timeline, widget )
    return widget
end

function ResManager:loadGuideRes()

    print("->start load guide res")
    
    local guide_res = global.luaCfg:guide_res()
    for _,v in pairs(guide_res) do

        if v.load == 1 then

            gdisplay.loadSpriteFrames(v.plist,v.png)
        end
    end
    
    print("->done load guide res")
end

function ResManager:getWidgetByName(node,nodeName)
    asset(node,"ResManager:getWidgetByName node == nil")
    if type(node) == "table" then
        if node[nodeName] then 
            return node[nodeName]
        else
            for k,v in pairs(node) do
                local ret = self:getWidgetByName(v)
                if ret ~= nil then
                    return ret
                end
            end
        end
    else
        return nil
    end
end

function ResManager:createCsbAction(name,actionStr,isloop,isRemoveSelf,frameListener,lastCallback)
    local uiMgr = global.uiMgr
    local csbName = name
    local node = self:createWidget(csbName)
    local nodeTimeLine = self:createTimeline(csbName,frameListener,node)
    
    uiMgr:configUITree(node)
    uiMgr:configUILanguage(node, csbName)
    
    node.timeLine = nodeTimeLine
    node.m_csbName = name
    node.m_actionStr = actionStr

    if lastCallback or isRemoveSelf then
        nodeTimeLine:setLastFrameCallFunc(function()
            
            if lastCallback then lastCallback() end
        
            if isRemoveSelf then

                node:removeFromParent()
            end        
        end)
    end

    if type(actionStr) == "string" then
        nodeTimeLine:play(actionStr,isloop)
    elseif type(actionStr) == "number" then
        if isloop then
            --针对世界野怪
            nodeTimeLine:gotoFrameAndPlay(actionStr,false)
            nodeTimeLine:setLastFrameCallFunc(function()
                nodeTimeLine:gotoFrameAndPlay(0,true)
            end)
        else
            nodeTimeLine:gotoFrameAndPlay(actionStr,true)
        end
    end
    node:runAction(nodeTimeLine)
    return node, nodeTimeLine
end


function ResManager:addCsbTimeLine(node,isloop,isRemoveSelf,frameListener,lastCallback)
    if tolua.isnull(node) then return end
    local uiMgr = global.uiMgr
    local csbName = node.m_csbName
    local actionStr = node.m_actionStr
    if not tolua.isnull(node.timeLine) then
        node:stopAction(node.timeLine)
    end
    local nodeTimeLine = self:createTimeline(csbName,frameListener,node)
    node.timeLine = nodeTimeLine

    if lastCallback or isRemoveSelf then
        nodeTimeLine:setLastFrameCallFunc(function()
            
            if lastCallback then lastCallback() end
        
            if isRemoveSelf then

                node:removeFromParent()
            end        
        end)
    end

    if type(actionStr) == "string" then
        nodeTimeLine:play(actionStr,isloop)
    elseif type(actionStr) == "number" then
        if isloop then
            --针对世界野怪
            nodeTimeLine:gotoFrameAndPlay(actionStr,false)
            nodeTimeLine:setLastFrameCallFunc(function()
                nodeTimeLine:gotoFrameAndPlay(0,true)
            end)
        else
            nodeTimeLine:gotoFrameAndPlay(actionStr,true)
        end
    end
    node:runAction(nodeTimeLine)
    return nodeTimeLine
end

function ResManager:unloadRes(sceneName)
    -- self:unloadArmature(sceneName)
    local textureCache = cc.Director:getInstance():getTextureCache()
    -- textureCache:removeUnusedTextures()

    local info = textureCache:getCachedTextureInfo()
    print(info)
    print(collectgarbage("count")) 
end

--
function ResManager:loadXmlBy(name)
    -- body
    local fileName = self:getAnimXMLName(name)    

    local fileUtils = cc.FileUtils:getInstance()
    if fileUtils:isFileExist(fileUtils:fullPathForFilename(fileName)) and armatureMgr:hadRelativeData(fileName) == false then
        armatureMgr:addArmatureFileInfo(fileName)
    end

    return fileName
end

function ResManager:loadXmlAyncBy(name, callBack)
    -- body
    local fileName = self:getAnimXMLName(name)

    local fileUtils = cc.FileUtils:getInstance()
    if fileUtils:isFileExist(fileUtils:fullPathForFilename(fileName)) and armatureMgr:hadRelativeData(fileName) == false then
        armatureMgr:addArmatureFileInfoAsync(fileName, callBack)
    else
        global.delayCallFunc(callBack, 0, 0.1)
    end 
    
    return fileName
end

function ResManager:unloadXmlBy(name)
    if _armatureRes[name] ~= nil or _playerRes[name] ~= nil then -- 全局动画不卸载
        return
    end
    local fileName = self:getAnimXMLName(name)

    local fileUtils = cc.FileUtils:getInstance()
    if fileUtils:isFileExist(fileUtils:fullPathForFilename(fileName)) and armatureMgr:hadRelativeData(fileName) == true then
        armatureMgr:removeArmatureFileInfo(fileName)
    end
end


function ResManager:preloadUITexturesByLoading()

    local data = luaCfg:common_res()
    local data2 = luaCfg:city_res()
    local data3 = luaCfg:texiao_res() or {}
    local preResList = {}
    local preResList2 = {}
    for i,v in pairs(data) do
        if v.load == 1 then
            table.insert(preResList,v)
        elseif v.load == 2 then
            table.insert(preResList2,v)
        elseif v.load == 3 then
            if global.isMemEnough then
                table.insert(preResList,v)
            end
        end
    end

    for i,v in pairs(data2) do
        if v.load == 1 then
            table.insert(preResList,v)
        end
    end
    for i,v in pairs(data3) do
        if v.load == 1 then
            table.insert(preResList,v)
        end
    end
    return preResList,preResList2
end

-- 刚进入游戏需要加载种族数据，以防创角界面有问题
function ResManager:preloadUITextures()
end

function ResManager:unloadTextures(moduleName)
    local datetime = require "datetime"
    local tstart = datetime.clock()

    local luaCfg = global.luaCfg
    local unloadData = self:getModuleData(moduleName)
    local loadData = self:getModuleData(loadModule)
    local isRoot = global.panelMgr:isRootPanel()
    if unloadData and #unloadData>0 then
        for i,v in pairs(unloadData) do
            if v.unload == 1 then
                gdisplay.removeSpriteFrames(v.plist,v.png)
            elseif v.unload == 2 and isRoot then
                gdisplay.removeSpriteFrames(v.plist,v.png)
            end
        end
    end
end

function ResManager:loadTextures(loadModule,doneCall,node)
    local datetime = require "datetime"
    local tstart = datetime.clock()

    local luaCfg = global.luaCfg
    local loadData = self:getModuleData(loadModule)
    if loadData and #loadData>0 then
        local total = 0
        local values = {}
        for i,v in pairs(loadData) do
            if v.load > 0 then
                total = total+1
                table.insert(values,v)
            end
        end
        dump(values)
        local loadCall = nil
        local finishIdx = 0
        loadCall = function(i_idx)
            -- body
            print("#########finishIdx="..finishIdx)
            print("#########i_idx="..i_idx)
            print("#########total="..total)

            if total <= 0 then 
                if doneCall then return doneCall() end 
                return
            end
            local v = values[i_idx]
            -- print("-------》load city-->v="..vardump(v))
            gdisplay.loadSpriteFrames(v.plist,v.png,function()
                -- body
                if loadCall then 
                    finishIdx = finishIdx + 1
                    if finishIdx >= total then
                        --资源加载完毕
                        if doneCall then doneCall() end
                        local tend = datetime.clock()
                        local perResTime = tend - tstart
                        print("<<<<<<ResManager:loadTextures(), time:%s", perResTime)
                        return 
                    end
                else
                    if doneCall then doneCall() end
                    print("#########没有loadcall")
                    return
                end
            end)
            if i_idx < total then
                loadCall(i_idx+1) 
            end
            -- node:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function()
            --     -- body
            --     if loadCall then 
            --         loadCall(i_idx+1) 
            --     else
            --         if doneCall then doneCall() end
            --         print("#########没有loadcall")
            --         return
            --     end
            -- end)))
        end
        loadCall(1)
    else
        if doneCall then doneCall() end 
        local tend = datetime.clock()
        local perResTime = tend - tstart
        print("<<<<<<ResManager:loadTextures(), time:%s", perResTime)
    end

end

function ResManager:getModuleData(moduleName)
    local luaCfg = global.luaCfg
    local data = {}
    if moduleName == "city" then
        data = luaCfg:city_res()
    elseif moduleName == "world" then
        data = luaCfg:world_res()
    elseif moduleName == "loading" then
        data = luaCfg:loading_res()
    elseif moduleName == "guide" then
        data = luaCfg:guide_res()
    elseif moduleName == "effect" then
        data = luaCfg:effect_res()
    elseif moduleName == "common" then
        data = luaCfg:common_res()
    end
    return data
end

function ResManager:unloadLoadingTextures()
    self:unloadTextures("loading")
    global.resMgr:unloadRes()
end

function ResManager:unloadMemWarningTextures()
    if global.scMgr:isMainScene() then
        global.resMgr:unloadTextures("world")
    elseif global.scMgr:isWorldScene() then
        global.resMgr:unloadTextures("city")
    end
    local isRoot = global.panelMgr:isRootPanel()
    if isRoot then
        global.resMgr:unloadTextures("effect")

        local _,load2List = global.resMgr:preloadUITexturesByLoading()
        local panelPlists = global.panelMgr:getloadBigMemoPlists()
        for k,v in pairs(panelPlists) do
            local data = {plist=k,png=k.gsub(k,".plist",".png")}
            table.insert(load2List,data)
        end
        if load2List and #load2List > 0 then
            for i,v in pairs(load2List) do
                gdisplay.removeSpriteFrames(v.plist, v.png)
            end
        end
    end
end

function ResManager:initCsbCache()
    local csb_path = "asset/ui/"

    local csbList = require("asset.config.csb_list")
    for i, csb in pairs(csbList) do 
        local f = csb_path..csb
        if cc.FileUtils:getInstance():isFileExist(f) then
            cc.CSLoader:cacheCsbData(f)
            cc.CSLoader:createNode(f)
        end
    end
end

global.resMgr = ResManager
