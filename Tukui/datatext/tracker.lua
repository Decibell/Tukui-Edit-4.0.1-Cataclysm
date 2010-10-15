--[[

	By Eclípsé

]]

if TukuiCF["datatext"].tracker and TukuiCF["datatext"].tracker > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
 	Stat:SetFrameLevel(3)

	local Text  = TukuiDataLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
	Text:SetWidth(100)
	TukuiDB.PP(TukuiCF["datatext"].tracker, Text)

	local function OnEvent(self)
	local tracking = false
		for i = 1, GetNumTrackingTypes() do
			local name, texture, active, category = GetTrackingInfo(i)
			if active then
				tracking = true
				if category == "spell" then
					Text:SetText(name)
				else
					Text:SetText(cStart .. "Tracking: " .. cEnd .. name)
				end
			end
		end
		if not tracking then
			Text:SetText(cStart .. "Not Tracking")
		end
		self:SetAllPoints(Text)
	end
	
	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("MINIMAP_UPDATE_TRACKING")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function(self) ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", TukuiDB.Scale(0), TukuiDB.Scale(0)) end)
end
