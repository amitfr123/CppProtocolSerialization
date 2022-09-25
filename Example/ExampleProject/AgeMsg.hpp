#pragma once

#include "BaseProtoMessage.hpp"

class AgeMsg : public BaseProtoMessage {
public:
    virtual ~AgeMsg() = default;

    virtual void serializeIntoVector(std::vector<char>& vec) {
        BaseProtoMessage::serializeIntoVector(vec);
        TypeSerialization::serializePrimitive(vec, _age);
    }

    uint16_t getAge() { return _age;}

protected:
    AgeMsg(GenMessageType genMessageType, uint16_t age) : 
        BaseProtoMessage(genMessageType), 
        _age(age){}

    AgeMsg() = default;

    virtual bool buildFromVec(const std::vector<char>& vec, uint32_t& offset) {
        BaseProtoMessage::buildFromVec(vec, offset);
        if (!TypeSerialization::deserializePrimitive(vec, _age, offset)) {
            return false;
        }
        return true;
    }

private:
    uint16_t _age;
};
