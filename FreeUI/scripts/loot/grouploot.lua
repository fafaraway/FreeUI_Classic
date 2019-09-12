local F, C, L = unpack(select(2, ...))
local LOOT = F:GetModule('loot')


UIParent:UnregisterEvent('START_LOOT_ROLL')
UIParent:UnregisterEvent('CANCEL_LOOT_ROLL')

local width = 200
local iconsize = 32
local grouplootlist, grouplootframes = {}, {}

local MAX_LEVEL = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]


local function OnEvent(self, event, rollId)
	tinsert(grouplootlist, {rollId = rollId})
	self:UpdateGroupLoot()
end

local function FrameOnEvent(self, event, rollId)
	if(self.rollId and rollId==self.rollId) then
		for index, value in next, grouplootlist do
			if(self.rollId==value.rollId) then
				tremove(grouplootlist, index)
				break
			end
		end
		StaticPopup_Hide('CONFIRM_LOOT_ROLL', self.rollId)
		self.rollId = nil
		FreeUILootRoll:UpdateGroupLoot()
	end
end

local function FrameOnClick(self)
	HandleModifiedItemClick(self.rollLink)
end

local function onUpdate(self)
	if GameTooltip:IsOwned(self) then
		if IsModifiedClick('COMPAREITEMS') or GetCVarBool('alwaysCompareItems') then
			GameTooltip_ShowCompareItem()
		else
			ShoppingTooltip1:Hide()
			ShoppingTooltip2:Hide()
		end

		if IsModifiedClick('DRESSUP') then
			ShowInspectCursor()
		else
			ResetCursor()
		end
	end
end

local function FrameOnEnter(self)
	if(not self.rollId) then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	GameTooltip:SetLootRollItem(self.rollId)
	self:SetScript('OnUpdate', onUpdate)
	CursorUpdate(self)
end

local function FrameOnLeave(self)
	self:SetScript('OnUpdate', nil)
	GameTooltip:Hide()
	ResetCursor()
end

local function ButtonOnClick(self, button)
	RollOnLoot(self:GetParent().rollId, self.type)
end

local function SortFunc(a, b)
	return a.rollId < b.rollId
end




local frame = CreateFrame('Frame', 'FreeUILootRollMover', UIParent)
frame:SetSize(width, 32)
F.Mover(frame, L['MOVER_GROUP_LOOT'], 'LootRoll', {'CENTER', UIParent, 'CENTER', 0, 200})


local lootRoll = CreateFrame('Frame', 'FreeUILootRoll', FreeUILootRollMover)
lootRoll:RegisterEvent('START_LOOT_ROLL')
lootRoll:SetScript('OnEvent', OnEvent)
lootRoll:SetPoint('CENTER')
lootRoll:SetWidth(width)
lootRoll:SetHeight(32)

function lootRoll:UpdateGroupLoot()
	sort(grouplootlist, SortFunc)
	for index, value in next, grouplootframes do value:Hide() end

	local frame
	for index, value in next, grouplootlist do
		frame = grouplootframes[index]
		if(not frame) then
			frame = CreateFrame('Frame', 'FreeUILootRollFrame'..index, UIParent)
			frame:EnableMouse(true)
			frame:SetWidth(220)
			frame:SetHeight(32)
			frame:SetPoint('TOP', lootRoll, 0, -((index-1)*(iconsize+5)))
			frame:RegisterEvent('CANCEL_LOOT_ROLL')
			frame:SetScript('OnEvent', FrameOnEvent)
			frame:SetScript('OnMouseUp', FrameOnClick)
			frame:SetScript('OnLeave', FrameOnLeave)
			frame:SetScript('OnEnter', FrameOnEnter)

			F.CreateBD(frame)

			frame.pass = CreateFrame('Button', nil, frame)
			frame.pass.type = 0
			frame.pass.roll = 'pass'
			frame.pass:SetWidth(28)
			frame.pass:SetHeight(28)
			frame.pass:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Up')
			frame.pass:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Pass-Down')
			frame.pass:SetPoint('RIGHT', 0, 1)
			frame.pass:SetScript('OnClick', ButtonOnClick)

			frame.greed = CreateFrame('Button', nil, frame)
			frame.greed.type = 2
			frame.greed.roll = 'greed'
			frame.greed:SetWidth(28)
			frame.greed:SetHeight(28)
			frame.greed:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Up')
			frame.greed:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Down')
			frame.greed:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Highlight')
			frame.greed:SetPoint('RIGHT', frame.pass, 'LEFT', -1, -4)
			frame.greed:SetScript('OnClick', ButtonOnClick)

			frame.disenchant = CreateFrame('Button', nil, frame)
			frame.disenchant.type = 3
			frame.disenchant.roll = 'disenchant'
			frame.disenchant:SetWidth(28)
			frame.disenchant:SetHeight(28)
			frame.disenchant:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-DE-Up')
			frame.disenchant:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-DE-Down')
			frame.disenchant:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-DE-Highlight')
			frame.disenchant:SetPoint('RIGHT', frame.greed, 'LEFT', -1, 2)
			frame.disenchant:SetScript('OnClick', ButtonOnClick)

			frame.need = CreateFrame('Button', nil, frame)
			frame.need.type = 1
			frame.need.roll = 'need'
			frame.need:SetWidth(28)
			frame.need:SetHeight(28)
			frame.need:SetNormalTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Up')
			frame.need:SetPushedTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Down')
			frame.need:SetHighlightTexture('Interface\\Buttons\\UI-GroupLoot-Dice-Highlight')
			frame.need:SetPoint('RIGHT', frame.disenchant, 'LEFT', -1, 0)
			frame.need:SetScript('OnClick', ButtonOnClick)

			frame.text = F.CreateFS(frame, {C.font.normal, 11}, nil, nil, true)
			frame.text:SetJustifyH('LEFT')
			frame.text:SetPoint('LEFT')
			frame.text:SetPoint('RIGHT', frame.need, 'LEFT')

			local iconFrame = CreateFrame('Frame', nil, frame)
			iconFrame:SetHeight(iconsize)
			iconFrame:SetWidth(iconsize)
			iconFrame:ClearAllPoints()
			iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

			local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
			icon:SetPoint('TOPLEFT')
			icon:SetPoint('BOTTOMRIGHT')
			icon:SetTexCoord(.08, .92, .08, .92)
			frame.icon = icon

			F.CreateBG(icon)

			tinsert(grouplootframes, frame)
		end

		local texture, name, count, quality, bindOnPickUp, Needable, Greedable, Disenchantable = GetLootRollItemInfo(value.rollId)

		if Disenchantable then frame.disenchant:Enable() else frame.disenchant:Disable() end
		if Needable then frame.need:Enable() else frame.need:Disable() end
		if Greedable then frame.greed:Enable() else frame.greed:Disable() end

		SetDesaturation(frame.disenchant:GetNormalTexture(), not Disenchantable)
		SetDesaturation(frame.need:GetNormalTexture(), not Needable)
		SetDesaturation(frame.greed:GetNormalTexture(), not Greedable)

		frame.text:SetText(ITEM_QUALITY_COLORS[quality].hex..name)

		frame.icon:SetTexture(texture)

		frame.rollId = value.rollId
		frame.rollLink = GetLootRollItemLink(value.rollId)

		frame:Show()
	end
end