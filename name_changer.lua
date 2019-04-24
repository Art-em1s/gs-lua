math.randomseed(client.timestamp())
local bool_enabled = false
local bool_first = true
local client_userid_to_entindex = client.userid_to_entindex
local entity_get_player_name = entity.get_player_name
local entity_get_local_player = entity.get_local_player
local ui_set = ui.set
local ui_ref = ui.reference
local steal_name = ui_ref("MISC", "Miscellaneous", "Steal player name")

local ui_button = ui.new_button("Lua", "B", "Steal Teammates Name", function()
    bool_enabled = true
    client.log("Name Stealer Enabled - (Other)")
    cvar.name:invoke_callback(0)
    cvar.name:set_string("\n\xAD\xAD\xAD")
end)

local ui_button = ui.new_button("Lua", "B", "Disable Name Stealer", function()
    bool_enabled = false
    client.log("Name Stealer Disabled")
end)

local function on_round_start(e)
    if bool_enabled then
        cvar.name:invoke_callback(0)
        cvar.name:set_string("\n\xAD\xAD\xAD")
    end
end

local function on_player_death(e)
	local attacker_entindex = client_userid_to_entindex(e.attacker)
    if attacker_entindex == entity_get_local_player() and bool_enabled then
        ui_set(steal_name, true)
    end
end

client.set_event_callback("player_death", on_player_death)
client.set_event_callback("round_start", on_round_start)
client.set_event_callback("cs_win_panel_match", on_game_end)