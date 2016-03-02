--序列化一个Table  
function tableToStr(t)  
    local mark={}  
    local assign={}  
  
    local function table2str(t, parent)  
        mark[t] = parent  
        local ret = {}  
  
        if table.isArray(t) then  
            for i,v in pairs(t) do  
                local k = tostring(i)  
                local dotkey = parent.."["..k.."]"  
                local t = type(v)  
                if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then  
                    --ignore  
                elseif t == "table" then  
                    if mark[v] then  
                        table.insert(assign, dotkey.."="..mark[v])  
                    else  
                        table.insert(ret, table2str(v, dotkey))  
                    end  
                elseif t == "string" then  
                    table.insert(ret, string.format("%q", v))  
                elseif t == "number" then  
                    if v == math.huge then  
                        table.insert(ret, "math.huge")  
                    elseif v == -math.huge then  
                        table.insert(ret, "-math.huge")  
                    else  
                        table.insert(ret,  tostring(v))  
                    end  
                else  
                    table.insert(ret,  tostring(v))  
                end  
            end  
        else  
            for f,v in pairs(t) do  
                local k = type(f)=="number" and "["..f.."]" or f  
                local dotkey = parent..(type(f)=="number" and k or "."..k)  
                local t = type(v)  
                if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then  
                    --ignore  
                elseif t == "table" then  
                    if mark[v] then  
                        table.insert(assign, dotkey.."="..mark[v])  
                    else  
                        table.insert(ret, string.format("%s=%s", k, table2str(v, dotkey)))  
                    end  
                elseif t == "string" then  
                    table.insert(ret, string.format("%s=%q", k, v))  
                elseif t == "number" then  
                    if v == math.huge then  
                        table.insert(ret, string.format("%s=%s", k, "math.huge"))  
                    elseif v == -math.huge then  
                        table.insert(ret, string.format("%s=%s", k, "-math.huge"))  
                    else  
                        table.insert(ret, string.format("%s=%s", k, tostring(v)))  
                    end  
                else  
                    table.insert(ret, string.format("%s=%s", k, tostring(v)))  
                end  
            end  
        end  
  
        return "{"..table.concat(ret,",").."}"  
    end  
  
    if type(t) == "table" then  
        return string.format("%s%s",  table2str(t,"_"), table.concat(assign," "))  
    else  
        return tostring(t)  
    end  
end  


--反序列化一个Table  
function strToTable(str)
	local EMPTY_TABLE = {} 
    if str == nil or str == "nil" then  
        return {}  
    elseif type(str) ~= "string" then  
        EMPTY_TABLE = {}  
        return EMPTY_TABLE  
    elseif #str == 0 then  
        EMPTY_TABLE = {}  
        return EMPTY_TABLE  
    end  
  
    local code, ret = pcall(loadstring(string.format("do local _=%s return _ end", str)))  
  
    if code then  
        return ret  
    else  
        EMPTY_TABLE = {}  
        return EMPTY_TABLE  
    end  
end


-- 打印整个table
function print_r(tb)
    if type(tb) ~= "table" then
        print(tb)
        return
    end
    local str = ""
    local tab = "    "
    local count = -1
    local function _print(t)
        count = count + 1
        local temp = ""
        local tmp = tab
        for i = 1, count do
            temp = string.format("%s%s", temp, tab)-- temp .. tab
            tmp = string.format("%s%s", tmp, tab)-- tmp .. tab
        end
        if type(t) ~= "table" then
            local data = tostring(t)
            if type(t) == "string" then
                data = string.format("\"%s\"", data)
            end
            str = string.format("%s%s,\n", str, data)
            count = count - 1
            return
        end

        str = string.format("%s\n%s{\n", str, temp) --str .. "\n" .. temp .. "{" .. "\n"
        for i, v in pairs(t) do
            local key = tostring(i)
            if type(i) == "string" then
                key = string.format("\"%s\"", key)
            end
            str = string.format("%s%s[%s] = ", str, tmp, key)--str .. tmp .. "[" .. i .. "]" .. "="
            _print(v)
        end
        str = string.format("%s%s},\n", str, temp) --str .. temp .. "}\n"
        count = count - 1
    end
    _print(tb)
    print(str)
end

function print_lua_table (lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end


local tonumber_ = tonumber
function tonumber(v, base)
    return tonumber_(v, base) or 0
end

function toint(v)
    return math.round(tonumber(v))
end

function tobool(v)
    return (v ~= nil and v ~= false)
end

function totable(v)
    if type(v) ~= "table" then v = {} end
    return v
end

--复制对象
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


--单例类
function sclass(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.dtor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            -- 已经是单例的对象，如果再被new就提示错误
            if cls.__instance then
                Log_Error(string.format("%s is single, can't produce others instance", cls.__cname))
                return nil
            end
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls

            local function _create(obj, ...)
                if obj.super then
                    _create(obj.super, ...)
                end
                obj.ctor(instance, ...)
            end

            _create(instance, ...)
            return instance
        end
    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end,
                dtor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            -- 已经是单例的对象，如果再被new就提示错误
            if cls.__instance then
                Log_Error(string.format("%s is single, can't produce others instance", cls.__cname))
                return nil
            end
            local instance = setmetatable({}, cls)
            instance.class = cls
            local function _create(obj, ...)
                if obj.super then
                    _create(obj.super, ...)
                end
                obj.ctor(instance, ...)
            end

            _create(instance, ...)
            return instance
        end
    end

    cls.__instance = nil
    -- 单例
    function cls.getInstance()
        if not cls.__instance then
            cls.__instance = cls.new()
        end
        return cls.__instance
    end
    -- 析构单例
    function cls.releaseInstance()
        if cls.__instance then
            cls.__instance:delete()
            cls.__instance = nil
        end
    end
    -- 析构函数
    function cls.delete(cls)
        local function _delete(obj)
            obj.dtor(cls)
            if obj.super then
                _delete(obj.super)
            end
        end
        _delete(cls)
    end
    return cls
end

--多例类
function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end


function handler(target, method)
    return function(...) return method(target, ...) end
end

function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        print("file is ok ok ok  ok ok ")
        if file:write(content) == nil then print("file is bad bad bad bad ") return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

function io.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

--计数器
local function newCounter()
    local i = 0
    return function()     -- anonymous function
       i = i + 1
        return i
    end
end

g_id_generator = newCounter()
function getNextID()
  local nextID 
    nextID = g_id_generator()
    return nextID
end




--去除扩展名
function stripExtension(filename)
    local idx = filename:match(".+()%.%w+$")
    if(idx) then
        return filename:sub(1, idx-1)
    else
        return filename
    end
end

--获取路径
function stripfilename(filename)
    return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system
    --return string.match(filename, “(.+)\\[^\\]*%.%w+$”) — windows
end

--获取文件名
function strippath(filename)
    return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system
    --return string.match(filename, “.+\\([^\\]*%.%w+)$”) — *nix system
end