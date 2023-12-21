local guildPermission = {}
local export type Teams = "Teams:*" | "Teams:Create" | "Teams:Remove" | "Teams:Modify" | "Teams:MovePlayers" | "Teams:Void" | "Teams:SetNeutral"
local export type Server = "Server:ForceStop" | "Server:CreateBackup" | "Server:DeleteBackup"
export type pluginPermissionType = Teams | Server
export type PluginIDP = {id:string, Password:string}
function guildPermission.newID(id:PluginIDP) return id end
local ServerSoftware = game:GetService("ServerScriptService"):WaitForChild("CreateServer")
local ServerEvents = require(ServerSoftware:WaitForChild("events"))
local SERVERGP = ServerEvents.GuildPermission.api
function guildPermission.register(id:PluginIDP) return SERVERGP:Invoke("REGISTER", id) end
function guildPermission.deregister(id:PluginIDP) return SERVERGP:Invoke("DEREGISTER", id) end
function guildPermission.require(id:PluginIDP, pluginPermissionType:pluginPermissionType) return SERVERGP:Invoke("REQUIRE", id, pluginPermissionType) end
function guildPermission.has(id:string, pluginPermissionType:pluginPermissionType) return SERVERGP:Invoke("HAS", id, pluginPermissionType) end
guildPermission.GuildAdded = script:WaitForChild("GuildAdded")
guildPermission.GuildRemoved = script:WaitForChild("GuildRemoved")
guildPermission.GuildPermissionUpdated = script:WaitForChild("GuildPermssionUpdated")
guildPermission.PermissionAdded = script:WaitForChild("PermissionAdded")
return guildPermission
