local F, C = unpack(select(2, ...))
if not C.appearance.adjustFonts then return end


_G.STANDARD_TEXT_FONT = C.font.normal
_G.UNIT_NAME_FONT = C.font.header
_G.DAMAGE_TEXT_FONT = C.font.damage


local function RestyleFont(fontObj, fontPath, fontSize, fontFlag, fontColor, fontShadow)
	fontObj:SetFont(fontPath, fontSize, fontFlag and 'OUTLINE' or '')

	if fontColor then
		fontObj:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
	end

	if fontShadow then
		if type(fontShadow) == 'boolean' then
			fontObj:SetShadowColor(0, 0, 0, 1)
			fontObj:SetShadowOffset(1, -1)
		elseif type(fontShadow) == 'table' then
			fontObj:SetShadowColor(fontShadow[1], fontShadow[2], fontShadow[3], fontShadow[4])
			fontObj:SetShadowOffset(fontShadow[5], fontShadow[6])
		end
	end
end

-- Sourced from SharedFonts.xml
RestyleFont(SystemFont_Tiny2, 					C.font.normal, 11)
RestyleFont(SystemFont_Tiny, 					C.font.normal, 11)
RestyleFont(SystemFont_Shadow_Small, 			C.font.normal, 12, false, nil, true)
RestyleFont(Game10Font_o1, 						C.font.normal, 12, true)
RestyleFont(SystemFont_Small, 					C.font.normal, 11)
RestyleFont(SystemFont_Small2, 					C.font.normal, 12)
RestyleFont(SystemFont_Shadow_Small2, 			C.font.normal, 12, false, nil, true)
RestyleFont(SystemFont_Shadow_Med1_Outline, 	C.font.normal, 12, true)
RestyleFont(SystemFont_Shadow_Med1, 			C.font.normal, 12, false, nil, true)
RestyleFont(SystemFont_Med2, 					C.font.normal, 12)
RestyleFont(SystemFont_Med3, 					C.font.normal, 12)
RestyleFont(SystemFont_Shadow_Med3, 			C.font.normal, 12, false, nil, true)
RestyleFont(QuestFont_Large, 					C.font.header, 16, false, nil, true)
RestyleFont(QuestFont_Huge, 					C.font.header, 20, false, nil, true)
RestyleFont(SystemFont_Large, 					C.font.normal, 16)
RestyleFont(SystemFont_Shadow_Large_Outline, 	C.font.normal, 16, true)
RestyleFont(SystemFont_Shadow_Med2, 			C.font.normal, 16, false, nil, true)
RestyleFont(SystemFont_Shadow_Large, 			C.font.normal, 16, false, nil, true)
RestyleFont(SystemFont_Shadow_Large2, 			C.font.normal, 18, false, nil, true)
RestyleFont(SystemFont_Shadow_Huge1, 			C.font.header, 20, false, nil, true)
RestyleFont(SystemFont_Huge2, 					C.font.header, 24)
RestyleFont(SystemFont_Shadow_Huge2, 			C.font.header, 24, false, nil, true)
RestyleFont(SystemFont_Shadow_Huge3, 			C.font.header, 28, false, nil, true)
RestyleFont(SystemFont_Shadow_Outline_Huge3, 	C.font.header, 28, true)
RestyleFont(SystemFont_World, 					C.font.header, 60, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(SystemFont_World_ThickOutline, 		C.font.header, 60, true)

RestyleFont(SystemFont_Shadow_Outline_Huge2, 	C.font.header, 22, true, nil, true)
RestyleFont(SystemFont_Med1, 					C.font.normal, 12)
RestyleFont(SystemFont_WTF2, 					C.font.header, 64, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(SystemFont_Outline_WTF2, 			C.font.header, 60, true)
RestyleFont(System_IME, 						C.font.chat, 14, false, nil, true)

RestyleFont(NumberFont_Shadow_Tiny, 			C.font.chat, 11, true)
RestyleFont(NumberFont_Shadow_Small, 			C.font.chat, 12, true)
RestyleFont(NumberFont_Shadow_Med, 				C.font.chat, 13, true)
RestyleFont(ChatFontNormal, 					C.font.chat, 14)
RestyleFont(ChatFontSmall, 						C.font.chat, 12)
RestyleFont(Game30Font, 						C.font.header, 30, false, nil, {0, 0, 0, 1, 2, -2})

RestyleFont(GameTooltipHeader, 					C.font.normal, 14, false, nil, true)
RestyleFont(Tooltip_Med, 						C.font.normal, 12, false, nil, true)
RestyleFont(Tooltip_Small, 						C.font.normal, 12, false, nil, true)

-- Sourced from FontStyles.xml
RestyleFont(ZoneTextFont, 						C.font.header, 40, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(SubZoneTextFont, 					C.font.header, 40, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(WorldMapTextFont, 					C.font.header, 40, false, nil, {0, 0, 0, 1, 2, -2})

RestyleFont(ErrorFont, 							C.font.normal, 14, false, nil, {0, 0, 0, 1, 2, -2})

RestyleFont(RaidWarningFrame.slot1, 			C.font.normal, 20, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(RaidWarningFrame.slot2, 			C.font.normal, 20, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(RaidBossEmoteFrame.slot1, 			C.font.normal, 20, false, nil, {0, 0, 0, 1, 2, -2})
RestyleFont(RaidBossEmoteFrame.slot2, 			C.font.normal, 20, false, nil, {0, 0, 0, 1, 2, -2})

RestyleFont(FriendsFont_Normal, C.font.normal, 12)
RestyleFont(FriendsFont_Small, C.font.normal, 12)
RestyleFont(FriendsFont_Large, C.font.normal, 14)
RestyleFont(FriendsFont_UserText, C.font.normal, 12)

RestyleFont(QuestFont, C.font.normal, 14)
RestyleFont(QuestFontNormalSmall, C.font.normal, 14)

