ACHIEVEMENT = {}
ACHIEVEMENT.Name = "Exterminate the Innocents" -- The Name of the Achievement. Viewable in the menu.
ACHIEVEMENT.Description = "End 50 innocent lives as a Traitor" -- The description that appears in the menu.
--ACHIEVEMENT.Icon = "50innocent.png" -- The icon that appears in the menu.
ACHIEVEMENT.Min = 0 -- At what stage do you start? Normal starting position is 0.
ACHIEVEMENT.Max = 50 -- At what stage do you earn the achievement? Set to 1 for instant achieve on action completion.
ACHIEVEMENT.Gamemode = {"terrortown"} -- If empty, will register on all gamemodes.
ACHIEVEMENT.TTTDelay = false -- If true, disables achievement broadcasting to other players until round end.
ACHIEVEMENT.Reward = { points = { points = 50, premiumPoints = 0 } } -- nil for no reward, otherwise define table as: { items = {"string"}, points = { points = num, premiumPoints = num } }
-- To get a item's name, you should look for it's ID. Turn on LibK.Debug, and then you'll notice on buy/sell of that item it's classname, being KInventory.Item.NUM, you need the number.


-- Only runs serverside once the Gamemode check has passed. <3 lua env
ACHIEVEMENT.Initialize = function()
			
	hook.Add("PlayerDeath", "Ps2Ach." .. ACHIEVEMENT.Name, function( victim, weapon, killer )
		if victim != killer and killer:IsPlayer() and (killer:IsActiveTraitor() and victim:GetRole() == ROLE_INNOCENT) then
			killer:UpdateAchievement(Ps2Achievements:GetByName(ACHIEVEMENT.Name), 1)
		end
	end)
		
end