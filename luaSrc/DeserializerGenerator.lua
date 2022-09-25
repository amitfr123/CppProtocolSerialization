require("luaSrc.UtilityFunctions")
require("luaSrc.PrimitiveTypes")

function CreateGenMessageDeserializerFile(messageIndex)
    File = io.open("output/GenMessageDeserializer.hpp", "w")
    io.output(File)
    WriteLine("#pragma once")
    WriteLine("")
    CreateGenMessageDeserializerInclude(messageIndex)
    WriteLine("class GenMessageDeserializer {")
    WriteLine("public:")
    CreateDeserializerFunction(messageIndex)
    WriteLine("};")
    io.close(File)
end

function CreateGenMessageDeserializerInclude(messageIndex)
    WriteLine("#include \"BaseProtoMessage.hpp\"")
    for k,v in pairs(messageIndex) do
        if (ContainsKey(v, "baseMsg")) then
            WriteLine("#include \""..v.msgName..".hpp\"")
        end
    end
    WriteLine("")
end

function CreateDeserializerFunction(messageIndex)
    WriteLineTabbed("static std::optional<std::shared_ptr<BaseProtoMessage>> deserializeVector(const std::vector<char>& vec) {", 1)
    WriteLineTabbed("uint32_t offset = 0;", 2)
    WriteLineTabbed("GenMessageType type;", 2)
    WriteLineTabbed("if (!TypeSerialization::deserializePrimitive(vec, type, offset)) {", 2)
    WriteLineTabbed(" ".."    ".."    ".."return {};", 3)
    WriteLineTabbed("}", 2)
    WriteLineTabbed("std::shared_ptr<BaseProtoMessage> msg;", 2)
    WriteLineTabbed("switch(type) {", 2)
    for k,v in pairs(messageIndex) do
        if (ContainsKey(v, "baseMsg")) then
            WriteLineTabbed("case GenMessageType::"..v.msgName:upper().."_E:", 2)
            WriteLineTabbed("msg = std::make_shared<"..v.msgName..">();", 3)
            WriteLineTabbed("break;", 3)
        end
    end
    WriteLineTabbed("default:", 2)
    WriteLineTabbed("return {};", 3)
    WriteLineTabbed("}", 2)
    WriteLineTabbed("if (!msg->buildFromVec(vec, offset)) {", 2)
    WriteLineTabbed("return {};", 3)
    WriteLineTabbed("}", 2)
    WriteLineTabbed("return {msg};", 2)
    WriteLineTabbed("}", 1)
end