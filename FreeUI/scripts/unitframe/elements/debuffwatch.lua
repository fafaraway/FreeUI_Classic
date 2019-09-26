local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.unitframe


local DebuffsList = {
	['raid'] = {
		-- 奥妮克希亚的巢穴
		[18431] = 2,	-- 低沉咆哮
		-- 熔火之心
		[19703] = 2,	-- 奥西弗隆的诅咒
		[19408] = 2,	-- 恐慌
		[19716] = 2,	-- 基赫纳斯的诅咒
		[20277] = 2,	-- 拉格纳罗斯之拳
		[20475] = 6,	-- 活化炸弹
		[19695] = 6,	-- 地狱火
		[19659] = 2,	-- 点燃法力
		[19714] = 2,	-- 衰减魔法
		[19713] = 2,	-- 沙斯拉尔的诅咒
		-- 黑翼之巢
		[23023] = 2,	-- 燃烧
		[18173] = 2,	-- 燃烧刺激
		[24573] = 2,	-- 致死打击
		[23340] = 2,	-- 埃博诺克之影
		[23170] = 2,	-- 青铜
		[22687] = 2,	-- 暗影迷雾
		-- 祖尔格拉布
		[23860] = 2,	-- 神圣之火
		[22884] = 2,	-- 心灵尖啸
		[23918] = 2,	-- 音爆
		[24111] = 2,	-- 腐蚀之毒
		[21060] = 2,	-- 致盲
		[24328] = 2,	-- 堕落之血
		[16856] = 2,	-- 致死打击
		[24664] = 2,	-- 睡眠
		[17172] = 2,	-- 妖术
		[24306] = 2,	-- 金度的欺骗
		-- 安其拉废墟
		[25646] = 2,	-- 重伤
		[25471] = 2,	-- 攻击命令
		[96] = 2,		-- 肢解
		[25725] = 2,	-- 麻痹
		[25189] = 2,	-- 包围之风
		-- 安其拉神殿
		[785] = 2,		-- 充实
		[26580] = 2,	-- 恐惧
		[26050] = 2,	-- 酸性喷射
		[26180] = 2,	-- 翼龙钉刺
		[26053] = 2,	-- 致命剧毒
		[26613] = 2,	-- 重压打击
		[26029] = 2,	-- 黑暗闪耀
		-- 纳克萨玛斯
		[28732] = 2,	-- 黑女巫的拥抱
		[28622] = 2,	-- 蛛网裹体
		[28169] = 2,	-- 变异注射
		[29213] = 2,	-- 瘟疫使者的诅咒
		[28835] = 2,	-- 瑟里耶克印记
		[27808] = 2,	-- 冰霜冲击
		[28410] = 2,	-- 克尔苏加德的锁链
		[27819] = 2,	-- 自爆法力
	},
	['other'] = {
		-- 黑色深渊
		[246] = 2,		-- 减速术
		[6533] = 2,		-- 投网
		[8399] = 2,		-- 催眠
		-- 黑石深渊
		[13704] = 2,	-- 心灵尖啸
		-- 死矿
		[6304] = 2,		-- 拉克佐猛击
		[12097] = 2,	-- 刺穿护甲
		[7399] = 2,		-- 恐吓
		[6713] = 2,		-- 缴械
		[5213] = 2,		-- 熔铁之水
		[5208] = 2,		-- 毒性鱼叉
		-- 玛拉顿
		[7964] = 2,		-- 烟雾弹
		[21869] = 2,	-- 憎恨凝视
		-- 怒焰裂谷
		[744] = 2,		-- 毒药
		[18267] = 2,	-- 虚弱诅咒
		[20800] = 2,	-- 献祭
		-- 剃刀高地
		[12255] = 2,	-- 图特卡什的诅咒
		[12252] = 2,	-- 撒网
		[7645] = 2,		-- 统御意志
		[12946] = 2,	-- 腐烂恶臭
		-- 剃刀沼泽
		[14515] = 2,	-- 统御意志
		-- 血色修道院
		[9034] = 2,		-- 献祭
		[8814] = 2,		-- 烈焰尖刺
		[8988] = 2,		-- 沉默
		[9256] = 2,		-- 深度睡眠
		[8282] = 2,		-- 血之诅咒
		-- 影牙城堡
		[7068] = 2,		-- 暗影迷雾
		[7125] = 2,		-- 毒性唾液
		[7621] = 2,		-- 阿鲁高的诅咒
		-- 斯塔索姆
		[16798] = 2,	-- 催眠曲
		[12734] = 2,	-- 大地粉碎
		[17293] = 2,	-- 燃烧之风
		[17405] = 2,	-- 支配
		[16867] = 2,	-- 女妖诅咒
		[6016] = 2,		-- 刺穿护甲
		[16869] = 2,	-- 寒冰之墓
		[17307] = 2,	-- 击昏
		-- 沉默的神庙
		[12889] = 2,	-- 语言诅咒
		[12888] = 2,	-- 导致疯狂
		[12479] = 2,	-- 伽玛兰的妖术
		[12493] = 2,	-- 虚弱诅咒
		[12890] = 2,	-- 深度睡眠
		[24375] = 2,	-- 战争践踏
		-- 奥达曼
		[3356] = 2,		-- 烈焰鞭笞
		[6524] = 2,		-- 大地震颤
		-- 哀嚎洞穴
		[8040] = 2,		-- 德鲁伊的睡眠
		[8142] = 2,		-- 缠绕之藤
		[7967] = 2,		-- 纳拉雷克斯的梦魇
		[7399] = 2,		-- 恐吓
		[8150] = 2,		-- 雷霆震颤
		-- 祖尔法拉克
		[11836] = 2,	-- 冰霜凝固
		-- World Boss
		[21056] = 2,	-- 卡扎克的印记
		[24814] = 2,	-- 渗漏之雾
	},
}

local function buttonOnEnter(self)
	if not self.index then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:ClearLines()
	GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
	GameTooltip:Show()
end

function UNITFRAME:AddDebuffsWatch(self)
	if not cfg.debuffsWatch then return end

	local bu = CreateFrame('Frame', nil, self)
	bu:SetSize(22, 22)
	bu:SetPoint('CENTER')
	bu:SetFrameLevel(self:GetFrameLevel() + 10)
	bu.bg = F.CreateBDFrame(bu)
	bu.glow = F.CreateSD(bu.bg, .35)
	bu:Hide()

	bu.icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.icon:SetAllPoints()
	bu.icon:SetTexCoord(unpack(C.TexCoord))
	bu.count = F.CreateFS(bu, 'pixel', '', nil, true, 'TOPRIGHT', 2, 4)
	bu.timer = F.CreateFS(bu, 'pixel', '', nil, true, 'BOTTOMLEFT', 2, -4)

	if not cfg.aurasClickThrough then
		bu:SetScript('OnEnter', buttonOnEnter)
		bu:SetScript('OnLeave', F.HideTooltip)
	end

	bu.ShowDispellableDebuff = true
	bu.ShowDebuffBorder = true
	bu.FilterDispellableDebuff = true

	bu.Debuffs = DebuffsList

	self.RaidDebuffs = bu
end