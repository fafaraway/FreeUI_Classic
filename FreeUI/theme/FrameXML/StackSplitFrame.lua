local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local StackSplitFrame = StackSplitFrame

	F.StripTextures(StackSplitFrame)
	F.SetBD(StackSplitFrame, 10, -10, -10, 10)
	F.Reskin(StackSplitOkayButton)
	F.Reskin(StackSplitCancelButton)
end)