local PANEL = {}

function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )
	self:SetTitle( "Achievements Settings" )
	self:SetSize( 300, 600 )
	
	self:AutoAddSettingsTable( Pointshop2.GetModule( "Achievements" ).Settings.Server, self )
	self:AutoAddSettingsTable( Pointshop2.GetModule( "Achievements" ).Settings.Shared, self )
end

function PANEL:DoSave( )
	Pointshop2View:getInstance( ):saveSettings( self.mod, "Server", self.settings )
end

derma.DefineControl( "DAchievementConfigurator", "", PANEL, "DSettingsEditor" )