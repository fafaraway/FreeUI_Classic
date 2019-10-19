local F, C, L = unpack(select(2, ...))
local QUEST, cfg = F:GetModule('Quest'), C.quest


-- Doubles the width of the quest log
function QUEST:WideQuestLog()
	-- Configure this as a double-wide frame to stop the UIParent trampling on it
	UIPanelWindows['QuestLogFrame'] = { area = 'override', pushable = 0, xoffset = -16, yoffset = 12, bottomClampOverride = 140+12, width = 724, height = 513, whileDead = 1 };

	-- Widen the window, note that this size includes some pad on the right hand side after the scrollbars
	QuestLogFrame:SetWidth(724);
	QuestLogFrame:SetHeight(513);

	-- Adjust quest log title text
	QuestLogTitleText:ClearAllPoints();
	QuestLogTitleText:SetPoint('TOP', QuestLogFrame, 'TOP', 0, -18);

	-- Relocate the detail frame over to the right, and stretch it to full height.
	QuestLogDetailScrollFrame:ClearAllPoints();
	QuestLogDetailScrollFrame:SetPoint('TOPLEFT', QuestLogListScrollFrame, 'TOPRIGHT', 41, 0);
	QuestLogDetailScrollFrame:SetHeight(362);

	-- Relocate the 'no active quests' text
	QuestLogNoQuestsText:ClearAllPoints();
	QuestLogNoQuestsText:SetPoint('TOP', QuestLogListScrollFrame, 0, -90);

	-- Expand the quest list to full height
	QuestLogListScrollFrame:SetHeight(362);

	-- Create the additional rows
	local oldQuestsDisplayed = QUESTS_DISPLAYED;
	QUESTS_DISPLAYED = QUESTS_DISPLAYED + 17;

	for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
		local button = CreateFrame('Button', 'QuestLogTitle' .. i, QuestLogFrame, 'QuestLogTitleButtonTemplate');
		button:SetID(i);
		button:Hide();
		button:ClearAllPoints();
		button:SetPoint('TOPLEFT', getglobal('QuestLogTitle' .. (i-1)), 'BOTTOMLEFT', 0, 1);
	end

	-- Tweak share quest button position
	QuestFramePushQuestButton:SetPoint('right', QuestFrameExitButton, 'LEFT', -4, 0)
end

-- Adds level badges to the quest log overview
local function ShowQuestLevel(self)
	local numEntries = GetNumQuestLogEntries()

	for i = 1, QUESTS_DISPLAYED, 1 do
		local questIndex = i + FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
		if questIndex <= numEntries then
			local questLogTitle = _G['QuestLogTitle'..i]
			local questTitleTag = _G['QuestLogTitle'..i..'Tag']
			local questLogTitleText, level, _, isHeader, _, isComplete = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText('['..level..'] '..questLogTitleText)
				if isComplete then
					questLogTitle.r = 1
					questLogTitle.g = .5
					questLogTitle.b = 1
					questTitleTag:SetTextColor(1, .5, 1)
				end
			end

			local questText = _G['QuestLogTitle'..i..'NormalText']
			local questCheck = _G['QuestLogTitle'..i..'Check']
			if questText then
				local width = questText:GetStringWidth()
				if width then
					if width <= 210 then
						questCheck:SetPoint('LEFT', questLogTitle, 'LEFT', width + 22, 0)
					else
						questCheck:SetPoint('LEFT', questLogTitle, 'LEFT', 210, 0)
					end
				end
			end

			local questNumGroupMates = _G['QuestLogTitle'..i..'GroupMates']
			if not questNumGroupMates.anchored then
				questNumGroupMates:SetPoint('LEFT')
				questNumGroupMates.anchored = true
			end
		end
	end
end

-- Restyle ClassicCodex buttons
function QUEST:RestyleClassicCodexButtons()
	if CodexQuestShow then
		CodexQuestShow:SetSize(60, 20)
		CodexQuestHide:SetSize(60, 20)
		CodexQuestHide:SetPoint('LEFT', CodexQuestShow, 'RIGHT', 6, 0)
		CodexQuestReset:SetSize(60, 20)
		CodexQuestReset:SetPoint('LEFT', CodexQuestHide, 'RIGHT', 6, 0)
		F.Reskin(CodexQuestShow)
		F.Reskin(CodexQuestHide)
		F.Reskin(CodexQuestReset)
	end
end


function QUEST:QuestLogEnhancement()
	if not cfg.logEnhancement then return end
	
	self:WideQuestLog()
	hooksecurefunc('QuestLog_Update', ShowQuestLevel)
	self:RestyleClassicCodexButtons()
end
