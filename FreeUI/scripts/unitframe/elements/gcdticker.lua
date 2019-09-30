local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


function UNITFRAME:AddGCDSpark(self)
	if not cfg.GCDSpark then return end
		
	self.GCD = CreateFrame('Frame', self:GetName()..'_GCD', self)
	self.GCD:SetWidth(self:GetWidth())
	self.GCD:SetHeight(3)
	self.GCD:SetFrameLevel(self:GetFrameLevel() + 3)
	self.GCD:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)

	self.GCD.Color = {1, 1, 1}
	self.GCD.Height = 4
	self.GCD.Width = 4
end