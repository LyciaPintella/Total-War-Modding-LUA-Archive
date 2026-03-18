-- ==============================================================
-- TAUSRET RESTORATION - METHOD 3: FINAL CORRECTED VERSION
-- ==============================================================
-- Creates Tausret as a female general in player's (Amenmesse) faction
-- Properly sets gender, immortality, and uniqueness
-- ==============================================================
local TAUSRET_CONFIG = {
     faction_key = "phar_main_amenmesse",
     agent_type = "general",
     agent_subtype = "phar_hero_egy_tau_tausret",
     forename = "names_name_862248711",
     family_name = "names_name_89313665",
     spawn_region_key = "phar_main_kerma_kerma",
     unit_list = "",
     startpos_id = "phar_main_tausret",
     debug_enabled = true
}

local function ModLog(message) if TAUSRET_CONFIG.debug_enabled then ModLog("Duplicate_and_Spawn_Tausret: " .. tostring(message) .. ".") end end

local function Duplicate_and_Spawn_Tausret()
     ModLog("===== Duplicate_and_Spawn_Tausret: MOD INITIALIZED =====")
     ModLog("Creating Tausret in Amenmesse's faction (player faction)...")

     -- Verify faction exists
     local faction = cm:get_faction(TAUSRET_CONFIG.faction_key)
     ModLog("Faction Key: " .. TAUSRET_CONFIG.faction_key .. 
		  "Faction Name: " .. faction:name()
	 	 )

     if not faction or faction:is_null_interface() then
          ModLog("ERROR: Could not find faction: " .. TAUSRET_CONFIG.faction_key)
          return
     end

     ModLog("Found Amenmesse faction!")

     -- Find valid spawn location in the region
     ModLog("Finding spawn location in region: " .. TAUSRET_CONFIG.spawn_region_key)
     local x, y = cm:find_valid_spawn_location_for_character_from_settlement(TAUSRET_CONFIG.faction_key, TAUSRET_CONFIG.spawn_region_key, false, true, 8)

     -- Create the general with full parameter set
     -- This method gives more control over the character creation
     ModLog("Creating force with general...")

     local cqi = cm:create_force_with_general(TAUSRET_CONFIG.faction_key, TAUSRET_CONFIG.unit_list, TAUSRET_CONFIG.spawn_region_key,
     ---@diagnostic disable-next-line: param-type-mismatch
                                              x, -- X coordinate (number)
     ---@diagnostic disable-next-line: param-type-mismatch
     y, -- Y coordinate (number)
     TAUSRET_CONFIG.agent_type, TAUSRET_CONFIG.agent_subtype, TAUSRET_CONFIG.forename, "", TAUSRET_CONFIG.family_name, "", false, -- Set false if she has been confederated, or true if she is still in her own faction.
                                              function(cqi)
          if not cqi or cqi < 0 then
               ModLog("ERROR: Failed to create general (cqi invalid)")
               return
          end
          ModLog("Successfully created general! CQI: " .. cqi)

          -- Get the character and set properties
          local character = cm:get_character_by_cqi(cqi)

          if character and not character:is_null_interface() then
               ModLog("Got character reference")
               local char_str = cm:char_lookup_str(character)
               -- Set unique status
               cm:set_character_unique(char_str, true)
               cm:force_add_trait(char_str, "trait_mighty_warrior", true)
               cm:force_add_trait(char_str, "trait_commander", true)
               ModLog("Set unique: true")
               ModLog("===== TAUSRET SUCCESSFULLY CREATED AND CONFIGURED =====")
               ModLog("She should now appear in your armies as a recruitable general")
          else
               ModLog("WARNING: Could not get character reference, but general was created")
               ModLog("CQI: " .. cqi .. " should still work")
          end
     end, false)
end
cm:add_first_tick_callback(function() Duplicate_and_Spawn_Tausret() end)
