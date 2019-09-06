local F, C = unpack(select(2, ...))
local LOOT = F:RegisterModule('loot')


function LOOT:OnLogin()
	COPPER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t'
	SILVER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t'
	GOLD_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t'


	--[[LOOT_ITEM_SELF = "+ %s";
	LOOT_ITEM_SELF_MULTIPLE = "+ %sx%d";
	LOOT_ITEM_BONUS_ROLL_SELF = "+ %s, Bonus";
	LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "+ %sx%d, Bonus";

	LOOT_ITEM_CREATED_SELF = "+ %s";
	LOOT_ITEM_CREATED_SELF_MULTIPLE = "+ %sx%d";

	LOOT_ITEM_PUSHED_SELF = "+ %s";
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %sx%d";
	LOOT_ITEM_REFUND = "Refunded - %s";
	LOOT_ITEM_REFUND_MULTIPLE = "Refunded - %sx%d";
	LOOT_ITEM_PUSHED_SELF = "+ %s";
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %sx%d";
	LOOT_CURRENCY_REFUND = "Refunded - %s x%d";
	LOOT_DISENCHANT_CREDIT = "%s Disenchanted - %s";

	LOOT_ITEM = "%s + %s";
	LOOT_ITEM_MULTIPLE = "%s + %sx%d";
	LOOT_ITEM_BONUS_ROLL = "%s, Bonus + %s";
	LOOT_ITEM_BONUS_ROLL_MULTIPLE = "%s, Bonus + %sx%d";
	LOOT_ITEM_PUSHED = "%s + %s";
	LOOT_ITEM_PUSHED_MULTIPLE = "%s + %sx%d";

	LOOT_MONEY = '|cff00a956+|r |cffffffff%s'
	YOU_LOOT_MONEY = '|cff00a956+|r |cffffffff%s'
	LOOT_MONEY_SPLIT = '|cff00a956+|r |cffffffff%s'
	YOU_LOOT_MONEY_GUILD = '|cff00a956+|r |cffffffff%s (%s Guild)'

	GUILD_NEWS_FORMAT4 = '+ %s : %s (Craft)'
	GUILD_NEWS_FORMAT8 = '+ %s : %s'

	CREATED_ITEM = '+ %s : %s (Craft)'
	CREATED_ITEM_MULTIPLE = '+ %s : %sx%d (Craft)'

	TRADESKILL_LOG_FIRSTPERSON = '+ %s : %s (Craft)'
	TRADESKILL_LOG_THIRDPERSON = '+ %s : %s (Craft)'--]]
end