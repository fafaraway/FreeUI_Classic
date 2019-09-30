local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')


local format, wipe, select, next, strsub = string.format, table.wipe, select, next, strsub
local TALENT, SHOW_SPEC_LEVEL, FEATURE_BECOMES_AVAILABLE_AT_LEVEL, NONE = TALENT, SHOW_SPEC_LEVEL, FEATURE_BECOMES_AVAILABLE_AT_LEVEL, NONE
local UnitLevel, ToggleTalentFrame, UnitCharacterPoints = UnitLevel, ToggleTalentFrame, UnitCharacterPoints
local talentString = '%s (%s)'
local unspendPoints = gsub(CHARACTER_POINTS1_COLON, HEADER_COLON, '')
local FreeUISpecButton = INFOBAR.FreeUISpecButton

local function addIcon(texture)
	texture = texture and '|T'..texture..':12:16:0:0:50:50:4:46:4:46|t' or ''
	return texture
end

function INFOBAR:Talent()
	if not C.infobar.enable then return end
	if not C.infobar.talent then return end

	FreeUISpecButton = INFOBAR:addButton('', INFOBAR.POSITION_RIGHT, 120, function(self, button)
		if UnitLevel('player') < SHOW_SPEC_LEVEL then
			UIErrorsFrame:AddMessage(C.InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_SPEC_LEVEL))
		else
			ToggleTalentFrame()
		end
	end)

	FreeUISpecButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUISpecButton:RegisterEvent('CHARACTER_POINTS_CHANGED')
	FreeUISpecButton:RegisterEvent('SPELLS_CHANGED')
	FreeUISpecButton:SetScript('OnEvent', function(self)
		local text = ''
		for i = 1, 5 do
			local name, _, pointsSpent = GetTalentTabInfo(i)
			if not name then break end
			text = text..'-'..pointsSpent
		end
		if text == '' then
			text = NONE
		else
			text = strsub(text, 2)
		end
		local points = UnitCharacterPoints('player')
		if points > 0 then
			text = format(talentString, text, points)
		end
		self.Text:SetText('Talent'..': '..C.MyColor..text)
	end)

	FreeUISpecButton:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -15)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENT, .9, .8, .6)
		GameTooltip:AddLine(' ')

		for i = 1, 5 do
			local name, _, pointsSpent = GetTalentTabInfo(i)
			if not name then break end
			GameTooltip:AddDoubleLine(name, pointsSpent, 1,1,1, 1,.8,0)
		end
		local points = UnitCharacterPoints('player')
		if points > 0 then
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(unspendPoints, points, .6,.8,1, 1,.8,0)
		end

		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.LeftButton..L['INFOBAR_OPEN_SPEC_PANEL']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	FreeUISpecButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end