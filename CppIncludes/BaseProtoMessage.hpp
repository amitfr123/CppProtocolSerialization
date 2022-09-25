#pragma once

#include <memory>

#include "TypeSerialization.hpp"
#include "GenMessageType.hpp"

class BaseProtoMessage {
public:
    virtual void serializeIntoVector(std::vector<char>& vec) {
        if (!vec.empty())
        {
            vec.clear();
        }
        TypeSerialization::serializePrimitive(vec, _type);
    }

    virtual ~BaseProtoMessage() = default;
protected:
    friend class GenMessageDeserializer;
    BaseProtoMessage(GenMessageType type) :
        _type(type)
    {}

    // This function is called by the deserializer
    BaseProtoMessage()
    {}

    virtual bool buildFromVec(const std::vector<char>& vec, uint32_t& offset)
    {
        offset = 0;
        if (!TypeSerialization::deserializePrimitive(vec, _type, offset))
        {
            return false;
        }
        return true;
    }
private:
    GenMessageType _type;
};