local F, C = unpack(select(2, ...))

if not IsAddOnLoaded("FreeUI_Options") then return end

local realm = GetRealmName()
local name = UnitName("player")

-- create the profile boolean
if not FreeUIOptionsGlobal then FreeUIOptionsGlobal = {} end
if FreeUIOptionsGlobal[realm] == nil then FreeUIOptionsGlobal[realm] = {} end
if FreeUIOptionsGlobal[realm][name] == nil then FreeUIOptionsGlobal[realm][name] = false end

-- create the main options table
if FreeUIOptions == nil then FreeUIOptions = {} end

-- determine which settings to use
local profile
if FreeUIOptionsGlobal[realm][name] == true then
	if FreeUIOptionsPerChar == nil then
		FreeUIOptionsPerChar = {}
	end
	profile = FreeUIOptionsPerChar
else
	profile = FreeUIOptions
end

-- apply or remove saved settings as needed
for group, options in pairs(profile) do
	if C[group] then
		for option, value in pairs(options) do
			if C[group][option] == nil or C[group][option] == value then
				-- remove saved vars if they do not exist in lua config anymore, or are the same as the lua config
				profile[group][option] = nil
			else
				C[group][option] = value
			end
		end
	else
		profile[group] = nil
	end
end

-- add global options variable
C.options = profile


--
local defaultSettings = {
	Classic = false,
	UIElementsAnchor = {},
	tempAnchor = {},
	clickCast = {},
	installComplete = false,
	inventory = {
		favouriteItems = {},
	},
	actionbar = {
		bindType = 1,
	},
}

local accountSettings = {
	totalGold = {},
	repairType = 0,
	autoSellJunk = true,
}

local function InitialSettings(source, target)
	for i, j in pairs(source) do
		if type(j) == 'table' then
			if target[i] == nil then target[i] = {} end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then target[i] = j end
		end
	end

	for i in pairs(target) do
		if source[i] == nil then target[i] = nil end
	end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, addon)
	if addon ~= 'FreeUI' then return end

	if not FreeUIConfig['Classic'] then
		FreeUIConfig = {}
		FreeUIConfig['Classic'] = true
	end

	InitialSettings(defaultSettings, FreeUIConfig)
	InitialSettings(accountSettings, FreeUIGlobalConfig)

	self:UnregisterAllEvents()
end)