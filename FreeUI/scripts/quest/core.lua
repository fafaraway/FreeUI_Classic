local F, C = unpack(select(2, ...))
local QUEST, cfg = F:RegisterModule('Quest'), C.quest


local tinsert = tinsert
local wipe = wipe
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogTitle = GetQuestLogTitle
local IsQuestComplete = IsQuestComplete
local C_QuestLog = C_QuestLog
local GetFileIDFromPath = GetFileIDFromPath
local MAX_NUM_QUESTS = MAX_NUM_QUESTS
local ACTIVE_QUEST_ICON_FILEID = GetFileIDFromPath('Interface\\GossipFrame\\ActiveQuestIcon')
local AVAILABLE_QUEST_ICON_FILEID = GetFileIDFromPath('Interface\\GossipFrame\\AvailableQuestIcon')
local NUMGOSSIPBUTTONS = NUMGOSSIPBUTTONS
local QuestFrameGreetingPanel = QuestFrameGreetingPanel

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


local escapes = {
	['|c%x%x%x%x%x%x%x%x'] = '', -- color start
	['|r'] = '' -- color end
}
local function unescape(str)
	for k, v in pairs(escapes) do
		str = gsub(str, k, v)
	end
	return str
end

local completedActiveQuests = {}
local function getCompletedQuestsInLog()
	wipe(completedActiveQuests)
	local numEntries = GetNumQuestLogEntries()
	local questLogTitleText, isComplete, questId, _
	for i = 1, numEntries, 1 do
		_, _, _, _, _, isComplete, _, questId = GetQuestLogTitle(i)
		if (isComplete == 1 or IsQuestComplete(questId)) then
			questLogTitleText = C_QuestLog.GetQuestInfo(questId)
			completedActiveQuests[questLogTitleText] = true
		end
	end
	return completedActiveQuests
end

local function setDesaturation(maxLines, lineMap, iconMap, activePred)
	local completedQuests = getCompletedQuestsInLog()
	for i = 1, maxLines do
		local line = lineMap[i]
		local icon = iconMap[i]
		icon:SetDesaturated(nil)
		if (line:IsVisible() and activePred(line)) then
			local questName = unescape(line:GetText())
			if (not completedQuests[questName]) then
				icon:SetDesaturated(1)
			end
		end
	end
end

local function getLineAndIconMaps(maxLines, titleIdent, iconIdent)
	local lines = {}
	local icons = {}
	for i = 1, maxLines do
		local titleLine = _G[titleIdent .. i]
		tinsert(lines, titleLine)
		tinsert(icons, _G[titleLine:GetName() .. iconIdent])
	end
	return lines, icons
end

local questFrameTitleLines, questFrameIconTextures = getLineAndIconMaps(MAX_NUM_QUESTS, 'QuestTitleButton', 'QuestIcon')
QuestFrameGreetingPanel:HookScript('OnShow', function()
	setDesaturation(
		MAX_NUM_QUESTS,
		questFrameTitleLines,
		questFrameIconTextures,
		function(line)
			return line.isActive == 1
		end
	)
end)

local gossipFrameTitleLines, gossipFrameIconTextures = getLineAndIconMaps(NUMGOSSIPBUTTONS, 'GossipTitleButton', 'GossipIcon')
hooksecurefunc('GossipFrameUpdate', function()
	setDesaturation(
		NUMGOSSIPBUTTONS,
		gossipFrameTitleLines,
		gossipFrameIconTextures,
		function(line)
			return line.type == 'Active'
		end
	)
end)

function QUEST:QuestRewardHighlight()
	if not cfg.rewardHightlight then return end

	local f = CreateFrame('Frame')
	local highlightFunc

	local last = 0
	local startIndex = 1

	local maxPrice = 0
	local maxPriceIndex = 0

	local function onUpdate(self, elapsed)
		last = last + elapsed
		if last >= 0.05 then
			self:SetScript('OnUpdate', nil)
			last = 0

			if QuestInfoRewardsFrameQuestInfoItem1:IsVisible() then
				highlightFunc()
			end
		end
	end

	highlightFunc = function()
		local numChoices = GetNumQuestChoices()
		if numChoices < 2 then return end

		for i = startIndex, numChoices do
			local link = GetQuestItemLink('choice', i)
			if link then
				local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(link)

				if vendorPrice > maxPrice then
					maxPrice = vendorPrice
					maxPriceIndex = i
				end
			else
				startIndex = i
				f:SetScript('OnUpdate', onUpdate)
				return
			end
		end

		if maxPriceIndex > 0 then
			local infoItem = _G['QuestInfoRewardsFrameQuestInfoItem'..maxPriceIndex]

			QuestInfoItemHighlight:ClearAllPoints()
			QuestInfoItemHighlight:SetPoint('TOP', infoItem)
			QuestInfoItemHighlight:Show()

			infoItem.bg:SetBackdropColor(0.8, 0.8, 0.8, .25)
		end

		startIndex = 1
		maxPrice = 0
		maxPriceIndex = 0
	end

	f:SetScript('OnEvent', highlightFunc)
	f:RegisterEvent('QUEST_COMPLETE')
end


function QUEST:OnLogin()
	self:QuestTracker()
	self:QuestNotifier()
	self:QuestRewardHighlight()
end