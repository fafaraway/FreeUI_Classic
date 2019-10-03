local F, C, L = unpack(select(2, ...))
local INSTALL = F:RegisterModule('Install')


local pairs, tonumber, wipe = pairs, tonumber, table.wipe
local min, max, floor = math.min, math.max, floor

local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local smoother = CreateFrame('Frame')
smoother:SetScript('OnUpdate', function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)

local function ForceDefaultSettings()
	SetCVar('autoLootDefault', 1)
	SetCVar('lootUnderMouse', 1)
	SetCVar('alwaysCompareItems', 0)
	SetCVar('autoSelfCast', 1)

	SetCVar('nameplateShowEnemies', 1)
	SetCVar('nameplateShowAll', 1)
	SetCVar('nameplateMotion', 1)
	SetCVar('nameplateSelectedScale', 1)
	SetCVar('nameplateLargerScale', 1)
	SetCVar('nameplateMinScale', 0.8)

	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('ActionButtonUseKeyDown', 1)
	SetActionBarToggles(1, 1, 1, 1)

	SetCVar('autoQuestWatch', 1)
	SetCVar('overrideArchive', 0)
	SetCVar('chatClassColorOverride', '0')
	
	SetCVar('screenshotQuality', 10)
	SetCVar('showTutorials', 0)

	if C.isMacClient then return end
	SetCVar('cameraYawMoveSpeed', 120)
	SetCVar('rawMouseEnable', 1)
end

local function ForceChatSettings()
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 50, 50)
	ChatFrame1:SetWidth(400)
	ChatFrame1:SetHeight(200)
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G['ChatFrame'..i]
		ChatFrame_RemoveMessageGroup(cf, 'CHANNEL')
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
end

local function ForceBWSettings()
end

local function ForceSkadaSettings()
end

function INSTALL:HelloWorld()
	local installFrame = CreateFrame('Frame', 'FreeUI_InstallFrame', UIParent)
	installFrame:SetSize(400, 300)
	installFrame:SetPoint('CENTER')
	installFrame:SetFrameStrata('HIGH')
	F.CreateBD(installFrame)
	F.CreateSD(installFrame)

	local titleText = F.CreateFS(installFrame, {C.AssetsPath..'font\\supereffective.ttf', 24, 'OUTLINEMONOCHROME'}, 'Free'..C.MyColor..'UI', nil, true, 'TOP', 0, -4)
	local descriptionText = F.CreateFS(installFrame, 'pixel', 'installation', 'grey', true, 'TOP', 0, -36)
	local versionText = F.CreateFS(installFrame, 'pixel', C.GreyColor..'v|r'..C.GreyColor..C.Version, 'yellow', true, 'BOTTOM', 0, 4)
	versionText:SetAlpha(.3)

	local lineLeft = CreateFrame('Frame', nil, installFrame)
	lineLeft:SetPoint('TOP', -50, -32)
	F.CreateGF(lineLeft, 100, 1, 'Horizontal', .7, .7, .7, 0, .7)
	lineLeft:SetFrameStrata('HIGH')

	local lineRight = CreateFrame('Frame', nil, installFrame)
	lineRight:SetPoint('TOP', 50, -32)
	F.CreateGF(lineRight, 100, 1, 'Horizontal', .7, .7, .7, .7, 0)
	lineRight:SetFrameStrata('HIGH')

	local headerText = F.CreateFS(installFrame, {C.font.normal, 18}, nil, 'yellow', true, 'TOPLEFT', 20, -70)
	local bodyText = F.CreateFS(installFrame, {C.font.normal, 13}, nil, nil, true, 'TOPLEFT', 20, -100)
	bodyText:SetJustifyH('LEFT')
	bodyText:SetWordWrap(true)
	bodyText:SetWidth(installFrame:GetWidth()-40)

	local sb = CreateFrame('StatusBar', nil, installFrame)
	sb:SetPoint('BOTTOM', installFrame, 'BOTTOM', 0, 60)
	sb:SetSize(320, 20)
	sb:SetStatusBarTexture(C.media.sbTex)
	sb:Hide()
	SmoothBar(sb)
	sb.bg = F.CreateBDFrame(sb)
	sb.glow = F.CreateSD(sb.bg)
	sb.glow:SetBackdropBorderColor(C.r, C.g, C.b, 1)

	local sbt = F.CreateFS(sb, 'pixel', '', nil, true, 'CENTER', 0, 0)

	local leftButton = CreateFrame('Button', 'FreeUI_Install_LeftButton', installFrame, 'UIPanelButtonTemplate')
	leftButton:SetPoint('BOTTOMLEFT', installFrame, 'BOTTOMLEFT', 40, 20)
	leftButton:SetSize(120, 26)
	F.Reskin(leftButton)

	local rightButton = CreateFrame('Button', 'FreeUI_Install_RightButton', installFrame, 'UIPanelButtonTemplate')
	rightButton:SetPoint('BOTTOMRIGHT', installFrame, 'BOTTOMRIGHT', -40, 20)
	rightButton:SetSize(120, 26)
	F.Reskin(rightButton)

	local closeButton = CreateFrame('Button', 'FreeUI_Install_CloseButton', installFrame, 'UIPanelCloseButton')
	closeButton:SetPoint('TOPRIGHT', installFrame, 'TOPRIGHT')
	closeButton:SetScript('OnClick', function()
		UIFrameFade(installFrame,{
			mode = 'OUT',
			timeToFade = 0.5,
			finishedFunc = function(installFrame) installFrame:SetAlpha(1); installFrame:Hide() end,
			finishedArg1 = installFrame,
		})
	end)
	F.ReskinClose(closeButton)


	local step5 = function()
		sb:SetValue(500)
		PlaySoundFile('Sound\\Spells\\LevelUp.wav')
		headerText:SetText(L['INSTALL_HEADER_FIFTH'])
		bodyText:SetText(L['INSTALL_BODY_FIFTH'])
		sbt:SetText('5/5')
		leftButton:Hide()
		rightButton:SetText(L['INSTALL_BUTTON_FINISH'])

		rightButton:SetScript('OnClick', function()
			FreeUIConfig['installComplete'] = true
			ReloadUI()
		end)
	end

	local step4 = function()
		sb:SetValue(400)
		headerText:SetText(L['INSTALL_HEADER_FOURTH'])
		bodyText:SetText(L['INSTALL_BODY_FOURTH'])
		sbt:SetText('4/5')

		leftButton:SetScript('OnClick', step5)
		rightButton:SetScript('OnClick', function()
			ForceSkadaSettings()
			ForceBWSettings()
			step5()
		end)
	end

	local step3 = function()
		sb:SetValue(300)
		headerText:SetText(L['INSTALL_HEADER_THIRD'])
		bodyText:SetText(L['INSTALL_BODY_THIRD'])
		sbt:SetText('3/5')

		leftButton:SetScript('OnClick', step4)
		rightButton:SetScript('OnClick', function()
			ForceChatSettings()
			step4()
		end)
	end

	local step2 = function()
		sb:SetValue(200)
		headerText:SetText(L['INSTALL_HEADER_SECOND'])
		bodyText:SetText(L['INSTALL_BODY_SECOND'])
		sbt:SetText('2/5')

		leftButton:SetScript('OnClick', step3)
		rightButton:SetScript('OnClick', function()
			F.SetupUIScale()
			step3()
		end)
	end

	local step1 = function()
		sb:SetMinMaxValues(0, 500)
		sb:Show()
		sb:SetValue(0)
		sb:SetValue(100)
		sb:SetStatusBarColor(C.r, C.g, C.b)
		headerText:SetText(L['INSTALL_HEADER_FIRST'])
		bodyText:SetText(L['INSTALL_BODY_FIRST'])
		sbt:SetText('1/5')

		leftButton:Show()
		leftButton:SetText(L['INSTALL_BUTTON_SKIP'])
		rightButton:SetText(L['INSTALL_BUTTON_CONTINUE'])

		leftButton:SetScript('OnClick', step2)
		rightButton:SetScript('OnClick', function()
			ForceDefaultSettings()
			step2()
		end)
	end


	local tut4 = function()
		sb:SetValue(600)
		headerText:SetText('4. Finished')
		bodyText:SetText('WIP')

		sbt:SetText('4/4')

		leftButton:Show()

		leftButton:SetText('Close')
		rightButton:SetText('Install')

		leftButton:SetScript('OnClick', function()
			UIFrameFade(installFrame,{
				mode = 'OUT',
				timeToFade = 0.5,
				finishedFunc = function(installFrame) installFrame:Hide() end,
				finishedArg1 = installFrame,
			})
		end)
		rightButton:SetScript('OnClick', step1)
	end

	local tut3 = function()
		sb:SetValue(300)
		headerText:SetText('3. Features')
		bodyText:SetText('WIP')

		sbt:SetText('3/4')

		rightButton:SetScript('OnClick', tut4)
	end

	local tut2 = function()
		sb:SetValue(200)
		headerText:SetText('2. Unit frames')
		bodyText:SetText('WIP')

		sbt:SetText('2/4')

		rightButton:SetScript('OnClick', tut3)
	end

	local tut1 = function()
		sb:SetMinMaxValues(0, 600)
		sb:Show()
		sb:SetValue(100)
		sb:GetStatusBarTexture():SetGradient('VERTICAL', C.r, C.g, C.b, C.r, C.g, C.b)
		headerText:SetText('1. Essentials')
		bodyText:SetText('WIP')

		sbt:SetText('1/4')

		leftButton:Hide()

		rightButton:SetText('Next')

		rightButton:SetScript('OnClick', tut2)
	end


	headerText:SetText(L['INSTALL_HEADER_HELLO'])
	bodyText:SetText(L['INSTALL_BODY_WELCOME'])

	leftButton:SetText(L['INSTALL_BUTTON_TUTORIAL'])
	rightButton:SetText(L['INSTALL_BUTTON_INSTALL'])

	leftButton:SetScript('OnClick', tut1)
	--leftButton:Disable()
	rightButton:SetScript('OnClick', step1)
end
	

function INSTALL:OnLogin()
	print('Free'..C.MyColor..'UI|r '..C.GreyColor..'Classic')
	print('Version: '..C.InfoColor..C.Version)
	print(C.RedColor..L['UIHELP'])

	if FreeUIConfig['installComplete'] ~= true then
		self:HelloWorld()
	else
		if C.general.uiScaleAuto then
			F.HideOption(Advanced_UseUIScale)
			F.HideOption(Advanced_UIScaleSlider)
		end
		
		F.SetupUIScale()
	end

	F:RegisterEvent('UI_SCALE_CHANGED', F.SetupUIScale)

	--print('cvar_useUiScale - '.._G.GetCVar('useUiScale'))
	--print('cvar_uiScale - '.._G.GetCVar('uiscale'))
	--print('UIParent_Scale - '.._G.UIParent:GetScale())
	--print(C.general.uiScale)

	--print(C.Mult)
end


