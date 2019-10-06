local F, C = unpack(select(2, ...))
local oUF = FreeUI.oUF

oUF.colors.disconnected = {
	0.1, 0.1, 0.1
}

oUF.colors.reaction = {
	[1] = {1.00, 0.32, 0.29}, 	-- Hated
	[2] = {1.00, 0.32, 0.29}, 	-- Hostile
	[3] = {1.00, 0.32, 0.29}, 	-- Unfriendly
	[4] = {1.00, 0.93, 0.47}, 	-- Neutral
	[5] = {0.34, 1.00, 0.36}, 	-- Friendly
	[6] = {0.34, 1.00, 0.36}, 	-- Honored
	[7] = {0.34, 1.00, 0.36}, 	-- Revered
	[8] = {0.34, 1.00, 0.36}, 	-- Exalted
}

oUF.colors.debuffType = {
	['Curse']   = {0.8, 0, 1},
	['Disease'] = {0.8, 0.6, 0},
	['Magic']   = {0, 0.8, 1},
	['Poison']  = {0, 0.8, 0},
	['none']    = {0, 0, 0}
}

oUF.colors.power = {
	['MANA']     = {.47, .83, .88},
	['RAGE']     = {.69, .31, .31},
	['ENERGY']   = {.88, .79, .25},
	['FOCUS']    = {.71, .43, .27},
	['AMMOSLOT'] = {.8, .6, 0},
}

oUF.colors.happiness = {
	[1] = {.69,.31,.31},
	[2] = {.65,.63,.35},
	[3] = {.33,.59,.33},
}

if C.unitframe.adjustClassColors then
	oUF.colors.class = {
		['DRUID']   = {.87, .41, .18},
		['HUNTER']  = {.15, .61, .21},
		['MAGE']    = {.38, .64, .87},
		['PALADIN'] = {1, .34, .46},
		['PRIEST']  = {.85, .85, .85},
		['ROGUE']   = {1, 0.83, 0.24},
		['SHAMAN']  = {.27, .28, .74},
		['WARLOCK'] = {.63, .51, .84},
		['WARRIOR'] = {.63, .56, .51},
	}
end

C['Colors'] = oUF.colors
