--!blank {[b64SSH], [SSHKEY]}
local this = script.Parent.Parent
local events = require(this:WaitForChild("events"))
local api = events.GuildPermission.api
local system = events.Console.api
local b64 = events.libraries.b1664
local storages = script.Parent.Parent:WaitForChild("storages")
local storage = storages:WaitForChild("storage")
local GuildPermissionDatas = require(storage:WaitForChild("GuildPermissions"))
useAPI = false 
if game:GetService("ServerScriptService"):WaitForChild("CreateAPI") then
	useAPI = true
	Core = require(game:GetService("ServerScriptService"):WaitForChild("CreateAPI"))
	GuildPermissionAPI = Core.GuildPermission
	GuildPermissionUpdateEvent = GuildPermissionAPI.GuildPermissionUpdated
	GuildCreateEvent = GuildPermissionAPI.GuildAdded
	GuildRemoveEvent = GuildPermissionAPI.GuildRemoved
	PermissionCreateEvent = GuildPermissionAPI.PermissionAdded
end

export type PluginIDP = {id:string, Password:string}
function register(id:PluginIDP)
	local GPR = GuildPermissionDatas:readData(SSHKey)

	if GPR == "NOPERMISSION" then
		local DETAILED = {
			"The Key was incorrect or RAM Storages were not working properly;", 
			"Possible Solution: Restart the server or Clear RAM Storage Cache;",
			"If this problem still exists, please file a issue at CREATE Github.", 
			"",
			"Requested from: register (function)",
		}

		system:Invoke("OUTPUT","create/server/GuildPermissions", "core.server.services", "Failed to Read Data from RAM Storage", 2, DETAILED)
		return "READFAILED"
	end

	if not GPR[tostring(id.id)] then
		local GPW = GuildPermissionDatas:writeData(tostring(id.id), {["Password"] = tostring(b64:Invoke("ENCODE", tostring(id.Password), b64SSH))}, SSHKey)
		if GPW == "SUCCESS" then
			if useAPI == true then GuildCreateEvent:Fire(id.id) end
			return "SUCCESS"
		else
			local DETAILED = {
				"Condition: "..tostring(GPW),
				"Target: "..tostring(id.id),
				"Data: {[Password] = id.Password}"
			}

			system:Invoke("OUTPUT","create/server/GuildPermissions", "core.server.services", "Failed to write Data to RAM Storage", 2, DETAILED)
			return "WRITEFAILED"
		end
	else
		local DETAILED = {
			"This ID already exists or was already registered by a plugin.", 
			"If this problem still exists, please restart your server.", 
		}

		system:Invoke("OUTPUT", "create/server/GuildPermissions", "core.server.services", "Error occured while attempting to register a new GPID named <"..tostring(id.id)..">", 2, DETAILED)
		return "ALREADY-EXIST"
	end
end



function deregister(id:PluginIDP)
	local GPR = GuildPermissionDatas:readData(SSHKey)

	if GPR == "NOPERMISSION" then
		local DETAILED = {
			"The Key was incorrect or RAM Storages were not working properly;", 
			"Possible Solution: Restart the server or Clear RAM Storage Cache;",
			"If this problem still exists, please file a issue at CREATE Github.", 
			"",
			"Requested from: deregister (function)",
		}

		system:Invoke("OUTPUT","create/server/GuildPermissions", "core.server.services", "Failed to Read Data from RAM Storage", 2, DETAILED)
		return "READFAILED"
	end

	if GPR[tostring(id.id)] then
		local ID = GPR[tostring(id.id)]
		local givenPassword = id.Password
		local DecodedPassword = b64:Invoke("DECODE", ID["Password"], b64SSH)

		if tostring(givenPassword) == tostring(DecodedPassword) then
			local GPD = GuildPermissionDatas:deleteData(tostring(id.id), SSHKey)

			if GPD == "SUCCESS" then
				if useAPI == true then GuildRemoveEvent:Fire(id.id) end
				return "SUCCESS"
			end
		else
			local DETAILED = {
				"Invalid GPID.Password given", 
			}

			system:Invoke("OUTPUT", "create/server/GuildPermissions", "core.server.services", "Error occured while attempting to deregister a GPID named <"..tostring(id.id)..">", 2, DETAILED)
			return "INVALID-PASSWORD"
		end
	else
		local DETAILED = {
			"This GPID doesn't exist or haven't been registered by any plugins.", 
		}

		system:Invoke("OUTPUT", "create/server/GuildPermissions", "core.server.services", "Error occured while attempting to deregister a GPID named <"..tostring(id.id)..">", 2, DETAILED)
		return "INVALID-GPID"
	end
end



local export type Teams = "Teams:*" | "Teams:Create" | "Teams:Remove" | "Teams:Modify" | "Teams:MovePlayers" | "Teams:Void" | "Teams:SetNeutral"
local export type Server = "Server:ForceStop" | "Server:CreateBackup" | "Server:DeleteBackup"
local export type pluginPermissionType = Teams | Server
function requires(id:PluginIDP, pluginPermissionType:pluginPermissionType)
	local GPR = GuildPermissionDatas:readData(SSHKey)

	if GPR == "NOPERMISSION" then
		local DETAILED = {
			"The Key was incorrect or RAM Storages were not working properly;", 
			"Possible Solution: Restart the server or Clear RAM Storage Cache;",
			"If this problem still exists, please file a issue at CREATE Github.", 
			"",
			"Requested from: requires (function)",
		}

		system:Invoke("OUTPUT","create/server/GuildPermissions", "core.server.services", "Failed to Read Data from RAM Storage", 2, DETAILED)
		return "READFAILED"
	end

	if GPR[tostring(id.id)] then
		local ID = GPR[tostring(id.id)]
		local givenPassword = id.Password
		local DecodedPassword = b64:Invoke("DECODE", ID["Password"], b64SSH)

		if tostring(givenPassword) == tostring(DecodedPassword) then
			local AllRequiredPermissions = {}
			AllRequiredPermissions = ID["Permissions"]
			AllRequiredPermissions[tostring(pluginPermissionType)] = false
			
			GuildPermissionDatas:deleteData(tostring(id.id), SSHKey)
			local GPW = GuildPermissionDatas:writeData(tostring(id.id), {["Password"] = tostring(b64:Invoke("ENCODE", tostring(id.Password), b64SSH)), ["Permissions"] = AllRequiredPermissions}, SSHKey)

			if GPW == "SUCCESS" then
				if useAPI == true then PermissionCreateEvent:Fire(id.id, pluginPermissionType) end
				return "SUCCESS"
			else
				local DETAILED = {
					"The Key was incorrect or Tables were invalid required by RAMStorage.setupTables;",
					"Condition: "..tostring(GPW),
					"Target: "..tostring(id.id), 
					"Data: {[Password] = id.Password, [Permissions] = GPID.Permissions.all + ["..tostring(pluginPermissionType).."] = false}"
				}

				system:Invoke("OUTPUT","create/server/GuildPermissions", "core.server.services", "Failed to write Data to RAM Storage", 2, DETAILED)
				return "WRITEFAILED"
			end
		else
			local DETAILED = {
				"Invalid GPID.Password given", 
			}

			system:Invoke("OUTPUT", "create/server/GuildPermissions", "core.server.services", "Error occured while attempting to deregister a GPID named <"..tostring(id.id)..">", 2, DETAILED)
			return "INVALID-PASSWORD"
		end
	else
		local DETAILED = {
			"This GPID doesn't exist or haven't been registered by any plugins.", 
		}

		system:Invoke("OUTPUT", "create/server/GuildPermissions", "core.server.services", "Error occured while attempting to deregister a GPID named <"..tostring(id.id)..">", 2, DETAILED)
		return "INVALID-GPID"
	end
end



function hasGPIDhadPPT(id:string, pluginPermissionType:pluginPermissionType)
	local GPR = GuildPermissionDatas:readData(SSHKey)

	if GPR == "NOPERMISSION" then
		local DETAILED = {
			"The Key was incorrect or RAM Storages were not working properly;", 
			"Possible Solution: Restart the server or Clear RAM Storage Cache;",
			"If this problem still exists, please file a issue at CREATE Github.",
			"",
			"Requested from: hasGPIDhadPPT (function)",
		}

		system:Invoke("OUTPUT","create/server/GuildPermissions", "core.server.services", "Failed to Read Data from RAM Storage", 2, DETAILED)
		return "READFAILED"
	end

	if GPR[tostring(id)] then
		local ID = GPR[tostring(id)]

		if ID[tostring(pluginPermissionType)] then
			return ID[tostring(pluginPermissionType)] --boolean
		else
			return "NOT-REQUIRED"
		end
	else
		return "NOT-REGISTERED"
	end
end

api.OnInvoke = function (t, d1, d2, d3, d4, d5)
	if t == "REGISTER" then
		return register(d1)
	elseif t == "DEREGISTER" then
		return deregister(d1)
	elseif t == "REQUIRE" then
		return requires(d1, d2)
	elseif t == "HAS" then
		return hasGPIDhadPPT(d1, d2)
	else
		return nil
	end
end
