
-- 常用函数定义
-- base需要首先加载这个文件 

local pairs         = pairs
local assert        = assert
local string        = string
local type          = type

local gtostring     = tostring
tostring = function(arg)
    arg = arg or "nil"
    return gtostring(arg)
end

gformat = gformat or string.format

-- print 重定义

echo = print

-- printf
function printf(fmt, ...)
    echo(string.format(tostring(fmt), ...))
end

-------------------------------------------------------------------------------
-- tonum 
-- @function [parent=#global] ipairs
-- @param #table v
-- @param base
-- @return #number
function tonum(v, base)
    return tonumber(v, base) or 0
end

-------------------------------------------------------------------------------
-- toint 
-- @function [parent=#global] ipairs
-- @param #table v
-- @return #number
function toint(v)
    return math.round(tonum(v))
end

-------------------------------------------------------------------------------
-- tobool 
-- @function [parent=#global] ipairs
-- @param v
-- @return #number
function tobool(v)
    return (v ~= nil and v ~= false)
end

-------------------------------------------------------------------------------
-- totable 
-- @function [parent=#global] ipairs
-- @param v
-- @return #table
function totable(v)
    if type(v) ~= "table" then v = {} end
    return v
end

function isset(arr, key)
    local t = type(arr)
    return (t == "table" or t == "userdata") and arr[key] ~= nil
end

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function dump(object, label, isReturnContents, nesting)
    if type(nesting) ~= "number" then nesting = 99 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        elseif type(v) == "number" then
            return gformat("%0.18g", v)
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    echo("dump from: " .. string.trim(traceback[3]))

    local function _dump(object, label, indent, nest, keylen)
        label = label or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(label)))
        end
        if type(object) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(label), spc, _v(object))
        elseif lookupTable[object] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, label, spc)
        else
            lookupTable[object] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, label)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(label))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(object) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(object, label, "- ", 1)

    if isReturnContents then
        return table.concat(result, "\n")
    end

    for i, line in ipairs(result) do
        echo(line)
    end
end

function vardump(object, label)
    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        elseif type(v) == "number" then
            return gformat("%0.18g", v)
        end
        return tostring(v)
    end

    local function _vardump(object, label, indent, nest)
        label = label or "<var>"
        local postfix = ""
        if nest > 1 then postfix = "," end
        if type(object) ~= "table" then
            if type(label) == "string" then
                result[#result +1] = string.format("%s%s = %s%s", indent, label, _v(object), postfix)
            elseif type(label) == "number" then
                result[#result +1] = string.format("%s[%s] = %s%s", indent, label, _v(object), postfix)
            else
                result[#result +1] = string.format("%s%s%s", indent, _v(object), postfix)
            end
        elseif not lookupTable[object] then
            lookupTable[object] = true

            if type(label) == "string" then
                result[#result +1 ] = string.format("%s%s = {", indent, label)
            else
                result[#result +1 ] = string.format("%s[%s] = {", indent, label)
            end
            local indent2 = indent .. "    "
            local keys = {}
            local values = {}
            for k, v in pairs(object) do
                keys[#keys + 1] = k
                values[k] = v
            end
            table.sort(keys, function(a, b)
                if type(a) == "number" and type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b)
                end
            end)
            for i, k in ipairs(keys) do
                _vardump(values[k], k, indent2, nest + 1)
            end
            result[#result +1] = string.format("%s}%s", indent, postfix)
        end
    end
    _vardump(object, label, "", 1)

    return table.concat(result, "\n")
end

function vardebug(object)
    local str = vardump(object)
    log.debug("%s", str)
end

--[Common]
-- 只读table的实现，非终极版本
-- 如果对table进行rawset、table.insert、pairs, ipairs, next, # 等操作，仍然起效，所以不是完全意义上的readonly的。
-- 有兴趣的可以看下这里给的解释：
-- http://lua-users.org/wiki/ReadOnlyTables
function readonly(t)
	for x, y in pairs(t) do
		if type(x) == "table" then
			if type(y) == "table" then
				t[readOnly(x)] = readOnly[y]
			else
				t[readOnly(x)] = y
			end
		elseif type(y) == "table" then
			t[x] = readonly(y)
		end
	end
	
	local proxy = {}
	local mt = {
		-- hide the actual table being accessed
		--__metatable = false, 
        __source = t,
		__index = function(tab, k) return t[k] end,
		__newindex = function (t,k,v)
			error("attempt to modify a read-only table", 2)
		end
	}
	setmetatable(proxy, mt)
	return proxy
end

nodefault = nil
nodefault = function(obj)
    assert(type(obj) == "table")
    local mt = getmetatable(obj) or {}
    mt.__index = function(t, k)
        error(string.format("index non-exist key <%s>", tostring(k)), 2)
    end
    setmetatable(obj, mt)

    -- 嵌套设置
    for _, v in pairs(obj) do
        if type(v) == "table" then
            v = nodefault(v)    
        end
    end
    return obj
end

-- xpcall错误输出
function hqxpcall_error(err)
    __G__TRACKBACK__(err)
    return err
end

if CCHgame:IsRelease() == 1 then
    print = function ()
        -- body
    end
    dump = function( ... )
        -- body
    end

    local isOpen = cc.UserDefault:getInstance():getBoolForKey("releaseIsOpenLog",false)
    if isOpen then
        LogMore:setLogLevel(1)
        print = function(...)
            local arg = {...}
            local finalarg = {}
            for k,v in pairs(arg) do
                table.insert(finalarg,tostring(v))
            end
            LogMore:logError(table.concat(finalarg, "\t"))
        end
    end
end

