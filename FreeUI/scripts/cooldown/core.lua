local F, C = unpack(select(2, ...))
local COOLDOWN = F:RegisterModule('cooldown')


function COOLDOWN:OnLogin()
	self:CooldownEnhancement()
end