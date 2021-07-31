// Not made by Josh 'Acecool' Moser

surface.CreateFont( "PS2_UberLarge", {
	font = "Segoe UI Bold",
	size = 96,
} )

surface.CreateFont( "PS2_StillLarge", {
	font = "Segoe UI 8",
	size = 40,
} )

surface.CreateFont( "PS2_MediumLargeBold", {
	font = "Segoe UI Bold",
	size = 22,
} )

local PANEL = {}

function PANEL:Init()
	self:SetSkin( Pointshop2.Config.DermaSkin )
	
	self.ProgressPanel = vgui.Create("DPanel", self)

	self.ProgressPanel:DockMargin(15, 15, 15, 15)
	self.ProgressPanel:SetTall(78)
	Derma_Hook( self.ProgressPanel, "Paint", "Paint", "InnerPanel" )
		
	self.ProgressPanel:InvalidateParent(true)
	self.ProgressPanel:InvalidateChildren(true)
	self.ProgressPanel:InvalidateLayout(true)
	
	self.ProgressPanel:Dock(TOP)

	if IsValid(self.CategorySelector) then self.CategorySelector:Remove() end
	self.CategorySelector = vgui.Create( "DComboBox", self )
	self.CategorySelector:SetPos( 15, 96 )
	self.CategorySelector:SetSize( 148, 20 )
	self.CategorySelector:SetValue( "All Categories" )
	self.CategorySelector:AddChoice( "All Categories" )
	
	local categories = {} 
	for k, v in pairs( Ps2Achievements.Achievements ) do categories[Ps2Achievements.CategoryNames[v.Category]] = true end
	for categoryName, _ in pairs( categories ) do
		self.CategorySelector:AddChoice( categoryName )		
	end
	self.CategorySelector.OnSelect = function( panel, index, value )
		self:UpdateAndList(value)
	end
	Derma_Hook( self.CategorySelector, "Paint", "Paint", "InnerPanel" )
	
	self:UpdateAndList()
	
	Pointshop2.Achievements = self
end

hook.Add("PS2_AchievementsUpdate", "UpdateAchievements", function( fileName, amount )
	print("reloading achievements")
	if IsValid(Pointshop2.Achievements) then Pointshop2.Achievements:UpdateAndList() end
end)

function PANEL:UpdateAndList(category)
	if category and category == "All Categories" then category = nil end
	
	self:SetSkin( Pointshop2.Config.DermaSkin )
		
	local MaxAchievements = table.Count(Ps2Achievements.Achievements)
	
	local CurAchieved = 0
	for _, Ach in pairs(Ps2Achievements.Achievements) do
		if Local_AchievementData[Ach.fileName] != nil and Local_AchievementData[Ach.fileName] >= Ach.Max then
			Ach.Achieved = true
			CurAchieved = CurAchieved + 1
		end
	end

	self:InvalidateParent(true)
	self:InvalidateChildren(true)
	self:InvalidateLayout(true)

	self.ProgressPanel:InvalidateParent(true)
	self.ProgressPanel:InvalidateChildren(true)
	self.ProgressPanel:InvalidateLayout(true)

	if IsValid(self.Progress) then self.Progress:Remove() end
	self.Progress = vgui.Create("DLabel", self.ProgressPanel)
	self.Progress:SetFont("PS2_MediumLarge")
	self.Progress:SetColor(Color(255, 255, 255))
	self.Progress:SetText("Progress")
	self.Progress:SetPos(15, 10)
	self.Progress:SizeToContents()

	local pan_w = 970 -- CHANGE THIS IF YOUR MENUSIZE IS DIFFERENT AS I GAVE UP ON DOCKING AS THE WIDTH ISN'T PASSED THE SAME FRAME
	local bar_w = pan_w - 80
	local box_w = pan_w - 20 
	print(pan_w)
	
	if IsValid(self.ProgressCount) then self.ProgressCount:Remove() end
	self.ProgressCount = vgui.Create("DLabel", self.ProgressPanel)
	self.ProgressCount:SetFont("PS2_StillLarge")
	self.ProgressCount:SetText(CurAchieved.." / "..MaxAchievements)
	self.ProgressCount:SetColor(Color(255, 198, 0))
	self.ProgressCount:SetPos(100, 0)
	self.ProgressCount:SizeToContents()
	
	local perc = (CurAchieved / MaxAchievements)
	
	if IsValid(self.ProgressBar) then self.ProgressBar:Remove() end
	self.ProgressBar = vgui.Create("DPanel", self.ProgressPanel)
	self.ProgressBar:SetWide( pan_w - 20 )
	self.ProgressBar:SetPos(15, 40)
	self.ProgressBar.Paint = function(self, w, h)
		
		local barW = perc * self:GetWide()

		draw.RoundedBox(2, 0, 0, w, h, Color( 69, 69, 69))
		draw.RoundedBox(2, 0, 0, barW, h, Color( 255, 198, 0 ))
	end
	
	if IsValid(self.AchievementsPanel) then self.AchievementsPanel:Remove() end
	self.AchievementsPanel = vgui.Create("DScrollPanel", self)
	self.AchievementsPanel:Dock(FILL)
	self.AchievementsPanel:DockMargin(15, 10, 15, 15)
	Derma_Hook( self.AchievementsPanel, "Paint", "Paint", "InnerPanel" )
	
	self.AchievementsPanel:InvalidateParent(true)
	self.AchievementsPanel:InvalidateChildren(true)
	self.AchievementsPanel:InvalidateLayout(true)

	-- Table Sorting.
	local Ps2SortedAchievements = {}
	for fileName, achievement in pairs(Ps2Achievements.Achievements) do 
		achievement.Enabled = true
		if not table.HasValue(achievement.Gamemode, engine.ActiveGamemode()) and #achievement.Gamemode > 0 then 
			achievement.Enabled = false
		end
		table.insert(Ps2SortedAchievements, achievement)
	end
	table.sort( Ps2SortedAchievements, function( a, b ) return a.Name < b.Name end )
	
	local marge = 15
	local firstmade = false
	for k, achievement in pairs(Ps2SortedAchievements) do 
		if (category and achievement.Category) and Ps2Achievements.CategoryNames[achievement.Category] != category then continue end
		
		if achievement.Secret and ( !Local_AchievementData[achievement.fileName] or Local_AchievementData[achievement.fileName] < achievement.Max ) then continue end -- SECRET ACHIEVEMENTS :D
		
		if firstmade then marge = 0 end
		firstmade = true
		local AP = vgui.Create("DPanel", self.AchievementsPanel)
		AP:SetTall(118)
		AP:Dock(TOP)
		AP:DockMargin(15, marge, 0, 9)	

		AP:InvalidateParent(true)
		AP:InvalidateChildren(true)
		AP:InvalidateLayout(true)

		AP.Paint = function(self, w, h)
			if (self:IsHovered( ) or self:IsChildHovered( 3 )) and achievement.Enabled then
				draw.RoundedBox(8, 0, 0, w, h, Color( 255, 198, 0 ))
			else
				draw.RoundedBox(8, 0, 0, w, h, Color( 129, 129, 129 ))
			end
		end
		if not achievement.Enabled then 
			AP.PaintOver = function(self, w, h)
				draw.RoundedBox(8, 0, 0, w, h, Color( 0, 0, 0, 200 ))
			end
		end
		
		AP.BOX = vgui.Create("DPanel", AP)
		AP.BOX:SetWide( box_w )
		AP.BOX:SetTall(72)
		AP.BOX:SetPos(103, 5)
		AP.BOX.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color( 49, 49, 49 ))
		end
		
		AP.PROGBOX = vgui.Create("DPanel", AP)
		AP.PROGBOX:SetWide( box_w )
		AP.PROGBOX:SetTall(30)
		AP.PROGBOX:SetPos(103, 82)
		AP.PROGBOX.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color( 49, 49, 49 ))
		end
		
		local perc = ((Local_AchievementData[achievement.fileName] or 0) / achievement.Max)
		
		AP.PROGBOX.PROG = vgui.Create("DPanel", AP.PROGBOX)
		AP.PROGBOX.PROG:SetWide( bar_w )
		AP.PROGBOX.PROG:SetTall(19)
		AP.PROGBOX.PROG:SetPos(15, 6)
		AP.PROGBOX.PROG:SetContentAlignment(5)
		AP.PROGBOX.PROG.Paint = function(self, w, h)
			
			local barW = perc * self:GetWide()

			draw.RoundedBox(2, 0, 0, w, h, Color( 69, 69, 69))
			draw.RoundedBox(2, 0, 0, barW, h, Color( 255, 198, 0 ))
		end
		--Derma_Hook( AP.PROGBOX, "Paint", "Paint", "InnerPanel" )
		
		AP.PROGBOX.LABEL = vgui.Create("DLabel", AP.PROGBOX)
		AP.PROGBOX.LABEL:SetFont("PS2_MediumLargeBold")
		AP.PROGBOX.LABEL:SetColor(Color(0,0,0))
		AP.PROGBOX.LABEL:SetText((Local_AchievementData[achievement.fileName] or 0).."/"..achievement.Max)
		AP.PROGBOX.LABEL:Dock(FILL)
		AP.PROGBOX.LABEL:SetContentAlignment(5)
		--AP.PROGBOX.LABEL:SetPos(AP.PROGBOX:GetWide()/2-AP.PROGBOX.LABEL:GetWide()/2, 3)
		
		AP.ImageBG = vgui.Create("DImage", AP)
		AP.ImageBG:SetMaterial(Material("achievements/ps_imgbg.png", "noclamp smooth nocull"))
		AP.ImageBG:SetSize(96, 96)
		AP.ImageBG:SetPos(3, 12)
		
		AP.MissingIcon = vgui.Create("DLabel", AP.ImageBG)
		AP.MissingIcon:SetText("?")
		AP.MissingIcon:SetColor(Color(129, 129, 129))
		if achievement.Achieved then
			AP.MissingIcon:SetColor(Color(255, 198, 0))
		end
		AP.MissingIcon:SetFont("PS2_UberLarge")
		AP.MissingIcon:Dock(FILL)
		AP.MissingIcon:DockMargin(0, 0, 0, 7)
		AP.MissingIcon:SetContentAlignment(5)
		AP.MissingIcon:SetVisible(false)
		
		if achievement.Icon then
			AP.AchIcon = vgui.Create("DImage", AP)
			AP.AchIcon:SetMaterial(Material("achievements/"..achievement.Icon, "noclamp smooth nocull"))
			AP.AchIcon:SetSize(96, 96)
			AP.AchIcon:SetPos(3, 12)
			if achievement.Achieved then
				AP.AchIcon:SetImageColor(Color(255, 198, 0))
			end
		else
			AP.MissingIcon:SetVisible(true)
		end
		
		if achievement.Name then
			AP.BOX.LN = vgui.Create("DLabel", AP.BOX)
			AP.BOX.LN:SetFont("PS2_MediumLarge")
			AP.BOX.LN:SetText(achievement.Name)
			AP.BOX.LN:SetPos(15, 5)
			AP.BOX.LN:SizeToContents()
		end
		
		if achievement.Description then
			AP.BOX.DESC = vgui.Create("DLabel", AP.BOX)
			AP.BOX.DESC:SetFont("PS2_Normal")
			AP.BOX.DESC:SetText(achievement.Description)
			AP.BOX.DESC:SetPos(15, 35)
			AP.BOX.DESC:SizeToContents()
		end
	end
end

Derma_Hook( PANEL, "Paint", "Paint", "PointshopInventoryTab" )
derma.DefineControl( "DPointshopAchievementsPanel", "", PANEL )

Pointshop2:AddInventoryPanel("Achievements", "achievements/staryu.png", "DPointshopAchievementsPanel")