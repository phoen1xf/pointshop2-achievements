local MODULE = {}

--Pointshop2 Achievements integration
MODULE.Name = "Achievements"
MODULE.Author = "Phoenixf129"

MODULE.Blueprints = {}

MODULE.SettingButtons = {
	{
		label = "Reset All",
		icon = "pointshop2/restart1.png",
		control = "DAchievementsReset"
	},
}

MODULE.Settings = {}
MODULE.Settings.Server = {}
	
Pointshop2.RegisterModule( MODULE )