if not TukuiCF["map"].enable == true then return end


-- fucking fix this shit later ecl�ps�

----------------------------------------------
-- Settings/Variables
----------------------------------------------

local mapscale = WORLDMAP_WINDOWED_SIZE
local infoHeight = TukuiDB.infoheight


local map = CreateFrame("Frame", nil, WorldMapDetailFrame)
TukuiDB.SkinPanel(map)

----------------------------------------------
-- Setup map title frame
----------------------------------------------

local mapTitle = CreateFrame ("Frame", nil, WorldMapDetailFrame)
TukuiDB.SkinFadedPanel(mapTitle)
mapTitle:SetHeight(infoHeight)



local addon = CreateFrame('Frame')
addon:RegisterEvent('PLAYER_LOGIN')
addon:RegisterEvent("PARTY_MEMBERS_CHANGED")
addon:RegisterEvent("RAID_ROSTER_UPDATE")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")


----------------------------------------------
-- Setup map lock button/text/script
----------------------------------------------

local mapLock = CreateFrame ("Frame", nil, WorldMapDetailFrame)
mapLock:SetScale(1 / mapscale)
mapLock:SetHeight(infoHeight)
mapLock:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "TOPRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(5))
TukuiDB.SkinPanel(mapLock)
mapLock:EnableMouse(true)
mapLock:Hide()

local lockText = mapLock:CreateFontString(nil, "OVERLAY")
lockText:SetFont(TukuiCF["media"].pixelfont, 8)
lockText:SetPoint("CENTER")
lockText:SetJustifyH("CENTER")
lockText:SetJustifyV("MIDDLE")
lockText:SetText(tukuilocal.map_move)
mapLock:SetWidth(lockText:GetWidth() + 20)

mapLock:SetScript("OnMouseDown", function(self)
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" then return end
	WorldMapScreenAnchor:ClearAllPoints()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:StartMoving()
end)

mapLock:SetScript("OnMouseUp", function(self)
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" then return end
	WorldMapFrame:StopMovingOrSizing()
	WorldMapScreenAnchor:StartMoving()
	WorldMapScreenAnchor:SetPoint("TOPLEFT", WorldMapFrame)
	WorldMapScreenAnchor:StopMovingOrSizing()
end)

mapLock:SetScript("OnEnter", TukuiDB.SetModifiedBackdrop)
mapLock:SetScript("OnLeave", TukuiDB.SetOriginalBackdrop)

--------------------------------------------
-- Setup map close button/text/script
--------------------------------------------

local mapClose = CreateFrame ("Frame", nil, WorldMapDetailFrame)
mapClose:SetScale(1 / mapscale)
mapClose:SetHeight(infoHeight)
mapClose:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(5))
TukuiDB.SkinPanel(mapClose)
mapClose:EnableMouse(true)
mapClose:Hide()

local closeText = mapClose:CreateFontString(nil, "OVERLAY")
closeText:SetFont(TukuiCF["media"].pixelfont, 8)
closeText:SetPoint("CENTER")
closeText:SetJustifyH("CENTER")
closeText:SetJustifyV("MIDDLE")
closeText:SetText(tukuilocal.map_close)
mapClose:SetWidth(closeText:GetWidth() + 20)

mapClose:SetScript("OnMouseUp", function(self) ToggleFrame(WorldMapFrame) end)

mapClose:SetScript("OnEnter", TukuiDB.SetModifiedBackdrop)
mapClose:SetScript("OnLeave", TukuiDB.SetOriginalBackdrop)

--------------------------------------------
-- Setup map expand button/text/script
--------------------------------------------

local mapExpand = CreateFrame ("Frame", nil, WorldMapDetailFrame)
mapExpand:SetScale(1 / mapscale)
mapExpand:SetHeight(infoHeight)
mapExpand:SetPoint("TOPRIGHT", mapLock, "TOPLEFT", TukuiDB.Scale(-3), 0)
TukuiDB.SkinPanel(mapExpand)
mapExpand:EnableMouse(true)
mapExpand:Hide()

local expandText = mapExpand:CreateFontString(nil, "OVERLAY", mapExpand)
expandText:SetFont(TukuiCF["media"].pixelfont, 8)
expandText:SetPoint("CENTER")
expandText:SetJustifyH("CENTER")
expandText:SetJustifyV("MIDDLE")
expandText:SetText(tukuilocal.map_expand)
mapExpand:SetWidth(expandText:GetWidth() + 20)

mapExpand:SetScript("OnMouseUp", function(self) 
	WorldMapFrame_ToggleWindowSize()
end)

mapExpand:SetScript("OnEnter", TukuiDB.SetModifiedBackdrop)
mapExpand:SetScript("OnLeave", TukuiDB.SetOriginalBackdrop)


local SmallerMapSkin = function()
	-- new frame to put zone and title text in
	mapTitle:SetScale(1 / mapscale)
	mapTitle:SetFrameStrata("MEDIUM")
	mapTitle:SetFrameLevel(20)
	mapTitle:SetPoint("TOPLEFT", mapClose, "TOPRIGHT", 3, 0)
	mapTitle:SetPoint("TOPRIGHT", mapExpand, "TOPLEFT", -3, 0)
	
	map:SetScale(1 / mapscale)
	map:SetPoint("TOPLEFT", WorldMapDetailFrame, TukuiDB.Scale(-2), TukuiDB.Scale(2))
	map:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, TukuiDB.Scale(2), TukuiDB.Scale(-2))
	map:SetFrameStrata("MEDIUM")
	map:SetFrameLevel(20)

	-- move buttons / texts and hide default border
	WorldMapButton:SetAllPoints(WorldMapDetailFrame)
	
	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapFrame:SetClampedToScreen(true)
	
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	
	WorldMapTitleButton:Show()	
	mapLock:Show()
	mapClose:Show()
	mapExpand:Show()

	
	
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameCloseButton:Hide()
	WorldMapFrameSizeUpButton:Hide()

	WorldMapFrameSizeDownButton:SetPoint("TOPRIGHT", WorldMapFrameMiniBorderRight, "TOPRIGHT", TukuiDB.Scale(-66), TukuiDB.Scale(5))

	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, TukuiDB.Scale(-1))
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")

	WorldMapQuestShowObjectivesText:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
	
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOMLEFT", 0, TukuiDB.Scale(-1))
	WorldMapTrackQuest:SetFrameStrata("HIGH")
	
	WorldMapTrackQuestText:SetFont(TukuiCF["media"].font, 12, "OUTLINE")

	
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetParent(mapTitle)
	WorldMapFrameTitle:SetPoint("CENTER")
	WorldMapFrameTitle:SetJustifyH("CENTER")
	WorldMapFrameTitle:SetJustifyV("MIDDLE")
	WorldMapFrameTitle:SetFont(TukuiCF["media"].pixelfont, 8)
	
	-- temporary
	WorldMapLevelDropDown:SetPoint("TOPRIGHT", WorldMapPositioningGuide, "TOPRIGHT", 0, TukuiDB.Scale(-30))
	
	WorldMapTitleButton:SetFrameStrata("MEDIUM")
	WorldMapTooltip:SetFrameStrata("TOOLTIP")
	

	-- fix tooltip not hidding after leaving quest # tracker icon
	hooksecurefunc("WorldMapQuestPOI_OnLeave", function() WorldMapTooltip:Hide() end)
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)


-- the classcolor function
local function UpdateIconColor(self)
	if not self.unit then return end -- it seem sometime self.unit is not found causing lua error. idn why but anyway.
	local color = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
	if not color then return end -- sometime color return nil
	self.icon:SetVertexColor(color.r, color.g, color.b)
end

local OnEvent = function()
	if event == "PLAYER_REGEN_DISABLED" then
		WorldMapFrameSizeDownButton:Disable() 
		WorldMapFrameSizeUpButton:Disable()
	elseif event == "PLAYER_REGEN_ENABLED" then
		WorldMapFrameSizeDownButton:Enable()
		WorldMapFrameSizeUpButton:Enable()
	elseif event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
		for r=1, 40 do
			if not _G["WorldMapRaid"..r] then return end
			if UnitInParty(_G["WorldMapRaid"..r].unit) then
				_G["WorldMapRaid"..r].icon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\Party")
			else
				_G["WorldMapRaid"..r].icon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\Raid")
			end
			_G["WorldMapRaid"..r]:SetScript("OnUpdate", UpdateIconColor)
		end

		for p=1, 4 do
			if not _G["WorldMapParty"..p] then return end
			_G["WorldMapParty"..p].icon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\Party")
			_G["WorldMapParty"..p]:SetScript("OnUpdate", UpdateIconColor)
		end
	end
end
addon:SetScript("OnEvent", OnEvent)