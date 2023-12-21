local guildPermission = {}
local export type Teams = "Teams:*" | "Teams:Create" | "Teams:Remove" | "Teams:Modify" | "Teams:MovePlayers" | "Teams:Void" | "Teams:SetNeutral"
local export type Server = "Server:ForceStop" | "Server:CreateBackup" | "Server:DeleteBackup"
export type pluginPermissionType = Teams | Server
export type PluginIDP = {id:string, Password:string}
function guildPermission.newID(id:PluginIDP) return id end
local ServerSoftware = game:GetService("ServerScriptService"):WaitForChild("CreateServer")
local ServerEvents = require(ServerSoftware:WaitForChild("events"))
local SERVERGP = ServerEvents.GuildPermission.api
function guildPermission.register(id:PluginIDP) local Attempt = SERVERGP:Invoke("REGISTER", id) return Attempt end
function guildPermission.deregister(id:PluginIDP) local Attempt = SERVERGP:Invoke("DEREGISTER", id) return Attempt end
function guildPermission.require(id:PluginIDP, pluginPermissionType:pluginPermissionType) local Attempt = SERVERGP:Invoke("REQUIRE", id, pluginPermissionType) return Attempt end
function guildPermission.has(id:string, pluginPermissionType:pluginPermissionType) local Attempt = SERVERGP:Invoke("HAS", id, pluginPermissionType) return Attempt end
guildPermission.GuildAdded = script:WaitForChild("GuildAdded")
guildPermission.GuildRemoved = script:WaitForChild("GuildRemoved")
guildPermission.GuildPermissionUpdated = script:WaitForChild("GuildPermssionUpdated")
guildPermission.PermissionAdded = script:WaitForChild("PermissionAdded")
guildPermission.PermissionRemoved = script:WaitForChild("PermissionRemoved")
return guildPermission
