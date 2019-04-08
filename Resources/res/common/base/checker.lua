local type = type

-- 是否是正整数
function positive_int(obj)
    -- number
    if type(obj) ~= "number" then return false end

    -- integer
    if obj % 1 ~= 0 then return false end

    -- positive
    return obj > 0
end

-- 是否是非负整数
function nonnegative_int(obj)
    -- number
    if type(obj) ~= "number" then return false end

    -- integer
    if obj % 1 ~= 0 then return false end

    -- nonnegative
    return obj >= 0
end

function istable(obj)
    return type(obj) == "table"
end

function isstring(obj)
    return type(obj) == "string"
end
