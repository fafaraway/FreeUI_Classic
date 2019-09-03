local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')


local format, min, max, floor, mod, pairs = string.format, math.min, math.max, math.floor, mod, pairs
local cfg, myClass = C.unitframe, C.Class
local LCD = F.LibClassicDurations

local ignoredDebuffs = {
	[  6788] = myClass ~= 'PRIEST',		-- Weakened Soul
	[ 25771] = myClass ~= 'PALADIN',	-- Forbearance

	[ 57724] = true, 	-- Sated
	[ 57723] = true,  	-- Exhaustion
	[ 80354] = true,  	-- Temporal Displacement
	[ 41425] = true,  	-- Hypothermia
	[ 95809] = true,  	-- Insanity
	[ 36032] = true,  	-- Arcane Blast
	[ 26013] = true,  	-- Deserter
	[ 95223] = true,  	-- Recently Mass Resurrected
	[ 97821] = true,  	-- Void-Touched (death knight resurrect)
	[ 36893] = true,  	-- Transporter Malfunction
	[ 36895] = true,  	-- Transporter Malfunction
	[ 36897] = true,  	-- Transporter Malfunction
	[ 36899] = true,  	-- Transporter Malfunction
	[ 36900] = true,  	-- Soul Split: Evil!
	[ 36901] = true,  	-- Soul Split: Good
	[ 25163] = true,  	-- Disgusting Oozeling Aura
	[ 85178] = true,  	-- Shrink (Deviate Fish)
	[  8064] = true,   	-- Sleepy (Deviate Fish)
	[  8067] = true,   	-- Party Time! (Deviate Fish)
	[ 24755] = true,  	-- Tricked or Treated (Hallow's End)
	[ 42966] = true, 	-- Upset Tummy (Hallow's End)
	[ 89798] = true, 	-- Master Adventurer Award (Maloriak kill title)
	[  6788] = true,   	-- Weakened Soul
	[ 92331] = true, 	-- Blind Spot (Jar of Ancient Remedies)
	[ 71041] = true, 	-- Dungeon Deserter
	[ 26218] = true,  	-- Mistletoe
	[117870] = true,	-- Touch of the Titans
	[173658] = true, 	-- Delvar Ironfist defeated
	[173659] = true, 	-- Talonpriest Ishaal defeated
	[173661] = true, 	-- Vivianne defeated
	[173679] = true, 	-- Leorajh defeated
	[173649] = true, 	-- Tormmok defeated
	[173660] = true, 	-- Aeda Brightdawn defeated
	[173657] = true, 	-- Defender Illona defeated
	[206151] = true, 	-- 挑战者的负担
	[260738] = true, 	-- 艾泽里特残渣
	[279737] = true,	-- 准备作战 (海岛)
	[264689] = true,	-- 疲倦
	[289423] = true,	-- 死亡的重担
	[283430] = true,	-- 工程学专精
}

local importantBuffs = {
	-- Immunities
	[196555] = true,	-- Netherwalk (Demon Hunter)
	[186265] = true,	-- Aspect of the Turtle (Hunter)
	[ 45438] = true,	-- Ice Block (Mage)
	[125174] = true,	-- Touch of Karma (Monk)
	[228050] = true,	-- Divine Shield (Prot Paladin PVP)
	[   642] = true,	-- Divine Shield (Paladin)
	[199448] = true,	-- Blessing of Ultimate Sacrifice (Paladin)
	[  1022] = true,	-- Blessing of Protection (Paladin)
	[ 47788] = true,	-- Guardian Spirit (Priest)
	[ 31224] = true,	-- Cloak of Shadows (Rogue)
	[210918] = true,	-- Ethereal Form (Shaman)

	-- Defensive buffs
	-- Warrior
	[190456] = true,	-- Ignore Pain
	[118038] = true,	-- Die by the Sword
	[   871] = true,	-- Shield Wall
	[213915] = true,	-- Mass Spell Reflection
	[ 23920] = true,	-- Spell Reflection (Prot)
	[216890] = true,	-- Spell Reflection (Arms/Fury)
	[184364] = true,	-- Enraged Regeneration
	[ 97463] = true,	-- Rallying Cry
	[ 12975] = true,	-- Last Stand

	-- Death Knight
	[ 48707] = true,	-- Anti-Magic Shell
	[ 48792] = true,	-- Icebound Fortitude
	[287081] = true,	-- Lichborne
	[ 55233] = true,	-- Vampiric Blood
	[194679] = true,	-- Rune Tap
	[145629] = true,	-- Anti-Magic Zone
	[ 81256] = true,	-- Dancing Rune Weapon

	-- Paladin
	[204018] = true,	-- Blessing of Spellwarding
	[  6940] = true,	-- Blessing of Sacrifice
	[   498] = true,	-- Divine Protection
	[ 31850] = true,	-- Ardent Defender
	[ 86659] = true,	-- Guardian of Ancient Kings
	[205191] = true,	-- Eye for an Eye

	-- Shaman
	[108271] = true,	-- Astral Shift
	[118337] = true,	-- Harden Skin

    -- Hunter
	[ 53480] = true,	-- Roar of Sacrifice
	[264735] = true,	-- Survival of the Fittest (Pet Ability)
	[281195] = true,	-- Survival of the Fittest (Lone Wolf)

	-- Demon Hunter
	[206804] = true,	-- Rain from Above
	[187827] = true,	-- Metamorphosis (Vengeance)
	[212800] = true,	-- Blur
	[263648] = true,	-- Soul Barrier

	-- Druid
	[102342] = true,	-- Ironbark
	[ 22812] = true,	-- Barkskin
	[ 61336] = true,	-- Survival Instincts

	-- Rogue
	[ 45182] = true,	-- Cheating Death
	[  5277] = true,	-- Evasion
	[199754] = true,	-- Riposte
	[  1966] = true,	-- Feint

	-- Monk
	[120954] = true,	-- Fortifying Brew (Brewmaster)
	[243435] = true,	-- Fortifying Brew (Mistweaver)
	[201318] = true,	-- Fortifying Brew (Windwalker)
	[115176] = true,	-- Zen Meditation
	[116849] = true,	-- Life Cocoon
	[122278] = true,	-- Dampen Harm
	[122783] = true,	-- Diffuse Magic

	-- Mage
	[198111] = true,	-- Temporal Shield
	[113862] = true,	-- Greater Invisibility

	-- Priest
	[ 47585] = true,	-- Dispersion
	[ 33206] = true,	-- Pain Suppression
	[213602] = true,	-- Greater Fade
	[ 81782] = true,	-- Power Word: Barrier
	[271466] = true,	-- Luminous Barrier

	-- Warlock
	[104773] = true, 	-- Unending Resolve
	[108416] = true, 	-- Dark Pact
	[212195] = true,	-- Nether Ward
}

local classBuffs = {
	['PRIEST'] = {
		[194384] = true,	-- 救赎
		[214206] = true,	-- 救赎(PvP)
		[ 41635] = true,	-- 愈合导言
		[193065] = true,	-- 忍辱负重
		[   139] = true,	-- 恢复
		[    17] = true,	-- 真言术盾
		[ 47788] = true,	-- 守护之魂
		[ 33206] = true,	-- 痛苦压制
	},
	['DRUID'] = {
		[   774] = true,	-- 回春
		[155777] = true,	-- 萌芽
		[  8936] = true,	-- 愈合
		[ 33763] = true,	-- 生命绽放
		[ 48438] = true,	-- 野性成长
		[207386] = true,	-- 春暖花开
		[102351] = true,	-- 结界
		[102352] = true,	-- 结界(HoT)
		[200389] = true,	-- 栽培
	},
	['PALADIN'] = {
		[ 53563] = true,	-- 道标
		[156910] = true,	-- 信仰道标
		[200025] = true,	-- 美德道标
		[  1022] = true,	-- 保护
		[  1044] = true,	-- 自由
		[  6940] = true,	-- 牺牲
		[223306] = true,	-- 赋予信仰
	},
	['SHAMAN'] = {
		[ 61295] = true,	-- 激流
		[   974] = true,	-- 大地之盾
		[207400] = true,	-- 先祖活力
	},
	['MONK'] = {
		[119611] = true,	-- 复苏之雾
		[116849] = true,	-- 作茧缚命
		[124682] = true,	-- 氤氲之雾
		[191840] = true,	-- 精华之泉
	},
	['ROGUE'] = {
		[ 57934] = true,	-- 嫁祸
	},
	['WARRIOR'] = {
		[114030] = true,	-- 警戒
	},
	['HUNTER'] = {
		[ 34477] = true,	-- 误导
		[ 90361] = true,	-- 灵魂治愈
	},
	['WARLOCK'] = {
		[ 20707] = true,	-- 灵魂石
	},
	['DEMONHUNTER'] = {},
	['MAGE'] = {},
	['DEATHKNIGHT'] = {},
}

local function PostCreateIcon(element, button)
	button.bg = F.CreateBDFrame(button)
	button.glow = F.CreateSD(button.bg, .35, 2, 2)
	
	button.overlay:SetTexture(nil)
	button.stealable:SetAtlas('bags-newitem')
	
	button.icon:SetDrawLayer('ARTWORK')
	button.icon:SetTexCoord(.08, .92, .25, .85)

	button.hl = button:CreateTexture(nil, 'HIGHLIGHT')
	button.hl:SetColorTexture(1, 1, 1, .25)
	button.hl:SetAllPoints()

	button.count = F.CreateFS(button, 'pixel', '', nil, true, 'TOPRIGHT', 2, 4)

	element.disableCooldown = true
	button.cd:SetReverse(true)

	button.timer = F.CreateFS(button, 'pixel', '', nil, true, 'BOTTOMLEFT', 2, -4)
end

local filteredUnits = {
	['target'] = true,
	['boss'] = true,
}

local function PostUpdateIcon(element, unit, button, index, _, duration, expiration, debuffType)
	if duration then button.bg:Show() end
	if duration then button.glow:Show() end

	if duration == 0 then
		local name, _, _, _, _, _, caster, _, _, spellID = LCD:UnitAura(unit, index, button.filter)
		duration, expiration = LCD:GetAuraDurationByUnit(unit, spellID, caster, name)
		if duration and duration > 0 then
			if button.cd and not element.disableCooldown then
				button.cd:SetCooldown(expiration - duration, duration)
				button.cd:Show()
			end
		end
	end

	if duration and duration > 0 then
		button.expiration = expiration
		button:SetScript('OnUpdate', F.CooldownOnUpdate)
		button.timer:Show()
	else
		button:SetScript('OnUpdate', nil)
		button.timer:Hide()
	end

	local style = element.__owner.unitStyle

	if not (style == 'party' and button.isDebuff) then
		button:SetSize(element.size, element.size*.75)
	end

	if (style == 'party' and not button.isDebuff) or style == 'raid' or style == 'pet' then
		button.timer:Hide()
	end

	if button.isDebuff and element.showDebuffType then
		local color = FreeUI.oUF.colors.debuff[debuffType] or FreeUI.oUF.colors.debuff.none
		button.bg:SetBackdropBorderColor(color[1], color[2], color[3])

		if button.glow then
			button.glow:SetBackdropBorderColor(color[1], color[2], color[3], .5)
		end
	elseif (style == 'party' or style == 'raid') and not button.isDebuff then
		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, 0)
		end
	else
		button.bg:SetBackdropBorderColor(0, 0, 0)

		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, .35)
		end
	end

	if button.isDebuff and not button.isPlayer and filteredUnits[style] then
		button.icon:SetDesaturated(true)
	else
		button.icon:SetDesaturated(false)
	end
end

local function CustomFilter(element, unit, button, name, _, _, _, _, _, caster, isStealable, _, spellID)
	local style = element.__owner.unitStyle

	if style == 'target' then
		if (cfg.debuffbyPlayer and button.isDebuff and not button.isPlayer) then
			return false
		else
			return true
		end
	elseif style == 'boss' then
		if (button.isDebuff and not button.isPlayer) then
			return false
		else
			return true
		end
	elseif style == 'party' or style == 'raid' then
		if (button.isDebuff and not ignoredDebuffs[spellID]) then
			return true
		elseif (button.isPlayer and classBuffs[myClass][spellID]) or (importantBuffs[spellID]) then
			return true
		else
			return false
		end
	elseif style == 'pet' then
		return true
	end
end
UNITFRAME.CustomFilter = CustomFilter

local function PostUpdateGapIcon(_, _, icon)
	if icon.bg and icon.bg:IsShown() then
		icon.bg:Hide()
	end
	if icon.glow and icon.glow:IsShown() then
		icon.glow:Hide()
	end
end

local function AuraIconSize(w, n, s)
	return (w-(n-1)*s)/n
end

function UNITFRAME:AddAuras(self)
	local num, perrow = 0, 0
	local Auras = CreateFrame('Frame', nil, self)

	if self.unitStyle == 'target' then
		Auras.initialAnchor = 'BOTTOMLEFT'
		Auras:SetPoint('BOTTOM', self, 'TOP', 0, 24)
		Auras['growth-y'] = 'UP'
		Auras['spacing-x'] = 5
		num = 36
		perrow = 6
	elseif self.unitStyle == 'pet' or self.unitStyle == 'boss' then
		Auras.initialAnchor = 'TOPLEFT'
		Auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		Auras['growth-y'] = 'DOWN'
		Auras['spacing-x'] = 5
	elseif self.unitStyle == 'pet' then
		num = 9
		perrow = 3
	elseif self.unitStyle == 'boss' then
		num = 20
		perrow = 5
	end

	Auras.numTotal = num
	Auras.iconsPerRow = perrow

	Auras.gap = true
	Auras.showDebuffType = true
	Auras.showStealableBuffs = true
	Auras.onlyShowPlayer = true

	Auras.size = AuraIconSize(self:GetWidth(), Auras.iconsPerRow, 5)
	Auras:SetWidth(self:GetWidth())
	Auras:SetHeight((Auras.size) * F.Round(Auras.numTotal/Auras.iconsPerRow))

	Auras.CustomFilter = CustomFilter
	Auras.PostCreateIcon = PostCreateIcon
	Auras.PostUpdateIcon = PostUpdateIcon
	Auras.PostUpdateGapIcon = PostUpdateGapIcon

	self.Auras = Auras
end

function UNITFRAME:AddBuffs(self)
	local buffs = CreateFrame('Frame', nil, self)
	buffs.initialAnchor = 'CENTER'
	--buffs:SetPoint('TOP', 0, -2)
	buffs['growth-x'] = 'RIGHT'
	buffs.spacing = 3
	buffs.num = 3
	
	if self.unitStyle == 'party' then
		buffs.size = 18
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -20, -2)
			elseif icons.visibleBuffs == 2 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -10, -2)
			else
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	else
		buffs.size = 12
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -14, -2)
			elseif icons.visibleBuffs == 2 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -7, -2)
			else
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	end

	buffs:SetSize((buffs.size*buffs.num)+(buffs.num-1)*buffs.spacing, buffs.size)

	buffs.disableCooldown = true
	buffs.disableMouse = true
	buffs.PostCreateIcon = PostCreateIcon
	buffs.PostUpdateIcon = PostUpdateIcon
	buffs.CustomFilter = CustomFilter

	self.Buffs = buffs
end

function UNITFRAME:AddDebuffs(self)
	local debuffs = CreateFrame('Frame', nil, self)
	
	if self.unitStyle == 'party' and not cfg.healer then
		debuffs.initialAnchor = 'LEFT'
		debuffs['growth-x'] = 'RIGHT'
		debuffs:SetPoint('LEFT', self, 'RIGHT', 6, 0)
		debuffs.size = 24
		debuffs.num = 4
		debuffs.disableCooldown = false
		debuffs.disableMouse = false
	else
		debuffs.initialAnchor = 'CENTER'
		debuffs['growth-x'] = 'RIGHT'
		debuffs:SetPoint('BOTTOM', 0, cfg.power_height - 1)
		debuffs.size = 16
		debuffs.num = 2
		debuffs.disableCooldown = true
		debuffs.disableMouse = true

		debuffs.PostUpdate = function(icons)
			if icons.visibleDebuffs == 2 then
				debuffs:ClearAllPoints()
				debuffs:SetPoint('BOTTOM', -9, 0)
			else
				debuffs:ClearAllPoints()
				debuffs:SetPoint('BOTTOM')
			end
		end
	end

	debuffs.spacing = 5
	debuffs:SetSize((debuffs.size*debuffs.num)+(debuffs.num-1)*debuffs.spacing, debuffs.size)
	debuffs.showDebuffType = true
	debuffs.PostCreateIcon = PostCreateIcon
	debuffs.PostUpdateIcon = PostUpdateIcon
	debuffs.CustomFilter = CustomFilter

	self.Debuffs = debuffs
end