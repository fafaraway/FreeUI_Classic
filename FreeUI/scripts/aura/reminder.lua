local F, C, L = unpack(select(2, ...))
local AURA, cfg = F:GetModule('Aura'), C.aura


local frames, parentFrame = {}
local InCombatLockdown, GetZonePVPInfo = InCombatLockdown, GetZonePVPInfo
local IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture = IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture
local pairs, tinsert, next = pairs, table.insert, next

local ReminderBuffs = {
	MAGE = {
		{	spells = {
				[1459] = true,
				[8096] = true,  -- 智力卷轴
				[23028] = true, -- 奥术光辉
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
				[8099] = true,  -- 耐力卷轴
				[21562] = true, -- 坚韧祷言
			},
			depend = 1243,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
}

local groups = ReminderBuffs[C.Class]

function AURA:Reminder_ConvertToName(setting)
	local cache = {}
	for spellID in pairs(setting.spells) do
		local name = GetSpellInfo(spellID)
		if name then
			cache[name] = true
		end
	end
	
	for name in pairs(cache) do
		setting.spells[name] = true
	end
end

function AURA:Reminder_Update(setting)
	local frame = setting.frame
	local depend = setting.depend
	local combat = setting.combat
	local instance = setting.instance
	local pvp = setting.pvp
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
			if name and setting.spells[name] then
				frame:Hide()
				return
			end
		end
		frame:Show()
	end
end

function AURA:Reminder_Create(setting)
	local frame = CreateFrame('Frame', nil, parentFrame)
	frame:SetSize(cfg.debuffSize, cfg.debuffSize)
	--F.PixelIcon(frame)
	frame.bg = F.CreateBDFrame(frame)
	frame.glow = F.CreateSD(frame.bg)
	frame.glow:SetBackdropBorderColor(1, 1, 1)
	frame.icon = frame:CreateTexture(nil, 'ARTWORK')
	frame.icon:SetPoint('TOPLEFT')
	frame.icon:SetPoint('BOTTOMRIGHT')

	for spell in pairs(setting.spells) do
		frame.icon:SetTexture(GetSpellTexture(spell))
		break
	end
	frame.icon:SetTexCoord(unpack(C.TexCoord))
	frame.text = F.CreateFS(frame, (C.isCNClient and{C.font.normal, 12}) or 'pixel', L['AURA_REMINDER_LACK'], 'red', true, 'TOP', 1, 15)
	frame:Hide()
	setting.frame = frame

	tinsert(frames, frame)
end

function AURA:Reminder_UpdateAnchor()
	local index = 0
	local offset = cfg.debuffSize + 5
	for _, frame in next, frames do
		if frame:IsShown() then
			frame:SetPoint('LEFT', offset * index, 0)
			index = index + 1
		end
	end
	parentFrame:SetWidth(offset * index)
end

function AURA:Reminder_OnEvent()
	for _, setting in pairs(groups) do
		if not setting.frame then
			AURA:Reminder_Create(setting)
			AURA:Reminder_ConvertToName(setting)
		end
		AURA:Reminder_Update(setting)
	end
	AURA:Reminder_UpdateAnchor()
end

function AURA:BuffReminder()
	if not groups then return end

	if C.aura.reminder then
		if not parentFrame then
			parentFrame = CreateFrame('Frame', nil, UIParent)
			parentFrame:SetPoint('TOP', 0, -200)
			parentFrame:SetSize(cfg.debuffSize, cfg.debuffSize)
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