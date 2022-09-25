AgeMsg = require("Example.ExampleMessages.AgeMsg")
AgeAndColorMsg = require("Example.ExampleMessages.AgeAndColorMsg")

return {
    [AgeMsg.msgName] = AgeMsg,
    [AgeAndColorMsg.msgName] = AgeAndColorMsg
}