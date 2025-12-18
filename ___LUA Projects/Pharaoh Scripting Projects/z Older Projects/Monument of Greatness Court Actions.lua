out("MONUMENT_MOD: init")
core:add_listener(
     "recharge_court",
     "FactionTurnStart",
     function(context)
          out("MONUMENT_MOD: Faction turn start - hecking for ownership of monument of greatness")
          if context:faction():building_exists("phar_main_all_landmark_victory_points_1") then
               return true
          end
     end,
     function(context)
          out("MONUMENT_MOD: adding 1 court action for fation: " .. context:faction():name())
          court.util_functions.add_court_extra_actions_for_faction(context:faction():name(), 1)
     end,
     true)
