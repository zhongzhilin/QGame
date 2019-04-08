string = string or {}

function string.fformat(str, ...)
    local r,r1,r2=pcall(string.format,str,...)
    if r then
        return string.format(str,...)
    else
        return str
    end
end

function string.startswith(obj, prefix)
    return string.sub(obj, 1, #prefix) == prefix
end

function string.endswith(obj, surfix)
    return string.sub(obj, #obj - #surfix +1, #surfix) == surfix
end

function string.htmlspecialchars(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, k, v)
    end
    return input
end
string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.htmlspecialcharsDecode(input)
    for k, v in pairs(string._htmlspecialchars_set) do
        input = string.gsub(input, v, k)
    end
    return input
end

function string.nl2br(input)
    return string.gsub(input, "\n", "<br />")
end

function string.text2html(input)
    input = string.gsub(input, "\t", "    ")
    input = string.htmlspecialchars(input)
    input = string.gsub(input, " ", "&nbsp;")
    input = string.nl2br(input)
    return input
end

function string.split(str, delimiter)
    str = tostring(str)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

function string.ltrim(str)
    return string.gsub(str, "^[ \t\n\r]+", "")
end

function string.rtrim(str)
    return string.gsub(str, "[ \t\n\r]+$", "")
end

function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end

function string.ucfirst(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

local function urlencodeChar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

function string.urlencode(str)
    -- convert line endings
    str = string.gsub(tostring(str), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    str = string.gsub(str, "([^%w%.%- ])", urlencodeChar)
    -- convert spaces to "+" symbols
    return string.gsub(str, " ", "+")
end

function string.urldecode(str)
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)", function(h) return string.char(tonum(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function string.utf8len(str)
    local len  = #str
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(str, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

function string.utf8charbytes (s, i)
    -- argument defaults
    i = i or 1

    -- argument checking
    if type(s) ~= "string" then
        error("bad argument #1 to 'utf8charbytes' (string expected, got ".. type(s).. ")")
    end
    if type(i) ~= "number" then
        error("bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")")
    end

    local c = s:byte(i)

    -- determine bytes needed for character, based on RFC 3629
    -- validate byte 1
    if c > 0 and c <= 127 then
        -- UTF8-1
        return 1

    elseif c >= 194 and c <= 223 then
        -- UTF8-2
        local c2 = s:byte(i + 1)

        if not c2 then
            error("UTF-8 string terminated early")
        end

        -- validate byte 2
        if c2 < 128 or c2 > 191 then
            error("Invalid UTF-8 character")
        end

        return 2

    elseif c >= 224 and c <= 239 then
        -- UTF8-3
        local c2 = s:byte(i + 1)
        local c3 = s:byte(i + 2)

        if not c2 or not c3 then
            error("UTF-8 string terminated early")
        end

        -- validate byte 2
        if c == 224 and (c2 < 160 or c2 > 191) then
            error("Invalid UTF-8 character")
        elseif c == 237 and (c2 < 128 or c2 > 159) then
            error("Invalid UTF-8 character")
        elseif c2 < 128 or c2 > 191 then
            error("Invalid UTF-8 character")
        end

        -- validate byte 3
        if c3 < 128 or c3 > 191 then
            error("Invalid UTF-8 character")
        end

        return 3

    elseif c >= 240 and c <= 244 then
        -- UTF8-4
        local c2 = s:byte(i + 1)
        local c3 = s:byte(i + 2)
        local c4 = s:byte(i + 3)

        if not c2 or not c3 or not c4 then
            error("UTF-8 string terminated early")
        end

        -- validate byte 2
        if c == 240 and (c2 < 144 or c2 > 191) then
            error("Invalid UTF-8 character")
        elseif c == 244 and (c2 < 128 or c2 > 143) then
            error("Invalid UTF-8 character")
        elseif c2 < 128 or c2 > 191 then
            error("Invalid UTF-8 character")
        end
        
        -- validate byte 3
        if c3 < 128 or c3 > 191 then
            error("Invalid UTF-8 character")
        end

        -- validate byte 4
        if c4 < 128 or c4 > 191 then
            error("Invalid UTF-8 character")
        end

        return 4

    else
        error("Invalid UTF-8 character")
    end
end

function string.utf8sub (s, i, j)
    -- argument defaults
    j = j or -1

    -- argument checking
    if type(s) ~= "string" then
        error("bad argument #1 to 'utf8sub' (string expected, got ".. type(s).. ")")
    end
    if type(i) ~= "number" then
        error("bad argument #2 to 'utf8sub' (number expected, got ".. type(i).. ")")
    end
    if type(j) ~= "number" then
        error("bad argument #3 to 'utf8sub' (number expected, got ".. type(j).. ")")
    end

    local pos = 1
    local bytes = s:len()
    local len = 0

    -- only set l if i or j is negative
    local l = (i >= 0 and j >= 0) or s:utf8len()
    local startChar = (i >= 0) and i or l + i + 1
    local endChar   = (j >= 0) and j or l + j + 1

    -- can't have start before end!
    if startChar > endChar then
        return ""
    end

    -- byte offsets to pass to string.sub
    local startByte, endByte = 1, bytes

    while pos <= bytes do
        len = len + 1

        if len == startChar then
            startByte = pos
        end

        pos = pos + string.utf8charbytes(s, pos)

        if len == endChar then
            endByte = pos - 1
            break
        end
    end

    return s:sub(startByte, endByte)
end

function string.formatNumberThousands(num)
    local formatted = tostring(tonum(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function string.hex(s)
   return string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
end

local h2b = {
    ["0"] = 0,
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["A"] = 10,
    ["B"] = 11,
    ["C"] = 12,
    ["D"] = 13,
    ["E"] = 14,
    ["F"] = 15
}
function string.hex2bin( hexstr )
    local s = string.gsub(hexstr, "(.)(.)", function ( h, l )
         return string.char(h2b[h]*16+h2b[l])
    end)
    return s
end

function string.utf8ToList(str)
    assert(type(str) == "string")
    
    local list = {}

    local arr = {0xc0, 0xe0, 0xf0, 0xf8, 0xfc, 0xfe}

    local p = 1
    for i=1, #str do 
        if i == p then
            local v = string.byte(str, i)
            if v >= arr[#arr] then
                print("[Error] invalid UTF-8 character sequence")
                break
            end

            local n = 1
            for j=1, #arr do
                if v < arr[j] then
                    n = j
                    break
                end
            end
            
            local c = string.sub(str,i, i + n - 1)
            if #c == n then
                table.insert(list, c)
            else
                print("[Error] invalid UTF-8 character sequence")
            end

            p = p + n
        end
    end

    return list
end

-- 检查是否utf8编码
function string.isutf8code(str)
    assert(type(str) == "string")
    
    local list = {}

    local arr = {0xc0, 0xe0, 0xf0, 0xf8, 0xfc, 0xfe}

    local p = 1
    for i=1, #str do 
        if i == p then
            local v = string.byte(str, i)
            if v >= arr[#arr] then
                return false
            end

            local n = 1
            for j=1, #arr do
                if v < arr[j] then
                    n = j
                    break
                end
            end
            
            local c = string.sub(str,i, i + n - 1)
            if #c ~= n then
                return false
            end
            
            table.insert(list, c)

            p = p + n
        end
    end

    return true
end

function string.inputLen(str)
  
    local list = string.utf8ToList(str)

    local res = 0
    for _,v in ipairs(list) do

        local curByte = string.byte(v)
        if curByte > 0 and curByte <= 127 then

            res = res + 1
        else

            res = res + 2
        end
    end  

    return res
end

function string.getFontWidth(str,fontSize) 

    local lenInByte = #str
    local width = 0

    for i=1,lenInByte do
        local curByte = string.byte(str, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        
        local char = string.sub(str, i, i+byteCount-1)
        i = i + byteCount -1
        
        if byteCount == 1 then
            width = width + fontSize * 0.5
        else
            width = width + fontSize
            print(char)
        end
    end

    return width
end

-- 超出一定宽度显示省略号
function string.setStringEllipsis( label,  str)

    -- local curStr = label:getString()
    -- local curStrNumber = string.len(curStr)
    -- -- 查找字符串“...” 位于末尾不做处理
    -- local _, endIndex = string.find(curStr, "%.%.%.")

    -- if endIndex~=nil then print("curStr :"..curStr.."  endIndex: "..endIndex)  end

    -- if endIndex~=nil and endIndex == curStrNumber then
    --     label:setString(curStr)
    --     return
    -- end


    if label.lastContentSize == nil then 
        label.lastContentSize = label:getContentSize() 
    end
   
    local labelWidth = label.lastContentSize.width  -- tonumber(label:getTag()) 
    local strList = string.utf8ToList(str)
    local strNumber = table.nums(strList)
    --dump(strList, "---- > labelWidth: "..labelWidth)

    local tempStr = ""
    local strIndex = 0
    for _,v in pairs(strList) do
        
        local _str = tostring(v)
        strIndex = strIndex + 1
        label:setString( string.getStrByIndex(str, strIndex) )
        local lbWidth =  label:getContentSize().width
        -- print("strIndex:"..strIndex.."   lbWidth:"..lbWidth)

        tempStr = tempStr.._str
        if lbWidth >= labelWidth then
            if strIndex ~= strNumber then

                print("———————————— strIndex： "..strIndex.."  str:"..str)
               local lastStr = string.getStrByIndex(str, strIndex-1) 
               if lastStr then tempStr = lastStr.."..." end

                -- local lastStr = string.getStrByIndex(str, strIndex-1) 
                -- tempStr = lastStr..".." 
            end
            label:setString(tempStr)
            return
        end
    end
    label:setString(tempStr)
end

function string.isEmoji(newName)
    local len = string.utf8len(newName)--utf8解码长度
    for i = 1, len do
        local str = string.utf8sub(newName, i, i)
        local byteLen = string.len(str)--编码占多少字节
        if byteLen > 3 then--超过三个字节的必须是emoji字符啊
            return true
        end

        if byteLen == 3 then
            if string.find(str, "[\226][\132-\173]") or string.find(str, "[\227][\128\138]") then
                return true--过滤部分三个字节表示的emoji字符，可能是早期的符号，用的还是三字节，坑。。。这里不保证完全正确，可能会过滤部分中文字。。。
            end
        end


        if byteLen == 1 then
            local ox = string.byte(str)
            if (33 <= ox and 47 >= ox) or (58 <= ox and 64 >= ox) or (91 <= ox and 96 >= ox) or (123 <= ox and 126 >= ox) or (str == "　") then
                return true--过滤ASCII字符中的部分标点，这里排除了空格，用编码来过滤有很好的扩展性，如果是标点可以直接用%p匹配。
            end
        end
    end
    return false
end

function string.getStrByIndex( str, index )
    
    local strList = string.utf8ToList(str)
    local tempStr = ""
    local strIndex = 0
    for _,v in pairs(strList) do
        local _str = tostring(v)
        tempStr = tempStr.._str
        strIndex = strIndex + 1
        if strIndex == index then   
            return tempStr
        end
    end
end

-- 根据分割符号，返回分割后字符串表
function string.delimitStr( scrStr, delimiter )

    if scrStr==nil or scrStr=='' or delimiter==nil then
        return {}
    end
    
    local result = {}
    for match in (scrStr..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


local bit = require("bit")
-- 字符串转换unicode编码  (0x+unicode) 
-- codeRange = { minCode = 0x0600, maxCode = 0x06FF  }  判断是否携带某种字符编码
-- 编码范围 exp：
-- （ U+0590 – U+059F） 希伯来字符 
-- （ U+0600 – U+06FF） 阿拉伯字符
function string.utf8_to_unicode(convertStr, codeRangeList)

    if type(convertStr)~="string" then
        return  convertStr
    end

    local resultStr=""
    local i=1
    local num1=string.byte(convertStr,i)
    while num1~=nil do
        local tempVar1,tempVar2 = 0, 0
        if num1 >= 0x00 and num1 <= 0x7f then
            tempVar1=num1
            tempVar2=0
        elseif bit.band(num1,0xe0)== 0xc0 then
            local t1 = 0
            local t2 = 0
            t1 = bit.band(num1,bit.rshift(0xff,3))
            i=i+1
            num1=string.byte(convertStr,i)
            t2 = bit.band(num1,bit.rshift(0xff,2))
            tempVar1=bit.bor(t2,bit.lshift(bit.band(t1,bit.rshift(0xff,6)),6))
            tempVar2=bit.rshift(t1,2)
        elseif bit.band(num1,0xf0)== 0xe0 then
            local t1 = 0
            local t2 = 0
            local t3 = 0
            t1 = bit.band(num1,bit.rshift(0xff,3))
            i=i+1
            num1=string.byte(convertStr,i)
            t2 = bit.band(num1,bit.rshift(0xff,2))
            i=i+1
            num1=string.byte(convertStr,i)
            t3 = bit.band(num1,bit.rshift(0xff,2))
            tempVar1=bit.bor(bit.lshift(bit.band(t2,bit.rshift(0xff,6)),6),t3)
            tempVar2=bit.bor(bit.lshift(t1,4),bit.rshift(t2,2))
        end

        -- 检测当前字符是否包含
        if codeRangeList and string.isRangeUnicode(tempVar2 .. tempVar1, codeRangeList) then
            return true
        end

        resultStr=resultStr..string.format("\\u%02x%02x",tempVar2,tempVar1)
        i=i+1
        num1=string.byte(convertStr,i)

    end
    -- print(resultStr)
    return false

end

function string.isRangeUnicode(codeStr, codeRangeList)
    -- 是否存在特定字符
    local isRange = function (range)
        local unicode=tonumber("0x"..codeStr)
        local minCode = tonumber("0x"..range[1])
        local maxCode = tonumber("0x"..range[2])
        if unicode >= minCode and unicode <= maxCode then
            return true
        else 
            return false
        end
    end
    for i,v in ipairs(codeRangeList) do
        if isRange(v) then
            return true
        end
    end
    return false
end


-- function string.unicode_to_utf8(convertStr)


--     if type(convertStr)~="string" then
--         return convertStr
--     end

--     local resultStr=""
--     local i=1
--     while true do

--         local num1=string.byte(convertStr,i)
--         local unicode

--         if num1~=nil and string.sub(convertStr,i,i+1)=="\\u" then
--             unicode=tonumber("0x"..string.sub(convertStr,i+2,i+5))
--             i=i+6
--         elseif num1~=nil then
--             unicode=num1
--             i=i+1
--         else
--             break
--         end


--         print(unicode)

--         if unicode <= 0x007f then


--             resultStr=resultStr..string.char(bit.band(unicode,0x7f))


--         elseif unicode >= 0x0080 and unicode <= 0x07ff then

--             resultStr=resultStr..string.char(bit.bor(0xc0,bit.band(bit.rshift(unicode,6),0x1f)))

--             resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))


--         elseif unicode >= 0x0800 and unicode <= 0xffff then


--             resultStr=resultStr..string.char(bit.bor(0xe0,bit.band(bit.rshift(unicode,12),0x0f)))

--             resultStr=resultStr..string.char(bit.bor(0x80,bit.band(bit.rshift(unicode,6),0x3f)))

--             resultStr=resultStr..string.char(bit.bor(0x80,bit.band(unicode,0x3f)))


--         end

--     end

--     resultStr=resultStr..'\0'

--     print(resultStr)

--     return resultStr

-- end