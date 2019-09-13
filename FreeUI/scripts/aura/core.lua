local F, C = unpack(select(2, ...))
local AURA = F:RegisterModule('Aura')


function AURA:OnLogin()
	self:BuffFrame()
	self:BuffReminder()
end