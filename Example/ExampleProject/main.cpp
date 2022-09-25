#include <iostream>

#include "GenMessageDeserializer.hpp"

int main()
{
    std::vector<uint8_t> rgb = {67,84,90};
    std::vector<char> ser;
    AgeAndColorMsg msg(8, "light blue", std::move(rgb));
    msg.serializeIntoVector(ser);
    auto des = GenMessageDeserializer::deserializeVector(ser);
    if (!des.has_value())
    {
        std::cout << "fail" << std::endl;
    }
    else
    {
        auto ageAndColor = std::dynamic_pointer_cast<AgeAndColorMsg>(des.value());
        std::cout << "age = " << ageAndColor->getAge() << std::endl;
        std::cout << "color = " << ageAndColor->getColor() << " rgb: " << 
            ageAndColor->getRgb()[0] << ageAndColor->getRgb()[1] << ageAndColor->getRgb()[2] << std::endl;
    }
    return 0;
}