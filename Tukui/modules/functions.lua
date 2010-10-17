function TukuiDB.UIScale()
	-- the tukui high reso whitelist
	if not (TukuiDB.getscreenresolution == "1680x945"
		or TukuiDB.getscreenresolution == "2560x1440" 
		or TukuiDB.getscreenresolution == "1680x1050" 
		or TukuiDB.getscreenresolution == "1920x1080" 
		or TukuiDB.getscreenresolution == "1920x1200" 
		or TukuiDB.getscreenresolution == "1600x900" 
		or TukuiDB.getscreenresolution == "2048x1152" 
		or TukuiDB.getscreenresolution == "1776x1000" 
		or TukuiDB.getscreenresolution == "2560x1600" 
		or TukuiDB.getscreenresolution == "1600x1200") then
			if TukuiCF["general"].overridelowtohigh == true then
				TukuiCF["general"].autoscale = false
				TukuiDB.lowversion = false
			else
				TukuiDB.lowversion = true
			end			
	end

	if TukuiCF["general"].autoscale == true then
		-- i'm putting a autoscale feature mainly for an easy auto install process
		-- we all know that it's not very effective to play via 1024x768 on an 0.64 uiscale :P
		-- with this feature on, it should auto choose a very good value for your current reso!
		TukuiCF["general"].uiscale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end

	if TukuiDB.lowversion then
		TukuiDB.raidscale = 0.8
	else
		TukuiDB.raidscale = 1
	end
end
TukuiDB.UIScale()

-- pixel perfect script of custom ui scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/TukuiCF["general"].uiscale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end

function TukuiDB.Scale(x) return scale(x) end
TukuiDB.mult = mult


----- [[    Textures    ]] -----

local media = TukuiCF["media"]
local theme_texture = TukuiCF.theme.UI_Texture

local textures = {
	normbg = {
		bgFile = theme_texture,
		edgeFile = media.blank,
		tile = false,
		tileSize = 0,
		edgeSize = mult,
		insets = { left = -mult, right = -mult, top = -mult, bottom = -mult }
	},
	
	fadebg = {
		bgFile = media.blank, -- no we keep this as blank or it looks terrible
		edgeFile = media.blank,
		tile = false,
		tileSize = 0,
		edgeSize = mult,
		insets = { left = -mult, right = -mult, top = -mult, bottom = -mult }
	},

	shadowbg = {
		edgeFile = media.glowTex, 
		edgeSize = 3,
		insets = { left = mult, right = mult, top = mult, bottom = mult }
	},
	
	border = {
		edgeFile = media.blank, 
		edgeSize = mult, 
		insets = { left = mult, right = mult, top = mult, bottom = mult }
	},
	
	overlay = theme_texture		
}


----- [[    Style    ]] -----

function TukuiDB.StyleShadow(f)
	if f.shadow or not TukuiCF["panels"].shadows then return end
	f.shadow = CreateFrame("Frame", nil, f)
	f.shadow:SetFrameLevel(0)
	f.shadow:SetFrameStrata(f:GetFrameStrata())
	f.shadow:SetPoint("TOPLEFT", -3, 3)
	f.shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	f.shadow:SetBackdrop(textures.shadowbg)
	f.shadow:SetBackdropColor(0, 0, 0, 0)
	f.shadow:SetBackdropBorderColor(0, 0, 0, .75)
	return f.shadow
end

function TukuiDB.StyleOverlay(f)
	if f.bg then return end
	f.bg = f:CreateTexture(f:GetName() and f:GetName().."_overlay" or nil, "BORDER", f)
	f.bg:ClearAllPoints()
	f.bg:SetPoint("TOPLEFT", mult, -mult)
	f.bg:SetPoint("BOTTOMRIGHT", -mult, mult)
	f.bg:SetTexture(textures.overlay)
	f.bg:SetVertexColor(0.075, 0.075, 0.075)
	return f.bg
end

function TukuiDB.StyleInnerBorder(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", mult, -mult)
	f.iborder:SetPoint("BOTTOMRIGHT", -mult, mult)
	f.iborder:SetBackdrop(textures.border)
	f.iborder:SetBackdropBorderColor(unpack(media.backdropcolor))
	return f.iborder
end

function TukuiDB.StyleOuterBorder(f)
	if f.oborder then return end
	f.oborder = CreateFrame("Frame", nil, f)
	f.oborder:SetPoint("TOPLEFT", -mult, mult)
	f.oborder:SetPoint("BOTTOMRIGHT", mult, -mult)
	f.oborder:SetBackdrop(textures.border)
	f.oborder:SetBackdropBorderColor(unpack(media.backdropcolor))
	return f.oborder
end


----- [[    Skin    ]] -----

function TukuiDB.SkinPanel(f)
	f:SetBackdrop(textures.normbg)
	f:SetBackdropColor(unpack(media.backdropcolor))
	f:SetBackdropBorderColor(unpack(media.bordercolor))
	
	TukuiDB.StyleOverlay(f)
	TukuiDB.StyleShadow(f)
end

function TukuiDB.SkinFadedPanel(f)
	f:SetBackdrop(textures.fadebg)
	f:SetBackdropColor(unpack(media.fadedbackdropcolor))
	f:SetBackdropBorderColor(unpack(media.bordercolor))

	TukuiDB.StyleShadow(f)
	TukuiDB.StyleInnerBorder(f)
	TukuiDB.StyleOuterBorder(f)
end


----- [[    Create    ]] -----

function TukuiDB.CreateText(parent, font, size, flag, a1, p, a2, x, y)
	local f = parent:CreateFontString(nil, "OVERLAY")
	f:SetFont(font, size, flag)
	f:SetPoint(a1, p, a2, x, y)
	return f
end

function TukuiDB.CreatePanel(f, w, h, a1, p, a2, x, y)
	sh = scale(h)
	sw = scale(w)	
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	
	TukuiDB.SkinPanel(f)
end

function TukuiDB.CreateFadedPanel(f, w, h, a1, p, a2, x, y)
	sh = scale(h)
	sw = scale(w)	
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	
	TukuiDB.StyleInnerBorder(f)
	TukuiDB.StyleOuterBorder(f)
	TukuiDB.SkinFadedPanel(f)
end

function TukuiDB.CreateBorder(f, w, h, a1, p, a2, x, y)
	sh = scale(h)
	sw = scale(w)	
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)

	TukuiDB.StyleOuterBorder(f)
end

function TukuiDB.SetTemplate(f)
	f:SetBackdrop({
	  bgFile = TukuiCF["media"].blank, 
	  edgeFile = TukuiCF["media"].blank, 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	f:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
	f:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
end

function TukuiDB.Kill(object)
	object.Show = TukuiDB.dummy
	object:Hide()
end

function TukuiDB.TukuiPetBarUpdate(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		
		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end
		
		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(0)
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end			
		end
		
		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end
		
		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end
		
		-- grid display
		if name then
			if not TukuiCF["actionbar"].showgrid then
				petActionButton:SetAlpha(1)
			end			
		else
			if not TukuiCF["actionbar"].showgrid then
				petActionButton:SetAlpha(0)
			end
		end
		
		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end
		
		-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
		-- Setting desaturation on button to true until you learn the control on class trainer.
		-- you can at least control "follow" button.
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end

-- styleButton function authors are Chiril & Karudon.
function TukuiDB.StyleButton(b, checked) 
    local name = b:GetName()
 
    local button          = _G[name]
    local icon            = _G[name.."Icon"]
    local count           = _G[name.."Count"]
    local border          = _G[name.."Border"]
    local hotkey          = _G[name.."HotKey"]
    local cooldown        = _G[name.."Cooldown"]
    local nametext        = _G[name.."Name"]
    local flash           = _G[name.."Flash"]
    local normaltexture   = _G[name.."NormalTexture"]
	local icontexture     = _G[name.."IconTexture"]

	local hover = b:CreateTexture("frame", nil, self) -- hover
	hover:SetTexture(1,1,1,0.3)
	hover:SetHeight(button:GetHeight())
	hover:SetWidth(button:GetWidth())
	hover:SetPoint("TOPLEFT",button,2,-2)
	hover:SetPoint("BOTTOMRIGHT",button,-2,2)
	button:SetHighlightTexture(hover)

	local pushed = b:CreateTexture("frame", nil, self) -- pushed
	pushed:SetTexture(0.9,0.8,0.1,0.3)
	pushed:SetHeight(button:GetHeight())
	pushed:SetWidth(button:GetWidth())
	pushed:SetPoint("TOPLEFT",button,2,-2)
	pushed:SetPoint("BOTTOMRIGHT",button,-2,2)
	button:SetPushedTexture(pushed)
 
	if checked then
		local checked = b:CreateTexture("frame", nil, self) -- checked
		checked:SetTexture(0,1,0,0.3)
		checked:SetHeight(button:GetHeight())
		checked:SetWidth(button:GetWidth())
		checked:SetPoint("TOPLEFT",button,2,-2)
		checked:SetPoint("BOTTOMRIGHT",button,-2,2)
		button:SetCheckedTexture(checked)
	end
end