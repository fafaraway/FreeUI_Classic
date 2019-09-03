local F, C = unpack(select(2, ...))
local module, cfg = F:GetModule('Unitframe'), C.unitframe


function module:AddRangeCheck(self)
	if not cfg.rangeCheck then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = 0.4
	}
end