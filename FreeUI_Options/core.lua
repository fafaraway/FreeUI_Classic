local _, ns = ...


local F, C, L
local r, g, b

local realm = GetRealmName()
local name = UnitName('player')


-- [[ Variables ]]

local checkboxes = {}
local radiobuttons = {}
local sliders = {}
local colourpickers = {}
local editboxes = {}
local dropdowns = {}
local panels = {}

-- cache old values to check whether UI needs to be reloaded
local old = {}
local oldRadioValues = {}
local oldColours = {}

local overrideReload = false
local userChangedSlider = true -- to use SetValue without triggering OnValueChanged
local baseName = 'FreeUIOptionsPanel'


-- [[ Options frame ]]

local options = CreateFrame('Frame', baseName, UIParent)
options:SetSize(640, 700)
options:SetPoint('CENTER')
options:SetFrameStrata('HIGH')
options:EnableMouse(true)
options.close = CreateFrame('Button', nil, options, 'UIPanelCloseButton')
tinsert(UISpecialFrames, options:GetName())

options.closeButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
options.closeButton:SetPoint('BOTTOMRIGHT', -6, 6)
options.closeButton:SetSize(80, 24)
options.closeButton:SetText(CLOSE)
options.closeButton:SetScript('OnClick', function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	options:Hide()
end)
tinsert(ns.buttons, options.closeButton)

options.okayButton = CreateFrame('Button', 'FreeUIOptionsPanelOkayButton', options, 'UIPanelButtonTemplate')
options.okayButton:SetPoint('RIGHT', options.closeButton, 'LEFT', -6, 0)
options.okayButton:SetSize(80, 24)
options.okayButton:SetText(OKAY)
options.okayButton:Disable()
tinsert(ns.buttons, options.okayButton)

options.reloadText = options:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
options.reloadText:SetPoint('BOTTOM', 0, 12)
options.reloadText:SetText(ns.localization.needReload)
options.reloadText:Hide()

options.creditsFrame = CreateFrame('Frame', 'FreeUIOptionsPanelCredits', UIParent)
options.creditsFrame:SetSize(500, 500)
options.creditsFrame:SetPoint('CENTER')
options.creditsFrame:SetFrameStrata('DIALOG')
options.creditsFrame:EnableMouse(true)
options.creditsFrame:Hide()
options.creditsFrame.close = CreateFrame('Button', nil, options.creditsFrame, 'UIPanelCloseButton')
options.creditsFrame:SetScript('OnHide', function()
	options:SetAlpha(1)
end)
tinsert(UISpecialFrames, options.creditsFrame:GetName())

options.creditsFrame.closeButton = CreateFrame('Button', nil, options.creditsFrame, 'UIPanelButtonTemplate')
options.creditsFrame.closeButton:SetSize(80, 24)
options.creditsFrame.closeButton:SetPoint('BOTTOM', 0, 25)
options.creditsFrame.closeButton:SetText(CLOSE)
options.creditsFrame.closeButton:SetScript('OnClick', function()
	options.creditsFrame:Hide()
end)
tinsert(ns.buttons, options.creditsFrame.closeButton)

options.resetButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
options.resetButton:SetSize(120, 24)
options.resetButton:SetText(ns.localization.reset)
options.resetButton:SetPoint('BOTTOMLEFT', options, 'BOTTOMLEFT', 30, 50)
tinsert(ns.buttons, options.resetButton)

options.creditsButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
options.creditsButton:SetSize(120, 24)
options.creditsButton:SetText(ns.localization.credits)
options.creditsButton:SetPoint('BOTTOM', options.resetButton, 'TOP', 0, 4)
options.creditsButton:SetScript('OnClick', function()
	options.creditsFrame:Show()
	options:SetAlpha(.2)
end)
tinsert(ns.buttons, options.creditsButton)

options.installButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
options.installButton:SetSize(120, 24)
options.installButton:SetText(ns.localization.install)
options.installButton:SetPoint('BOTTOM', options.creditsButton, 'TOP', 0, 4)
tinsert(ns.buttons, options.installButton)

options.profile = CreateFrame('CheckButton', nil, options, 'InterfaceOptionsCheckButtonTemplate')
options.profile:SetSize(24, 24)
options.profile:SetPoint('BOTTOMLEFT', 6, 6)
options.profile.Text:SetText(ns.localization.profile)
options.profile.tooltipText = ns.localization.profileTooltip

options.line = options:CreateTexture()
options.line:SetSize(1, 600)
options.line:SetPoint('TOPLEFT', 180, -60)
options.line:SetColorTexture(.5, .5, .5, .1)


-- [[ Functions ]]

-- when an option needs a reload
local function setReloadNeeded(isNeeded)
	FreeUIOptionsPanel.reloadText:SetShown(isNeeded)
	ns.needReload = isNeeded -- for the popup when clicking okay

	if isNeeded then
		FreeUIOptionsPanelOkayButton:Enable()
	else
		FreeUIOptionsPanelOkayButton:Disable()
	end
end

-- check if a reload is needed
local function checkIsReloadNeeded()
	for frame, value in pairs(old) do
		if C[frame.group][frame.option] ~= value then
			setReloadNeeded(true)
			return
		end
	end

	for radioOptionGroup, radioOptionValues in pairs(oldRadioValues) do
		for option, value in pairs(radioOptionValues) do
			if C[radioOptionGroup][option] ~= value then
				setReloadNeeded(true)
				return
			end
		end
	end

	for colourOption, oldTable in pairs(oldColours) do
		local savedTable = C[colourOption.group][colourOption.option]
		if savedTable[1] ~= oldTable[1] or savedTable[2] ~= oldTable[2] or savedTable[3] ~= oldTable[3] then
			setReloadNeeded(true)
			return
		end
	end

	-- if the tables were empty, or all of the old values match their current ones
	setReloadNeeded(false)
end

-- Called by every widget to save a value
local function SaveValue(f, value)
	if not C.options[f.group] then C.options[f.group] = {} end
	if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

	C.options[f.group][f.option] = value -- these are the saved variables
	C[f.group][f.option] = value -- and this is from the lua options
end


-- [[ Widgets ]]

-- Toggle
local function toggleChildren(self, checked)
	local tR, tG, tB
	if checked then
		tR, tG, tB = 1, 1, 1
	else
		tR, tG, tB = .3, .3, .3
	end

	for _, child in next, self.children do
		if child.radioHeader then -- radio button group
			child.radioHeader:SetTextColor(tR, tG, tB)

			for _, radioButton in pairs(child.buttons) do
				radioButton:SetEnabled(checked)
				radioButton.text:SetTextColor(tR, tG, tB)
			end
		else
			child:SetEnabled(checked)
			child.Text:SetTextColor(tR, tG, tB)
		end
	end

	for _, slider in pairs(sliders) do
		slider.textInput.num:SetTextColor(tR, tG, tB)
	end
end

local function toggle(self)
	local checked = self:GetChecked()

	if checked then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end

	SaveValue(self, checked)
	if self.children then toggleChildren(self, checked) end

	if self.needsReload then
		if old[self] == nil then
			old[self] = not checked
		end

		checkIsReloadNeeded()
	end
end

-- Check boxes
ns.CreateCheckBox = function(parent, option, disable)
	local f = CreateFrame('CheckButton', nil, parent.child, 'InterfaceOptionsCheckButtonTemplate')
	f:SetSize(24, 24)

	if disable then
		f:Disable()
	end

	f.group = parent.tag
	f.option = option

	f.Text:SetText(ns.localization[parent.tag..'_'..option])
	f.tooltipText = ns.localization[parent.tag..'_'..option..'_tooltip']

	f.needsReload = true

	f:SetScript('OnClick', toggle)
	parent[option] = f

	tinsert(checkboxes, f)

	return f
end

-- Radios
local function toggleRadio(self)
	local previousValue

	local index = 1
	local radioButton = self.parent[self.option..index]
	while radioButton do
		if radioButton.isChecked then
			previousValue = index

			if radioButton ~= self then
				radioButton.isChecked = false
				radioButton:SetChecked(false)
			end
		end

		index = index + 1
		radioButton = self.parent[self.option..index]
	end

	self:SetChecked(true) -- don't allow deselecting
	self.isChecked = true

	PlaySound('856')

	SaveValue(self, self.index)

	if self.needsReload then
		if oldRadioValues[self.group] == nil then
			oldRadioValues[self.group] = {}

			if oldRadioValues[self.group][self.option] == nil then
				oldRadioValues[self.group][self.option] = previousValue
			end
		end

		checkIsReloadNeeded()
	end
end

local function radioOnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
end

local function radioOnLeave(self)
	GameTooltip:Hide()
end

ns.CreateRadioButtonGroup = function(parent, option, numValues, tooltipText, needsReload)
	local group = {}
	group.buttons = {}

	for i = 1, numValues do
		local f = CreateFrame('CheckButton', nil, parent.child, 'UIRadioButtonTemplate')

		f.parent = parent
		f.group = parent.tag
		f.option = option
		f.index = i

		f.text:SetFontObject(GameFontHighlight)
		f.text:SetText(ns.localization[parent.tag..'_'..option..i])
		if tooltipText then
			f.tooltipText = ns.localization[parent.tag..'_'..option..i..'tooltip']
		end

		if f.tooltipText then
			f:HookScript('OnEnter', radioOnEnter)
			f:HookScript('OnLeave', radioOnLeave)
		end

		f.needsReload = needsReload

		f:SetScript('OnClick', toggleRadio)
		parent[option..i] = f

		-- return value
		tinsert(group.buttons, f)

		-- handling input, style, ...
		tinsert(radiobuttons, f)

		if i > 1 then
			f:SetPoint('TOP', parent[option..i-1], 'BOTTOM', 0, -8)
		end
	end

	local firstOption = parent[option..1]

	-- add header
	local header = firstOption:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	header:SetPoint('BOTTOMLEFT', firstOption, 'TOPLEFT', 2, 5)
	header:SetText(ns.localization[parent.tag..'_'..option])
	group.radioHeader = header

	return group
end

-- Sliders
local function onValueChanged(self, value)
	if self.step < 1 then
		value = tonumber(string.format('%.2f', value))
	else
		value = floor(value + 0.5)
	end

	if self.textInput then
		self.textInput:SetText(value)
	end

	if userChangedSlider then
		SaveValue(self, value)

		if self.needsReload then
			if self.step < 1 then
				self.oldValue = tonumber(string.format('%.2f', self.oldValue))
			end
			old[self] = self.oldValue

			checkIsReloadNeeded()
		end
	end
end

local function createSlider(parent, option, lowText, highText, low, high, step, needsReload)
	local f = CreateFrame('Slider', baseName..option, parent.child, 'OptionsSliderTemplate')
	f:SetWidth(120)
	BlizzardOptionsPanel_Slider_Enable(f)

	f.group = parent.tag
	f.option = option

	f.text = _G[baseName..option..'Text']
	f.lowText = _G[baseName..option..'Low']
	f.highText = _G[baseName..option..'High']

	f.text:SetFontObject(GameFontNormalTiny)
	f.text:SetText(ns.localization[parent.tag..'_'..option])
	f.text:SetTextColor(1, 1, 1)

	f.lowText:SetText(lowText)
	f.lowText:SetTextColor(.5, .5, .5)
	f.highText:SetText(highText)
	f.highText:SetTextColor(.5, .5, .5)

	f:SetMinMaxValues(low, high)
	f:SetObeyStepOnDrag(true)
	f:SetValueStep(step)

	f.tooltipText = ns.localization[parent.tag..'_'..option..'_tooltip']

	f.needsReload = needsReload
	f.step = step

	f:SetScript('OnValueChanged', onValueChanged)
	parent[option] = f

	tinsert(sliders, f)

	return f
end

local function onSliderEscapePressed(self)
	self:ClearFocus()
end

local function onSliderEnterPressed(self)
	local slider = self:GetParent()
	local min, max = slider:GetMinMaxValues()

	local value = tonumber(self:GetText())
	if value and value >= floor(min) and value <= floor(max) then
		slider:SetValue(value)
	else
		self:SetText(floor(slider:GetValue()*1000)/1000)
	end

	self:ClearFocus()
end

ns.CreateNumberSlider = function(parent, option, lowText, highText, low, high, step, needsReload)
	local slider = createSlider(parent, option, lowText, highText, low, high, step, needsReload)

	local f = CreateFrame('EditBox', baseName..option..'TextInput', slider, 'InputBoxTemplate')
	f:SetAutoFocus(false)
	f:SetWidth(36)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	
	f:SetPoint('LEFT', slider, 'RIGHT', 20, 0)

	f.num = f:GetRegions()
	if f.num:GetObjectType() == 'FontString' then
		f.num:SetJustifyH('CENTER')
	end

	f:SetScript('OnEscapePressed', onSliderEscapePressed)
	f:SetScript('OnEnterPressed', onSliderEnterPressed)
	f:SetScript('OnEditFocusGained', nil)
	f:SetScript('OnEditFocusLost', onSliderEnterPressed)

	slider.textInput = f

	return slider
end

-- EditBox
local function onEnterPressed(self)
	local value = self.valueNumber and tonumber(self:GetText()) or tostring(self:GetText())
	SaveValue(self, value)
	self:ClearFocus()
	old[self] = self.oldValue
	checkIsReloadNeeded()
end

ns.CreateEditBox = function(parent, option, needsReload, number)
	local f = CreateFrame('EditBox', parent:GetName()..option..'TextInput', parent, 'InputBoxTemplate')
	f:SetAutoFocus(false)
	f:SetWidth(55)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	f:SetFontObject(GameFontHighlight)

	f:SetPoint('LEFT', 40, 0)

	f.value = ''
	f.valueNumber = number and true or false

	f:SetScript('OnEscapePressed', onSliderEscapePressed)
	f:SetScript('OnEscapePressed', function(self) self:ClearFocus() self:SetText(f.value) end)
	f:SetScript('OnEnterPressed', onEnterPressed)
	f:SetScript('OnEditFocusGained', function() f.value = f:GetText() end)
	f:SetScript('OnEditFocusLost', onEnterPressed)

	local label = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	label:SetWidth(440)
	label:SetHeight(20)
	label:SetJustifyH('LEFT')
	label:SetPoint('LEFT', f, 'RIGHT', 10, 0)
	label:SetText(ns.localization[parent.tag..'_'..option])

	f.tooltipText = ns.localization[parent.tag..'_'..option..'_tooltip'] or label

	f:SetScript('OnEnter', function()
		GameTooltip:SetOwner(f, 'ANCHOR_RIGHT', 5, 5)
		GameTooltip:SetText(f.tooltipText, nil, nil, nil, nil, true)
	end)

	f:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload
	parent[option] = f

	tinsert(editboxes, f)

	return f
end

-- Colour pickers
local currentColourOption

local function round(x)
	return floor((x * 100) + .5) / 100
end

local function setColour()
	local newR, newG, newB = ColorPickerFrame:GetColorRGB()
	newR, newG, newB = round(newR), round(newG), round(newB)

	currentColourOption:SetBackdropBorderColor(newR, newG, newB)
	currentColourOption:SetBackdropColor(newR, newG, newB, 0.3)
	SaveValue(currentColourOption, {newR, newG, newB})

	checkIsReloadNeeded()
end

local function resetColour(previousValues)
	local oldR, oldG, oldB = unpack(previousValues)

	currentColourOption:SetBackdropBorderColor(oldR, oldG, oldB)
	currentColourOption:SetBackdropColor(oldR, oldG, oldB, 0.3)
	SaveValue(currentColourOption, {oldR, oldG, oldB})

	checkIsReloadNeeded()
end

local function onColourSwatchClicked(self)
	local colourTable = C[self.group][self.option]

	local r, g, b = unpack(colourTable)
	r, g, b = round(r), round(g), round(b)
	local originalR, originalG, originalB = r, g, b

	currentColourOption = self

	if self.needsReload and oldColours[self] == nil then
		oldColours[self] = {r, g, b}
	end

	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.previousValues = {originalR, originalG, originalB}
	ColorPickerFrame.func = setColour
	ColorPickerFrame.cancelFunc = resetColour
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

ns.CreateColourPicker = function(parent, option, needsReload)
	local f = CreateFrame('Button', nil, parent)
	f:SetSize(22, 14)

	--[[f.label = f:CreateFontString(nil, 'OVERLAY', 'GameFontNormalTiny')
	f.label:SetText(COLOR)
	f.label:SetTextColor(1, 1, 1)
	f.label:SetPoint('CENTER')
	f.label:SetJustifyH('CENTER')--]]

	f.text = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	f.text:SetText(ns.localization[parent.tag..'_'..option])
	f.text:SetWidth(300)
	f.text:SetHeight(20)
	f.text:SetJustifyH('LEFT')
	f.text:SetPoint('LEFT', 30, 2)

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload

	f:SetScript('OnClick', onColourSwatchClicked)
	parent[option] = f

	tinsert(colourpickers, f)

	return f
end

-- DropDown
local DropDownText = {
	['interface\\addons\\FreeUI\\assets\\font\\supereffective.ttf'] = 'Pixel font',
	[STANDARD_TEXT_FONT] = 'Normal font'
}

ns.CreateDropDown = function(parent, option, needsReload, text, tableValue)
	local f = CreateFrame('Frame', parent:GetName()..option..'DropDown', parent, 'UIDropDownMenuTemplate')
	UIDropDownMenu_SetWidth(f, 110)

	UIDropDownMenu_Initialize(f, function(self)
		local info = UIDropDownMenu_CreateInfo()
		info.func = self.SetValue
		for _, value in pairs(tableValue) do
			info.text = DropDownText[value] or value
			info.arg1 = value
			info.checked = value == f.selectedValue
			UIDropDownMenu_AddButton(info)
		end
	end)

	function f:SetValue(newValue)
		f.selectedValue = newValue
		local text = DropDownText[newValue] or newValue
		UIDropDownMenu_SetText(f, text)
		SaveValue(f, newValue)
		old[f] = f.oldValue
		checkIsReloadNeeded()
		CloseDropDownMenus()
	end

	local label = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	if text then
		label:SetText(text)
	else
		label:SetText(ns.localization[parent.tag..'_'..option])
	end
	label:SetWidth(440)
	label:SetHeight(20)
	label:SetJustifyH('LEFT')
	label:SetPoint('LEFT', 150, 4)

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload

	parent[option] = f

	tinsert(dropdowns, f)

	return f
end


-- [[ Categories and tabs ]]

local offset = 60
local activeTab = nil

local function setActiveTab(tab)
	activeTab = tab
	activeTab:SetBackdropColor(r, g, b, .3)
	activeTab.panel:Show()
end

local onTabClick = function(tab)
	activeTab.panel:Hide()
	activeTab:SetBackdropColor(.03, .03, .03, .3)
	setActiveTab(tab)
end

ns.addCategory = function(name)
	local tag = strlower(name)

	local panel = CreateFrame('ScrollFrame', baseName..name, FreeUIOptionsPanel, 'UIPanelScrollFrameTemplate')
	panel:SetSize(420, 600)
	panel:SetPoint('TOPLEFT', 190, -60)
	panel:Hide()

	panel.child = CreateFrame('Frame', nil, panel)
	panel.child:SetPoint('TOPLEFT', 0, 0)
	panel.child:SetPoint('BOTTOMRIGHT', 0, 0)
	panel.child:SetSize(420, 800)

	panel:SetScrollChild(panel.child)

	panel.Title = panel.child:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	panel.Title:SetPoint('TOPLEFT', 14, -16)
	panel.Title:SetText(ns.localization[tag])

	panel.subText = panel.child:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	panel.subText:SetPoint('TOPLEFT', panel.Title, 'BOTTOMLEFT', 0, -8)
	panel.subText:SetJustifyH('LEFT')
	panel.subText:SetJustifyV('TOP')
	panel.subText:SetSize(420, 30)
	panel.subText:SetText(ns.localization[tag..'_'..'subText'])

	local tab = CreateFrame('Button', nil, FreeUIOptionsPanel)
	tab:SetPoint('TOPLEFT', 10, -offset)
	tab:SetSize(160, 30)

	local icon = tab:CreateTexture(nil, 'OVERLAY')
	icon:SetSize(20, 20)
	icon:SetPoint('LEFT', tab, 6, 0)
	icon:SetTexCoord(.08, .92, .08, .92)
	tab.Icon = icon

	tab.Text = tab:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med3')
	tab.Text:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
	tab.Text:SetTextColor(.9, .9, .9)
	tab.Text:SetText(ns.localization[tag])

	tab:SetScript('OnMouseUp', onTabClick)

	tab.panel = panel
	panel.tab = tab
	panel.tag = tag

	FreeUIOptionsPanel[tag] = panel

	tinsert(panels, panel)

	offset = offset + 36
end

ns.addSubCategory = function(category, name)
	local header = category.child:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	header:SetText(name)
	header:SetTextColor(233/255, 197/255, 93/255)

	local line = category.child:CreateTexture(nil, 'ARTWORK')
	line:SetSize(380, 1)
	line:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -4)
	line:SetColorTexture(.5, .5, .5, .1)

	return header, line
end


-- [[ Init ]]

local function changeProfile()
	local profile

	if FreeUIOptionsGlobal[realm][name] == true then
		if FreeUIOptionsPerChar == nil then
			FreeUIOptionsPerChar = {}
		end

		profile = FreeUIOptionsPerChar
	else
		profile = FreeUIOptions
	end

	for group, options in pairs(profile) do
		if C[group] then
			for option, value in pairs(options) do
				if C[group][option] == nil or (group == 'unitframes' and (tonumber(profile[group][option]) or type(profile[group][option]) == 'table')) then
					profile[group][option] = nil
				else
					C[group][option] = value
				end
			end
		else
			profile[group] = nil
		end
	end

	C.options = profile
end

local function displaySettings()
	for _, box in pairs(checkboxes) do
		box:SetChecked(C[box.group][box.option])
		if box.children then toggleChildren(box, box:GetChecked()) end
	end

	for _, radio in pairs(radiobuttons) do
		local isChecked = C[radio.group][radio.option] == radio.index

		radio:SetChecked(isChecked)
		radio.isChecked = isChecked -- need this for storing the previous value when user changes setting
	end

	userChangedSlider = false

	for _, slider in pairs(sliders) do
		slider:SetValue(C[slider.group][slider.option])
		slider.textInput:SetText(floor(C[slider.group][slider.option]*1000)/1000)
		slider.textInput:SetCursorPosition(0)
		slider.oldValue = C[slider.group][slider.option]
	end

	userChangedSlider = true

	for _, editbox in pairs(editboxes) do
		editbox:SetText(C[editbox.group][editbox.option])
		editbox:SetCursorPosition(0)
		editbox.oldValue = C[editbox.group][editbox.option]
	end

	for _, dropdown in pairs(dropdowns) do
		local text = DropDownText[C[dropdown.group][dropdown.option]] or C[dropdown.group][dropdown.option]
		UIDropDownMenu_SetText(dropdown, text)
		dropdown.selectedValue = C[dropdown.group][dropdown.option]
		dropdown.oldValue = C[dropdown.group][dropdown.option]
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)
	r, g, b = C.r, C.g, C.b
	L = ns.localization

	local FOP = FreeUIOptionsPanel

	if C.unitframe.enable then
		FOP:HookScript("OnShow", function()
			oUF_Player:SetAlpha(0)
			oUF_Pet:SetAlpha(0)
			oUF_Target:SetAlpha(0)
			oUF_TargetTarget:SetAlpha(0)
		end)

		FOP:HookScript("OnHide", function()
			oUF_Player:SetAlpha(1)
			oUF_Pet:SetAlpha(1)
			oUF_Target:SetAlpha(1)
			oUF_TargetTarget:SetAlpha(1)
		end)
	end
	
	StaticPopupDialogs['FREEUI_RESET'] = {
		text = L.resetCheck,
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			FreeUIGlobalConfig = {}
			FreeUIConfig = {}
			FreeUIOptionsGlobal[realm][name] = false
			FreeUIOptions = {}
			FreeUIOptionsPerChar = {}
			
			C.options = FreeUIOptions
			
			ReloadUI()
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
		preferredIndex = 5,
	}

	StaticPopupDialogs['FREEUI_PROFILE'] = {
		text = L.profileCheck,
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			if FOP.profile:GetChecked() then
				FreeUIOptionsGlobal[realm][name] = true
			else
				FreeUIOptionsGlobal[realm][name] = false
			end
			changeProfile()
			ReloadUI()
		end,
		OnCancel = function()
			if FOP.profile:GetChecked() then
				FOP.profile:SetChecked(false)
			else
				FOP.profile:SetChecked(true)
			end
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
		preferredIndex = 5,
	}

	StaticPopupDialogs['FREEUI_RELOAD'] = {
		text = ns.localization.reloadCheck,
		button1 = APPLY,
		button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
		OnAccept = function()
			ReloadUI()
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = true,
		preferredIndex = 5,
	}

	FOP.profile:SetChecked(FreeUIOptionsGlobal[realm][name])
	FOP.profile:SetScript("OnClick", function()
		StaticPopup_Show("FREEUI_PROFILE")
	end)

	FOP.installButton:SetScript('OnClick', function()
		F:GetModule('Install'):HelloWorld()
		FOP:Hide()
	end)

	FOP.resetButton:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_RESET')
	end)

	FOP.okayButton:SetScript('OnClick', function()
		options:Hide()
		if ns.needReload then
			StaticPopup_Show('FREEUI_RELOAD')
		end
	end)

	F.CreateMF(FOP)
	F.CreateBD(FOP)
	F.CreateSD(FOP)
	F.ReskinClose(FOP.close)

	F.CreateBD(FOP.creditsFrame)
	F.CreateSD(FOP.creditsFrame)
	F.ReskinClose(FOP.creditsFrame.close)
	FOP.creditsFrame.title = F.CreateFS(FOP.creditsFrame, {C.AssetsPath..'font\\supereffective.ttf', 24, 'OUTLINEMONOCHROME'}, 'Free'..C.MyColor..'UI|r', nil, true, 'TOP', 0, -4)
	FOP.creditsFrame.author = F.CreateFS(FOP.creditsFrame, 'pixel', L.author, nil, true, 'TOP', 0, -40)
	FOP.creditsFrame.authorSubText = F.CreateFS(FOP.creditsFrame, 'pixel', L.authorSubText, nil, true, 'TOP', 0, -52)
	FOP.creditsFrame.credits = F.CreateFS(FOP.creditsFrame, {C.font.normal, 20}, L.credits, 'yellow', true, 'TOP', 0, -80)
	
	FOP.creditsFrame.haleth = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.haleth, nil, true, 'TOP', 0, -110)
	FOP.creditsFrame.halethSubText = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.halethSubText, 'grey', true, 'TOP', 0, -130)

	FOP.creditsFrame.alza = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.alza, nil, true, 'TOP', 0, -150)
	FOP.creditsFrame.alzaSubText = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.alzaSubText, 'grey', true, 'TOP', 0, -170)

	FOP.creditsFrame.haste = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.haste, nil, true, 'TOP', 0, -190)
	FOP.creditsFrame.hasteSubText = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.hasteSubText, 'grey', true, 'TOP', 0, -210)
	FOP.creditsFrame.tukz = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.tukz, nil, true, 'TOP', 0, -230)
	FOP.creditsFrame.tukzSubText = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.tukzSubText, 'grey', true, 'TOP', 0, -250)
	FOP.creditsFrame.zork = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.zork, nil, true, 'TOP', 0, -270)
	FOP.creditsFrame.zorkSubText = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.zorkSubText, 'grey', true, 'TOP', 0, -290)

	FOP.creditsFrame.siweia = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.siweia, nil, true, 'TOP', 0, -310)
	FOP.creditsFrame.siweiaSubText = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.siweiaSubText, 'grey', true, 'TOP', 0, -330)

	FOP.creditsFrame.others = F.CreateFS(FOP.creditsFrame, {C.font.normal, 16}, L.others, 'yellow', true, 'TOP', 0, -360)
	FOP.creditsFrame.othersSubText_1 = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.othersSubText_1, 'grey', true, 'TOP', 0, -380)
	FOP.creditsFrame.othersSubText_2 = F.CreateFS(FOP.creditsFrame, {C.font.normal, 12}, L.othersSubText_2, 'grey', true, 'TOP', 0, -400)

	F.ReskinCheck(FOP.profile)

	for _, panel in pairs(panels) do
		F.CreateBDFrame(panel)
		panel.Title:SetTextColor(r, g, b)
		panel.subText:SetTextColor(.8, .8, .8)
		panel.tab:SetBackdropColor(.03, .03, .03, .3)
		F.CreateBDFrame(panel.tab.Icon)
		F.Reskin(panel.tab)
		F.ReskinScroll(panel.ScrollBar)
	end

	setActiveTab(FOP.general.tab)

	for _, button in pairs(ns.buttons) do
		F.Reskin(button)
	end

	for _, box in pairs(checkboxes) do
		F.ReskinCheck(box, true)
	end

	for _, radio in pairs(radiobuttons) do
		F.ReskinRadio(radio)
	end

	for _, slider in pairs(sliders) do
		F.ReskinSlider(slider)
		F.ReskinInput(slider.textInput)
		F.SetFS(slider.textInput, 'pixel')
		slider.textInput.num:SetTextColor(r, g, b)
		F.SetFS(slider.lowText, 'pixel')
		F.SetFS(slider.highText, 'pixel')
	end

	for _, picker in pairs(colourpickers) do
		local bg = F.CreateBDFrame(picker)
		local value = C[picker.group][picker.option]
		bg:SetBackdropColor(unpack(value))
		picker.text:SetTextColor(unpack(value))
	end

	for _, dropdown in pairs(dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	local title = F.CreateFS(FOP, {C.AssetsPath..'font\\supereffective.ttf', 24, 'OUTLINEMONOCHROME'}, 'Free'..C.MyColor..'UI', nil, true, 'TOP', 0, -4)
	local description = F.CreateFS(FOP, 'pixel', 'configuration', 'grey', true, 'TOP', 0, -36)
	local version = F.CreateFS(FOP, 'pixel', C.GreyColor..'v|r'..C.GreyColor..C.Version, 'yellow', true)
	version:SetPoint('BOTTOMLEFT', title, 'BOTTOMRIGHT', 0, 3)
	version:SetAlpha(.3)
	
	local lineLeft = CreateFrame('Frame', nil, FOP)
	lineLeft:SetPoint('TOP', -50, -32)
	F.CreateGF(lineLeft, 100, 1, 'Horizontal', .7, .7, .7, 0, .7)
	lineLeft:SetFrameStrata('HIGH')

	local lineRight = CreateFrame('Frame', nil, FOP)
	lineRight:SetPoint('TOP', 50, -32)
	F.CreateGF(lineRight, 100, 1, 'Horizontal', .7, .7, .7, .7, 0)
	lineRight:SetFrameStrata('HIGH')

	displaySettings()


	-- Insert FreeUI GUI button into game menu
	local menuButton = CreateFrame('Button', 'GameMenuFrameNDui', GameMenuFrame, 'GameMenuButtonTemplate')
	menuButton:SetText('Free'..C.MyColor..'UI')
	menuButton:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)

	GameMenuFrame:HookScript('OnShow', function(self)
		GameMenuButtonLogout:SetPoint('TOP', menuButton, 'BOTTOM', 0, -14)
		self:SetHeight(self:GetHeight() + menuButton:GetHeight() + 15)
	end)

	menuButton:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		HideUIPanel(GameMenuFrame)
		FOP:Show()
	end)

	F.Reskin(menuButton)
end)

