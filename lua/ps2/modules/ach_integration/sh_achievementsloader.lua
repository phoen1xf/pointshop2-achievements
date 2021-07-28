Ps2Achievements = Ps2Achievements or {}
Ps2Achievements.Achievements = {}

function Ps2Achievements:GetByName(name) -- The Name of the Achievement.
	local achievement = nil
	for k, v in pairs(Ps2Achievements.Achievements) do
		if name == v.Name then
			achievement = v
			break
		end
	end
	return achievement
end

function Ps2Achievements:GetByID(fileName) -- File name is the ID.
	return Ps2Achievements.Achievements[fileName]
end

function Ps2Achievements:loadItem( filepath, filename )
	local fileName = string.gsub( filename, ".lua", "" )
	local category = string.gsub( filepath, "ps2_achievements/", "")
	category = string.gsub( category, "/"..filename, "")
	
	local achievementId = category.."_"..fileName
	--Set up the environment for the function
	local environment = {}
	--make it accessible via ACHIEVEMENT
	environment.ACHIEVEMENT = Ps2Achievements.Achievements[achievementId]
	setmetatable( environment, { __index = _G } ) --make sure that func can access the real _G

	local func = CompileFile( filepath )
	if not func then
		KLogf( 2, "      -> [ERROR] Couldn't load achievement file %s", filename )
		Ps2Achievements.Achievements[achievementId] = nil --remove the class
		return
	end

	setfenv( func, environment ) -- _G for func now becomes environment
	func( )
	
	Ps2Achievements.Achievements[achievementId] = environment.ACHIEVEMENT
	Ps2Achievements.Achievements[achievementId].fileName = achievementId
	Ps2Achievements.Achievements[achievementId].Category = category
	
	if SERVER then
		if table.HasValue( Ps2Achievements.Achievements[achievementId].Gamemode, engine.ActiveGamemode() ) or #Ps2Achievements.Achievements[achievementId].Gamemode == 0 then
			Ps2Achievements.Achievements[achievementId].Initialize()
		end
	end
	
	KLogf( 4, "     -> Achievement %s loaded!", fileName )
end

function Ps2Achievements:includeFolder( folder )
	local files, folders = file.Find( folder .. "/*", "LUA" )
	for k, filename in pairs( files ) do
		local fullpath = folder .. "/" .. filename
		if SERVER then
			AddCSLuaFile( fullpath )
		
			print( "AddCSLua", fullpath )
			
			include(fullpath)
		end
		Ps2Achievements:loadItem( fullpath, filename )
	end

	for k, v in pairs( folders ) do
		Ps2Achievements:includeFolder( folder .. "/" .. v )
	end
end

hook.Add("InitPostEntity", "Ps2Achievements_LoadItems", function()
	Ps2Achievements:includeFolder( "ps2_achievements" )
	hook.Run( "Ps2_AchievementsLoaded" )
end)

hook.Add( "OnReloaded", "Ps2Achievements_LoadItems", function( )
	Ps2Achievements:includeFolder( "ps2_achievements" )
	hook.Run( "Ps2_AchievementsLoaded" )
end )