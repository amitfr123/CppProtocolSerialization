#pragma once

#include <vector>
#include <span>
#include <optional>
#include <cstdint>
#include <type_traits>
#include <cstring>
#include <string>

class TypeSerialization
{
public:
    template<typename T>
    static bool deserializePrimitive(const std::vector<char>& vec, T& mem, uint32_t& offset)
    {
        static_assert(std::is_fundamental<T>::value || std::is_enum<T>::value, "Invalid template type for deserializePrimitive");
        if (vec.size() - offset >= sizeof(T))
        {
            std::memcpy(&mem, vec.data() + offset, sizeof(T));
            offset += sizeof(T);
            return true;
        }
        return false;
    }

    template<typename T>
    static bool deserializePrimitiveVector(const std::vector<char>& vec, std::vector<T>& mem, uint32_t& offset)
    {
        static_assert(std::is_fundamental<T>::value || std::is_enum<T>::value, "Invalid template type for deserializePrimitiveVector");
        return deserializeArrayType(vec, mem, offset, sizeof(T));
    }

    static bool deserializeString(const std::vector<char>& vec, std::string& mem, uint32_t& offset)
    {
        return deserializeArrayType(vec, mem, offset, sizeof(char));
    }

    template<typename T>
    static void serializePrimitive(std::vector<char>& vec, T mem)
    {
        static_assert(std::is_fundamental<T>::value || std::is_enum<T>::value, "Invalid template type for serializePrimitive");
        uint32_t vec_size = vec.size();
        vec.resize(vec_size + sizeof(T));
        std::memcpy(vec.data() + vec_size, &mem, sizeof(T));
    }

    template<typename T>
    static void serializePrimitiveVector(std::vector<char>& vec, std::vector<T>& mem)
    {
        static_assert(std::is_fundamental<T>::value || std::is_enum<T>::value, "Invalid template type for serializePrimitiveVector");
        serializeArrayType(vec, mem, sizeof(T));
    }

    static void serializeString(std::vector<char>& vec, std::string& mem)
    {
        serializeArrayType(vec, mem, sizeof(char));
    }

private:
    template<typename T>
    static bool deserializeArrayType(const std::vector<char>& vec, T& mem, uint32_t& offset, uint32_t typeSize)
    {
        uint32_t arrSize;
        if (!deserializePrimitive(vec, arrSize, offset))
        {
            return false;
        }
        if ((vec.size() - offset) / typeSize < arrSize)
        {
            return false;
        }
        mem.resize(arrSize);
        std::memcpy(mem.data(), vec.data() + offset, arrSize * typeSize);
        offset += arrSize * typeSize;
        return true;
    }

    template<typename T>
    static void serializeArrayType(std::vector<char>& vec, T& mem, uint32_t typeSize)
    {
        uint32_t arr_size = mem.size();
        serializePrimitive<uint32_t>(vec, arr_size);
        uint32_t vec_size = vec.size();
        vec.resize(vec_size + arr_size * typeSize);
        std::memcpy(vec.data() + vec_size, mem.data(), arr_size * typeSize);
    }
};