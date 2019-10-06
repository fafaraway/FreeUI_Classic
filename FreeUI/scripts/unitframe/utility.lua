local _, ns = ...
local oUF = ns.oUF
local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:RegisterModule('Unitframe'), C.unitframe


local format, floor, abs, min = string.format, math.floor, math.abs, math.min
local pairs, next = pairs, next
local LCD = C.LibClassicDurations

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
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetBackdropBorderColor(1, 1, 1, 1)
	border:Hide()

	self.Border = border
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end



