local Base = require("Example.ExampleMessages.AgeMsg")

return {
    msgName = "AgeAndColorMsg",
    isConcrete = true,
    baseMsg = Base,
    fields = {
        {fieldName = "color", dataType = "string"},
        {fieldName = "rgb", dataType = "uint8_t", array = true},
    }
}