ACHIEVEMENT = {}
ACHIEVEMENT.Name = "All Coffee'd Up!" -- The Name of the Achievement. Viewable in the menu.
ACHIEVEMENT.Description = "Play with one of the Developers of Pointshop2!" -- The description that appears in the menu.
ACHIEVEMENT.Icon = "allcoffeedup.png" -- The icon that appears in the menu. Defaults to achievements/iconname.png/vmt
ACHIEVEMENT.Min = 0 -- At what stage do you start? Normal starting position is 0.
ACHIEVEMENT.Max = 1 -- At what stage do you earn the achievement? Set to 1 for instant achieve on action completion.
ACHIEVEMENT.Gamemode = {} -- If empty, will register on all gamemodes.
ACHIEVEMENT.TTTDelay = false -- If true, disables achievement broadcasting to other players until round end.
ACHIEVEMENT.Reward = nil -- nil for no reward, otherwise define table as: { items = {}, points = 0, premiumPoints = 0 } 

-- Initialize only runs serverside, if it has passed the above Gamemode checks.
ACHIEVEMENT.Initialize = function()
			
	hook.Add("PlayerSpawn", "Ps2Ach." .. ACHIEVEMENT.Name, function( ply )
		if ply:SteamID() == "STEAM_0:0:19299911" or ply:SteamID() == "STEAM_0:0:39587206" then 
		
			timer.Simple(10, function() -- So we can be satisfied :(
				for k, v in pairs(player.GetAll()) do
					v:UpdateAchievement(Ps2Achievements:GetByName(ACHIEVEMENT.Name), 1)
				end
			end)
		end
	end)
end