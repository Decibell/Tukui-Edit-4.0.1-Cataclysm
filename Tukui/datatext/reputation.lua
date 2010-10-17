local rep = CreateFrame("Frame", "TukuiReputation", UIParent)
if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
	TukuiDB.CreatePanel(rep, 150, TukuiDB.infoheight, "TOPLEFT", TukuiExperience, "TOPRIGHT", 3, 0)
else
	if TukuiCF["datatext"].stat_block then
		TukuiDB.CreatePanel(rep, 150, TukuiDB.infoheight, "TOPLEFT", TukuiTimeStats, "TOPRIGHT", 3, 0)
	else
		TukuiDB.CreatePanel(rep, 150, TukuiDB.infoheight, "TOPLEFT", UIParent, "TOPLEFT", 8, -8)
	end
end
rep:EnableMouse(true)

local bar = CreateFrame("StatusBar", "TukuiReputationBar", rep)
bar:SetPoint("TOPLEFT", rep, TukuiDB.Scale(2), TukuiDB.Scale(-2))
bar:SetPoint("BOTTOMRIGHT", rep, TukuiDB.Scale(-2), TukuiDB.Scale(2))
bar:SetStatusBarTexture(TukuiCF["theme"].UI_Texture)
rep.bar = bar

local text = bar:CreateFontString(nil, "LOW")
text:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
text:SetPoint("CENTER", rep)
rep.text = text

local factioncolors = {
	{ r = .9, g = .3, b = .3 }, -- Hated
	{ r = .7, g = .3, b = .3 }, -- Hostile
	{ r = .7, g = .3, b = .3 }, -- Unfriendly
	{ r = .8, g = .7, b = .4 }, -- Neutral
	{ r = .3, g = .7, b = .3 }, -- Friendly
	{ r = .3, g = .7, b = .3 }, -- Honored
	{ r = .3, g = .7, b = .3 }, -- Revered
	{ r = .3, g = .9, b = .3 }, -- Exalted
}

local function event(self, event, ...)
	local _, id, min, max, value = GetWatchedFactionInfo()
	local colors = factioncolors[id]
	
	bar:SetMinMaxValues(min, max)
	bar:SetValue(value)
	
	if id > 0 then
		text:SetText((value - min) .. " / " .. (max - min))
		bar:SetStatusBarColor(colors.r, colors.g, colors.b)
		
		rep:Show()
	else
		rep:Hide()
	end
end

rep:HookScript("OnEnter", function()
	local name, id, min, max, value = GetWatchedFactionInfo()
	local colors = factioncolors[id]
	
	local perMax = max - min
	local perGValue = value - min
	local perNValue = max - value
	
	local perGain = format("%.1f%%", (perGValue / perMax) * 100)
	local perNeed = format("%.1f%%", (perNValue / perMax) * 100)

	GameTooltip:SetOwner(rep, "ANCHOR_BOTTOMRIGHT", -rep:GetWidth(), -(rep:GetHeight() - 17))
	GameTooltip:ClearLines()
	GameTooltip:AddLine(cStart .. "Reputation:|r")
	GameTooltip:AddLine" "
	GameTooltip:AddDoubleLine(cStart .. "Faction: |r", name, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(cStart .. "Standing: |r", _G['FACTION_STANDING_LABEL'..id], 1, 1, 1, colors.r, colors.g, colors.b)
	GameTooltip:AddDoubleLine(cStart .. "Gained: |r", value - min .. " (" .. perGain .. ")", 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(cStart .. "Needed: |r", max - value .. " (" .. perNeed .. ")", 1, 1, 1, .8, .2, .2)
	GameTooltip:AddDoubleLine(cStart .. "Total: |r", max - min, 1, 1, 1, 1, 1, 1)
	
	GameTooltip:Show()
end)
rep:HookScript("OnLeave", function() GameTooltip:Hide() end)

rep:RegisterEvent("UPDATE_FACTION")
rep:RegisterEvent("PLAYER_ENTERING_WORLD")
rep:HookScript("OnEvent", event)
