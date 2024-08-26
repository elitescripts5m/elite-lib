local module = {}
local nCharset = {}
local sCharset = {}
for i = 48, 57 do nCharset[#nCharset + 1] = string.char(i) end
for i = 65, 90 do sCharset[#sCharset + 1] = string.char(i) end
for i = 97, 122 do sCharset[#sCharset + 1] = string.char(i) end

local function tPrint(table, indent)
    indent = indent or 0
    if type(table) == "table" then
        for k, v in pairs(table) do
            local tblType = type(v)
            local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)

            if tblType == "table" then
                print(formatting)
                tPrint(v, indent + 1)
            elseif tblType == "boolean" then
                print(("%s^1 %s ^0"):format(formatting, v))
            elseif tblType == "function" then
                print(("%s^9 %s ^0"):format(formatting, v))
            elseif tblType == "number" then
                print(("%s^5 %s ^0"):format(formatting, v))
            elseif tblType == "string" then
                print(('%s ^2"%s" ^0'):format(formatting, v))
            else
                print(("%s^2 %s ^0"):format(formatting, v))
            end
        end
    else
        print(("%s ^0%s"):format(string.rep("  ", indent), table))
    end
end

module.debugger = function(table, indent)
    print(("\x1b[4m\x1b[36m[ELITE-LIB DEBUGGER]\x1b[0m"))
    tPrint(table, indent)
    print("\x1b[4m\x1b[36m[DEBUGGER ENDED]\x1b[0m")
end

module.randomInt = function(length)
    if not CheckArgs(length) then return end
    local number = ""
    for _ = 1, length do
        number = number..nCharset[math.random(1, #nCharset)]
    end

    return tonumber(number)
end

module.randomString = function(length)
    if not CheckArgs(length) then return end
    local string = ""
    for _ = 1, length do
        string = string..sCharset[math.random(1, #nCharset)]
    end

    return tostring(string)
end

module.trim = function(value)
    if not CheckArgs(value) then return end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

module.firstToUpper = function(value)
    if not CheckArgs(value) then return end
    return (value:gsub("^%l", string.upper))
end

module.round = function(value, numDecimalPlaces)
    if not CheckArgs(value) then return end
    if not numDecimalPlaces then
        return math.floor(value + 0.5)
    end

    local power = 10 ^ numDecimalPlaces
    return (math.floor((value * power) + 0.5) / (power))
end

return module