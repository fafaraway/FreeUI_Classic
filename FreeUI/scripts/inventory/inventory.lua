local F, C, L = unpack(select(2, ...))
local INVENTORY, cfg = F:RegisterModule('Inventory'), C.inventory


local cargBags = FreeUI.cargBags
local ipairs, strmatch, unpack, pairs, ceil = ipairs, string.match, unpack, pairs, math.ceil
local BAG_ITEM_QUALITY_COLORS = BAG_ITEM_QUALITY_COLORS
local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_RARE = LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_RARE
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_QUIVER = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_QUIVER
local GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem = GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem
local C_NewItems_IsNewItem, C_Timer_After = C_NewItems.IsNewItem, C_Timer.After
local IsControlKeyDown, IsAltKeyDown, DeleteCursorItem = IsControlKeyDown, IsAltKeyDown, DeleteCursorItem
local SortBankBags, SortBags, InCombatLockdown, ClearCursor = SortBankBags, SortBags, InCombatLockdown, ClearCursor
local GetContainerItemID, GetContainerNumFreeSlots = GetContainerItemID, GetContainerNumFreeSlots

local sortCache = {}
function INVENTORY:ReverseSort()
	for bag = 0, 4 do
		local numSlots = GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			local texture, _, locked = GetContainerItemInfo(bag, slot)
			if (slot <= numSlots/2) and texture and not locked and not sortCache['b'..bag..'s'..slot] then
				ClearCursor()
				PickupContainerItem(bag, slot)
				PickupContainerItem(bag, numSlots+1 - slot)
				sortCache['b'..bag..'s'..slot] = true
				C_Timer_After(.1, INVENTORY.ReverseSort)
				return
			end
		end
	end

	FreeUI_Backpack.isSorting = false
	FreeUI_Backpack:BAG_UPDATE()
end

function INVENTORY:UpdateAnchors(parent, bags)
	local anchor = parent
	for _, bag in ipairs(bags) do
		if bag:GetHeight() > 45 then
			bag:Show()
		else
			bag:Hide()
		end
		if bag:IsShown() then
			bag:SetPoint('BOTTOMLEFT', anchor, 'TOPLEFT', 0, 5)
			anchor = bag
		end
	end
end

function INVENTORY:SetBackground()
	F.CreateBD(self)
	F.CreateSD(self)
end

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or .3)
end

function INVENTORY:CreateInfoFrame()
	local infoFrame = CreateFrame('Button', nil, self)
	infoFrame:SetPoint('TOPLEFT', 10, 2)
	infoFrame:SetSize(140, 30)

	local searchIcon = self:CreateTexture(nil, 'ARTWORK')
	searchIcon:SetTexture(C.AssetsPath..'Search')
	searchIcon:SetVertexColor(.8, .8, .8)
	searchIcon:SetPoint('TOPLEFT', self, 'TOPLEFT', 6, -2)
	searchIcon:SetSize(16, 16)

	local search = self:SpawnPlugin('SearchBar', infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint('LEFT', 0, 5)
	search:DisableDrawLayer('BACKGROUND')
	local bg = F.CreateBDFrame(search, .8)
	bg:SetPoint('TOPLEFT', -5, -5)
	bg:SetPoint('BOTTOMRIGHT', 5, 5)
	if F then F.CreateGradient(bg) end

	local tag = self:SpawnPlugin('TagDisplay', '[money]', infoFrame)
	F.SetFS(tag, 'pixel')
	tag:SetPoint('LEFT', searchIcon, 'RIGHT', 6, 0)
end

function INVENTORY:CreateBagBar(settings, columns)
	local bagBar = self:SpawnPlugin('BagBar', settings.Bags)
	local width, height = bagBar:LayoutButtons('grid', columns, 5, 5, -5)
	bagBar:SetSize(width + 10, height + 10)
	bagBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -5)
	INVENTORY.SetBackground(bagBar)
	bagBar.highlightFunction = highlightFunction
	bagBar.isGlobal = true
	bagBar:Hide()

	self.BagBar = bagBar
end

function INVENTORY:CreateCloseButton()
	local bu = F.CreateButton(self, 16, 16, true, '')
	bu:SetPoint('TOPRIGHT', -5, -5)
	bu:SetScript('OnClick', CloseAllBags)
	bu.title = CLOSE
	F.AddTooltip(bu, 'ANCHOR_TOP')
	F.ReskinClose(bu)

	return bu
end

function INVENTORY:CreateRestoreButton(f)
	local bu = F.CreateButton(self, 17, 17, true, C.AssetsPath..'ResetNew', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', function()
		FreeUIConfig['tempAnchor'][f.main:GetName()] = nil
		FreeUIConfig['tempAnchor'][f.bank:GetName()] = nil
		f.main:ClearAllPoints()
		f.main:SetPoint('BOTTOMRIGHT', -50, 50)
		f.bank:ClearAllPoints()
		f.bank:SetPoint('BOTTOMRIGHT', f.main, 'BOTTOMLEFT', -10, 0)
		PlaySound(SOUNDKIT.IG_MINIMAP_OPEN)
	end)

	bu.title = L['INVENTORY_RESET']
	F.AddTooltip(bu, 'ANCHOR_TOP')

	return bu
end

function INVENTORY:CreateBagToggle()
	local bu = F.CreateButton(self, 17, 17, true, C.AssetsPath..'BagToggle')
	bu:SetScript('OnClick', function()
		ToggleFrame(self.BagBar)
		if self.BagBar:IsShown() then
			bu.Icon:SetVertexColor(1, 0, 0, 1)
			PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		else
			bu.Icon:SetVertexColor(1, 1, 1, 1)
			PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
		end

		bu:GetScript('OnEnter')(self)
	end)

	bu.title = L['INVENTORY_BAGS']
	F.AddTooltip(bu, 'ANCHOR_TOP')

	return bu
end

function INVENTORY:CreateSortButton(name)
	local bu = F.CreateButton(self, 17, 17, true, C.AssetsPath..'Restack', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', function()
		if name == 'Bank' then
			SortBankBags()
		else
			if cfg.reverseSort then
				if InCombatLockdown() then
					UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT)
				else
					SortBags()
					wipe(sortCache)
					FreeUI_Backpack.isSorting = true
					C_Timer_After(.5, INVENTORY.ReverseSort)
				end
			else
				SortBags()
			end
		end
	end)

	bu.title = L['INVENTORY_SORT']
	F.AddTooltip(bu, 'ANCHOR_TOP')

	return bu
end

local deleteEnable
function INVENTORY:CreateDeleteButton()
	local enabledText = C.InfoColor..L['INVENTORY_DELETE_MODE_ENABLED']

	local bu = F.CreateButton(self, 17, 17, true, C.AssetsPath..'SellJunk')
	bu:SetScript('OnClick', function(self)
		deleteEnable = not deleteEnable
		if deleteEnable then
			self.Icon:SetVertexColor(1, 0, 0, 1)
			self.text = enabledText

			print(C.RedColor..L['INVENTORY_DELETE_MODE_ENABLED_NOTIFY'])

			if C.notification.enableBanner then
				F.Notification(L['NOTIFICATION_BAG'], C.RedColor..L['INVENTORY_DELETE_MODE_ENABLED_NOTIFY'], 'Interface\\ICONS\\INV_Misc_Bag_08')
			end
		else
			self.Icon:SetVertexColor(1, 1, 1, 1)
			self.text = nil

			print(C.GreenColor..L['INVENTORY_DELETE_MODE_DISABLED_NOTIFY'])

			if C.notification.enableBanner then
				F.Notification(L['NOTIFICATION_BAG'], C.GreenColor..L['INVENTORY_DELETE_MODE_DISABLED_NOTIFY'], 'Interface\\ICONS\\INV_Misc_Bag_08')
			end
		end
		self:GetScript('OnEnter')(self)
	end)

	bu.title = L['INVENTORY_DELETE_MODE']
	F.AddTooltip(bu, 'ANCHOR_TOP')

	return bu
end

local function deleteButtonOnClick(self)
	if not deleteEnable then return end
	local texture, _, _, quality = GetContainerItemInfo(self.bagID, self.slotID)
	if IsControlKeyDown() and IsAltKeyDown() and texture and (quality < LE_ITEM_QUALITY_RARE) then
		PickupContainerItem(self.bagID, self.slotID)
		DeleteCursorItem()
	end
end

local favouriteEnable
function INVENTORY:CreateFavouriteButton()
	local enabledText = C.InfoColor..L['INVENTORY_FAVOURITE_MODE_ENABLED']

	local bu = F.CreateButton(self, 17, 17, true, C.AssetsPath..'Config')
	bu:SetScript('OnClick', function(self)
		favouriteEnable = not favouriteEnable
		if favouriteEnable then
			self.Icon:SetVertexColor(1, 0, 0, 1)
			self.text = enabledText
		else
			self.Icon:SetVertexColor(1, 1, 1, 1)
			self.text = nil
		end
		self:GetScript('OnEnter')(self)
	end)

	bu.title = L['INVENTORY_FAVOURITE_MODE']
	F.AddTooltip(bu, 'ANCHOR_TOP')

	return bu
end

local function favouriteOnClick(self)
	if not favouriteEnable then return end

	local texture, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(self.bagID, self.slotID)
	if texture and quality > LE_ITEM_QUALITY_POOR then
		if FreeUIConfig['inventory']['favouriteItems'][itemID] then
			FreeUIConfig['inventory']['favouriteItems'][itemID] = nil
		else
			FreeUIConfig['inventory']['favouriteItems'][itemID] = true
		end
		ClearCursor()
		FreeUI_Backpack:BAG_UPDATE()
	end
end

function INVENTORY:ButtonOnClick(btn)
	if btn ~= 'LeftButton' then return end
	deleteButtonOnClick(self)
	favouriteOnClick(self)
end

function INVENTORY:GetContainerEmptySlot(bagID)
	local bagType = INVENTORY.BagsType[bagID]
	for slotID = 1, GetContainerNumSlots(bagID) do
		if not GetContainerItemID(bagID, slotID) and bagType == 0 then
			return slotID
		end
	end
end

function INVENTORY:GetEmptySlot(name)
	if name == 'Main' then
		for bagID = 0, 4 do
			local slotID = INVENTORY:GetContainerEmptySlot(bagID)
			if slotID then
				return bagID, slotID
			end
		end
	elseif name == 'Bank' then
		local slotID = INVENTORY:GetContainerEmptySlot(-1)
		if slotID then
			return -1, slotID
		end
		for bagID = 5, 11 do
			local slotID = INVENTORY:GetContainerEmptySlot(bagID)
			if slotID then
				return bagID, slotID
			end
		end
	end
end

function INVENTORY:FreeSlotOnDrop()
	local bagID, slotID = INVENTORY:GetEmptySlot(self.__name)
	if slotID then
		PickupContainerItem(bagID, slotID)
	end
end

local freeSlotContainer = {
	['Main'] = true,
	['Bank'] = true,
}

function INVENTORY:CreateFreeSlots()
	if not cfg.combineFreeSlots then return end

	local name = self.name
	if not freeSlotContainer[name] then return end

	local slot = CreateFrame('Button', name..'FreeSlot', self)
	slot:SetSize(self.iconSize, self.iconSize)
	slot:SetHighlightTexture(C.media.bdTex)
	slot:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
	local bg = F.CreateBDFrame(slot)

	slot:SetScript('OnMouseUp', INVENTORY.FreeSlotOnDrop)
	slot:SetScript('OnReceiveDrag', INVENTORY.FreeSlotOnDrop)
	F.AddTooltip(slot, 'ANCHOR_RIGHT', L['INVENTORY_FREE_SLOTS'])
	slot.__name = name

	local tag = self:SpawnPlugin('TagDisplay', '[space]', slot)
	F.SetFS(tag, 'pixel')
	tag:SetTextColor(C.r, C.g, C.b)
	tag:SetPoint('BOTTOMRIGHT', 2, 2)
	tag.__name = name

	self.freeSlot = slot
end


function INVENTORY:OnLogin()
	if not cfg.enable then return end

	local bagsScale = cfg.bagScale
	local bagsWidth = cfg.bagColumns
	local bankWidth = cfg.bankColumns
	local iconSize = cfg.itemSlotSize
	local deleteButton = cfg.deleteButton

	local Backpack = cargBags:NewImplementation('FreeUI_Backpack')
	Backpack:RegisterBlizzard()
	Backpack:SetScale(bagsScale)
	Backpack:HookScript('OnShow', function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end)
	Backpack:HookScript('OnHide', function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end)

	INVENTORY.BagsType = {}
	INVENTORY.BagsType[0] = 0
	INVENTORY.BagsType[-1] = 0

	local f = {}
	local onlyBags, bagClass, bagAmmo, bagEquipment, bagConsumble, bagTradeGoods, bagQuestItem, bagsJunk, onlyBank, bankClass, bankAmmo, bankLegendary, bankEquipment, bankConsumble, onlyReagent, bagFavourite, bankFavourite = self:GetFilters()

	function Backpack:OnInit()
		local MyContainer = self:GetContainerClass()

		f.main = MyContainer:New('Main', {Columns = bagsWidth, Bags = 'bags'})
		f.main:SetFilter(onlyBags, true)
		f.main:SetPoint('BOTTOMRIGHT', -50, 50)

		f.junk = MyContainer:New('Junk', {Columns = bagsWidth, Parent = f.main})
		f.junk:SetFilter(bagsJunk, true)

		f.bagFavourite = MyContainer:New('BagFavourite', {Columns = bagsWidth, Parent = f.main})
		f.bagFavourite:SetFilter(bagFavourite, true)

		f.ammoItem = MyContainer:New('AmmoItem', {Columns = bagsWidth, Parent = f.main})
		f.ammoItem:SetFilter(bagAmmo, true)

		f.equipment = MyContainer:New('Equipment', {Columns = bagsWidth, Parent = f.main})
		f.equipment:SetFilter(bagEquipment, true)

		f.consumble = MyContainer:New('Consumble', {Columns = bagsWidth, Parent = f.main})
		f.consumble:SetFilter(bagConsumble, true)

		f.tradegoods = MyContainer:New('TradeGoods', {Columns = bagsWidth, Parent = f.main})
		f.tradegoods:SetFilter(bagTradeGoods, true)

		f.questitem = MyContainer:New('QuestItem', {Columns = bagsWidth, Parent = f.main})
		f.questitem:SetFilter(bagQuestItem, true)

		f.classItem = MyContainer:New('ClassItem', {Columns = bagsWidth, Parent = f.main})
		f.classItem:SetFilter(bagClass, true)

		f.bank = MyContainer:New('Bank', {Columns = bankWidth, Bags = 'bank'})
		f.bank:SetFilter(onlyBank, true)
		f.bank:SetPoint('BOTTOMRIGHT', f.main, 'BOTTOMLEFT', -10, 0)
		f.bank:Hide()

		f.bankFavourite = MyContainer:New('BankFavourite', {Columns = bankWidth, Parent = f.bank})
		f.bankFavourite:SetFilter(bankFavourite, true)

		f.bankAmmoItem = MyContainer:New('BankAmmoItem', {Columns = bankWidth, Parent = f.bank})
		f.bankAmmoItem:SetFilter(bankAmmo, true)

		f.bankLegendary = MyContainer:New('BankLegendary', {Columns = bankWidth, Parent = f.bank})
		f.bankLegendary:SetFilter(bankLegendary, true)

		f.bankEquipment = MyContainer:New('BankEquipment', {Columns = bankWidth, Parent = f.bank})
		f.bankEquipment:SetFilter(bankEquipment, true)

		f.bankConsumble = MyContainer:New('BankConsumble', {Columns = bankWidth, Parent = f.bank})
		f.bankConsumble:SetFilter(bankConsumble, true)

		f.bankClassItem = MyContainer:New('BankClassItem', {Columns = bankWidth, Parent = f.bank})
		f.bankClassItem:SetFilter(bankClass, true)
	end

	function Backpack:OnBankOpened()
		self:GetContainer('Bank'):Show()
	end

	function Backpack:OnBankClosed()
		self:GetContainer('Bank'):Hide()
	end

	local MyButton = Backpack:GetItemButtonClass()
	MyButton:Scaffold('Default')

	function MyButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetPushedTexture(nil)
		self:SetHighlightTexture(C.media.bdTex)
		self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
		self:SetSize(iconSize, iconSize)

		self.Icon:SetAllPoints()
		self.Icon:SetTexCoord(unpack(C.TexCoord))
		self.Count:SetPoint('BOTTOMRIGHT', 2, 2)
		F.SetFS(self.Count, 'pixel')

		self.BG = F.CreateBG(self)
		self.BG:SetVertexColor(0, 0, 0, .5)

		--[[self.junkIcon = self:CreateTexture(nil, 'ARTWORK')
		self.junkIcon:SetAtlas('bags-junkcoin')
		self.junkIcon:SetSize(20, 20)
		self.junkIcon:SetPoint('TOPRIGHT', 1, 0)]]

		self.Quest = F.CreateFS(self, 'pixel', '!', 'yellow', true, 'TOPLEFT', 2, -2)

		self.Favourite = self:CreateTexture(nil, 'ARTWORK', nil, 2)
		self.Favourite:SetAtlas('collections-icon-favorites')
		self.Favourite:SetSize(24, 24)
		self.Favourite:SetPoint('TOPLEFT', -6, 2)

		local flash = self:CreateTexture(nil, 'ARTWORK')
		flash:SetTexture('Interface\\Cooldown\\star4')
		flash:SetPoint('TOPLEFT', -20, 20)
		flash:SetPoint('BOTTOMRIGHT', 20, -20)
		flash:SetBlendMode('ADD')
		flash:SetAlpha(0)
		local anim = flash:CreateAnimationGroup()
		anim:SetLooping('REPEAT')
		anim.rota = anim:CreateAnimation('Rotation')
		anim.rota:SetDuration(1)
		anim.rota:SetDegrees(-90)
		anim.fader = anim:CreateAnimation('Alpha')
		anim.fader:SetFromAlpha(0)
		anim.fader:SetToAlpha(.5)
		anim.fader:SetDuration(.5)
		anim.fader:SetSmoothing('OUT')
		anim.fader2 = anim:CreateAnimation('Alpha')
		anim.fader2:SetStartDelay(.5)
		anim.fader2:SetFromAlpha(.5)
		anim.fader2:SetToAlpha(0)
		anim.fader2:SetDuration(1.2)
		anim.fader2:SetSmoothing('OUT')
		self:HookScript('OnHide', function() if anim:IsPlaying() then anim:Stop() end end)
		self.anim = anim

		self.ShowNewItems = true

		self:HookScript('OnClick', INVENTORY.ButtonOnClick)
	end

	function MyButton:ItemOnEnter()
		if self.ShowNewItems then
			if self.anim:IsPlaying() then self.anim:Stop() end
		end
	end

	function MyButton:OnUpdate(item)
		if MerchantFrame:IsShown() then
			if item.isInSet then
				self:SetAlpha(.5)
			else
				self:SetAlpha(1)
			end
		end
		
		--[[if MerchantFrame:IsShown() and item.rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0 then
			self.junkIcon:SetAlpha(1)
		else
			self.junkIcon:SetAlpha(0)
		end]]

		if FreeUIConfig['inventory']['favouriteItems'][item.id] then
			self.Favourite:SetAlpha(1)
		else
			self.Favourite:SetAlpha(0)
		end

		if self.ShowNewItems then
			if C_NewItems_IsNewItem(item.bagID, item.slotID) then
				self.anim:Play()
			else
				if self.anim:IsPlaying() then self.anim:Stop() end
			end
		end
	end

	function MyButton:OnUpdateQuest(item)
		self.Quest:SetAlpha(0)

		if item.isQuestItem then
			self.BG:SetVertexColor(.8, .8, 0, 1)
			self.Quest:SetAlpha(1)
		elseif item.rarity and item.rarity > -1 then
			local color = ITEM_QUALITY_COLORS[item.rarity]
			self.BG:SetVertexColor(color.r, color.g, color.b, 1)
		else
			self.BG:SetVertexColor(0, 0, 0, 1)
		end
	end

	local MyContainer = Backpack:GetContainerClass()
	function MyContainer:OnContentsChanged()
		self:SortButtons('bagSlot')

		local columns = self.Settings.Columns
		local offset = 30
		local spacing = 5
		local xOffset = 5
		local yOffset = -offset + spacing
		local width, height = self:LayoutButtons('grid', columns, spacing, xOffset, yOffset)
		if self.freeSlot then
			local numSlots = #self.buttons + 1
			local row = ceil(numSlots / columns)
			local col = numSlots % columns
			if col == 0 then col = columns end
			local xPos = (col-1) * (iconSize + spacing)
			local yPos = -1 * (row-1) * (iconSize + spacing)

			self.freeSlot:ClearAllPoints()
			self.freeSlot:SetPoint('TOPLEFT', self, 'TOPLEFT', xPos+xOffset, yPos+yOffset)

			if height < 0 then
				width, height = columns * (iconSize+spacing)-spacing, iconSize
			elseif col == 1 then
				height = height + iconSize + spacing
			end
		end
		self:SetSize(width + xOffset*2, height + offset)

		INVENTORY:UpdateAnchors(f.main, {f.classItem, f.ammoItem, f.equipment, f.bagFavourite, f.consumble, f.tradegoods, f.questitem, f.junk})
		INVENTORY:UpdateAnchors(f.bank, {f.bankClassItem, f.bankAmmoItem, f.bankEquipment, f.bankLegendary, f.bankFavourite, f.bankConsumble})
	end

	function MyContainer:OnCreate(name, settings)
		self.Settings = settings
		self:SetParent(settings.Parent or Backpack)
		self:SetFrameStrata('HIGH')
		self:SetClampedToScreen(true)
		INVENTORY.SetBackground(self)
		F.CreateMF(self, settings.Parent, true)

		local label
		if strmatch(name, 'AmmoItem$') then
			label = C.Class == 'HUNTER' and INVTYPE_AMMO or SOUL_SHARDS
		elseif strmatch(name, 'ClassItem$') then
			label = L['INVENTORY_CLASS_RELATED']
		elseif strmatch(name, 'Equipment$') then
			label = BAG_FILTER_EQUIPMENT
		elseif name == 'BankLegendary' then
			label = LOOT_JOURNAL_LEGENDARIES
		elseif strmatch(name, 'Consumble$') then
			label = BAG_FILTER_CONSUMABLES
		elseif strmatch(name, 'TradeGoods$') then
			label = BAG_FILTER_TRADE_GOODS
		elseif strmatch(name, 'QuestItem$') then
			label = AUCTION_CATEGORY_QUEST_ITEMS
		elseif name == 'Junk' then
			label = BAG_FILTER_JUNK
		elseif strmatch(name, 'Favourite') then
			label = PREFERENCES
		end
		if label then
			self.cat = F.CreateFS(self, {C.font.normal, 11}, label, 'yellow', true, 'TOPLEFT', 5, -4)
			return
		end

		INVENTORY.CreateInfoFrame(self)

		local buttons = {}
		buttons[1] = INVENTORY.CreateCloseButton(self)
		if name == 'Main' then
			INVENTORY.CreateBagBar(self, settings, 4)
			buttons[2] = INVENTORY.CreateRestoreButton(self, f)
			buttons[3] = INVENTORY.CreateBagToggle(self)
			buttons[4] = INVENTORY.CreateSortButton(self, name)
			buttons[5] = INVENTORY.CreateFavouriteButton(self)
			if deleteButton then buttons[6] = INVENTORY.CreateDeleteButton(self) end
		elseif name == 'Bank' then
			INVENTORY.CreateBagBar(self, settings, 7)
			buttons[2] = INVENTORY.CreateBagToggle(self)
			buttons[3] = INVENTORY.CreateSortButton(self, name)
		end

		for i = 1, 6 do
			local bu = buttons[i]
			if not bu then break end
			if i == 1 then
				bu:SetPoint('TOPRIGHT', -5, -2)
			else
				bu:SetPoint('RIGHT', buttons[i-1], 'LEFT', -3, 0)
			end
		end

		self:HookScript('OnShow', F.RestoreMF)

		self.iconSize = iconSize
		INVENTORY.CreateFreeSlots(self)
	end

	local BagButton = Backpack:GetClass('BagButton', true, 'BagButton')
	function BagButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetPushedTexture(nil)
		self:SetHighlightTexture(C.media.bdTex)
		self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)

		self:SetSize(iconSize, iconSize)

		self.BG = F.CreateBG(self)

		self.Icon:SetAllPoints()
		self.Icon:SetTexCoord(unpack(C.TexCoord))
	end

	function BagButton:OnUpdate()
		local id = GetInventoryItemID('player', (self.GetInventorySlot and self:GetInventorySlot()) or self.invID)
		if not id then return end
		local _, _, quality, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(id)
		quality = quality or 0
		if quality == 1 then quality = 0 end
		local color = ITEM_QUALITY_COLORS[quality]
		if not self.hidden and not self.notBought then
			self.BG:SetVertexColor(color.r, color.g, color.b, 1)
		else
			self.BG:SetVertexColor(0, 0, 0, .5)
		end

		if classID == LE_ITEM_CLASS_CONTAINER then
			INVENTORY.BagsType[self.bagID] = subClassID or 0
		elseif classID == LE_ITEM_CLASS_QUIVER then
			INVENTORY.BagsType[self.bagID] = -1
		else
			INVENTORY.BagsType[self.bagID] = 0
		end
	end

	-- Fixes
	ToggleAllBags()
	ToggleAllBags()
	BankFrame.GetRight = function() return f.bank:GetRight() end
	BankFrameItemButton_Update = F.Dummy

	SetSortBagsRightToLeft(not cfg.reverseSort)
	SetInsertItemsLeftToRight(false)
end