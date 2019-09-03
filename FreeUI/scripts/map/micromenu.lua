local F, C = unpack(select(2, ...))
local MAP = F:GetModule('Map')


-- basee on ClickMenu by 10leej
local menuFrame = CreateFrame('Frame', 'MinimapRightClickMenu', UIParent, 'UIDropDownMenuTemplate')
local menuList = {
	{
		text = MAINMENU_BUTTON,
		isTitle = true,
		notCheckable = true,
	},
	{
		text = CHARACTER_BUTTON,
		icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
		func = function()
			securecall(ToggleCharacter, 'PaperDollFrame') 
		end,
		notCheckable = true,
	},
	{
		text = SPELLBOOK_ABILITIES_BUTTON,
		icon = 'Interface\\MINIMAP\\TRACKING\\Class',
		func = function() 
			--securecall(ToggleSpellBook, SpellBookFrame)
			if not SpellBookFrame:IsShown() then
				ShowUIPanel(SpellBookFrame)
			else
				HideUIPanel(SpellBookFrame)
			end
		end,
		notCheckable = true,
	},
	{
		text = TALENTS_BUTTON,
		icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
		func = function() 
			if (not PlayerTalentFrame) then
				LoadAddOn('Blizzard_TalentUI')
			end
			securecall(ToggleFrame, TalentFrame)
		end,
		notCheckable = true,
	},
	{
		text = SOCIAL_BUTTON,
		icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
		func = function() 
			securecall(ToggleFriendsFrame, 1) 
		end,
		notCheckable = true,
	},
	{
		text = BLIZZARD_STORE,
		icon = 'Interface\\MINIMAP\\TRACKING\\Auctioneer',
		func = function()
			if (not StoreFrame) then
				LoadAddOn('Blizzard_StoreUI')
			end
			securecall(ToggleStoreUI)
		end,
		notCheckable = true,
	},
	{
		text = '',
		isTitle = true,
		notCheckable = true,
	},
	{
		text = OTHER,
		isTitle = true,
		notCheckable = true,
	},
	{
		text = BACKPACK_TOOLTIP,
		icon = 'Interface\\MINIMAP\\TRACKING\\Banker',
		func = function()
			securecall(ToggleAllBags)
		end,
		notCheckable = true,
	},
	{
		text = GM_EMAIL_NAME,
		icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
		func = function() 
			securecall(ToggleHelpFrame) 
		end,
		notCheckable = true,
	},
	{
		text = BATTLEFIELD_MINIMAP,
		colorCode = '|cff999999',
		func = function()
			if not BattlefieldMapFrame then 
				LoadAddOn('Blizzard_BattlefieldMap') 
			end
			BattlefieldMapFrame:Toggle()
		end,
		notCheckable = true,
	},
}

local f = CreateFrame('Frame')
f:SetScript('OnEvent', function()
	ShowUIPanel(SpellBookFrame)
	HideUIPanel(SpellBookFrame)
end)
f:RegisterEvent('PLAYER_ENTERING_WORLD')

function MAP:MicroMenu()
	if not C.map.microMenu then return end
	
	Minimap:SetScript('OnMouseUp', function(self, button)
		if (button == 'RightButton') then
			EasyMenu(menuList, menuFrame, self, 0, 0, 'MENU', 3)
		else
			Minimap_OnClick(self)
		end
	end)
end

