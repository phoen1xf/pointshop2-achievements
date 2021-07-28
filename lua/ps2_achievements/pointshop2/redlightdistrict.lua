ACHIEVEMENT = {}
ACHIEVEMENT.Name = "Red Light District Legend" -- The Name of the Achievement. Viewable in the menu.
ACHIEVEMENT.Description = "Earn a total of 10,000 points by whoring yourself out to other players" -- The description that appears in the menu.
ACHIEVEMENT.Icon = "redlightdistrict.png" -- The icon that appears in the menu.
ACHIEVEMENT.Min = 0 -- At what stage do you start? Normal starting position is 0.
ACHIEVEMENT.Max = 10000 -- At what stage do you earn the achievement? Set to 1 for instant achieve on action completion.
ACHIEVEMENT.Gamemode = {} -- If empty, will register on all gamemodes.
ACHIEVEMENT.TTTDelay = false -- If true, disables achievement broadcasting to other players until round end.
ACHIEVEMENT.Reward = { items = {"Steeze"}, points = { points = 500, premiumPoints = 50 } } -- nil for no reward, otherwise define table as: { items = {"string"}, points = { points = num, premiumPoints = num } }
-- To get a item's name, you should look for it's ID. Turn on LibK.Debug, and then you'll notice on buy/sell of that item it's classname, being KInventory.Item.NUM, you need the number.


-- Only runs serverside once the Gamemode check has passed. <3 lua env
ACHIEVEMENT.Initialize = function()
		
	hook.Add("PS2_PointsAwarded", "Ps2Ach." .. ACHIEVEMENT.Name, function( ply, points )
		ply:UpdateAchievement(Ps2Achievements:GetByName(ACHIEVEMENT.Name), points)
	end)
		
end