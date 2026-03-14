local function out(t)
     ModLog("AI CPR: " .. tostring(t) .. ".")
end

local pharaoh_growth_buildings = {
	["phar_main_all_landmark_growth_happiness_ashkelon_1"] = true,
	["phar_main_all_province_management_growth_type_a_1"] = true,
	["phar_main_all_province_management_growth_type_a_2"] = true,
	["phar_main_all_province_management_growth_type_a_3"] = true,
	["phar_main_all_province_management_growth_type_b_1"] = true,
	["phar_main_all_province_management_growth_type_b_2"] = true,
	["phar_main_amenmesse_province_management_main_building_production_boost_growth_1"] = true,
	["phar_main_amenmesse_province_management_main_building_production_boost_growth_2"] = true,
	["phar_main_amenmesse_province_management_main_building_production_boost_growth_3"] = true,
	["phar_main_suppi_province_management_growth_1"] = true,
	["phar_main_suppi_province_management_growth_2"] = true,
	["phar_map_bab_province_management_happiness_growth_type_a_1"] = true,
	["phar_map_bab_province_management_happiness_growth_type_a_2"] = true,
	["phar_map_bab_province_management_happiness_growth_type_a_3"] = true,
	["phar_sea_sherden_province_management_growth_production_adjacent_1"] = true,
	["phar_sea_sherden_province_management_growth_production_adjacent_2"] = true,
	["phar_sea_sherden_province_management_growth_production_adjacent_3"] = true
}

local function is_growth_building(building_name)
	return pharaoh_growth_buildings[building_name] or false
end

local function Dismantle_Growth(region_key)
     out("Dismantle_Growth: start error checks.")
     out("Dismantle_Growth: for region " .. region_key)
     local region = cm:get_region(region_key)
     if not region then
          out("Error - Region not found for key " .. region_key)
          return
     end
     out("Region " .. region_key .. " found.")

     local settlement = region:settlement()
     if not settlement then
          out("Error - Settlement not found for region " .. region_key)
          return
     end
     out("Settlement found for region " .. region_key)

     local slot_list = settlement:slot_list()
     if not slot_list then
          out("Error - Slot list is nil for region " .. region_key)
          return
     end
     out("Slot list found for region " .. region_key)

     out("Dismantle_Growth: error checks complete.")
     for i = 0, slot_list:num_items() - 1 do
          local slot = slot_list:item_at(i)
          out("AI CPR slot: " .. tostring(slot) .. ", has_building: " .. tostring(slot and slot:has_building()))

          if slot and slot:has_building() then
               local building = slot:building()
               out("Building: " .. tostring(building))

               if building then
                    local building_name = building:name()
                    if is_growth_building(building_name) then
                         out("Dismantle_Growth:: removing building " .. building_name)
                         cm:region_slot_instantly_dismantle_building(slot)
                    end
               end
          end
     end
end

local function Growth_Listener()
     out("Creating Listener for Maxed out Provinces.")
     core:add_listener(
          "AI_CPR_DismantleGrowthListener",
          "BuildingCompleted",
          function(context)
               if not context or not context:building() or not context:building():slot() then
                    out("Error - Invalid context in BuildingCompleted listener")
                    return false
               end
               return context:building():slot():type() == "primary" and context:building():building_level() == 5
          end,
          function(context)
               local region = context:building():region()
               local region_key = context:building():region():name()
               local region_owner = region:owning_faction()
               local province = region:province()
               if not province then
                    out("Error - Province not found")
                    return
               end

               out("DismantleGrowthListener T5 settlement reached in " ..
                    (province:key() or "unknown province") ..
                    " for " .. (region_owner:name() or "unknown owner") ..
                    " region_owner:is_human() - " .. tostring(region_owner:is_human()))

               if not region_owner:is_human() then
                    out("Region is owned by an AI faction.")
                    for _, current_region in model_pairs(province:regions()) do
                         if current_region then
                              out("Inspecting region: " .. current_region:name() ..
                                   ", owned by faction: " .. current_region:owning_faction():name())
                              if current_region:owning_faction():command_queue_index() == region_owner:command_queue_index() then
                                   out("CQI checks complete, dismantling growth in region: " .. current_region:name())
                                   Dismantle_Growth(current_region:name())
                              end
                         else
                              out("Error: current_region is nil in province:regions() iteration.")
                         end
                    end
               end
          end,
          true
     )
end
cm:add_first_tick_callback(Growth_Listener)
