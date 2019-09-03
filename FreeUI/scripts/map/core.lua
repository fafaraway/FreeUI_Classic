local F, C = unpack(select(2, ...))
local MAP = F:RegisterModule('Map')


function MAP:OnLogin()
	self:SetupWorldMap()
	self:SetupMiniMap()
end