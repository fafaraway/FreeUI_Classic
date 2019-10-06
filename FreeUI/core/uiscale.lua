local F, C = unpack(select(2, ...))


local function clipScale(scale)
	return tonumber(format('%.5f', scale))
end

local function GetPerfectScale()
	local scale = C.general.uiScale
	local bestScale = max(.4, min(1.15, 768 / C.ScreenHeight))
	local pixelScale = 768 / C.ScreenHeight

	if C.general.uiScaleAuto then
		if C.is4KRes then
			scale = clipScale(bestScale * 1.5)
		--elseif C.is2KRes then
		--	scale = clipScale(bestScale * 1.2)
		else
			scale = clipScale(bestScale)
		end
	end

	C.Mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	return scale
end
GetPerfectScale()

local isScaling = false
function F:SetupUIScale()
	if isScaling then return end
	isScaling = true

	local scale = GetPerfectScale()
	local parentScale = UIParent:GetScale()
	if scale ~= parentScale then
		UIParent:SetScale(scale)
	end

	C.general.uiScale = clipScale(scale)

	isScaling = false
end







--[[local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	print('C.Mult '..C.Mult)
	print('CVar uiScale '..GetCVar("uiScale"))
	print('UIParentScale '..UIParent:GetScale())
end)--]]