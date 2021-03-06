


--表操作

--返回指定表格中的所有键
-- 用法示例：
-- local t = {a = 1, b = 2, c = 3}
-- local keys = table.keys(t)
-- keys = {"a", "b", "c"}
function table.keys(t)
    local keys = {}
    if t == nil then
        return keys;
    end
    for k, v in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end


-- 返回指定表格中的所有值。
-- 格式：
-- values = table.values(表格对象)
-- 用法示例：
-- local t = {a = "1", b = "2", c = "3"}
-- local values = table.values(t)
-- -- values = {1, 2, 3}
function table.values(t)
    local values = {}
    if t == nil then
        return values;
    end
    for k, v in pairs(t) do
        values[#values + 1] = v
    end
    return values
end



--table t是否存在key
function table.containKey( t, key )
    for k, v in pairs(t) do
        if key == k then
            return true
        end
    end
    return false;
end

--table t是否存在value
function table.containValue( t, value )
    for k, v in pairs(t) do
        if value == v then
            return true
        end
    end
    return false;
end

function table.getKeyByValue( t, value )
    for k, v in pairs(t) do
        if value == v then
            return k
        end
    end
end

--table 将t2 的keys复制到t1中
function table.ikeys(t1, t2)
	for k,v in ipairs(t2) do
		table.insert(t1, k)
	end
end

--table 将t2 的keys复制到t1中
function table.kkeys(t1, t2)
	for k,v in pairs(t2) do
		table.insert(t1, k)
	end
end

function table.count(t)
	local i = 0
	for _,_ in pairs(t) do
		i = i + 1
	end
	return i
end

function table.isArray(t)
	if #t == table.count(t) then
		return true
	end
	return false
end

-- 合并两个表格。
-- 格式：
-- table.merge(目标表格对象, 来源表格对象)
-- 将来源表格中所有键及其值复制到目标表格对象中，如果存在同名键，则覆盖其值
function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function arrayContain( array, value)
    for i=1,#array do
        if array[i] == value then
            return true;
        end
    end
    return false;
end


--====================================
--字符串操作


-- 分割字符串。
-- 格式：
-- result = string.split(要分割的字符串, 分隔符)
-- 用法示例：
-- local result = string.split("1,2,3", ",")
-- result = {"1", "2", "3"}
function string.split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

--计算一个 UTF8 字符串包含的字符数量
--当一个 UTF8 字符串中包含中文时，string.len() 返回的结果是字符串的字节长度。string.utf8len() 会确保始终返回字符串中包含的字符数量。
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

local function urlencodeChar(char)
    return "%" .. string.format("%02X", string.byte(c))
end

--为了通过 URL 传递数据，字符串中所有的非字母和数字都会被替换为“%编码”格式，空格会被替换为“+”。
function string.urlencode(str)
    -- convert line endings
    str = string.gsub(tostring(str), "\n", "\r\n")
    -- escape all characters but alphanumeric, '.' and '-'
    str = string.gsub(str, "([^%w%.%- ])", urlencodeChar)
    -- convert spaces to "+" symbols
    return string.gsub(str, " ", "+")
end

--将数字格式化为千分位格式。
--用法示例：
--local result = string.formatNumberThousands(12345)
-- result = "12,345"
function string.formatNumberThousands(num)
    local formatted = tostring(tonumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- 删除字符串前部的空白字符。
-- 格式：
-- result = string.ltrim(字符串)
-- 空白字符包括：空格、制表符“\t”、换行符“\n”和“\r”。
-- 用法示例：
-- local result = string.ltrim("   \n\tHello")
-- result = "Hello"
function string.ltrim(str)
    return string.gsub(str, "^[ \t\n\r]+", "")
end

--删除字符串尾部的空白字符。
function string.rtrim(str)
    return string.gsub(str, "[ \t\n\r]+$", "")
end

--删除字符串两端的空白字符
function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end

-- 返回首字母大写的字符串
function string.ucfirst(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end


