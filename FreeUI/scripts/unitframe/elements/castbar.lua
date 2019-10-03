local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


local unpack = unpack
local GetTime, UnitIsUnit = GetTime, UnitIsUnit
local CastingInfo = CastingInfo
local ChannelInfo = ChannelInfo

local LibClassicCasterino = LibStub('LibClassicCasterino', true)
if(LibClassicCasterino) then
	UnitChannelInfo = function(unit)
		return LibClassicCasterino:UnitChannelInfo(unit)
	end
end

local function GetSpellName(spellID)
	local name = GetSpellInfo(spellID)
	if not name then
		print('oUF-Plugins-Castbar: '.. spellID..' not found.')
		return 0
	end
	return name
end

local channelingTicks = {
	[GetSpellName(740)] = 4,		-- 宁静
	[GetSpellName(755)] = 3,		-- 生命通道
	[GetSpellName(5143)] = 5, 		-- 奥术飞弹
	[GetSpellName(12051)] = 3, 		-- 唤醒
	[GetSpellName(15407)] = 4,		-- 精神鞭笞
}

local ticks = {}
local function updateCastBarTicks(bar, numTicks)
	if numTicks and numTicks > 0 then
		local delta = bar:GetWidth() / numTicks
		for i = 1, numTicks do
			if not ticks[i] then
				ticks[i] = bar:CreateTexture(nil, 'OVERLAY')
				ticks[i]:SetTexture(C.media.sbTex)
				ticks[i]:SetVertexColor(0, 0, 0, .7)
				ticks[i]:SetWidth(C.Mult)
				ticks[i]:SetHeight(bar:GetHeight())
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint('CENTER', bar, 'LEFT', delta * i, 0 )
			ticks[i]:Show()
		end
	else
		for _, tick in pairs(ticks) do
			tick:Hide()
		end
	end
end

local function FixTargetCastbarUpdate(self)
	if UnitIsUnit('target', 'player') and not CastingInfo() and not ChannelInfo() then
		self.casting = nil
		self.channeling = nil
		self.Text:SetText(INTERRUPTED)
		self.holdTime = 0
	end
end

local function OnCastbarUpdate(self, elapsed)
	if self.casting or self.channeling then
		FixTargetCastbarUpdate(self)

		local decimal = self.decimal

		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end

		if self.__owner.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText(decimal..' | |cffff0000'..decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText(decimal..' | '..decimal, duration, self.max)
				if self.Lag and self.SafeZone and self.SafeZone.timeDiff and self.SafeZone.timeDiff ~= 0 then
					self.Lag:SetFormattedText('%d ms', self.SafeZone.timeDiff * 1000)
				end
			end
		else
			if duration > 1e4 then
				self.Time:SetText('∞ | ∞')
			else
				self.Time:SetFormattedText(decimal..' | '..decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			end
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	elseif self.holdTime > 0 then
		self.holdTime = self.holdTime - elapsed
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - .02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

local function OnCastSent(self)
	local element = self.Castbar
	if not element.SafeZone then return end
	element.SafeZone.sendTime = GetTime()
	element.SafeZone.castSent = true
end

local function PostCastStart(self, unit)
	self:SetAlpha(1)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))

	if unit == 'player' then
		local safeZone = self.SafeZone
		if not safeZone then return end
 
		safeZone.timeDiff = 0
		if safeZone.castSent then
			safeZone.timeDiff = GetTime() - safeZone.sendTime
			safeZone.timeDiff = safeZone.timeDiff > self.max and self.max or safeZone.timeDiff
			safeZone:SetWidth(self:GetWidth() * (safeZone.timeDiff + .001) / self.max)
			safeZone:Show()
			safeZone.castSent = false
		end

		local numTicks = 0
		if self.channeling then
			local spellID = UnitChannelInfo(unit)
			numTicks = channelingTicks[spellID] or 0
		end
		updateCastBarTicks(self, numTicks)
	elseif not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	end

	-- Fix for empty icon
	if self.Icon and not self.Icon:GetTexture() or self.Icon:GetTexture() == 136235 then
		self.Icon:SetTexture('Interface\\ICONS\\Trade_Engineering')
	end


	if self.iconBg then
		if self.notInterruptible then
			self.iconBg:SetVertexColor(unpack(self.notInterruptibleColor))
		else
			self.iconBg:SetVertexColor(unpack(self.CastingColor))
		end
	end

	if self.iconGlow then
		if self.iconGlow then
			if self.notInterruptible then
				self.iconGlow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .65)
			else
				self.iconGlow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .65)
			end
		end
	end

	if (unit == 'player' and not C.unitframe.castbar_separatePlayer) or unit == 'target' then
		if self.Glow then
			if self.notInterruptible then
				self.Glow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .5)
			else
				self.Glow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .5)
			end
		end
	end

	if (unit == 'player' and C.unitframe.castbar_separatePlayer) then
		self:SetStatusBarColor(C.r, C.g, C.b, 1)
	end
	
	if unit == 'player' and C.unitframe.castbar_separatePlayer then
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], 1)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], 1)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .6)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 1)
	else
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .4)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .4)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .2)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

local function PostUpdateInterruptible(self, unit)
	if not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	else
		self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	end
end

local function PostCastStop(self)
	if not self.fadeOut then
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

local function PostChannelStop(self)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

local function PostCastFailed(self)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
end


function UNITFRAME:AddCastBar(self)
	if not cfg.enableCastbar then return end

	local castbar = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	castbar:SetAllPoints(self)
	castbar:SetStatusBarTexture(C.media.sbTex)
	castbar:GetStatusBarTexture():SetBlendMode('BLEND')
	castbar:SetStatusBarColor(0, 0, 0, 0)
	castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
	self.Castbar = castbar

	local spark = castbar:CreateTexture(nil, 'OVERLAY')
	spark:SetBlendMode('ADD')
	spark:SetAlpha(.7)
	spark:SetHeight(castbar:GetHeight()*2)
	
	local text = F.CreateFS(castbar, (C.isCNClient and {C.font.normal, 11, 'OUTLINE'}) or 'pixel', '', nil, nil)
	text:SetPoint('CENTER', castbar)
	
	local timer = F.CreateFS(castbar, 'pixel', '', nil, nil, true)
	timer:SetPoint('CENTER', castbar)

	if cfg.castbar_showSpellName then text:Show() else text:Hide() end
	if cfg.castbar_showSpellTimer then timer:Show() else timer:Hide() end
	
	local iconFrame = CreateFrame('Frame', nil, castbar)
	iconFrame:SetPoint('RIGHT', castbar, 'LEFT', -4*C.Mult, 0)
	iconFrame:SetSize(self:GetHeight()+6, self:GetHeight()+6)

	local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
	icon:SetAllPoints(iconFrame)
	icon:SetTexCoord(unpack(C.TexCoord))
	
	if self.unitStyle == 'player' then
		local safeZone = castbar:CreateTexture(nil,'OVERLAY')
		safeZone:SetTexture(C.media.bdTex)
		safeZone:SetVertexColor(223/255, 63/255, 107/255, .6)
		safeZone:SetPoint('TOPRIGHT')
		safeZone:SetPoint('BOTTOMRIGHT')
		castbar.SafeZone = safeZone
	end

	if (self.unitStyle == 'target' and cfg.healer) or (self.unitStyle == 'player' and not cfg.healer and not cfg.castbar_separatePlayer) then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', castbar, 'RIGHT', 4*C.Mult, 0)
	end

	if self.unitStyle == 'player' and cfg.castbar_separatePlayer then
		castbar:SetSize(self:GetWidth(), cfg.player_cb_height*C.Mult)
		castbar:ClearAllPoints()
		iconFrame:SetSize(castbar:GetHeight()+4, castbar:GetHeight()+4)

		castbar:SetParent(UIParent)

		if cfg.healer then
			F.Mover(castbar, L['MOVER_UNITFRAME_PLAYER_CASTBAR'], 'PlayerCastbar', {'CENTER', UIParent, 'CENTER', 0, -300*C.Mult}, cfg.player_cb_width, cfg.player_cb_height)
		else
			F.Mover(castbar, L['MOVER_UNITFRAME_PLAYER_CASTBAR'], 'PlayerCastbar', {'TOPLEFT', self, 'BOTTOMLEFT', 0, -40}, cfg.player_cb_width, cfg.player_cb_height)
		end
	end

	if self.unitStyle == 'boss' then
		castbar.decimal = '%.1f'
	else
		castbar.decimal = '%.2f'
	end

	
	castbar.Bg = F.CreateBDFrame(castbar)
	castbar.Glow = F.CreateSD(castbar.Bg, .35, 4, 4)
	castbar.Icon = icon
	castbar.iconBg = F.CreateBG(iconFrame)
	castbar.iconGlow = F.CreateSD(iconFrame, .35, 4, 4)
	castbar.Spark = spark
	castbar.Text = text
	castbar.Time = timer

	castbar.CastingColor = cfg.castbar_CastingColor
	castbar.ChannelingColor = cfg.castbar_ChannelingColor
	castbar.notInterruptibleColor = cfg.castbar_notInterruptibleColor
	castbar.CompleteColor = cfg.castbar_CompleteColor
	castbar.FailColor = cfg.castbar_FailColor

	castbar.OnUpdate = OnCastbarUpdate
	castbar.PostCastStart = PostCastStart
	castbar.PostChannelStart = PostCastStart
	castbar.PostCastStop = PostCastStop
	castbar.PostChannelStop = PostChannelStop
	castbar.PostCastFailed = PostCastFailed
	castbar.PostCastInterrupted = PostCastFailed
	castbar.PostCastInterruptible = PostUpdateInterruptible
	castbar.PostCastNotInterruptible = PostUpdateInterruptible
end