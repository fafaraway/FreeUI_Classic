local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	-- Dressup Frame

	F.ReskinPortraitFrame(DressUpFrame)
	F.StripTextures(DressUpFrame)
	
	function SetDressUpBackground()
		return
	end


	DressUpModelFrameRotateLeftButton:Hide()
	DressUpModelFrameRotateRightButton:Hide()
	DressUpFrameCancelButton:SetPoint("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -6, 6)
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -4, 0)
	F.Reskin(DressUpFrameCancelButton)
	F.Reskin(DressUpFrameResetButton)

	-- SideDressUp

	F.StripTextures(SideDressUpFrame, 0)
	select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", C.Mult, 0)
	end)
	F.Reskin(SideDressUpModelResetButton)
	F.ReskinClose(SideDressUpModelCloseButton)
	F.SetBD(SideDressUpModel)
end)
