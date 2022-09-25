require("luaSrc.UtilityFunctions")
require("luaSrc.PrimitiveTypes")

function CheckIndexMessages(messageIndex)
    if messageIndex == nil then
        return false
    end
    for k,v in pairs(messageIndex) do
        if not CheckMessageIntegrity(v, k, messageIndex) then
            return false
        end
    end
    return true
end

function CheckMessageIntegrity(msg, k, messageIndex)
    if msg == nil then
        return false
    elseif not ContainsKey(msg, "msgName") then
        print("Message in "..k.." is missing a name")
        return false
    end
    if ContainsKey(msg, "msgBase") then
        if not CheckMessageInheritance(msg, messageIndex) then
            return false
        end
    end
    return CheckMessageFieldsIntegrity(msg.fields)
end

function CheckMessageInheritance(msgBase, messageIndex)
    if msgBase == nil then
        return false
    elseif not ContainsKey(messageIndex, msgBase.msgName) then
        return false
    end
    return true
end

function CheckMessageFieldsIntegrity(msgFields)
    if msgFields == nil then
        return false
    end
    for k,v in ipairs(msgFields) do
        if not CheckDataFieldIntegrity(v, k) then
            return false
        end
    end
    return true
end

function CheckDataFieldIntegrity(field, k)
    if not ContainsKey(field, "fieldName") then
        print("Field in key "..k.." is missing a name")
        return false
    elseif not ContainsKey(field, "dataType") then
        print("Field "..field.fieldName.." is missing a dataType")
        return false
    elseif not ContainsKey(PrimitiveTypes, field.dataType) and (not(field.dataType == "string")) then
        print("Field "..field.fieldName.." has an invalid dataType = "..field.dataType)
        return false
    end
    return true
end