# CppProtocolSerialization
This project aims to provide a simple to provide a simple tool for creating protocol classes with binary serialization functionality for c++ projects.

This project was created mainly for fun and coding practice. If you need a more robust tool I recommend that you look at other projects like protobuf flatbuffers and nanopb.

### What are protocol classes?
Protocol class in my view are class that only exist as an application communication protocol. The only functionality they provide is usually for serialization and deserialization of class members (aside from getters setters construction and all that jazz).

Creating them manually is time consuming and usually requires a lot of boilerplate code.

## How to use?
1. Create an index.lua file.
2. Create message.lua file for you messages.
3. Run main.lua
4. Copy the generated files in the output folder an CppIncludes folder and add them to your project.
5. Enjoy

For the fastest setup just created all of your files in main project folder.

## Index and Protocol files syntax
The protocol files and index files are simple lua files that export data using the ability to return tables.

### Index file syntax
In the index file you require all of your protocol files and export them using the return section.
The reason you add the protocol name as a key is to make searches easier for the scripts.

    Protocol1 = require("ProtocolFolder.protocol1")
    Protocol2 = require("ProtocolFolder.protocol2")

    return {
        [Protocol1.msgName] = Protocol1,
        [Protocol2.msgName] = Protocol2
    }


### Protocol file syntax
The protocol file syntax uses a table with key words to describe the protocol data and relationship with other protocols.

The key words are:

1. msgName = the message name (mandatory).
2. isConcrete = do you want the class created to be concrete(optional).
3. baseMsg = the base class for this class (optional).
4. fields = the data that the class contains (optional).

example of a file:

    return {
        msgName = "MyProto",
        isConcrete = true,
        fields = {
            {fieldName = "mem1", dataType = "string"},
            {fieldName = "mem2", dataType = "uint8_t", array = true},
            {fieldName = "mem3", dataType = "uint32_t"},
        }
    }

### Troubleshooting tips
* Make sure that all of your files are searchable by index.lua. If you are having problems with this you can always just add all of your files to this project main folder.
* If you tried to compile the c++ code and it failed check if you compiled with c++ 20.

### Project limitation
This project will probably only support primitive types arrays and strings. I might add more complex types later but it isn't planed for now.

The might do later list:

1. More complex data types.
2. Class description.
3. Static array sizes.

## Background on the project
### What does binary serialization mean?
Binary serialization means taking data and representing it in a binary format.

To explain the difference between text and binary serialization its easier to use an over simplified example:

Let take a data structure and try to serialize it in the two methods presented.

    struct s
    {
        uint8_t a = 8
        uint8_t b = 5
    }


Can be represented as a text:

    s {
        a = 8
        b = 5
    }

And it can also be represented by its binary value:

    10000101

While the text format has much better readability for some applications it is slow because it requires you to preform string manipulation. 
On the other hand the binary isn't readable at all but because you can achieve it without converting the structure members to a string it is much faster.

### Why lua?
Lua is a simple scripting language and in my eyes for simple applications it is a great fit.
I considered using python for this project but I preferred lua for its simplicity and lack of tab nonsense.

### Inspiration for this project
This project is inspired by existing tools similar to protocol buffers.