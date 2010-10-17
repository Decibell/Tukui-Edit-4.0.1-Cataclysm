-- credits: Kryso // Foof (making it work with spellnames instead of ids, so it can be used from level 1 to 80 without changing anything!)

if TukuiCF["unitframes"].enable ~= true or TukuiCF["ct"].classtimers ~= true then return end

local CreateSpellEntry = function( id, castByAnyone, color, unitType, castSpellId, forceId )
	return { id = id, castByAnyone = castByAnyone, color = color, unitType = unitType or 0, castSpellId = castSpellId, forceId = forceId }
end

local CreateColor = function( red, green, blue, alpha )
	return { red / 255, green / 255, blue / 255, alpha }
end

-- Bar height
local BAR_HEIGHT = 14

-- Distance between bars
local BAR_SPACING = 1

-- Background alpha (range from 0 to 1)
local BACKGROUND_ALPHA = 0.75

-- Icon overlay color
local ICON_COLOR = CreateColor( 120, 120, 120, 1 )

-- Show spark
local SPARK = true

-- Show cast separator
local CAST_SEPARATOR = true

-- Sets cast separator color
local CAST_SEPARATOR_COLOR = CreateColor( 0, 0, 0, 0.5 )

-- Sets distance between right edge of bar and name and left edge of bar and time left
local TEXT_MARGIN = 5

local MASTER_FONT, STACKS_FONT = { TukuiCF["theme"].UF_Font, TukuiCF["theme"].UF_FSize, TukuiCF["theme"].UF_FFlag }, { TukuiCF["theme"].UF_Font, TukuiCF["theme"].UF_FSize, TukuiCF["theme"].UF_FFlag }

local PERMANENT_AURA_VALUE = 1

if TukuiCF["ct"].classcolored == true then
	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass("player"))]
	PLAYER_BAR_COLOR = {color.r, color.g, color.b, 1}
else
	PLAYER_BAR_COLOR = TukuiCF["media"].bordercolor
end
local PLAYER_DEBUFF_COLOR = nil
local TARGET_BAR_COLOR = CreateColor( 70, 150, 70, 1 )
local TARGET_DEBUFF_COLOR = CreateColor( 150, 70, 70, 1 )
local TRINKET_BAR_COLOR = CreateColor( 75, 75, 75, 1 )

--[[ Sort direction
	false - ascending
	true - descending
]]--
local SORT_DIRECTION = true

-- Timer tenths threshold - range from 1 to 60
local TENTHS_TRESHOLD = 1

-- Trinket filter - mostly for trinket procs, delete or wrap into comment block --[[  ]] if you dont want to track those
local TRINKET_FILTER = {
	-- CreateSpellEntry( 67671 ), -- Fury(Banner of Victory)

	-- CreateSpellEntry( 60229 ), -- Greatness (Greatness - Strength)
	-- CreateSpellEntry( 60233 ), -- Greatness (Greatness - Agility)
	-- CreateSpellEntry( 60234 ), -- Greatness (Greatness - Intellect)
	-- CreateSpellEntry( 60235 ), -- Greatness (Greatness - Spirit)
		
	-- CreateSpellEntry( 67703 ), CreateSpellEntry( 67708 ), CreateSpellEntry( 67772 ), CreateSpellEntry( 67773 ), -- Paragon (Death Choice)
	-- CreateSpellEntry( 67684 ), -- Hospitality (Talisman of Resurgence)
		
	-- CreateSpellEntry( 71432 ), -- Mote of Anger (Tiny Abomination in a Jar)	
	-- CreateSpellEntry( 71485 ), CreateSpellEntry( 71556 ), -- Agility of the Vrykul (Deathbringer's Will)
	-- CreateSpellEntry( 71492 ), CreateSpellEntry( 71560 ), -- Speed of the Vrykul (Deathbringer's Will)
	-- CreateSpellEntry( 71487 ), CreateSpellEntry( 71557 ), -- Precision of the Iron Dwarves (Deathbringer's Will)
	-- CreateSpellEntry( 71491 ), CreateSpellEntry( 71559 ), -- Aim of the Iron Dwarves (Deathbringer's Will)
	-- CreateSpellEntry( 71486 ), CreateSpellEntry( 71558 ), -- Power of the Taunka (Deathbringer's Will)
	-- CreateSpellEntry( 71484 ), CreateSpellEntry( 71561 ), -- Strength of the Taunka (Deathbringer's Will)
	-- CreateSpellEntry( 71570 ), CreateSpellEntry( 71572 ), -- Cultivated Power (Muradin's Spyglass)
	-- CreateSpellEntry( 71605 ), CreateSpellEntry( 71636 ), -- Phylactery of the Nameless Lich
	-- CreateSpellEntry( 71401 ), CreateSpellEntry( 71541 ), -- Icy Rage (Whispering Fanged Skull)
	-- CreateSpellEntry( 71396 ), -- Herkuml War Token
	-- CreateSpellEntry( 72412 ), -- Frostforged Champion (Ashen Band of Unmatched/Endless Might/Vengeance)
	
	-- CreateSpellEntry( 59626 ), -- Black Magic
	-- CreateSpellEntry( 54758 ), -- Hyperspeed Acceleration (Hyperspeed Accelerators)
	-- CreateSpellEntry( 55637 ), -- Lightweave
	-- CreateSpellEntry( 59620 ), -- Berserking
		
	-- CreateSpellEntry( 2825, true ), CreateSpellEntry( 32182, true ), -- Bloodlust/Heroism
	-- CreateSpellEntry( 26297 ), -- Berserking (troll racial)
	-- CreateSpellEntry( 33702 ), CreateSpellEntry( 33697 ), CreateSpellEntry( 20572 ), -- Blood Fury (orc racial)
	CreateSpellEntry( 57933 ), -- Tricks of Trade (15% dmg buff)
}

local FOCUS_FILTERS = {
	CreateSpellEntry( 45524 ),
	CreateSpellEntry( 17 ),
	CreateSpellEntry( 6788, true, nil, 1 ), -- Weakened Soul
	CreateSpellEntry( 120 ), -- CoC
}

local CLASS_FILTERS = {
	DEATHKNIGHT = { 
		target = { 
			CreateSpellEntry( 55095 ), -- Frost Fever
			CreateSpellEntry( 55078 ), -- Blood Plague
			CreateSpellEntry( 81130 ), -- Scarlet Fever
		},
		player = { 
			CreateSpellEntry( 59052 ), -- Freezing Fog
			CreateSpellEntry( 51124 ), -- Killing Machine  
			CreateSpellEntry( 49222 ), -- Bone Shield
			CreateSpellEntry( 57330 ), -- Horn of Winter
			CreateSpellEntry( 48707 ), -- Anti-magic Shell
			CreateSpellEntry( 48792 ), -- Icebound Fortitude
			CreateSpellEntry( 55233 ), -- Vampiric Blood
			CreateSpellEntry( 49028 ), -- Dancing Rune Weapon
		},
		procs = {
			CreateSpellEntry( 53365 ), -- Unholy Strength
			CreateSpellEntry( 81340 ), -- Sudden Doom 
		}
	},
	DRUID = { 
		target = { 
			CreateSpellEntry( 48438 ), -- Wild Growth
			CreateSpellEntry( 774 ), -- Rejuvenation
			CreateSpellEntry( 8936 ), -- Regrowth
			CreateSpellEntry( 33763 ), -- Lifebloom
			CreateSpellEntry( 5570 ), -- Insect Swarm
			CreateSpellEntry( 8921 ), -- Moonfire
			CreateSpellEntry( 93402 ), -- Sunfire
			CreateSpellEntry( 339 ), -- Entangling Roots
			CreateSpellEntry( 33786 ), -- Cyclone
			CreateSpellEntry( 60433 ), -- Earth and Moon
			CreateSpellEntry( 2637 ), -- Hibernate
			CreateSpellEntry( 2908 ), -- Soothe Animal
			CreateSpellEntry( 50259 ), -- Feral Charge (Cat) - daze
			CreateSpellEntry( 45334 ), -- Feral Charge (Bear) - immobilize
			CreateSpellEntry( 58180 ), -- Infected Wounds
			CreateSpellEntry( 6795 ), -- Growl
			CreateSpellEntry( 5209 ), -- Challenging Roar
			CreateSpellEntry( 99 ), -- Demoralizing Roar
			CreateSpellEntry( 33745 ), -- Lacerate
			CreateSpellEntry( 5211 ), -- Bash 
			CreateSpellEntry( 22570 ), -- Maim
			CreateSpellEntry( 1822 ), -- Rake
			CreateSpellEntry( 1079 ), -- Rip
			CreateSpellEntry( 33878, true ), -- Mangle (Bear)
			CreateSpellEntry( 33876, true ), -- Mangle (Cat)
			CreateSpellEntry( 9007 ), -- Pounce bleed
			CreateSpellEntry( 9005 ), -- Pounce stun
			CreateSpellEntry( 91565, true ), -- Farie Fire
		},
		player = { 
			CreateSpellEntry( 48505 ), -- Starfall
			CreateSpellEntry( 29166 ), -- Innervate
			CreateSpellEntry( 22812 ), -- Barkskin
			CreateSpellEntry( 5215 ), -- Prowl 
			CreateSpellEntry( 53312 ), -- Nature's Grasp
			CreateSpellEntry( 5229 ), -- Enrage
			CreateSpellEntry( 52610 ), -- Savage Roar
			CreateSpellEntry( 5217 ), -- Tiger's Fury
			CreateSpellEntry( 1850 ), -- Dash
			CreateSpellEntry( 22842 ), -- Frenzied Regeneration
			CreateSpellEntry( 50334 ), -- Berserk
			CreateSpellEntry( 61336 ), -- Survival Instincts
		},
		procs = {
			CreateSpellEntry( 16870 ), -- Clearcasting	
			CreateSpellEntry( 48517 ), -- Solar Eclipse
			CreateSpellEntry( 48518 ), -- Lunar Eclipse
			CreateSpellEntry( 62606 ), -- Predator's Swiftness
			CreateSpellEntry( 93400 ), -- Shooting Stars
			CreateSpellEntry( 81192 ), -- Lunar Shower
		}
	},
	HUNTER = { 
		target = {
			CreateSpellEntry( 1978 ), -- Serpent Stingng
			CreateSpellEntry( 63468 ), -- Piercing Shots
			CreateSpellEntry( 3674 ), -- Black Arrow
		},
		player = {
			CreateSpellEntry( 3045 ), -- Rapid Fire
		},
		procs = {
			CreateSpellEntry( 6150 ), -- Quick Shots
			CreateSpellEntry( 56453 ), -- Lock and Load
			CreateSpellEntry( 70728 ), -- Exploit Weakness (2pc t10)
			CreateSpellEntry( 71007 ), -- Stinger (4pc t10)
			CreateSpellEntry( 82925 ), -- Master Marksman
			CreateSpellEntry( 53220 ), -- Improved Steady Shot
			CreateSpellEntry( 82926 ), -- Fire!
		},
	},
	MAGE = {
		target = { 
			CreateSpellEntry( 44457 ), -- Living Bomb
		},
		player = {
			CreateSpellEntry( 36032 ), -- Arcane Blast
			CreateSpellEntry( 1463 ), -- Mana Shield
			CreateSpellEntry( 11426 ), -- Ice Barrier
			CreateSpellEntry( 543 ), -- Mage Ward 
			CreateSpellEntry( 12472 ), -- Icy Veins
			CreateSpellEntry( 12042 ), -- Arcane Power
			CreateSpellEntry( 48108 ), -- Hot Streak
		},
		procs = {
			CreateSpellEntry( 44544 ), -- Fingers of Frost	
			CreateSpellEntry( 79683 ), -- Arkan Missile!	
			CreateSpellEntry( 57761 ), -- Brain Frezze	
		},
	},
	PALADIN = { 
		target = {
			CreateSpellEntry( 31803 ), -- Censure
			CreateSpellEntry( 20066 ), -- Repentance
			CreateSpellEntry( 53563 ), -- Beacon of Light
			CreateSpellEntry( 853 ), -- Hammer of Justice
		},
		player = {
			CreateSpellEntry( 642 ), -- Divine Shield
			CreateSpellEntry( 498 ), -- Divine Protection
			CreateSpellEntry( 31850 ), --Ardent Defender
			CreateSpellEntry( 31884 ), -- Avenging Wrath
			CreateSpellEntry( 54428 ), -- Divine Plea
			CreateSpellEntry( 87342 ), -- Holy Shield
			CreateSpellEntry( 85433 ), -- Sacred Duty
			CreateSpellEntry( 85416 ), --Grand Crusader
			CreateSpellEntry( 70940, true), -- Divine Guardian 
			CreateSpellEntry( 85696 ), -- Zealotry
		},
		procs = {
			CreateSpellEntry( 59578 ), -- The Art of War
			CreateSpellEntry( 90174 ), -- Hand of Light	
			CreateSpellEntry( 85496 ), -- Speed of Light	
			CreateSpellEntry( 88819 ), -- Daybreak 
		},
	},
	PRIEST = { 
		target = { 
			CreateSpellEntry( 17 ), -- Power Word: Shield
			CreateSpellEntry( 6788, true, nil, 1 ), -- Weakened Soul
			CreateSpellEntry( 139 ), -- Renew
			CreateSpellEntry( 33076 ), -- Prayer of Mending
			CreateSpellEntry( 33206 ), -- Pain Suppression
			CreateSpellEntry( 34914, false, nil, nil, 34914 ), -- Vampiric Touch
			CreateSpellEntry( 589 ), -- Shadow Word: Pain
			CreateSpellEntry( 2944 ), -- Devouring Plague
			CreateSpellEntry( 47788 ), -- Guardian Spirit
		},
		player = {
			CreateSpellEntry( 10060 ), -- Power Infusion
			CreateSpellEntry( 47585 ), -- Dispersion
			CreateSpellEntry( 81207 ), -- Chakra: Renew
			CreateSpellEntry( 81208 ), -- Chakra: Heal
			CreateSpellEntry( 81206 ), -- Chakra: Prayer of Healing
			CreateSpellEntry( 81209 ), -- Chakra: Smite
			CreateSpellEntry( 81700 ), -- Archangel
			CreateSpellEntry( 87153 ), -- Dark Archangel
			CreateSpellEntry( 81661 ), -- Evangelism
			CreateSpellEntry( 588 ), -- Inner Fire
		},
		procs = {
			CreateSpellEntry( 63735 ), -- Serendipity
			CreateSpellEntry( 88688 ), -- Surge of Light
			CreateSpellEntry( 77487 ), -- Shadow Orbs
		},
	},
    ROGUE = { 
        target = { 
            CreateSpellEntry( 1833 ), -- Cheap Shot
            CreateSpellEntry( 408 ), -- Kidney Shot
            CreateSpellEntry( 1776 ), -- Gouge 
            CreateSpellEntry( 2094 ), -- Blind
            CreateSpellEntry( 8647 ), -- Expose Armor
            CreateSpellEntry( 51722 ), -- Dismantle
            CreateSpellEntry( 2818 ), -- Deadly Poison
            CreateSpellEntry( 13218 ), -- Wound Posion
            CreateSpellEntry( 3409 ), -- Crippling Poison 
            CreateSpellEntry( 5760 ), -- Mind-Numbling Poison
            CreateSpellEntry( 6770 ), -- Sap    
            CreateSpellEntry( 1943 ), -- Rupture
            CreateSpellEntry( 703 ), -- Garrote
            CreateSpellEntry( 93068 ), -- Master Poisoner
            CreateSpellEntry( 79140 ), -- Vendetta
            CreateSpellEntry( 16511 ), -- Hemorrhage
        },
        player = { 
            CreateSpellEntry( 32645 ), -- Envenom
            CreateSpellEntry( 5171 ), -- Slice and Dice    
            CreateSpellEntry( 57934 ), -- Tricks of the Trade
            CreateSpellEntry( 5277 ), -- Evasion
            CreateSpellEntry( 58427 ), -- Overkill
            CreateSpellEntry( 13750 ), -- Adrenaline Rush
            CreateSpellEntry( 13877 ), -- Blade Flurry
            CreateSpellEntry( 73651 ), -- Recuperate
        },
        procs = {

        },
    },
	SHAMAN = {
		target = { 
			CreateSpellEntry( 8042 ), -- Earth Shield
			CreateSpellEntry( 8050 ), -- Flame Shock
			CreateSpellEntry( 8056 ), -- Frost Shock
		},
		player = { 
			CreateSpellEntry( 324 ), -- Lightning Shield
			CreateSpellEntry( 52127 ), -- Water Shield
			CreateSpellEntry( 30823 ), -- Shamanistic Rage
			CreateSpellEntry( 16166 ), -- Elemental Mastery
		},
		procs = {
			CreateSpellEntry( 51528 ), -- Maelstrom Weapon
			CreateSpellEntry( 51562 ), -- Tidal Waves 
		},
	},
	WARLOCK = { 
		target = {
			CreateSpellEntry( 48181 ), -- Haunt
			CreateSpellEntry( 32389 ), -- Shadow Embrace 
			CreateSpellEntry( 172 ), -- Corruption
			CreateSpellEntry( 30108 ), -- Unstable Affliction
			CreateSpellEntry( 603 ), -- Bane of Doom
			CreateSpellEntry( 980 ), -- Bane of Agony
			CreateSpellEntry( 1490 ), -- Curse of the Elements 
			CreateSpellEntry( 18018 ), -- Conflagration
			CreateSpellEntry( 348 ), -- Immolate
			CreateSpellEntry( 27243 ), -- Seed of Corruption
			CreateSpellEntry( 17800 ), -- Improved Shadow Bolt
		},
		player = { 
		},
		procs = {
			CreateSpellEntry( 54277 ), -- Backdraft
			CreateSpellEntry( 64371 ), -- Eradication
			CreateSpellEntry( 71165 ), -- Molten Core
			CreateSpellEntry( 63167 ), -- Decimation 
			CreateSpellEntry( 17941 ), -- Shadow Trance
			CreateSpellEntry( 47283 ), -- Empowered Imp 
			CreateSpellEntry( 85383 ), -- Improved Soul Fire 
		},
	},
	WARRIOR = { 
		target = {
			CreateSpellEntry( 94009 ), -- Rend
			CreateSpellEntry( 12294 ), -- Mortal Strike
			CreateSpellEntry( 1160 ), -- Demoralizing Shout
			CreateSpellEntry( 64382 ), -- Shattering Throw
			CreateSpellEntry( 58567 ), -- Sunder Armor
			CreateSpellEntry( 6343 ), -- Thunder Clap
		},
		player = { 
			CreateSpellEntry( 469 ), -- Commanding Shout
			CreateSpellEntry( 6673 ), -- Battle Shout
			CreateSpellEntry( 55694 ), -- Enraged Regeneration
			CreateSpellEntry( 23920 ), -- Spell Reflection
			CreateSpellEntry( 871 ), -- Shield Wall
			CreateSpellEntry( 1719 ), -- Recklessness
			CreateSpellEntry( 20230 ), -- Retaliation
			CreateSpellEntry( 46916 ), -- Slam!
		},
		procs = {

		},
	},
};

local CreateUnitAuraDataSource
do
	local auraTypes = { "HELPFUL", "HARMFUL" }

	-- private
	local CheckFilter = function( self, id, caster, filter, name )
		if ( filter == nil ) then return false end
			
		local byPlayer = caster == "player" or caster == "pet" or caster == "vehicle"
			
		for _, v in ipairs( filter ) do
			local filterName = GetSpellInfo(v.id)
			if ( ( ( v.forceId and v.id == id ) or ( not v.forceId and filterName == name ) ) and ( v.castByAnyone or byPlayer ) ) then	return v end
		end
		
		return false
	end
	
	local CheckUnit = function( self, unit, filter, result )
		if ( not UnitExists( unit ) ) then return 0 end

		local unitIsFriend = UnitIsFriend( "player", unit )

		for _, auraType in ipairs( auraTypes ) do
			local isDebuff = auraType == "HARMFUL"
		
			for index = 1, 40 do
				local name, _, texture, stacks, _, duration, expirationTime, caster, _, _, spellId = UnitAura( unit, index, auraType )		
				if ( name == nil ) then
					break
				end							
				
				local filterInfo = CheckFilter( self, spellId, caster, filter, name )
				if ( filterInfo and ( filterInfo.unitType ~= 1 or unitIsFriend ) and ( filterInfo.unitType ~= 2 or not unitIsFriend ) ) then 					
					filterInfo.name = name
					filterInfo.texture = texture
					filterInfo.duration = duration
					filterInfo.expirationTime = expirationTime
					filterInfo.stacks = stacks
					filterInfo.unit = unit
					filterInfo.isDebuff = isDebuff
					table.insert( result, filterInfo )
				end
			end
		end
	end

	-- public 
	local Update = function( self )
		local result = self.table

		for index = 1, #result do
			table.remove( result )
		end				

		CheckUnit( self, self.unit, self.filter, result )
		if ( self.includePlayer ) then
			CheckUnit( self, "player", self.playerFilter, result )
		end
		
		self.table = result
	end

	local SetSortDirection = function( self, descending )
		self.sortDirection = descending
	end
	
	local GetSortDirection = function( self )
		return self.sortDirection
	end
	
	local Sort = function( self )
		local direction = self.sortDirection
		local time = GetTime()
	
		local sorted
		repeat
			sorted = true
			for key, value in pairs( self.table ) do
				local nextKey = key + 1
				local nextValue = self.table[ nextKey ]
				if ( nextValue == nil ) then break end
				
				local currentRemaining = value.expirationTime == 0 and 4294967295 or math.max( value.expirationTime - time, 0 )
				local nextRemaining = nextValue.expirationTime == 0 and 4294967295 or math.max( nextValue.expirationTime - time, 0 )
				
				if ( ( direction and currentRemaining < nextRemaining ) or ( not direction and currentRemaining > nextRemaining ) ) then
					self.table[ key ] = nextValue
					self.table[ nextKey ] = value
					sorted = false
				end				
			end			
		until ( sorted == true )
	end
	
	local Get = function( self )
		return self.table
	end
	
	local Count = function( self )
		return #self.table
	end
	
	local AddFilter = function( self, filter, defaultColor, debuffColor )
		if ( filter == nil ) then return end
		
		for _, v in pairs( filter ) do
			local clone = { }
			
			clone.id = v.id
			clone.castByAnyone = v.castByAnyone
			clone.color = v.color
			clone.unitType = v.unitType
			clone.castSpellId = v.castSpellId
			clone.forceId = v.forceId
			
			clone.defaultColor = defaultColor
			clone.debuffColor = debuffColor
			
			table.insert( self.filter, clone )
		end
	end
	
	local AddPlayerFilter = function( self, filter, defaultColor, debuffColor )
		if ( filter == nil ) then return end

		for _, v in pairs( filter ) do
			local clone = { }
			
			clone.id = v.id
			clone.castByAnyone = v.castByAnyone
			clone.color = v.color
			clone.unitType = v.unitType
			clone.castSpellId = v.castSpellId
			clone.forceId = v.forceId
			
			clone.defaultColor = defaultColor
			clone.debuffColor = debuffColor
			
			table.insert( self.playerFilter, clone )
		end
	end
	
	local GetUnit = function( self )
		return self.unit
	end
	
	local GetIncludePlayer = function( self )
		return self.includePlayer
	end
	
	local SetIncludePlayer = function( self, value )
		self.includePlayer = value
	end
	
	-- constructor
	CreateUnitAuraDataSource = function( unit )
		local result = {  }

		result.Sort = Sort
		result.Update = Update
		result.Get = Get
		result.Count = Count
		result.SetSortDirection = SetSortDirection
		result.GetSortDirection = GetSortDirection
		result.AddFilter = AddFilter
		result.AddPlayerFilter = AddPlayerFilter
		result.GetUnit = GetUnit 
		result.SetIncludePlayer = SetIncludePlayer 
		result.GetIncludePlayer = GetIncludePlayer 
		
		result.unit = unit
		result.includePlayer = false
		result.filter = { }
		result.playerFilter = { }
		result.table = { }
		
		return result
	end
end

local CreateFramedTexture
do
	-- public
	local SetTexture = function( self, ... )
		return self.texture:SetTexture( ... )
	end
	
	local GetTexture = function( self )
		return self.texture:GetTexture()
	end
	
	local GetTexCoord = function( self )
		return self.texture:GetTexCoord()
	end
	
	local SetTexCoord = function( self, ... )
		return self.texture:SetTexCoord( ... )
	end
	
	local SetBorderColor = function( self, ... )
		return self.border:SetVertexColor( ... )
	end
	
	-- constructor
	CreateFramedTexture = function( parent )
		local result = parent:CreateTexture( nil, "BACKGROUND", nil )
		local border = parent:CreateTexture( nil, "BORDER", nil )
		local background = parent:CreateTexture( nil, "ARTWORK", nil )
		local texture = parent:CreateTexture( nil, "OVERLAY", nil )		
		
		local offset = TukuiDB.Scale(1)
		
		result:SetTexture( unpack ( TukuiCF["media"].backdropcolor ) )
		border:SetTexture( unpack ( TukuiCF["media"].bordercolor ) )
		background:SetTexture( unpack ( TukuiCF["media"].backdropcolor ) )
		
		border:SetPoint( "TOPLEFT", result, "TOPLEFT", offset, -offset )
		border:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", -offset, offset )
		
		background:SetPoint( "TOPLEFT", border, "TOPLEFT", offset, -offset )
		background:SetPoint( "BOTTOMRIGHT", border, "BOTTOMRIGHT", -offset, offset )

		texture:SetPoint( "TOPLEFT", background, "TOPLEFT", offset, -offset )
		texture:SetPoint( "BOTTOMRIGHT", background, "BOTTOMRIGHT", -offset, offset )
		
		result.border = border
		result.background = background
		result.texture = texture
		
		result.SetBorderColor = SetBorderColor
		
		result.SetTexture = SetTexture
		result.GetTexture = GetTexture
		result.SetTexCoord = SetTexCoord
		result.GetTexCoord = GetTexCoord
		
		return result
	end
end

local CreateAuraBarFrame
do
	-- classes
	local CreateAuraBar
	do
		-- private 
		local OnUpdate = function( self, elapsed )	
			local time = GetTime()
		
			if ( time > self.expirationTime ) then
				self.bar:SetScript( "OnUpdate", nil )
				self.bar:SetValue( 0 )
				self.time:SetText( "" )
				
				local spark = self.spark
				if ( spark ) then			
					spark:Hide()
				end
			else
				local remaining = self.expirationTime - time
				self.bar:SetValue( remaining )
				
				local timeText = ""
				if ( remaining >= 3600 ) then
					timeText = tostring( math.floor( remaining / 3600 ) ) .. "h"
				elseif ( remaining >= 60 ) then
					timeText = tostring( math.floor( remaining / 60 ) ) .. "m"
				elseif ( remaining > TENTHS_TRESHOLD ) then
					timeText = tostring( math.floor( remaining ) )
				elseif ( remaining > 0 ) then
					timeText = tostring( math.floor( remaining * 10 ) / 10 )
				end
				self.time:SetText( timeText )
				
				local barWidth = self.bar:GetWidth()
				
				local spark = self.spark
				if ( spark ) then			
					spark:SetPoint( "CENTER", self.bar, "LEFT", barWidth * remaining / self.duration, 0 )
				end
				
				local castSeparator = self.castSeparator
				if ( castSeparator and self.castSpellId ) then
					local _, _, _, _, _, _, castTime, _, _ = GetSpellInfo( self.castSpellId )

					castTime = castTime / 1000
					if ( castTime and remaining > castTime ) then
						castSeparator:SetPoint( "CENTER", self.bar, "LEFT", barWidth * ( remaining - castTime ) / self.duration, 0 )
					else
						castSeparator:Hide()
					end
				end
			end
		end
		
		-- public
		local SetIcon = function( self, icon )
			if ( not self.icon ) then return end
			
			self.icon:SetTexture( icon )
		end
		
		local SetTime = function( self, expirationTime, duration )
			self.expirationTime = expirationTime
			self.duration = duration
			
			if ( expirationTime > 0 and duration > 0 ) then		
				self.bar:SetMinMaxValues( 0, duration )
				OnUpdate( self, 0 )
		
				local spark = self.spark
				if ( spark ) then 
					spark:Show()
				end
		
				self:SetScript( "OnUpdate", OnUpdate )
			else
				self.bar:SetMinMaxValues( 0, 1 )
				self.bar:SetValue( PERMANENT_AURA_VALUE )
				self.time:SetText( "" )
				
				local spark = self.spark
				if ( spark ) then 
					spark:Hide()
				end
				
				self:SetScript( "OnUpdate", nil )
			end
		end
		
		local SetName = function( self, name )
			self.name:SetText( name )
		end
		
		local SetStacks = function( self, stacks )
			if ( not self.stacks ) then
				if ( stacks ~= nil and stacks > 1 ) then
					local name = self.name
					
					name:SetText( tostring( stacks ) .. "  " .. name:GetText() )
				end
			else			
				if ( stacks ~= nil and stacks > 1 ) then
					self.stacks:SetText( stacks )
				else
					self.stacks:SetText( "" )
				end
			end
		end
		
		local SetColor = function( self, color )
			self.bar:SetStatusBarColor( unpack( color ) )
		end
		
		local SetCastSpellId = function( self, id )
			self.castSpellId = id
			
			local castSeparator = self.castSeparator
			if ( castSeparator ) then
				if ( id ) then
					self.castSeparator:Show()
				else
					self.castSeparator:Hide()
				end
			end
		end
		
		local SetAuraInfo = function( self, auraInfo )
			self:SetName( auraInfo.name )
			self:SetIcon( auraInfo.texture )	
			self:SetTime( auraInfo.expirationTime, auraInfo.duration )
			self:SetStacks( auraInfo.stacks )
			self:SetCastSpellId( auraInfo.castSpellId )
		end
		
		-- constructor
		CreateAuraBar = function( parent )
			local result = CreateFrame( "Frame", nil, parent, nil )

			if TukuiCF["ct"].icons == true then
				local icon = CreateFramedTexture( result, "ARTWORK" )
				icon:SetTexCoord( 0.15, 0.85, 0.15, 0.85 )
				
				local iconAnchor1
				local iconAnchor2
				local iconOffset
				iconAnchor1 = "TOPRIGHT"
				iconAnchor2 = "TOPLEFT"
				iconOffset = -4
				
				icon:SetPoint( iconAnchor1, result, iconAnchor2, iconOffset, 3 )
				icon:SetWidth( BAR_HEIGHT + 6 )
				icon:SetHeight( BAR_HEIGHT + 6 )	
				
				result.icon = icon		
			end
			
			local bar = CreateFrame( "StatusBar", nil, result, nil )
			bar:SetStatusBarTexture( TukuiCF["theme"].UI_Texture )
			bar:SetPoint( "TOPLEFT", result, "TOPLEFT", 0, 0 )
			bar:SetPoint( "BOTTOMRIGHT", result, "BOTTOMRIGHT", 0, 0 )
			result.bar = bar
			
			if ( SPARK ) then
				local spark = bar:CreateTexture( nil, "OVERLAY", nil )
				spark:SetTexture( [[Interface\CastingBar\UI-CastingBar-Spark]] )
				spark:SetWidth( 12 )
				spark:SetBlendMode( "ADD" )
				spark:Show()
				result.spark = spark
			end
			
			if ( CAST_SEPARATOR ) then
				local castSeparator = bar:CreateTexture( nil, "OVERLAY", nil )
				castSeparator:SetTexture( unpack( CAST_SEPARATOR_COLOR ) )
				castSeparator:SetWidth( 1 )
				castSeparator:SetHeight( BAR_HEIGHT )
				castSeparator:Show()
				result.castSeparator = castSeparator
			end
			
			local name = bar:CreateFontString( nil, "OVERLAY", nil )
			name:SetFont( unpack( MASTER_FONT ) )
			name:SetJustifyH( "LEFT" )
			name:SetPoint( "TOPLEFT", bar, "TOPLEFT", TEXT_MARGIN, 0 )
			name:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMRIGHT", -45, 0 )
			result.name = name
			
			local time = bar:CreateFontString( nil, "OVERLAY", nil )
			time:SetFont( unpack( MASTER_FONT ) )
			time:SetJustifyH( "RIGHT" )
			time:SetPoint( "TOPLEFT", name, "TOPRIGHT", 0, 0 )
			time:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMRIGHT", -TEXT_MARGIN, 0 )
			result.time = time
			
			result.SetIcon = SetIcon
			result.SetTime = SetTime
			result.SetName = SetName
			result.SetStacks = SetStacks
			result.SetAuraInfo = SetAuraInfo
			result.SetColor = SetColor
			result.SetCastSpellId = SetCastSpellId
			
			return result
		end
	end

	-- private
	local SetAuraBar = function( self, index, auraInfo )
		local line = self.lines[ index ]
		if ( line == nil ) then
			line = CreateAuraBar( self )
			if ( index == 1 ) then
				line:SetPoint( "TOPLEFT", self, "BOTTOMLEFT", 0, BAR_HEIGHT )
				line:SetPoint( "BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0 )
			else
				local anchor = self.lines[ index - 1 ]
				line:SetPoint( "TOPLEFT", anchor, "TOPLEFT", 0, BAR_HEIGHT + BAR_SPACING )
				line:SetPoint( "BOTTOMRIGHT", anchor, "TOPRIGHT", 0, BAR_SPACING )
			end
			tinsert( self.lines, index, line )
		end	
		
		line:SetAuraInfo( auraInfo )
		if ( auraInfo.color ) then
			line:SetColor( auraInfo.color )
		elseif ( auraInfo.debuffColor and auraInfo.isDebuff ) then
			line:SetColor( auraInfo.debuffColor )
		elseif ( auraInfo.defaultColor ) then
			line:SetColor( auraInfo.defaultColor )
		end
		
		line:Show()
	end
	
	local function OnUnitAura( self, unit )
		if ( unit ~= self.unit and ( self.dataSource:GetIncludePlayer() == false or unit ~= "player" ) ) then
			return
		end
		
		self:Render()
	end
	
	local function OnPlayerTargetChanged( self, method )
		self:Render()
	end
	
	local function OnPlayerEnteringWorld( self )
		self:Render()
	end
	
	local function OnEvent( self, event, ... )
		if ( event == "UNIT_AURA" ) then
			OnUnitAura( self, ... )
		elseif ( event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" ) then
			OnPlayerTargetChanged( self, ... )
		elseif ( event == "PLAYER_ENTERING_WORLD" ) then
			OnPlayerEnteringWorld( self )
		else
			error( "Unhandled event " .. event )
		end
	end
	
	-- public
	local function Render( self )
		local dataSource = self.dataSource	

		dataSource:Update()
		dataSource:Sort()
		
		local count = dataSource:Count()

		for index, auraInfo in ipairs( dataSource:Get() ) do
			SetAuraBar( self, index, auraInfo )
		end
		
		for index = count + 1, 80 do
			local line = self.lines[ index ]
			if ( line == nil or not line:IsShown() ) then
				break
			end
			line:Hide()
		end
		
		if ( count > 0 ) then
			self:SetHeight( ( BAR_HEIGHT + BAR_SPACING ) * count - BAR_SPACING )
			self:Show()
		else
			self:Hide()
			self:SetHeight( self.hiddenHeight or 1 )
		end
	end
	
	local function SetHiddenHeight( self, height )
		self.hiddenHeight = height
	end

	-- constructor
	CreateAuraBarFrame = function( dataSource, parent )
		local result = CreateFrame( "Frame", nil, parent, nil )
		local unit = dataSource:GetUnit()
		
		result.unit = unit
		
		result.lines = { }		
		result.dataSource = dataSource
		
		local background = CreateFrame("Frame", "background", result, nil)
		TukuiDB.SkinFadedPanel(background)
		background:SetPoint( "TOPLEFT", -TukuiDB.Scale(2), TukuiDB.Scale(2))
		background:SetPoint( "BOTTOMRIGHT", TukuiDB.Scale(2), -TukuiDB.Scale(2))
	
		if TukuiCF["ct"].icons == true then
			local iconFrame = CreateFrame("Frame", nil, result)
			iconFrame:SetPoint( "TOPLEFT", result, "TOPLEFT", -TukuiDB.Scale(BAR_HEIGHT + 9), TukuiDB.Scale(2))
			iconFrame:SetPoint( "BOTTOMRIGHT", result, "BOTTOMLEFT", TukuiDB.Scale(-4), -TukuiDB.Scale(2))
			if TukuiCF["panels"].shadows == true then
				TukuiDB.StyleShadow(iconFrame)
			end
		end
	
		result:RegisterEvent( "PLAYER_ENTERING_WORLD" )
		result:RegisterEvent( "UNIT_AURA" )
		if ( unit == "target" ) then
			result:RegisterEvent( "PLAYER_TARGET_CHANGED" )
		end
		if ( unit == "focus" ) then
			result:RegisterEvent( "PLAYER_FOCUS_CHANGED" );
		end
		
		result:SetScript( "OnEvent", OnEvent )
		
		result.Render = Render
		result.SetHiddenHeight = SetHiddenHeight
		
		return result
	end
end

local _, playerClass = UnitClass( "player" )
local classFilter = CLASS_FILTERS[ playerClass ]

local yOffset = TukuiDB.Scale(7)
local cOffset = TukuiDB.Scale(10)
local uOffset = TukuiDB.Scale(1)
local iOffset = TukuiDB.Scale(22)

local targetDataSource = CreateUnitAuraDataSource( "target" )
local playerDataSource = CreateUnitAuraDataSource( "player" )
local trinketDataSource = CreateUnitAuraDataSource( "player" )
local focusDataSource = CreateUnitAuraDataSource( "focus" )

targetDataSource:SetSortDirection( SORT_DIRECTION )
playerDataSource:SetSortDirection( SORT_DIRECTION )
trinketDataSource:SetSortDirection( SORT_DIRECTION )
focusDataSource:SetSortDirection( SORT_DIRECTION )

if ( classFilter ) then
	targetDataSource:AddFilter( classFilter.target, TARGET_BAR_COLOR, TARGET_DEBUFF_COLOR )		
	playerDataSource:AddFilter( classFilter.player, PLAYER_BAR_COLOR, PLAYER_DEBUFF_COLOR )
	trinketDataSource:AddFilter( classFilter.procs, TRINKET_BAR_COLOR )
end
trinketDataSource:AddFilter( TRINKET_FILTER, TRINKET_BAR_COLOR )
focusDataSource:AddFilter( FOCUS_FILTERS, PLAYER_BAR_COLOR )

local playerFrame = CreateAuraBarFrame( playerDataSource, oUF_Tukz_player )
playerFrame:SetHiddenHeight( -yOffset )
if TukuiCF["unitframes"].playerauras then
	if TukuiCF["ct"].icons == true then
		playerFrame:SetPoint( "BOTTOMLEFT", oUF_Tukz_player.Debuffs, "TOPLEFT", iOffset - 1, yOffset + cOffset )
	else
		playerFrame:SetPoint( "BOTTOMLEFT", oUF_Tukz_player.Debuffs, "TOPLEFT", uOffset, yOffset + cOffset )
	end
	playerFrame:SetPoint( "BOTTOMRIGHT", oUF_Tukz_player.Debuffs, "TOPRIGHT", -uOffset, yOffset + cOffset )
else
	if ( playerClass == "DEATHKNIGHT" and TukuiCF["unitframes"].runebar == true ) or ( playerClass == "SHAMAN" and TukuiCF["unitframes"].totemtimer == true ) or ( playerClass == "PALADIN" or playerClass == "WARLOCK" or playerClass == "DRUID" ) then
		if TukuiCF["ct"].icons == true then
			playerFrame:SetPoint( "BOTTOMLEFT", oUF_Tukz_player, "TOPLEFT", iOffset, yOffset + cOffset )
		else
			playerFrame:SetPoint( "BOTTOMLEFT", oUF_Tukz_player, "TOPLEFT", uOffset, yOffset + cOffset )
		end
		playerFrame:SetPoint( "BOTTOMRIGHT", oUF_Tukz_player, "TOPRIGHT", -uOffset, yOffset + cOffset )
	else
		if TukuiCF["ct"].icons == true then
			playerFrame:SetPoint( "BOTTOMLEFT", oUF_Tukz_player, "TOPLEFT", iOffset, yOffset - uOffset )
		else
			playerFrame:SetPoint( "BOTTOMLEFT", oUF_Tukz_player, "TOPLEFT", uOffset, yOffset - uOffset )
		end
		playerFrame:SetPoint( "BOTTOMRIGHT", oUF_Tukz_player, "TOPRIGHT", -uOffset, yOffset - uOffset )
	end
end
playerFrame:Show()

local trinketFrame = CreateAuraBarFrame( trinketDataSource, oUF_Tukz_player )
trinketFrame:SetHiddenHeight( -yOffset )
trinketFrame:SetPoint( "BOTTOMLEFT", playerFrame, "TOPLEFT", 0, yOffset )
trinketFrame:SetPoint( "BOTTOMRIGHT", playerFrame, "TOPRIGHT", 0, yOffset )
trinketFrame:Show()
	
local targetFrame = CreateAuraBarFrame( targetDataSource, oUF_Tukz_player )
targetFrame:SetHiddenHeight( -yOffset )
targetFrame:SetPoint( "BOTTOMLEFT", trinketFrame, "TOPLEFT", 0, yOffset )
targetFrame:SetPoint( "BOTTOMRIGHT", trinketFrame, "TOPRIGHT", 0, yOffset )
targetFrame:Show()

-- if TukuiCF["ct"].showfocus == true then
	-- local focusFrame = CreateAuraBarFrame( focusDataSource, oUF_Tukz_focus )
	-- focusFrame:SetHiddenHeight( -yOffset )
	-- focusFrame:SetWidth(140)
	-- focusFrame:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 )
	-- focusFrame:Show()
-- end