local F, C, L = unpack(select(2, ...))
local NOTIFICATION, cfg = F:GetModule('Notification'), C.notification


function NOTIFICATION:CombatAlert()
	if not cfg.combatAlert then return end

	local lowHPSound = C.AssetsPath..'sound\\lowhealth.ogg'
	local lowMPSound = C.AssetsPath..'sound\\lowmana.ogg'
	local interruptSound = C.AssetsPath..'sound\\interrupt.ogg'
	local dispelSound = C.AssetsPath..'sound\\buzz.ogg'
	local playedHp, playedMp

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
			
			if timer > 1 and timer < 2 then
				self:SetAlpha(1 - (timer - 1) * 2)
			end
			
			if timer >= 2 then
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

	if cfg.enterCombat then
		combatAlert:RegisterEvent('PLAYER_REGEN_ENABLED')
		combatAlert:RegisterEvent('PLAYER_REGEN_DISABLED')
	end

	if cfg.interruptAnnounce or cfg.interruptSound or cfg.dispelAnnounce or cfg.dispelSound then
		combatAlert:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end

	if cfg.lowHPSound or cfg.lowMPSound then
		combatAlert:RegisterEvent('UNIT_HEALTH')
		combatAlert:RegisterEvent('UNIT_POWER_UPDATE')
		combatAlert:RegisterEvent('UNIT_MAXHEALTH')
		combatAlert:RegisterEvent('UNIT_MAXPOWER')
	end

	combatAlert:SetScript('OnEvent', function(self, event, unit, pType)
		if not cfg.enterCombat then return end

		-- Enter combat
		if event == 'PLAYER_REGEN_DISABLED' then
			showAlert({232/255, 97/255, 50/255, 1}, C.OrangeColor..L['NOTIFICATION_ENTER_COMBAT'])
		end

		-- Leave combat
		if event == 'PLAYER_REGEN_ENABLED' then
			showAlert({233/255, 197/255, 93/255, 1}, C.InfoColor..L['NOTIFICATION_LEAVE_COMBAT'])
		end

		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, destName, _, _, _, spellName, _, _, extraskillName = CombatLogGetCurrentEventInfo()
			local inInstance, instanceType = IsInInstance()

			if not sourceGUID or sourceName == destName then return end

			-- Interrupt
			if eventType == 'SPELL_INTERRUPT' and ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
				if cfg.interruptAnnounce and inInstance and IsInGroup() then
					SendChatMessage(format(L['NOTIFICATION_INTERRUPTED']..destName..' '..extraskillName), say)
				end

				if cfg.interruptSound then
					PlaySoundFile(interruptSound, 'Master')
				end
			end

			-- Dispel
			if eventType == 'SPELL_DISPEL' and ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
				if cfg.dispelAnnounce and inInstance and IsInGroup() then
					SendChatMessage(format(L['NOTIFICATION_DISPELED']..destName..' '..extraskillName), say)
				end

				if cfg.dispelSound then
					PlaySoundFile(dispelSound, 'Master')
				end
			end
		end

		local isLowHP = (UnitHealth('player') / UnitHealthMax('player')) < cfg.lowHPThreshold
		local isMana = (pType == 'MANA')
		local isLowMP = (UnitPower('player') / UnitPowerMax('player')) < cfg.lowMPThreshold

		if unit ~= 'player' then return end

		if event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH' then
			if isLowHP and cfg.lowHPSound then
				if not playedHp then
					playedHp = true

					PlaySoundFile(lowHPSound)
				end
			else
				playedHp = false
			end
		elseif event == 'UNIT_POWER_UPDATE' or event == 'UNIT_MAXPOWER' then
			if isMana and isLowMP and cfg.lowMPSound then
				if not playedMp then
					playedMp = true

					PlaySoundFile(lowMPSound)
				end
			else
				playedMp = false
			end
		end
	end)
end
