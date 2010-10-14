if not TukuiCF["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomRight as bar #5
---------------------------------------------------------------------------

local TukuiBar5 = CreateFrame("Frame","TukuiBar5",UIParent) -- MultiBarBottomRight
TukuiBar5:SetAllPoints(TukuiActionBarBackground)
MultiBarBottomRight:SetParent(TukuiBar5)

for i= 1, 12 do
	local b = _G["MultiBarBottomRightButton"..i]
	local b2 = _G["MultiBarBottomRightButton"..i-1]
	b:ClearAllPoints()
	if i == 1 then
		if TukuiCF.actionbar.split_bar or TukuiCF.actionbar.rightbars == 2 then
			b:SetPoint("TOPLEFT", TukuiActionBarBackgroundRight)
		else
			if TukuiCF.actionbar.rightbars_vh then
				b:SetPoint("TOP", TukuiActionBarBackgroundRight)
			else
				b:SetPoint("LEFT", TukuiActionBarBackgroundRight)
			end
		end
	else
		if TukuiCF.actionbar.rightbars_vh then
			b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
		end
	end
end

-- hide it if needed
if (TukuiCF.actionbar.rightbars < 2) then
	TukuiBar5:Hide()
end