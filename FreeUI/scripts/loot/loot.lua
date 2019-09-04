local F, C = unpack(select(2, ...))
local LOOT = F:RegisterModule('loot')


local iconsize = 32
local width = 160
local sq, ss, sn, st

local loot = CreateFrame('Button', 'FreeUILootFrame', UIParent)
loot:SetFrameStrata('HIGH')
loot:SetClampedToScreen(true)
loot:SetWidth(width)
loot:SetHeight(64)

loot.slots = {}

local OnEnter = function(self)
	local slot = self:GetID()
	if GetLootSlotType(slot) == LOOT_SLOT_ITEM then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide'CONFIRM_LOOT_DISTRIBUTION'
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		st = self.icon:GetTexture()

		LootFrame.selectedLootButton = self:GetName()
		LootFrame.selectedSlot = ss
		LootFrame.selectedQuality = sq
		LootFrame.selectedItemName = sn
		LootFrame.selectedTexture = st

		LootSlot(ss)
	end
end

local createSlot = function(id)
	local frame = CreateFrame('Button', 'FreeUILootSlot'..id, loot)
	frame:SetPoint('TOP', loot, 0, -((id-1)*(iconsize+1)))
	frame:SetPoint('RIGHT')
	frame:SetPoint('LEFT')
	frame:SetHeight(24)
	frame:SetFrameStrata('HIGH')
	frame:SetFrameLevel(20)
	frame:SetID(id)
	loot.slots[id] = frame

	frame.bg = F.CreateBDFrame(frame)

	frame:SetScript('OnClick', OnClick)
	frame:SetScript('OnEnter', OnEnter)
	frame:SetScript('OnLeave', OnLeave)

	local iconFrame = CreateFrame('Frame', nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:SetFrameStrata('HIGH')
	iconFrame:SetFrameLevel(20)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

	local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
	icon:SetTexCoord(.08, .92, .08, .92)
	icon:SetPoint('TOPLEFT', 1, -1)
	icon:SetPoint('BOTTOMRIGHT', -1, 1)
	F.CreateBG(icon)
	frame.icon = icon

	local count = F.CreateFS(iconFrame, 'pixel')
	count:SetPoint('TOP', iconFrame, 1, -2)
	count:SetText(1)
	count:SetJustifyH('CENTER')
	frame.count = count

	local name = F.CreateFS(frame, {C.font.normal, 12}, nil, nil, true)
	name:SetPoint('RIGHT', frame)
	name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
	name:SetJustifyH('LEFT')
	name:SetNonSpaceWrap(true)
	frame.name = name

	return frame
end

local anchorSlots = function(self)
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint('TOP', loot, 4, (-8 + iconsize) - (shownSlots * (iconsize+1)))
		end
	end

	self:SetHeight(math.max(shownSlots * iconsize + 16, 20))
end

loot:SetScript('OnHide', function(self)
	StaticPopup_Hide'CONFIRM_LOOT_DISTRIBUTION'
	CloseLoot()
end)

loot.LOOT_CLOSED = function(self)
	StaticPopup_Hide'LOOT_BIND'
	self:Hide()

	for _, v in next, self.slots do
		v:Hide()
	end
end

loot.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	local x, y = GetCursorPosition()
	x = x / self:GetEffectiveScale()
	y = y / self:GetEffectiveScale()

	self:ClearAllPoints()
	self:SetPoint('TOPLEFT', nil, 'BOTTOMLEFT', x-40, y+20)
	self:Raise()

	if(items > 0) then
		for i = 1, items do
			local slot = loot.slots[i] or createSlot(i)
			local texture, item, quantity, currencyID, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			if texture then

				if GetLootSlotType(i) == LOOT_SLOT_MONEY then
					item = item:gsub('\n', ', ')
				end

				if(quantity > 1) then
					slot.count:SetText(quantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end

				slot.quality = quality

				local color = ITEM_QUALITY_COLORS[quality]

				if questId and not isActive then
					slot.bg:SetBackdropColor(.5, .5, 0, .3)
					slot.name:SetTextColor(1, 1, 0)
				elseif questId or isQuestItem then
					slot.bg:SetBackdropColor(.5, .5, 0, .3)
					slot.name:SetTextColor(color.r, color.g, color.b)
				else
					slot.bg:SetBackdropColor(0, 0, 0, .5)
					slot.name:SetTextColor(color.r, color.g, color.b)
				end

				slot.name:SetText(item)
				slot.icon:SetTexture(texture)

				slot:Enable()
				slot:Show()
			end
		end
	else
		self:Hide()
	end

	anchorSlots(self)
end

loot.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end
	loot.slots[slot]:Hide()
	anchorSlots(self)
end

loot.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, loot.slots[ss], 0, 0)
end

loot.UPDATE_MASTER_LOOT_LIST = function(self)
	MasterLooterFrame_UpdatePlayers()
end

loot:SetScript('OnEvent', function(self, event, arg1) self[event](self, event, arg1) end)

loot:RegisterEvent'LOOT_OPENED'
loot:RegisterEvent'LOOT_SLOT_CLEARED'
loot:RegisterEvent'LOOT_CLOSED'
loot:RegisterEvent'OPEN_MASTER_LOOT_LIST'
loot:RegisterEvent'UPDATE_MASTER_LOOT_LIST'
loot:Hide()

LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, 'FreeUILootFrame')