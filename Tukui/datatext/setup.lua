-- temp
EclipseSettings = { }

-- if TukuiCF["datatext"].classcolor == true then
	local _,class = UnitClass("player")
	local r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	cStart = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
-- else
	-- local r, g, b = unpack(TukuiCF["datatext"].color)
	-- cStart = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
-- end
cEnd = "|r"

function TukuiDB.PP(p, obj)
	local left = TukuiDataLeft
	local right = TukuiDataRight
	local bottom = TukuiDataBottom
	local leftsplit = TukuiLeftSplitBarData
	local rightsplit = TukuiRightSplitBarData

	if p == 1 then
		obj:SetHeight(left:GetHeight())
		obj:SetPoint("LEFT", left, 20, 0)
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 2 then
		obj:SetHeight(left:GetHeight())
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 3 then
		obj:SetHeight(left:GetHeight())
		obj:SetPoint("RIGHT", left, -20, 0)
		obj:SetPoint('TOP', left)
		obj:SetPoint('BOTTOM', left)
	elseif p == 4 then
		obj:SetHeight(right:GetHeight())
		obj:SetPoint("LEFT", right, 20, 0)
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	elseif p == 5 then
		obj:SetHeight(right:GetHeight())
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	elseif p == 6 then
		obj:SetHeight(right:GetHeight())
		obj:SetPoint("RIGHT", right, -20, 0)
		obj:SetPoint('TOP', right)
		obj:SetPoint('BOTTOM', right)
	end
	
	if TukuiCF["panels"].bottom_panels then
		if p == 7 then
			obj:SetHeight(bottom:GetHeight())
			obj:SetPoint("LEFT", bottom, 20, 0)
			obj:SetPoint('TOP', bottom)
			obj:SetPoint('BOTTOM', bottom)
		elseif p == 8 then
			obj:SetHeight(bottom:GetHeight())
			obj:SetPoint('TOP', bottom)
			obj:SetPoint('BOTTOM', bottom)
		elseif p == 9 then
			obj:SetHeight(bottom:GetHeight())
			obj:SetPoint("RIGHT", bottom, -20, 0)
			obj:SetPoint('TOP', bottom)
			obj:SetPoint('BOTTOM', bottom)
		end
	
		if TukuiCF["actionbar"].split_bar then
			if p == 10 then
				obj:SetHeight(leftsplit:GetHeight() - 10)
				obj:SetWidth(leftsplit:GetWidth() - 15)
				obj:SetPoint('CENTER', leftsplit)
			elseif p == 11 then
				obj:SetHeight(rightsplit:GetHeight() - 10)
				obj:SetWidth(rightsplit:GetWidth() - 15)
				obj:SetPoint('CENTER', rightsplit)
			end
		end
	end
end