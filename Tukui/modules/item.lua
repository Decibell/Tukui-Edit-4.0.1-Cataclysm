if TukuiCF.tooltip.enable ~= true then return end

GameTooltip:HookScript("OnTooltipCleared", function(self) self.TukuiItemTooltip=nil end)
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	if (IsShiftKeyDown() or IsAltKeyDown()) and (TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.id or TukuiItemTooltip.count)) then
		local link = select(2, self:GetItem())
		local num = GetItemCount(link)
		local left = ""
		local right = ""
		
		if TukuiItemTooltip.id and link ~= nil then
			left = "|cFFCA3C3CItem ID|r "..link:match(":(%w+)")
		end
		
		if TukuiItemTooltip.count and num > 1 then
			right = "|cFFCA3C3C"..tukuilocal.tooltip_count.."|r "..num
		end
				
		self:AddLine(" ")
		self:AddDoubleLine(left, right)
		self.TukuiItemTooltip = 1
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	if IsAltKeyDown() and TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.spell) then
		local id = select(3, self:GetSpell())
		local left = ""

		if TukuiItemTooltip.spell and id ~= nil then
			left = "|cFFCA3C3CSpell ID|r "..id
		end

		self:AddLine(" ")
		self:AddLine(left)
		self.TukuiItemTooltip = 1
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= "Tukui" then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
	TukuiItemTooltip = TukuiItemTooltip or {count=true,id=true,spell=true}
end)