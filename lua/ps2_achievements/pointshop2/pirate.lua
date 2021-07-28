ACHIEVEMENT = {}
ACHIEVEMENT.Name = "Pirate" -- The Name of the Achievement. Viewable in the menu.
ACHIEVEMENT.Description = "Earn a total of 1,000 points" -- The description that appears in the menu.
ACHIEVEMENT.Icon = "pirate.png" -- The icon that appears in the menu.
ACHIEVEMENT.Min = 0 -- At what stage do you start? Normal starting position is 0.
ACHIEVEMENT.Max = 1000 -- At what stage do you earn the achievement? Set to 1 for instant achieve on action completion.
ACHIEVEMENT.Gamemode = {} -- If empty, will register on all gamemodes.
ACHIEVEMENT.TTTDelay = false -- If true, disables achievement broadcasting to other players until round end.
ACHIEVEMENT.Reward = { items = {}, points = {points = 50, premiumPoints = 0} } -- nil for no reward, otherwise define table as: { items = {}, points = 0, premiumPoints = 0 } 

ACHIEVEMENT.Initialize = function()
		
	hook.Add("PS2_PointsAwarded", "Ps2Ach" .. ACHIEVEMENT.Name, function( ply, points )
		ply:UpdateAchievement(Ps2Achievements:GetByName(ACHIEVEMENT.Name), points)
	end)
		
end