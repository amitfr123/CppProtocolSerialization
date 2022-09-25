function ContainsKey(table, key)
    return table[key] ~= nil
end

function ExecuteAndPrintResult(func, param, str)
    if func(param) then
        print(str.." success")
        return true
    else
        print("fail")
        return false
    end
end

function WriteLine(str)
    io.write(str, "\n")
end

function WriteLineTabbed(str, num)
    local line = ""
    for i = 1,num do line = line.."    " end
    WriteLine(line..str)
end

function CapitalizeFirstCharacter(str)
    return str:gsub("^%l", string.upper, 1)
end