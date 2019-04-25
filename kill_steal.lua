local bool_enabled_ks = false
local client_userid_to_entindex = client.userid_to_entindex
local entity_get_player_name = entity.get_player_name
local entity_get_local_player = entity.get_local_player

local function sanitize_string(string)
    return string:gsub("%W", "")
end

local ui_button = ui.new_button("Lua", "B", "Enable Victim Name Stealer", function()
    bool_enabled_ks = true
    client.log("Name Stealer Enabled - (Other)")
    cvar.name:invoke_callback(0)
    cvar.name:set_string("\n\xAD\xAD\xAD")
end)

local ui_button = ui.new_button("Lua", "B", "Disable Name Stealer", function()
    bool_enabled_ks = false
    client.log("Name Stealer Disabled")
end)

local function on_round_start(e)
    if bool_enabled_ks then
        cvar.name:invoke_callback(0)
        cvar.name:set_string("\n\xAD\xAD\xAD")
    end
end

local function on_player_death(e)
	local victim_entindex = client_userid_to_entindex(e.userid)
	local attacker_entindex = client_userid_to_entindex(e.attacker)
    if attacker_entindex == entity_get_local_player() and bool_enabled_ks then
        local victim_name = entity_get_player_name(victim_entindex)
        local own_name = entity_get_player_name(attacker_entindex)
        if own_name ~= "?empty" then
            client.log("Setting name to empty to allow for infinite changes")
            cvar.name:invoke_callback(0)
            cvar.name:set_string("\n\xAD\xAD\xAD")
        end
        victim_name = sanitize_string(victim_name)
        client.log("Killed "..victim_name.." stealing their name")
        cvar.name:set_string(victim_name.." ")
    end
end

client.set_event_callback("player_death", on_player_death)
client.set_event_callback("round_start", on_round_start)
client.set_event_callback("cs_win_panel_match", on_game_end)