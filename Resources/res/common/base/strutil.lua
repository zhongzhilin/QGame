local strutil = {}
local string = require "string"

-- utf8名字长度，数字字母一个，其他两个长度
function strutil.get_len(strutilstr)
    assert(type(strutilstr) == "string")
    
    local strutillen = 0
    local strList = string.utf8ToList(strutilstr)
    for _, v in pairs(strList) do
        if string.match(v, "[%a%d]") then
            strutillen = strutillen + 1
        else
            strutillen = strutillen + 2
        end
    end   
    
    return strutillen
end

-- 名字包含空白字符或标点符号等非法字符
function strutil.has_inv_mark(strutilstr)
    assert(type(strutilstr) == "string")
    return not not string.match(strutilstr, "[%s%p]")
end

return strutil