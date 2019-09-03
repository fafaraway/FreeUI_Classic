local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')


local strmatch, strfind, strupper = string.match, string.find, string.upper
local select, pairs, ipairs, unpack = select, pairs, ipairs, unpack

local function NewMail()
	local mail = CreateFrame('Frame', 'FreeUIMailFrame', Minimap)
	mail:Hide()
	mail:RegisterEvent('UPDATE_PENDING_MAIL')
	mail:SetScript('OnEvent', function(self)
		if HasNewMail() then
			self:Show()
		else
			self:Hide()
		end
	end)

	MiniMapMailFrame:HookScript('OnMouseUp', function(self)
		self:Hide()
		mail:Hide()
	end)

	local mt = F.CreateFS(mail, 'pixel', '<New Mail>', 'yellow', true)
	mt:SetPoint('BOTTOM', Minimap, 0, (C.map.miniMapSize/8*C.Mult)+6)

	MiniMapMailFrame:SetAlpha(0)
	MiniMapMailFrame:SetSize(22, 10)
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('CENTER', mt)
end

local function ZoneText()
	ZoneTextFrame:SetFrameStrata('MEDIUM')
	SubZoneTextFrame:SetFrameStrata('MEDIUM')

	ZoneTextString:ClearAllPoints()
	ZoneTextString:SetPoint('CENTER', Minimap)
	ZoneTextString:SetWidth(230)
	SubZoneTextString:SetWidth(230)
	PVPInfoTextString:SetWidth(230)
	PVPArenaTextString:SetWidth(230)

	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint('TOP', Minimap, 0, -(C.map.miniMapSize/8+10))
	MinimapZoneTextButton:SetFrameStrata('HIGH')
	MinimapZoneTextButton:EnableMouse(false)
	MinimapZoneTextButton:SetAlpha(0)
	MinimapZoneText:SetPoint('CENTER', MinimapZoneTextButton)

	MinimapZoneText:SetShadowColor(0, 0, 0, 0)
	MinimapZoneText:SetJustifyH('CENTER')

	ZoneTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	SubZoneTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	PVPInfoTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	PVPArenaTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	MinimapZoneText:SetFont(C.font.normal, 16, 'OUTLINE')

	Minimap:HookScript('OnEnter', function()
		MinimapZoneTextButton:SetAlpha(1)
	end)

	Minimap:HookScript('OnLeave', function()
		MinimapZoneTextButton:SetAlpha(0)
	end)
end

local function WhoPings()
	if not C.map.whoPings then return end

	local f = CreateFrame('Frame', nil, Minimap)
	f:SetAllPoints()
	f.text = F.CreateFS(f, {C.font.normal, 14, 'OUTLINE'}, '', 'class', true, 'TOP', 0, -4)

	local anim = f:CreateAnimationGroup()
	anim:SetScript('OnPlay', function() f:SetAlpha(1) end)
	anim:SetScript('OnFinished', function() f:SetAlpha(0) end)
	anim.fader = anim:CreateAnimation('Alpha')
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing('OUT')
	anim.fader:SetStartDelay(3)

	F:RegisterEvent('MINIMAP_PING', function(_, unit)
		local class = select(2, UnitClass(unit))
		local r, g, b = F.ClassColor(class)
		local name = GetUnitName(unit)

		anim:Stop()
		f.text:SetText(name)
		f.text:SetTextColor(r, g, b)
		anim:Play()
	end)
end

function MAP:SetupMiniMap()
	local size = C.map.miniMapSize
	local pos = C.map.miniMapPosition
	function GetMinimapShape() return 'SQUARE' end
	
	MinimapCluster:EnableMouse(false)
	Minimap:SetSize(size*C.Mult, size*C.Mult)
	Minimap:SetMaskTexture(C.AssetsPath..'rectangle')
	Minimap:SetHitRectInsets(0, 0, (size/8)*C.Mult, (size/8)*C.Mult)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	Minimap:SetClampedToScreen(true)
	Minimap:ClearAllPoints()

	local mover = F.Mover(Minimap, L['MOVER_MINIMAP'], 'Minimap', {pos[1], pos[2], pos[3], pos[4], pos[5]-(size/8*C.Mult)}, Minimap:GetWidth(), Minimap:GetHeight())
	Minimap:SetPoint('TOPRIGHT', mover)
	Minimap.mover = mover

	BorderFrame = CreateFrame('Frame', nil, Minimap)
	BorderFrame:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 0, -(size/8*C.Mult))
	BorderFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 0, (size/8*C.Mult))
	BorderFrame:SetFrameLevel(Minimap:GetFrameLevel() - 1)
	local bg = F.CreateBDFrame(BorderFrame, 1)
	F.CreateSD(bg)

	-- Mousewheel Zoom
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript('OnMouseWheel', function(_, zoom)
		if zoom > 0 then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end)

	-- Hide Blizz
	local frames = {
		'MinimapBorderTop',
		'MinimapNorthTag',
		'MinimapBorder',
		'MinimapZoomOut',
		'MinimapZoomIn',
		'MiniMapWorldMapButton',
		'MiniMapMailBorder',
		'TimeManagerClockButton',
		'GameTimeFrame',
		'MinimapToggleButton',
	}

	for _, v in pairs(frames) do
		F.HideObject(_G[v])
	end

	NewMail()
	ZoneText()
	WhoPings()

	self:MicroMenu()
	self:ExpRepBar()
end