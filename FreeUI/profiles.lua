local _, ns = ...
local F, C, L = unpack(ns)

--[[
	This file allows you to override any option in options.lua, or append to it.
	You can therefore simply copy and paste it every time you update the UI, and keep your settings, unless mentioned otherwise.

	To override an option in a table which uses key-value pairs, format it like this:
	C.inventory.enable = true
]]

local playerName = UnitName('player')
local playerClass = select(2, UnitClass('player'))
local playerRealm = GetRealmName()



-- Override fonts
--C.font.normal = 'Fonts\\normal.ttf'
--C.font.damage = 'Fonts\\damage.ttf'
--C.font.header = 'Fonts\\header.ttf'
--C.font.chat   = 'Fonts\\chat.ttf'













