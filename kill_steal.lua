local bool_enabled = false
local bool_first = true
local client_userid_to_entindex = client.userid_to_entindex
local entity_get_player_name = entity.get_player_name
local entity_get_local_player = entity.get_local_player

local function sanitize_string(string)
    return string:gsub("%W", "")
end

local ui_button = ui.new_button("Lua", "B", "Enable Name Stealer (Comp/Cas)", function() --waits until round start to enable in order to prevent it breaking comp gamemodes
    bool_enabled = true
    client.log("Name Stealer Enabled - Comp/Casual")
end)

local ui_button = ui.new_button("Lua", "B", "Enable Name Stealer (Other)", function()
    bool_enabled = true
    client.log("Name Stealer Enabled - (Other)")
    cvar.name:invoke_callback(0)
    cvar.name:set_string("\n\xAD\xAD\xAD")
    bool_first = false
end)

local ui_button = ui.new_button("Lua", "B", "Disable Name Stealer", function()
    bool_enabled = false
    client.log("Name Stealer Disabled")
end)

local function on_round_start()
    if bool_enabled and bool_first then
        cvar.name:invoke_callback(0)
        cvar.name:set_string("\n\xAD\xAD\xAD")
        bool_first = false
    end
end

local function on_player_death(e)
	local victim_entindex = client_userid_to_entindex(e.userid)
	local attacker_entindex = client_userid_to_entindex(e.attacker)
    if attacker_entindex == entity_get_local_player() and bool_enabled then
        local victim_name = entity_get_player_name(victim_entindex)
        victim_name = sanitize_string(victim_name)
        client.log("Killed "..victim_name.." stealing their name")
        cvar.name:set_string(victim_name.." ")
    end
end

local function on_game_end() --sets to first run when the game ends so the name is reset on the first round again to prevent script from hitting limits
    bool_first = true
end

client.set_event_callback("player_death", on_player_death)
client.set_event_callback("round_start", on_round_start)
client.set_event_callback("cs_win_panel_match", on_game_end)