if not TukuiCF["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarLeft as bar #3
---------------------------------------------------------------------------

local TukuiBar3 = CreateFrame("Frame","TukuiBar3",UIParent) -- bottomrightbar
TukuiBar3:SetAllPoints(TukuiActionBarBackground)
MultiBarLeft:SetParent(TukuiBar3)

for i = 1, 12 do
	local b = _G["MultiBarLeftButton"..i]
	local b2 = _G["MultiBarLeftButton"..i-1]
	b:ClearAllPoints()
	if i == 1 then
		if TukuiCF["actionbar"].split_bar then
			b:SetPoint("BOTTOMLEFT", TukuiLeftSplitBarBackground)
		else
			b:SetPoint("TOPLEFT", TukuiActionBarBackgroundRight)
		end
	else
		if TukuiCF["actionbar"].split_bar then
			if i == 4 then
				b:SetPoint("BOTTOMLEFT", TukuiRightSplitBarBackground)
			elseif i == 7 then
				b:SetPoint("BOTTOMLEFT", MultiBarLeftButton1, "TOPLEFT", 0, TukuiDB.buttonspacing)
			elseif i == 10 then
				b:SetPoint("BOTTOMLEFT", MultiBarLeftButton4, "TOPLEFT", 0, TukuiDB.buttonspacing)
			else
				b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
			end
		else
			if TukuiCF.actionbar.rightbars_vh then
				b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
			else
				b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
			end
		end
	end
end

if (TukuiCF.actionbar.split_bar and TukuiCF.actionbar.bottomrows == 1) then
	for i = 7, 12 do
		local b = _G["MultiBarLeftButton"..i]
		b:SetAlpha(0)
		b:SetScale(0.0001)
	end
end

-- hide it if needed
-- if (TukuiCF.actionbar.bottomrows == 1 and TukuiCF.actionbar.rightbars < 3) or (TukuiDB.lowversion and TukuiCF.actionbar.rightbars < 3) then
	-- TukuiBar3:Hide()
-- end