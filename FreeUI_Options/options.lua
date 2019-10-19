local _, ns = ...


ns.addCategory('general')
ns.addCategory('appearance')
ns.addCategory('notification')
ns.addCategory('infobar')
ns.addCategory('actionbar')
ns.addCategory('cooldown')
ns.addCategory('aura')
ns.addCategory('unitFrame')
ns.addCategory('inventory')
ns.addCategory('loot')
ns.addCategory('map')
ns.addCategory('quest')
ns.addCategory('tooltip')
ns.addCategory('chat')

local fontsTable = {
	'interface\\addons\\FreeUI\\assets\\font\\supereffective.ttf',
	STANDARD_TEXT_FONT
}

local flagsTable = {
	'OUTLINE',
	'OUTLINEMONOCHROME',
	''
}


-- General
do
	local general = FreeUIOptionsPanel.general
	general.tab.Icon:SetTexture('Interface\\Icons\\Trade_Engineering')

	local basic = ns.addSubCategory(general, ns.localization.general_subCategory_basic)
	basic:SetPoint('TOPLEFT', general.subText, 'BOTTOMLEFT', 0, -8)

	local helmCloak = ns.CreateCheckBox(general, 'helmCloak')
	helmCloak:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local alreadyKnown = ns.CreateCheckBox(general, 'alreadyKnown')
	alreadyKnown:SetPoint('LEFT', helmCloak, 'RIGHT', 160, 0)

	local mailButton = ns.CreateCheckBox(general, 'mailButton')
	mailButton:SetPoint('TOPLEFT', helmCloak, 'BOTTOMLEFT', 0, -8)

	local enhancedMenu = ns.CreateCheckBox(general, 'enhancedMenu')
	enhancedMenu:SetPoint('LEFT', mailButton, 'RIGHT', 160, 0)

	local marker = ns.CreateCheckBox(general, 'marker')
	marker:SetPoint('TOPLEFT', mailButton, 'BOTTOMLEFT', 0, -8)

	local PVPSound = ns.CreateCheckBox(general, 'PVPSound')
	PVPSound:SetPoint('LEFT', marker, 'RIGHT', 160, 0)

	local autoDismount = ns.CreateCheckBox(general, 'autoDismount')
	autoDismount:SetPoint('TOPLEFT', marker, 'BOTTOMLEFT', 0, -8)

	local quickBuy = ns.CreateCheckBox(general, 'quickBuy')
	quickBuy:SetPoint('LEFT', autoDismount, 'RIGHT', 160, 0)

	local camerasub = ns.addSubCategory(general, ns.localization.general_subCategory_camera)
	camerasub:SetPoint('TOPLEFT', autoDismount, 'BOTTOMLEFT', 0, -16)

	local cameraZoomSpeed = ns.CreateNumberSlider(general, 'cameraZoomSpeed', 1, 5, 1, 5, 1, true)
	cameraZoomSpeed:SetPoint('TOPLEFT', camerasub, 'BOTTOMLEFT', 24, -32)

	local uiscalesub = ns.addSubCategory(general, ns.localization.general_subCategory_uiscale)
	uiscalesub:SetPoint('TOPLEFT', cameraZoomSpeed, 'BOTTOMLEFT', -24, -24)

	local uiScaleAuto = ns.CreateCheckBox(general, 'uiScaleAuto')
	uiScaleAuto:SetPoint('TOPLEFT', uiscalesub, 'BOTTOMLEFT', 0, -8)

	local uiScale = ns.CreateNumberSlider(general, 'uiScale', 0.4, 1.2, 0.4, 1.2, 0.01, true)
	uiScale:SetPoint('TOPLEFT', uiScaleAuto, 'BOTTOMLEFT', 24, -32)

	local function toggleUIScaleOptions()
		local shown = not uiScaleAuto:GetChecked()
		uiScale:SetShown(shown)
	end

	uiScaleAuto:HookScript('OnClick', toggleUIScaleOptions)
	uiScale:HookScript('OnShow', toggleUIScaleOptions)
end

-- Appearance
do
	local appearance = FreeUIOptionsPanel.appearance
	appearance.tab.Icon:SetTexture('Interface\\Icons\\Ability_Rogue_Disguise')

	local basic = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_basic)
	basic:SetPoint('TOPLEFT', appearance.subText, 'BOTTOMLEFT', 0, -8)

	local themes = ns.CreateCheckBox(appearance, 'themes')
	themes:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local backdropAlpha = ns.CreateNumberSlider(appearance, 'backdropAlpha', 0.1, 1, 0.1, 1, 0.01, true)
	backdropAlpha:SetPoint('TOPLEFT', themes, 'BOTTOMLEFT', 24, -24)

	themes.children = {backdropAlpha}

	local vignette = ns.CreateCheckBox(appearance, 'vignette')
	vignette:SetPoint('TOPLEFT', backdropAlpha, 'BOTTOMLEFT', -24, -24)

	local vignetteAlpha = ns.CreateNumberSlider(appearance, 'vignetteAlpha', 0.1, 1, 0.1, 1, 0.01, true)
	vignetteAlpha:SetPoint('TOPLEFT', vignette, 'BOTTOMLEFT', 24, -24)

	vignette.children = {vignetteAlpha}

	local misc = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_misc)
	misc:SetPoint('TOPLEFT', vignetteAlpha, 'BOTTOMLEFT', -24, -24)

	local flashCursor = ns.CreateCheckBox(appearance, 'flashCursor')
	flashCursor:SetPoint('TOPLEFT', misc, 'BOTTOMLEFT', 0, -16)

	local addShadowBorder = ns.CreateCheckBox(appearance, 'addShadowBorder')
	addShadowBorder:SetPoint('LEFT', flashCursor, 'RIGHT', 160, 0)

	local addGradient = ns.CreateCheckBox(appearance, 'addGradient')
	addGradient:SetPoint('TOPLEFT', flashCursor, 'BOTTOMLEFT', 0, -8)

	local subfonts = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_font)
	subfonts:SetPoint('TOPLEFT', addGradient, 'BOTTOMLEFT', 0, -16)

	local adjustFonts = ns.CreateCheckBox(appearance, 'adjustFonts')
	adjustFonts:SetPoint('TOPLEFT', subfonts, 'BOTTOMLEFT', 0, -8)

	local usePixelFont = ns.CreateCheckBox(appearance, 'usePixelFont')
	usePixelFont:SetPoint('LEFT', adjustFonts, 'RIGHT', 160, 0)

	local addons = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_addons)
	addons:SetPoint('TOPLEFT', adjustFonts, 'BOTTOMLEFT', 0, -16)

	local BigWigs = ns.CreateCheckBox(appearance, 'BigWigs', true)
	BigWigs:SetPoint('TOPLEFT', addons, 'BOTTOMLEFT', 0, -8)

	local WeakAuras = ns.CreateCheckBox(appearance, 'WeakAuras', true)
	WeakAuras:SetPoint('LEFT', BigWigs, 'RIGHT', 160, 0)
end

-- Notification
do
	local notification = FreeUIOptionsPanel.notification
	notification.tab.Icon:SetTexture('Interface\\Icons\\Ability_Warrior_BattleShout')

	local banner = ns.addSubCategory(notification, ns.localization.notification_subCategory_banner)
	banner:SetPoint('TOPLEFT', notification.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(notification, 'enableBanner')
	enable:SetPoint('TOPLEFT', banner, 'BOTTOMLEFT', 0, -8)

	local playSounds = ns.CreateCheckBox(notification, 'playSounds')
	playSounds:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local checkBagsFull = ns.CreateCheckBox(notification, 'checkBagsFull')
	checkBagsFull:SetPoint('LEFT', playSounds, 'RIGHT', 160, 0)

	local checkMail = ns.CreateCheckBox(notification, 'checkMail')
	checkMail:SetPoint('TOPLEFT', playSounds, 'BOTTOMLEFT', 0, -8)

	local autoRepair = ns.CreateCheckBox(notification, 'autoRepair')
	autoRepair:SetPoint('LEFT', checkMail, 'RIGHT', 160, 0)

	local autoSellJunk = ns.CreateCheckBox(notification, 'autoSellJunk')
	autoSellJunk:SetPoint('TOPLEFT', checkMail, 'BOTTOMLEFT', 0, -8)

	enable.children = {playSounds, checkBagsFull, checkMail, autoRepair, autoSellJunk}

	local alert = ns.addSubCategory(notification, ns.localization.notification_subCategory_combat)
	alert:SetPoint('TOPLEFT', autoSellJunk, 'BOTTOMLEFT', -16, -16)

	local combatAlert = ns.CreateCheckBox(notification, 'combatAlert')
	combatAlert:SetPoint('TOPLEFT', alert, 'BOTTOMLEFT', 0, -8)

	local interruptSound = ns.CreateCheckBox(notification, 'interruptSound')
	interruptSound:SetPoint('TOPLEFT', combatAlert, 'BOTTOMLEFT', 16, -8)

	local interruptAnnounce = ns.CreateCheckBox(notification, 'interruptAnnounce')
	interruptAnnounce:SetPoint('LEFT', interruptSound, 'RIGHT', 160, 0)

	local dispelSound = ns.CreateCheckBox(notification, 'dispelSound')
	dispelSound:SetPoint('TOPLEFT', interruptSound, 'BOTTOMLEFT', 0, -8)

	local dispelAnnounce = ns.CreateCheckBox(notification, 'dispelAnnounce')
	dispelAnnounce:SetPoint('LEFT', dispelSound, 'RIGHT', 160, 0)

	local lowHPSound = ns.CreateCheckBox(notification, 'lowHPSound')
	lowHPSound:SetPoint('TOPLEFT', dispelSound, 'BOTTOMLEFT', 0, -8)

	local lowMPSound = ns.CreateCheckBox(notification, 'lowMPSound')
	lowMPSound:SetPoint('LEFT', lowHPSound, 'RIGHT', 160, 0)

	local enterCombat = ns.CreateCheckBox(notification, 'enterCombat')
	enterCombat:SetPoint('TOPLEFT', lowHPSound, 'BOTTOMLEFT', 0, -8)

	local lowHPThreshold = ns.CreateNumberSlider(notification, 'lowHPThreshold', 0.1, 1, 0.1, 1, 0.1, true)
	lowHPThreshold:SetPoint('TOPLEFT', enterCombat, 'BOTTOMLEFT', 8, -24)

	local lowMPThreshold = ns.CreateNumberSlider(notification, 'lowMPThreshold', 0.1, 1, 0.1, 1, 0.1, true)
	lowMPThreshold:SetPoint('LEFT', lowHPThreshold, 'RIGHT', 70, 0)

	combatAlert.children = {interruptSound, interruptAnnounce, dispelSound, dispelAnnounce, lowHPSound, lowMPSound, enterCombat, lowHPThreshold, lowMPThreshold}
end

-- Infobar
do
	local infobar = FreeUIOptionsPanel.infobar
	infobar.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Note_03')

	local line = ns.addSubCategory(infobar, ns.localization.infobar_subCategory_cores)
	line:SetPoint('TOPLEFT', infobar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(infobar, 'enable')
	enable:SetPoint('TOPLEFT', line, 'BOTTOMLEFT', 0, -8)

	local mouseover = ns.CreateCheckBox(infobar, 'mouseover')
	mouseover:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local durability = ns.CreateCheckBox(infobar, 'durability')
	durability:SetPoint('LEFT', mouseover, 'RIGHT', 160, 0)

	local stats = ns.CreateCheckBox(infobar, 'stats')
	stats:SetPoint('TOPLEFT', mouseover, 'BOTTOMLEFT', 0, -8)

	local gold = ns.CreateCheckBox(infobar, 'gold')
	gold:SetPoint('LEFT', stats, 'RIGHT', 160, 0)

	local friends = ns.CreateCheckBox(infobar, 'friends')
	friends:SetPoint('TOPLEFT', stats, 'BOTTOMLEFT', 0, -8)

	local talent = ns.CreateCheckBox(infobar, 'talent')
	talent:SetPoint('LEFT', friends, 'RIGHT', 160, 0)

	local function toggleInfobarOptions()
		local shown = enable:GetChecked()
		mouseover:SetShown(shown)
		stats:SetShown(shown)
		gold:SetShown(shown)
		friends:SetShown(shown)
		durability:SetShown(shown)
		talent:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInfobarOptions)
	infobar:HookScript('OnShow', toggleInfobarOptions)
end

-- Actionbar
do
	local actionbar = FreeUIOptionsPanel.actionbar
	actionbar.tab.Icon:SetTexture('Interface\\Icons\\Ability_DualWield')

	local basic = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_basic)
	basic:SetPoint('TOPLEFT', actionbar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(actionbar, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local layoutStyle = ns.CreateRadioButtonGroup(actionbar, 'layoutStyle', 3, false, true)
	layoutStyle.buttons[1]:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -24)

	local extra = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_extra)
	extra:SetPoint('TOPLEFT', layoutStyle.buttons[3], 'BOTTOMLEFT', -16, -16)

	local bar3 = ns.CreateCheckBox(actionbar, 'bar3')
	bar3:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local bar3Mouseover = ns.CreateCheckBox(actionbar, 'bar3Mouseover')
	bar3Mouseover:SetPoint('TOPLEFT', bar3, 'BOTTOMLEFT', 16, -8)

	bar3.children = {bar3Mouseover}

	local sideBar = ns.CreateCheckBox(actionbar, 'sideBar')
	sideBar:SetPoint('LEFT', bar3, 'RIGHT', 160, 0)

	local sideBarMouseover = ns.CreateCheckBox(actionbar, 'sideBarMouseover')
	sideBarMouseover:SetPoint('TOPLEFT', sideBar, 'BOTTOMLEFT', 16, -8)

	sideBar.children = {sideBarMouseover}

	local petBar = ns.CreateCheckBox(actionbar, 'petBar')
	petBar:SetPoint('TOPLEFT', bar3Mouseover, 'BOTTOMLEFT', -16, -8)

	local petBarMouseover = ns.CreateCheckBox(actionbar, 'petBarMouseover')
	petBarMouseover:SetPoint('TOPLEFT', petBar, 'BOTTOMLEFT', 16, -8)

	petBar.children = {petBarMouseover}

	local stanceBar = ns.CreateCheckBox(actionbar, 'stanceBar')
	stanceBar:SetPoint('LEFT', petBar, 'RIGHT', 160, 0)

	local stanceBarMouseover = ns.CreateCheckBox(actionbar, 'stanceBarMouseover')
	stanceBarMouseover:SetPoint('TOPLEFT', stanceBar, 'BOTTOMLEFT', 16, -8)

	stanceBar.children = {stanceBarMouseover}

	local feature = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_feature)
	feature:SetPoint('TOPLEFT', petBarMouseover, 'BOTTOMLEFT', -16, -16)

	local hotKey = ns.CreateCheckBox(actionbar, 'hotKey')
	hotKey:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local macroName = ns.CreateCheckBox(actionbar, 'macroName')
	macroName:SetPoint('LEFT', hotKey, 'RIGHT', 160, 0)

	local count = ns.CreateCheckBox(actionbar, 'count')
	count:SetPoint('TOPLEFT', hotKey, 'BOTTOMLEFT', 0, -8)

	local classColor = ns.CreateCheckBox(actionbar, 'classColor')
	classColor:SetPoint('LEFT', count, 'RIGHT', 160, 0)

	local bind = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_bind)
	bind:SetPoint('TOPLEFT', count, 'BOTTOMLEFT', 0, -16)

	local hoverBind = ns.CreateCheckBox(actionbar, 'hoverBind')
	hoverBind:SetPoint('TOPLEFT', bind, 'BOTTOMLEFT', 0, -8)

	local size = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_size)
	size:SetPoint('TOPLEFT', hoverBind, 'BOTTOMLEFT', 0, -16)

	local buttonSizeNormal = ns.CreateNumberSlider(actionbar, 'buttonSizeNormal', 20, 50, 20, 50, 1, true)
	buttonSizeNormal:SetPoint('TOPLEFT', size, 'BOTTOMLEFT', 8, -32)

	local buttonSizeSmall = ns.CreateNumberSlider(actionbar, 'buttonSizeSmall', 20, 50, 20, 50, 1, true)
	buttonSizeSmall:SetPoint('LEFT', buttonSizeNormal, 'RIGHT', 70, 0)

	local buttonSizeBig = ns.CreateNumberSlider(actionbar, 'buttonSizeBig', 20, 50, 20, 50, 1, true)
	buttonSizeBig:SetPoint('TOPLEFT', buttonSizeNormal, 'BOTTOMLEFT', 0, -32)

	local function toggleActionBarsOptions()
		local shown = enable:GetChecked()
		layoutStyle.buttons[1]:SetShown(shown)
		layoutStyle.buttons[2]:SetShown(shown)
		layoutStyle.buttons[3]:SetShown(shown)

		feature:SetShown(shown)
		hotKey:SetShown(shown)
		macroName:SetShown(shown)
		count:SetShown(shown)
		classColor:SetShown(shown)

		bind:SetShown(shown)
		hoverBind:SetShown(shown)

		extra:SetShown(shown)
		stanceBar:SetShown(shown)
		stanceBarMouseover:SetShown(shown)
		petBar:SetShown(shown)
		petBarMouseover:SetShown(shown)
		bar3:SetShown(shown)
		bar3Mouseover:SetShown(shown)
		sideBar:SetShown(shown)
		sideBarMouseover:SetShown(shown)

		size:SetShown(shown)
		buttonSizeNormal:SetShown(shown)
		buttonSizeSmall:SetShown(shown)
		buttonSizeBig:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleActionBarsOptions)
	actionbar:HookScript('OnShow', toggleActionBarsOptions)
end

-- Cooldown
do
	local cooldown = FreeUIOptionsPanel.cooldown
	cooldown.tab.Icon:SetTexture('Interface\\Icons\\Spell_Nature_TimeStop')

	local basic = ns.addSubCategory(cooldown, ns.localization.cooldown_subCategory_basic)
	basic:SetPoint('TOPLEFT', cooldown.subText, 'BOTTOMLEFT', 0, -8)

	local CDEnhancement = ns.CreateCheckBox(cooldown, 'CDEnhancement')
	CDEnhancement:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local CDPulse = ns.CreateCheckBox(cooldown, 'CDPulse')
	CDPulse:SetPoint('LEFT', CDEnhancement, 'RIGHT', 160, 0)

	local CDFont = ns.CreateDropDown(cooldown, 'CDFont', true, ns.localization.font_stats_font, fontsTable)
	CDFont:SetPoint('TOPLEFT', CDEnhancement, 'BOTTOMLEFT', 0, -16)

	local CDFontFlag = ns.CreateDropDown(cooldown, 'CDFontFlag', true, ns.localization.font_stats_font_style, flagsTable)
	CDFontFlag:SetPoint('LEFT', CDFont, 'RIGHT', 30, 0)

	local CDFontSize = ns.CreateNumberSlider(cooldown, 'CDFontSize', 8, 24, 8, 24, 1, true)
	CDFontSize:SetPoint('TOPLEFT', CDFont, 'BOTTOMLEFT', 24, -32)

	local function toggleCooldownOptions()
		local shown = CDEnhancement:GetChecked()
		CDFont:SetShown(shown)
		CDFontFlag:SetShown(shown)
		CDFontSize:SetShown(shown)
	end

	CDEnhancement:HookScript('OnClick', toggleCooldownOptions)
	CDFontFlag:HookScript('OnShow', toggleCooldownOptions)
	CDFontSize:HookScript('OnShow', toggleCooldownOptions)
end

-- Aura
do
	local aura = FreeUIOptionsPanel.aura
	aura.tab.Icon:SetTexture('Interface\\Icons\\Spell_Holy_WordFortitude')

	local basic = ns.addSubCategory(aura, ns.localization.aura_subCategory_basic)
	basic:SetPoint('TOPLEFT', aura.subText, 'BOTTOMLEFT', 0, -8)

	local reminder = ns.CreateCheckBox(aura, 'reminder')
	reminder:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)
end

-- Unitframe
do
	local unitframe = FreeUIOptionsPanel.unitframe
	unitframe.tab.Icon:SetTexture('Interface\\Icons\\Spell_Holy_PrayerofSpirit')

	local basic = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_basic)
	basic:SetPoint('TOPLEFT', unitframe.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(unitframe, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local healer = ns.CreateCheckBox(unitframe, 'healer')
	healer:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local transMode = ns.CreateCheckBox(unitframe, 'transMode')
	transMode:SetPoint('LEFT', healer, 'RIGHT', 160, 0)

	local colourSmooth = ns.CreateCheckBox(unitframe, 'colourSmooth')
	colourSmooth:SetPoint('TOPLEFT', healer, 'BOTTOMLEFT', 0, -8)

	local portrait = ns.CreateCheckBox(unitframe, 'portrait')
	portrait:SetPoint('LEFT', colourSmooth, 'RIGHT', 160, 0)

	local frameVisibility = ns.CreateCheckBox(unitframe, 'frameVisibility')
	frameVisibility:SetPoint('TOPLEFT', colourSmooth, 'BOTTOMLEFT', 0, -8)

	local feature = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_feature)
	feature:SetPoint('TOPLEFT', frameVisibility, 'BOTTOMLEFT', -16, -16)

	local dispellable = ns.CreateCheckBox(unitframe, 'dispellable')
	dispellable:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local rangeCheck = ns.CreateCheckBox(unitframe, 'rangeCheck')
	rangeCheck:SetPoint('LEFT', dispellable, 'RIGHT', 160, 0)

	local comboPoints = ns.CreateCheckBox(unitframe, 'comboPoints')
	comboPoints:SetPoint('TOPLEFT', dispellable, 'BOTTOMLEFT', 0, -8)

	local energyTicker = ns.CreateCheckBox(unitframe, 'energyTicker')
	energyTicker:SetPoint('LEFT', comboPoints, 'RIGHT', 160, 0)

	local clickCast = ns.CreateCheckBox(unitframe, 'clickCast')
	clickCast:SetPoint('TOPLEFT', comboPoints, 'BOTTOMLEFT', 0, -8)

	local onlyShowPlayer = ns.CreateCheckBox(unitframe, 'onlyShowPlayer')
	onlyShowPlayer:SetPoint('LEFT', clickCast, 'RIGHT', 160, 0)

	local adjustClassColors = ns.CreateCheckBox(unitframe, 'adjustClassColors')
	adjustClassColors:SetPoint('TOPLEFT', clickCast, 'BOTTOMLEFT', 0, -8)

	local castbar = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_castbar)
	castbar:SetPoint('TOPLEFT', adjustClassColors, 'BOTTOMLEFT', 0, -16)

	local enableCastbar = ns.CreateCheckBox(unitframe, 'enableCastbar')
	enableCastbar:SetPoint('TOPLEFT', castbar, 'BOTTOMLEFT', 0, -8)

	local castbar_separatePlayer = ns.CreateCheckBox(unitframe, 'castbar_separatePlayer')
	castbar_separatePlayer:SetPoint('TOPLEFT', enableCastbar, 'BOTTOMLEFT', 16, -8)

	enableCastbar.children = {castbar_separatePlayer}

	local extra = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_extra)
	extra:SetPoint('TOPLEFT', castbar_separatePlayer, 'BOTTOMLEFT', -16, -16)

	local enableGroup = ns.CreateCheckBox(unitframe, 'enableGroup')
	enableGroup:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local groupNames = ns.CreateCheckBox(unitframe, 'groupNames')
	groupNames:SetPoint('TOPLEFT', enableGroup, 'BOTTOMLEFT', 16, -8)

	local groupColourSmooth = ns.CreateCheckBox(unitframe, 'groupColourSmooth')
	groupColourSmooth:SetPoint('LEFT', groupNames, 'RIGHT', 160, 0)

	local debuffsWatch = ns.CreateCheckBox(unitframe, 'debuffsWatch')
	debuffsWatch:SetPoint('TOPLEFT', groupNames, 'BOTTOMLEFT', 0, -8)

	local cornerBuffs = ns.CreateCheckBox(unitframe, 'cornerBuffs')
	cornerBuffs:SetPoint('LEFT', debuffsWatch, 'RIGHT', 160, 0)

	local groupFilter = ns.CreateNumberSlider(unitframe, 'groupFilter', 4, 8, 4, 8, 1, true)
	groupFilter:SetPoint('TOPLEFT', debuffsWatch, 'BOTTOMLEFT', 0, -30)

	local function toggleUFOptions()
		local shown = enable:GetChecked()
		feature:SetShown(shown)
		extra:SetShown(shown)
		castbar:SetShown(shown)

		transMode:SetShown(shown)
		portrait:SetShown(shown)
		healer:SetShown(shown)
		colourSmooth:SetShown(shown)
		frameVisibility:SetShown(shown)

		enableGroup:SetShown(shown)
		groupNames:SetShown(shown)
		groupColourSmooth:SetShown(shown)
		groupFilter:SetShown(shown)
		debuffsWatch:SetShown(shown)
		cornerBuffs:SetShown(shown)

		dispellable:SetShown(shown)
		rangeCheck:SetShown(shown)
		energyTicker:SetShown(shown)
		onlyShowPlayer:SetShown(shown)
		clickCast:SetShown(shown)
		comboPoints:SetShown(shown)
		adjustClassColors:SetShown(shown)
		
		enableCastbar:SetShown(shown)
		castbar_separatePlayer:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleUFOptions)
	unitframe:HookScript('OnShow', toggleUFOptions)

	local function toggleGroupOptions()
		local shown = enableGroup:GetChecked()
		groupNames:SetShown(shown)
		groupColourSmooth:SetShown(shown)
		groupFilter:SetShown(shown)
	end

	enableGroup:HookScript('OnClick', toggleGroupOptions)
	unitframe:HookScript('OnShow', toggleGroupOptions)
end

-- Inventory
do
	local inventory = FreeUIOptionsPanel.inventory
	inventory.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Bag_07')

	local basic = ns.addSubCategory(inventory, ns.localization.inventory_subCategory_basic)
	basic:SetPoint('TOPLEFT', inventory.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(inventory, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local newitemFlash = ns.CreateCheckBox(inventory, 'newitemFlash')
	newitemFlash:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local reverseSort = ns.CreateCheckBox(inventory, 'reverseSort')
	reverseSort:SetPoint('LEFT', newitemFlash, 'RIGHT', 160, 0)


	local combineFreeSlots = ns.CreateCheckBox(inventory, 'combineFreeSlots')
	combineFreeSlots:SetPoint('TOPLEFT', newitemFlash, 'BOTTOMLEFT', 0, -8)



	local category = ns.addSubCategory(inventory, ns.localization.inventory_subCategory_category)
	category:SetPoint('TOPLEFT', combineFreeSlots, 'BOTTOMLEFT', -16, -8)

	local useCategory = ns.CreateCheckBox(inventory, 'useCategory')
	useCategory:SetPoint('TOPLEFT', category, 'BOTTOMLEFT', 0, -8)

	local tradeGoodsFilter = ns.CreateCheckBox(inventory, 'tradeGoodsFilter')
	tradeGoodsFilter:SetPoint('TOPLEFT', useCategory, 'BOTTOMLEFT', 16, -8)

	local questItemFilter = ns.CreateCheckBox(inventory, 'questItemFilter')
	questItemFilter:SetPoint('LEFT', tradeGoodsFilter, 'RIGHT', 160, 0)


	local classRelatedFilter = ns.CreateCheckBox(inventory, 'classRelatedFilter')
	classRelatedFilter:SetPoint('TOPLEFT', tradeGoodsFilter, 'BOTTOMLEFT', 0, -8)


	useCategory.children = {tradeGoodsFilter, questItemFilter, classRelatedFilter}

	local size = ns.addSubCategory(inventory, ns.localization.inventory_subCategory_size)
	size:SetPoint('TOPLEFT', classRelatedFilter, 'BOTTOMLEFT', -16, -8)

	local slotSize = ns.CreateNumberSlider(inventory, 'itemSlotSize', 20, 40, 20, 40, 1, true)
	slotSize:SetPoint('TOPLEFT', size, 'BOTTOMLEFT', 24, -32)

	local bagColumns = ns.CreateNumberSlider(inventory, 'bagColumns', 8, 16, 8, 16, 1, true)
	bagColumns:SetPoint('TOPLEFT', slotSize, 'BOTTOMLEFT', 0, -32)

	local bankColumns = ns.CreateNumberSlider(inventory, 'bankColumns', 8, 16, 8, 16, 1, true)
	bankColumns:SetPoint('TOPLEFT', bagColumns, 'BOTTOMLEFT', 0, -32)

	local function toggleInventoryOptions()
		local shown = enable:GetChecked()
		useCategory:SetShown(shown)
		tradeGoodsFilter:SetShown(shown)
		classRelatedFilter:SetShown(shown)
		questItemFilter:SetShown(shown)
		reverseSort:SetShown(shown)
		newitemFlash:SetShown(shown)
		combineFreeSlots:SetShown(shown)
		slotSize:SetShown(shown)
		bagColumns:SetShown(shown)
		bankColumns:SetShown(shown)
		basic:SetShown(shown)
		size:SetShown(shown)
		category:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInventoryOptions)
	inventory:HookScript('OnShow', toggleInventoryOptions)
end

-- Loot
do
	local loot = FreeUIOptionsPanel.loot
	loot.tab.Icon:SetTexture('Interface\\Icons\\Ability_Hunter_BeastSoothe')

	local basic = ns.addSubCategory(loot, ns.localization.loot_subCategory_basic)
	basic:SetPoint('TOPLEFT', loot.subText, 'BOTTOMLEFT', 0, -8)

	local fasterLoot = ns.CreateCheckBox(loot, 'fasterLoot')
	fasterLoot:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)


end

-- Map
do
	local map = FreeUIOptionsPanel.map
	map.tab.Icon:SetTexture('Interface\\Icons\\Ability_Spy')

	local worldMap = ns.addSubCategory(map, ns.localization.map_subCategory_worldMap)
	worldMap:SetPoint('TOPLEFT', map.subText, 'BOTTOMLEFT', 0, -8)

	local coords = ns.CreateCheckBox(map, 'worldMapCoords')
	coords:SetPoint('TOPLEFT', worldMap, 'BOTTOMLEFT', 0, -8)

	local mapReveal = ns.CreateCheckBox(map, 'worldMapReveal')
	mapReveal:SetPoint('LEFT', coords, 'RIGHT', 160, 0)

	local miniMap = ns.addSubCategory(map, ns.localization.map_subCategory_miniMap)
	miniMap:SetPoint('TOPLEFT', coords, 'BOTTOMLEFT', 0, -16)

	local whoPings = ns.CreateCheckBox(map, 'whoPings')
	whoPings:SetPoint('TOPLEFT', miniMap, 'BOTTOMLEFT', 0, -8)

	local microMenu = ns.CreateCheckBox(map, 'microMenu')
	microMenu:SetPoint('LEFT', whoPings, 'RIGHT', 160, 0)

	local expRepBar = ns.CreateCheckBox(map, 'expRepBar')
	expRepBar:SetPoint('TOPLEFT', whoPings, 'BOTTOMLEFT', 0, -8)

	local miniMapSize = ns.CreateNumberSlider(map, 'miniMapSize', 100, 400, 100, 400, 1, true)
	miniMapSize:SetPoint('TOPLEFT', expRepBar, 'BOTTOMLEFT', 16, -32)
end

-- Quest
do
	local quest = FreeUIOptionsPanel.quest
	quest.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Book_08')

	local basic = ns.addSubCategory(quest, ns.localization.quest_subCategory_basic)
	basic:SetPoint('TOPLEFT', quest.subText, 'BOTTOMLEFT', 0, -8)



	local logEnhancement = ns.CreateCheckBox(quest, 'logEnhancement')
	logEnhancement:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local trackerEnhancement = ns.CreateCheckBox(quest, 'trackerEnhancement')
	trackerEnhancement:SetPoint('LEFT', logEnhancement, 'RIGHT', 160, 0)

	local quickQuest = ns.CreateCheckBox(quest, 'quickQuest')
	quickQuest:SetPoint('TOPLEFT', logEnhancement, 'BOTTOMLEFT', 0, -8)

	local rewardHightlight = ns.CreateCheckBox(quest, 'rewardHightlight')
	rewardHightlight:SetPoint('LEFT', quickQuest, 'RIGHT', 160, 0)



	local notifier = ns.CreateCheckBox(quest, 'notifier')
	notifier:SetPoint('TOPLEFT', quickQuest, 'BOTTOMLEFT', 0, -8)

	local progressNotify = ns.CreateCheckBox(quest, 'progressNotify')
	progressNotify:SetPoint('TOPLEFT', notifier, 'BOTTOMLEFT', 16, -8)

	local completeRing = ns.CreateCheckBox(quest, 'completeRing')
	completeRing:SetPoint('TOPLEFT', progressNotify, 'BOTTOMLEFT', 0, -8)

	notifier.children = {progressNotify, completeRing}
end

-- Tooltip
do
	local tooltip = FreeUIOptionsPanel.tooltip
	tooltip.tab.Icon:SetTexture('Interface\\Icons\\INV_Scroll_08')

	local basic = ns.addSubCategory(tooltip, ns.localization.tooltip_subCategory_basic)
	basic:SetPoint('TOPLEFT', tooltip.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(tooltip, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local cursor = ns.CreateCheckBox(tooltip, 'cursor')
	cursor:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local combatHide = ns.CreateCheckBox(tooltip, 'combatHide')
	combatHide:SetPoint('LEFT', cursor, 'RIGHT', 160, 0)

	local tipIcon = ns.CreateCheckBox(tooltip, 'tipIcon')
	tipIcon:SetPoint('TOPLEFT', cursor, 'BOTTOMLEFT', 0, -8)

	local borderColor = ns.CreateCheckBox(tooltip, 'borderColor')
	borderColor:SetPoint('LEFT', tipIcon, 'RIGHT', 160, 0)

	local hideTitle = ns.CreateCheckBox(tooltip, 'hideTitle')
	hideTitle:SetPoint('TOPLEFT', tipIcon, 'BOTTOMLEFT', 0, -8)

	local hideRealm = ns.CreateCheckBox(tooltip, 'hideRealm')
	hideRealm:SetPoint('LEFT', hideTitle, 'RIGHT', 160, 0)

	local hideRank = ns.CreateCheckBox(tooltip, 'hideRank')
	hideRank:SetPoint('TOPLEFT', hideTitle, 'BOTTOMLEFT', 0, -8)

	local targetBy = ns.CreateCheckBox(tooltip, 'targetBy')
	targetBy:SetPoint('LEFT', hideRank, 'RIGHT', 160, 0)

	local linkHover = ns.CreateCheckBox(tooltip, 'linkHover')
	linkHover:SetPoint('TOPLEFT', hideRank, 'BOTTOMLEFT', 0, -8)

	local extraInfo = ns.CreateCheckBox(tooltip, 'extraInfo')
	extraInfo:SetPoint('LEFT', linkHover, 'RIGHT', 160, 0)

	enable.children = {cursor, hideTitle, hideRealm, hideRank, combatHide, linkHover, borderColor, tipIcon, extraInfo, targetBy}
end

-- Chat
do
	local chat = FreeUIOptionsPanel.chat
	chat.tab.Icon:SetTexture('Interface\\Icons\\UI_Chat')

	local basic = ns.addSubCategory(chat, ns.localization.chat_subCategory_basic)
	basic:SetPoint('TOPLEFT', chat.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(chat, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local lockPosition = ns.CreateCheckBox(chat, 'lockPosition')
	lockPosition:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local fontOutline = ns.CreateCheckBox(chat, 'fontOutline')
	fontOutline:SetPoint('LEFT', lockPosition, 'RIGHT', 160, 0)

	local whisperAlert = ns.CreateCheckBox(chat, 'whisperAlert')
	whisperAlert:SetPoint('TOPLEFT', lockPosition, 'BOTTOMLEFT', 0, -8)

	local copyButton = ns.CreateCheckBox(chat, 'copyButton')
	copyButton:SetPoint('LEFT', whisperAlert, 'RIGHT', 160, 0)

	local fading = ns.CreateCheckBox(chat, 'fading')
	fading:SetPoint('TOPLEFT', whisperAlert, 'BOTTOMLEFT', 0, -8)

	local filters = ns.CreateCheckBox(chat, 'filters')
	filters:SetPoint('LEFT', fading, 'RIGHT', 160, 0)

	local hideVoiceButtons = ns.CreateCheckBox(chat, 'hideVoiceButtons')
	hideVoiceButtons:SetPoint('TOPLEFT', fading, 'BOTTOMLEFT', 0, -8)

	enable.children = {lockPosition, fontOutline, whisperAlert, copyButton, fading, filters, hideVoiceButtons}
end


