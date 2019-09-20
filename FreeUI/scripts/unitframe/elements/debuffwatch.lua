local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


UNITFRAME.DebuffsTracking = {}



local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end


-- Raid debuffs
UNITFRAME.DebuffsTracking["RaidDebuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
		-- [209858] = Defaults(), -- Necrotic
	},
}

-- CC debuffs
UNITFRAME.DebuffsTracking["CCDebuffs"] = {
	-- BROKEN: Need to build a new classic cc debuffs list
	
	["type"] = "Whitelist",
	["spells"] = {
		-- [107079] = Defaults(4), -- Quaking Palm
	},
}

function UNITFRAME:UpdateRaidDebuffIndicator()
	local ORD = oUF_RaidDebuffs

	if (ORD) then
		local _, InstanceType = IsInInstance()

		if (ORD.RegisteredList ~= "RD") and (InstanceType == "party" or InstanceType == "raid") then
			ORD:ResetDebuffData()
			ORD:RegisterDebuffs(UNITFRAME.DebuffsTracking.RaidDebuffs.spells)
			ORD.RegisteredList = "RD"
		else
			if ORD.RegisteredList ~= "CC" then
				ORD:ResetDebuffData()
				ORD:RegisterDebuffs(UNITFRAME.DebuffsTracking.CCDebuffs.spells)
				ORD.RegisteredList = "CC"
			end
		end
	end
end


function UNITFRAME:AddDebuffWatch(self)
	if not cfg.debuffWatch then return end

	local RaidDebuffs = CreateFrame("Frame", nil, self)
	RaidDebuffs:SetHeight(24)
	RaidDebuffs:SetWidth(24)
	RaidDebuffs:SetPoint("CENTER", self)
	RaidDebuffs:SetFrameLevel(self:GetFrameLevel() + 10)
	--RaidDebuffs:SetTemplate()
	--RaidDebuffs:CreateShadow()
	--RaidDebuffs.Shadow:SetFrameLevel(RaidDebuffs:GetFrameLevel() + 1)
	RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, "ARTWORK")
	RaidDebuffs.icon:SetTexCoord(unpack(C.TexCoord))
	--RaidDebuffs.icon:SetInside(RaidDebuffs)
	RaidDebuffs.cd = CreateFrame("Cooldown", nil, RaidDebuffs, "CooldownFrameTemplate")
	--RaidDebuffs.cd:SetInside(RaidDebuffs, 1, 0)
	RaidDebuffs.cd:SetReverse(true)
	RaidDebuffs.cd.noOCC = true
	RaidDebuffs.cd.noCooldownCount = true
	RaidDebuffs.cd:SetHideCountdownNumbers(true)
	RaidDebuffs.cd:SetAlpha(.7)
	RaidDebuffs.showDispellableDebuff = true
	RaidDebuffs.onlyMatchSpellID = true
	RaidDebuffs.FilterDispellableDebuff = true

	RaidDebuffs.time = F.CreateFS(RaidDebuffs, 'pixel', nil, nil, true, 'CENTER', 1, 0)
	RaidDebuffs.count = F.CreateFS(RaidDebuffs, 'pixel', nil, 'yellow', true, 'BOTTOMRIGHT', 2, 2)

	--RaidDebuffs.forceShow = true
	
	self.RaidDebuffs = RaidDebuffs
end