local function CurrentFaction
	local game_core = context:GetValue("GameCore")
	local active_faction = game_core:GetValue("CurrentFaction")
	local turn_number = context:GetValue("Queries"):GetValue("TurnNumber")
	
	if turn_number then
		active_faction:GetValue("Name")
		active_faction:GetValue("FactionKey")
		tostring(turn_number)
	end
end

