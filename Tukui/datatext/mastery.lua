----- [[    Mastery by Eclípsé    ]] -----

if TukuiCF["datatext"].mastery and TukuiCF["datatext"].mastery > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = TukuiDataLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
	TukuiDB.PP(TukuiCF["datatext"].mastery, Text)

	local int = 1

	local function Update(self, t)
		int = int - t
		mastery = GetMastery()

		if int < 0 then
			Text:SetText(format("%.2f", mastery) .. "%" .. cStart .. " Mastery")
			int = 1
		end     
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end