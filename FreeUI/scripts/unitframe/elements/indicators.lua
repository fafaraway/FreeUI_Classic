local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


function UNITFRAME:AddStatusIndicator(self)
	local statusIndicator = CreateFrame('Frame')
	local statusText = F.CreateFS(self.Health, 'pixel', '', nil, true)
	statusText:SetPoint('LEFT', self.HealthValue, 'RIGHT', 10, 0)

	local function updateStatus()
		if UnitAffectingCombat('player') then
			statusText:SetText('!')
			statusText:SetTextColor(1, 0, 0)
		elseif IsResting() then
			statusText:SetText('Zzz')
			statusText:SetTextColor(44/255, 141/255, 81/255)
		else
			statusText:SetText('')
		end
	end

	local function checkEvents()
		statusText:Show()
		statusIndicator:RegisterEvent('PLAYER_ENTERING_WORLD', true)
		statusIndicator:RegisterEvent('PLAYER_UPDATE_RESTING', true)
		statusIndicator:RegisterEvent('PLAYER_REGEN_ENABLED', true)
		statusIndicator:RegisterEvent('PLAYER_REGEN_DISABLED', true)

		updateStatus()
	end
	checkEvents()
	statusIndicator:SetScript('OnEvent', updateStatus)
end

function UNITFRAME:AddRaidTargetIndicator(self)
	local raidTargetIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	raidTargetIndicator:SetTexture(C.AssetsPath..'UI-RaidTargetingIcons')
	raidTargetIndicator:SetAlpha(.5)
	raidTargetIndicator:SetSize(16, 16)
	raidTargetIndicator:SetPoint('CENTER', self)

	self.RaidTargetIndicator = raidTargetIndicator
end

function UNITFRAME:AddResurrectIndicator(self)
	local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	resurrectIndicator:SetSize(16, 16)
	resurrectIndicator:SetPoint('CENTER')
	self.ResurrectIndicator = resurrectIndicator
end

function UNITFRAME:AddReadyCheckIndicator(self)
	local readyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	readyCheckIndicator:SetPoint('CENTER', self.Health)
	readyCheckIndicator:SetSize(16, 16)
	self.ReadyCheckIndicator = readyCheckIndicator
end
