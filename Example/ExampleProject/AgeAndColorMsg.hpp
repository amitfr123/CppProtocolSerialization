#pragma once

#include "AgeMsg.hpp"

class AgeAndColorMsg : public AgeMsg {
public:
    AgeAndColorMsg(uint16_t age, std::string color, std::vector<uint8_t> rgb) : 
        AgeMsg(GenMessageType::AGEANDCOLORMSG_E, age), 
        _color(color), _rgb(std::move(rgb)){}

    AgeAndColorMsg() = default;

    virtual ~AgeAndColorMsg() = default;

    virtual void serializeIntoVector(std::vector<char>& vec) {
        AgeMsg::serializeIntoVector(vec);
        TypeSerialization::serializeString(vec, _color);
        TypeSerialization::serializePrimitiveVector(vec, _rgb);
    }

    std::string getColor() { return _color;}
    std::vector<uint8_t> getRgb() { return _rgb;}

protected:
    AgeAndColorMsg(GenMessageType genMessageType, uint16_t age, std::string color, std::vector<uint8_t> rgb) : 
        AgeMsg(genMessageType, age), 
        _color(color), _rgb(std::move(rgb)){}

    virtual bool buildFromVec(const std::vector<char>& vec, uint32_t& offset) {
        AgeMsg::buildFromVec(vec, offset);
        if (!TypeSerialization::deserializeString(vec, _color, offset)) {
            return false;
        }
        if (!TypeSerialization::deserializePrimitiveVector(vec, _rgb, offset)) {
            return false;
        }
        return true;
    }

private:
    std::string _color;
    std::vector<uint8_t> _rgb;
};
