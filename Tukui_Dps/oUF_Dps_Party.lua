if not TukuiCF["unitframes"].enable == true then return end

----- [[    Local Variables    ]] -----

local media = TukuiCF["media"]
local unitframes = TukuiCF["unitframes"]

local theme_font, theme_fsize, theme_fflag = TukuiCF["theme"].UF_Font, TukuiCF["theme"].UF_FSize, TukuiCF["theme"].UF_FFlag

local theme_texture = TukuiCF["theme"].UI_Texture


----- [[    Layout    ]] -----

local function Shared(self, unit)
	self.colors = TukuiDB.oUF_colors
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = TukuiDB.SpawnMenu
	
	
	----- [[    Health Bar / Background / Border    ]] -----
	
	local health = CreateFrame("StatusBar", nil, self)
	health:SetPoint("TOPLEFT", TukuiDB.mult, -TukuiDB.mult)
	health:SetPoint("BOTTOMRIGHT", -TukuiDB.mult, TukuiDB.mult)
	health:SetStatusBarTexture(theme_texture)
	self.Health = health
	
	local hBg = health:CreateTexture(nil, "BORDER")
	hBg:SetAllPoints()
	hBg:SetTexture(.05, .05, .05)
	self.Health.bg = hBg

	local hBorder = CreateFrame("Frame", nil, health)
	hBorder:SetFrameLevel(health:GetFrameLevel() - 1)
	hBorder:SetPoint("TOPLEFT", -2, 2)
	hBorder:SetPoint("BOTTOMRIGHT", 2, -2)
	TukuiDB.SkinPanel(hBorder)
	self.Health.border = hBorder		
	
	
	----- [[    Unit Name    ]] -----

	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(theme_font, theme_fsize, theme_fflag)
	local ns = 0
	if theme_font == TukuiCF.media.pixelfont then ns = 3 end	
	name:SetPoint("CENTER", health, "CENTER", ns, 0)
	self.Name = name

	
	----- [[    Color Health Bar    ]] -----

	health.frequentUpdates = true

	if unitframes.showsmooth then
		health.Smooth = true
	end
	
	if unitframes.classcolor then
		health.colorTapping = true
		health.colorDisconnected = true
		health.colorReaction = true
		health.colorClass = true
		hBg.multiplier = 0.3
		
		self:Tag(name, '[Tukui:name_dps] [Tukui:dead][Tukui:afk]')
	else
		health.colorTapping = false
		health.colorDisconnected = false
		health.colorClass = false
		health.colorReaction = false
		health:SetStatusBarColor(.15, .15, .15)
		
		self:Tag(name, '[Tukui:getnamecolor][Tukui:name_dps] [Tukui:dead][Tukui:afk]')
	end
	
	
	----- [[    LFD Role Icon    ]] -----

	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:SetHeight(TukuiDB.Scale(6))
    LFDRole:SetWidth(TukuiDB.Scale(6))
	LFDRole:SetPoint("TOPLEFT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole

	
	----- [[    Raid Icons    ]] -----

	if unitframes.showsymbols then
		local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetHeight(TukuiDB.Scale(14))
		RaidIcon:SetWidth(TukuiDB.Scale(14))
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	
	----- [[    Aggro Coloring Function    ]] -----

	if unitframes.aggro then
		table.insert(self.__elements, TukuiDB.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
    end
	
	
	----- [[    Ready Check Icon    ]] -----

	-- local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	-- ReadyCheck:SetHeight(TukuiDB.Scale(12))
	-- ReadyCheck:SetWidth(TukuiDB.Scale(12))
	-- ReadyCheck:SetPoint('CENTER')
	-- self.ReadyCheck = ReadyCheck
	
	
	----- [[    Debuff Highlight    ]] ----- NEED TO DO THIS

	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
	
	
	----- [[    Phased Icon    ]] ----- 
	
	-- local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	-- picon:SetPoint('CENTER', self.Health)
	-- picon:SetSize(16, 16)
	-- picon:SetTexture[[Interface\AddOns\Tukui\media\textures\picon]]
	-- picon.Override = TukuiDB.Phasing
	-- self.PhaseIcon = picon

	
	----- [[    Range Alpha    ]] -----

	if unitframes.showrange then
		local range = {insideAlpha = 1, outsideAlpha = unitframes.raidalphaoor}
		self.Range = range
	end
	
	return self
end

oUF:RegisterStyle('TukuiDpsParty', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsParty")

	local party = self:SpawnHeader("oUF_TukuiDpsParty", nil, "solo,party", 
	'oUF-initialConfigFunction', [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute('initial-width'))
		self:SetHeight(header:GetAttribute('initial-height'))
	]],
	"initial-width", (TukuiCF["panels"].tinfowidth / 5) - 4.3,
	"initial-height", TukuiDB.Scale(24),	
	"showParty", true, 
	"showSolo", TukuiCF["unitframes"].show_solomode,
	"showPlayer", TukuiCF["unitframes"].showplayerinparty, 
	"groupFilter", "1,2,3,4,5,6,7,8", 
	"groupingOrder", "1,2,3,4,5,6,7,8", 
	"groupBy", "GROUP", 
	"xOffset", TukuiDB.Scale(5),
	"point", "LEFT"
	)
	party:SetPoint("BOTTOMLEFT", TukuiChatLeftTabs, "TOPLEFT", 1, 4)
end)