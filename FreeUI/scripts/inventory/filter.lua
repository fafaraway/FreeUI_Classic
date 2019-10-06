local F, C = unpack(select(2, ...))
local INVENTORY, cfg = F:GetModule('Inventory'), C.inventory

local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_COMMON, LE_ITEM_QUALITY_LEGENDARY = LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_COMMON, LE_ITEM_QUALITY_LEGENDARY
local LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT, EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC = LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT, EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR

-- Custom filter
local CustomFilterList = {
	[ 37863] = false,	-- 酒吧传送器
	[141333] = true,	-- 宁神圣典
	[141446] = true,	-- 宁神书卷
	[153646] = true,	-- 静心圣典
	[153647] = true,	-- 静心书卷
	[161053] = true,	-- 水手咸饼干
	[  6452] = true,	-- 抗毒药剂
}

local function isCustomFilter(item)
	if not cfg.useCategory then return end
	return CustomFilterList[item.id]
end

local ClassFilterList = {
	['ROGUE'] = {
		[ 7676] = true,	-- 菊花茶
		[ 5140] = true,	-- 闪光粉
		[ 5060] = true,	-- 盗贼工具
		[ 3775] = true,	-- 致残毒药
		[ 6947] = true,	-- 速效毒药
	},
	['MAGE'] = {
		[17020] = true,	-- 魔粉
		[17032] = true,	-- 传送门符文
		[17031] = true,	-- 传送符文
		[17056] = true,	-- 轻羽毛
	},
	['WARLOCK'] = {
	},
	['SHAMAN'] = {
	},
	['WARRIOR'] = {
	},
	['PALADIN'] = {
	},
	['PRIEST'] = {
	},
	['HUNTER'] = {
	},
	['DRUID'] = {
	},
}

local function isClassFilter(item)
	if not cfg.useCategory then return end
	return ClassFilterList[C.Class][item.id]
end

local function isItemClass(item)
	if not cfg.useCategory then return end
	if not cfg.classRelatedFilter then return end
	return isClassFilter(item)
end

-- Default filter
local function isItemInBag(item)
	return item.bagID >= 0 and item.bagID <= 4
end

local function isItemInBank(item)
	return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11
end

local function isItemJunk(item)
	if not cfg.useCategory then return end
	return item.rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0
end

local function isItemAmmo(item)
	if not cfg.useCategory then return end
	if C.Class == 'HUNTER' then
		return item.equipLoc == 'INVTYPE_AMMO' or INVENTORY.BagsType[item.bagID] == -1
	elseif C.Class == 'WARLOCK' then
		return item.id == 6265 or INVENTORY.BagsType[item.bagID] == 1
	end
end

local function isItemEquipment(item)
	if not cfg.useCategory then return end
	return item.level and item.rarity > LE_ITEM_QUALITY_COMMON and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or item.classID == LE_ITEM_CLASS_WEAPON or item.classID == LE_ITEM_CLASS_ARMOR)
end

local function isItemConsumble(item)
	if not cfg.useCategory then return end
	if isCustomFilter(item) == false then return end
	return isCustomFilter(item) or (item.classID and (item.classID == LE_ITEM_CLASS_CONSUMABLE or item.classID == LE_ITEM_CLASS_ITEM_ENHANCEMENT))
end

local function isItemLegendary(item)
	if not cfg.useCategory then return end
	return item.rarity == LE_ITEM_QUALITY_LEGENDARY
end

local function isItemFavourite(item)
	if not cfg.useCategory then return end
	return item.id and FreeUIConfig['inventory']['favouriteItems'][item.id]
end

local function isItemTrade(item)
	if not cfg.useCategory then return end
	if not cfg.tradeGoodsFilter then return end
	return item.classID == LE_ITEM_CLASS_TRADEGOODS
end

local function isItemQuest(item)
	if not cfg.useCategory then return end
	if not cfg.questItemFilter then return end
	return item.classID == LE_ITEM_CLASS_QUESTITEM
end

local function isEmptySlot(item)
	if not cfg.combineFreeSlots then return end
	return not item.texture and INVENTORY.BagsType[item.bagID] == 0
end


function INVENTORY:GetFilters()
	local onlyBags = function(item) return isItemInBag(item) and not isItemEquipment(item) and not isItemClass(item) and not isItemConsumble(item) and not isItemTrade(item) and not isItemQuest(item) and not isItemJunk(item) and not isItemFavourite(item) and not isEmptySlot(item) end
	local bagClass = function(item) return isItemInBag(item) and isItemClass(item) end
	local bagAmmo = function(item) return isItemInBag(item) and isItemAmmo(item) end
	local bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
	local bagConsumble = function(item) return isItemInBag(item) and isItemConsumble(item) and not isItemClass(item) end
	local bagTradeGoods = function(item) return isItemInBag(item) and isItemTrade(item) and not isItemClass(item) end
	local bagQuestItem = function(item) return isItemInBag(item) and isItemQuest(item) end
	local bagsJunk = function(item) return isItemInBag(item) and isItemJunk(item) end

	local onlyBank = function(item) return isItemInBank(item) and not isItemEquipment(item) and not isItemLegendary(item) and not isItemClass(item) and not isItemConsumble(item) and not isItemAmmo(item) and not isItemFavourite(item) and not isEmptySlot(item) end
	local bankClass = function(item) return isItemInBank(item) and isItemClass(item) end
	local bankAmmo = function(item) return isItemInBank(item) and isItemAmmo(item) end
	local bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
	local bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
	local bankConsumble = function(item) return isItemInBank(item) and isItemConsumble(item) and not isItemClass(item) end
	local bagFavourite = function(item) return isItemInBag(item) and isItemFavourite(item) end
	local bankFavourite = function(item) return isItemInBank(item) and isItemFavourite(item) end

	return onlyBags, bagClass, bagAmmo, bagEquipment, bagConsumble, bagTradeGoods, bagQuestItem, bagsJunk, onlyBank, bankClass, bankAmmo, bankLegendary, bankEquipment, bankConsumble, onlyReagent, bagFavourite, bankFavourite
end
