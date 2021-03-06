--------------------------------------------------------------------
-- player haste
--------------------------------------------------------------------

if TukuiCF["datatext"].haste and TukuiCF["datatext"].haste > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = TukuiDataLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
	TukuiDB.PP(TukuiCF["datatext"].haste, Text)

	local int = 1

	local function Update(self, t)
		spellhaste = GetCombatRating(20)
		rangedhaste = GetCombatRating(19)
		attackhaste = GetCombatRating(18)
		
		if attackhaste > spellhaste and select(2, UnitClass("Player")) ~= "HUNTER" then
			haste = attackhaste
		elseif select(2, UnitClass("Player")) == "HUNTER" then
			haste = rangedhaste
		else
			haste = spellhaste
		end
		
		int = int - t
		if int < 0 then
			Text:SetText(haste .. " " .. cStart .. tukuilocal.datatext_playerhaste)
			int = 1
		end     
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end