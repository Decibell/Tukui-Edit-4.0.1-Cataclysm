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
	health:SetPoint("TOPRIGHT", -TukuiDB.mult, TukuiDB.mult)
	health:SetHeight(30)
	health:SetStatusBarTexture(theme_texture)
	self.Health = health
	
	if unitframes.health_vertical == true then
		health:SetOrientation('VERTICAL')
	end

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

	
	----- [[    Power Bar / Background / Border    ]] -----

	local power = CreateFrame("StatusBar", nil, self)
	power:SetHeight(4)
	power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -7)
	power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -7)
	power:SetStatusBarTexture(theme_texture)
	self.Power = power
	
	local pBg = power:CreateTexture(nil, "BORDER")
	pBg:SetAllPoints()
	pBg:SetTexture(theme_texture)
	pBg.multiplier = 0.3
	self.Power.bg = pBg
	
	local pBorder = CreateFrame("Frame", nil, power)
	pBorder:SetFrameLevel(power:GetFrameLevel() - 1)
	pBorder:SetPoint("TOPLEFT", -2, 2)
	pBorder:SetPoint("BOTTOMRIGHT", 2, -2)
	TukuiDB.SkinPanel(pBorder)
	self.Power.border = pBorder

	
	----- [[    Unit Name    ]] -----

	local name = health:CreateFontString(nil, "OVERLAY")
	name:SetFont(theme_font, theme_fsize, theme_fflag)
	local ns = 0
	local hs = 0
	if theme_font == TukuiCF.media.pixelfont then ns = 3 end	
	if unitframes.health_deficit then hs = 6 end
	name:SetPoint("CENTER", health, "CENTER", ns, hs)
	self.Name = name
	
	
	----- [[    Color Health / Power Bars    ]] -----

	health.frequentUpdates = true
	power.frequentUpdates = true

	if unitframes.showsmooth then
		health.Smooth = true
		power.Smooth = true
	end

	if unitframes.classcolor then
		health.colorTapping = true
		health.colorDisconnected = true
		health.colorReaction = true
		health.colorClass = true
		hBg.multiplier = 0.3
		
		power.colorPower = true
		
		self:Tag(name, '[Tukui:name_heal] [Tukui:dead][Tukui:afk]')
	else
		health.colorTapping = false
		health.colorDisconnected = false
		health.colorClass = false
		health.colorReaction = false
		health:SetStatusBarColor(.15, .15, .15)
		
		power.colorTapping = true
		power.colorDisconnected = true
		power.colorClass = true
		power.colorReaction = true
		
		self:Tag(name, '[Tukui:getnamecolor][Tukui:name_heal] [Tukui:dead][Tukui:afk]')
	end
	
	
	----- [[    Health Deficit Text   ]] -----
	
	if unitframes.health_deficit then
		health.value = health:CreateFontString(nil, "OVERLAY")
		health.value:SetPoint("CENTER", health, "CENTER", 0, -(hs + 1))
		health.value:SetFont(theme_font, theme_fsize, theme_fflag)
		health.value:SetTextColor(1,1,1)
		self.Health.value = health.value
		health.PostUpdate = TukuiDB.PostUpdateHealthRaid
	end
	
	
	----- [[    Leader Icon    ]] -----

    -- local leader = health:CreateTexture(nil, "OVERLAY") -- not tested
    -- leader:SetHeight(TukuiDB.Scale(12))
    -- leader:SetWidth(TukuiDB.Scale(12))
    -- leader:SetPoint("TOPLEFT", 0, 6)
	-- self.Leader = leader
	
	
	----- [[    LFD Role Icon    ]] -----

    local LFDRole = health:CreateTexture(nil, "OVERLAY") -- not tested
    LFDRole:SetHeight(TukuiDB.Scale(6))
    LFDRole:SetWidth(TukuiDB.Scale(6))
	LFDRole:SetPoint("TOPRIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(-2))
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	
	----- [[    Master Looter Icon    ]] -----

    -- local MasterLooter = health:CreateTexture(nil, "OVERLAY") -- not tested
    -- MasterLooter:SetHeight(TukuiDB.Scale(12))
    -- MasterLooter:SetWidth(TukuiDB.Scale(12))
	-- self.MasterLooter = MasterLooter
    -- self:RegisterEvent("PARTY_LEADER_CHANGED", TukuiDB.MLAnchorUpdate)
    -- self:RegisterEvent("PARTY_MEMBERS_CHANGED", TukuiDB.MLAnchorUpdate)
	
	
	----- [[    Raid Icons    ]] -----

	if unitframes.showsymbols == true then
		local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:SetHeight(TukuiDB.Scale(14))
		RaidIcon:SetWidth(TukuiDB.Scale(14))
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end

	
	----- [[    Aggro Coloring Function    ]] -----

	if unitframes.aggro == true then
		table.insert(self.__elements, TukuiDB.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
    end
	
	
	----- [[    Ready Check Icon    ]] -----

	--local ReadyCheck = self.Power:CreateTexture(nil, "OVERLAY")
	--ReadyCheck:SetHeight(TukuiDB.Scale(12))
	--ReadyCheck:SetWidth(TukuiDB.Scale(12))
	--ReadyCheck:SetPoint('CENTER')
	--self.ReadyCheck = ReadyCheck
	
	
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
	
	
	----- [[    HealComm    ]] -----

	-- if TukuiCF["unitframes"].healcomm then
		-- local mhpb = CreateFrame('StatusBar', nil, self.Health)
		-- mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		-- mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		-- mhpb:SetWidth(150)
		-- mhpb:SetStatusBarTexture(normTex)
		-- mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		-- local ohpb = CreateFrame('StatusBar', nil, self.Health)
		-- ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		-- ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		-- ohpb:SetWidth(150)
		-- ohpb:SetStatusBarTexture(normTex)
		-- ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		-- self.HealPrediction = {
			-- myBar = mhpb,
			-- otherBar = ohpb,
			-- maxOverflow = 1,
		-- }
	-- end
	
	return self
end

oUF:RegisterStyle('TukuiHealModeRaid', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiHealModeRaid")

	local raid = self:SpawnHeader("oUF_TukuiHealModeRaid", nil, "raid", 
	'oUF-initialConfigFunction', [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute('initial-width'))
		self:SetHeight(header:GetAttribute('initial-height'))
	]],
	"initial-width", 70,
	"initial-height", 43,	
	"showRaid", true, 
	"groupFilter", "1,2,3,4,5,6,7,8", 
	"groupingOrder", "1,2,3,4,5,6,7,8", 
	"groupBy", "GROUP", 
	"xOffset", 5,
	"point", "LEFT",
	"maxColumns", 5,
	"unitsPerColumn", 5,
	"columnSpacing", TukuiDB.Scale(5),
	"columnAnchorPoint", "BOTTOM"
	)	
	raid:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(169))
end)