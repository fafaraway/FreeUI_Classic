local _, ns = ...
local F, C = unpack(select(2, ...))
local oUF = ns.oUF or oUF

C.LibClassicDurations = LibStub("LibClassicDurations")
C.LibClassicDurations:RegisterFrame("FreeUI")
local LCD = C.LibClassicDurations

local debugMode = false
local RaidDebuffsIgnore, invalidPrio = {}, -1

local DispellColor = {
	['Curse'] = {.8, 0, 1},
	['Disease'] = {.8, .6, 0},
	['Magic'] = {0, .8, 1},
	['Poison'] = {0, .8, 0},
	['none'] = {0, 0, 0}
}

local DispellPriority = {
	["Magic"]	= 4,
	["Curse"]	= 3,
	["Disease"]	= 2,
	["Poison"]	= 1,
}

local DispellFilter
do
	local dispellClasses = {
		["DRUID"] = {
			["Curse"] = true,
			["Poison"] = true,
		},
		["PALADIN"] = {
			["Magic"] = true,
			["Poison"] = true,
			["Disease"] = true,
		},
		["PRIEST"] = {
			["Magic"] = true,
			["Disease"] = true,
		},
		["SHAMAN"] = {
			["Poison"] = true,
			["Disease"] = true,
		},
		["MAGE"] = {
			["Curse"] = true,
		},
		["WARLOCK"] = {
			["Magic"] = true,
		},
	}

	DispellFilter = dispellClasses[C.Class] or {}
end

local function UpdateDebuffFrame(self, name, icon, count, debuffType, duration, expiration)
	local rd = self.RaidDebuffs
	if name then
		if rd.icon then
			rd.icon:SetTexture(icon)
			rd.icon:Show()
		end

		if rd.count then
			if count and count > 1 then
				rd.count:SetText(count)
				rd.count:Show()
			else
				rd.count:Hide()
			end
		end

		if rd.timer then
			rd.duration = duration
			if duration and duration > 0 then
				rd.expiration = expiration
				rd:SetScript("OnUpdate", F.CooldownOnUpdate)
				rd.timer:Show()
			else
				rd:SetScript("OnUpdate", nil)
				rd.timer:Hide()
			end
		end

		if rd.cd then
			if duration and duration > 0 then
				rd.cd:SetCooldown(expiration - duration, duration)
				rd.cd:Show()
			else
				rd.cd:Hide()
			end
		end

		local c = DispellColor[debuffType] or DispellColor.none
		if rd.ShowDebuffBorder then
			if rd.bg and rd.glow then
				rd.bg:SetBackdropBorderColor(c[1], c[2], c[3])
				rd.glow:SetBackdropBorderColor(c[1], c[2], c[3], .35)
			end
		end

		rd:Show()
	else
		rd:Hide()
	end
end

local instType
local function checkInstance()
	local _, instanceType = GetInstanceInfo()
	if instanceType == "raid" then
		instType = "raid"
	else
		instType = "other"
	end
end

local function Update(self, _, unit)
	if unit ~= self.unit then return end

	local rd = self.RaidDebuffs
	rd.priority = invalidPrio
	rd.filter = "HARMFUL"

	local _name, _icon, _count, _debuffType, _duration, _expiration
	local debuffs = rd.Debuffs or {}
	local isCharmed = UnitIsCharmed(unit)
	local canAttack = UnitCanAttack("player", unit)
	local prio

	for i = 1, 32 do
		local name, icon, count, debuffType, duration, expiration, caster, _, _, spellId = UnitAura(unit, i, rd.filter)
		if not name then break end

		if duration == 0 then
			local newduration, newexpires = LCD:GetAuraDurationByUnit(unit, spellId, caster, name)
			if newduration then
				duration, expiration = newduration, newexpires
			end
		end

		if rd.ShowDispellableDebuff and debuffType and (not isCharmed) and (not canAttack) then
			if rd.FilterDispellableDebuff then
				prio = DispellFilter[debuffType] and (DispellPriority[debuffType] + 6) or 2
				if prio == 2 then debuffType = nil end
			else
				prio = DispellPriority[debuffType]
			end

			if prio and prio > rd.priority then
				rd.priority, rd.index = prio, i
				_name, _icon, _count, _debuffType, _duration, _expiration = name, icon, count, debuffType, duration, expiration
			end
		end

		local instPrio
		if instType and debuffs[instType] then
			instPrio = debuffs[instType][spellId]
		end

		if not RaidDebuffsIgnore[spellId] and instPrio and (instPrio == 6 or instPrio > rd.priority) then
			rd.priority, rd.index = instPrio, i
			_name, _icon, _count, _debuffType, _duration, _expiration = name, icon, count, debuffType, duration, expiration
		end
	end

	if debugMode then
		rd.priority = 6
		_name, _, _icon = GetSpellInfo(168)
		_count, _debuffType, _duration, _expiration = 2, "Magic", 10, GetTime()+10, 0
	end

	if rd.priority == invalidPrio then
		rd.index, _name = nil, nil
	end

	UpdateDebuffFrame(self, _name, _icon, _count, _debuffType, _duration, _expiration)
end

local function Path(self, ...)
	return (self.RaidDebuffs.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local rd = self.RaidDebuffs
	if rd then
		self:RegisterEvent("UNIT_AURA", Path)
		rd.ForceUpdate = ForceUpdate
		rd.__owner = self
		return true
	end

	checkInstance()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", checkInstance, true)
end

local function Disable(self)
	if self.RaidDebuffs then
		self:UnregisterEvent("UNIT_AURA", Path)
		self.RaidDebuffs:Hide()
		self.RaidDebuffs.__owner = nil
	end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD", checkInstance)
end

oUF:AddElement("RaidDebuffs", Update, Enable, Disable)