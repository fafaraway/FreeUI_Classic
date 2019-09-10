local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Notification')

function module:Dispel()
	local dispelSound = C.AssetsPath..'sound\\buzz.ogg'
	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self)
		local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, destName, _, _, _, spellName, _, _, extraskillName = CombatLogGetCurrentEventInfo()
		if not sourceGUID or sourceName == destName then return end
		
		local inInstance, instanceType = IsInInstance()
		if ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
			if (eventType == 'SPELL_DISPEL') then
				if C.notification.dispel then
					PlaySoundFile(dispelSound, 'Master')
				end

				if C.notification.dispelAnnounce and inInstance and IsInGroup() then
					SendChatMessage(L['NOTIFICATION_DISPELED']..destName..' '..extraskillName, say)
				end
			elseif (eventType == 'SPELL_STOLEN') then
				if C.notification.dispel then
					PlaySoundFile(dispelSound, 'Master')
				end

				if C.notification.dispelAnnounce and inInstance and IsInGroup() then
					SendChatMessage(L['NOTIFICATION_STOLEN']..destName..' '..extraskillName, say)
				end
			end
		end
	end)
end