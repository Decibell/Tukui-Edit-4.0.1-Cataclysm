if TukuiCF["datatext"].wintergrasp and TukuiCF["datatext"].wintergrasp > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
 	Stat:SetFrameLevel(3)

	local Text  = TukuiDataLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
	TukuiDB.PP(TukuiCF["datatext"].wintergrasp, Text)

	local function Update(self)
		local wgtime = GetWintergraspWaitTime() or nil
		local inInstance, instanceType = IsInInstance()
			if not ( instanceType == "none" ) then
				Text:SetText(cStart .. "WG: " .. cEnd .. QUEUE_TIME_UNAVAILABLE)
			elseif wgtime == nil then
				Text:SetText(cStart .. "WG: " .. cEnd .. WINTERGRASP_IN_PROGRESS)
			else
				Text:SetText(cStart .. "WG: " .. cEnd .. SecondsToTime(wgtime))
			end
		self:SetAllPoints(Text)
	end
	
	Stat:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, TukuiDB.Scale(6));
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, TukuiDB.mult)
		GameTooltip:ClearLines()

		local control = QUEUE_TIME_UNAVAILABLE
		inInstance, instanceType = IsInInstance()
		if not ( instanceType == "none" ) then
			wgtime = QUEUE_TIME_UNAVAILABLE
		elseif wgtime == nil then
			wgtime = WINTERGRASP_IN_PROGRESS
		else
			SetMapByID(485)
			for i = 1, GetNumMapLandmarks() do
				local index = select(3, GetMapLandmarkInfo(i))
				if index == 46 then
					control = "|cFF69CCF0"..FACTION_ALLIANCE.."|r"
				elseif index == 48 then
					control = "|cFFC41F3B"..FACTION_HORDE.."|r"
				end
			end
			SetMapToCurrentZone()
		end
		if TukuiDB.level >= 68 then
			GameTooltip:AddDoubleLine(cStart .. tukuilocal.datatext_control .. cEnd, control, _, _, _, 1, 1, 1)
		end
		GameTooltip:Show()
	end)
	
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:SetScript("OnUpdate", Update)
	Stat:SetScript("OnMouseDown", function() ToggleFrame(WorldMapFrame) SetMapZoom(4 , 11) end)
	Update(Stat, 10)
end
