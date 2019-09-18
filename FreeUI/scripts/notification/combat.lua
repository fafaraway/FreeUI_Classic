local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')


local random, getn = math.random, table.getn

local cfg = C.notification
local interruptSound = C.AssetsPath..'sound\\interrupt.ogg'
local dispelSound = C.AssetsPath..'sound\\buzz.ogg'
local lowHPSound = C.AssetsPath..'sound\\lowhealth.ogg'
local lowMPSound = C.AssetsPath..'sound\\lowmana.ogg'
local executeSound = C.AssetsPath..'sound\\forthehorde.mp3'
local flag = 0

local ExecuteClass = {
	['WARRIOR'] = true,
	['PALADIN'] = true,
}


local combatAlert = CreateFrame('Frame', 'CombatAlert', UIParent)
combatAlert:SetSize(418, 72)
combatAlert:SetPoint('TOP', 0, -320)
combatAlert:SetScale(1)
combatAlert:Hide()

combatAlert.bg = combatAlert:CreateTexture(nil, 'BACKGROUND')
combatAlert.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
combatAlert.bg:SetPoint('BOTTOM')
combatAlert.bg:SetSize(326, 103)
combatAlert.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
combatAlert.bg:SetVertexColor(0, 0, 0, .75)

combatAlert.lineTop = combatAlert:CreateTexture(nil, 'BACKGROUND')
combatAlert.lineTop:SetDrawLayer('BACKGROUND', 2)
combatAlert.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
combatAlert.lineTop:SetPoint('TOP')
combatAlert.lineTop:SetSize(418, 7)
combatAlert.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)


combatAlert.lineBottom = combatAlert:CreateTexture(nil, 'BACKGROUND')
combatAlert.lineBottom:SetDrawLayer('BACKGROUND', 2)
combatAlert.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
combatAlert.lineBottom:SetPoint('BOTTOM')
combatAlert.lineBottom:SetSize(418, 7)
combatAlert.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)


combatAlert.text = F.CreateFS(combatAlert, {C.font.damage, 40}, '', 'yellow', {0, 0, 0, 0, 2, -2}, 'BOTTOM', 0, 12)
combatAlert.text:SetJustifyH('CENTER')

local timer = 0
combatAlert:SetScript('OnShow', function(self)
	timer = 0
	self:SetScript('OnUpdate', function(self, elasped)
		timer = timer + elasped
		
		if timer < 0.5 then
			self:SetAlpha(timer * 2)
		end
		
		if timer > 1 and timer < 1.5 then
			self:SetAlpha(1 - (timer - 1) * 2)
		end
		
		if timer >= 1.5 then
			self:Hide()
		end
	end)
end)

local function showAlert(color, text)
	combatAlert.lineTop:SetVertexColor(color[1], color[2], color[3], color[4])
	combatAlert.lineBottom:SetVertexColor(color[1], color[2], color[3], color[4])
	CombatAlert.text:SetText(text)
	
	CombatAlert:Show()
end

local function showSpecialAlert(color, name, spell)
	combatAlert.lineTop:SetVertexColor(color[1], color[2], color[3], color[4])
	combatAlert.lineBottom:SetVertexColor(color[1], color[2], color[3], color[4])
	CombatAlert.text:SetText(L['NOTIFICATION_INTERRUPTED']..name..' '..spell)

	CombatAlert:Show()
end


function NOTIFICATION:CombatAlert()
	if cfg.enterCombat then
		combatAlert:RegisterEvent('PLAYER_REGEN_ENABLED')
		combatAlert:RegisterEvent('PLAYER_REGEN_DISABLED')
	end

	if cfg.emergency then
		combatAlert:RegisterEvent('UNIT_HEALTH')
		combatAlert:RegisterEvent('UNIT_MAXHEALTH')
		combatAlert:RegisterEvent('UNIT_POWER_UPDATE')
		combatAlert:RegisterEvent('UNIT_MAXPOWER')
	end

	if cfg.execute then
		combatAlert:RegisterEvent('UNIT_HEALTH')
		combatAlert:RegisterEvent('PLAYER_TARGET_CHANGED')
	end

	if cfg.interrupt or cfg.dispel then
		combatAlert:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end

	combatAlert:SetScript('OnEvent', function(self, event, unit, pType)
		local isPlayer = (unit == 'player')
		local isTarget = (unit == 'target')
		local isBoss = (UnitLevel('target') == -1)
		local isPlayerAlive = (not UnitIsDeadOrGhost('player'))
		local isTargetAlive = (not UnitIsDead('target'))
		local isLowHP = (UnitHealth('player') / UnitHealthMax('player')) < cfg.lowHPThreshold
		local isMana = (pType == 'MANA')
		local isLowMP = (UnitPower('player') / UnitPowerMax('player')) < cfg.lowMPThreshold
		local isExeHP = (UnitHealth('target') / UnitHealthMax('target')) < cfg.executeThreshold
		local isExeClass = (C.Class == 'WARRIOR' or C.Class == 'PALADIN')
		local canAttack = (UnitCanAttack('player', 'target'))

		if event == 'PLAYER_REGEN_DISABLED' then
			if not cfg.enterCombat then return end

			-- enter combat alert
			showAlert({233/255, 197/255, 93/255, .75}, C.InfoColor..L['NOTIFICATION_ENTER_COMBAT'])
			flag = 0
		end

		if event == 'PLAYER_REGEN_ENABLED' then
			if not cfg.enterCombat then return end

			-- leave combat alert
			showAlert({142/255, 218/255, 98/255, .75}, C.GreenColor..L['NOTIFICATION_LEAVE_COMBAT'])
			flag = 0
		end

		if event == 'PLAYER_TARGET_CHANGED' then
			-- reset alert flag when target changed
			flag = 0
		end

		if event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH' then
			-- low health alert
			if isPlayer and isPlayerAlive and isLowHP and flag == 0 then
				--[[if cfg.emergency and cfg.lowHPSound then
					PlaySoundFile(lowHPSound)
				end--]]

				showAlert({201/255, 10/255, 28/255, .75}, C.RedColor..L['NOTIFICATION_LOW_HEALTH'])
				flag = 1
			-- execute alert
			elseif isTarget and isBoss and canAttack and isTargetAlive and isExeClass and isExeHP and flag == 0 then
				if cfg.execute and cfg.executeSound then
					PlaySoundFile(executeSound)
				end

				showAlert({232/255, 97/255, 50/255, .75}, C.OrangeColor..L['NOTIFICATION_EXECUTE_PHASE'])
				flag = 1
			end
		end
		
		-- low mana alert
		if event == 'UNIT_POWER_UPDATE' or event == 'UNIT_MAXPOWER' then
			if isPlayer and isMana and isLowMP and flag == 0 then
				--[[if cfg.emergency and cfg.lowMPSound then
					PlaySoundFile(lowMPSound)
				end--]]

		  		showAlert({112/255, 191/255, 225/255, .75}, C.BlueColor..L['NOTIFICATION_LOW_MANA'])
				flag = 1
			end
		end
		

		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, destName, _, _, _, spellName, _, _, extraskillName = CombatLogGetCurrentEventInfo()
			local inInstance, instanceType = IsInInstance()

			if not sourceGUID or sourceName == destName then return end

			-- interrupt alert
			if cfg.interrupt and eventType == 'SPELL_INTERRUPT' and ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
				if cfg.interruptAlert then
					showSpecialAlert({165/255, 113/255, 223/255, .75}, destName, extraskillName)
				end

				if cfg.interruptAnnounce and inInstance and IsInGroup() then
					SendChatMessage(format(L['NOTIFICATION_INTERRUPTED']..destName..' '..extraskillName), say)
				end

				if cfg.interruptSound then
					PlaySoundFile(interruptSound, 'Master')
				end
			end

			-- dispel alert
			if cfg.dispel and eventType == 'SPELL_DISPEL' and ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
				if cfg.dispelAlert then
					showSpecialAlert({165/255, 113/255, 223/255, .75}, destName, extraskillName)
				end

				if cfg.dispelAnnounce and inInstance and IsInGroup() then
					SendChatMessage(format(L['NOTIFICATION_DISPELED']..destName..' '..extraskillName), say)
				end

				if cfg.dispelSound then
					PlaySoundFile(dispelSound, 'Master')
				end
			end
		end
	end)
end

function NOTIFICATION:Emergency()
	if not cfg.emergency then return end

	local f = CreateFrame('Frame')
	f:SetScript('OnEvent', function(self, event, unit, pType)
		if unit ~= 'player' then return end

		if event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH' then
			if (UnitHealth('player') / UnitHealthMax('player')) < cfg.lowHPThreshold then
				if not playedHp then
					playedHp = true
					PlaySoundFile(lowHPSound)
				end
			else
				playedHp = false
			end
		elseif (event == 'UNIT_POWER_UPDATE' or event == 'UNIT_MAXPOWER') and pType == 'MANA' then
			if (UnitPower('player') / UnitPowerMax('player')) < cfg.lowMPThreshold then
				if not playedMp then
					playedMp = true
					PlaySoundFile(lowMPSound)
				end
			else
				playedMp = false
			end
		end
	end)

	f:RegisterEvent('UNIT_HEALTH')
	f:RegisterEvent('UNIT_POWER_UPDATE')
	f:RegisterEvent('UNIT_MAXHEALTH')
	f:RegisterEvent('UNIT_MAXPOWER')
end