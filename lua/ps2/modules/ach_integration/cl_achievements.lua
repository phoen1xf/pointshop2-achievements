LocalPlayer().AchievementData = {}

net.Receive("Achievement_Init", function(len) 
	local Data = net.ReadTable()

	if table.Count(Ps2Achievements.Achievements) == 0 then
		Ps2Achievements:includeFolder( "ps2_achievements" ) -- Validation incase they didn't load originally when they should have :O
	end
	
	LocalPlayer().AchievementData = Data
	
	hook.Run("PS2_AchievementsUpdate")
end)

net.Receive("Achievement_Update", function(len)
	local fileName = net.ReadString()
	local amount = net.ReadUInt(32)
	
	LocalPlayer().AchievementData[fileName] = amount
	
	hook.Run("PS2_AchievementsUpdate", fileName, amount)
	
end)

net.Receive("Achievement_NotifyReset", function(len)

	chat.AddText(Color(0,255,0), "[PS2 Achievements] ",
		Color(255,255,255), " The Achievements Database has been reset! All Achievements reset to zero! Restarting map in 5..."
	)
	
end)

net.Receive("Achievement_Finish", function(len)
	local ply = net.ReadEntity()
	local fileName = net.ReadString()
	
	local achievement = Ps2Achievements.Achievements[fileName]
	
	if not ply:IsValid() then return end
	if not achievement then return end -- Incase you receive before initializing.
	
	chat.AddText(Color(0,255,0), "[PS2 Achievements] ",
		Color(255,220,0), ply:Nick(),
		Color(255,255,255), " earned the ",
		Color(255,220,0), achievement.Name,
		Color(255,255,255), " achievement!"
	)
	
	--ShowSexyPopup(achievement)
	
end)

local function ShowSexyPopup(achievement)
	print("coming soon, I need a design!")
end