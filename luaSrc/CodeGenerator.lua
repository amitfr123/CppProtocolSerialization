require("luaSrc.GenMessageTypeGenerator")
require("luaSrc.DeserializerGenerator")
require("luaSrc.MessageClassGenerator")

function GenerateCode(messageIndex)
    for k,v in pairs(messageIndex) do
        CreateMessageClassFile(v)
    end
    CreateGenMessageDeserializerFile(messageIndex)
    CreateGenMessageTypeFile(messageIndex)
    return true
end