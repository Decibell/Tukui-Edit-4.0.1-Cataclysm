if TukuiCF["datatext"].stat_block then

	----- [[    Memory    ]] -----

	local memorystat = CreateFrame("Frame", "TukuiMemoryStats", UIParent)
	TukuiDB.CreatePanel(memorystat, 60, TukuiDB.infoheight, "TOPLEFT", UIParent, "TOPLEFT", 8, -8)
	memorystat:EnableMouse(true)

	local mtext  = memorystat:CreateFontString(nil, "OVERLAY")
	mtext:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
	mtext:SetPoint("CENTER")

	local colorme = string.format("%02x%02x%02x", 1*255, 1*255, 1*255)

	local function formatMem(memory, color)
		if color then
			statColor = { "|cff"..colorme, "|r" }
		else
			statColor = { "", "" }
		end
		
		local mb, kb = (cStart .. "mb|r"), (cStart .. "kb|r")
		
		local mult = 10^1
		if memory > 999 then
			local mem = floor((memory/1024) * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0 %s" .. mb .. "%s", unpack(statColor))
			else
				return mem..string.format(" %s" .. mb .. "%s", unpack(statColor))
			end
		else
			local mem = floor(memory * mult + 0.5) / mult
				if mem % 1 == 0 then
					return mem..string.format(".0 %s" .. kb .. "%s", unpack(statColor))
				else
					return mem..string.format(" %s" .. kb .. "%s", unpack(statColor))
				end
		end
	end

	local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory
	local function RefreshMem(self)
		Memory = {}
		collectgarbage("collect")
		UpdateAddOnMemoryUsage()
		Total = 0
		for i = 1, GetNumAddOns() do
			Mem = GetAddOnMemoryUsage(i)
			Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
			Total = Total + Mem
		end
		
		MEMORY_TEXT = formatMem(Total, true)
		table.sort(Memory, function(a, b)
			if a and b then
				return a[2] > b[2]
			end
		end)
		
		local memC
		
		if Total > 5000 then
			memC = format("|cffCC3333 %s|r ", MEMORY_TEXT)
		elseif Total > 2500 then
			memC = format("|cffFDD842 %s|r ", MEMORY_TEXT)
		else
			memC = format("|cff32DC46 %s|r ", MEMORY_TEXT)
		end
		
		mtext:SetText(memC)
		memorystat:SetWidth(mtext:GetWidth() + 20)
	end

	local int = 10
	local function MemUpdate(self, t)
		int = int - t
		if int < 0 then
			RefreshMem(self)
			int = 10
		end
	end

	memorystat:HookScript("OnMouseDown", function() collectgarbage("collect") MemUpdate(memorystat, 20) end)
	memorystat:HookScript("OnUpdate", MemUpdate) 

	memorystat:HookScript("OnEnter", function()
		if not InCombatLockdown() then
			GameTooltip:SetOwner(memorystat, "ANCHOR_BOTTOMRIGHT", -memorystat:GetWidth(), -(memorystat:GetHeight() - 16))
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(cStart .. tukuilocal.datatext_totalmemusage .. cEnd,formatMem(Total), _, _, _, 1, 1, 1)
			GameTooltip:AddLine(" ")
			for i = 1, #Memory do
				if Memory[i][3] then 
					local red = Memory[i][2]/Total*2
					local green = 1 - red
					GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)						
				end
			end
			GameTooltip:Show()
		end
	end)
	memorystat:HookScript("OnLeave", function() GameTooltip:Hide() end)
	MemUpdate(memorystat, 20)


	----- [[    Fps    ]] -----

	local fpsstat = CreateFrame("Frame", "TukuiFpsStats", UIParent)
	TukuiDB.CreatePanel(fpsstat, 60, TukuiDB.infoheight, "TOPLEFT", memorystat, "TOPLEFT", memorystat:GetWidth() + 3, 0)

	local ftext  = fpsstat:CreateFontString(nil, "OVERLAY")
	ftext:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
	ftext:SetPoint("CENTER")

	local int2 = 1
	local function FpsUpdate(self, t)
		int2 = int2 - t
		if int2 < 0 then
			local fps = floor(GetFramerate())
			if fps >= 50 then
				fps = "|cff32DC46"..floor(GetFramerate()).."|r"
			elseif fps >= 25 then
				fps = "|cffFDD842"..floor(GetFramerate()).."|r"
			elseif fps >= 0 then
				fps = "|cffCC3333"..floor(GetFramerate()).."|r"
			end
			
			ftext:SetText(cStart .. "FPS: |r" .. fps)
			fpsstat:SetWidth(ftext:GetWidth() + 20)
			fpsstat:SetPoint("TOPLEFT", memorystat, "TOPLEFT", memorystat:GetWidth() + 3, 0)
			int2 = 1
		end	
	end
	fpsstat:HookScript("OnUpdate", FpsUpdate)
	FpsUpdate(fpsstat, 10)


	----- [[    Latency    ]] -----

	local latencystat = CreateFrame("Frame", "TukuiLatencyStats", UIParent)
	TukuiDB.CreatePanel(latencystat, 60, TukuiDB.infoheight, "TOPLEFT", fpsstat, "TOPLEFT", fpsstat:GetWidth() + 3, 0)

	local ltext  = latencystat:CreateFontString(nil, "OVERLAY")
	ltext:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
	ltext:SetPoint("CENTER")

	local int3 = 1
	local function LatencyUpdate(self, t)
		int3 = int3 - t
		if int3 < 0 then
			local ms = select(3, GetNetStats())		
			if ms >= 300 then
				ms = "|cffCC3333"..select(3, GetNetStats()).."|r"
			elseif ms >= 150 then
				ms = "|cffFDD842"..select(3, GetNetStats()).."|r"
			elseif ms >= 0 then
				ms = "|cff32DC46"..select(3, GetNetStats()).."|r"
			end

			ltext:SetText(cStart .. "MS: |r" .. ms)
			latencystat:SetWidth(ltext:GetWidth() + 20)
			latencystat:SetPoint("TOPLEFT", fpsstat, "TOPLEFT", fpsstat:GetWidth() + 3, 0)
			int3 = 1
		end	
	end
	latencystat:HookScript("OnUpdate", LatencyUpdate)
	LatencyUpdate(latencystat, 10)


	----- [[    Time    ]] -----

	local timestat = CreateFrame("Button", "TukuiTimeStats", UIParent)
	TukuiDB.CreatePanel(timestat, 60, TukuiDB.infoheight, "TOPLEFT", latencystat, "TOPLEFT", latencystat:GetWidth() + 3, 0)
	timestat:EnableMouse(true)
	timestat:RegisterForClicks("AnyDown")

	local ttext  = timestat:CreateFontString(nil, "OVERLAY")
	ttext:SetFont(TukuiCF.theme.DATA_Font, TukuiCF.theme.DATA_FSize, TukuiCF.theme.DATA_FFlag)
	ttext:SetPoint("CENTER")

	timestat:HookScript("OnMouseDown", function(self, btn)
		if btn == "RightButton" then
			if EclipseSettings[1] == true then
				EclipseSettings[1] = false
				EclipseSettings[2] = true
			else
				EclipseSettings[1] = true
				EclipseSettings[2] = false
			end
		elseif btn == "LeftButton" then
			if EclipseSettings[3] == true then
				EclipseSettings[3] = false
				hrmode = "Disabled"
			else
				EclipseSettings[3] = true
				hrmode = "Enabled"
			end
		elseif btn == "MiddleButton" then
			GameTimeFrame:Click()
		end
	end)

	local int4 = 1
	local function TimeUpdate(self, t)
		local pendingCalendarInvites = CalendarGetNumPendingInvites()
		int4 = int4 - t
		
		if int4 < 0 then
			if EclipseSettings[1] == true then
				Hr24 = tonumber(date("%H"))
				Hr = tonumber(date("%I"))
				Min = date("%M")
				
				if EclipseSettings[3] == true then
					if pendingCalendarInvites > 0 then
						ttext:SetText(cStart .. "L: |r" .. "|cffFF0000" .. Hr24 .. ":" .. Min)
					else
						ttext:SetText(cStart .. "L: |r" .. Hr24 .. ":" .. Min)
					end
				else
					if Hr24>=12 then
						if pendingCalendarInvites > 0 then
								ttext:SetText(cStart .. "L: |r" .. "|cffFF0000" .. Hr .. ":" .. Min .. cStart .. " pm|r")
							else
								ttext:SetText(cStart .. "L: |r" .. Hr .. ":" .. Min .. cStart .. " pm|r")
							end
					else
						if pendingCalendarInvites > 0 then
							ttext:SetText(cStart .. "L: |r" .. "|cffFF0000" .. Hr .. ":" .. Min .. cStart .. " am|r")
						else
							ttext:SetText(cStart .. "L: |r" .. Hr .. ":" .. Min .. cStart .. " am|r")
						end
					end
				end	
			else
				local Hr, Min = GetGameTime()
				if Min<10 then Min = "0"..Min end
				if EclipseSettings[3] == true then
					if pendingCalendarInvites > 0 then
						ttext:SetText(cStart .. "S: |r" .. "|cffFF0000" .. Hr .. ":" .. Min)
					else
						ttext:SetText(cStart .. "S: |r" .. Hr .. ":" .. Min)
					end
				else
					if Hr>=12 then
						if Hr>12 then Hr = Hr-12 end
						if pendingCalendarInvites > 0 then
							ttext:SetText(cStart .. "S: |r" .. "|cffFF0000" .. Hr .. ":" .. Min .. cStart .. " pm|r")
						else
							ttext:SetText(cStart .. "S: |r" .. Hr .. ":" .. Min .. cStart .. " pm|r")
						end
					else
						if Hr == 0 then Hr = 12 end
						if pendingCalendarInvites > 0 then
							ttext:SetText(cStart .. "S: |r" .. "|cffFF0000" .. Hr .. ":" .. Min .. cStart .. " am|r")
						else
							ttext:SetText(cStart .. "S: |r" .. Hr .. ":" .. Min .. cStart .. " am|r")
						end
					end
				end
			end
			int4 = 1
		end
		
		timestat:SetWidth(ttext:GetWidth() + 20)
		timestat:SetPoint("TOPLEFT", latencystat, "TOPLEFT", latencystat:GetWidth() + 3, 0)
	end
	timestat:HookScript("OnUpdate", TimeUpdate)
	TimeUpdate(timestat, 10)

	timestat:HookScript("OnEnter", function()
		GameTooltip:SetOwner(timestat, "ANCHOR_BOTTOMRIGHT", -timestat:GetWidth(), -(timestat:GetHeight() - 16))
		GameTooltip:ClearLines()
		
		if not EclipseSettings[1] == true then
			Hr24 = tonumber(date("%H"))
			Hr = tonumber(date("%I"))
			Min = date("%M")
			
			if EclipseSettings[3] == true then
				GameTooltip:AddDoubleLine(tukuilocal.datatext_localtime, Hr24 .. ":" .. Min)
			else
				if Hr24>=12 then
					GameTooltip:AddDoubleLine(tukuilocal.datatext_localtime, Hr .. ":" .. Min .. " pm|r")
				else
					GameTooltip:AddDoubleLine(tukuilocal.datatext_localtime, Hr .. ":" .. Min .. " am|r")
				end
			end	
		else
			local Hr, Min = GetGameTime()
			if Min<10 then Min = "0"..Min end
			if EclipseSettings[3] == true then
				GameTooltip:AddDoubleLine(tukuilocal.datatext_servertime, Hr .. ":" .. Min)
			else
				if Hr>=12 then
					if Hr>12 then Hr = Hr-12 end
					GameTooltip:AddDoubleLine(tukuilocal.datatext_servertime, Hr .. ":" .. Min .. " pm|r")
				else
					if Hr == 0 then Hr = 12 end
					GameTooltip:AddDoubleLine(tukuilocal.datatext_servertime, Hr .. ":" .. Min .. " am|r")
				end
			end
		end
		
		GameTooltip:AddLine" "
		GameTooltip:AddDoubleLine("Right-click:", "Local or Server Time")
		GameTooltip:AddDoubleLine("Left-click:", "Format 24H or AM/PM")
		GameTooltip:AddDoubleLine("Middle-click:", "Show Calender")
		

		GameTooltip:Show()
	end)
	timestat:HookScript("OnLeave", function() GameTooltip:Hide() end)

end