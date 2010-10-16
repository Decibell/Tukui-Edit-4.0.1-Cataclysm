if not TukuiCF["unitframes"].enable == true then return end


local normTex = TukuiCF["media"].normTex

local backdrop = {
	bgFile = theme_texture,
	insets = {top = -TukuiDB.mult, left = -TukuiDB.mult, bottom = -TukuiDB.mult, right = -TukuiDB.mult},
}

----- [[    Local Variables    ]] -----

local media = TukuiCF["media"]
local unitframes = TukuiCF["unitframes"]

local theme_font, theme_fsize, theme_fflag = TukuiCF["theme"].UF_Font, TukuiCF["theme"].UF_FSize, TukuiCF["theme"].UF_FFlag

local theme_texture = TukuiCF["theme"].UI_Texture

local unitframes_style = TukuiCF["unitframes"].V3_Style


----- [[    Layout    ]] -----

local function Shared(self, unit)
	self.colors = TukuiDB.oUF_colors
	
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = TukuiDB.SpawnMenu

	
	----- [[    Player and Target    ]] -----
	
	if (unit == "player" or unit == "target") then
		local health = CreateFrame("StatusBar", nil, self)
		health:SetHeight(TukuiDB.Scale(26))
		health:SetPoint("TOPLEFT", TukuiDB.mult, -TukuiDB.mult)
		health:SetPoint("TOPRIGHT", -TukuiDB.mult, TukuiDB.mult)
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

		local power = CreateFrame("StatusBar", nil, self)
		if unitframes_style then
			power:SetHeight(TukuiDB.Scale(3))
		else
			power:SetHeight(TukuiDB.Scale(4))
		end
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

		if unitframes.V3_Style then
			local panel = CreateFrame("Frame", nil, self)
			TukuiDB.CreatePanel(panel, 1, 17, "BOTTOM", self, "BOTTOM", 0, 0)
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:ClearAllPoints()
			panel:SetPoint("TOPLEFT", pBorder, "BOTTOMLEFT", 0, -3)
			panel:SetPoint("TOPRIGHT", pBorder, "BOTTOMRIGHT", 0, -3)
			self.panel = panel
			if theme_font == TukuiCF.media.font then panel:SetHeight(18) end
		end
		
		----- [[	Health and Power Colors  ]] -----
		
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
		end
		
		health.value = TukuiDB.SetFontString(health, theme_font, theme_fsize, theme_fflag)
		if unitframes_style then
			health.value:SetPoint("RIGHT", panel, "RIGHT", -4, 0)
		else
			health.value:SetPoint("RIGHT", health, "RIGHT", -4, 0)
		end
		health.PostUpdate = TukuiDB.PostUpdateHealth

		power.value = TukuiDB.SetFontString(health, theme_font, theme_fsize, theme_fflag)
		if unitframes_style then
			power.value:SetPoint("LEFT", panel, "LEFT", 5, 0)
		else
			power.value:SetPoint("LEFT", health, "LEFT", 5, 0)
		end
		power.PreUpdate = TukuiDB.PreUpdatePower
		power.PostUpdate = TukuiDB.PostUpdatePower

		
		----- [[    Target Unit Name    ]] -----

		if (unit == "target") then			
			local Name = health:CreateFontString(nil, "OVERLAY")
			if unitframes_style then
				Name:SetPoint("LEFT", panel, "LEFT", TukuiDB.Scale(4), 0)
			else
				Name:SetPoint("LEFT", health, "LEFT", TukuiDB.Scale(4), 0)
			end
			Name:SetJustifyH("LEFT")
			Name:SetFont(theme_font, theme_fsize, theme_fflag)

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
			self.Name = Name
		end
		

		----- [[    I set size like this, fuck new way!!    ]] -----
		
		if unitframes.V3_Style then
			self:SetAttribute('initial-height', ((health:GetHeight() + 4) + (power:GetHeight() + 4) + (panel:GetHeight()) + 6))
		else
			self:SetAttribute('initial-height', ((health:GetHeight() + 4) + (power:GetHeight() + 4) + 3))
		end
		self:SetAttribute('initial-width', TukuiDB.Scale(195))

		
		----- [[	Portraits	]] -----
		
		if unitframes.charportrait == true then
			local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetHeight(self:GetAttribute('initial-height'))
			portrait:SetWidth(60)
			portrait:SetAlpha(1)
			if unit == "player" then
				portrait:SetPoint("TOPRIGHT", hBorder, "TOPLEFT", -3, 0)
			elseif unit == "target" then
				portrait:SetPoint("TOPLEFT", hBorder, "TOPRIGHT", 3, 0)
			end
			table.insert(self.__elements, TukuiDB.HidePortrait)
			self.Portrait = portrait
		
			local poBg = CreateFrame("Frame", nil, portrait)
			poBg:SetFrameLevel(portrait:GetFrameLevel()-1)
			poBg:SetAllPoints()
			poBg:SetBackdrop({ bgFile = theme_texture, insets = { top = -TukuiDB.mult, left = -TukuiDB.mult, bottom = -TukuiDB.mult, right = -TukuiDB.mult } })
			poBg:SetBackdropColor(unpack(media.fadedbackdropcolor))
			portrait.bg = poBg
			
			local pFrame = CreateFrame("Frame", nil, portrait)
			TukuiDB.SkinFadedPanel(pFrame)
			pFrame:SetAllPoints()
			pFrame:SetFrameLevel(portrait:GetFrameLevel()+1)
			pFrame:SetBackdropColor(0, 0, 0, 0)
			TukuiDB.StyleInnerBorder(pFrame)
			TukuiDB.StyleOuterBorder(pFrame)
			portrait.frame = pFrame
		end

		
		if unit == "player" then
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:SetHeight(TukuiDB.Scale(19))
			Combat:SetWidth(TukuiDB.Scale(19))
			Combat:SetPoint("CENTER",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			FlashInfo = CreateFrame("Frame", "FlashInfo", self)
			FlashInfo:SetScript("OnUpdate", TukuiDB.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetToplevel(true)
			FlashInfo:SetAllPoints(health)
			FlashInfo.ManaLevel = TukuiDB.SetFontString(FlashInfo, theme_font, theme_fsize)
			FlashInfo.ManaLevel:SetPoint("CENTER", health, "CENTER", 0, 0)
			self.FlashInfo = FlashInfo
			
			local status = TukuiDB.SetFontString(health, theme_font, theme_fsize)
			status:SetPoint("CENTER", health, "CENTER", 0, 0)
			status:SetTextColor(0.69, 0.31, 0.31, 0)
			self.Status = status
			self:Tag(status, "[pvp]")
			
			local Leader = health:CreateTexture(nil, "OVERLAY")
			Leader:SetHeight(TukuiDB.Scale(14))
			Leader:SetWidth(TukuiDB.Scale(14))
			Leader:SetPoint("TOPLEFT", TukuiDB.Scale(2), TukuiDB.Scale(8))
			self.Leader = Leader
			
			local MasterLooter = health:CreateTexture(nil, "OVERLAY")
			MasterLooter:SetHeight(TukuiDB.Scale(14))
			MasterLooter:SetWidth(TukuiDB.Scale(14))
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", TukuiDB.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", TukuiDB.MLAnchorUpdate)

			
			----- [[    Threat Bar    ]] ----- 
			if unitframes.showthreat then
				local ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', TukuiDataBottom)
				ThreatBar:SetFrameLevel(5)
				ThreatBar:SetPoint("TOPLEFT", TukuiDataBottom, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				ThreatBar:SetPoint("BOTTOMRIGHT", TukuiDataBottom, TukuiDB.Scale(-2), TukuiDB.Scale(2))
			  
				ThreatBar:SetStatusBarTexture(theme_texture)
				ThreatBar:GetStatusBarTexture():SetHorizTile(false)
				ThreatBar:SetBackdrop(backdrop)
				ThreatBar:SetBackdropColor(0, 0, 0, 0)
		   
				ThreatBar.Text = TukuiDB.SetFontString(ThreatBar, theme_font, 8, theme_fflag)
				ThreatBar.Text:SetPoint("RIGHT", ThreatBar, "RIGHT", TukuiDB.Scale(-30), 0)
		
				ThreatBar.Title = TukuiDB.SetFontString(ThreatBar, theme_font, 8, theme_fflag)
				ThreatBar.Title:SetText(tukuilocal.unitframes_ouf_threattext)
				ThreatBar.Title:SetPoint("LEFT", ThreatBar, "LEFT", TukuiDB.Scale(30), 0)

				ThreatBar.bg = ThreatBar:CreateTexture(nil, 'BORDER')
				ThreatBar.bg:SetAllPoints(ThreatBar)
				ThreatBar.bg:SetTexture(0.1,0.1,0.1)
		   
				ThreatBar.useRawThreat = false
				self.ThreatBar = ThreatBar
			end

			
			----- [[    Druid Solar/Lunar Bar and Shapeshift Mana    ]] ----- 
			if TukuiDB.myclass == "DRUID" then
				CreateFrame("Frame"):SetScript("OnUpdate", function() TukuiDB.UpdateDruidMana(self) end)
				local DruidMana = TukuiDB.SetFontString(health, theme_font, theme_fsize, theme_fflag)
				DruidMana:SetTextColor(1, 0.49, 0.04)
				self.DruidMana = DruidMana
				
				local eclipseBar = CreateFrame('Frame', nil, self)
				eclipseBar:SetPoint("BOTTOMLEFT", hBorder, "TOPLEFT", 2, 5)
				eclipseBar:SetSize((self:GetAttribute("initial-width") - 2), TukuiDB.Scale(4))
				eclipseBar:SetFrameStrata("MEDIUM")
				eclipseBar:SetFrameLevel(8)
				eclipseBar:SetScript("OnShow", function() TukuiDB.EclipseDisplay(self, false) end)
				eclipseBar:SetScript("OnUpdate", function() TukuiDB.EclipseDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
				eclipseBar:SetScript("OnHide", function() TukuiDB.EclipseDisplay(self, false) end)
				
				local fuckthis = CreateFrame("Frame", nil, eclipseBar)
				fuckthis:SetPoint("TOPLEFT", eclipseBar, "TOPLEFT", -2, 2)
				fuckthis:SetPoint("BOTTOMRIGHT", eclipseBar, "BOTTOMRIGHT", 2, -2)
				TukuiDB.SkinPanel(fuckthis)
				fuckthis:SetFrameLevel(eclipseBar:GetFrameLevel() - 4) -- do this to get rid of shitty shadow inside unitframe, blargh

				local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
				lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
				lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
				lunarBar:SetStatusBarTexture(theme_texture)
				lunarBar:SetStatusBarColor(.30, .52, .90)
				eclipseBar.LunarBar = lunarBar

				local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
				solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
				solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
				solarBar:SetStatusBarTexture(theme_texture)
				solarBar:SetStatusBarColor(.80, .82,  .60)
				eclipseBar.SolarBar = solarBar

				-- lawl WHAT?
				-- local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
				-- eclipseBarText:SetPoint('CENTER', UIParent, "CENTER")
				-- eclipseBarText:SetPoint('BOTTOM', health)
				-- eclipseBarText:SetFont(media.pixelfont, 8, theme_fflag)
				-- eclipseBar.Text = eclipseBarText

				self.EclipseBar = eclipseBar
			end

			
			----- [[    Death Knight Runes    ]] -----
			if TukuiDB.myclass == "DEATHKNIGHT" and unitframes.runebar then
				local Runes = CreateFrame("Frame", nil, self)
				local rB = CreateFrame("Frame", nil, self)
				
				for i = 1, 6 do
					rB[i] = CreateFrame("Frame", nil, self)
					rB[i]:SetFrameLevel(health:GetFrameLevel() + 1)
					rB[i]:SetHeight(8)
					rB[i]:SetWidth((self:GetAttribute("initial-width") - 13) / 6)
					if (i == 1) then
						rB[i]:SetPoint("BOTTOMLEFT", hBorder, "TOPLEFT", 0, 3)
					else
						rB[i]:SetPoint("TOPLEFT", rB[i-1], "TOPRIGHT", 3, 0)
					end
					TukuiDB.SkinPanel(rB[i])

					Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
					Runes[i]:SetPoint("TOPLEFT", rB[i], "TOPLEFT", 2, -2)
					Runes[i]:SetPoint("BOTTOMRIGHT", rB[i], "BOTTOMRIGHT", -2, 2)
					Runes[i]:SetFrameLevel(rB:GetFrameLevel() + 1)
					Runes[i]:SetStatusBarTexture(theme_texture)			
				end

				self.Runes = Runes
			end
			

			----- [[    Shaman Totem Bar    ]] -----
			if TukuiDB.myclass == "SHAMAN" and unitframes.totemtimer then
				local TotemBar = {}
				TotemBar.Destroy = true
				
				local totemFrame = CreateFrame("Frame", nil, self)
				
				for i = 1, 4 do
					totemFrame[i] = CreateFrame("Frame", nil, self)
					totemFrame[i]:SetFrameLevel(health:GetFrameLevel() + 1)
					totemFrame[i]:SetHeight(8)
					totemFrame[i]:SetWidth((self:GetAttribute("initial-width") - 7) / 4)
					TukuiDB.SkinPanel(totemFrame[i])

					if i == 1 then
						totemFrame[i]:SetPoint("BOTTOMLEFT", hBorder, "TOPLEFT", 0, 3)
					else
						totemFrame[i]:SetPoint("TOPLEFT", totemFrame[i-1], "TOPRIGHT", 3, 0)
					end
					
					TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
					TotemBar[i]:SetPoint("TOPLEFT", totemFrame[i], "TOPLEFT", 2, -2)
					TotemBar[i]:SetPoint("BOTTOMRIGHT", totemFrame[i], "BOTTOMRIGHT", -2, 2)
					TotemBar[i]:SetFrameLevel(totemFrame:GetFrameLevel() + 2)
					TotemBar[i]:SetStatusBarTexture(theme_texture)
					TotemBar[i]:SetMinMaxValues(0, 1)

					TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
					TotemBar[i].bg:SetAllPoints(TotemBar[i])
					TotemBar[i].bg:SetTexture(normTex) -- sorry this needs to be this texture
					TotemBar[i].bg.multiplier = 0.3
				end
				
				self.TotemBar = TotemBar
			end

			
			----- [[    Warlock Shard Bar and Paladin Holy Bar    ]] -----
			if (TukuiDB.myclass == "WARLOCK" or TukuiDB.myclass == "PALADIN") then
				local bars = CreateFrame("Frame", nil, self)	
				local barFrame = CreateFrame("Frame", nil, self)
				
				for i = 1, 3 do		
					barFrame[i] = CreateFrame("Frame", nil, self)
					barFrame[i]:SetFrameLevel(health:GetFrameLevel() + 1)
					barFrame[i]:SetHeight(8)
					barFrame[i]:SetWidth((self:GetAttribute("initial-width") - 4) / 3)
					TukuiDB.SkinPanel(barFrame[i])
					
					if i == 1 then
						barFrame[i]:SetPoint("BOTTOMLEFT", hBorder, "TOPLEFT", 0, 3)
					else
						barFrame[i]:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 3, 0)
					end

					bars[i] = CreateFrame("StatusBar", self:GetName().."_Shard"..i, self)
					bars[i]:SetPoint("TOPLEFT", barFrame[i], "TOPLEFT", 2, -2)
					bars[i]:SetPoint("BOTTOMRIGHT", barFrame[i], "BOTTOMRIGHT", -2, 2)
					bars[i]:SetFrameLevel(barFrame:GetFrameLevel() + 1)
					bars[i]:SetStatusBarTexture(theme_texture)			

					bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')			
					bars[i].bg:SetTexture(bars[i]:GetStatusBarTexture())					
					bars[i].bg:SetAlpha(.15)

					local _, class = UnitClass(unit)
					if TukuiDB.myclass == "WARLOCK" then
						bars[i]:SetStatusBarColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
					elseif TukuiDB.myclass == "PALADIN" then
						bars[i]:SetStatusBarColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)
					end
				end
				
				if TukuiDB.myclass == "WARLOCK" then
					bars.Override = TukuiDB.UpdateShards				
					self.SoulShards = bars
				elseif TukuiDB.myclass == "PALADIN" then
					bars.Override = TukuiDB.UpdateHoly
					self.HolyPower = bars
				end
			end			
		end
		
		
		----- [[    Auras (Buffs/Debuffs)    ]] -----
		if (unit == "target" and unitframes.targetauras) or (unit == "player" and unitframes.playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			if (TukuiDB.myclass == "SHAMAN" or TukuiDB.myclass == "DEATHKNIGHT" or TukuiDB.myclass == "PALADIN" or TukuiDB.myclass == "WARLOCK") and (unitframes.playerauras) and (unit == "player") then
				buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 37)
			else
				buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 26)
			end

			buffs:SetHeight(22)
			buffs:SetWidth(self:GetAttribute('initial-width'))
			buffs.size = 22
			buffs.num = 8

			debuffs:SetHeight(22)
			debuffs:SetWidth(self:GetAttribute('initial-width'))
			debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 2, 3)
			debuffs.size = 22
			debuffs.num = 24

			buffs.spacing = 3
			buffs.initialAnchor = 'TOPLEFT'
			buffs.PostCreateIcon = TukuiDB.PostCreateAura
			buffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Buffs = buffs	

			debuffs.spacing = 3
			debuffs.initialAnchor = 'TOPRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end

		
		----- [[    Castbar    ]] -----
		if unitframes.unitcastbar then
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetStatusBarTexture(theme_texture)
			
			if unit == "player" then
				castbar:SetHeight(23)
				if unitframes.cbicons then
					castbar:SetPoint("BOTTOMLEFT", TukuiActionBarBackground, "TOPLEFT", TukuiDB.buttonsize + 5, 5)
				else
					castbar:SetPoint("BOTTOMLEFT", TukuiActionBarBackground, "TOPLEFT", TukuiDB.Scale(2), 5)
				end
				castbar:SetPoint("BOTTOMRIGHT", TukuiActionBarBackground, "TOPRIGHT", TukuiDB.Scale(-2), 5)
			else
				castbar:SetHeight(TukuiDB.Scale(21))
				castbar:SetWidth(TukuiDB.Scale(141))
				castbar:SetPoint("BOTTOM", TukuiActionBarBackground, "TOP", 0, TukuiDB.Scale(178))
			end
			
			local castbarBg = CreateFrame("Frame", nil, castbar)
			castbarBg:SetPoint("TOPLEFT", -TukuiDB.Scale(2), TukuiDB.Scale(2))
			castbarBg:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(2), -TukuiDB.Scale(2))
			castbarBg:SetFrameLevel(castbar:GetFrameLevel() - 1)
			TukuiDB.SkinPanel(castbarBg)
			
			castbar.CustomTimeText = TukuiDB.CustomCastTimeText
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.CheckCast
			castbar.PostChannelStart = TukuiDB.CheckChannel

			castbar.time = TukuiDB.SetFontString(castbar, theme_font, theme_fsize, theme_fflag)
			castbar.time:SetPoint("RIGHT", castbar, "RIGHT", TukuiDB.Scale(-4), 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = TukuiDB.SetFontString(castbar, theme_font, theme_fsize, theme_fflag)
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", TukuiDB.Scale(4), 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			if unit == "target" then
				castbar.Text:SetWidth(90)
				castbar.Text:SetHeight(20)
			end			

			----- [[    Castbar Icons   ]] -----
			if unitframes.cbicons then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:SetHeight(TukuiDB.buttonsize)
				castbar.button:SetWidth(TukuiDB.buttonsize)
				TukuiDB.SetTemplate(castbar.button)
				TukuiDB.StyleShadow(castbar.button)

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:SetPoint("TOPLEFT", castbar.button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			
				if unit == "player" then
					castbar.button:SetPoint("RIGHT", castbarBg, "LEFT", -3, 0)
				elseif unit == "target" then
					castbar.button:SetPoint("BOTTOM", castbarBg, "TOP", 0, 3)
				end
			end
			
			----- [[    Castbar Latency    ]] -----
			if unit == "player" and unitframes.cblatency  then
				castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
				castbar.safezone:SetTexture(theme_texture)
				castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
				castbar.SafeZone = castbar.safezone
			end

			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
		
		
		----- [[    Player Aggro    ]] -----
		if unitframes.playeraggro then
			table.insert(self.__elements, TukuiDB.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
		end
	end
	
	
	------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		local health = CreateFrame("StatusBar", nil, self)
		health:SetHeight(TukuiDB.Scale(22))
		health:SetPoint("TOPLEFT", TukuiDB.mult, -TukuiDB.mult)
		health:SetPoint("TOPRIGHT", -TukuiDB.mult, TukuiDB.mult)
		health:SetStatusBarTexture(theme_texture)
		self.Health = health
		
		local hBg = health:CreateTexture(nil, "BORDER")
		hBg:SetAllPoints()
		hBg:SetTexture(.05, .05, .05)
		self.Health.bg = hBg

		local hBorder = CreateFrame("Frame", nil, health)
		hBorder:SetFrameLevel(health:GetFrameLevel())
		hBorder:SetPoint("TOPLEFT", -2, 2)
		hBorder:SetPoint("BOTTOMRIGHT", 2, -2)
		TukuiDB.SkinPanel(hBorder)
		self.Health.border = hBorder		

		local power = CreateFrame("StatusBar", nil, health)
		power:SetHeight(TukuiDB.Scale(3))
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
		pBorder:SetFrameLevel(power:GetFrameLevel())
		pBorder:SetPoint("TOPLEFT", -2, 2)
		pBorder:SetPoint("BOTTOMRIGHT", 2, -2)
		TukuiDB.SkinPanel(pBorder)
		self.Power.border = pBorder

		
		----- [[	Health and Power Colors  ]] -----
		
		health.frequentUpdates = true
		power.frequentUpdates = true

		if unitframes.showsmooth == true then
			health.Smooth = true
			power.Smooth = true
		end

		if unitframes.classcolor == true then
			health.colorTapping = true
			health.colorDisconnected = true
			health.colorReaction = true
			health.colorClass = true
			hBg.multiplier = 0.3
			
			power.colorPower = true
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
		end
		
		
		----- [[    I set size like this, fuck new way!!    ]] -----
		
		self:SetAttribute('initial-height', ((health:GetHeight() + 4) + (power:GetHeight() + 4) + 3))
		self:SetAttribute('initial-width', TukuiDB.Scale(130))
		
		
		----- [[    Unit Name    ]] -----
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetFont(theme_font, theme_fsize, theme_fflag)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		----- [[    Auras (Buffs/Debuffs)    ]] -----
		if unitframes.totdebuffs then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 20
			debuffs.spacing = 2
			debuffs.num = 6

			debuffs:SetPoint("TOPLEFT", health, "TOPLEFT", -0.5, 24)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		local health = CreateFrame("StatusBar", nil, self)
		health:SetHeight(TukuiDB.Scale(22))
		health:SetPoint("TOPLEFT", TukuiDB.mult, -TukuiDB.mult)
		health:SetPoint("TOPRIGHT", -TukuiDB.mult, TukuiDB.mult)
		health:SetStatusBarTexture(theme_texture)
		self.Health = health
		
		local hBg = health:CreateTexture(nil, "BORDER")
		hBg:SetAllPoints()
		hBg:SetTexture(.05, .05, .05)
		self.Health.bg = hBg

		local hBorder = CreateFrame("Frame", nil, health)
		hBorder:SetFrameLevel(health:GetFrameLevel())
		hBorder:SetPoint("TOPLEFT", -2, 2)
		hBorder:SetPoint("BOTTOMRIGHT", 2, -2)
		TukuiDB.SkinPanel(hBorder)
		self.Health.border = hBorder		

		local power = CreateFrame("StatusBar", nil, health)
		power:SetHeight(TukuiDB.Scale(3))
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
		pBorder:SetFrameLevel(power:GetFrameLevel())
		pBorder:SetPoint("TOPLEFT", -2, 2)
		pBorder:SetPoint("BOTTOMRIGHT", 2, -2)
		TukuiDB.SkinPanel(pBorder)
		self.Power.border = pBorder

		
		----- [[	Health and Power Colors  ]] -----
		
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
			if TukuiDB.myclass == "HUNTER" then
				health.colorHappiness = true
			end
			hBg.multiplier = 0.3
			
			power.colorPower = true
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
		end
		
		
		----- [[    I set size like this, fuck new way!!    ]] -----
		
		self:SetAttribute('initial-height', ((health:GetHeight() + 4) + (power:GetHeight() + 4) + 3))
		self:SetAttribute('initial-width', TukuiDB.Scale(130))
		
		
		----- [[    Unit Name    ]] -----
		
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetFont(theme_font, theme_fsize, theme_fflag)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium] [Tukui:diffcolor][level]')
		self.Name = Name
		
		
		----- [[    Cast Bar    ]] -----

		if unitframes.unitcastbar then
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetStatusBarTexture(theme_texture)
			
			castbar.bg = castbar:CreateTexture(nil, "BORDER")
			castbar.bg:SetAllPoints(castbar)
			castbar.bg:SetTexture(theme_texture)
			castbar.bg:SetVertexColor(0.15, 0.15, 0.15)
			castbar:SetFrameLevel(6)
			castbar:SetPoint("TOPLEFT", health)
			castbar:SetPoint("BOTTOMRIGHT", health)
			
			castbar.CustomTimeText = TukuiDB.CustomCastTimeText
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.CheckCast
			castbar.PostChannelStart = TukuiDB.CheckChannel

			castbar.time = TukuiDB.SetFontString(castbar, theme_font, theme_fsize, theme_fflag)
			castbar.time:SetPoint("RIGHT", health, "RIGHT", TukuiDB.Scale(-4), 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = TukuiDB.SetFontString(castbar, theme_font, theme_fsize, theme_fflag)
			castbar.Text:SetPoint("LEFT", health, "LEFT", TukuiDB.Scale(4), 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			self.Castbar = castbar
			self.Castbar.Time = castbar.time
		end
		
		
		----- [[    Player Aggro    ]] -----
		
		if unitframes.playeraggro then
			table.insert(self.__elements, TukuiDB.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
		end

		-- update pet name, this should fix "UNKNOWN" pet names on pet unit.
		self:RegisterEvent("UNIT_PET", TukuiDB.UpdatePetInfo)
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		-- not done
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	if (unit == "focustarget") then
		-- not done
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and TukuiCF["arena"].unitframes == true) or (unit and unit:find("boss%d") and db.showboss == true) then
		-- not done
	end

	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"oUF_MainTank" or self:GetParent():GetName():match"oUF_MainAssist") then
		-- not done
	end

	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	-- because we can only use self here, and self is under all elements.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("TOP", 0, 8)
	self.RaidIcon = RaidIcon
	
	return self
end

------------------------------------------------------------------------
--	Default position of Tukui unitframes
------------------------------------------------------------------------

-- for lower reso
local adjustX = 0
local adjustY = 0
if TukuiDB.lowversion then adjustX = 80 end
if TukuiDB.lowversion then adjustY = 10 end

oUF:RegisterStyle('Tukz', Shared)

-- player
local player = oUF:Spawn('player', "oUF_Tukz_player")
player:SetPoint("BOTTOM", UIParent, "BOTTOM", -(TukuiDB.Scale(180) - adjustX), TukuiDB.Scale(167 + adjustY))
player:SetSize(player:GetAttribute('initial-width'), player:GetAttribute('initial-height'))


-- target
local target = oUF:Spawn('target', "oUF_Tukz_target")
target:SetPoint("BOTTOM", UIParent, "BOTTOM", (TukuiDB.Scale(180) - adjustX), TukuiDB.Scale(167 + adjustY))
target:SetSize(target:GetAttribute('initial-width'), target:GetAttribute('initial-height'))


-- target
local tot = oUF:Spawn('targettarget', "oUF_Tukz_targettarget")
if unitframes.charportrait then
	tot:SetPoint("TOPRIGHT", oUF_Tukz_target, "BOTTOMRIGHT", TukuiDB.Scale(63), TukuiDB.Scale(-3))
else
	tot:SetPoint("TOPRIGHT", oUF_Tukz_target, "BOTTOMRIGHT", 0, -TukuiDB.Scale(3))
end
tot:SetSize(tot:GetAttribute('initial-width'), tot:GetAttribute('initial-height'))


-- pet
local pet = oUF:Spawn('pet', "oUF_Tukz_pet")
if unitframes.charportrait then
	pet:SetPoint("TOPLEFT", oUF_Tukz_player, "BOTTOMLEFT", TukuiDB.Scale(-63), TukuiDB.Scale(-3))
else
	pet:SetPoint("TOPLEFT", oUF_Tukz_player, "BOTTOMLEFT", 0, -TukuiDB.Scale(3))
end
pet:SetSize(pet:GetAttribute('initial-width'), pet:GetAttribute('initial-height'))












-- if TukuiCF.arena.unitframes then
	-- local arena = {}
	-- for i = 1, 5 do
		-- arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
		-- if i == 1 then
			-- arena[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 252, 260)
		-- else
			-- arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 10)
		-- end
		-- arena[i]:SetSize(TukuiDB.Scale(200), TukuiDB.Scale(29))
	-- end
-- end

-- if db.showboss then
	-- for i = 1,MAX_BOSS_FRAMES do
		-- local t_boss = _G["Boss"..i.."TargetFrame"]
		-- t_boss:UnregisterAllEvents()
		-- t_boss.Show = TukuiDB.dummy
		-- t_boss:Hide()
		-- _G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		-- _G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	-- end

	-- local boss = {}
	-- for i = 1, MAX_BOSS_FRAMES do
		-- boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
		-- if i == 1 then
			-- boss[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 252, 260)
		-- else
			-- boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 10)             
		-- end
		-- boss[i]:SetSize(TukuiDB.Scale(200), TukuiDB.Scale(29))
	-- end
-- end

-- THIS NEED TO BE UPDATED FOR 4.0.1 BUT I'M RUNNING OUT OF TIME FOR A v12 RELEASE.
--[[
if db.maintank == true then
	local tank = oUF:SpawnHeader("oUF_MainTank", nil, 'raid, party, solo', 
		"showRaid", true, "groupFilter", "MAINTANK", "yOffset", 5, "point" , "BOTTOM",
		"template", "oUF_tukzMtt"
	)
	tank:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

if db.mainassist == true then
	local assist = oUF:SpawnHeader("oUF_MainAssist", nil, 'raid, party, solo', 
		"showRaid", true, "groupFilter", "MAINASSIST", "yOffset", 5, "point" , "BOTTOM",
		"template", "oUF_tukzMtt"
	)
	assist:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
end
--]]

-- this is just a fake party to hide Blizzard frame if no Tukui raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

------------------------------------------------------------------------
--	Just a command to test buffs/debuffs alignment
------------------------------------------------------------------------

local testui = TestUI or function() end
TestUI = function()
	testui()
	UnitAura = function()
		-- name, rank, texture, count, dtype, duration, timeLeft, caster
		return 'penancelol', 'Rank 2', 'Interface\\Icons\\Spell_Holy_Penance', random(5), 'Magic', 0, 0, "player"
	end
	if(oUF) then
		for i, v in pairs(oUF.units) do
			if(v.UNIT_AURA) then
				v:UNIT_AURA("UNIT_AURA", v.unit)
			end
		end
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"

------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" }
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end

