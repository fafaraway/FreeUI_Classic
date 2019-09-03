local F, C, L = unpack(select(2, ...))
local QUEST = F:RegisterModule('Quest')


local tinsert = tinsert
local GetFileIDFromPath = GetFileIDFromPath
local MAX_NUM_QUESTS = MAX_NUM_QUESTS
local ACTIVE_QUEST_ICON_FILEID = GetFileIDFromPath('Interface\\GossipFrame\\ActiveQuestIcon')
local AVAILABLE_QUEST_ICON_FILEID = GetFileIDFromPath('Interface\\GossipFrame\\AvailableQuestIcon')

local titleLines = {}
local questIconTextures = {}

for i = 1, MAX_NUM_QUESTS do
	local titleLine = _G['QuestTitleButton' .. i]
	tinsert(titleLines, titleLine)
	tinsert(questIconTextures, _G[titleLine:GetName() .. 'QuestIcon'])
end

QuestFrameGreetingPanel:HookScript('OnShow', function()
	for i, titleLine in ipairs(titleLines) do
		if (titleLine:IsVisible()) then
			local bulletPointTexture = questIconTextures[i]
			if (titleLine.isActive == 1) then
				bulletPointTexture:SetTexture(ACTIVE_QUEST_ICON_FILEID)
			else
				bulletPointTexture:SetTexture(AVAILABLE_QUEST_ICON_FILEID)
			end
		end
	end
end)


function QUEST:OnLogin()
	self:Tracker()
end