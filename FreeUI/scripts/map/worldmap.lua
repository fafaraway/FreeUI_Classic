local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')


local select = select
local WorldMapFrame = WorldMapFrame
local CreateVector2D = CreateVector2D
local UnitPosition = UnitPosition
local C_Map_GetWorldPosFromMapPos = C_Map.GetWorldPosFromMapPos
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit

local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)
local currentMapID, playerCoords, cursorCoords, mapScale

function MAP:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition('player')
	if not tempVec2D.x then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {}
		mapRect[1] = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		mapRect[2] = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y/mapRect[2].y, tempVec2D.x/mapRect[2].x
end

function MAP:GetCursorCoords()
	if not WorldMapFrame.ScrollContainer:IsMouseOver() then return end

	local cursorX, cursorY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
	if cursorX < 0 or cursorX > 1 or cursorY < 0 or cursorY > 1 then return end
	return cursorX, cursorY
end

local function CoordsFormat(owner, none)
	local text = none and ': --, --' or ': %.1f, %.1f'
	return owner..C.InfoColor..text
end

function MAP:UpdateCoords(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.1 then
		local cursorX, cursorY = MAP:GetCursorCoords()
		if cursorX and cursorY then
			cursorCoords:SetFormattedText(CoordsFormat(L['MAP_CURSOR']), 100 * cursorX, 100 * cursorY)
		else
			cursorCoords:SetText(CoordsFormat(L['MAP_CURSOR'], true))
		end

		if not currentMapID then
			playerCoords:SetText(CoordsFormat(L['MAP_PLAYER'], true))
		else
			local x, y = MAP:GetPlayerMapPos(currentMapID)
			if not x or (x == 0 and y == 0) then
				playerCoords:SetText(CoordsFormat(L['MAP_PLAYER'], true))
			else
				playerCoords:SetFormattedText(CoordsFormat(L['MAP_PLAYER']), 100 * x, 100 * y)
			end
		end

		self.elapsed = 0
	end
end

function MAP:UpdateMapID()
	if self:GetMapID() == C_Map_GetBestMapForUnit('player') then
		currentMapID = self:GetMapID()
	else
		currentMapID = nil
	end
end

function MAP:WorldMapCoords()
	if not C.map.worldMapCoords then return end

	playerCoords = F.CreateFS(WorldMapFrame.BorderFrame, {C.font.normal, 11}, '', nil, nil, 'BOTTOMLEFT', 10, 10)
	cursorCoords = F.CreateFS(WorldMapFrame.BorderFrame, {C.font.normal, 11}, '', nil, nil, 'BOTTOMLEFT', 130, 10)

	hooksecurefunc(WorldMapFrame, 'OnFrameSizeChanged', MAP.UpdateMapID)
	hooksecurefunc(WorldMapFrame, 'OnMapChanged', MAP.UpdateMapID)

	local CoordsUpdater = CreateFrame('Frame', nil, WorldMapFrame.BorderFrame)
	CoordsUpdater:SetScript('OnUpdate', MAP.UpdateCoords)
end

function MAP:UpdateMapScale()
	if self.isMaximized and self:GetScale() ~= 1 then
		self:SetScale(1)
	elseif not self.isMaximized and self:GetScale() ~= C.map.worldMapScale then
		self:SetScale(C.map.worldMapScale)
	end
end

function MAP:UpdateMapAnchor()
	MAP.UpdateMapScale(self)
	if not self.isMaximized then F.RestoreMF(self) end
end

function MAP:WorldMapScale()
	-- Fix worldmap cursor when scaling
	WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
		local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
		local scale = WorldMapFrame:GetScale()
		return x / scale, y / scale
	end

	F.CreateMF(WorldMapFrame, nil, true)
	self.UpdateMapScale(WorldMapFrame)
	hooksecurefunc(WorldMapFrame, 'HandleUserActionToggleSelf', self.UpdateMapAnchor)
	WorldMapFrame.BlackoutFrame:Hide()
end

function MAP:WorldMapFader()
	if C.map.worldMapFader then
		PlayerMovementFrameFader.AddDeferredFrame(WorldMapFrame, .5, 1, 1)
	else
		PlayerMovementFrameFader.RemoveFrame(WorldMapFrame)
	end
end

function MAP:SetupWorldMap()
	self:WorldMapScale()
	self:WorldMapCoords()
	self:WorldMapReveal()
	self:WorldMapFader()
end