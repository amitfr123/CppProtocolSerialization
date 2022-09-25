require("luaSrc.MessageValidator")
require("luaSrc.CodeGenerator")

local MessageIndex = require("index")

function Main()
    if not ExecuteAndPrintResult(CheckIndexMessages, MessageIndex, "Validating messages") then
        return
    end
    if not ExecuteAndPrintResult(GenerateCode, MessageIndex, "Creating messages") then
        return
    end
end

Main()