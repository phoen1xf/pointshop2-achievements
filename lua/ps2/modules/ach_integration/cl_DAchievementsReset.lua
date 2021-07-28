local PANEL = {}

function PANEL:Init( )
	self:SetSize( 300, 300 )
	self:SetTitle( "Reset to defaults" )
	
	self.warning = vgui.Create( "DMultilineLabel", self )
	self.warning:InsertColorChange( 255, 0, 0, 255 )
	self.warning:AppendText( "WARNING: This will permanently remove all achievements and reset your achievements to the default installation! Once done, this step cannot be undone! The map will be changed after the reset!" )
	self.warning:Dock( FILL )
	self.warning.PerformLayout = function( ) end
	
	self.button = vgui.Create( "DButton", self )
	self.button:Dock( BOTTOM )
	self.button:SetText( "Reset Achievements" )
	function self.button.DoClick( )
		net.Start("Achievement_ResetAll")
		net.SendToServer()
		self:Close()
	end
end

function PANEL:ApplySchemeSettings( )
	self.warning.font = self:GetSkin().SmallTitleFont
end

--interface, has to be defined 20089331
function PANEL:SetModule( )
end

function PANEL:SetData( )
end


vgui.Register( "DAchievementsReset", PANEL, "DFrame" )