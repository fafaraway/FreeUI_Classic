local F, C, L = unpack(select(2, ...))
local MISC = F:RegisterModule('Misc')


local _G = getfenv(0)
local tostring, tonumber, pairs, select, random, strsplit, strmatch = tostring, tonumber, pairs, select, math.random, string.split, string.match


function MISC:OnLogin()
	self:HelmCloak()
	self:EnhancedMenu()

	self:ItemLevel()

	--self:AlertFrame()
	self:ErrorFrame()


	self:ColorPicker()

	self:FasterLoot()
	self:FasterDelete()


	self:ReadyCheck()
	self:Marker()

	self:MailButton()


	self:PVPSound()
	

	self:TradeTargetInfo()
	self:TicketStatusFrame()
	self:Reputation()







	-- Fix blizz error
	MAIN_MENU_MICRO_ALERT_PRIORITY = MAIN_MENU_MICRO_ALERT_PRIORITY or {}
end



-- Easily hide helm and cloak
function MISC:HelmCloak()
	if not C.general.helmCloak then return end

	local helm = CreateFrame("CheckButton", "FreeUI_HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
	helm:SetSize(22, 22)
	helm:SetPoint("LEFT", CharacterModelFrame, "BOTTOMLEFT", 0, 44)
	helm:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
	helm:SetScript("OnEvent", function() helm:SetChecked(ShowingHelm()) end)
	helm:RegisterEvent("UNIT_MODEL_CHANGED")
	helm:SetToplevel(true)
	helm.text = F.CreateFS(helm, (C.isCNClient and {C.font.normal, 11}) or 'pixel', L['MISC_SHOW_HELM'], nil, true, 'LEFT', 22, 1)

	local cloak = CreateFrame("CheckButton", "FreeUI_CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
	cloak:SetSize(22, 22)
	cloak:SetPoint("LEFT", CharacterModelFrame, "BOTTOMLEFT", 0, 24)
	cloak:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
	cloak:SetScript("OnEvent", function() cloak:SetChecked(ShowingCloak()) end)
	cloak:RegisterEvent("UNIT_MODEL_CHANGED")
	cloak:SetToplevel(true)
	cloak.text = F.CreateFS(cloak, (C.isCNClient and {C.font.normal, 11}) or 'pixel', L['MISC_SHOW_CLOAK'], nil, true, 'LEFT', 22, 1)

	helm:SetChecked(ShowingHelm())
	cloak:SetChecked(ShowingCloak())
	helm:SetFrameLevel(31)
	cloak:SetFrameLevel(31)

	F.ReskinCheck(helm)
	F.ReskinCheck(cloak)
end




-- Instant delete
function MISC:FasterDelete()
	hooksecurefunc(StaticPopupDialogs['DELETE_GOOD_ITEM'], 'OnShow', function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end

-- Faster looting
local lootDelay = 0
local function FasterLoot()
	if GetTime() - lootDelay >= 0.3 then
		lootDelay = GetTime()
		if GetCVarBool('autoLootDefault') ~= IsModifiedClick('AUTOLOOTTOGGLE') then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			lootDelay = GetTime()
		end
	end
end

function MISC:FasterLoot()
	if C.general.fasterLoot then
		F:RegisterEvent('LOOT_READY', FasterLoot)
	else
		F:UnregisterEvent('LOOT_READY', FasterLoot)
	end
end



-- Ready check in master sound
function MISC:ReadyCheck()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')

	f:RegisterEvent('RESURRECT_REQUEST')
	f:RegisterEvent('READY_CHECK')
	f:SetScript('OnEvent', function(self, event)
		if event == 'UPDATE_BATTLEFIELD_STATUS' then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == 'confirm' then
					PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
					break
				end
				i = i + 1
			end
		elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
			PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
		elseif event == 'LFG_PROPOSAL_SHOW' then
			PlaySound(SOUNDKIT.READY_CHECK, 'Master')
		elseif event == 'RESURRECT_REQUEST' then
			PlaySound(37, 'Master')
		elseif event == 'READY_CHECK' then
			PlaySound(SOUNDKIT.READY_CHECK, 'master')
		end
	end)
end


-- TradeFrame hook
function MISC:TradeTargetInfo()
	local infoText = F.CreateFS(TradeFrame, {C.font.normal, 14}, '', nil, nil, true)
	infoText:ClearAllPoints()
	infoText:SetPoint('TOP', TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

	local function updateColor()
		local r, g, b = F.UnitColor('NPC')
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID('NPC')
		if not guid then return end
		local text = '|cffff0000'..L['MISC_STRANGER']
		if BNGetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) then
			text = '|cffffff00'..FRIEND
		elseif IsGuildMember(guid) then
			text = '|cff00ff00'..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc('TradeFrame_Update', updateColor)
end







-- Reanchor TicketStatusFrame
function MISC:TicketStatusFrame()
	hooksecurefunc(TicketStatusFrame, 'SetPoint', function(self, relF)
		if relF == 'TOPRIGHT' then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 'TOP', 0, -100)
		end
	end)
end










-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G['RaidGroupButton'..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute('type', 'target')
				bu:SetAttribute('unit', bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local function setupMisc(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_RaidUI' then
			if not InCombatLockdown() then
				fixRaidGroupButton()
			else
				F:RegisterEvent('PLAYER_REGEN_ENABLED', setupMisc)
			end
			F:UnregisterEvent(event, setupMisc)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute('type') ~= 'target' then
				fixRaidGroupButton()
				F:UnregisterEvent(event, setupMisc)
			end
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end

-- ALT+RightClick to buy a stack
do
	local cache = {}
	local itemLink, id

	StaticPopupDialogs['BUY_STACK'] = {
		text = L['MISC_STACK_BUYING_CHECK'],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then return end
			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hasItemFrame = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = true,
		preferredIndex = 5,
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then return end
			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = GetItemQualityColor(quality or 1)
					StaticPopup_Show('BUY_STACK', ' ', ' ', {['texture'] = texture, ['name'] = name, ['color'] = {r, g, b, 1}, ['link'] = itemLink, ['index'] = id, ['count'] = maxStack})
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end

		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end

-- Show BID and highlight price
do
	local function setupMisc(event, addon)
		if addon == 'Blizzard_AuctionUI' then
			hooksecurefunc('AuctionFrameBrowse_Update', function()
				local numBatchAuctions = GetNumAuctionItems('list')
				local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
				local name, buyoutPrice, bidAmount, hasAllInfo
				for i = 1, NUM_BROWSE_TO_DISPLAY do
					local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
					local shouldHide = index > (numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page))
					if not shouldHide then
						name, _, _, _, _, _, _, _, _, buyoutPrice, bidAmount, _, _, _, _, _, _, hasAllInfo = GetAuctionItemInfo('list', offset + i)
						if not hasAllInfo then shouldHide = true end
					end
					if not shouldHide then
						local alpha = .5
						local color = 'yellow'
						local buttonName = 'BrowseButton'..i
						local itemName = _G[buttonName..'Name']
						local moneyFrame = _G[buttonName..'MoneyFrame']
						local buyoutMoney = _G[buttonName..'BuyoutFrameMoney']
						if buyoutPrice >= 5*1e7 then color = 'red' end
						if bidAmount > 0 then
							name = name..' |cffffff00'..BID..'|r'
							alpha = 1.0
						end
						itemName:SetText(name)
						moneyFrame:SetAlpha(alpha)
						SetMoneyFrameColor(buyoutMoney:GetName(), color)
					end
				end
			end)

			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end



-- Temporary taint fix
do
	InterfaceOptionsFrameCancel:SetScript("OnClick", function()
		InterfaceOptionsFrameOkay:Click()
	end)
end



-- Fix trade skill search
hooksecurefunc('ChatEdit_InsertLink', function(text) -- shift-clicked
	-- change from SearchBox:HasFocus to :IsShown again
	if text and TradeSkillFrame and TradeSkillFrame:IsShown() then
		local spellId = strmatch(text, 'enchant:(%d+)')
		local spell = GetSpellInfo(spellId)
		local item = GetItemInfo(strmatch(text, 'item:(%d+)') or 0)
		local search = spell or item
		if not search then return end

		-- search needs to be lowercase for .SetRecipeItemNameFilter
		TradeSkillFrame.SearchBox:SetText(search)

		-- jump to the recipe
		if spell then -- can only select recipes on the learned tab
			if PanelTemplates_GetSelectedTab(TradeSkillFrame.RecipeList) == 1 then
				TradeSkillFrame:SelectRecipe(tonumber(spellId))
			end
		elseif item then
			C_Timer.After(.1, function() -- wait a bit or we cant select the recipe yet
				for _, v in pairs(TradeSkillFrame.RecipeList.dataList) do
					if v.name == item then
						--TradeSkillFrame.RecipeList:RefreshDisplay() -- didnt seem to help
						TradeSkillFrame:SelectRecipe(v.recipeID)
						return
					end
				end
			end)
		end
	end
end)

-- make it only split stacks with shift-rightclick if the TradeSkillFrame is open
-- shift-leftclick should be reserved for the search box
local function hideSplitFrame(_, button)
	if TradeSkillFrame and TradeSkillFrame:IsShown() then
		if button == 'LeftButton' then
			StackSplitFrame:Hide()
		end
	end
end
hooksecurefunc('ContainerFrameItemButton_OnModifiedClick', hideSplitFrame)
hooksecurefunc('MerchantItemButton_OnModifiedClick', hideSplitFrame)

-- Fix blizz guild news hyperlink
do
	local function fixGuildNews(event, addon)
		if addon ~= 'Blizzard_GuildUI' then return end

		local _GuildNewsButton_OnEnter = GuildNewsButton_OnEnter
		function GuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_GuildNewsButton_OnEnter(self)
		end

		F:UnregisterEvent(event, fixGuildNews)
	end

	local function fixCommunitiesNews(event, addon)
		if addon ~= 'Blizzard_Communities' then return end

		local _CommunitiesGuildNewsButton_OnEnter = CommunitiesGuildNewsButton_OnEnter
		function CommunitiesGuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_CommunitiesGuildNewsButton_OnEnter(self)
		end

		F:UnregisterEvent(event, fixCommunitiesNews)
	end

	F:RegisterEvent('ADDON_LOADED', fixGuildNews)
	F:RegisterEvent('ADDON_LOADED', fixCommunitiesNews)
end



-- Add friend and guild invite on target menu
function MISC:MenuButton_OnClick(info)
	local name, server = UnitName(info.unit)
	if server and server ~= "" then name = name.."-"..server end

	if info.value == "name" then
		if MailFrame:IsShown() then
			MailFrameTab_OnClick(nil, 2)
			SendMailNameEditBox:SetText(name)
			SendMailNameEditBox:HighlightText()
		else
			local editBox = ChatEdit_ChooseBoxForSend()
			local hasText = (editBox:GetText() ~= "")
			ChatEdit_ActivateChat(editBox)
			editBox:Insert(name)
			if not hasText then editBox:HighlightText() end
		end
	elseif info.value == "guild" then
		GuildInvite(name)
	end
end

function MISC:MenuButton_Show(_, unit)
	if UIDROPDOWNMENU_MENU_LEVEL > 1 then return end

	if unit and (unit == "target" or string.find(unit, "party") or string.find(unit, "raid")) then
		local info = UIDropDownMenu_CreateInfo()
		info.text = MISC.MenuButtonList["name"]
		info.arg1 = {value = "name", unit = unit}
		info.func = MISC.MenuButton_OnClick
		info.notCheckable = true
		UIDropDownMenu_AddButton(info)

		if IsInGuild() and UnitIsPlayer(unit) and not UnitCanAttack("player", unit) and not UnitIsUnit("player", unit) then
			info = UIDropDownMenu_CreateInfo()
			info.text = MISC.MenuButtonList["guild"]
			info.arg1 = {value = "guild", unit = unit}
			info.func = MISC.MenuButton_OnClick
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)
		end
	end
end

function MISC:EnhancedMenu()
	if not C.general.enhancedMenu then return end

	MISC.MenuButtonList = {
		["name"] = COPY_NAME,
		["guild"] = gsub(CHAT_GUILD_INVITE_SEND, HEADER_COLON, ""),
	}
	hooksecurefunc("UnitPopup_ShowMenu", MISC.MenuButton_Show)
end