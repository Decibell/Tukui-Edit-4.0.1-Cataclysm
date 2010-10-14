if not TukuiCF["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Shapeshift Bar, using Blizzard SS bar.
---------------------------------------------------------------------------

local DummyShift = CreateFrame("Frame",nil,UIParent)
local TukuiShift = CreateFrame("Frame","TukuiShiftBar",UIParent)
if TukuiCF["actionbar"].vertical_shapeshift then
	TukuiDB.CreatePanel(TukuiShift, TukuiDB.stancebuttonsize, TukuiDB.stancebuttonsize / 2, "TOPLEFT", 8, -40)
else
	TukuiDB.CreatePanel(TukuiShift, TukuiDB.stancebuttonsize / 2, TukuiDB.stancebuttonsize, "TOPLEFT", 8, -40)
end
TukuiShift:SetScript("OnEnter", TukuiDB.SetModifiedBackdrop)
TukuiShift:SetScript("OnLeave", TukuiDB.SetOriginalBackdrop)


-- shapeshift
ShapeshiftBarFrame:SetParent(DummyShift)
ShapeshiftBarFrame:SetWidth(0.00001)
for i=1, 10 do
	local b = _G["ShapeshiftButton"..i]
	local b2 = _G["ShapeshiftButton"..i-1]
	b:ClearAllPoints()
	if TukuiCF["actionbar"].vertical_shapeshift then
		b:SetPoint("TOP", b2, "BOTTOM", 0, -TukuiDB.buttonspacing)
	else
		b:SetPoint("LEFT", b2, "RIGHT", TukuiDB.buttonspacing, 0)
	end
end

-- hook setpoint
local function MoveShapeshift()
	ShapeshiftButton1:ClearAllPoints()
	if TukuiCF["actionbar"].vertical_shapeshift then
		ShapeshiftButton1:SetPoint("TOPLEFT", TukuiShiftBar, "BOTTOMLEFT", 0, -3)
	else
		ShapeshiftButton1:SetPoint("TOPLEFT", TukuiShiftBar, "TOPRIGHT", 3, 0)
	end
end
hooksecurefunc("ShapeshiftBar_Update", MoveShapeshift)

TukuiShift:SetAlpha(0)
TukuiShift:SetMovable(true)
TukuiShift:SetUserPlaced(true)
local ssmove = false
local function showmovebutton()
	if ssmove == false then
		ssmove = true
		TukuiShift:SetAlpha(1)
		TukuiShift:EnableMouse(true)
		TukuiShift:RegisterForDrag("LeftButton", "RightButton")
		TukuiShift:SetScript("OnDragStart", function(self) self:StartMoving() end)
		TukuiShift:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	elseif ssmove == true then
		ssmove = false
		TukuiShift:SetAlpha(0)
		TukuiShift:EnableMouse(false)
	end
end
SLASH_SHOWMOVEBUTTON1 = "/mss"
SlashCmdList["SHOWMOVEBUTTON"] = showmovebutton

-- hide it if not needed
if TukuiCF.actionbar.hideshapeshift then
	TukuiShift:Hide()
end