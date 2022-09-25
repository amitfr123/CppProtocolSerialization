require("luaSrc.UtilityFunctions")
require("luaSrc.PrimitiveTypes")

function CreateMessageClassFile(msg)
    File = io.open("output/"..msg.msgName..".hpp", "w")
    io.output(File)
    local isDerived = ContainsKey(msg, "baseMsg")
    WriteLine("#pragma once")
    WriteLine("")
    CreateMessageInclude(msg, isDerived)
    CreateMessageClass(msg, isDerived)
    io.close(File)
end

function CreateMessageInclude(msg, isDerived)
    local line
    if isDerived then
        line = "#include \""..msg.baseMsg.msgName..".hpp\""
    else
        line = "#include \"BaseProtoMessage.hpp\""
    end
    WriteLine(line)
    WriteLine("")
end

function CreateMessageClass(msg, isDerived)
    
    local line
    local isConcrete = false
    line = "class "..msg.msgName.." : public "
    if isDerived then
        line = line..msg.baseMsg.msgName
    else
        line = line.."BaseProtoMessage"
    end
    if ContainsKey(msg, "isConcrete") then
        isConcrete = msg.isConcrete
    end
    WriteLine(line.." {")
    CreateClassPublicSection(msg, isDerived, isConcrete)
    CreateClassProtectedSection(msg, isDerived, isConcrete)
    CreateClassPrivateSection(msg, isDerived)
    WriteLine("};")
end

function CreateClassPublicSection(msg, isDerived, isConcrete)
    WriteLine("public:")
    if isConcrete then
        CreateComplexConstructorFunction(msg, isDerived, isConcrete)
        WriteLine("")
        WriteLineTabbed(msg.msgName.."() = default;", 1)
        WriteLine("")
    end
    WriteLineTabbed("virtual ~"..msg.msgName.."() = default;", 1)
    WriteLine("")
    CreateSerializeIntoVectorFunction(msg, isDerived)
    WriteLine("")
    CreateClassMembersGetters(msg)
    WriteLine("")
end

function CreateClassProtectedSection(msg, isDerived, isConcrete)
    WriteLine("protected:")
    CreateComplexConstructorFunction(msg, isDerived, false)
    WriteLine("")
    if not isConcrete then
        WriteLineTabbed(msg.msgName.."() = default;", 1)
        WriteLine("")
    end
    CreateBuildFromVecFunction(msg, isDerived)
    WriteLine("")
end

function CreateClassPrivateSection(msg, isDerived)
    WriteLine("private:")
    CreateClassMembers(msg)
end

function CreateClassMembers(msg)
    for k,v in ipairs(msg.fields) do
        local dataType = GetFieldDataType(v)
        WriteLineTabbed(dataType.." _"..v.fieldName..";", 1)
    end
end

function CreateClassMembersGetters(msg)
    for k,v in ipairs(msg.fields) do
        local dataType = GetFieldDataType(v)
        WriteLineTabbed(dataType.." get"..CapitalizeFirstCharacter(v.fieldName).."() { return _"..v.fieldName..";}", 1)
    end
end

function CreateSerializeIntoVectorFunction(msg, isDerived)
    local line = ""
    WriteLineTabbed("virtual void serializeIntoVector(std::vector<char>& vec) {", 1)
    if isDerived then
        WriteLineTabbed(msg.baseMsg.msgName.."::serializeIntoVector(vec);", 2)
    else
        WriteLineTabbed("BaseProtoMessage::serializeIntoVector(vec);", 2)
    end
    for k,v in ipairs(msg.fields) do
        line = "TypeSerialization::"
        if ContainsKey(v, "array") then
            line = line.."serializePrimitiveVector"
        elseif v.dataType == "string" then
            line = line.."serializeString"
        else
            line = line.."serializePrimitive"
        end
        line = line.."(vec, _"..v.fieldName..");"
        WriteLineTabbed(line, 2)
    end
    WriteLineTabbed("}", 1)
end

function CreateBuildFromVecFunction(msg, isDerived)
    local isFirstMember = true
    local line = ""
    WriteLineTabbed("virtual bool buildFromVec(const std::vector<char>& vec, uint32_t& offset) {", 1)
    if isDerived then
        WriteLineTabbed(msg.baseMsg.msgName.."::buildFromVec(vec, offset);", 2)
    else
        WriteLineTabbed("BaseProtoMessage::buildFromVec(vec, offset);", 2)
    end
    for k,v in ipairs(msg.fields) do
        line = "if (!TypeSerialization::"
        if ContainsKey(v, "array") then
            line = line.."deserializePrimitiveVector"
        elseif v.dataType == "string" then
            line = line.."deserializeString"
        else
            line = line.."deserializePrimitive"
        end
        line = line.."(vec, _"..v.fieldName..", offset)) {"
        WriteLineTabbed(line, 2)
        WriteLineTabbed("return false;", 3)
        WriteLineTabbed("}", 2)
    end
    WriteLineTabbed("return true;", 2)
    WriteLineTabbed("}", 1)
end

function CreateComplexConstructorFunction(msg, isDerived, isConcrete)
    CreateConstructorParameters(msg, isDerived, isConcrete)
    CreateConstructorInitList(msg, isDerived, isConcrete)
end

function CreateConstructorParameters(msg, isDerived, isConcrete)
    local line = msg.msgName.."("
    if not isConcrete then
        line = line.."GenMessageType genMessageType, "
    end
    line = (line..AddClassMemberToConstructorParameters(msg, isDerived)):sub(1, -3)
    WriteLineTabbed(line..") : ", 1)
end

function AddClassMemberToConstructorParameters(msg, isDerived)
    local line = ""
    if isDerived then
        line = AddClassMemberToConstructorParameters(msg.baseMsg, ContainsKey(msg.baseMsg, "baseMsg"))
    end
    for k,v in ipairs(msg.fields) do
        local dataType = GetFieldDataType(v)
        line = line..dataType.." "..v.fieldName..", "
    end
    return line
end

function CreateConstructorInitList(msg, isDerived, isConcrete)
    AddCallToBaseConstructor(msg, isDerived, isConcrete)
    AddClassMembersInitialization(msg)
end

function AddCallToBaseConstructor(msg, isDerived, isConcrete)
    local line = ""
    if isDerived then
        line = line..msg.baseMsg.msgName
    else
        line = line.."BaseProtoMessage"
    end
    line = line.."("
    if isConcrete then
        line = line.."GenMessageType::"..((msg.msgName):upper()).."_E"
    else
        line = line.."genMessageType"
    end
    line = line..", "
    if isDerived then
        line = line..AddBaseClassMemberToInitList(msg.baseMsg, ContainsKey(msg.baseMsg, "baseMsg"))
    end
    line = line:sub(1, -3).."), "
    WriteLineTabbed(line, 2)
end

function AddClassMembersInitialization(msg)
    local line = AddClassMemberToInitList(msg)
    line = line:sub(1, -3)
    line = line.."{}"
    WriteLineTabbed(line, 2)
end

function AddBaseClassMemberToInitList(msg, isDerived)
    local line = ""
    if isDerived then
        line = AddBaseClassMemberToInitList(msg.baseMsg, ContainsKey(msg.baseMsg, "baseMsg"))
    end
    for k,v in ipairs(msg.fields) do
        if ContainsKey(v, "array") or ContainsKey(v, "string") then
            line = line.."std::move("..v.fieldName.."), "
        else
            line = line..v.fieldName..", "
        end
    end
    return line
end

function AddClassMemberToInitList(msg)
    local line = ""
    for k,v in ipairs(msg.fields) do
        line = line.."_"..v.fieldName.."("
        if ContainsKey(v, "array") or ContainsKey(v, "string") then
            line = line.."std::move("..v.fieldName..")"
        else
            line = line..v.fieldName
        end
        line = line.."), "
    end
    return line
end

function GetFieldDataType(field)
    local dataType
    if ContainsKey(field, "array") then
        dataType = "std::vector<"..field.dataType..">"
    elseif field.dataType ==  "string" then
        dataType = "std::string"
    else
        dataType = field.dataType
    end
    return dataType
end