local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


local CornerBuffList = {
	PRIEST = {
		{10899, 'TOPLEFT', 		{1, .8, 0}}, 			-- Power Word: Shield
		{10900, 'TOPLEFT', 		{1, .8, 0}}, 			-- Power Word: Shield
		{10901, 'TOPLEFT', 		{1, .8, 0}}, 			-- Power Word: Shield
		{10927, 'LEFT', 		{0, 1, 0}}, 			-- Renew
		{10928, 'LEFT', 		{0, 1, 0}}, 			-- Renew
		{10929, 'LEFT', 		{0, 1, 0}}, 			-- Renew
		{25315, 'LEFT', 		{0, 1, 0}}, 			-- Renew
		{ 6788, 'BOTTOMLEFT', 	{.8, 0, 0}}, 			-- Weakened Soul
	},
	DRUID = {
		{ 9840, 'LEFT', 		{1, .2, 1}}, 			-- Rejuvenation
		{ 9841, 'LEFT', 		{1, .2, 1}}, 			-- Rejuvenation
		{25299, 'LEFT', 		{1, .2, 1}}, 			-- Rejuvenation
		{ 9856 , 'BOTTOMLEFT', 	{.4, 1, .4}}, 			-- Regrowth
		{ 9857 , 'BOTTOMLEFT', 	{.4, 1, .4}}, 			-- Regrowth
		{ 9858 , 'BOTTOMLEFT', 	{.4, 1, .4}}, 			-- Regrowth
	},
	PALADIN = {
		{25771, 'LEFT', 		{.8, 0, 0}}, 			-- Forbearance
	},
	WARRIOR = {
		{25289, 'LEFT', 		{1, .4 , .4}}, 			-- Battle Shout
	},
	WARLOCK = {
		{20707, 'LEFT',			{.8, .4, .8}},     	    -- Soulstone
	},
	HUNTER = {},
	MAGE = {
		{  130, 'TOPLEFT',		{.8, .2, 0}, true}, 	-- Slowfall
		{10157, 'BOTTOMRIGHT', 	{.4 , .4, 1}}, 			-- Arcane Intellect
		{23028, 'BOTTOMRIGHT', 	{.4 , .4, 1}}, 			-- Brilliance
		{10174, 'BOTTOMLEFT', 	{.2, .7, .4}}, 			-- Dampen Magic
		{10170, 'BOTTOMLEFT', 	{1, .7, .5}}, 			-- Amplify Magic
	},
	SHAMAN = {},
	ROGUE = {},
}

UNITFRAME.CornerBuffList = CornerBuffList
local CornerBuffsAnchor = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

function UNITFRAME:CreateCornerBuffIcon(icon)
	F.CreateBDFrame(icon)
	icon.icon:SetPoint('TOPLEFT', 1, -1)
	icon.icon:SetPoint('BOTTOMRIGHT', -1, 1)
	icon.icon:SetTexCoord(unpack(C.TexCoord))
	icon.icon:SetDrawLayer('ARTWORK')

	if (icon.cd) then
		icon.cd:SetHideCountdownNumbers(true)
		icon.cd:SetReverse(true)
	end

	icon.overlay:SetTexture()
end

function UNITFRAME:AddCornerBuff(self)
	if not cfg.cornerBuffs then return end

	local Auras = CreateFrame('Frame', nil, self)
	Auras:SetPoint('TOPLEFT', self.Health, 2, -2)
	Auras:SetPoint('BOTTOMRIGHT', self.Health, -2, 2)
	Auras:SetFrameLevel(self.Health:GetFrameLevel() + 5)
	Auras.presentAlpha = 1
	Auras.missingAlpha = 0
	Auras.icons = {}
	Auras.PostCreateIcon = UNITFRAME.CreateCornerBuffIcon
	Auras.strictMatching = true
	Auras.hideCooldown = true

	local buffs = {}

	if (UNITFRAME.CornerBuffList['ALL']) then
		for key, value in pairs(UNITFRAME.CornerBuffList['ALL']) do
			tinsert(buffs, value)
		end
	end

	if (UNITFRAME.CornerBuffList[C.Class]) then
		for key, value in pairs(UNITFRAME.CornerBuffList[C.Class]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for key, spell in pairs(buffs) do
			local Icon = CreateFrame('Frame', nil, Auras)
			Icon.spellID = spell[1]
			Icon.anyUnit = spell[4]
			Icon:SetSize(6, 6)
			Icon:SetPoint(spell[2], 0, 0)

			local Texture = Icon:CreateTexture(nil, 'OVERLAY')
			Texture:SetAllPoints(Icon)
			Texture:SetTexture(C.media.bdTex)

			if (spell[3]) then
				Texture:SetVertexColor(unpack(spell[3]))
			else
				Texture:SetVertexColor(0.8, 0.8, 0.8)
			end

			local Count = F.CreateFS(Icon, 'pixel')
			Count:SetPoint('CENTER', unpack(CornerBuffsAnchor[spell[2]]))
			Icon.count = Count

			Auras.icons[spell[1]] = Icon
		end
	end

	self.AuraWatch = Auras
end
