------------------------------------------------------
--- Hit Rating
------------------------------------------------------
 
if TukuiCF["datatext"].hitrating and TukuiCF["datatext"].hitrating > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
 	Stat:SetFrameLevel(3)

	local Text  = TukuiDataLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
	TukuiDB.PP(TukuiCF["datatext"].hitrating, Text)
 
	local int = 1
 
	local function Update(self, t)
	int = int - t
	local base, posBuff, negBuff = UnitAttackPower("player");
	local effective = base + posBuff + negBuff;
	local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player");
	local Reffective = Rbase + RposBuff + RnegBuff;
 
	Rattackpwr = Reffective
	spellpwr = GetSpellBonusDamage(7)
	attackpwr = effective
 
	if int < 0 then
			if attackpwr > spellpwr and select(2, UnitClass("Player")) ~= "HUNTER" then
				Text:SetText(format("%.2f", GetCombatRatingBonus(6)).."% ".. cStart .. "Hit" .. cEnd)
			elseif select(2, UnitClass("Player")) == "HUNTER" then
				Text:SetText(format("%.2f", GetCombatRatingBonus(7)).."% " .. cStart .. "Hit" .. cEnd)
			else
				Text:SetText(format("%.2f", GetCombatRatingBonus(8)).."% " .. cStart .. "Hit" .. cEnd)
			end
			int = 1
		end
	end
 
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end