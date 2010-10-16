------------------------------------------------------------------------
--	First Time Launch and On Login file
------------------------------------------------------------------------

local function install()
	SetCVar("buffDurations", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("scriptErrors", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyPets", 0)
	SetCVar("nameplateShowFriendlyGuardians", 0)
	SetCVar("nameplateShowFriendlyTotems", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowEnemyPets", 1)
	SetCVar("nameplateShowEnemyGuardians", 1)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 8)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "im")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("CombatDamage", 1)
	SetCVar("CombatHealing", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("Maxfps", 120)
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("showLootSpam", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("chatBubblesParty", 0)
	SetCVar("chatBubbles", 0)	
	SetCVar("UnitNameOwn", 0)
	SetCVar("UnitNameNPC", 0)
	SetCVar("UnitNameNonCombatCreatureName", 0)
	SetCVar("UnitNamePlayerGuild", 1)
	SetCVar("UnitNamePlayerPVPTitle", 1)
	SetCVar("UnitNameFriendlyPlayerName", 0)
	SetCVar("UnitNameFriendlyPetName", 0)
	SetCVar("UnitNameFriendlyGuardianName", 0)
	SetCVar("UnitNameFriendlyTotemName", 0)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyTotemName", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("showVKeyCastbar", 1)
	SetCVar("colorblindMode", 0)
	-- SetCVar("bloatthreat", 0)
	
	-- setting this the creator or tukui only, because a lot of people don't like this change.		
	if TukuiDB.myname == "Tukz" then	
		SetCVar("secureAbilityToggle", 0)
	end
	
	-- Var ok, now setting chat frames if using Tukui chats.	
	if (TukuiCF.chat.enable == true) and (not IsAddOnLoaded("Prat") or not IsAddOnLoaded("Chatter")) then					
		FCF_ResetChatWindows()
		FCF_SetLocked(ChatFrame1, 1)
		FCF_DockFrame(ChatFrame2)
		FCF_SetLocked(ChatFrame2, 1)
		FCF_OpenNewWindow("General")
		FCF_SetLocked(ChatFrame3, 1)
		FCF_DockFrame(ChatFrame3)

		FCF_OpenNewWindow("Trade / Loot")
		FCF_UnDockFrame(ChatFrame4)
		FCF_SetLocked(ChatFrame4, 1)
		ChatFrame4:Show();

		for i = 1, NUM_CHAT_WINDOWS do
			local frame = _G[format("ChatFrame%s", i)]
			local chatFrameId = frame:GetID()
			local chatName = FCF_GetChatWindowInfo(chatFrameId)
			
			frame:SetSize(TukuiDB.Scale(TukuiCF["panels"].tinfowidth - 8), TukuiCF["chat"].chatheight - 9)
			
			-- this is the default width and height of tukui chats.
			SetChatWindowSavedDimensions(chatFrameId, TukuiDB.Scale(TukuiCF["panels"].tinfowidth - 8), TukuiCF["chat"].chatheight - 9)
			
			-- move general bottom left or Loot (if found) on right.
			if i == 1 then
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOMLEFT", TukuiChatLeft, "BOTTOMLEFT", TukuiDB.Scale(3), TukuiDB.Scale(5))
			elseif i == 4 and chatName == "Loot" then
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOMRIGHT", TukuiChatRight, "BOTTOMRIGHT", TukuiDB.Scale(-5), TukuiDB.Scale(5))
			end
			
			-- save new default position and dimension
			FCF_SavePositionAndDimensions(frame)
			
			-- set default tukui font size
			FCF_SetChatWindowFontSize(nil, frame, 12)
			
			-- rename windows general and combat log
			if i == 1 then FCF_SetWindowName(frame, "G, S & W") end
			if i == 2 then FCF_SetWindowName(frame, "Log") end
		end
		
		ChatFrame_RemoveAllMessageGroups(ChatFrame1)
		ChatFrame_RemoveChannel(ChatFrame1, "Trade")
		ChatFrame_RemoveChannel(ChatFrame1, "General")
		ChatFrame_RemoveChannel(ChatFrame1, "LocalDefense")
		ChatFrame_RemoveChannel(ChatFrame1, "GuildRecruitment")
		ChatFrame_RemoveChannel(ChatFrame1, "LookingForGroup")
		ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
		ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
		ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
		ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
		ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
		ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
		ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
		ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
		ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
		ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
		ChatFrame_AddMessageGroup(ChatFrame1, "DND")
		ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
		ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
		ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")

		-- Setup the spam chat frame
		ChatFrame_RemoveAllMessageGroups(ChatFrame3)
		ChatFrame_AddChannel(ChatFrame3, "General")
		ChatFrame_AddChannel(ChatFrame3, "GuildRecruitment")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")

		-- Setup the right chat
		ChatFrame_RemoveAllMessageGroups(ChatFrame4);
		ChatFrame_AddChannel(ChatFrame4, "Trade")
		ChatFrame_AddChannel(ChatFrame4, "LookingForGroup")
		ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
		ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")

		-- enable classcolor automatically on login and on each character without doing /configure each time.
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	end

	TukuiInstallv1200 = true
	
	-- reset unitframe position
	if TukuiCF["unitframes"].positionbychar == true then
		TukuiUFpos = {}
	else
		TukuiData.ufpos = {}
	end

	ReloadUI()
end

local function DisableTukui()
	DisableAddOn("Tukui")
	ReloadUI()
end

------------------------------------------------------------------------
--	Popups
------------------------------------------------------------------------

StaticPopupDialogs["DISABLE_UI"] = {
	text = tukuilocal.popup_disableui,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = DisableTukui,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["INSTALL_UI"] = {
	text = tukuilocal.popup_install,
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = install,
	OnCancel = function() TukuiInstallv1100 = true TukuiData.SetcVar = true end,
    timeout = 0,
    whileDead = 1,
}

local function INSTALL_LAYOUT()
	local function SkinButton(f)
		f:HookScript("OnEnter", TukuiDB.SetModifiedBackdrop)
		f:HookScript("OnLeave", TukuiDB.SetOriginalBackdrop)
	end

	local main = CreateFrame("Frame", "main", UIParent)
	TukuiDB.CreateFadedPanel(main, 360, 85, "TOP", 0, -240)
	
	local mtext = main:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	mtext:SetPoint("TOP", main, "TOP", 0, -14)
	mtext:SetText("Choose unitframe layout:")
	
	local b1 = CreateFrame("Button", "b1", main)
	b1:SetHeight(24)
	b1:SetWidth(100)
	b1:SetPoint("LEFT", main, "LEFT", 10, -15)
	TukuiDB.SetTemplate(b1)
	b1:HookScript("OnClick", function() 
		EnableAddOn("Tukui_Heal") 
		DisableAddOn("Tukui_Dps") 
		DisableAddOn("Tukui_HealMode")
		EnableAddOn("ecUnitframes")
		ReloadUI() 
	end)
	local b1text = b1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	b1text:SetPoint("CENTER")
	b1text:SetText("Heal")
	
	local b2 = CreateFrame("Button", "b2", main)
	b2:SetHeight(24)
	b2:SetWidth(100)
	b2:SetPoint("CENTER", main, "CENTER", 0, -15)
	TukuiDB.SetTemplate(b2)
	b2:HookScript("OnClick", function() 
		DisableAddOn("Tukui_Heal") 
		EnableAddOn("Tukui_Dps") 
		DisableAddOn("Tukui_HealMode")
		EnableAddOn("ecUnitframes")
		ReloadUI() 
	end)
	local b2text = b2:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	b2text:SetPoint("CENTER")
	b2text:SetText("Dps - Tank")

	local b3 = CreateFrame("Button", "b3", main)
	b3:SetHeight(24)
	b3:SetWidth(100)
	b3:SetPoint("RIGHT", main, "RIGHT", -10, -15)
	TukuiDB.SetTemplate(b3)
	b3:HookScript("OnClick", function() 
		DisableAddOn("Tukui_Heal") 
		DisableAddOn("Tukui_Dps") 
		EnableAddOn("Tukui_HealMode")
		DisableAddOn("ecUnitframes")
		ReloadUI() 
	end)
	local b4text = b3:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	b4text:SetPoint("CENTER")
	b4text:SetText("HealMode")
	
	SkinButton(b1)
	SkinButton(b2)
	SkinButton(b3)
end

------------------------------------------------------------------------
--	On login function, look for some infos!
------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if TukuiDB.getscreenresolution == "800x600"
		or TukuiDB.getscreenresolution == "1024x768"
		or TukuiDB.getscreenresolution == "720x576"
		or TukuiDB.getscreenresolution == "1024x600" -- eeepc reso
		or TukuiDB.getscreenresolution == "1152x864" then
			SetCVar("useUiScale", 0)
			StaticPopup_Show("DISABLE_UI")
	else
		SetCVar("useUiScale", 1)
		if TukuiCF["general"].multisampleprotect == true then
			SetMultisampleFormat(1)
		end
		if TukuiCF["general"].uiscale > 1 then TukuiCF["general"].uiscale = 1 end
		if TukuiCF["general"].uiscale < 0.64 then TukuiCF["general"].uiscale = 0.64 end
		SetCVar("uiScale", TukuiCF["general"].uiscale)
		if TukuiInstallv1200 ~= true then
			if (TukuiData == nil) then TukuiData = {} end
			StaticPopup_Show("INSTALL_UI")
		end
	end
	
	-- lol
	if IsAddOnLoaded("Tukui_Heal") and IsAddOnLoaded("Tukui_Dps") and IsAddOnLoaded("Tukui_HealMode")
		or IsAddOnLoaded("Tukui_Heal") and IsAddOnLoaded("Tukui_Dps") and IsAddOnLoaded("Tukui_HealMode")
		or IsAddOnLoaded("Tukui_Heal") and IsAddOnLoaded("Tukui_Dps")
		or IsAddOnLoaded("Tukui_Heal") and IsAddOnLoaded("Tukui_HealMode")
		or IsAddOnLoaded("Tukui_Dps") and IsAddOnLoaded("Tukui_HealMode") then
			INSTALL_LAYOUT()
	end
	
	print(tukuilocal.core_release)
	print(tukuilocal.core_welcome1)
	print(tukuilocal.core_welcome2)
end)

------------------------------------------------------------------------
--	UI HELP
------------------------------------------------------------------------

-- Print Help Messages
local function UIHelp()
	print(" ")
	print(tukuilocal.core_uihelp1)
	print(tukuilocal.core_uihelp2)
	print(tukuilocal.core_uihelp3)
	print(tukuilocal.core_uihelp4)
	print(tukuilocal.core_uihelp5)
	print(tukuilocal.core_uihelp6)
	print(tukuilocal.core_uihelp7)
	print(tukuilocal.core_uihelp8)
	print(tukuilocal.core_uihelp9)
	print(tukuilocal.core_uihelp10)
	print(tukuilocal.core_uihelp11)
	--print(tukuilocal.core_uihelp12)  -- temp disabled, don't know yet if i'll readd this feature
	print(tukuilocal.core_uihelp13)
	print(tukuilocal.core_uihelp15)
	print(" ")
	print(tukuilocal.core_uihelp14)
end

SLASH_UIHELP1 = "/UIHelp"
SlashCmdList["UIHELP"] = UIHelp

SLASH_CONFIGURE1 = "/resetui"
SlashCmdList.CONFIGURE = function() StaticPopup_Show("INSTALL_UI") end


