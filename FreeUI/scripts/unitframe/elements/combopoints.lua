local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


function UNITFRAME:AddComboPointsBar(self)
	if (cfg.comboPoints) and (C.Class == 'ROGUE' or C.Class == 'DRUID') then
		local gap, offset, maxPoints = 3, 4, 5

		local ComboPoints = CreateFrame('Frame', 'FreeUIComboPointsBar', self)
		ComboPoints:SetHeight(cfg.comboPointsHeight)
		ComboPoints:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -offset)
		ComboPoints:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -offset)

		for i = 1, 5 do
			ComboPoints[i] = CreateFrame('StatusBar', nil, ComboPoints)
			ComboPoints[i]:SetHeight(cfg.comboPointsHeight)
			ComboPoints[i]:SetStatusBarTexture(C.media.sbTex)
			F.CreateBDFrame(ComboPoints[i])

			if i == 1 then
				ComboPoints[i]:SetPoint('LEFT', ComboPoints, 'LEFT', 0, 0)
				ComboPoints[i]:SetWidth((self:GetWidth() - (gap * (maxPoints - 1))) / maxPoints)
			else
				ComboPoints[i]:SetWidth((self:GetWidth() - (gap * (maxPoints - 1))) / maxPoints)
				ComboPoints[i]:SetPoint('LEFT', ComboPoints[i - 1], 'RIGHT', gap, 0)
			end
		end

		self.ComboPointsBar = ComboPoints
	end
end