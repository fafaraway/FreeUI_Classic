local F, C = unpack(select(2, ...))


C.Class = select(2, UnitClass('player'))
C.Color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[C.Class]
C.Name = UnitName('player')
C.Level = UnitLevel('player')
C.Realm = GetRealmName()
C.Client = GetLocale()
C.Version = GetAddOnMetadata('FreeUI', 'Version')
C.Title = GetAddOnMetadata('FreeUI', 'Title')
C.Support = GetAddOnMetadata('FreeUI', 'X-Support')
C.wowBuild = select(2, GetBuildInfo()); C.wowBuild = tonumber(C.wowBuild)
C.isClassic = select(4, GetBuildInfo()) < 20000

if C.appearance.adjustClassColors then
	RAID_CLASS_COLORS['SHAMAN']['colorStr'] = 'ff4447bc'
	RAID_CLASS_COLORS['SHAMAN']['r'] = 0.27
	RAID_CLASS_COLORS['SHAMAN']['g'] = 0.28
	RAID_CLASS_COLORS['SHAMAN']['b'] = 0.74
	RAID_CLASS_COLORS['WARRIOR']['colorStr'] = 'ffa18e81'
	RAID_CLASS_COLORS['WARRIOR']['b'] = 0.51
	RAID_CLASS_COLORS['WARRIOR']['g'] = 0.56
	RAID_CLASS_COLORS['WARRIOR']['r'] = 0.63
	RAID_CLASS_COLORS['PALADIN']['colorStr'] = 'ffff5775'
	RAID_CLASS_COLORS['PALADIN']['b'] = 0.46
	RAID_CLASS_COLORS['PALADIN']['g'] = 0.34
	RAID_CLASS_COLORS['PALADIN']['r'] = 1
	RAID_CLASS_COLORS['MAGE']['colorStr'] = 'ff61a4df'
	RAID_CLASS_COLORS['MAGE']['b'] = 0.87
	RAID_CLASS_COLORS['MAGE']['g'] = 0.64
	RAID_CLASS_COLORS['MAGE']['r'] = 0.38
	RAID_CLASS_COLORS['PRIEST']['colorStr'] = 'ffd9d9d9'
	RAID_CLASS_COLORS['PRIEST']['b'] = 0.85
	RAID_CLASS_COLORS['PRIEST']['g'] = 0.85
	RAID_CLASS_COLORS['PRIEST']['r'] = 0.85
	RAID_CLASS_COLORS['WARLOCK']['colorStr'] = 'ffa07fd7'
	RAID_CLASS_COLORS['WARLOCK']['b'] = 0.84
	RAID_CLASS_COLORS['WARLOCK']['g'] = 0.51
	RAID_CLASS_COLORS['WARLOCK']['r'] = 0.63
	RAID_CLASS_COLORS['HUNTER']['colorStr'] = 'ff219c34'
	RAID_CLASS_COLORS['HUNTER']['b'] = 0.21
	RAID_CLASS_COLORS['HUNTER']['g'] = 0.61
	RAID_CLASS_COLORS['HUNTER']['r'] = 0.13
	RAID_CLASS_COLORS['DRUID']['colorStr'] = 'ffdf692f'
	RAID_CLASS_COLORS['DRUID']['b'] = 0.18
	RAID_CLASS_COLORS['DRUID']['g'] = 0.41
	RAID_CLASS_COLORS['DRUID']['r'] = 0.87
	RAID_CLASS_COLORS['ROGUE']['colorStr'] = 'ffffd33e'
	RAID_CLASS_COLORS['ROGUE']['b'] = 0.24
	RAID_CLASS_COLORS['ROGUE']['g'] = 0.83
	RAID_CLASS_COLORS['ROGUE']['r'] = 1
end

C.ClassColors = {}
C.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	C.ClassList[v] = k
end

local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class in pairs(colors) do
	C.ClassColors[class] = {}
	C.ClassColors[class].r = colors[class].r
	C.ClassColors[class].g = colors[class].g
	C.ClassColors[class].b = colors[class].b
	C.ClassColors[class].colorStr = colors[class].colorStr
end
C.r, C.g, C.b = C.ClassColors[C.Class].r, C.ClassColors[C.Class].g, C.ClassColors[C.Class].b

C.MyColor = format('|cff%02x%02x%02x', C.r*255, C.g*255, C.b*255)
C.InfoColor = '|cffe9c55d'
C.GreyColor = '|cff808080'
C.RedColor = '|cffc90a1c'
C.GreenColor = '|cff219c34'
C.BlueColor = '|cff70bfe1'
C.OrangeColor = '|cffe86132'
C.PurpleColor = '|cffa571df'

C.LineString = C.GreyColor..'---------------'
C.LeftButton = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t '
C.RightButton = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t '
C.MiddleButton = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t '
C.CopyTex = 'Interface\\Buttons\\UI-GuildButton-PublicNote-Up'
C.AssetsPath = 'interface\\addons\\FreeUI\\assets\\'
C.TexCoord = {.08, .92, .08, .92}


C.media = {
	['arrowUp']    = C.AssetsPath..'arrow-up-active',
	['arrowDown']  = C.AssetsPath..'arrow-down-active',
	['arrowLeft']  = C.AssetsPath..'arrow-left-active',
	['arrowRight'] = C.AssetsPath..'arrow-right-active',
	['gradient']   = C.AssetsPath..'gradient',
	['bdTex']      = 'Interface\\ChatFrame\\ChatFrameBackground',
	['pushed']     = C.AssetsPath..'pushed',
	['checked']    = C.AssetsPath..'checked',
	['glowTex']    = C.AssetsPath..'glowTex',
	['roleIcons']  = C.AssetsPath..'UI-LFG-ICON-ROLES',
	['sbTex']      = C.AssetsPath..'statusbar',
	['bgTex']	   = C.AssetsPath..'bgTex',
}


local dev = {'歸雁入胡天'}
local function isDeveloper()
	for _, name in pairs(dev) do
		if UnitName('player') == name then
			return true
		end
	end
end
C.isDeveloper = isDeveloper()

local function isCNClient()
	if GetLocale() == 'zhCN' or GetLocale() == 'zhTW' then
		return true
	end
end
C.isCNClient = isCNClient()


local normalFont, damageFont, headerFont, chatFont
if GetLocale() == 'zhCN' then
	normalFont = 'Fonts\\ARKai_T.ttf'
	damageFont = 'Fonts\\ARKai_C.ttf'
	headerFont = 'Fonts\\ARKai_T.ttf'
	chatFont   = 'Fonts\\ARKai_T.ttf'
elseif GetLocale() == 'zhTW' then
	normalFont = 'Fonts\\blei00d.ttf'
	damageFont = 'Fonts\\bKAI00M.ttf'
	headerFont = 'Fonts\\blei00d.ttf'
	chatFont   = 'Fonts\\blei00d.ttf'
elseif GetLocale() == 'koKR' then
	normalFont = 'Fonts\\2002.ttf'
	damageFont = 'Fonts\\K_Damage.ttf'
	headerFont = 'Fonts\\2002.ttf'
	chatFont   = 'Fonts\\2002.ttf'
elseif GetLocale() == 'ruRU' then
	normalFont = 'Fonts\\FRIZQT___CYR.ttf'
	damageFont = 'Fonts\\FRIZQT___CYR.ttf'
	headerFont = 'Fonts\\FRIZQT___CYR.ttf'
	chatFont   = 'Fonts\\FRIZQT___CYR.ttf'
else
	normalFont = C.AssetsPath..'font\\expresswaysb.ttf'
	damageFont = C.AssetsPath..'font\\PEPSI_pl.ttf'
	headerFont = C.AssetsPath..'font\\ExocetBlizzardMedium.ttf'
	chatFont   = C.AssetsPath..'font\\expresswaysb.ttf'
end

C.font = {
	['normal']  = normalFont,
	['damage']  = damageFont,
	['header']  = headerFont,
	['chat']    = chatFont,
	['pixel']   = C.AssetsPath..'font\\pixel.ttf',
}

if GetLocale() == 'ruRU' then
	C.font.pixel = C.AssetsPath..'font\\iFlash705.ttf'
end

C.NormalFont = {C.font.normal, 11, 'OUTLINE'}
C.PixelFont = {C.font.pixel, 8, 'OUTLINEMONOCHROME'}





