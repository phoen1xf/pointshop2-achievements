util.AddNetworkString("Achievement_Update")
util.AddNetworkString("Achievement_Init")
util.AddNetworkString("Achievement_Finish")
util.AddNetworkString("Achievement_ResetAll")
util.AddNetworkString("Achievement_NotifyReset")

local meta = FindMetaTable("Player")
local DelayForTTT = {}
local ForceItemToPoints = true
LibK.addContentFolder("materials/achievements")

local AchievementsModel = Pointshop2.AchievementsModel

net.Receive("Achievement_ResetAll", function(len, ply)
	if not PermissionInterface.query( ply, "pointshop2 reset" ) then print("[WARNING] "..tostring(ply:Nick()).." has attempted to reset the Achievements, but doesn't have permissions!") return end
	
	-- Resets the database!
	AchievementsModel.truncateTable( )

	-- So serverside clears out.
	for k, v in pairs(player.GetAll()) do 
		v.AchievementData = {}
	end
	
	-- Notify all connected clients.
	net.Start( "Achievement_NotifyReset" )
	net.Broadcast()
	
	-- So clientside clears out.
	net.Start( "Achievement_Init" )
		net.WriteTable({})
	net.Broadcast()
	
	timer.Simple(5, function()
		RunConsoleCommand("changelevel", game.GetMap())
	end)
	
end)

function meta:LoadAchievements()
	if !self:IsValid() then return end
	
	self.AchievementData = {}
	
	AchievementsModel.findAllByOwnerId( self.kPlayerId )
	:Then( function( achievements )
			
		for _, achievement in pairs( achievements ) do
			self.AchievementData[achievement.filename] = achievement.count
		end
	
		net.Start( "Achievement_Init" )
			net.WriteTable( self.AchievementData )
		net.Send( self )
				
	end )
	
end

function meta:SaveAchievement( fileName )
	if !self:IsValid() then return end

	return AchievementsModel.findWhere{ ownerId = self.kPlayerId, filename = fileName }
	:Then( function( achievements )
		local achievement = achievements[1]
		if not achievement then
			--Create it
			achievement = AchievementsModel:new( )
			achievement.ownerId = self.kPlayerId 
			achievement.filename = fileName
		end
		
		achievement.count = self.AchievementData[fileName]
		
		return achievement:save( )
	end )
end

function meta:HasAchievement(achievement)
	if !self:IsValid() then return end

	if self.AchievementData[achievement.fileName] >= achievement.Max then
		return true
	end
	return false
end

function meta:UpdateAchievement(ach, amount)
	if !self:IsValid() then return end
	
	if !ach then return end
	amount = amount or 1
		
	local fileName = ach.fileName
	local Min = ach.Min
	local Max = ach.Max
	
	if not self.AchievementData then
		self:LoadAchievements()
		
		timer.Simple(5, function()
			if not self:IsValid() then return end
			self:UpdateAchievement(ach, amount)
		end)
		return
	end
	
	self.AchievementData[fileName] = self.AchievementData[fileName] or Min
	
	local Data = self.AchievementData[fileName]
	
	if Data < Min then
		Data = Min
	end
	if Data >= Max then return end
		
	Data = Data + amount
	if Data >= Max then -- Finished achievement!
		Data = Max
		
		self:BroadcastAchievement(fileName, ach.TTTDelay or false )	
	end
	
	self.AchievementData[fileName] = Data
	
	net.Start("Achievement_Update")
		net.WriteString(fileName)
		net.WriteUInt(Data, 32)
	net.Send(self)
		
	self:SaveAchievement(fileName)
end

hook.Add("TTTRoundEnd", "BroadcastAchievements", function()
	for k, v in pairs(DelayForTTT) do 
		if !v.ply:IsValid() then continue end -- Looks like they missed out!
		
		v.ply:BroadcastAchievement(v.fileName)
	end
	DelayForTTT = {}
end)

meta.NextAllowCall = 0
function meta:BroadcastAchievement(fileName, TTTDelay)
	if !self:IsValid() then return end
	
	if meta.NextAllowCall > CurTime() then return end -- Infinite loop - meta:PS2_AddStandardPoints + hook PS2_AchievementEarn prevented.
	meta.NextAllowCall = CurTime() + 0.1

	local achievement = Ps2Achievements.Achievements[fileName]
		
	if achievement.Reward then 
		if achievement.Reward.points then
			if achievement.Reward.points.points then
				self:PS2_AddStandardPoints(achievement.Reward.points.points, achievement.Name)
			end
			if achievement.Reward.points.premiumPoints then
				-- When there's a dedicated function in Pointshop2.
			end
		end

		if achievement.Reward.items then 
			for k, v in pairs(achievement.Reward.items) do
			
				local itemClass = Pointshop2.GetItemClassByPrintName( v )		
				if not itemClass then
					print("[Ps2Achievements] Reward "..v.." is an invalid item name!")
					continue
				end
				
				if (#self.PS2_Inventory:getItems( ) >= self.PS2_Inventory.numSlots) or ForceItemToPoints then
					local SalePrice = itemClass:GetBuyPrice( self ).points * Pointshop2.GetSetting( "Pointshop 2", "BasicSettings.SellRatio" )
					self:PS2_AddStandardPoints( SalePrice, "Item to Points Conversion")
				else
					self:PS2_EasyAddItem( itemClass.className )
				end
				
			end
		end
	end
	
	if TTTDelay then	
		table.insert( DelayForTTT, { ply = self, fileName = fileName } )
	else
		net.Start("Achievement_Finish")	
			net.WriteEntity(self)
			net.WriteString(fileName)	
		net.Broadcast()
		
		-- Due to TTT, this will be called at round end, players will NOT know they have earned said achievement until the round ends, giving them a surprise :)
		hook.Run("PS2_AchievementEarn", self, fileName)
	end
end

hook.Add("PlayerInitialSpawn", "LoadAchievements", function(ply)
	--if !ply:IsValid() then return end
	--ply:LoadAchievements()
	--this doesnt work, net is unreliable here
end)

util.AddNetworkString( "achievements_readyfornetworking" )
net.Receive( "achievements_readyfornetworking", function( len, ply )
	if (ply._rl_load or 0) > CurTime() then return end
	ply._rl_load = CurTime() + 5 -- once every 5 seconds, ratelimit

	ply:LoadAchievements()
end )