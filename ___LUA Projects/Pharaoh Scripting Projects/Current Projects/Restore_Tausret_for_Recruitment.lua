-- Script to restore Tausret to the player's recruitment pool
local function restore_tausret()
    local faction_key = "phar_main_amenmesse" -- Replace with actual faction key
    local agent_subtype = "phar_hero_egy_tau_tausret"     -- Replace with actual agent subtype
    local forename = "names_name_862248711"     -- Replace with Tausret's forename key
    local surname = "names_name_89313665"      -- Replace with Tausret's surname key
    local region_key = "phar_main_kerma_kerma"             -- Replace with a valid region key you own

    -- Find a valid spawn location near the region
    local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 8)

    -- Create Tausret as a general with a basic army (replace unit list as desired)
    cm:create_force_with_general(
        faction_key,
        "egyptian_spearmen,egyptian_archers", -- Example unit list
        region_key,
        x,
        y,
        "general",
        agent_subtype,
        forename,
        "",
        surname,
        "",
        true, -- Make her faction leader if desired
        function(cqi)
            local char_str = cm:char_lookup_str(cqi)
            -- Set immortality and uniqueness
            --1cm:set_character_immortality(char_str, true)
            cm:set_character_unique(char_str, true)
            -- Add traits or items as needed
            -- cm:force_add_trait(char_str, "trait_key", true)
        end
    )
end

cm:add_first_tick_callback(function()
    restore_tausret()
end)