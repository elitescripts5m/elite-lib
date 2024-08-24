local module = {}

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

return module