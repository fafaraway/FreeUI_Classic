local _, ns = ...
local oUF = ns.oUF
local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:RegisterModule('Unitframe'), C.unitframe


local format, floor, abs, min = string.format, math.floor, math.abs, math.min
local pairs, next = pairs, next
local LCD = C.LibClassicDurations

oUF.colors.power.MANA = {0.47, 0.83, 0.88}
oUF.colors.power.ENERGY = {0.88, 0.79, 0.25}

oUF.colors.debuffType = {
	['Curse'] = {.8, 0, 1},
	['Disease'] = {.8, .6, 0},
	['Magic'] = {0, .8, 1},
	['Poison'] = {0, .8, 0},
	['none'] = {0, 0, 0}
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

if C.appearance.adjustClassColors then
	local RCC = RAID_CLASS_COLORS
	oUF.colors.class.ROGUE = {RCC['ROGUE']['r'], RCC['ROGUE']['g'], RCC['ROGUE']['b']}
	oUF.colors.class.DRUID = {RCC['DRUID']['r'], RCC['DRUID']['g'], RCC['DRUID']['b']}
	oUF.colors.class.HUNTER = {RCC['HUNTER']['r'], RCC['HUNTER']['g'], RCC['HUNTER']['b']}
	oUF.colors.class.MAGE = {RCC['MAGE']['r'], RCC['MAGE']['g'], RCC['MAGE']['b']}
	oUF.colors.class.PALADIN = {RCC['PALADIN']['r'], RCC['PALADIN']['g'], RCC['PALADIN']['b']}
	oUF.colors.class.PRIEST = {RCC['PRIEST']['r'], RCC['PRIEST']['g'], RCC['PRIEST']['b']}
	oUF.colors.class.SHAMAN = {RCC['SHAMAN']['r'], RCC['SHAMAN']['g'], RCC['SHAMAN']['b']}
	oUF.colors.class.WARLOCK = {RCC['WARLOCK']['r'], RCC['WARLOCK']['g'], RCC['WARLOCK']['b']}
	oUF.colors.class.WARRIOR = {RCC['WARRIOR']['r'], RCC['WARRIOR']['g'], RCC['WARRIOR']['b']}
end

function UNITFRAME:createBarMover(bar, text, value, anchor)
	local mover = F.Mover(bar, text, value, anchor, bar:GetHeight()+bar:GetWidth()+5, bar:GetHeight()+5)
	bar:ClearAllPoints()
	bar:SetPoint('RIGHT', mover)
end

local handler = CreateFrame('Frame')
handler:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

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



