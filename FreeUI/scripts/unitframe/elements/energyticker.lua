local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


function UNITFRAME:AddEnergyTicker(self)
	if not cfg.energyTicker then return end

	local energyTicker = CreateFrame('Frame', nil, self)
	energyTicker:SetFrameLevel(self.Power:GetFrameLevel() + 2)

	self.EnergyTicker = energyTicker
end