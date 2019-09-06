local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:RegisterModule('Actionbar')


local next, tonumber = next, tonumber
local cfg = C.actionbar
local buttonSizeNormal = cfg.buttonSizeNormal*C.Mult
local buttonSizeSmall = cfg.buttonSizeSmall*C.Mult
local buttonSizeBig = cfg.buttonSizeBig*C.Mult
local padding = cfg.padding*C.Mult
local margin = cfg.margin*C.Mult
local numNormal = NUM_ACTIONBAR_BUTTONS
local numPet = NUM_PET_ACTION_SLOTS
local numStance = NUM_STANCE_SLOTS
local ACTION_BUTTON_SHOW_GRID_REASON_CVAR = ACTION_BUTTON_SHOW_GRID_REASON_CVAR

local buttonList = {}

function ACTIONBAR:CreateBar1()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar1', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
	frame:SetHeight(buttonSizeNormal + 2*padding)

	frame:SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 50)

	for i = 1, numNormal do
		local button = _G['ActionButton'..i]
		table.insert(buttonList, button)
		button:SetParent(frame)
		button:SetSize(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['ActionButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if cfg.layoutStyle == 3 then
		frame.frameVisibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.faderOnShow)
	else
		frame.frameVisibility = '[petbattle] hide; show'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	local actionPage = '[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1'
	local buttonName = 'ActionButton'
	for i, button in next, buttonList do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
		buttons = table.new()
		for i = 1, %d do
			table.insert(buttons, self:GetFrameRef('%s'..i))
		end
	]]):format(numNormal, buttonName))

	frame:SetAttribute('_onstate-page', [[
		for _, button in next, buttons do
			button:SetAttribute('actionpage', newstate)
		end
	]])
	RegisterStateDriver(frame, 'page', actionPage)
end

function ACTIONBAR:CreateBar2()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar2', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
	frame:SetHeight(buttonSizeNormal + 2*padding)
	frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)

	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)

	for i = 1, numNormal do
		local button = _G['MultiBarBottomLeftButton'..i]
		table.insert(buttonList, button)
		button:SetSize(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['MultiBarBottomLeftButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if cfg.layoutStyle == 3 then
		frame.frameVisibility = '[mod:shift] show; hide'
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.faderOnShow)
	else
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateBar3()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar3', UIParent, 'SecureHandlerStateTemplate')

	if cfg.layoutStyle == 2 then
		frame:SetWidth(18*buttonSizeNormal + 17*margin + 2*padding)
		frame:SetHeight(2*buttonSizeNormal + margin + 2*padding)
	else
		frame:SetWidth(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
		frame:SetHeight(buttonSizeNormal + 2*padding)
	end

	if cfg.layoutStyle == 2 then
		frame:SetPoint(unpack(cfg.bar1Pos))
	else
		local function positionBars()
			if InCombatLockdown() then return end
			local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
			if leftShown then
				frame:SetPoint('BOTTOM', 'FreeUI_ActionBar2', 'TOP', 0, 0)
			else
				frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
			end
		end
		hooksecurefunc('MultiActionBar_Update', positionBars)
	end

	MultiBarBottomRight:SetParent(frame)
	MultiBarBottomRight:EnableMouse(false)

	for i = 1, numNormal do
		local button = _G['MultiBarBottomRightButton'..i]
		table.insert(buttonList, button)
		button:SetSize(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', frame, padding, -padding)
		elseif (i == 4 and cfg.layoutStyle == 2) then
			local previous = _G['MultiBarBottomRightButton1']
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		elseif (i == 7 and cfg.layoutStyle == 2) then
			local previous = _G['MultiBarBottomRightButton3']
			button:SetPoint('LEFT', previous, 'RIGHT', 12*buttonSizeNormal+13*margin, 0)
		elseif (i == 10 and cfg.layoutStyle == 2) then
			local previous = _G['MultiBarBottomRightButton7']
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		else
			local previous = _G['MultiBarBottomRightButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if (cfg.bar3Mouseover and cfg.layoutStyle == 1) or cfg.layoutStyle == 3 then
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
	end
end

function ACTIONBAR:CreateBar4()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar4', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(buttonSizeSmall + 2*padding)
	frame:SetHeight(numNormal*buttonSizeSmall + (numNormal-1)*margin + 2*padding)
	frame:SetPoint('RIGHT', UIParent, 'RIGHT', -4, 0)

	MultiBarRight:SetParent(frame)
	MultiBarRight:EnableMouse(false)
	hooksecurefunc(MultiBarRight, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, numNormal do
		local button = _G['MultiBarRightButton'..i]
		table.insert(buttonList, button)
		button:SetSize(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarRightButton'..i-1]
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		end

	end

	if not cfg.sideBar then
		frame.frameVisibility = 'hide'
	else
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if cfg.sideBar and cfg.sideBarMouseover then
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
	end
end

function ACTIONBAR:CreateBar5()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar5', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(buttonSizeSmall + 2*padding)
	frame:SetHeight(numNormal*buttonSizeSmall + (numNormal-1)*margin + 2*padding)
	frame:SetPoint('RIGHT', 'FreeUI_ActionBar4', 'LEFT', 0, 0)

	MultiBarLeft:SetParent(frame)
	MultiBarLeft:EnableMouse(false)
	hooksecurefunc(MultiBarLeft, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, numNormal do
		local button = _G['MultiBarLeftButton'..i]
		table.insert(buttonList, button)
		button:SetSize(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarLeftButton'..i-1]
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		end
	end

	if not cfg.sideBar then
		frame.frameVisibility = 'hide'
	else
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if cfg.sideBar and cfg.sideBarMouseover then
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
	end
end

function ACTIONBAR:CreatePetbar()
	local frame = CreateFrame('Frame', 'FreeUI_PetActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(numPet*buttonSizeSmall + (numPet-1)*(margin+2) + 2*padding)
	frame:SetHeight(buttonSizeSmall + 2*padding)

	local function positionBars()
		if InCombatLockdown() then return end
		local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
		if leftShown and rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif leftShown and not rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar2', 'TOP', 0, 0)
		elseif rightShown and not leftShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		else
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
		end
	end
	hooksecurefunc('MultiActionBar_Update', positionBars)

	PetActionBarFrame:SetParent(frame)
	PetActionBarFrame:EnableMouse(false)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)

	for i = 1, numPet do
		local button = _G['PetActionButton'..i]
		table.insert(buttonList, button)
		button:SetSize(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('LEFT', frame, padding, 0)
		else
			local previous = _G['PetActionButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin+2, 0)
		end
		--cooldown fix
		local cd = _G['PetActionButton'..i..'Cooldown']
		cd:SetAllPoints(button)
	end

	if cfg.petBar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide'
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if cfg.petBar and cfg.petBarMouseover then
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
	end
end

function ACTIONBAR:CreateStancebar()
	local frame = CreateFrame('Frame', 'FreeUI_StanceBar', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(numStance*buttonSizeBig + (numStance-1)*margin + 2*padding)
	frame:SetHeight(buttonSizeBig + 2*padding)

	local function positionBars()
		if InCombatLockdown() then return end
		local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
		if leftShown and rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif leftShown and not rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar2', 'TOP', 0, 0)
		elseif rightShown and not leftShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif not rightShown and not leftShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
		end
	end
	hooksecurefunc('MultiActionBar_Update', positionBars)

	StanceBarFrame:SetParent(frame)
	StanceBarFrame:EnableMouse(false)
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)

	for i = 1, numStance do
		local button = _G['StanceButton'..i]
		table.insert(buttonList, button)
		button:SetSize(buttonSizeBig, buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['StanceButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if cfg.stanceBar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if cfg.stanceBar and cfg.stanceBarMouseover then
		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
	end
end

function ACTIONBAR:CreateLeaveVehicleBar()
	local padding, margin = 10, 5
	local num = 1

	local frame = CreateFrame('Frame', 'FreeUI_LeaveVehicleBar', UIParent)
	frame:SetWidth(num*24 + (num-1)*margin + 2*padding)
	frame:SetHeight(24 + 2*padding)
	frame.Pos = {'CENTER', UIParent, 'CENTER', 0, 100}

	local button = CreateFrame('Button', 'FreeUI_LeaveVehicleButton', frame)
	table.insert(buttonList, button)
	button:SetSize(24, 24)
	button:SetPoint('BOTTOMLEFT', frame, padding, padding)
	button:RegisterForClicks('AnyUp')
	F.PixelIcon(button, 'INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up', true)
	button.Icon:SetTexCoord(.216, .784, .216, .784)
	F.CreateSD(button)

	local function updateVisibility()
		if UnitOnTaxi('player') then
			button:Show()
		else
			button:Hide()
			button:UnlockHighlight()
		end
	end
	hooksecurefunc('MainMenuBarVehicleLeaveButton_Update', updateVisibility)

	local function onClick(self)
		if not UnitOnTaxi('player') then return end
		TaxiRequestEarlyLanding()
		self:LockHighlight()
	end
	button:SetScript('OnClick', onClick)
	button:SetScript('OnEnter', MainMenuBarVehicleLeaveButton_OnEnter)
	button:SetScript('OnLeave', F.HideTooltip)

	F.Mover(frame, L['ACTIONBAR_LEAVE_VEHICLE'], 'LeaveVehicle', frame.Pos)
end

local scripts = {
	'OnShow', 'OnHide', 'OnEvent', 'OnEnter', 'OnLeave', 'OnUpdate', 'OnValueChanged', 'OnClick', 'OnMouseDown', 'OnMouseUp',
}

local framesToHide = {
	MainMenuBar, OverrideActionBar,
}

local framesToDisable = {
	MainMenuBar,
	MicroButtonAndBagsBar, MainMenuBarArtFrame, StatusTrackingBarManager,
	ActionBarDownButton, ActionBarUpButton,
	OverrideActionBar,
	OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

function ACTIONBAR:RemoveBlizzArt()
	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(true)
	MainMenuBar.ignoreFramePositionManager = true
	MainMenuBar:SetAttribute('ignoreFramePositionManager', true)

	for _, frame in next, framesToHide do
		frame:SetParent(F.HiddenFrame)
	end

	for _, frame in next, framesToDisable do
		frame:UnregisterAllEvents()
		DisableAllScripts(frame)
	end

	-- Update button grid
	local function buttonShowGrid(name, showgrid)
		for i = 1, 12 do
			local button = _G[name..i]
			button:SetAttribute('showgrid', showgrid)
			ActionButton_ShowGrid(button, ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		end
	end
	local updateAfterCombat
	local function ToggleButtonGrid()
		if InCombatLockdown() then
			updateAfterCombat = true
			F:RegisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
		else
			local showgrid = tonumber(GetCVar('alwaysShowActionBars'))
			buttonShowGrid('ActionButton', showgrid)
			buttonShowGrid('MultiBarBottomRightButton', showgrid)
			if updateAfterCombat then
				F:UnregisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
				updateAfterCombat = false
			end
		end
	end
	hooksecurefunc('MultiActionBar_UpdateGridVisibility', ToggleButtonGrid)
end


function ACTIONBAR:OnLogin()
	if not cfg.enable then return end

	self:CreateBar1()
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreatePetbar()
	self:CreateStancebar()
	self:CreateLeaveVehicleBar()
	self:RemoveBlizzArt()
	self:RestyleButtons()
	self:HookActionEvents()
end