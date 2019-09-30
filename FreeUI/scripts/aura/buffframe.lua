local F, C, L = unpack(select(2, ...))
local AURA, cfg = F:RegisterModule('Aura'), C.aura


local _G = getfenv(0)
local format, floor, strmatch, select, unpack = format, floor, strmatch, select, unpack
local DebuffTypeColor = _G.DebuffTypeColor
local UnitAura, GetTime = UnitAura, GetTime
local GetInventoryItemQuality, GetInventoryItemTexture, GetItemQualityColor, GetWeaponEnchantInfo = GetInventoryItemQuality, GetInventoryItemTexture, GetItemQualityColor, GetWeaponEnchantInfo
local margin, offset, settings = 6, 12
local day, hour, minute = 86400, 3600, 60

function AURA:OnLogin()
	settings = {
		Buffs = {
			size = cfg.buffSize,
			wrapAfter = cfg.buffsPerRow,
			maxWraps = 3,
			reverseGrow = cfg.reverseBuffs,
		},
		Debuffs = {
			size = cfg.debuffSize,
			wrapAfter = cfg.debuffsPerRow,
			maxWraps = 1,
			reverseGrow = cfg.reverseDebuffs,
		},
	}

	F.HideObject(_G.BuffFrame)
	F.HideObject(_G.TemporaryEnchantFrame)

	self.BuffFrame = self:CreateAuraHeader('HELPFUL')
	local buffAnchor = F.Mover(self.BuffFrame, L['MOVER_BUFFS'], 'BuffsFrame', {'TOPRIGHT', UIParent, 'TOPRIGHT', -50, -50})
	self.BuffFrame:ClearAllPoints()
	self.BuffFrame:SetPoint('TOPRIGHT', buffAnchor)

	self.DebuffFrame = self:CreateAuraHeader('HARMFUL')
	local debuffAnchor = F.Mover(self.DebuffFrame, L['MOVER_DEBUFFS'], 'DebuffsFrame', {'TOPRIGHT', buffAnchor, 'BOTTOMRIGHT', 0, -12})
	self.DebuffFrame:ClearAllPoints()
	self.DebuffFrame:SetPoint('TOPRIGHT', debuffAnchor)

	self:BuffReminder()
end

function AURA:FormatAuraTime(s)
	if s >= day then
		return format('%d'..C.InfoColor..'d', s/day), s%day
	elseif s >= hour then
		return format('%d'..C.InfoColor..'h', s/hour), s%hour
	elseif s >= 10*minute then
		return format('%d'..C.InfoColor..'m', s/minute), s%minute
	elseif s >= minute then
		return format('%d:%.2d', s/minute, s%minute), s - floor(s)
	elseif s > 10 then
		return format('%d'..C.InfoColor..'s', s), s - floor(s)
	elseif s > 5 then
		return format('|cffffff00%.1f|r', s), s - format('%.1f', s)
	else
		return format('|cffff0000%.1f|r', s), s - format('%.1f', s)
	end
end

function AURA:UpdateTimer(elapsed)
	if self.offset then
		local expiration = select(self.offset, GetWeaponEnchantInfo())
		if expiration then
			self.timeLeft = expiration / 1e3
		else
			self.timeLeft = 0
		end
	else
		self.timeLeft = self.timeLeft - elapsed
	end

	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end

	if self.timeLeft >= 0 then
		local timer, nextUpdate = AURA:FormatAuraTime(self.timeLeft)
		self.nextUpdate = nextUpdate
		self.timer:SetText(timer)
	end
end

function AURA:UpdateAuras(button, index)
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute('unit')
	local name, texture, count, debuffType, duration, expirationTime = UnitAura(unit, index, filter)

	if name then
		if duration > 0 and expirationTime then
			local timeLeft = expirationTime - GetTime()
			if not button.timeLeft then
				button.nextUpdate = -1
				button.timeLeft = timeLeft
				button:SetScript('OnUpdate', AURA.UpdateTimer)
			else
				button.timeLeft = timeLeft
			end
			-- need reviewed
			button.nextUpdate = -1
			AURA.UpdateTimer(button, 0)
		else
			button.timeLeft = nil
			button.timer:SetText('')
			button:SetScript('OnUpdate', nil)
		end

		if count and count > 1 then
			button.count:SetText(count)
		else
			button.count:SetText('')
		end

		if filter == 'HARMFUL' then
			local color = DebuffTypeColor[debuffType or 'none']
			button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			button.glow:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			button.bg:SetBackdropBorderColor(0, 0, 0)
			button.glow:SetBackdropBorderColor(0, 0, 0, .35)
		end

		button.icon:SetTexture(texture)
		button.offset = nil
	end
end

function AURA:UpdateTempEnchant(button, index)
	local quality = GetInventoryItemQuality('player', index)
	button.icon:SetTexture(GetInventoryItemTexture('player', index))

	local offset = 2
	local weapon = button:GetName():sub(-1)
	if strmatch(weapon, '2') then
		offset = 6
	end

	if quality then
		button:SetBackdropBorderColor(GetItemQualityColor(quality))
	end

	local expirationTime, count = select(offset, GetWeaponEnchantInfo())
	if expirationTime then
		if count and count > 0 then
			button.count:SetText(count)
		else
			button.count:SetText('')
		end
		button.offset = offset
		button:SetScript('OnUpdate', AURA.UpdateTimer)
		button.nextUpdate = -1
		AURA.UpdateTimer(button, 0)
	else
		button.offset = nil
		button.timeLeft = nil
		button:SetScript('OnUpdate', nil)
		button.timer:SetText('')
		button.count:SetText('')
	end
end

function AURA:OnAttributeChanged(attribute, value)
	if attribute == 'index' then
		AURA:UpdateAuras(self, value)
	elseif attribute == 'target-slot' then
		AURA:UpdateTempEnchant(self, value)
	end
end

function AURA:UpdateHeader(header)
	local cfg = settings.Debuffs
	if header:GetAttribute('filter') == 'HELPFUL' then
		cfg = settings.Buffs
		header:SetAttribute('consolidateTo', 0)
		header:SetAttribute('weaponTemplate', format('FreeUIAuraTemplate%d', cfg.size))
	end

	header:SetAttribute('separateOwn', 1)
	header:SetAttribute('sortMethod', 'INDEX')
	header:SetAttribute('sortDirection', '+')
	header:SetAttribute('wrapAfter', cfg.wrapAfter)
	header:SetAttribute('maxWraps', cfg.maxWraps)
	header:SetAttribute('point', cfg.reverseGrow and 'TOPLEFT' or 'TOPRIGHT')
	header:SetAttribute('minWidth', (cfg.size + margin)*cfg.wrapAfter)
	header:SetAttribute('minHeight', (cfg.size + offset)*cfg.maxWraps)
	header:SetAttribute('xOffset', (cfg.reverseGrow and 1 or -1) * (cfg.size + margin))
	header:SetAttribute('yOffset', 0)
	header:SetAttribute('wrapXOffset', 0)
	header:SetAttribute('wrapYOffset', -(cfg.size + offset))
	header:SetAttribute('template', format('FreeUIAuraTemplate%d', cfg.size))

	local index = 1
	local child = select(index, header:GetChildren())
	while child do
		if (floor(child:GetWidth() * 100 + .5) / 100) ~= cfg.size then
			child:SetSize(cfg.size, cfg.size)
		end

		--Blizzard bug fix, icons arent being hidden when you reduce the amount of maximum buttons
		if index > (cfg.maxWraps * cfg.wrapAfter) and child:IsShown() then
			child:Hide()
		end

		index = index + 1
		child = select(index, header:GetChildren())
	end
end

function AURA:CreateAuraHeader(filter)
	local name = 'FreeUIPlayerDebuffs'
	if filter == 'HELPFUL' then name = 'FreeUIPlayerBuffs' end

	local header = CreateFrame('Frame', name, UIParent, 'SecureAuraHeaderTemplate')
	header:SetClampedToScreen(true)
	header:SetAttribute('unit', 'player')
	header:SetAttribute('filter', filter)
	RegisterStateDriver(header, 'visibility', '[petbattle] hide; show')
	RegisterAttributeDriver(header, 'unit', '[vehicleui] vehicle; player')

	if filter == 'HELPFUL' then
		header:SetAttribute('consolidateDuration', -1)
		header:SetAttribute('includeWeapons', 1)
	end

	AURA:UpdateHeader(header)
	header:Show()

	return header
end

function AURA:CreateAuraIcon(button)
	local header = button:GetParent()
	local cfg = settings.Debuffs
	if header:GetAttribute('filter') == 'HELPFUL' then
		cfg = settings.Buffs
	end
	local fontSize = floor(cfg.size/30*12 + .5)

	button.icon = button:CreateTexture(nil, 'BORDER')
	button.icon:SetPoint('TOPLEFT', C.Mult, -C.Mult)
	button.icon:SetPoint('BOTTOMRIGHT', -C.Mult, C.Mult)
	button.icon:SetTexCoord(unpack(C.TexCoord))

	button.count = button:CreateFontString(nil, 'ARTWORK')
	button.count:SetPoint('TOPRIGHT', -1, -3)
	F.SetFS(button.count, 'pixel')

	button.timer = button:CreateFontString(nil, 'ARTWORK')
	button.timer:SetPoint('TOP', button, 'BOTTOM', 1, 2)
	F.SetFS(button.timer, 'pixel')

	button.highlight = button:CreateTexture(nil, 'HIGHLIGHT')
	button.highlight:SetColorTexture(1, 1, 1, .25)
	button.highlight:SetAllPoints(button.icon)

	button.bg = F.CreateBDFrame(button)
	button.glow = F.CreateSD(button, .35)

	button:SetScript('OnAttributeChanged', AURA.OnAttributeChanged)
end