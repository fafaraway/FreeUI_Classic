local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:RegisterModule('Unitframe')


local format, floor, abs, min = string.format, math.floor, math.abs, math.min
local pairs, next = pairs, next

F.LibClassicDurations = LibStub('LibClassicDurations')
F.LibClassicDurations:RegisterFrame('FreeUI')
local LCD = F.LibClassicDurations

local cfg = C.unitframe
local oUF = FreeUI.oUF

oUF.colors.power.MANA = {111/255, 185/255, 237/255}
oUF.colors.power.ENERGY = {1, 222/255, 80/255}

oUF.colors.debuffType = {
	Curse = {.8, 0, 1},
	Disease = {.8, .6, 0},
	Magic = {0, .8, 1},
	Poison = {0, .8, 0},
	none = {0, 0, 0}
}

oUF.colors.reaction = {
	[1] = {255/255, 81/255, 74/255}, 	-- Exceptionally hostile
	[2] = {255/255, 81/255, 74/255}, 	-- Very Hostile
	[3] = {255/255, 81/255, 74/255}, 	-- Hostile
	[4] = {255/255, 236/255, 121/255}, 	-- Neutral
	[5] = {87/255, 255/255, 93/255}, 	-- Friendly
	[6] = {87/255, 255/255, 93/255}, 	-- Very Friendly
	[7] = {87/255, 255/255, 93/255}, 	-- Exceptionally friendly
	[8] = {87/255, 255/255, 93/255}, 	-- Exalted
}

function UNITFRAME:createBarMover(bar, text, value, anchor)
	local mover = F.Mover(bar, text, value, anchor, bar:GetHeight()+bar:GetWidth()+5, bar:GetHeight()+5)
	bar:ClearAllPoints()
	bar:SetPoint('RIGHT', mover)
end

local handler = CreateFrame('Frame')
handler:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

function handler:MODIFIER_STATE_CHANGED(key, state)
	if (key ~= 'RALT') then return end

	for _, object in next, oUF.objects do
		local unit = object.realUnit or object.unit
		if (unit == 'target') then
			local auras = object.Auras
			if (state == 1) then
				auras.CustomFilter = nil
			else
				auras.CustomFilter = UNITFRAME.CustomFilter
			end
			auras:ForceUpdate()
			break
		end
	end
end

function handler:PLAYER_ENTERING_WORLD()
	self:RegisterEvent('PLAYER_REGEN_DISABLED')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	if (InCombatLockdown()) then
		self:PLAYER_REGEN_DISABLED()
	else
		self:PLAYER_REGEN_ENABLED()
	end
end
handler:RegisterEvent('PLAYER_ENTERING_WORLD')

function handler:PLAYER_REGEN_DISABLED()
	self:UnregisterEvent('MODIFIER_STATE_CHANGED')
end

function handler:PLAYER_REGEN_ENABLED()
	self:RegisterEvent('MODIFIER_STATE_CHANGED')
end

function handler:PLAYER_TARGET_CHANGED()
	if (UnitExists('target')) then
		if (UnitIsEnemy('target', 'player')) then
			PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
		elseif (UnitIsFriend('target', 'player')) then
			PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
		else
			PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
		end
	else
		PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
	end
end

handler:RegisterEvent('PLAYER_TARGET_CHANGED')

function UNITFRAME:AddBackDrop(self)
	local highlight = self:CreateTexture(nil, 'OVERLAY')
	highlight:SetAllPoints()
	highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	highlight:SetTexCoord(0, 1, .5, 1)
	highlight:SetVertexColor(.6, .6, .6)
	highlight:SetBlendMode('ADD')
	highlight:Hide()

	self:RegisterForClicks('AnyUp')
	self:HookScript('OnEnter', function()
		UnitFrame_OnEnter(self)
		highlight:Show()
	end)
	self:HookScript('OnLeave', function()
		UnitFrame_OnLeave(self)
		highlight:Hide()
	end)

	self.Highlight = highlight

	local bg = F.CreateBDFrame(self, 0.2)
	self.Bg = bg

	local glow = F.CreateSD(self.Bg, .35, 3, 3)
	self.Glow = glow
end

local function UpdateSelectedBorder(self)
	if UnitIsUnit('target', self.unit) then
		self.Border:Show()
	else
		self.Border:Hide()
	end
end

function UNITFRAME:AddSelectedBorder(self)
	local border = F.CreateBDFrame(self.Bg)
	border:SetBackdropBorderColor(1, 1, 1, 1)
	border:Hide()

	self.Border = border
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end

function UNITFRAME:AddFCT(self)
	if not cfg.enableFCT then return end

	local parentFrame = CreateFrame('Frame', nil, UIParent)
	local fcf = CreateFrame('Frame', 'oUF_CombatTextFrame', parentFrame)
	fcf:SetSize(32, 32)
	if self.unitStyle == 'player' then
		F.Mover(fcf, L['MOVER_COMBATTEXT_INCOMING'], 'PlayerCombatText', {'BOTTOM', self, 'TOPLEFT', 0, 120})
	else
		F.Mover(fcf, L['MOVER_COMBATTEXT_OUTGOING'], 'TargetCombatText', {'BOTTOM', self, 'TOPRIGHT', 0, 120})
	end

	for i = 1, 36 do
		fcf[i] = parentFrame:CreateFontString('$parentText', 'OVERLAY')
	end

	fcf.font = C.font.normal
	fcf.fontHeight = 18
	fcf.fontFlags = nil
	fcf.showPets = cfg.petFCT
	fcf.showHots = cfg.hotsDots
	fcf.showAutoAttack = cfg.autoAttack
	fcf.showOverHealing = cfg.overHealing
	fcf.abbreviateNumbers = true
	self.FloatingCombatFeedback = fcf
end