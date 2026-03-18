-- ==============================================================
-- TAUSRET RESTORATION - METHOD 3: FINAL CORRECTED VERSION
-- ==============================================================
-- Creates Tausret as a female general in player's (Amenmesse) faction
-- Properly sets gender, immortality, and uniqueness
-- ==============================================================
local TAUSRET_SPAWN_CONFIG = {
     faction_key = "phar_main_amenmesse",
     agent_type = "general",
     agent_subtype = "phar_hero_egy_tau_tausret",
     forename = "names_name_862248711",
     family_name = "names_name_89313665",
     spawn_in_region_key = "phar_main_kerma_kerma",
     unit_list = "",
     startpos_id = "phar_main_tausret",
     debug_enabled = true
}

local function log_debug(message) if TAUSRET_SPAWN_CONFIG.debug_enabled then out("TAUSRET_DUPLICATE_FINAL_MOD: " .. tostring(message)) end end

local function Duplicate_and_Spawn_Tausret()
    log_debug("===== TAUSRET DUPLICATE (FINAL) MOD INITIALIZED =====")
    log_debug("Creating Tausret in Amenmesse's faction (player faction)...")

    -- Verify faction exists
    local faction = cm:get_faction(TAUSRET_SPAWN_CONFIG.faction_key)

    if not faction or faction:is_null_interface() then
        log_debug("ERROR: Could not find faction: " .. TAUSRET_SPAWN_CONFIG.faction_key)
        return
    end

    log_debug("Found Amenmesse faction!")

    -- Find valid spawn location in the region
    log_debug("Finding spawn location in region: " .. TAUSRET_SPAWN_CONFIG.spawn_region_key)
    local x, y = cm:find_valid_spawn_location_for_character_from_settlement(TAUSRET_SPAWN_CONFIG.faction_key,
        TAUSRET_SPAWN_CONFIG.spawn_region_key, false, true, 8)

    -- Create the general with full parameter set
    -- This method gives more control over the character creation
    log_debug("Creating force with general...")

    local cqi = cm:create_force_with_general(
        TAUSRET_SPAWN_CONFIG.faction_key,
        TAUSRET_SPAWN_CONFIG.unit_list,
        TAUSRET_SPAWN_CONFIG.spawn_in_region_key,
        ---@diagnostic disable-next-line: param-type-mismatch
        x, -- X coordinate (number)
        ---@diagnostic disable-next-line: param-type-mismatch
        y, -- Y coordinate (number)
        TAUSRET_SPAWN_CONFIG.agent_type,
        TAUSRET_SPAWN_CONFIG.agent_subtype,
        TAUSRET_SPAWN_CONFIG.forename,
        "",
        TAUSRET_SPAWN_CONFIG.family_name,
        "",
        false, -- Set false if she has been confederated, or true if she is still in her own faction.
        function(cqi)
            if not cqi or cqi < 0 then
                log_debug("ERROR: Failed to create general (cqi invalid)")
                return
            end
            log_debug("Successfully created general! CQI: " .. cqi)
		  
            -- Get the character and set properties
            local character = cm:get_character_by_cqi(cqi)

            if character and not character:is_null_interface() then
                log_debug("Got character reference")
                local char_str = cm:char_lookup_str(character)
                -- Set unique status
                cm:set_character_unique(char_str, true)
                cm:force_add_trait(char_str, "trait_mighty_warrior", true)
                cm:force_add_trait(char_str, "trait_commander", true)
                log_debug("Set unique: true")
                log_debug("===== TAUSRET SUCCESSFULLY CREATED AND CONFIGURED =====")
                log_debug("She should now appear in your armies as a recruitable general")
            else
                log_debug("WARNING: Could not get character reference, but general was created")
                log_debug("CQI: " .. cqi .. " should still work")
            end
        end,
        false)
end
cm:add_first_tick_callback(function()
	Duplicate_and_Spawn_Tausret()
 end)
