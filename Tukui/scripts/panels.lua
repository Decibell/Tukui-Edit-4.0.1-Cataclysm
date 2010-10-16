-- ACTION BAR PANEL
TukuiDB.buttonsize = TukuiDB.Scale(27)
TukuiDB.petbuttonsize = TukuiDB.Scale(27)
TukuiDB.stancebuttonsize = TukuiDB.Scale(27)

TukuiDB.buttonspacing = TukuiDB.Scale(3)

----- [[    Local Variables    ]] -----

local panels = TukuiCF["panels"]
local chat = TukuiCF["chat"]

-- temp -- fucking move this shit later
if TukuiCF["actionbar"].rightbars_vh then
	TukuiCF["panels"].tinfowidth = 350
else
	TukuiCF["panels"].tinfowidth = (TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 11) -- force this if vertical rightbars are disabled so people don't go "OMG ACTION BUTTONS DON'T FIT SIDE/CHAT PANELS"
end

TukuiDB.infoheight = 19


----- [[    Top "Art" Panel    ]] -----

local tbar = CreateFrame("Frame", "TukuiTopBar", UIParent)
TukuiDB.CreatePanel(tbar, (GetScreenWidth() * UIParent:GetEffectiveScale()) * 2, 22, "TOP", UIParent, "TOP", 0, 5)
tbar:SetFrameLevel(0)


----- [[    Bottom "Art" Panel    ]] -----

local bbar = CreateFrame("Frame", "TukuiBottomBar", UIParent)
TukuiDB.CreatePanel(bbar, (GetScreenWidth() * UIParent:GetEffectiveScale()) * 2, 22, "BOTTOM", UIParent, "BOTTOM", 0, -5)
bbar:SetFrameLevel(0)

----- [[    Bottom Data Panel    ]] -----

if TukuiCF["panels"].bottom_panels then
	local dbottom = CreateFrame("Frame", "TukuiDataBottom", UIParent)
	TukuiDB.CreatePanel(dbottom, (TukuiDB.buttonsize * 12 + TukuiDB.buttonspacing * 11), TukuiDB.infoheight, "BOTTOM", UIParent, "BOTTOM", 0, 8)
end

----- [[    Left Data Panel    ]] -----

local dleft = CreateFrame("Frame", "TukuiDataLeft", UIParent)
TukuiDB.CreatePanel(dleft, TukuiCF["panels"].tinfowidth, TukuiDB.infoheight, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 8, 8)


----- [[    Right Data Panel    ]] -----

local dright = CreateFrame("Frame", "TukuiDataRight", UIParent)
TukuiDB.CreatePanel(dright, TukuiCF["panels"].tinfowidth, TukuiDB.infoheight, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -8, 8)


----- [[    Split Bar Data Panels    ]] -----

if TukuiCF["actionbar"].split_bar and TukuiCF["panels"].bottom_panels then
	local leftsd = CreateFrame("Frame", "TukuiLeftSplitBarData", UIParent)
	TukuiDB.CreatePanel(leftsd, (TukuiDB.buttonsize * 3 + TukuiDB.buttonspacing * 2), TukuiDB.infoheight, "RIGHT", TukuiDataBottom, "LEFT", -3, 0)

	local rightsd = CreateFrame("Frame", "TukuiRightSplitBarData", UIParent)
	TukuiDB.CreatePanel(rightsd, (TukuiDB.buttonsize * 3 + TukuiDB.buttonspacing * 2), TukuiDB.infoheight, "LEFT", TukuiDataBottom, "RIGHT", 3, 0)
end
	
----- [[    Left Chat Background and Tabs    ]] -----

local cleft = CreateFrame("Frame", "TukuiChatLeft", UIParent)
TukuiDB.CreateFadedPanel(cleft, TukuiCF["panels"].tinfowidth, TukuiCF["chat"].chatheight - 3, "BOTTOM", dleft, "TOP", 0, 3)

local cltabs = CreateFrame("Frame", "TukuiChatLeftTabs", UIParent)
TukuiDB.CreateFadedPanel(cltabs, TukuiCF["panels"].tinfowidth, TukuiDB.infoheight + 2, "BOTTOM", cleft, "TOP", 0, 3)


----- [[    Right Chat Background and Tabs    ]] -----

local cright = CreateFrame("Frame", "TukuiChatRight", UIParent)
TukuiDB.CreateFadedPanel(cright, TukuiCF["panels"].tinfowidth, TukuiCF["chat"].chatheight - 3, "BOTTOM", dright, "TOP", 0, 3)

local crtabs = CreateFrame("Frame", "TukuiChatRightTabs", UIParent)
TukuiDB.CreateFadedPanel(crtabs, TukuiCF["panels"].tinfowidth, TukuiDB.infoheight + 2, "BOTTOM", cright, "TOP", 0, 3)


----- [[    Dummy Frames    ]] -----

local barbg = CreateFrame("Frame", "TukuiActionBarBackground", UIParent)
barbg:SetWidth((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 11))
if TukuiCF["panels"].bottom_panels then
	barbg:SetPoint("BOTTOM", TukuiDataBottom, "TOP", 0, 3)
else
	barbg:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 8)
end
if TukuiCF["actionbar"].bottomrows == 2 then
	barbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 1))
else
	barbg:SetHeight(TukuiDB.buttonsize)
end


if TukuiCF["actionbar"].split_bar then
	local leftsbg = CreateFrame("Frame", "TukuiLeftSplitBarBackground", UIParent)
	leftsbg:SetWidth((TukuiDB.buttonsize * 3) + (TukuiDB.buttonspacing * 2))
	if TukuiCF["panels"].bottom_panels then
		leftsbg:SetPoint("BOTTOM", TukuiLeftSplitBarData, "TOP", 0, 3)
	else
		leftsbg:SetPoint("RIGHT", barbg, "LEFT", -3, 0)
	end

	if TukuiCF["actionbar"].bottomrows == 2 then
		leftsbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 1))
	else
		leftsbg:SetHeight(TukuiDB.buttonsize)
	end

	local rightsbg = CreateFrame("Frame", "TukuiRightSplitBarBackground", UIParent)
	rightsbg:SetWidth((TukuiDB.buttonsize * 3) + (TukuiDB.buttonspacing * 2))
	if TukuiCF["panels"].bottom_panels then
		rightsbg:SetPoint("BOTTOM", TukuiRightSplitBarData, "TOP", 0, 3)
	else
		rightsbg:SetPoint("LEFT", barbg, "RIGHT", 3, 0)
	end

	if TukuiCF["actionbar"].bottomrows == 2 then
		rightsbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 1))
	else
		rightsbg:SetHeight(TukuiDB.buttonsize)
	end
end


local rightbbg = CreateFrame("Frame", "TukuiActionBarBackgroundRight", UIParent)
rightbbg:SetPoint("BOTTOMRIGHT", crtabs, "TOPRIGHT", 0, 3)
if TukuiCF["actionbar"].rightbars_vh then
	rightbbg:SetHeight((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 11))
	if TukuiCF["actionbar"].rightbars == 1 then
		rightbbg:SetWidth(TukuiDB.buttonsize)
	elseif TukuiCF["actionbar"].split_bar or TukuiCF["actionbar"].rightbars == 2 then
		rightbbg:SetWidth((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 1))
	elseif not TukuiCF["actionbar"].split_bar and TukuiCF["actionbar"].rightbars == 3 then
		rightbbg:SetWidth((TukuiDB.buttonsize * 3) + (TukuiDB.buttonspacing * 2))
	else
		rightbbg:Hide()
	end
else
	rightbbg:SetWidth((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 11))
	if TukuiCF["actionbar"].rightbars == 1 then
		rightbbg:SetHeight(TukuiDB.buttonsize)
	elseif TukuiCF["actionbar"].split_bar or TukuiCF["actionbar"].rightbars == 2 then
		rightbbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 1))
	elseif not TukuiCF["actionbar"].split_bar and TukuiCF["actionbar"].rightbars == 3 then
		rightbbg:SetHeight((TukuiDB.buttonsize * 3) + (TukuiDB.buttonspacing * 2))
	else
		rightbbg:Hide()
	end
end


local petbg = CreateFrame("Frame", "TukuiPetActionBarBackground", UIParent)
if TukuiCF["actionbar"].rightbars_vh then
	petbg:SetWidth(TukuiDB.petbuttonsize)
	petbg:SetHeight((TukuiDB.petbuttonsize * NUM_PET_ACTION_SLOTS) + (TukuiDB.buttonspacing * 9))

	if TukuiCF["actionbar"].rightbars > 0 then
		petbg:SetPoint("BOTTOMRIGHT", rightbbg, "BOTTOMLEFT", -3, 0)
	else
		petbg:SetPoint("BOTTOMRIGHT", crtabs, "TOPRIGHT", 0, 3)
	end
else
	petbg:SetWidth((TukuiDB.petbuttonsize * NUM_PET_ACTION_SLOTS) + (TukuiDB.buttonspacing * 9))
	petbg:SetHeight(TukuiDB.petbuttonsize)

	if TukuiCF["actionbar"].rightbars > 0 then
		petbg:SetPoint("BOTTOMRIGHT", rightbbg, "TOPRIGHT", 0, 3)
	else
		petbg:SetPoint("BOTTOMRIGHT", crtabs, "TOPRIGHT", 0, 3)
	end
end
	
----- [[    S    ]] -----
----- [[    S    ]] -----










-- set left and right info panel width
-- TukuiCF["panels"] = {["tinfowidth"] = 370}

-- LEFT VERTICAL LINE
-- local ileftlv = CreateFrame("Frame", "TukuiInfoLeftLineVertical", barbg)
-- TukuiDB.CreatePanel(ileftlv, 2, 130, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", TukuiDB.Scale(22), TukuiDB.Scale(30))

-- RIGHT VERTICAL LINE
-- local irightlv = CreateFrame("Frame", "TukuiInfoRightLineVertical", barbg)
-- TukuiDB.CreatePanel(irightlv, 2, 130, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", TukuiDB.Scale(-22), TukuiDB.Scale(30))

-- CUBE AT LEFT, ACT AS A BUTTON (CHAT MENU)
-- local cubeleft = CreateFrame("Frame", "TukuiCubeLeft", barbg)
-- TukuiDB.CreatePanel(cubeleft, 10, 10, "BOTTOM", ileftlv, "TOP", 0, 0)
-- cubeleft:EnableMouse(true)
-- cubeleft:SetScript("OnMouseDown", function(self, btn)
	-- if TukuiInfoLeftBattleGround then
		-- if btn == "RightButton" then
			-- if TukuiInfoLeftBattleGround:IsShown() then
				-- TukuiInfoLeftBattleGround:Hide()
			-- else
				-- TukuiInfoLeftBattleGround:Show()
			-- end
		-- end
	-- end
	
	-- if btn == "LeftButton" then	
		-- ToggleFrame(ChatMenu)
	-- end
-- end)

-- CUBE AT RIGHT, ACT AS A BUTTON (CONFIGUI or BG'S)
-- local cuberight = CreateFrame("Frame", "TukuiCubeRight", barbg)
-- TukuiDB.CreatePanel(cuberight, 10, 10, "BOTTOM", irightlv, "TOP", 0, 0)
-- if TukuiCF["bags"].enable then
	-- cuberight:EnableMouse(true)
	-- cuberight:SetScript("OnMouseDown", function(self)
		-- ToggleKeyRing()
	-- end)
-- end

-- HORIZONTAL LINE LEFT
-- local ltoabl = CreateFrame("Frame", "TukuiLineToABLeft", barbg)
-- TukuiDB.CreatePanel(ltoabl, 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
-- ltoabl:ClearAllPoints()
-- ltoabl:SetPoint("BOTTOMLEFT", ileftlv, "BOTTOMLEFT", 0, 0)
-- ltoabl:SetPoint("RIGHT", barbg, "BOTTOMLEFT", TukuiDB.Scale(-1), TukuiDB.Scale(17))

-- HORIZONTAL LINE RIGHT
-- local ltoabr = CreateFrame("Frame", "TukuiLineToABRight", barbg)
-- TukuiDB.CreatePanel(ltoabr, 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
-- ltoabr:ClearAllPoints()
-- ltoabr:SetPoint("LEFT", barbg, "BOTTOMRIGHT", TukuiDB.Scale(1), TukuiDB.Scale(17))
-- ltoabr:SetPoint("BOTTOMRIGHT", irightlv, "BOTTOMRIGHT", 0, 0)

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "TukuiInfoLeft", barbg)
-- TukuiDB.CreatePanel(ileft, TukuiCF["panels"].tinfowidth, 23, "LEFT", ltoabl, "LEFT", TukuiDB.Scale(14), 0)
-- ileft:SetFrameLevel(2)
-- ileft:SetFrameStrata("BACKGROUND")

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "TukuiInfoRight", barbg)
-- TukuiDB.CreatePanel(iright, TukuiCF["panels"].tinfowidth, 23, "RIGHT", ltoabr, "RIGHT", TukuiDB.Scale(-14), 0)
-- iright:SetFrameLevel(2)
-- iright:SetFrameStrata("BACKGROUND")


--BATTLEGROUND STATS FRAME
-- if TukuiCF["datatext"].battleground == true then
	-- local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	-- TukuiDB.CreatePanel(bgframe, 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	-- bgframe:SetAllPoints(ileft)
	-- bgframe:SetFrameStrata("LOW")
	-- bgframe:SetFrameLevel(0)
	-- bgframe:EnableMouse(true)
-- end