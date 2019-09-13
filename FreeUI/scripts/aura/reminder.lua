local F, C, L = unpack(select(2, ...))
local AURA = F:GetModule('Aura')


local iconSize = 40
local frames, parentFrame = {}
local InCombatLockdown, GetZonePVPInfo = InCombatLockdown, GetZonePVPInfo
local IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture = IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture
local pairs, tinsert, next = pairs, table.insert, next

local ReminderBuffs = {
	MAGE = {
		{	spells = {
				[1459] = true,
			},
			depend = 1459,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	PRIEST = {
		{	spells = {
				[1243] = true,
			},
			depend = 1243,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
}

local groups = ReminderBuffs[C.Class]

function AURA:Reminder_ConvertToName(cfg)
	for spellID in pairs(cfg.spells) do
		local name = GetSpellInfo(spellID)
		if name then
			cfg.spells[name] = true
		end
	end
end

function AURA:Reminder_Update(cfg)
	local frame = cfg.frame
	local depend = cfg.depend
	local combat = cfg.combat
	local instance = cfg.instance
	local pvp = cfg.pvp
	local isPlayerSpell, isInCombat, isInInst, isInPVP = true
	local inInst, instType = IsInInstance()

	if depend and not IsPlayerSpell(depend) then isPlayerSpell = false end
	if combat and InCombatLockdown() then isInCombat = true end
	if instance and inInst and (instType == 'scenario' or instType == 'party' or instType == 'raid') then isInInst = true end
	if pvp and (instType == 'arena' or instType == 'pvp' or GetZonePVPInfo() == 'combat') then isInPVP = true end
	if not combat and not instance and not pvp then isInCombat, isInInst, isInPVP = true, true, true end

	frame:Hide()
	if isPlayerSpell and (isInCombat or isInInst or isInPVP) then
		for i = 1, 32 do
			local name = UnitBuff('player', i)
			if not name then break end
			if name and cfg.spells[name] then
				frame:Hide()
				return
			end
		end
		frame:Show()
	end
end

function AURA:Reminder_Create(cfg)
	local frame = CreateFrame('Frame', nil, parentFrame)
	frame:SetSize(iconSize, iconSize)
	F.PixelIcon(frame)
	F.CreateSD(frame)
	for spell in pairs(cfg.spells) do
		frame.Icon:SetTexture(GetSpellTexture(spell))
		break
	end
	frame.text = F.CreateFS(frame, (C.isCNClient and{C.font.normal, 12}) or 'pixel', L['AURA_REMINDER_LACK'], 'red', true, 'TOP', 1, 15)
	frame:Hide()
	cfg.frame = frame

	tinsert(frames, frame)
end

function AURA:Reminder_UpdateAnchor()
	local index = 0
	local offset = iconSize + 5
	for _, frame in next, frames do
		if frame:IsShown() then
			frame:SetPoint('LEFT', offset * index, 0)
			index = index + 1
		end
	end
	parentFrame:SetWidth(offset * index)
end

function AURA:Reminder_OnEvent()
	for _, cfg in pairs(groups) do
		if not cfg.frame then
			AURA:Reminder_Create(cfg)
			AURA:Reminder_ConvertToName(cfg)
		end
		AURA:Reminder_Update(cfg)
	end
	AURA:Reminder_UpdateAnchor()
end

function AURA:BuffReminder()
	if not groups then return end

	if C.aura.reminder then
		if not parentFrame then
			parentFrame = CreateFrame('Frame', nil, UIParent)
			parentFrame:SetPoint('TOP', 0, -200)
			parentFrame:SetSize(iconSize, iconSize)
		end
		parentFrame:Show()

		AURA:Reminder_OnEvent()
		F:RegisterEvent('UNIT_AURA', AURA.Reminder_OnEvent, 'player')
		F:RegisterEvent('PLAYER_REGEN_ENABLED', AURA.Reminder_OnEvent)
		F:RegisterEvent('PLAYER_REGEN_DISABLED', AURA.Reminder_OnEvent)
		F:RegisterEvent('ZONE_CHANGED_NEW_AREA', AURA.Reminder_OnEvent)
		F:RegisterEvent('PLAYER_ENTERING_WORLD', AURA.Reminder_OnEvent)
	else
		if parentFrame then
			parentFrame:Hide()
			F:UnregisterEvent('UNIT_AURA', AURA.Reminder_OnEvent)
			F:UnregisterEvent('PLAYER_REGEN_ENABLED', AURA.Reminder_OnEvent)
			F:UnregisterEvent('PLAYER_REGEN_DISABLED', AURA.Reminder_OnEvent)
			F:UnregisterEvent('ZONE_CHANGED_NEW_AREA', AURA.Reminder_OnEvent)
			F:UnregisterEvent('PLAYER_ENTERING_WORLD', AURA.Reminder_OnEvent)
		end
	end
end