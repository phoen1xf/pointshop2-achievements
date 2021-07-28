Pointshop2.AchievementsModel = class( "Pointshop2.AchievementsModel" )

Pointshop2.AchievementsModel.static.DB = "Pointshop2" --The identifier of the database as given to LibK.SetupDatabase
Pointshop2.AchievementsModel.static.model = {
    tableName = "ps2_achievements",
    fields = {
        ownerId = "int",
        filename = "string",
        count = "int"
	}
}
Pointshop2.AchievementsModel:include( DatabaseModel ) --Adds the model functionality and automagic functions
