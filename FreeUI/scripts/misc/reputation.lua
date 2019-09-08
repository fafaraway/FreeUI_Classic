local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local NUM_FACTIONS_DISPLAYED = NUM_FACTIONS_DISPLAYED
local REPUTATION_PROGRESS_FORMAT = REPUTATION_PROGRESS_FORMAT
local NEW_REP_MSG = '%s (%d/%d): %+d '..REPUTATION
local rep = {}
local extraRep = {}

local function CreateMessage(msg)
	local info = ChatTypeInfo['COMBAT_FACTION_CHANGE'];
	for j = 1, 4, 1 do
		local chatfrm = getglobal('ChatFrame'..j);
		for k,v in pairs(chatfrm.messageTypeList) do
			if v == 'COMBAT_FACTION_CHANGE' then
				chatfrm:AddMessage(msg, info.r, info.g, info.b, info.id);
				break;
			end
		end
	end
end

local function RepUpdate()
	local numFactions = GetNumFactions(self);
	for i = 1, numFactions, 1 do
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i);
		local value = 0;
		if name and (not isHeader) or (hasRep) then
			if not rep[name] then
				rep[name] = barValue;
			end
			local change = barValue - rep[name];
			if (change > 0) then
				rep[name] = barValue
				local msg = string.format(NEW_REP_MSG, name, barValue - barMin, barMax - barMin, change)
				CreateMessage(msg)
			end
		end
	end
end


function MISC:Reputation()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_FACTION')
	f:SetScript('OnEvent', RepUpdate)

	ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', function()
		return true
	end)
end