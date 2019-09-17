local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


function UNITFRAME:AddEnergyTicker(self)
	if not cfg.energyTicker then return end
	if not (C.Class == 'ROGUE' or C.Class == 'DRUID') then return end

	self.EnergyTicker = CreateFrame("Frame", nil, self)
	self.EnergyTicker:SetFrameLevel(self.Power:GetFrameLevel() + 1)
end