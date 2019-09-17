local F, C = unpack(select(2, ...))
local module, cfg = F:GetModule('Unitframe'), C.unitframe


local function PostUpdatePower(power, unit, cur, max, min)
	local self = power:GetParent()
	local style = self.unitStyle

	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end

	if C.Class == 'ROGUE' and style == 'player' then
		power:SetStatusBarColor(213/255, 192/255, 105/255)
	end
end

function module:AddPowerBar(self)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('LEFT')
	power:SetPoint('RIGHT')
	power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
	power:SetStatusBarTexture(C.media.sbTex)
	power:SetHeight(cfg.powerHeight*C.Mult)
	F.SmoothBar(power)
	power.frequentUpdates = true

	self.Power = power

	local line = power:CreateTexture(nil, 'OVERLAY')
	line:SetHeight(C.Mult)
	line:SetPoint('TOPLEFT', 0, C.Mult)
	line:SetPoint('TOPRIGHT', 0, C.Mult)
	line:SetTexture(C.media.bdTex)
	line:SetVertexColor(0, 0, 0)

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints()
	bg:SetTexture(C.media.bdTex)
	bg.multiplier = .2
	power.bg = bg

	power.colorTapping = true
	power.colorDisconnected = true
	power.colorReaction = true
	--power.colorSelection = true

	if self.unitStyle == 'pet' then
		power.colorPower = true
	elseif cfg.transMode then
		if self.unitStyle == 'player' then
			power.colorPower = true
		else
			power.colorClass = true
		end
	else
		power.colorPower = true
	end

	self.Power.PostUpdate = PostUpdatePower
end