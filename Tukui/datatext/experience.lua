local xp = CreateFrame("Frame", "TukuiExperience", UIParent)
if TukuiCF["datatext"].stat_block then
	TukuiDB.CreatePanel(xp, 150, TukuiDB.infoheight, "TOPLEFT", TukuiTimeStats, "TOPLEFT", TukuiTimeStats:GetWidth() + 3, 0)
	xp:HookScript("OnUpdate", function(self) xp:SetPoint("TOPLEFT", TukuiTimeStats, "TOPLEFT", TukuiTimeStats:GetWidth() + 3, 0) end)
else
	TukuiDB.CreatePanel(xp, 150, TukuiDB.infoheight, "TOPLEFT", UIParent, "TOPLEFT", 8, -8)
end
xp:EnableMouse(true)

local bar = CreateFrame("StatusBar", "TukuiExperienceBar", xp)
bar:SetPoint("TOPLEFT", xp, TukuiDB.Scale(2), TukuiDB.Scale(-2))
bar:SetPoint("BOTTOMRIGHT", xp, TukuiDB.Scale(-2), TukuiDB.Scale(2))
bar:SetStatusBarTexture(TukuiCF["theme"].UI_Texture)
xp.bar = bar

local text = bar:CreateFontString(nil, "LOW")
text:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
text:SetPoint("CENTER", xp)
xp.text = text

local xpcolors = {
	{ r = .8, g = .2, b = .2, a = .7 }, -- Normal
	{ r = .2, g = .2, b = .8, a = .7 }, -- Rested
}

local function shortvalue(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e4 or value <= -1e4 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local function event(self, event, ...)
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		local currValue = UnitXP("player")
		local maxValue = UnitXPMax("player")
		local restXP = GetXPExhaustion()

		bar:SetMinMaxValues(0, maxValue)
		bar:SetValue(currValue)
		
		currValue = shortvalue(currValue)
		maxValue = shortvalue(maxValue)
		restXP = shortvalue(restXP)
		
		if restXP then
			text:SetText(currValue .. " / " .. maxValue .. " R: " .. restXP)
			
			bar:SetStatusBarColor(xpcolors[2].r, xpcolors[2].g, xpcolors[2].b, xpcolors[2].a)
		else
			text:SetText(currValue .. " / " .. maxValue)
			
			bar:SetStatusBarColor(xpcolors[1].r, xpcolors[1].g, xpcolors[1].b, xpcolors[1].a)
		end
	end
end

xp:HookScript("OnEnter", function()
	local currValue = UnitXP("player")
	local maxValue = UnitXPMax("player")
	local restXP = GetXPExhaustion()
	
	local perMax = maxValue - currValue
	local perGain = format("%.1f%%", (currValue / maxValue) * 100)
	local perRem = format("%.1f%%", (perMax / maxValue) * 100)
	
	local bars = format("%.1f", currValue / maxValue * 20)

	GameTooltip:SetOwner(xp, "ANCHOR_BOTTOMRIGHT", -xp:GetWidth(), -(xp:GetHeight() - 17))
	GameTooltip:ClearLines()
	GameTooltip:AddLine(cStart .. "Experience:|r")
	GameTooltip:AddLine" "
	GameTooltip:AddDoubleLine(cStart .. "Bars: |r", bars.." / 20", _, _, _, 1, 1, 1)
	GameTooltip:AddDoubleLine(cStart .. "Gained: |r", shortvalue(currValue).." ("..perGain..")", _, _, _, 1, 1, 1)
	GameTooltip:AddDoubleLine(cStart .. "Remaining: |r", shortvalue(maxValue - currValue).." ("..perRem..")", _, _, _, xpcolors[1].r, xpcolors[1].g, xpcolors[1].b)
	GameTooltip:AddDoubleLine(cStart .. "Total: |r", shortvalue(maxValue), _, _, _, 1, 1, 1)
	if restXP ~= nil and restXP > 0 then
		GameTooltip:AddDoubleLine(cStart .. "Rested: |r", shortvalue(restXP).." ("..format("%.f%%", restXP / maxValue * 100)..")", _, _, _, xpcolors[2].r, xpcolors[2].g, xpcolors[2].b)
	end
	
	GameTooltip:Show()
end)
xp:HookScript("OnLeave", function() GameTooltip:Hide() end)

xp:RegisterEvent("PLAYER_XP_UPDATE")
xp:RegisterEvent("PLAYER_LEVEL_UP")
xp:RegisterEvent("UPDATE_EXHAUSTION")
xp:RegisterEvent("PLAYER_ENTERING_WORLD")
xp:HookScript("OnEvent", event)
