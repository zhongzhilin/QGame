
math = math or {}

function math.round(num)
    return math.floor(num + 0.5)
end

--向下取整，最小值为1
function math.floorMin(num,min)
    local i_min = min or 1
    if num < i_min then
        return i_min
    else
        return math.floor(num)
    end
end

function math.clamp(value, min, max)
    if value < min then value = min end
    if value > max then value = max end
    return value
end

--TODO  fix

-- 获取Int值中某个Byte的值，是有符号相关的
math.getbyte = function(source, index)
    return gs.AxGetIntByte(source, index - 1)
end

-- 设置Int值中某个Byte的值，是有符号相关的
math.setbyte = function(source, index, value)
    return gs.AxSetIntByte(source, index - 1, value)
end

-- 获取Int值中某个Bit的值，返回值是一个bool类型
math.getbit = function(source, index)
    return gs.AxGetIntBit(source, index)
end

-- 设置Int值中某个Bit的值，设置值是一个bool类型
math.setbit = function(source, index, value)
    return gs.AxSetIntBit(source, index, value)
end

local function IsZero(number)
    return not number or (number == 0)
end

-- 求最大公约数算法
-- 1 a%b得余数c
-- 2 若c=0，则b即为两数的最大公约数
-- 3 若c≠0，则a=b，b=c，再回去执行1
math.GetGreatestCommonDivisor = function(a, b)
    if IsZero(a) or IsZero(b) then
        return nil
    end
    local max = math.max(a, b)
    local min = math.min(a, b)
    local mod = max % min
    if mod ~= 0 then
        return math.GetGreatestCommonDivisor(min, mod)
    else
        return min
    end
end

-- 最小公倍数=两整数的乘积 / 最大公约数
math.GetLeastCommonMultipleGrid = function(a, b)
    if IsZero(a) or IsZero(b) then
        return nil
    end
    return (a * b) / math.GetGreatestCommonDivisor(a, b)
end

math.ReduceDecimalPrecision = function(number, precision)
    local format = "%." .. precision .. "f"
    return tonumber(string.format(format, number))
end

