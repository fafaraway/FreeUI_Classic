local _, ns = ...

if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then return end

local L = ns.localization

L.profile = "角色单独配置"
L.profileTooltip = "为当前角色使用单独的选项配置。"
L.reloadCheck = "|cffff2735是否重载界面来完成设置？|r"
L.needReload = "|cffff2735重载界面来应用改动。|r"
L.install = "安装"
L.reset = "重置选项"
L.resetCheck = "|cffff2735是否移除所有已保存的选项并重置为默认值？|r"
L.credits = "致谢"




L.font_stats_font = "字体"
L.font_stats_font_style = "描边"
L.font_stats_font_shadow = "阴影"



L.general = "综合"
L.general_subText = "这些选项控制大部分的通用设置。"
L.general_subCategory_basic = "基本设定"
L.general_mailButton = "邮件收取增强"
L.general_mailButton_tooltip = "在邮件界面添加一个按钮来一键收取所有邮件。"
L.general_alreadyKnown = "已知染色"
L.general_alreadyKnown_tooltip = "在商人/拍卖行界面给已经学会的配方/坐骑/宠物染色。"
L.general_enhancedMenu = "右键菜单增强"
L.general_enhancedMenu_tooltip = "目标框体的右键菜单添加复制名字和加入公会功能。"
L.general_helmCloak = "快速隐藏头盔披风"
L.general_helmCloak_tooltip = "在人物界面添加按钮来快速隐藏/显示头盔披风。"
L.general_marker = "快速标记"
L.general_marker_tooltip = "Alt+鼠标左键点击人物模型可以快速设置标记。"
L.general_PVPSound = "击杀音效"
L.general_PVPSound_tooltip = "为PVP行为添加类似DotA的击杀/连杀音效。"
L.general_subCategory_camera = "镜头视角"
L.general_cameraZoomSpeed = "视角缩放速度"
L.general_cameraZoomSpeed_tooltip = "视角调整速度，数值越大调整越快。"
L.general_subCategory_uiscale = "界面缩放"
L.general_uiScaleAuto = "强制界面缩放"
L.general_uiScaleAuto_tooltip = "自动为当前分辨率使用最合适的界面缩放值。"
L.general_uiScale = "自定义缩放"
L.general_autoDismount = "自动下马"
L.general_autoDismount_tooltip = "施法/攻击/使用物品时自动下马。"



L.appearance = "外观"
L.appearance_subText = "这些选项控制大部分与外观相关的设置。"
L.appearance_subCategory_basic = "基本设定"
L.appearance_themes = "全局主题"
L.appearance_themes_tooltip = "启用全局主题美化默认界面。"
L.appearance_backdropAlpha = "主题背景透明度"
L.appearance_backdropAlpha_tooltip = "调整背景透明度，数字越小透明度越高。"
L.appearance_vignette = "暗角效果"
L.appearance_vignette_tooltip = "在屏幕边缘添加暗角效果。"
L.appearance_vignetteAlpha = "暗角强度"
L.appearance_vignetteAlpha_tooltip = "调整暗角强度，数字越小透明度越高。"
L.appearance_shadow = "阴影边框"
L.appearance_shadow_tooltip = "界面元素添加外围阴影。"
L.appearance_gradient = "渐变风格"
L.appearance_gradient_tooltip = "按钮类元素使用渐变效果。"
L.appearance_subCategory_misc = "其他"
L.appearance_flashCursor = "鼠标闪光"
L.appearance_flashCursor_tooltip = "鼠标移动时添加一道闪光轨迹。"
L.appearance_subCategory_font = "字体相关"
L.appearance_fonts = "字体调整"
L.appearance_fonts_tooltip = "调整部分游戏界面的字体大小，禁用此项如果你觉得文字过小。"
L.appearance_subCategory_addons = "插件适配"
L.appearance_BigWigs = "BigWigs"
L.appearance_BigWigs_tooltip = "美化 BigWigs 的计时条风格。"
L.appearance_WeakAuras = "WeakAuras"
L.appearance_WeakAuras_tooltip = "美化 WeakAuras 的图标风格。"
L.appearance_Skada = "Skada"
L.appearance_Skada_tooltip = "美化 Skada 的外观。"
L.appearance_QuestLogEx = "QuestLog"
L.appearance_QuestLogEx_tooltip = "美化 QuestLogEx 之类的任务日志增强插件。"


L.notification = "通知提示"
L.notification_subText = "这些选项控制大部分与通知提示相关的设置。"
L.notification_subCategory_banner = "基本设定"
L.notification_enableBanner = "通知框"
L.notification_enableBanner_tooltip = "触发特定事件时在屏幕上方显示一个通知框。"
L.notification_playSounds = "声音"
L.notification_playSounds_tooltip = "通知框出现时播放声音提示。"
L.notification_checkMail = "新邮件"
L.notification_checkMail_tooltip = "收到新邮件时触发通知框。"
L.notification_checkBagsFull = "背包满了"
L.notification_checkBagsFull_tooltip = "背包满了触发通知框。"
L.notification_autoRepair = "自动修理"
L.notification_autoRepair_tooltip = "自动修理装备后触发通知框提示修理花费。"
L.notification_autoSellJunk = "自动出售垃圾"
L.notification_autoSellJunk_tooltip = "自动出售垃圾物品后触发通知框提示获得金币。"
L.notification_subCategory_combat = "战斗相关"
L.notification_enterCombat = "进入战斗"
L.notification_enterCombat_tooltip = "进入/离开战斗时显示提示。"
L.notification_interrupt = "打断"
L.notification_interrupt_tooltip = "打断。"
L.notification_interruptAlert = "提示"
L.notification_interruptAlert_tooltip = "成功打断时显示提示。"
L.notification_interruptSound = "声音"
L.notification_interruptSound_tooltip = "成功打断时播放声音提示。"
L.notification_interruptAnnounce = "通知"
L.notification_interruptAnnounce_tooltip = "成功打断时说话通知队友（只在副本中启用）。"
L.notification_dispel = "驱散"
L.notification_dispel_tooltip = "驱散。"
L.notification_dispelAlert = "提示"
L.notification_dispelAlert_tooltip = "成功驱散时显示提示。"
L.notification_dispelSound = "声音"
L.notification_dispelSound_tooltip = "成功驱散时播放声音提示。"
L.notification_dispelAnnounce = "通知"
L.notification_dispelAnnounce_tooltip = "成功驱散时说话通知队友（只在副本中启用）。"



L.notification_emergency = "紧急状态"
L.notification_emergency_tooltip = "紧急状态。"
L.notification_lowHPAlert = "低血量提示"
L.notification_lowHPAlert_tooltip = "低血量时显示提示。"
L.notification_lowHPSound = "低血量声音警告"
L.notification_lowHPSound_tooltip = "低血量时播放声音警告。"
L.notification_lowMPAlert = "低蓝量提示"
L.notification_lowMPAlert_tooltip = "低蓝量时显示提示。"
L.notification_lowMPSound = "低蓝量声音警告"
L.notification_lowMPSound_tooltip = "低蓝量时播放声音警告。"

L.notification_execute = "斩杀"
L.notification_execute_tooltip = "斩杀。"
L.notification_executeAlert = "斩杀提示"
L.notification_executeAlert_tooltip = "进入斩杀阶段时显示提示。"
L.notification_executeSound = "斩杀声音警告"
L.notification_executeSound_tooltip = "进入斩杀阶段时播放声音警告。"



L.notification_vitalSpells = "技能/事件"
L.notification_vitalSpells_tooltip = "通告一些重要的技能/事件（食物/大餐/传送门/修理机器人）。"
L.notification_resurrect = "战复"
L.notification_resurrect_tooltip = "通告战复相关信息。"
L.notification_sapped = "闷棍"
L.notification_sapped_tooltip = "被闷棍时通告队友。"




L.infobar = "信息条"
L.infobar_subText = "这些选项控制信息条相关的通用设置。"
L.infobar_subCategory_cores = "基本设定"
L.infobar_enable = "启用信息条"
L.infobar_enable_tooltip = "启用屏幕顶部的信息条。"
L.infobar_mouseover = "鼠标悬停时显示按钮"
L.infobar_mouseover_tooltip = "只在鼠标悬停时显示按钮。"
L.infobar_stats = "时间/帧数/延迟"
L.infobar_stats_tooltip = "显示时间/帧数/延迟等信息。\n左键打开插件加载面板，右键打开计时器。"
L.infobar_talent = "天赋"
L.infobar_talent_tooltip = "显示当前天赋选择。\n左键打开天赋面板。"
L.infobar_friends = "好友"
L.infobar_friends_tooltip = "显示好友在线信息。\n左键打开好友列表，右键添加好友。"
L.infobar_currencies = "金币"
L.infobar_currencies_tooltip = "显示金币状态以及相关统计。\n左键开启自动出售垃圾功能，右键重置金币统计。"
L.infobar_durability = "装备耐久"
L.infobar_durability_tooltip = "显示身上装备的耐久度信息。\n左键开启自动修理功能。"



L.actionbar = "动作条"
L.actionbar_subText = "这些选项控制大部分和动作条相关的设置。"
L.actionbar_subCategory_layout = "基本设定"
L.actionbar_enable = "启用动作条"
L.actionbar_enable_tooltip = "禁用该项如果你想要使用其他的动作条类插件。"
L.actionbar_layoutStyle = "动作条布局"
L.actionbar_layoutStyle1 = "默认布局 (3*12)"
L.actionbar_layoutStyle2 = "加长布局 (2*18)"
L.actionbar_layoutStyle3 = "极简模式 (默认隐藏动作条)"
L.actionbar_subCategory_extra = "额外动作条"
L.actionbar_sideBar = "侧边条"
L.actionbar_sideBar_tooltip = "显示侧边动作条，界面设置/动作条里的右边动作条"
L.actionbar_sideBarMouseover = "鼠标悬停渐显"
L.actionbar_petBar = "宠物条"
L.actionbar_petBar_tooltip = "显示宠物动作条。"
L.actionbar_petBarMouseover = "鼠标悬停渐显"
L.actionbar_stanceBar = "姿态条"
L.actionbar_stanceBar_tooltip = "显示姿态动作条。"
L.actionbar_stanceBarMouseover = "鼠标悬停渐显"
L.actionbar_bar3 = "Bar3"
L.actionbar_bar3_tooltip = "显示 bar3 \n界面设置/动作条里的右下方动作条。"
L.actionbar_bar3Mouseover = "鼠标悬停渐显"
L.actionbar_subCategory_feature = "杂项"
L.actionbar_hotKey = "显示快捷键"
L.actionbar_macroName = "显示宏名称"
L.actionbar_count = "显示物品计数"
L.actionbar_classColor = "按钮职业染色"
L.actionbar_subCategory_bind = "按键绑定"
L.actionbar_hoverBind = "快速按键绑定"
L.actionbar_hoverBind_tooltip = "输入 /hb 使用快速绑定快捷键功能，鼠标移到按钮上按下要绑定的快捷键。"



L.cooldown = "冷却计时"
L.cooldown_subText = "这些选项控制冷却计时相关的设置。"
L.cooldown_subCategory_basic = "基本设定"
L.cooldown_cdEnhanced = "冷却计时"
L.cooldown_cdEnhanced_tooltip = "显示技能冷却计时。"
L.cooldown_cdFontSize = "冷却计时字体大小"
L.cooldown_cdPulse = "冷却提示"
L.cooldown_cdPulse_tooltip = "当技能完成冷却后在屏幕中间显示技能图标提示。"


L.inventory = "背包"
L.inventory_subText = "这些选项控制大部分和背包相关的设置。"
L.inventory_subCategory_basic = "基本设定"
L.inventory_enable = "启用背包"
L.inventory_enable_tooltip = "启用背包模块，禁用该项如果你想要使用其他的背包类插件。"
L.inventory_itemLevel = "装备等级"
L.inventory_itemLevel_tooltip = "显示背包内装备的等级。"
L.inventory_newitemFlash = "新物品闪光"
L.inventory_newitemFlash_tooltip = "新获得的物品闪光。"
L.inventory_reverseSort = "反向整理"
L.inventory_reverseSort_tooltip = "物品优先整理到背包底部。"
L.inventory_subCategory_category = "物品分类"
L.inventory_useCategory = "启用物品分类"
L.inventory_useCategory_tooltip = "启用物品分类，不同种类的物品归纳到不同的背包。"
L.inventory_questItemFilter = "任务相关"
L.inventory_questItemFilter_tooltip = "任务相关的物品作为一个单独的分类来归纳。"
L.inventory_tradeGoodsFilter = "商业相关"
L.inventory_tradeGoodsFilter_tooltip = "商业相关的物品作为一个单独的分类来归纳。"
L.inventory_subCategory_size = "大小设定"
L.inventory_itemSlotSize = '背包格子大小'
L.inventory_bagColumns = '背包每行格子数量'
L.inventory_bankColumns = '银行每行格子数量'


L.loot = "拾取"
L.loot_subText = "这些选项控制大部分和拾取相关的设置。"
L.loot_subCategory_basic = "基本设定"
L.loot_fasterLoot = "快速拾取"
L.loot_fasterLoot_tooltip = "加快拾取速度。"



L.aura = "光环"
L.aura_subText = "这些选项控制大部分和光环相关的设置。"



L.quest = "任务"
L.quest_subText = "这些选项控制大部分和任务相关的设置。"
L.quest_subCategory_basic = "基本设定"

L.quest_questTracker = "任务追踪栏增强"
L.quest_questTracker_tooltip = "任务追踪栏增强。"

L.quest_quickQuest = "自动交接任务"
L.quest_quickQuest_tooltip = "自动交接任务。"

L.quest_notifier = "任务提示"
L.quest_notifier_tooltip = "任务提示。"
L.quest_progressNotify = "进度广播"
L.quest_progressNotify_tooltip = "组队时自动广播自己的任务进度状态。"
L.quest_completeRing = "完成提示"
L.quest_completeRing_tooltip = "任务完成时播放一个音效提示。"





L.chat = "聊天"
L.chat_subText = "这些选项控制大部分和聊天相关的设置。"
L.chat_subCategory_basic = "基本设定"
L.chat_enable = "启用聊天增强"
L.chat_enable_tooltip = "禁用该项如果你想要使用其他的聊天类插件。"
L.chat_lockPosition = "锁定聊天框位置"
L.chat_lockPosition_tooltip = "锁定聊天框的位置，禁用该项如果你想要自己移动聊天框的位置。"
L.chat_fontOutline = "字体描边"
L.chat_fontOutline_tooltip = "给聊天框的文字添加描边。"
L.chat_whisperAlert = "密语提醒"
L.chat_whisperAlert_tooltip = "当收到密语时触发声音提醒。"
L.chat_timeStamp = "时间戳"
L.chat_timeStamp_tooltip = "添加自定义的时间戳。"
L.chat_timeStampColor = "时间戳颜色"
L.chat_timeStampColor_tooltip = ""
L.chat_copyButton = "复制按钮"
L.chat_copyButton_tooltip = "在聊天框左下角添加一个小按钮。\n左键点击隐藏整个聊天框，右键点击复制聊天内容，中键点击加入/离开世界频道。"
L.chat_fading = "文字淡化"
L.chat_fading_tooltip = "如果聊天框一段时间没有收到新信息则旧信息会逐渐淡化消失。"
L.chat_filters = "内容过滤"
L.chat_filters_tooltip = "自动过滤重复或者无用的信息。"
L.chat_hideVoiceButtons = "隐藏语音按钮"
L.chat_hideVoiceButtons_tooltip = "隐藏游戏自带语音的按钮。"




L.map = "地图"
L.map_subText = "调整地图相关的功能。"
L.map_subCategory_worldMap = "世界地图"
L.map_worldMapCoords = "显示坐标"
L.map_worldMapCoords_tooltip = "在世界地图的左下方显示玩家当前位置坐标值和鼠标所在位置坐标值。"
L.map_worldMapReveal = "清除迷雾"
L.map_worldMapReveal_tooltip = "在世界地图上清除未探索区域的迷雾。"
L.map_subCategory_miniMap = "小地图"
L.map_whoPings = "显示谁在点击小地图"
L.map_whoPings_tooltip = "组队时显示谁在点击小地图。"
L.map_miniMapSize = "调整小地图大小"
L.map_miniMapSize_tooltip = "调整小地图大小。"
L.map_microMenu = "游戏菜单"
L.map_microMenu_tooltip = "鼠标右键点击小地图显示游戏菜单。"
L.map_expRepBar = "经验进度"
L.map_expRepBar_tooltip = "小地图上方添加一个进度条监控当前的经验/声望进度。"



L.tooltip = "鼠标提示"
L.tooltip_subText = "调整鼠标提示的外观和功能。"
L.tooltip_subCategory_basic = "基本设定"
L.tooltip_enable = "启用鼠标提示强化"
L.tooltip_enable_tooltip = "禁用该项如果你想使用其他鼠标提示类插件。"
L.tooltip_cursor = "跟随鼠标"
L.tooltip_cursor_tooltip = "鼠标提示的位置跟随鼠标，禁用则固定在屏幕右下角。"
L.tooltip_hideTitle = "隐藏头衔"
L.tooltip_hideTitle_tooltip = "隐藏头衔。"
L.tooltip_hideRealm = "隐藏服务器"
L.tooltip_hideRealm_tooltip = "隐藏服务器。"
L.tooltip_hideRank = "隐藏公会会阶"
L.tooltip_hideRank_tooltip = "隐藏公会会阶。"
L.tooltip_combatHide = "战斗中隐藏鼠标提示"
L.tooltip_combatHide_tooltip = "战斗中隐藏鼠标提示。"
L.tooltip_borderColor = "边框染色"
L.tooltip_borderColor_tooltip = "鼠标提示边框按照物品品质染色。"
L.tooltip_tipIcon = "物品图标"
L.tooltip_tipIcon_tooltip = "鼠标提示显示相应的物品图标。"
L.tooltip_linkHover = "装备链接"
L.tooltip_linkHover_tooltip = "鼠标悬停聊天栏的装备链接时显示鼠标提示。"
L.tooltip_extraInfo = "显示额外的信息"
L.tooltip_extraInfo_tooltip = "鼠标提示显示额外的信息比如技能/物品的id。"
L.tooltip_targetBy = "选中目标信息"
L.tooltip_targetBy_tooltip = "组队时显示敌方单位被多少队友选中。"



L.unitframe = "单位框体"
L.unitframe_subText = "这些选项控制大部分和单位框体相关的设置。"
L.unitframe_enable = "启用单位框体"
L.unitframe_enable_tooltip = "禁用该项如果你想要使用其他的单位框体类插件。"

L.unitframe_subCategory_basic = "基本设定"
L.unitframe_transMode = "透明风格"
L.unitframe_transMode_tooltip = "禁用该项如果你喜欢实色风格。"
L.unitframe_colourSmooth = "平滑染色"
L.unitframe_colourSmooth_tooltip = "玩家/目标/焦点的血量根据当前血量百分比染色。"
L.unitframe_portrait = "动态肖像"
L.unitframe_portrait_tooltip = "添加动态肖像。"
L.unitframe_healer = "治疗布局"
L.unitframe_healer_tooltip = "对治疗职业更友好的对称布局，小队/团队框体集中在屏幕中下部。"
L.unitframe_frameVisibility = "极简模式"
L.unitframe_frameVisibility_tooltip = "默认隐藏玩家头像框体，进入战斗或者选择目标后显示。"

L.unitframe_subCategory_feature = "额外功能"
L.unitframe_rangeCheck = "距离提示"
L.unitframe_rangeCheck_tooltip = "超出距离的框体淡化。"
L.unitframe_dispellable = "驱散提示"
L.unitframe_dispellable_tooltip = "如果小队/团队成员中了你可以驱散的减益效果，该成员的框体会高亮提示，高亮颜色取决于减益效果的类型。"
L.unitframe_comboPoints = "连击点"
L.unitframe_comboPoints_tooltip = "显示连击点(盗贼德鲁伊)。"
L.unitframe_energyTicker = "回能提示"
L.unitframe_energyTicker_tooltip = "显示能量回复的提示(盗贼德鲁伊)。"
L.unitframe_onlyShowPlayer = "减益光环过滤"
L.unitframe_onlyShowPlayer_tooltip = "只显示玩家施放的减益光环。"
L.unitframe_clickCast = "点击施法"
L.unitframe_clickCast_tooltip = "启用点击施法功能。\n点击技能面板右下的图标或者使用命令行 /freeui clickcast 可以打开点击施法绑定面板。"



L.unitframe_subCategory_castbar = "施法条相关"
L.unitframe_enableCastbar = "启用施法条"
L.unitframe_enableCastbar_tooltip = "禁用该项如果你想要使用其他的施法条类插件。"
L.unitframe_castbar_separatePlayer = "分离玩家施法条"
L.unitframe_castbar_separateTarget = "分离目标施法条"
L.unitframe_castbar_separatePlayer_tooltip = "显示单独分离的玩家施法条"
L.unitframe_castbar_separateTarget_tooltip = "显示单独分离的目标施法条"

L.unitframe_subCategory_extra = "其他框架"
L.unitframe_enableGroup = "启用小队/团队框架"
L.unitframe_enableGroup_tooltip = "禁用此项如果你想要使用其他小队/团队框架类插件。"
L.unitframe_groupNames = "显示名字"
L.unitframe_groupNames_tooltip = "在小队/团队框体上显示名字。"
L.unitframe_groupColourSmooth = "平滑染色"
L.unitframe_groupColourSmooth_tooltip = "小队/团队的血量根据当前血量百分比染色。"
L.unitframe_groupFilter = "显示队伍数量"



L.classmod = "职业特定"
L.classmodSubText = "设置加载职业特定的组件"

local classes = UnitSex("player") == 2 and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE

for class, localized in pairs(classes) do
	L["classmod"..strlower(class)] = localized
end

L.classmodhavocFury = "|cffffffff 恶魔猎手"
L.classmodhavocFuryTooltip = "根据浩劫怒气值改变怒气条颜色"



