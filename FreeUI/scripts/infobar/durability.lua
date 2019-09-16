local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')


local format, gsub, sort, floor, modf, select = string.format, string.gsub, table.sort, math.floor, math.modf, select
local GetInventoryItemLink, GetInventoryItemDurability, GetInventoryItemTexture = GetInventoryItemLink, GetInventoryItemDurability, GetInventoryItemTexture
local GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair = GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair
local C_Timer_After, IsShiftKeyDown, InCombatLockdown, CanMerchantRepair = C_Timer.After, IsShiftKeyDown, InCombatLockdown, CanMerchantRepair
local FreeUIDurabilityButton = INFOBAR.FreeUIDurabilityButton

local localSlots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_CHEST, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, L['INFOBAR_HANDS'], 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, L['INFOBAR_FEET'], 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000}
}

local repairlist = {
	[0] = '|cffff5555'..VIDEO_OPTIONS_DISABLED,
	[1] = '|cff55ff55'..VIDEO_OPTIONS_ENABLED,
	[2] = '|cffffff55'..'NFG',
}

local function getItemDurability()
	local numSlots = 0
	for i = 1, 10 do
		if GetInventoryItemLink('player', localSlots[i][1]) then
			local current, max = GetInventoryItemDurability(localSlots[i][1])
			if current then 
				localSlots[i][3] = current/max
				numSlots = numSlots + 1
			end
		else
			localSlots[i][3] = 1000
		end
	end
	sort(localSlots, function(a, b) return a[3] < b[3] end)

	return numSlots
end

local function isLowDurability()
	for i = 1, 10 do
		if localSlots[i][3] < .25 then
			return true
		end
	end
end

local function gradientColor(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg*3+1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1+(r2-r1)*relperc, g1+(g2-g1)*relperc, b1+(b2-b1)*relperc
	return format('|cff%02x%02x%02x', r*255, g*255, b*255), r, g, b
end


function INFOBAR:DurabilityIndicatorMover()
	local f = CreateFrame('Frame', 'FreeUIDurabilityMover', UIParent)
	f:SetSize(50, 50)
	F.Mover(f, L['MOVER_DURABILITY_INDICATOR'], 'DurabilityFrame', {'TOP', UIParent, 'TOP', 0, -200})

	hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('CENTER', f)
		end
	end)
end


local isShown, isBankEmpty, autoRepair, repairAllCost, canRepair

local function delayFunc()
	if isBankEmpty then
		autoRepair(true)
	else
		print(format(C.RedColor..'%s:|r %s', L['INFOBAR_GUILD_REPAIR_COST'], GetMoneyString(repairAllCost)))

		if C.notification.enableBanner and C.notification.autoRepair then
			F.Notification(L['NOTIFICATION_REPAIR'], format(C.RedColor..'%s:|r %s', L['INFOBAR_GUILD_REPAIR_COST'], GetMoneyString(repairAllCost)), 'Interface\\ICONS\\Trade_BlackSmithing')
		end
	end
end

function autoRepair(override)
	if isShown and not override then return end
	isShown = true
	isBankEmpty = false

	local myMoney = GetMoney()
	repairAllCost, canRepair = GetRepairAllCost()

	if canRepair and repairAllCost > 0 then
		if (not override) and FreeUIGlobalConfig['repairType'] == 1 and not C.isClassic then
			RepairAllItems(true)
		else
			if myMoney > repairAllCost then
				RepairAllItems()

				print(format(C.RedColor..'%s:|r'..' %s', L['INFOBAR_REPAIR_COST'], GetMoneyString(repairAllCost)))

				if C.notification.enableBanner and C.notification.autoRepair then
					F.Notification(L['NOTIFICATION_REPAIR'], format(C.RedColor..'%s:|r'..' %s', L['INFOBAR_REPAIR_COST'], GetMoneyString(repairAllCost)), 'Interface\\ICONS\\Ability_Repair')
				end
				return
			else
				print(C.InfoColor..L['INFOBAR_REPAIR_FAILED'])

				if C.notification.enableBanner and C.notification.autoRepair then
					F.Notification(L['NOTIFICATION_REPAIR'], C.InfoColor..L['INFOBAR_REPAIR_FAILED'], 'Interface\\ICONS\\Ability_Repair')
				end
				return
			end
		end

		C_Timer_After(.5, delayFunc)
	end
end

local function checkBankFund(_, msgType)
	if msgType == LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
		isBankEmpty = true
	end
end

local function merchantClose()
	isShown = false
	F:UnregisterEvent('UI_ERROR_MESSAGE', checkBankFund)
	F:UnregisterEvent('MERCHANT_CLOSED', merchantClose)
end

local function merchantShow()
	if IsShiftKeyDown() or FreeUIGlobalConfig['repairType'] == 0 or not CanMerchantRepair() then return end
	autoRepair()
	F:RegisterEvent('UI_ERROR_MESSAGE', checkBankFund)
	F:RegisterEvent('MERCHANT_CLOSED', merchantClose)
end


function INFOBAR:Durability()
	if not C.infobar.enable then return end
	if not C.infobar.durability then return end

	FreeUIDurabilityButton = INFOBAR:addButton('', INFOBAR.POSITION_RIGHT, 120)

	FreeUIDurabilityButton:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	FreeUIDurabilityButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIDurabilityButton:SetScript('OnEvent', function(self, event)
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		if event == 'PLAYER_REGEN_ENABLED' then
			self:UnregisterEvent(event)
			self:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
			getItemDurability()
			if isLowDurability() then inform:Show() end
		else
			local numSlots = getItemDurability()
			if numSlots > 0 then
				self.Text:SetText(format(gsub('Durability: '..'[color]%d|r%%', '%[color%]', (gradientColor(floor(localSlots[1][3]*100)/100))), floor(localSlots[1][3]*100)))
			else
				self.Text:SetText('Durability'..': '..C.InfoColor..NONE)
			end
		end
	end)

	FreeUIDurabilityButton.onEnter = function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -15)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(DURABILITY, .9, .8, .6)
		GameTooltip:AddLine(' ')

		for i = 1, 10 do
			if localSlots[i][3] ~= 1000 then
				local green = localSlots[i][3]*2
				local red = 1 - green
				local slotIcon = '|T'..GetInventoryItemTexture('player', localSlots[i][1])..':13:15:0:0:50:50:4:46:4:46|t ' or ''
				GameTooltip:AddDoubleLine(slotIcon..localSlots[i][2], floor(localSlots[i][3]*100)..'%', 1,1,1, red+1,green,0)
			end
		end

		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.LeftButton..L['INFOBAR_AUTO_REPAIR']..': '..repairlist[FreeUIGlobalConfig['repairType']], 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end
	FreeUIDurabilityButton:HookScript('OnEnter', FreeUIDurabilityButton.onEnter)

	FreeUIDurabilityButton.onMouseUp = function(self, btn)
		if btn == 'LeftButton' then
			FreeUIGlobalConfig['repairType'] = mod(FreeUIGlobalConfig['repairType'] + 1, 2)
			F.Notification(L['NOTIFICATION_REPAIR'], L['INFOBAR_AUTO_REPAIR']..': '..repairlist[FreeUIGlobalConfig['repairType']], 'Interface\\ICONS\\Ability_Repair')
			self:onEnter()
		end
	end
	FreeUIDurabilityButton:HookScript('OnMouseUp', FreeUIDurabilityButton.onMouseUp)

	FreeUIDurabilityButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)

	self:DurabilityIndicatorMover()

	F:RegisterEvent('MERCHANT_SHOW', merchantShow)
end