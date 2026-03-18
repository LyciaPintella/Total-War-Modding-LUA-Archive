-- ==============================================================
-- TAUSRET RESTORATION - METHOD 2: UNLOCK (FINAL)
-- ==============================================================
-- Unlocks the REAL Tausret to the recruitment pool
-- Using correct faction key: phar_main_amenmesse (player's faction)
-- ==============================================================
local TAUSRET_CONFIG = {
     faction_key = "phar_main_amenmesse", -- Player's faction (Amenmesse)
     startpos_id = "phar_main_tausret", -- Tausret's starting position ID
     agent_subtype = "phar_hero_egy_tau_tausret",
     debug_enabled = true
}

local function ModLog(message) if TAUSRET_CONFIG.debug_enabled then ModLog("Unlock_Recruitment_of_Tausret: " .. tostring(message) .. ".") end end

local function Unlock_Recruitment_of_Tausret()
    ModLog("Unlock_Recruitment_of_Tausret function called")
		
	ModLog("Applying unlock_starting_character_recruitment for Tausret")
     cm:unlock_starting_character_recruitment(TAUSRET_CONFIG.startpos_id, TAUSRET_CONFIG.faction_key)
     ModLog("Applied unlock_starting_character_recruitment for Tausret")

     -- Approach 2: Find and stop convalescence (backup)
     ModLog("Attempt 2: Searching for Tausret in faction and stopping convalescence...")

     local faction = cm:get_faction(TAUSRET_CONFIG.faction_key)

     if faction and not faction:is_null_interface() then
          local character_list = faction:character_list()

          if character_list and not character_list:is_empty() then
               ModLog("Faction has " .. character_list:num_items() .. " characters")

               for i = 0, character_list:num_items() - 1 do
                    local character = character_list:item_at(i)

                    if character and not character:is_null_interface() then
                         local agent_subtype = character:character_subtype_key()
                         local cqi = character:command_queue_index()

                         ModLog("  Found character: subtype=" .. agent_subtype .. ", cqi=" .. cqi)

                         -- Check if this is Tausret
                         if agent_subtype == TAUSRET_CONFIG.agent_subtype then
                              ModLog("  ★ THIS IS TAUSRET! CQI: " .. cqi)

                              -- Stop her convalescence
                              cm:stop_character_convalescing(cqi)
                              ModLog("  ✓ Stopped convalescence for Tausret")

                              -- Make sure she's set as unique
                              local char_str = cm:char_lookup_str(character)
                              cm:set_character_unique(char_str, true)
                              ModLog("  ✓ Set Tausret as unique")
                         end
                    end
               end
          else
               ModLog("WARNING: Faction character list is empty")
          end
     else
          ModLog("ERROR: Could not get faction interface")
     end

     ModLog("===== TAUSRET UNLOCK COMPLETE =====")
     ModLog("If successful, Tausret should now appear in recruitment pool")
end
cm:add_first_tick_callback(function() Unlock_Recruitment_of_Tausret() end)

-- Periodic check every 3 turns (safety net)
core:add_listener("Tausret_Unlock_Final_PeriodicCheck", "FactionTurnStart", function(context)
     local turn = cm:model():turn_number()
     -- Check every 3 turns for player's faction
     return turn % 3 == 0 and context:faction():name() == "Amenmesse"
end, function(context)
     ModLog("Periodic check at turn " .. cm:model():turn_number())

     -- Re-apply unlock as safety net
     cm:unlock_starting_character_recruitment(TAUSRET_CONFIG.startpos_id, TAUSRET_CONFIG.faction_key)

     -- Check for Tausret and stop convalescence if found
     local faction = cm:get_faction(TAUSRET_CONFIG.faction_key)
     if faction and not faction:is_null_interface() then
          local character_list = faction:character_list()
          if character_list and not character_list:is_empty() then
               for i = 0, character_list:num_items() - 1 do
                    local character = character_list:item_at(i)
                    if character and not character:is_null_interface() then
                         if character:character_subtype_key() == TAUSRET_CONFIG.agent_subtype then
                              cm:stop_character_convalescing(character:command_queue_index())
                         end
                    end
               end
          end
     end
end, true)
ModLog("===== Unlock_Recruitment_of_Tausret MOD LOADED =====")