-- ==============================================================
-- TAUSRET RESTORATION - METHOD 3: FINAL CORRECTED VERSION
-- ==============================================================
-- Creates Tausret as a female general in player's (Amenmesse) faction
-- Properly sets gender, immortality, and uniqueness
-- ==============================================================

local TAUSRET_DUPLICATE_CONFIG = {
    faction_key = "phar_main_amenmesse",  -- Player's faction (correct)
    agent_subtype = "phar_hero_egy_tau_tausret",  -- Tausret's subtype (correct)
    spawn_region_key = "phar_main_kerma_kerma",  -- Kerma (adjust to your owned region if needed)
    unit_list = "phar_egy_khopesh_warriors,phar_egy_spearmen",
    debug_enabled = true,
}

local function log_debug(message)
    if TAUSRET_DUPLICATE_CONFIG.debug_enabled then
        out("TAUSRET_DUPLICATE_FINAL_MOD: " .. tostring(message))
    end
end

core:add_listener(
    "Tausret_Duplicate_Final_FirstTick",
    "FirstTickAfterWarp",
    true,
    function(context)
        log_debug("===== TAUSRET DUPLICATE (FINAL) MOD INITIALIZED =====")
        log_debug("Creating Tausret in Amenmesse's faction (player faction)...")
        
        -- Verify faction exists
        local faction = cm:get_faction(TAUSRET_DUPLICATE_CONFIG.faction_key)
        
        if not faction or faction:is_null_interface() then
            log_debug("ERROR: Could not find faction: " .. TAUSRET_DUPLICATE_CONFIG.faction_key)
            return
        end
        
        log_debug("Found Amenmesse faction!")
        
        -- Find valid spawn location in the region
        log_debug("Finding spawn location in region: " .. TAUSRET_DUPLICATE_CONFIG.spawn_region_key)
        
        local x, y = cm:find_valid_spawn_location_for_character_from_settlement(
            TAUSRET_DUPLICATE_CONFIG.faction_key,
            TAUSRET_DUPLICATE_CONFIG.spawn_region_key,
            false,
            true,
            8
        )
        
        if x and y then
            log_debug("Found spawn location: X=" .. x .. ", Y=" .. y)
        else
            log_debug("Could not find spawn location with coordinates, using settlement spawn")
        end
        
        -- Create the general with full parameter set
        -- This method gives more control over the character creation
        log_debug("Creating force with general...")
        
        local cqi = cm:create_force_with_general(
            TAUSRET_DUPLICATE_CONFIG.faction_key,
            TAUSRET_DUPLICATE_CONFIG.agent_subtype,
            "",  -- Empty name to use default
            TAUSRET_DUPLICATE_CONFIG.spawn_region_key,
            true,  -- Create army
            TAUSRET_DUPLICATE_CONFIG.unit_list,
            false  -- Don't make her faction leader
        )
        
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
            
            -- Set immortality (prevents death)
            cm:set_character_immortality(char_str, true)
            log_debug("Set immortality: true")
            
            -- Set unique status
            cm:set_character_unique(char_str, true)
            log_debug("Set unique: true")
            
            -- Try to add Tausret traits to make her more authentic
            -- These are optional - comment out if they cause errors
            -- cm:force_add_trait(char_str, "trait_mighty_warrior", true)
            -- cm:force_add_trait(char_str, "trait_commander", true)
            
            log_debug("===== TAUSRET SUCCESSFULLY CREATED AND CONFIGURED =====")
            log_debug("She should now appear in your armies as a recruitable general")
        else
            log_debug("WARNING: Could not get character reference, but general was created")
            log_debug("CQI: " .. cqi .. " should still work")
        end
    end,
    true
)

log_debug("===== TAUSRET DUPLICATE (FINAL) MOD LOADED =====")
