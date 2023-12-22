--!blankencrypted

local debugEnabled = true
local this = script.Parent.Parent
local events = require(this:WaitForChild("events"))
local ClientOutput = events.Console.output
local api = events.Console.api
useAPI = false
if game:GetService("ServerScriptService"):WaitForChild("CreateAPI") then
	useAPI = true
	Core = require(game:GetService("ServerScriptService"):WaitForChild("CreateAPI"))
	OS = Core.System
	OutputCreateEvent = OS.OutputCreated
end

local TS = game:GetService("TestService")
LatestMessage = {"00:00:00", "noAuthor", "unknownFromer", "nil", 0}
function output(author:string, from:string, message:string, level:number|nil, detailed:{string}|nil)
	local timeStamp = tostring(os.date("%X"))
	ClientOutput:FireAllClients("["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message), level, detailed)
	LatestMessage = {timeStamp, author, from, message, level, detailed}
	if useAPI then OutputCreateEvent:Fire(timeStamp, author, from, message, level, detailed) end
	if debugEnabled then
		if level == 0 then
			if detailed then
				print("[INFO] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
				for COUNT, Each in pairs(detailed) do
					print("   - "..Each)
				end
			else
				print("[INFO] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
			end
		elseif level == 1 then
			if detailed then
				warn("[WARN] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
				
				for COUNT, Each in pairs(detailed) do
					warn("   - "..Each)
				end
			else
				warn("[WARN] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
			end
		elseif level == 2 then
			if detailed then
				TS:Error("[ERROR] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
				
				for COUNT, Each in pairs(detailed) do
					TS:Error("   - "..Each)
				end
			else
				TS:Error("[ERROR] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
			end
		elseif level == 3 then
			if detailed then
				TS:Error("[FATAL] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
				
				for COUNT, Each in pairs(detailed) do
					error("   - "..Each, 0)
				end
			else
				TS:Error("[FATAL] ".."["..timeStamp.."] ["..tostring(author).."] ["..tostring(from).."]: "..tostring(message))
			end
		end
	end
end

function Test(author:string, from:string, message:string, level:number|nil)
	local timeStamp = tostring(os.date("%X"))
	local Message, leveld = "["..timeStamp.."] ["..tostring(author).."] ["..tostring(from)..": "..tostring(message), level

	if Message == "["..timeStamp.."] ["..tostring(author).."] ["..tostring(from)..": "..tostring(message) then
		if leveld == level then
			return "PASS"
		else
			return "FAILED"
		end
	end
end

api.OnInvoke = function (t, d1, d2, d3, d4, d5)
	if t == "OUTPUT" then
		output(d1, d2, d3, d4, d5)
		return nil
	elseif t == "GETLATESTMESSAGE" then
		return LatestMessage
	elseif t == "TESTUSAGE" then
		if d5 ~= ENCRYPTED then return end
		return Test(d1, d2, d3, d4)
	else
		local DETAILED = {
			"At BindableEvent arugment input #1, got <"..tostring(t)..">;",
			"<"..tostring(t).."> is not a valid event from OutputService;"
		}
		output("create/server/Output", "core.server.services", "No such as <"..tostring(t).."> type found while attempting to parse OutputService available events;", 2, DETAILED)
		return nil
	end
end
