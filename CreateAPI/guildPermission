local guildPermission = {}
export type pluginPermissionType = "Teams:*" | "Teams:Create" | "Teams:Remove" | "Teams:Modify" | "Teams:movePlayers" | "Teams:Void" | "Teams:setNeutral"
export type PluginIDP = {id:string, Password:string}

guildPermission.Guilds = {}
gPD = guildPermission.Guilds

tempWorldLocation = "0.0.0.0"
local DS = game:GetService("DataStoreService")
local DB = DS:GetDataStore(tostring(tempWorldLocation))
local HTTPSS = game:GetService("HttpService")

local b64 = require(script.Parent:WaitForChild("libraries"):WaitForChild("baseUNI16-64.luau"))

function Save()
	print("Saving guildPermissions to World <"..tostring(tempWorldLocation).."> Database.")
	local success, catchError = pcall(function()
		DB:SetAsync("PluginPermissions", HTTPSS:JSONEncode(gPD))
	end)
	if success then
		print("Successfully Saved guildPermissions to World <"..tostring(tempWorldLocation).."> Database.")
	else
		error(tostring(catchError.." // E400"))
	end
end

guildPermission.Status = "IDLE"

function guildPermission:Load() --Load
	print("Loading guildPermissions from World <"..tostring(tempWorldLocation).."> Database.")
	
	local success, catchError = pcall(function()
		local Get = DB:GetAsync("PluginPermissions")
		gPD = HTTPSS:JSONDecode(Get)
	end)
	if success then
		print("Successfully loaded guildPermissions from World <"..tostring(tempWorldLocation).."> Database.")
		guildPermission.Status = "READY"
	else
		guildPermission.Status = "E400+3"
		error(tostring(catchError.." // E400+3 // Guild Permission // Load"))
	end
end



function guildPermission:deregister(id:PluginIDP)
	if gPD[tostring(id.id)] then
		local ID = gPD[tostring(id.id)]
		local givenPassword = id.Password
		local DecodedPassword = b64.decode(ID["Password"])
		
		if tostring(givenPassword) == tostring(DecodedPassword) then
			gPD[tostring(id.id)] = nil
			warn("Successfully deregistered a ID named <"..tostring(id.id)..">.")
			Save()
		else
			error([[Error occured while attempting to deregister <]]..tostring(id.id)..[[>;
		Invalid Password
		
		E10 // Guild Permission // Deregister]])
			return "E10"
		end
	else
		error([[Error occured while attempting to deregister <]]..tostring(id.id)..[[>;
		does that ID exist or is that registered by a plugin?
		
		E01 // Guild Permission // Deregister]])
	end
end

function guildPermission:register(id:PluginIDP)
	if not gPD[tostring(id.id)] then
		gPD[tostring(id.id)] = {["Password"] = tostring(b64.encode(tostring(id.Password)))}
	else
		error([[Error occured while attempting to register a new ID named <]]..tostring(id.id)..[[>;
		This ID already exists or was registered by a plugin.
		
		E111 // Guild Permission // Register]])
		return "E111"
	end
	wait()
	if gPD[tostring(id)] then
		print("Successfully registered an ID named <"..tostring(id)..">.")
		Save()
	else
		error([[Error occured while attempting to register a new ID named <]]..tostring(id)..[[>;
		Attempts to insert a tables has failed due to Roblox issues.
		
		E399 // Guild Permission // Register]])
		return("E399")
	end
end



function guildPermission:require(id:PluginIDP, pluginPermissionType:pluginPermissionType)
	if gPD[tostring(id.id)] then
		local ID = gPD[tostring(id.id)]
		local givenPassword = id.Password
		local DecodedPassword = b64.decode(ID["Password"])
		
		if tostring(givenPassword) == tostring(DecodedPassword) then
			ID[tostring(pluginPermissionType)] = false

			if ID[tostring(pluginPermissionType)] then
				print("Successfully required an Permission <"..tostring(pluginPermissionType).."> to <"..tostring(id.id)..">.")
				Save()
			else
				error([[Error occured while attempting to require an permission <]]..tostring(pluginPermissionType).."> to <"..tostring(id.id)..[[>;
		Attempts to insert a tables has failed due to Roblox issues.
		
		E399 // Guild Permission // Require]])
				return "E399"
			end
		else
			error([[Error occured while attempting to require an permission <]]..tostring(pluginPermissionType).."> to <"..tostring(id.id)..[[>;
		Invalid Password
		
		E10 // Guild Permission // Require]])
			return "E10"
		end
	else
		error([[Error occured while attempting to require <]]..tostring(pluginPermissionType).."> to <"..tostring(id.id)..[[>;
		does that ID exist or is that registered by a plugin?
		
		E01 // Guild Permission // Require]])
		return "E01"
	end
end

function guildPermission.has(id:string, pluginPermissionType:pluginPermissionType)
	if gPD[tostring(id)] then
		local ID = gPD[tostring(id)]
		
		if ID[tostring(pluginPermissionType)] then
			return ID[tostring(pluginPermissionType)]
		else
			return "Not Required"
		end
	else
		return "Not Registered"
	end
end



function guildPermission:check(id:string, Password:string)
	if gPD[tostring(id)] then
		local ID = gPD[tostring(id)]
		local DecodedPassword = b64.decode(ID["Password"])
		if tostring(Password) == tostring(DecodedPassword) then
			return true
		else
			return false
		end
	else
		return "E01"
	end
end



function guildPermission:modify(id:string, pluginPermissionType:pluginPermissionType, access:boolean)
	if gPD[tostring(id)] then
		local ID = gPD[tostring(id)]
		if ID[tostring(pluginPermissionType)] then
			ID[tostring(pluginPermissionType)] = access
			wait()
			if ID[tostring(pluginPermissionType)] == access then
				print("Successfully modified <"..tostring(id).."/"..tostring(pluginPermissionType).."> to <"..tostring(access)..">.")
				Save()
				
				script:WaitForChild("GuildPermssionUpdate"):Fire(tostring(id), tostring(pluginPermissionType), access)
			else
				error([[Error occured while attempting to modifiy <]]..tostring(id).."/"..tostring(pluginPermissionType).."> to <"..tostring(access)..[[>;
		Attempts to insert a tables has failed due to Roblox issues.
		
		E399 // Guild Permission // Modify]])
				return "E399"
			end
		else
			error([[Error occured while attempting to modifiy <]]..tostring(id).."/"..tostring(pluginPermissionType)..[[>;
		Is that permission required by a plugin?
		
		E02 // Guild Permission // Modify]])
			return "E02"
		end
	else
		error([[Error occured while attempting to modifiy <]]..tostring(id)..[[>;
		does that ID exist or is that registered by a plugin?
		
		E01 // Guild Permission // Modify]])
		return "E01"
	end
end

return guildPermission
