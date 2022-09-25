require("luaSrc.UtilityFunctions")
require("luaSrc.PrimitiveTypes")

function CreateGenMessageTypeFile(messageIndex)
    File = io.open("output/GenMessageType.hpp", "w")
    io.output(File)
    local line = ""
    WriteLine("#pragma once")
    WriteLine("")
    WriteLine("enum GenMessageType {")
    for k,v in pairs(messageIndex) do
        if (ContainsKey(v, "baseMsg")) then
            line = line..v.msgName:upper().."_E, "
        end
    end
    WriteLineTabbed(line:sub(1, -3), 1)
    WriteLine("};")
    io.close(File)
end