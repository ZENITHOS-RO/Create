local System = {}
System.VERSION = "1.0"
local ServerSoftware = game:GetService("ServerScriptService"):WaitForChild("CreateServer")
local ServerEvents = require(ServerSoftware:WaitForChild("events"))
local ConsoleAPI = ServerEvents.Console.api
function System.output(author:string, from:string, message:string, level:number|nil, detailedINFO:{string}|nil) ConsoleAPI:Invoke("OUTPUT", author, from, message, level, detailedINFO) end
function System.LatestOutput() return ConsoleAPI:Invoke("GETLATESTMESSAGE") end
System.OutputCreated = script:WaitForChild("OutputCreated")
return System
