if TukuiCF["actionbar"].enable ~= true then return end

-- we just use default totem bar for shaman
-- we parent it to our shapeshift bar.
-- This is approx the same script as it was in WOTLK Tukui version.

if TukuiDB.myclass == "SHAMAN" then
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(DummyShiftBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("TOPLEFT", TukuiShiftBar, "TOPRIGHT", 3, 6)
 
		for i = 1, 4 do
			local b = _G["MultiCastSlotButton"..i]
			local b2 = _G["MultiCastActionButton"..i]
 
			b:ClearAllPoints()
			b:SetAllPoints(b2)
		end
 
		MultiCastActionBarFrame.SetParent = TukuiDB.dummy
		MultiCastActionBarFrame.SetPoint = TukuiDB.dummy
		MultiCastRecallSpellButton.SetPoint = TukuiDB.dummy -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405
	end
end