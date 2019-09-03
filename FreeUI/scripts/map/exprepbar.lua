local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')


local format, pairs = string.format, pairs
local min, mod, floor = math.min, mod, math.floor
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local MAX_REPUTATION_REACTION = MAX_REPUTATION_REACTION
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local NUM_FACTIONS_DISPLAYED = NUM_FACTIONS_DISPLAYED
local REPUTATION_PROGRESS_FORMAT = REPUTATION_PROGRESS_FORMAT

local function UpdateBar(bar)
	local rest = bar.restBar
	if rest then rest:Hide() end

	if UnitLevel('player') < MAX_PLAYER_LEVEL then
		local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
		bar:SetStatusBarColor(79/250, 167/250, 74/250)
		bar:SetMinMaxValues(0, mxp)
		bar:SetValue(xp)
		bar:Show()
		if rxp then
			rest:SetMinMaxValues(0, mxp)
			rest:SetValue(min(xp + rxp, mxp))
			rest:Show()
		end
	else
		bar:Hide()
	end
end

local function UpdateTooltip(bar)
	GameTooltip:SetOwner(Minimap, 'ANCHOR_NONE')
	GameTooltip:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -4, -(C.map.miniMapSize/8*C.Mult)-6)
	
	if UnitLevel('player') < MAX_PLAYER_LEVEL then
		GameTooltip:AddLine(LEVEL..' '..UnitLevel('player'), C.r, C.g, C.b)

		local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
		GameTooltip:AddDoubleLine(XP, xp..' / '..mxp..' ('..floor(xp/mxp*100)..'%)', 1, 1, 1, 1, 1, 1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, '+'..rxp..' ('..floor(rxp/mxp*100)..'%)', 1, 1, 1, 1, 1, 1)
		end
	end

	if GetWatchedFactionInfo() then
		local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
		if standing == MAX_REPUTATION_REACTION then
			barMax = barMin + 1e3
			value = barMax - 1
		end
		local standingtext = GetText('FACTION_STANDING_LABEL'..standing, UnitSex('player'))
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(name, 62/250, 175/250, 227/250)
		
		GameTooltip:AddDoubleLine(standingtext, value - barMin..' / '..barMax - barMin..' ('..floor((value - barMin)/(barMax - barMin)*100)..'%)', 1, 1, 1, 1, 1, 1)
	end

	GameTooltip:Show()
end

function MAP:SetupScript(bar)
	bar.eventList = {
		'PLAYER_XP_UPDATE',
		'PLAYER_LEVEL_UP',
		'UPDATE_EXHAUSTION',
		'PLAYER_ENTERING_WORLD',
		'UPDATE_FACTION',
		'UNIT_INVENTORY_CHANGED',
		'ENABLE_XP_GAIN',
		'DISABLE_XP_GAIN',
	}
	for _, event in pairs(bar.eventList) do
		bar:RegisterEvent(event)
	end
	bar:SetScript('OnEvent', UpdateBar)
	bar:SetScript('OnEnter', UpdateTooltip)
	bar:SetScript('OnLeave', F.HideTooltip)
end

function MAP:ExpRepBar()
	if not C.map.expRepBar then return end 

	local bar = CreateFrame('StatusBar', nil, Minimap)
	bar:SetPoint('BOTTOM', Minimap, 'TOP', 0, -C.map.miniMapSize/8*C.Mult)
	bar:SetSize(C.map.miniMapSize*C.Mult, 3*C.Mult)
	bar:SetHitRectInsets(0, 0, -10, -10)
	F.CreateSB(bar)
	F.CreateBDFrame(bar)

	local rest = CreateFrame('StatusBar', nil, bar)
	rest:SetAllPoints()
	rest:SetStatusBarTexture(C.media.sbTex)
	rest:SetStatusBarColor(105/250, 194/250, 221/250, .9)
	rest:SetFrameLevel(bar:GetFrameLevel() - 1)
	bar.restBar = rest

	self:SetupScript(bar)
end


