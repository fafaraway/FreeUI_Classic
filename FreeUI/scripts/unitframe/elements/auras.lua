local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')


local format, min, max, floor, mod, pairs = string.format, math.min, math.max, math.floor, mod, pairs
local cfg, myClass = C.unitframe, C.Class
local LCD = F.LibClassicDurations

local ignoredDebuffs = {
	
}

local importantBuffs = {

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

	['MAGE'] = {},
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
	elseif self.unitStyle == 'pet' then
		Auras.initialAnchor = 'TOPLEFT'
		Auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		Auras['growth-y'] = 'DOWN'
		Auras['spacing-x'] = 5
		num = 9
		perrow = 3
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
		debuffs:SetPoint('BOTTOM', 0, cfg.powerHeight - 1)
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