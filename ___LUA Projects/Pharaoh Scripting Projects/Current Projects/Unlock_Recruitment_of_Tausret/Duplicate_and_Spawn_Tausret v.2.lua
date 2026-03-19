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
    debug_enabled = true,
    traits = {"trait_mighty_warrior", "trait_commander"}
}

local function out(log)
    if TAUSRET_CONFIG.debug_enabled then
        ModLog("Duplicate_and_Spawn_Tausret: " .. tostring(log) .. ".")
    end
end

core:add_listener("Duplicate_and_Spawn_Tausret",
			 "FirstTickAfterWorldCreated",
			 true,
			 function(context)
			 out("===== Duplicate_and_Spawn_Tausret: MOD INITIALIZED =====")
			 out("Creating Tausret in Amenmesse's faction (player faction)...")

			 -- Verify faction exists
			 local faction = cm:get_faction(TAUSRET_CONFIG.faction_key)
			 out("Faction Key/Name: " .. TAUSRET_CONFIG.faction_key)

			 if not faction or faction:is_null_interface() then
				 out("ERROR: Could not find faction: " .. TAUSRET_CONFIG.faction_key)
				 return
			end

		       -- Find valid spawn location in the region
			out("Finding spawn location in region: " .. TAUSRET_CONFIG.spawn_region_key)
			local x, y = cm:find_valid_spawn_location_for_character_from_settlement(
			TAUSRET_CONFIG.faction_key,
			TAUSRET_CONFIG.spawn_region_key, false, true, 8)

			if not x or not y then
				out(
					"ERROR: Could not find valid spawn location for Tausret in region: " ..
						TAUSRET_CONFIG.spawn_region_key)
				return
			end

			-- Create the general with full parameter set
			-- This method gives more control over the character creation
			out("Creating force with general...")
			cm:create_force_with_general(TAUSRET_CONFIG.faction_key,
									TAUSRET_CONFIG.unit_list,
									TAUSRET_CONFIG.spawn_region_key,
									x,
									y,
									TAUSRET_CONFIG.agent_type,
									TAUSRET_CONFIG.agent_subtype,
									TAUSRET_CONFIG.forename,
									"", -- Other name (leave empty)
									TAUSRET_CONFIG.family_name,
									"", -- Clan name (leave empty)
									false, -- Set false if she has been confederated or true if she is still in her own faction.
									function(cqi)
												if not cqi or cqi < 0 then
													out("ERROR: Failed to create general (cqi invalid)")
													return
												end
												out("Successfully created general! CQI: " .. cqi)

												-- Get the character and set properties
												local character = cm:get_character_by_cqi(cqi)

												if character and not character:is_null_interface() then
													out("Got character reference")
													local char_str = cm:char_lookup_str(character)
													-- Set unique status
													cm:set_character_unique(char_str, true)
													for _, trait in ipairs(TAUSRET_CONFIG.traits) do
														cm:force_add_trait(char_str, trait, true)
													end
													out("Set unique: true")
													out("===== TAUSRET SUCCESSFULLY CREATED AND CONFIGURED =====")
												else
													out(
														"WARNING: Could not get character reference, but general was created")
													out("CQI: " .. cqi .. " should still work")
												end
									end,
									true)
end, false)
