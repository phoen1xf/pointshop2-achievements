ACHIEVEMENT = {}
ACHIEVEMENT.Name = "Pointshop2 Master" -- The Name of the Achievement. Viewable in the menu.
ACHIEVEMENT.Description = "Earn all achievements in the Pointshop2 Category" -- The description that appears in the menu.
ACHIEVEMENT.Icon = "master.png" -- The icon that appears in the menu.
ACHIEVEMENT.Min = 0 -- At what stage do you start? Normal starting position is 0.
ACHIEVEMENT.Max = 7 -- At what stage do you earn the achievement? Set to 1 for instant achieve on action completion.
ACHIEVEMENT.Gamemode = {} -- If empty, will register on all gamemodes.
ACHIEVEMENT.TTTDelay = false -- If true, disables achievement broadcasting to other players until round end.
ACHIEVEMENT.Reward = { points = { points = 500 } } -- nil for no reward, otherwise define table as: { items = {"string"}, points = { points = num, premiumPoints = num } }

ACHIEVEMENT.Initialize = function()
		
	hook.Add("PS2_AchievementEarn", "Ps2Ach." .. ACHIEVEMENT.Name, function( ply, fileName )
		if Ps2Achievements.Achievements[fileName].Category and Ps2Achievements.Achievements[fileName].Category == "pointshop2" then
			ply:UpdateAchievement(Ps2Achievements:GetByName(ACHIEVEMENT.Name), 1)
		end
	end)
		
end