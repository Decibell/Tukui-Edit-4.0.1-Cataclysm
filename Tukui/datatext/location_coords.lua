if not TukuiCF["datatext"].location then return end

----- [[    Location    ]] -----

local location = CreateFrame("Frame", "TukuiLocation", UIParent)
TukuiDB.CreatePanel(location, 60, TukuiDB.infoheight, "TOP", UIParent, "TOP", 0, -8)

local locationtext  = location:CreateFontString(nil, "LOW")
locationtext:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
locationtext:SetPoint("CENTER", location)
 
local function OnEvent(self, event)
	local loc = GetMinimapZoneText()
	local pvpType, isFFA, zonePVPStatus = GetZonePVPInfo()

	if (pvpType == "sanctuary") then
		loc = "|cff69C9EF"..loc.."|r" -- light blue
	elseif (pvpType == "friendly") then
		loc = "|cff00ff00"..loc.."|r" -- green
	elseif (pvpType == "contested") then
		loc = "|cffffff00"..loc.."|r" -- yellow
	elseif (pvpType == "hostile" or pvpType == "combat" or pvpType == "arena" or not pvpType) then
		loc = "|cffff0000"..loc.."|r" -- red
	else
		loc = loc -- white
	end

	locationtext:SetText(loc)
	location:SetWidth(locationtext:GetWidth() + 24)
end

location:RegisterEvent("PLAYER_ENTERING_WORLD")
location:RegisterEvent("ZONE_CHANGED_NEW_AREA")
location:RegisterEvent("ZONE_CHANGED")
location:RegisterEvent("ZONE_CHANGED_INDOORS")
location:HookScript("OnEvent", OnEvent)


----- [[    Coords    ]] -----

if TukuiCF["datatext"].coords then 
	local xcoords = CreateFrame("Frame", "TukuiXCoordsPanel", UIParent)
	TukuiDB.CreatePanel(xcoords, 35, TukuiDB.infoheight, "RIGHT", location, "LEFT", -3, 0)

	local ycoords = CreateFrame("Frame", "TukuiYCoordsPanel", UIParent)
	TukuiDB.CreatePanel(ycoords, 35, TukuiDB.infoheight, "LEFT", location, "RIGHT", 3, 0)

	local xcoordstext = xcoords:CreateFontString(nil, "OVERLAY")
	xcoordstext:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
	xcoordstext:SetPoint("CENTER", xcoords)
	
	local ycoordstext  = ycoords:CreateFontString(nil, "OVERLAY")
	ycoordstext:SetFont(TukuiCF["media"].pixelfont, 8, "MONOCHROMEOUTLINE")
	ycoordstext:SetPoint("CENTER", ycoords)

	local ela,go = 0,false

	local Update = function(self,t)
		ela = ela - t
		if ela > 0 then return end
		local x,y = GetPlayerMapPosition("player")
		local xt,yt
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x == 0 and y == 0 then
			xcoordstext:SetText("")
			ycoordstext:SetText("")
			
			xcoords:SetAlpha(0)
			ycoords:SetAlpha(0)
		else
			if x < 10 then
				xt = "0"..x
			else
				xt = x
			end
			if y < 10 then
				yt = "0"..y
			else
				yt = y
			end
			xcoordstext:SetText("x: " .. xt)
			ycoordstext:SetText("y: " .. yt)
			
			xcoords:SetAlpha(1)
			ycoords:SetAlpha(1)
			xcoords:SetWidth(xcoordstext:GetWidth() + 24)
			ycoords:SetWidth(ycoordstext:GetWidth() + 24)
		end
		ela = .2
	end
	xcoords:HookScript("OnUpdate", Update)
end