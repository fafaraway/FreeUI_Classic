local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')


local format, tostring = string.format, tostring
local cfg = C.unitframe
local oUF = FreeUI.oUF

local function CreatePlayerStyle(self)
	self.unitStyle = 'player'
	self:SetSize((cfg.healer and cfg.player_width_healer) or cfg.player_width, (cfg.healer and cfg.player_height_healer) or cfg.player_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)

	UNITFRAME:AddPowerBar(self)

	UNITFRAME:AddHealthValue(self)
	UNITFRAME:AddPowerValue(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddDispel(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddStatusIndicator(self)
	UNITFRAME:AddPvPIndicator(self)
	UNITFRAME:AddFCT(self)

	if C.Class == 'SHAMAN' then UNITFRAME:AddTotems(self) end
	if cfg.classPower then UNITFRAME:AddClassPower(self) end
end

local function CreatePetStyle(self)
	self.unitStyle = 'pet'
	self:SetSize((cfg.healer and cfg.pet_width_healer) or cfg.pet_width, (cfg.healer and cfg.pet_height_healer) or cfg.pet_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)

	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)
end

local function CreateTargetStyle(self)
	self.unitStyle = 'target'
	self:SetSize((cfg.healer and cfg.target_width_healer) or cfg.target_width, (cfg.healer and cfg.target_height_healer) or cfg.target_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)

	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddHealthValue(self)
	UNITFRAME:AddPowerValue(self)
	UNITFRAME:AddClassificationText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFCT(self)
end

local function CreateTargetTargetStyle(self)
	self.unitStyle = 'targettarget'
	self:SetSize((cfg.healer and cfg.targettarget_width_healer) or cfg.targettarget_width, (cfg.healer and cfg.targettarget_height_healer) or cfg.targettarget_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
end

local function CreatePartyStyle(self)
	self.unitStyle = 'party'

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)

	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddDispel(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddBuffs(self)
	UNITFRAME:AddDebuffs(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddLeaderIndicator(self)
	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)

	UNITFRAME:AddSelectedBorder(self)
end

local function CreateRaidStyle(self)
	self.unitStyle = 'raid'

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)

	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddDispel(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddBuffs(self)
	UNITFRAME:AddDebuffs(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddLeaderIndicator(self)
	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)

	UNITFRAME:AddSelectedBorder(self)
end

local function CreateBossStyle(self)
	self.unitStyle = 'boss'
	self:SetSize(cfg.boss_width, cfg.boss_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthValue(self)

	UNITFRAME:AddPowerBar(self)

	UNITFRAME:AddPowerValue(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
end


function UNITFRAME:OnLogin()
	if not C.unitframe.enable then return end

	local moverWidth, moverHeight

	oUF:RegisterStyle('Player', CreatePlayerStyle)
	oUF:RegisterStyle('Pet', CreatePetStyle)
	oUF:RegisterStyle('Target', CreateTargetStyle)
	oUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)

	oUF:SetActiveStyle('Player')
	local player = oUF:Spawn('player', 'oUF_Player')
	if cfg.frameVisibility then
		player:Disable()
		player.frameVisibility = cfg.frameVisibility
		RegisterStateDriver(player, "visibility", cfg.player_frameVisibility)
	end
	F.Mover(player, L['MOVER_UNITFRAME_PLAYER'], 'PlayerFrame', (cfg.healer and cfg.player_pos_healer) or cfg.player_pos, player:GetWidth(), player:GetHeight())

	oUF:SetActiveStyle('Pet')
	local pet = oUF:Spawn('pet', 'oUF_Pet')
	if cfg.frameVisibility then
		pet:Disable()
		pet.frameVisibility = cfg.frameVisibility
		RegisterStateDriver(pet, "visibility", cfg.pet_frameVisibility)
	end
	F.Mover(pet, L['MOVER_UNITFRAME_PET'], 'PetFrame', cfg.pet_pos, pet:GetWidth(), pet:GetHeight())

	oUF:SetActiveStyle('Target')
	local target = oUF:Spawn('target', 'oUF_Target')
	F.Mover(target, L['MOVER_UNITFRAME_TARGET'], 'TargetFrame', (cfg.healer and cfg.target_pos_healer) or cfg.target_pos, target:GetWidth(), target:GetHeight())

	oUF:SetActiveStyle('TargetTarget')
	local targettarget = oUF:Spawn('targettarget', 'oUF_TargetTarget')
	F.Mover(targettarget, L['MOVER_UNITFRAME_TARGETTARGET'], 'TargetTargetFrame', (cfg.healer and cfg.targettarget_pos_healer) or cfg.targettarget_pos, targettarget:GetWidth(), targettarget:GetHeight())

	if cfg.enableBoss then
		oUF:RegisterStyle('Boss', CreateBossStyle)
		oUF:SetActiveStyle('Boss')
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn('boss'..i, 'oUF_Boss'..i)
			if i == 1 then
				boss[i].mover = F.Mover(boss[i], L['MOVER_UNITFRAME_BOSS'], 'BossFrame', (cfg.healer and cfg.boss_pos_healer) or cfg.boss_pos, cfg.boss_width, cfg.boss_height)
			else
				boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, cfg.boss_gap)
			end
		end
	end

	if cfg.enableGroup then
		if IsAddOnLoaded('Blizzard_CompactRaidFrames') then
			CompactRaidFrameManager:SetParent(FreeUIHider)
			CompactUnitFrameProfiles:UnregisterAllEvents()
		end

		oUF:RegisterStyle('Party', CreatePartyStyle)
		oUF:SetActiveStyle('Party')

		local partyMover
		local party = oUF:SpawnHeader(nil, nil, 'solo,party',
			'showParty', true,
			'showPlayer', true,
			'showSolo', false,
			'xoffset', cfg.party_gap,
			'yoffset', cfg.party_gap,
			'maxColumns', 1,
			'unitsperColumn', 5,
			'columnSpacing', 0,
			'point', cfg.healer and 'LEFT' or 'BOTTOM',
			'columnAnchorPoint', 'LEFT',
			'groupBy', 'ASSIGNEDROLE',
			'groupingOrder', 'TANK,HEALER,DAMAGER',
			'oUF-initialConfigFunction', ([[
				self:SetHeight(%d)
				self:SetWidth(%d)
			]]):format((cfg.healer and cfg.party_height_healer) or cfg.party_height, (cfg.healer and cfg.party_width_healer) or cfg.party_width)
		)

		if cfg.healer then
			partyMover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], 'PartyFrame', cfg.party_pos_healer, (cfg.party_width_healer*5+cfg.party_gap*4), cfg.party_height_healer)
			party:ClearAllPoints()
			party:SetPoint('TOP', partyMover)
		else
			partyMover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], 'PartyFrame', cfg.party_pos, cfg.party_width, (cfg.party_height*5+cfg.party_gap*4))
			party:ClearAllPoints()
			party:SetPoint('BOTTOM', partyMover)
		end

		oUF:RegisterStyle('Raid', CreateRaidStyle)
		oUF:SetActiveStyle('Raid')

		local raidMover
		local function CreateRaid(name, i)
			local raid = oUF:SpawnHeader(name, nil, 'raid',
			'showParty', false,
			'showRaid', true,
			'xoffset', cfg.raid_gap,
			'yOffset', -cfg.raid_gap,
			'groupFilter', tostring(i),
			'groupingOrder', '1,2,3,4,5,6,7,8',
			'groupBy', 'GROUP',
			'sortMethod', 'INDEX',
			'maxColumns', 1,
			'unitsPerColumn', 5,
			'columnSpacing', 0,
			'point', cfg.healer and 'LEFT' or 'TOP',
			'columnAnchorPoint', cfg.healer and 'LEFT' or 'RIGHT',
			'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
			]]):format((cfg.healer and cfg.raid_height_healer) or cfg.raid_height, (cfg.healer and cfg.raid_width_healer) or cfg.raid_width))
			return raid
		end

		local groups = {}
		for i = 1, cfg.groupFilter do
			groups[i] = CreateRaid('oUF_Raid'..i, i)
			if i == 1 then
				if cfg.healer then
					raidMover = F.Mover(groups[i], L['MOVER_UNITFRAME_RAID'], 'RaidFrame', cfg.raid_pos_healer, (cfg.raid_width_healer*5+cfg.raid_gap*4), (cfg.raid_height_healer*cfg.groupFilter+(cfg.raid_gap*(cfg.groupFilter-1))))
					groups[i]:ClearAllPoints()
					groups[i]:SetPoint('TOPLEFT', raidMover)
				else
					raidMover = F.Mover(groups[i], L['MOVER_UNITFRAME_RAID'], 'RaidFrame', cfg.raid_pos, (cfg.raid_width*cfg.groupFilter+(cfg.raid_gap*(cfg.groupFilter-1))), (cfg.raid_height*5+cfg.raid_gap*4))
					groups[i]:ClearAllPoints()
					groups[i]:SetPoint('TOPRIGHT', raidMover)
				end
			else
				if cfg.healer then
					groups[i]:SetPoint('TOPLEFT', groups[i-1], 'BOTTOMLEFT', 0, -cfg.raid_gap)
				else
					groups[i]:SetPoint('TOPRIGHT', groups[i-1], 'TOPLEFT', -cfg.raid_gap, 0)
				end
			end
		end
	end
end