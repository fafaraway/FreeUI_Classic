local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	-- Dressup Frame

	F.ReskinPortraitFrame(DressUpFrame)
	F.Reskin(DressUpFrameCancelButton)
	F.Reskin(DressUpFrameResetButton)

	DressUpModelFrameRotateLeftButton:Hide()
	DressUpModelFrameRotateRightButton:Hide()

	DressUpFrameBackgroundTopLeft:SetAlpha(0)
	DressUpFrameBackgroundTopRight:SetAlpha(0)
	DressUpFrameBackgroundBot:SetAlpha(0)



	F.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -6, -6)


	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)



	-- SideDressUp

	F.StripTextures(SideDressUpFrame, 0)
	select(5, SideDressUpModelCloseButton:GetRegions()):Hide()

	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", C.mult, 0)
	end)

	F.Reskin(SideDressUpModelResetButton)
	F.ReskinClose(SideDressUpModelCloseButton)
	F.SetBD(SideDressUpModel)
end)
