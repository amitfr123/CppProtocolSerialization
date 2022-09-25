#pragma once

#include "BaseProtoMessage.hpp"
#include "AgeAndColorMsg.hpp"

class GenMessageDeserializer {
public:
    static std::optional<std::shared_ptr<BaseProtoMessage>> deserializeVector(const std::vector<char>& vec) {
        uint32_t offset = 0;
        GenMessageType type;
        if (!TypeSerialization::deserializePrimitive(vec, type, offset)) {
                     return {};
        }
        std::shared_ptr<BaseProtoMessage> msg;
        switch(type) {
        case GenMessageType::AGEANDCOLORMSG_E:
            msg = std::make_shared<AgeAndColorMsg>();
            break;
        default:
            return {};
        }
        if (!msg->buildFromVec(vec, offset)) {
            return {};
        }
        return {msg};
    }
};
