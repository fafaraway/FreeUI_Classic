local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')


local strmatch, format, tonumber, select, type, strfind = string.match, string.format, tonumber, select, type, string.find
local MerchantFrame = MerchantFrame
local GetMouseFocus, GetItemInfo = GetMouseFocus, GetItemInfo
local UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink = UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink
local BAGSLOT, BANK = BAGSLOT, BANK


local types = {
	spell = SPELLS..'ID:',
	item = ITEMS..'ID:',
	quest = QUESTS_LABEL..'ID:',
	talent = TALENT..'ID:',
	achievement = ACHIEVEMENTS..'ID:',
	currency = CURRENCY..'ID:',
	azerite = L['TOOLTIP_AZERITE_TRAIT']..'ID:',
}

function TOOLTIP:AddLineForID(id, linkType, noadd)
	for i = 1, self:NumLines() do
		local line = _G[self:GetName()..'TextLeft'..i]
		if not line then break end
		local text = line:GetText()
		if text and text == linkType then return end
	end
	if not noadd and IsAltKeyDown() then self:AddLine(' ') end

	if IsAltKeyDown() then
		self:AddDoubleLine(linkType, format(C.InfoColor..'%s|r', id))
	end

	if linkType == types.item then
		local bagCount = GetItemCount(id)
		local bankCount = GetItemCount(id, true) - GetItemCount(id)
		local itemStackCount = select(8, GetItemInfo(id))

		if bankCount > 0 and IsAltKeyDown() then
			self:AddDoubleLine(BAGSLOT..'/'..BANK..':', C.InfoColor..bagCount..'/'..bankCount)
		elseif bagCount > 0 and IsAltKeyDown() then
			self:AddDoubleLine(BAGSLOT..':', C.InfoColor..bagCount)
		end
		if itemStackCount and itemStackCount > 1 and IsAltKeyDown() then
			self:AddDoubleLine(L['TOOLTIP_STACK_CAP']..':', C.InfoColor..itemStackCount)
		end

		local container = GetMouseFocus()
		if container and container.GetName then
			local name = container:GetName() or ''
			local itemLink = select(2, self:GetItem())
			if itemLink then
				local itemSellPrice = select(11, GetItemInfo(itemLink))
				if itemSellPrice and itemSellPrice > 0 and IsAltKeyDown() then
					local name = container:GetName()
					local object = container:GetObjectType()
					local count
					if object == 'Button' then
						count = container.count
					elseif object == 'CheckButton' then
						count = container.count or tonumber(container.Count:GetText())
					end
					local vendorPrice = (type(count) == 'number' and count or 1) * itemSellPrice
					self:AddDoubleLine(L['TOOLTIP_SELL_PRICE']..':', '|cffffffff'..GetMoneyString(vendorPrice)..'|r')
				end
			end
		end
	end

	self:Show()
end

function TOOLTIP:SetHyperLinkID(link)
	local linkType, id = strmatch(link, '^(%a+):(%d+)')
	if not linkType or not id then return end

	if linkType == 'spell' or linkType == 'enchant' or linkType == 'trade' then
		TOOLTIP.AddLineForID(self, id, types.spell)
	elseif linkType == 'talent' then
		TOOLTIP.AddLineForID(self, id, types.talent, true)
	elseif linkType == 'quest' then
		TOOLTIP.AddLineForID(self, id, types.quest)
	elseif linkType == 'achievement' then
		TOOLTIP.AddLineForID(self, id, types.achievement)
	elseif linkType == 'item' then
		TOOLTIP.AddLineForID(self, id, types.item)
	elseif linkType == 'currency' then
		TOOLTIP.AddLineForID(self, id, types.currency)
	end
end

function TOOLTIP:SetItemID()
	local link = select(2, self:GetItem())
	if link then
		local id = strmatch(link, 'item:(%d+):')
		local keystone = strmatch(link, '|Hkeystone:([0-9]+):')
		if keystone then id = tonumber(keystone) end
		if id then TOOLTIP.AddLineForID(self, id, types.item) end
	end
end

function TOOLTIP:UpdateSpellCaster(...)
	local unitCaster = select(7, UnitAura(...))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F.HexRGB(F.UnitColor(unitCaster))
		self:AddDoubleLine(L['TOOLTIP_AURA_FROM']..':', hexColor..name)
		self:Show()
	end
end

function TOOLTIP:ExtraInfo()
	if not C.tooltip.extraInfo then return end

	-- Update all
	hooksecurefunc(GameTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)
	hooksecurefunc(ItemRefTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)

	-- Spells
	hooksecurefunc(GameTooltip, 'SetUnitAura', function(self, ...)
		local id = select(10, UnitAura(...))
		if id then TOOLTIP.AddLineForID(self, id, types.spell) end
	end)
	GameTooltip:HookScript('OnTooltipSetSpell', function(self)
		local id = select(2, self:GetSpell())
		if id then TOOLTIP.AddLineForID(self, id, types.spell) end
	end)
	hooksecurefunc('SetItemRef', function(link)
		local id = tonumber(strmatch(link, 'spell:(%d+)'))
		if id then TOOLTIP.AddLineForID(ItemRefTooltip, id, types.spell) end
	end)

	-- Items
	GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)





	-- Spell caster
	hooksecurefunc(GameTooltip, 'SetUnitAura', TOOLTIP.UpdateSpellCaster)


end