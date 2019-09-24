local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end

UNITFRAME.DebuffsTracking = {}

-- RAID DEBUFFS
UNITFRAME.DebuffsTracking["RaidDebuffs"] = {
	["type"] = "Whitelist",
	["spells"] = {
		-- 黑色深渊
		[246] = Defaults(), 		-- 减速术
		[6533] = Defaults(),		-- 投网
		[8399] = Defaults(),		-- 催眠
		-- 黑石深渊
		[13704] = Defaults(),		-- 心灵尖啸
		-- 死矿
		[6304] = Defaults(),		-- 拉克佐猛击
		[12097] = Defaults(),		-- 刺穿护甲
		[7399] = Defaults(),		-- 恐吓
		[6713] = Defaults(),		-- 缴械
		[5213] = Defaults(),		-- 熔铁之水
		[5208] = Defaults(),		-- 毒性鱼叉
		-- 玛拉顿
		[7964] = Defaults(),		-- 烟雾弹
		[21869] = Defaults(),		-- 憎恨凝视
		-- 怒焰裂谷
		[744] = Defaults(),			-- 毒药
		[18267] = Defaults(),		-- 虚弱诅咒
		[20800] = Defaults(),		-- 献祭
		-- 剃刀高地
		[12255] = Defaults(),		-- 图特卡什的诅咒
		[12252] = Defaults(),		-- 撒网
		[7645] = Defaults(),		-- 统御意志
		[12946] = Defaults(),		-- 腐烂恶臭
		-- 剃刀沼泽
		[14515] = Defaults(),		-- 统御意志
		-- 血色修道院
		[9034] = Defaults(),		-- 献祭
		[8814] = Defaults(),		-- 烈焰尖刺
		[8988] = Defaults(),		-- 沉默
		[9256] = Defaults(),		-- 深度睡眠
		[8282] = Defaults(),		-- 血之诅咒
		-- 影牙城堡
		[7068] = Defaults(),		-- 暗影迷雾
		[7125] = Defaults(),		-- 毒性唾液
		[7621] = Defaults(),		-- 阿鲁高的诅咒
		-- 斯塔索姆
		[16798] = Defaults(),		-- 催眠曲
		[12734] = Defaults(),		-- 大地粉碎
		[17293] = Defaults(),		-- 燃烧之风
		[17405] = Defaults(),		-- 支配
		[16867] = Defaults(),		-- 女妖诅咒
		[6016] = Defaults(),		-- 刺穿护甲
		[16869] = Defaults(),		-- 寒冰之墓
		[17307] = Defaults(),		-- 击昏
		-- 沉默的神庙
		[12889] = Defaults(),		-- 语言诅咒
		[12888] = Defaults(),		-- 导致疯狂
		[12479] = Defaults(),		-- 伽玛兰的妖术
		[12493] = Defaults(),		-- 虚弱诅咒
		[12890] = Defaults(),		-- 深度睡眠
		[24375] = Defaults(),		-- 战争践踏
		-- 奥达曼
		[3356] = Defaults(),		-- 烈焰鞭笞
		[6524] = Defaults(),		-- 大地震颤
		-- 哀嚎洞穴
		[8040] = Defaults(),		-- 德鲁伊的睡眠
		[8142] = Defaults(),		-- 缠绕之藤
		[7967] = Defaults(),		-- 纳拉雷克斯的梦魇
		[7399] = Defaults(),		-- 恐吓
		[8150] = Defaults(),		-- 雷霆震颤
		-- 祖尔法拉克
		[11836] = Defaults(),		-- 冰霜凝固
		-- World Boss
		[21056] = Defaults(),		-- 卡扎克的印记
		[24814] = Defaults(),		-- 渗漏之雾
		-- 奥妮克希亚的巢穴
		[18431] = Defaults(),		-- 低沉咆哮
		-- 熔火之心
		[19703] = Defaults(),		-- 奥西弗隆的诅咒
		[19408] = Defaults(),		-- 恐慌
		[19716] = Defaults(),		-- 基赫纳斯的诅咒
		[20277] = Defaults(),		-- 拉格纳罗斯之拳
		[20475] = Defaults(6),		-- 活化炸弹
		[19695] = Defaults(6),		-- 地狱火
		[19659] = Defaults(),		-- 点燃法力
		[19714] = Defaults(),		-- 衰减魔法
		[19713] = Defaults(),		-- 沙斯拉尔的诅咒
		-- 黑翼之巢
		[23023] = Defaults(),		-- 燃烧
		[18173] = Defaults(),		-- 燃烧刺激
		[24573] = Defaults(),		-- 致死打击
		[23340] = Defaults(),		-- 埃博诺克之影
		[23170] = Defaults(),		-- 青铜
		[22687] = Defaults(),		-- 暗影迷雾
		-- 祖尔格拉布
		[23860] = Defaults(),		-- 神圣之火
		[22884] = Defaults(),		-- 心灵尖啸
		[23918] = Defaults(),		-- 音爆
		[24111] = Defaults(),		-- 腐蚀之毒
		[21060] = Defaults(),		-- 致盲
		[24328] = Defaults(),		-- 堕落之血
		[16856] = Defaults(),		-- 致死打击
		[24664] = Defaults(),		-- 睡眠
		[17172] = Defaults(),		-- 妖术
		[24306] = Defaults(),		-- 金度的欺骗
		-- 安其拉废墟
		[25646] = Defaults(),		-- 重伤
		[25471] = Defaults(),		-- 攻击命令
		[96] = Defaults(),			-- 肢解
		[25725] = Defaults(),		-- 麻痹
		[25189] = Defaults(),		-- 包围之风
		-- 安其拉神殿
		[785] = Defaults(),			-- 充实
		[26580] = Defaults(),		-- 恐惧
		[26050] = Defaults(),		-- 酸性喷射
		[26180] = Defaults(),		-- 翼龙钉刺
		[26053] = Defaults(),		-- 致命剧毒
		[26613] = Defaults(),		-- 重压打击
		[26029] = Defaults(),		-- 黑暗闪耀
		-- 纳克萨玛斯
		[28732] = Defaults(),		-- 黑女巫的拥抱
		[28622] = Defaults(),		-- 蛛网裹体
		[28169] = Defaults(),		-- 变异注射
		[29213] = Defaults(),		-- 瘟疫使者的诅咒
		[28835] = Defaults(),		-- 瑟里耶克印记
		[27808] = Defaults(),		-- 冰霜冲击
		[28410] = Defaults(),		-- 克尔苏加德的锁链
		[27819] = Defaults(),		-- 自爆法力
	},
}

-- CC DEBUFFS
UNITFRAME.DebuffsTracking["CCDebuffs"] = {
	-- BROKEN: Need to build a new classic cc debuffs list
	-- EXAMPLE: See comment in spells table
	
	["type"] = "Whitelist",
	["spells"] = {
		-- [107079] = Defaults(4), -- Quaking Palm
	},
}

function UNITFRAME:UpdateRaidDebuffIndicator()
	local ORD = oUF_RaidDebuffs

	if (ORD) then
		local _, InstanceType = IsInInstance()

		if (ORD.RegisteredList ~= "RD") and (InstanceType == "party" or InstanceType == "raid") then
			ORD:ResetDebuffData()
			ORD:RegisterDebuffs(UNITFRAME.DebuffsTracking.RaidDebuffs.spells)
			ORD.RegisteredList = "RD"
		else
			if ORD.RegisteredList ~= "CC" then
				ORD:ResetDebuffData()
				ORD:RegisterDebuffs(UNITFRAME.DebuffsTracking.CCDebuffs.spells)
				ORD.RegisteredList = "CC"
			end
		end
	end
end

function UNITFRAME:AddDebuffWatch(self)
	if not cfg.debuffWatch then return end

	local RaidDebuffs = CreateFrame("Frame", nil, Health)
	RaidDebuffs:SetHeight(20)
	RaidDebuffs:SetWidth(20)
	RaidDebuffs:SetPoint("CENTER", self)
	RaidDebuffs:SetFrameLevel(self:GetFrameLevel() + 10)
	--RaidDebuffs:SetTemplate()
	--RaidDebuffs:CreateShadow()
	--RaidDebuffs.Shadow:SetFrameLevel(RaidDebuffs:GetFrameLevel() + 1)
	RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, "ARTWORK")
	RaidDebuffs.icon:SetTexCoord(.1, .9, .1, .9)
	--RaidDebuffs.icon:SetInside(RaidDebuffs)
	RaidDebuffs.cd = CreateFrame("Cooldown", nil, RaidDebuffs, "CooldownFrameTemplate")
	--RaidDebuffs.cd:SetInside(RaidDebuffs, 1, 0)
	RaidDebuffs.cd:SetReverse(true)
	RaidDebuffs.cd.noOCC = true
	RaidDebuffs.cd.noCooldownCount = true
	RaidDebuffs.cd:SetHideCountdownNumbers(true)
	RaidDebuffs.cd:SetAlpha(.7)
	RaidDebuffs.showDispellableDebuff = true
	RaidDebuffs.onlyMatchSpellID = true
	RaidDebuffs.FilterDispellableDebuff = true

	RaidDebuffs.count = F.CreateFS(RaidDebuffs, 'pixel', "", nil, true, "BOTTOMRIGHT", 6, -3)
	RaidDebuffs.timer = F.CreateFS(RaidDebuffs, 'pixel', "", nil, true, "CENTER", 1, 0)


	--RaidDebuffs.forceShow = true
	
	self.RaidDebuffs = RaidDebuffs
end